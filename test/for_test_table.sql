create schema public;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE customer_contacts (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    number VARCHAR(5) NOT NULL
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    number VARCHAR(5) NOT NULL,
    price NUMERIC(12,2) NOT NULL
);

CREATE TABLE companies_btx (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    number VARCHAR(5) NOT NULL,
    inn CHAR(10) NOT NULL,
    kpp CHAR(9) NOT NULL
);

INSERT INTO users (first_name, last_name, email) VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com'),
('Анна', 'Петрова', 'anna.petrova@example.com'),
('Павел', 'Сидоров', 'pavel.sidorov@example.com'),
('Екатерина', 'Козлова', 'ekaterina.kozlova@example.com'),
('Алексей', 'Морозов', 'aleksey.morozov@example.com');

INSERT INTO customer_contacts (full_name, phone, email) VALUES
('Иванов Иван Иванович', '+7 (912) 345-67-89', 'ivan.ivanov@anonymized.local'),
('Петрова Анна Сергеевна', '+7 (903) 123-45-67', 'anna.petrova@anonymized.local'),
('Сидоров Павел Николаевич', '+7 (916) 789-01-23', 'pavel.sidorov@anonymized.local'),
('Козлова Екатерина Дмитриевна', '+7 (905) 456-78-90', 'ekaterina.kozlova@anonymized.local'),
('Морозов Алексей Владимирович', '+7 (909) 876-54-32', 'aleksey.morozov@anonymized.local');

INSERT INTO customers (name, number) VALUES
('ТехноПром', '12345'),
('АльфаСтрой', '67890'),
('БизнесЛидер', '11122'),
('РосИнвест', '33344'),
('ГлобалТрейд', '55566');

INSERT INTO projects (name, number, price) VALUES
('Разработка CRM системы', '00101', 1500000.00),
('Строительство офисного центра', '00102', 8500000.00),
('Модернизация серверной инфраструктуры', '00103', 4200000.00),
('Внедрение ERP-платформы', '00104', 9800000.00),
('Разработка мобильного приложения', '00105', 2800000.00);

INSERT INTO companies_btx (title, number, inn, kpp) VALUES
('ООО "ТехноПром"', '77711', '1234567890', '123456789'),
('ЗАО "АльфаСтрой"', '77722', '2345678901', '234567890'),
('ООО "БизнесЛидер"', '77733', '3456789012', '345678901'),
('АО "РосИнвест"', '77744', '4567890123', '456789012'),
('ООО "ГлобалТрейд"', '77755', '5678901234', '567890123');