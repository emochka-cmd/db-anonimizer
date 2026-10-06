import logging
import os
from typing import Any, Dict, List

from anonymizer.config import load_yaml_config
from anonymizer.db import DatabaseAnonymizer
from anonymizer.strategies.base import BaseAnonymizer
from .strategies.registry import StrategyRegistry

logger = logging.getLogger(__name__)


class AnonymizationPipeline:
    def __init__(self, config_path: str = "config/anonymization.yaml"):
        """
        Отвечает за анонимизацию строк.
        config_path - путь к конфигу анонимизации.
        """
        project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

        if not os.path.isabs(config_path):
            config_path = os.path.join(project_root, config_path)

        
        
        self.config_path = config_path
        self.config_dir = os.path.dirname(config_path)  # папка, где лежит конфиг (для словарей)
        self.config = load_yaml_config(config_path)
        
        settings = self.config.get("settings", {})
        self.batch_size = settings.get("batch_size") or 5000

        self._dictionaries: Dict[str, str] = settings.get("dictionaries", {})
        self.db = DatabaseAnonymizer()

        # Для детерминации
        self._strategy_cache = {}

    # --- Внутренние методы ---

    def _resolve_params(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """
        Подставляет пути к словарям вместо их символических имён.
        """
        resolved = params.copy()
        for key, value in resolved.items():
            if isinstance(value, str) and value in self._dictionaries:
                # Получаем относительный путь из словаря
                rel_path = self._dictionaries[value]
                # Делаем абсолютный путь относительно config_dir
                abs_path = os.path.join(self.config_dir, rel_path)
                resolved[key] = abs_path
        return resolved



    def _process_table(self, src_table: str, table_conf: Dict[str, Any]) -> None:
        """Анонимизирует одну таблицу и записывает результат."""
        dst_table = f"{src_table}_anonymized"

         # Логируем список колонок, которые будут анонимизированы
        columns_config = table_conf.get("columns", {})
        columns_to_anonymize = list(columns_config.keys())
        logger.info(
            "Таблица '%s': анонимизация колонок: %s",
            src_table,
            columns_to_anonymize if columns_to_anonymize else "нет"
        )

        # Пересоздаём целевую таблицу
        if self.db.table_exists(dst_table):
            self.db.execute(f'DROP TABLE "{dst_table}" CASCADE')
        self.db.create_table_like(src_table, dst_table)

        all_columns: List[str] = self.db.get_table_columns(src_table)
        total_processed = 0

        for batch in self.db.fetch_batch(src_table, all_columns, self.batch_size):
            anonymized_batch = [
                self._apply_strategy_to_row(row, table_conf) for row in batch
            ]
            self.db.insert_rows(dst_table, anonymized_batch)
            total_processed += len(anonymized_batch)
            logger.info("Таблица %s: обработано %d строк.", src_table, total_processed)

        logger.info(
            "Таблица '%s' полностью анонимизирована → '%s' (%d строк).",
            src_table,
            dst_table,
            total_processed,
        )

    def _get_strategy(self, algorithm: str, params: Dict[str, Any]) -> BaseAnonymizer:
        resolved_params = self._resolve_params(params)
        key = (algorithm, frozenset(resolved_params.items()))
        if key not in self._strategy_cache:
            strategy_class = StrategyRegistry.get(algorithm)
            self._strategy_cache[key] = strategy_class(params=resolved_params)
        return self._strategy_cache[key]

    def _apply_strategy_to_row(
        self, row: Dict[str, Any], table_config: Dict[str, Any]
    ) -> Dict[str, Any]:
        new_row = row.copy()
        columns_config = table_config.get("columns", {})
        for column, strategy_cfg in columns_config.items():
            if column not in row:
                continue
            algorithm = strategy_cfg.get("algorithm")
            if not algorithm:
                continue
            raw_params = strategy_cfg.get("params", {})
            strategy = self._get_strategy(algorithm, raw_params)
            original_value = row[column]
            try:
                new_row[column] = strategy.anonymize(original_value, row)
            except Exception:
                logger.exception("Ошибка анонимизации колонки '%s'", column)
        return new_row

    # --- Публичный интерфейс ---

    def run(self) -> None:
        """Анонимизирует все таблицы, перечисленные в конфиге."""
        tables_dict: Dict[str, Any] = self.config.get("tables", {})
        if not tables_dict:
            logger.warning("В конфиге не задано ни одной таблицы для анонимизации.")
            return

        logger.info("Начало анонимизации %d таблиц(ы)", len(tables_dict))
        for src_table, table_conf in tables_dict.items():
            try:
                self._process_table(src_table, table_conf)
            except Exception:
                logger.exception("Ошибка при обработке таблицы '%s'.", src_table)
                raise
        logger.info("Анонимизация всех таблиц завершена.")
