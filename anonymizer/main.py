"""
Точка входа для анонимизации базы данных PostgreSQL.
Поддерживает:
  - загрузку дампов из S3
  - восстановление БД из SQL-файлов
  - анонимизацию таблиц согласно YAML-конфигурации
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import argparse
import datetime
import logging

from anonymizer.db import DatabaseAnonymizer
from anonymizer.pipeline import AnonymizationPipeline
from anonymizer.s3 import S3

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
logger = logging.getLogger("main")

timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Анонимизация продуктивной БД PostgreSQL с возможностью загрузки дампов из S3"
    )
    parser.add_argument(
        "-c",
        "--config",
        default="config/anonymization.yaml",
        help="Путь к YAML-конфигурации анонимизации (по умолчанию: config/anonymization.yaml)",
    )
    parser.add_argument(
        "--dump", action="store_true", help="Создать дамп анонимизированной БД"
    )
    parser.add_argument(
        "-u", "--upload", action="store_true", help="Загрузить дамп в целевой S3-бакет"
    )
    parser.add_argument(
        "--dump-name", default="anonymized_backup.sql", help="Имя файла дампа"
    )
    parser.add_argument(
        "-d",
        "--download",
        action="store_true",
        help="Скачать дампы из S3 перед восстановлением БД",
    )
    parser.add_argument(
        "-r",
        "--restore",
        action="store_true",
        help="Восстановить БД из SQL-файлов в папке temp/ (по умолчанию используется, если указан --download или явно задан)",
    )
    parser.add_argument(
        "-a",
        "--anonymize",
        action="store_true",
        help="Запустить процесс анонимизации таблиц",
    )
    parser.add_argument(
        "--s3-source",
        default="source",
        help="Имя исходного бакета в S3 (по умолчанию: source)",
    )
    parser.add_argument(
        "--s3-target",
        default="target",
        help="Имя целевого бакета в S3 (пока не используется, зарезервировано)",
    )
    parser.add_argument(
        "--restore-folder",
        default="temp/",
        help="Путь к папке с SQL-дампами для восстановления (по умолчанию: temp/)",
    )
    parser.add_argument(
        "--no-restore-on-download",
        action="store_true",
        help="Не восстанавливать БД автоматически после скачивания дампов",
    )
    return parser.parse_args()


def download_dumps(s3_source: str, s3_target: str, restore_folder: str) -> None:
    """Скачивает все .sql файлы из source-бакета S3 в локальную папку."""
    logger.info("Подключение к S3 и скачивание дампов...")
    s3 = S3(source_bn=s3_source, target_bn=s3_target, save_path=restore_folder)
    keys = s3.list_by_suffix(".sql")
    if not keys:
        logger.warning("В бакете '%s' не найдено файлов с суффиксом .sql", s3_source)
        return
    logger.info("Найдено %d файлов. Начинаем скачивание...", len(keys))
    for key in keys:
        s3.download_file(key)
    logger.info("Скачивание завершено.")


def restore_database(restore_folder: str) -> None:
    """Восстанавливает БД из SQL-файлов в указанной папке."""
    logger.info("Восстановление базы данных из файлов в '%s'...", restore_folder)
    with DatabaseAnonymizer() as db:
        db.restore_from_sql_file(folder_path=restore_folder, target_ext=".sql")
    logger.info("Восстановление БД завершено.")


def run_anonymization(config_path: str) -> None:
    """Запускает пайплайн анонимизации."""
    logger.info("Запуск анонимизации с конфигом: %s", config_path)
    pipeline = AnonymizationPipeline(config_path=config_path)
    pipeline.run()
    logger.info("Анонимизация успешно завершена.")


def main() -> None:
    args = parse_args()

    if not (args.download or args.restore or args.anonymize or args.dump or args.upload):
        logger.error(
            "Не указано действие: хотя бы один из флагов --download, --restore, --anonymize"
        )
        sys.exit(1)

    # 1. Скачивание дампов
    if args.download:
        download_dumps(args.s3_source, args.s3_target, args.restore_folder)
        # Автоматически восстанавливаем БД после скачивания, если не запрещено
        if not args.no_restore_on_download:
            restore_database(args.restore_folder)
    # 2. Восстановление из уже существующих файлов (без скачивания)
    elif args.restore:
        restore_database(args.restore_folder)

    # 3. Анонимизация
    if args.anonymize:
        run_anonymization(args.config)

    if args.dump:
        with DatabaseAnonymizer() as db:
            db.dump_anonymized_db(args.dump_name)
    if args.upload:
        s3 = S3(args.s3_source, args.s3_target, args.restore_folder)
        s3.upload_file(args.dump_name, key=f"anonymized_{timestamp}.sql")


if __name__ == "__main__":
    main()
