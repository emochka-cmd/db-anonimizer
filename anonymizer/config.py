# anonymizer/config.py
import logging
from typing import Any, Dict

import yaml

logger = logging.getLogger(__name__)


def load_yaml_config(config_path: str) -> Dict[str, Any]:
    """
    Загружает YAML-конфиг и возвращает его содержимое.

    Raises:
        FileNotFoundError: если файл не найден.
        ValueError: если содержимое невалидно или не является словарём.
    """
    try:
        with open(config_path, "r", encoding="utf-8") as yaml_file:
            data = yaml.safe_load(yaml_file)
    except FileNotFoundError:
        raise FileNotFoundError(f"Файл конфигурации не найден: {config_path}")
    except yaml.YAMLError as exc:
        raise ValueError(
            f"Ошибка парсинга YAML в файле '{config_path}': {exc}"
        ) from exc

    if not isinstance(data, dict):
        raise ValueError(
            f"Конфиг '{config_path}' должен содержать YAML-словарь, "
            f"получено: {type(data).__name__}"
        )

    return data
