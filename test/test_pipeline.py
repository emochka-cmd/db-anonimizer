# test_pipeline.py

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


from dotenv import load_dotenv

from anonymizer.db import DatabaseAnonymizer
from anonymizer.pipeline import AnonymizationPipeline

load_dotenv()


def setup_test_data(db: DatabaseAnonymizer):
    """Создаёт тестовую таблицу users и наполняет её данными."""
    print("Создание тестовой таблицы users...")
    db.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            first_name TEXT,
            last_name TEXT,
            email TEXT
        )
    """)
    db.execute("TRUNCATE users RESTART IDENTITY")
    db.execute("""
        INSERT INTO users (first_name, last_name, email)
        VALUES
            ('Иван', 'Иванов', 'ivan@example.com'),
            ('Петр', 'Петров', 'petr@example.com'),
            ('Сидор', 'Сидоров', 'sidor@example.com')
    """)
    print("Тестовые данные добавлены.")


def verify_anonymization(db: DatabaseAnonymizer):
    """Проверяет, что анонимизированная таблица существует и данные изменены."""
    print("\nПроверка результатов анонимизации...")
    if not db.table_exists("users_anonymized"):
        print("❌ Таблица users_anonymized не найдена!")
        return False

    original = db.fetch_all(
        "SELECT first_name, last_name, email FROM users ORDER BY id"
    )
    anonymized = db.fetch_all(
        "SELECT first_name, last_name, email FROM users_anonymized ORDER BY id"
    )

    print("Оригинальные строки:")
    for row in original:
        print(f"  {row}")

    print("Анонимизированные строки:")
    for row in anonymized:
        print(f"  {row}")

    # Проверяем, что хотя бы одно имя изменилось
    changed = any(
        orig["first_name"] != anon["first_name"]
        or orig["last_name"] != anon["last_name"]
        or orig["email"] != anon["email"]
        for orig, anon in zip(original, anonymized)
    )
    if changed:
        print("✅ Анонимизация сработала: данные изменены.")
    else:
        print("⚠️ Внимание: анонимизированные данные совпадают с оригиналом.")
    return changed


def main():
    db = DatabaseAnonymizer()

    try:
        # 1. Подготовка тестовых данных
        #setup_test_data(db)

        # 2. Запуск пайплайна (конфиг должен лежать по пути config/anonymization.yaml)
        pipeline = AnonymizationPipeline("config/anonymization.yaml")
        pipeline.run()

        # 3. Верификация
        success = verify_anonymization(db)

        # 4. Очистка (опционально)
        db.execute("DROP TABLE users CASCADE")
        db.execute("DROP TABLE users_anonymized CASCADE")

        sys.exit(0 if success else 1)

    except Exception as e:
        print(f"Ошибка во время выполнения теста: {e}")
        sys.exit(1)
    finally:
        db.close()


if __name__ == "__main__":
    main()
