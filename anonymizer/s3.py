"""
s3.py
Работа с s3:
- подключение к s3. информация для подключения берется из .env
- получение информации о файлах на бакете
- скачивание из бакета
- загрузка в бакетах
"""


import logging
import os
from typing import List

import boto3
from botocore.exceptions import ClientError
from dotenv import load_dotenv

logger = logging.getLogger(__name__)

load_dotenv()


class S3:
    def __init__(self, source_bn: str, target_bn: str, save_path: str = "temp") -> None:
        """
        Информация для подключения (endpoint_url, aws_access_key_id, aws_secret_access_key) берется из .env файла.
        source_bn - имя исходного бакета
        target_bn - имя целевого бакета
        save_path - путь для сохранения
        """
        # Подключение к бд
        self._endpoint_url = os.getenv("ENDPOINT_URL")
        self._access_key = os.getenv("MINIO_ROOT_USER")
        self._secret_key = os.getenv("MINIO_ROOT_PASSWORD")
        self._client = None

        # Бакеты
        self._source_bn = source_bn
        self._target_bn = target_bn

        # Путь для сохранения. Нормализуем путь и создаём директорию
        self._save_path = os.path.abspath(os.path.join(save_path, ""))
        os.makedirs(self._save_path, exist_ok=True)

        self._s3_connect()

    def _s3_connect(self) -> None:
        """Подключение к s3"""
        self._client = boto3.client(
            "s3",
            endpoint_url=self._endpoint_url,
            aws_access_key_id=self._access_key,
            aws_secret_access_key=self._secret_key,
        )
        logger.info(f"Подключен к s3 хранилищу {self._endpoint_url}")

    # --- Методы для фильтрации ---
    def _list_all_keys(self, bucket: str, prefix: str = "") -> List[str]:
        """
        Вспомогательный метод – возвращает все ключи в бакете с заданным префиксом.
        Использует пагинацию для больших бакетов.
        """
        keys = []
        paginator = self._client.get_paginator("list_objects_v2")
        for page in paginator.paginate(Bucket=bucket, Prefix=prefix):
            if "Contents" in page:
                for obj in page["Contents"]:
                    keys.append(obj["Key"])
        return keys

    def list_by_prefix(self, prefix: str) -> List[str]:
        """Фильтрация по префиксу."""
        return self._list_all_keys(self._source_bn, prefix=prefix)

    def list_by_suffix(self, suffix: str, prefix: str = "") -> List[str]:
        """
        Филитрация по cуфиксу(например - .sql).
        Сначала получаем все ключи с расширением (или без), затем фильтруем в Python.
        """
        all_keys = self._list_all_keys(self._source_bn, prefix=prefix)
        return [key for key in all_keys if key.endswith(suffix)]

    # --- Работа с файлами ---
    def download_file(self, key: str) -> None:
        """Скачивает файл из source_bn в локальную директорию."""
        filepath = os.path.join(self._save_path, os.path.basename(key))
        try:
            self._client.download_file(self._source_bn, key, filepath)
            logger.info("Скачан: %s -> %s", key, filepath)
        except ClientError as e:
            logger.error("Ошибка скачивания '%s': %s", key, e)
            raise

    def upload_file(self, local_path: str, key: str = None) -> None:
        """Загружает локальный файл в target_bn."""
        if key is None:
            key = os.path.basename(local_path)
        try:
            self._client.upload_file(local_path, self._target_bn, key)
            logger.info("Загружен: %s -> s3://%s/%s", local_path, self._target_bn, key)
        except ClientError as e:
            logger.error("Ошибка загрузки '%s': %s", local_path, e)
            raise
