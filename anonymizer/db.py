"""
db.py
Работа с PostgreSQL:
- восстановление БД из SQL-файлов через psql (docker exec)
- пакетное чтение данных для анонимизации (серверный курсор)
- массовая вставка анонимизированных данных
"""

import logging
import os
import subprocess
from typing import Any, Dict, Generator, List, Optional

import psycopg2
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor, execute_values

load_dotenv()

logger = logging.getLogger(__name__)

# Максимальная длина имени идентификатора в PostgreSQL
_PG_MAX_IDENTIFIER = 63


class DatabaseAnonymizer:
    """
    Класс для работы с PostgreSQL.

    Использует ДВА соединения:
    - _read_conn  — для серверных курсоров (SELECT).
    - _write_conn — для DDL и INSERT (с явными коммитами).
    """

    def __init__(
        self,
        container_name: Optional[str] = None,
        db_user: Optional[str] = None,
        db_name: Optional[str] = None,
    ) -> None:
        self._container_name = container_name or os.getenv("POSTGRES_CONTAINER_NAME")
        self._db_user = db_user or os.getenv("POSTGRES_USER")
        self._db_name = db_name or os.getenv("POSTGRES_DB")
        self._db_password = os.getenv("POSTGRES_PASSWORD")
        self._db_host = os.getenv("POSTGRES_HOST", "localhost")
        self._db_port = os.getenv("POSTGRES_PORT", "5432")

        self._read_conn: Optional[psycopg2.extensions.connection] = None
        self._write_conn: Optional[psycopg2.extensions.connection] = None

        # Поднимаем оба соединения сразу, чтобы ошибка конфигурации выявлялась при инициализации.
        self._get_read_conn()
        self._get_write_conn()

    def _connect(self) -> psycopg2.extensions.connection:
        return psycopg2.connect(
            host=self._db_host,
            port=self._db_port,
            user=self._db_user,
            password=self._db_password,
            database=self._db_name,
        )

    def _get_read_conn(self) -> psycopg2.extensions.connection:
        """
        Соединение для чтения.
        """
        if self._read_conn is None or self._read_conn.closed != 0:
            self._read_conn = self._connect()
            self._read_conn.autocommit = False
        return self._read_conn

    def _get_write_conn(self) -> psycopg2.extensions.connection:
        """Соединение для DDL и DML с явными коммитами."""
        if self._write_conn is None or self._write_conn.closed != 0:
            self._write_conn = self._connect()
            self._write_conn.autocommit = False
        return self._write_conn

    def close(self) -> None:
        """Закрывает оба соединения."""
        for conn_attr in ("_read_conn", "_write_conn"):
            conn = getattr(self, conn_attr)
            if conn is not None and conn.closed == 0:
                conn.close()
                setattr(self, conn_attr, None)

    def __enter__(self) -> "DatabaseAnonymizer":
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        self.close()

    # DDL / утилиты

    def execute(self, sql: str, params: tuple = ()) -> None:
        """Выполняет произвольный SQL через write-соединение."""
        conn = self._get_write_conn()
        with conn.cursor() as cur:
            cur.execute(sql, params)
            conn.commit()

    def table_exists(self, table_name: str, schema: str = "public") -> bool:
        """
        Проверяет существование таблицы в заданной схеме.
        """
        sql = """
            SELECT EXISTS (
                SELECT 1
                FROM information_schema.tables
                WHERE table_schema = %s
                  AND table_name   = %s
            )
        """
        conn = self._get_write_conn()
        with conn.cursor() as cur:
            cur.execute(sql, (schema, table_name))
            return cur.fetchone()[0]

    def get_table_columns(self, table_name: str, schema: str = "public") -> List[str]:
        """
        Возвращает имена колонок таблицы в порядке их объявления.
        """
        sql = """
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = %s
              AND table_name   = %s
            ORDER BY ordinal_position
        """
        conn = self._get_write_conn()
        with conn.cursor() as cur:
            cur.execute(sql, (schema, table_name))
            return [row[0] for row in cur.fetchall()]

    def create_table_like(
        self,
        source_table: str,
        target_table: str,
    ) -> None:
        """
        Создаёт целевую таблицу по структуре исходной.
        """
        sql = (
            f'CREATE TABLE "{target_table}" (LIKE "{source_table}" INCLUDING DEFAULTS)'
        )
        self.execute(sql)
        logger.debug(
            "Создана таблица '%s' по образцу '%s'.", target_table, source_table
        )

    # --- Чтение ---

    def fetch_batch(
        self,
        table_name: str,
        columns: List[str],
        batch_size: int = 1000,
        where_clause: str = "",
    ) -> Generator[List[Dict[str, Any]], None, None]:
        """
        Читает таблицу пачками через серверный курсор, не загружая всё в память.
        """
        conn = self._get_read_conn()

        raw_name = f"anon_read_{table_name}"
        cursor_name = raw_name[:_PG_MAX_IDENTIFIER]

        col_str = ", ".join(f'"{c}"' for c in columns)
        sql = f'SELECT {col_str} FROM "{table_name}"'
        if where_clause:
            sql += f" WHERE {where_clause}"

        cur = conn.cursor(name=cursor_name, cursor_factory=RealDictCursor)
        try:
            cur.execute(sql)
            while True:
                rows = cur.fetchmany(batch_size)
                if not rows:
                    break
                yield [dict(row) for row in rows]
        finally:
            cur.close()
            conn.rollback()

    def fetch_all(self, sql: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """Выполняет произвольный SELECT и возвращает все строки. Для тестов."""
        conn = self._get_write_conn()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, params)
            return [dict(row) for row in cur.fetchall()]

    # --- Запись ---

    def insert_rows(self, table_name: str, rows: List[Dict[str, Any]]) -> None:
        """
        Массовая вставка строк через psycopg2.extras.execute_values.
        """
        if not rows:
            return

        columns = list(rows[0].keys())
        col_names = ", ".join(f'"{c}"' for c in columns)
        sql = f'INSERT INTO "{table_name}" ({col_names}) VALUES %s'

        # Преобразуем список dict в список tuple, сохраняя порядок колонок
        data = [tuple(row[c] for c in columns) for row in rows]

        conn = self._get_write_conn()
        with conn.cursor() as cur:
            execute_values(cur, sql, data, page_size=len(data))
        conn.commit()

    # --- Восстановление БД из SQL-файлов (docker exec psql) ---

    def restore_from_sql_file(
        self,
        folder_path: str = "temp/",
        target_ext: str = ".sql",
    ) -> None:
        """
        Восстанавливает БД из всех файлов с нужным расширением
        в указанной папке (в алфавитном порядке).
        """
        if not os.path.isdir(folder_path):
            raise FileNotFoundError(f"Папка не найдена: {folder_path}")

        files = sorted(f for f in os.listdir(folder_path) if f.endswith(target_ext))

        if not files:
            logger.warning("Нет файлов '*%s' в папке '%s'.", target_ext, folder_path)
            return

        logger.info("Найдено файлов для восстановления: %d", len(files))
        for file_name in files:
            full_path = os.path.join(folder_path, file_name)
            logger.info("Восстановление из '%s'...", file_name)
            self._execute_psql_file(full_path)

        logger.info("Восстановление БД завершено.")

    def _get_psql_env(self) -> Dict[str, str]:
        """Возвращает переменные окружения для psql/pg_dump."""
        return {
            "PGHOST": self._db_host,
            "PGPORT": str(self._db_port),
            "PGUSER": self._db_user,
            "PGPASSWORD": self._db_password,
            "PGDATABASE": self._db_name,
        }

    def _container_exists(self) -> bool:
        """Проверяет, существует ли Docker-контейнер с заданным именем."""
        if not self._container_name:
            return False
        result = subprocess.run(
            ["docker", "ps", "-q", "-f", f"name={self._container_name}"],
            capture_output=True,
            text=True,
        )
        return bool(result.stdout.strip())

    def _execute_psql_file(self, file_path: str) -> None:
        """
        Выполняет SQL-файл через psql внутри Docker-контейнера.
        Либо напяму через psql
        """
        if not os.path.isfile(file_path):
            raise FileNotFoundError(f"Файл не найден: {file_path}")

        use_docker = self._container_name and self._container_exists()
        if use_docker:
            cmd = [
                "docker",
                "exec",
                "-i",
                self._container_name,
                "psql",
                "-U",
                self._db_user,
                "-d",
                self._db_name,
            ]
            env = None
        else:
            # Прямой вызов psql (для CI/CD)
            cmd = ["psql", "-v", "ON_ERROR_STOP=1", "--no-psqlrc"]
            env = self._get_psql_env()

        try:
            with open(file_path, "r", encoding="utf-8") as sql_file:
                result = subprocess.run(
                    cmd,
                    stdin=sql_file,
                    env=env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                    timeout=3600,  # 1 час — защита от зависания
                )

            if result.returncode != 0:
                stderr_lower = result.stderr.lower()
                # Игнорируем ошибки "already exists" для отношений, таблиц, схем
                if "already exists" in stderr_lower and any(
                    keyword in stderr_lower
                    for keyword in ("relation", "table", "schema")
                ):
                    logger.warning(
                        "Игнорируем ошибку 'already exists' в файле %s: %s",
                        os.path.basename(file_path),
                        result.stderr.strip(),
                    )
                    return

                raise RuntimeError(
                    f"psql завершился с кодом {result.returncode} "
                    f"при выполнении '{file_path}':\n{result.stderr}"
                )

            logger.info("Успешно выполнен: %s", os.path.basename(file_path))
        except subprocess.TimeoutExpired:
            raise RuntimeError(f"Таймаут при выполнении '{file_path}'.")

    def dump_anonymized_db(self, output_file: str, tables: List[str] = None) -> None:
        """Создаёт SQL-дамп анонимизированных таблиц (или всей БД) через pg_dump."""

        # Формируем список таблиц для дампа (по умолчанию все *anonymized)
        if not tables:
            # Можно найти все таблицы с суффиксом _anonymized
            with self._get_read_conn().cursor() as cur:
                cur.execute("""
                    SELECT tablename FROM pg_tables 
                    WHERE schemaname='public' AND tablename LIKE '%_anonymized'
                """)
                tables = [row[0] for row in cur.fetchall()]

        table_args = " ".join(f"-t {t}" for t in tables)

        use_docker = self._container_name and self._container_exists()

        env = None

        if use_docker:
            cmd = [
                "docker",
                "exec",
                self._container_name,
                "pg_dump",
                "-U",
                self._db_user,
                "-d",
                self._db_name,
                "--no-owner",
                "--no-privileges",
                "--inserts",
                *table_args.split(),
            ]
        else:
            cmd = ["pg_dump", "--no-owner", "--no-privileges", "--inserts"]
            cmd.extend(table_args.split())
            env = self._get_psql_env()
        with open(output_file, "w") as f:
            subprocess.run(cmd, env=env, stdout=f, stderr=subprocess.PIPE, check=True)
        logger.info("Дамп создан: %s", output_file)
