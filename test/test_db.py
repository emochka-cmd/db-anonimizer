# костыль для текстов
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


from anonymizer.db import DatabaseAnonymizer
from dotenv import load_dotenv

load_dotenv()

if __name__ == "__main__":
    try:
        db = DatabaseAnonymizer()
        db.execute("SELECT 1")
        print("✅ База данных доступна")
    except Exception as e:
        print(f"❌ Ошибка подключения: {e}")
        exit()

    # Создаём тестовую таблицу (если её нет)
    db.execute("CREATE TABLE IF NOT EXISTS test (id int, name text)")
    print("Таблица создана")

    # Вставляем данные
    db.execute("INSERT INTO test VALUES (1, 'Alice'), (2, 'Bob'), (100, 'Lioi'), (12231, 'lss')")
    print("Данные вставлены")

    # Читаем данные
    rows = db.fetch_all("SELECT * FROM test")
    print("Результат SELECT:", rows)

    # Проверяем пакетное чтение
    print("\nПроверка fetch_batch:")
    for batch in db.fetch_batch("test", ["id", "name"], batch_size=1):
        print("batch:", batch, '\n')
    
    db.close()