--
-- PostgreSQL database dump
--

\restrict rdNMMjRCYoHi4U816thN9jD5wQJsDvhPQQj7gxf4w28fOWIlgXBP9MXyPIyZL1w

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.3 (Debian 18.3-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies_btx_anonymized; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies_btx_anonymized (
    id character varying CONSTRAINT companies_btx_id_not_null NOT NULL,
    title character varying CONSTRAINT companies_btx_title_not_null NOT NULL,
    created_at timestamp without time zone CONSTRAINT companies_btx_created_at_not_null NOT NULL,
    modified_at timestamp without time zone CONSTRAINT companies_btx_modified_at_not_null NOT NULL,
    erp_contractor_ref_key character varying,
    erp_partner_ref_key character varying,
    number character varying,
    inn character varying,
    kpp character varying
);


--
-- Name: customer_contacts_anonymized; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_contacts_anonymized (
    id character varying DEFAULT gen_random_uuid() CONSTRAINT customer_contacts_id_not_null NOT NULL,
    project_id character varying CONSTRAINT customer_contacts_project_id_not_null NOT NULL,
    role public.customer_contact_role CONSTRAINT customer_contacts_role_not_null NOT NULL,
    full_name character varying,
    phone character varying,
    email character varying
);


--
-- Name: customers_anonymized; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers_anonymized (
    id character varying DEFAULT gen_random_uuid() CONSTRAINT customers_id_not_null NOT NULL,
    name character varying CONSTRAINT customers_name_not_null NOT NULL,
    number character varying,
    no_sync boolean DEFAULT true CONSTRAINT customers_no_sync_not_null NOT NULL,
    company_btx_id character varying
);


--
-- Name: projects_anonymized; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_anonymized (
    id character varying DEFAULT gen_random_uuid() CONSTRAINT projects_id_not_null NOT NULL,
    name character varying CONSTRAINT projects_name_not_null NOT NULL,
    customer_id character varying CONSTRAINT projects_customer_id_not_null NOT NULL,
    country character varying,
    currency character varying DEFAULT 'RUB'::character varying CONSTRAINT projects_currency_not_null NOT NULL,
    status public.projectstatuses DEFAULT 'SELLING'::public.projectstatuses CONSTRAINT projects_status_not_null NOT NULL,
    poc numeric,
    important boolean,
    project_manager_id character varying,
    end_customer_id character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    price numeric,
    number character varying CONSTRAINT projects_number_not_null NOT NULL,
    is_paused boolean CONSTRAINT projects_is_paused_not_null NOT NULL,
    deal_btx_id character varying,
    chief_engineer_id character varying,
    deal_type_id character varying,
    industry_id character varying,
    no_sync boolean DEFAULT true CONSTRAINT projects_no_sync_not_null NOT NULL,
    is_reported_job_requires_contract_position boolean DEFAULT true CONSTRAINT projects_is_reported_job_requires_contract_position_not_null NOT NULL,
    type public.projecttype DEFAULT 'EXTERNAL'::public.projecttype CONSTRAINT projects_type_not_null NOT NULL
);


--
-- Name: users_anonymized; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_anonymized (
    id character varying DEFAULT gen_random_uuid() CONSTRAINT users_id_not_null NOT NULL,
    email character varying CONSTRAINT users_email_not_null NOT NULL,
    hashed_password character varying CONSTRAINT users_hashed_password_not_null NOT NULL,
    first_name character varying CONSTRAINT users_first_name_not_null NOT NULL,
    last_name character varying CONSTRAINT users_last_name_not_null NOT NULL,
    language character varying DEFAULT 'ru'::character varying CONSTRAINT users_language_not_null NOT NULL,
    is_deleted boolean DEFAULT false CONSTRAINT users_is_deleted_not_null NOT NULL,
    is_terminated boolean DEFAULT false CONSTRAINT users_is_terminated_not_null NOT NULL,
    terminated_at timestamp without time zone,
    no_sync boolean DEFAULT true CONSTRAINT users_no_sync_not_null NOT NULL,
    is_banned boolean DEFAULT false CONSTRAINT users_is_banned_not_null NOT NULL
);


--
-- Data for Name: companies_btx_anonymized; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.companies_btx_anonymized VALUES ('1986', 'Реконструкция Инновация', '2025-03-31 14:15:53', '2025-03-31 14:15:53', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('5', 'СофтИнтеграция Пожар Тепло', '2025-10-09 15:10:04', '2025-10-09 15:10:04', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('1984', 'Эко Реконструкция Чип', '2025-03-31 14:13:40', '2025-03-31 14:13:40', '33a62bae-c08a-11f0-9331-74563c3cb7fb', '337b8714-c08a-11f0-9331-74563c3cb7fb', NULL, NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('1985', 'СтройИнвест Консалтинг Интеграция', '2025-03-31 14:14:53', '2025-03-31 14:14:53', '33a62a64-c08a-11f0-9331-74563c3cb7fb', '337d4676-c08a-11f0-9331-74563c3cb7fb', NULL, NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('1987', 'Мастер Софт', '2025-03-31 14:17:01', '2025-03-31 14:17:02', '33a62b36-c08a-11f0-9331-74563c3cb7fb', '337a7586-c08a-11f0-9331-74563c3cb7fb', NULL, NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('1', 'Лаборатория', '2025-10-09 15:01:23', '2025-10-09 15:03:20', '33a62ba4-c08a-11f0-9331-74563c3cb7fb', '337d3a00-c08a-11f0-9331-74563c3cb7fb', '63571', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('10', 'КапиталСтрой Высотка', '2025-11-13 15:51:03', '2025-11-13 15:51:03', '68e10432-c090-11f0-9331-74563c3cb7fb', '68a6addc-c090-11f0-9331-74563c3cb7fb', '80805', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('11', 'ТеплоЭнерго Капитал', '2025-11-13 15:52:08', '2025-11-13 15:52:08', '68e0faf0-c090-11f0-9331-74563c3cb7fb', '68a80fec-c090-11f0-9331-74563c3cb7fb', '81049', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('2', 'ТехноКонсалт', '2025-10-09 15:04:37', '2025-10-09 15:04:37', '33a62eec-c08a-11f0-9331-74563c3cb7fb', '337d4964-c08a-11f0-9331-74563c3cb7fb', '68399', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('3', 'Станция', '2025-10-09 15:06:05', '2025-10-09 15:06:05', 'a073274e-bb1e-11f0-82c9-74563c3cb7fb', '9fc74c12-bb1e-11f0-82c9-74563c3cb7fb', '50327', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('4', 'Комплекс Хард', '2025-10-09 15:08:57', '2025-10-09 15:30:32', 'a070fbc2-bb1e-11f0-82c9-74563c3cb7fb', '9fc8cace-bb1e-11f0-82c9-74563c3cb7fb', '78058', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('6', 'Инжиниринг', '2025-11-01 16:26:02', '2025-11-01 16:26:02', 'a073deaa-bb1e-11f0-82c9-74563c3cb7fb', '9fc899fa-bb1e-11f0-82c9-74563c3cb7fb', '98800', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('7', 'Туризм', '2025-11-13 14:07:45', '2025-11-13 14:07:45', '7f135518-c089-11f0-9331-74563c3cb7fb', '7e7ee216-c089-11f0-9331-74563c3cb7fb', '98982', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('8', 'Модернизация', '2025-11-13 14:08:57', '2025-11-13 14:08:57', 'e6b5dfea-c08b-11f0-9331-74563c3cb7fb', 'e6a02d9e-c08b-11f0-9331-74563c3cb7fb', '61912', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('9', 'МонолитСтрой Факторинг', '2025-11-13 14:10:32', '2025-11-13 14:10:32', '7f1fa16a-c089-11f0-9331-74563c3cb7fb', '7e8036de-c089-11f0-9331-74563c3cb7fb', '75432', NULL, NULL);
INSERT INTO public.companies_btx_anonymized VALUES ('12', 'Леспром Двигатель', '2025-11-17 13:48:08', '2025-11-21 16:29:24', '8686d6f6-194b-11f1-9e80-74563c3cb7fb', '856bcbfa-194b-11f1-9e80-74563c3cb7fb', '95964', '8876734527', '528191027');


--
-- Data for Name: customer_contacts_anonymized; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.customer_contacts_anonymized VALUES ('032bdce0-3aa1-4e5c-a99f-b4909d874fa2', '145e0f16-10a1-429f-b434-8951d4f2b092', 'CHIEF_ENGINEER', 'Иван Иванович Новиков', NULL, NULL);
INSERT INTO public.customer_contacts_anonymized VALUES ('938d143b-257e-4479-a7b2-9f02e54b0857', 'bf62f91c-2451-4f47-a0d2-32d4e81460f9', 'PROJECT_MANAGER', 'Прохор Прохорович Горшков', '+7 (473) 525 73 71', NULL);


--
-- Data for Name: customers_anonymized; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.customers_anonymized VALUES ('f0031546-e96a-4bce-b4bb-9f9cabf98f41', 'Безопасность ЭнергоИнвест Редуктор', NULL, true, NULL);
INSERT INTO public.customers_anonymized VALUES ('6ccfe453-1a7e-4662-b01d-f7c66989abf9', 'Холдинг АтомЭнерго Роботизация', NULL, true, NULL);
INSERT INTO public.customers_anonymized VALUES ('0db3c566-ec34-4402-a6cc-2119562434a9', 'Контроль Кабель', NULL, true, NULL);
INSERT INTO public.customers_anonymized VALUES ('d3de6d4a-aee2-48a4-9f88-a2c82227cbff', 'ПромСтрой Гарант', NULL, true, NULL);
INSERT INTO public.customers_anonymized VALUES ('889a0a83-fae8-43f8-90ae-7c39ad11a3ef', 'НасосПром Инвест', NULL, true, NULL);
INSERT INTO public.customers_anonymized VALUES ('f7807b95-1d67-4a99-b868-5422974895f1', 'Лаборатория', '63571', false, '1');
INSERT INTO public.customers_anonymized VALUES ('0b4c1087-094e-4107-89e6-67de48aa01fd', 'ТеплоЭнерго Капитал', '81049', true, '11');
INSERT INTO public.customers_anonymized VALUES ('16b51809-7f1f-48b5-ad88-d3014a835201', 'Мастер Софт', '68541', true, '1987');
INSERT INTO public.customers_anonymized VALUES ('55f82744-3779-4c9d-9af5-2ab7becbb256', 'КапиталСтрой Высотка', '80805', true, '10');
INSERT INTO public.customers_anonymized VALUES ('66ca648c-2e52-4a85-a698-a0a2ea89508d', 'Леспром Двигатель', '95964', true, '12');
INSERT INTO public.customers_anonymized VALUES ('775608b3-b8fd-4fb4-9e86-28d2b0f9fc92', 'Эко Реконструкция Чип', '07120', true, '1984');
INSERT INTO public.customers_anonymized VALUES ('a485473a-e26c-44b9-b5cd-a91def86793d', 'МонолитСтрой Факторинг', '75432', true, '9');
INSERT INTO public.customers_anonymized VALUES ('ae1b3e7b-578e-4f04-848a-ec68f663b3af', 'Реконструкция Инновация', '07348', true, '1986');
INSERT INTO public.customers_anonymized VALUES ('cf59dd3a-2f18-4359-bb16-18b18655cfa8', 'Туризм', '98982', true, '7');
INSERT INTO public.customers_anonymized VALUES ('fb9ae05c-0980-4127-a5f9-66e9e544fd35', 'СтройИнвест Консалтинг Интеграция', '01113', true, '1985');
INSERT INTO public.customers_anonymized VALUES ('6a6392dc-5543-40d2-9013-98d227889de8', 'ТехноКонсалт', '68399', false, '2');
INSERT INTO public.customers_anonymized VALUES ('a1532c2a-24ed-4889-9b8a-7bfc90ea5090', 'Станция', '50327', false, '3');
INSERT INTO public.customers_anonymized VALUES ('56223538-6d30-4571-9f80-78fd4890b6bd', 'Комплекс Хард', '78058', false, '4');
INSERT INTO public.customers_anonymized VALUES ('cc891a04-8014-4a22-844d-4819b7facb80', 'Инжиниринг', '98800', false, '6');
INSERT INTO public.customers_anonymized VALUES ('72d1e65d-9add-4e06-a8d3-82f446e70749', 'Модернизация', '61912', false, '8');
INSERT INTO public.customers_anonymized VALUES ('7fb526fd-d344-4599-8242-947e64b136a8', 'Прибор', '68014', true, NULL);
INSERT INTO public.customers_anonymized VALUES ('5846bf83-ee7f-42fe-8bec-e2fce9567a56', 'ПромСтрой', '31510', true, NULL);
INSERT INTO public.customers_anonymized VALUES ('63172c92-8d35-48d3-8e82-fad59bb5e33d', 'Электро', '36333', true, NULL);
INSERT INTO public.customers_anonymized VALUES ('555c5e70-06dd-490a-a9da-233e9cbc1a81', 'Тоннель', '91712', true, NULL);
INSERT INTO public.customers_anonymized VALUES ('7173e752-ec63-49cd-b6c8-90082d3f3f7c', 'Отрасль', '57501', true, NULL);


--
-- Data for Name: projects_anonymized; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.projects_anonymized VALUES ('30df4d38-79c5-425e-9678-fcf9900d2be1', 'Шина Принтер Интегратор Метр', 'fb9ae05c-0980-4127-a5f9-66e9e544fd35', NULL, 'RUB', 'EXECUTION', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, '2025-03-31 03:00:00', '2025-04-07 03:00:00', NULL, '07183', false, '6730', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('b9e1ac3c-38b9-43e1-b856-e3a26567def2', 'Аутентификатор Сенсор Адвайзер Принтер Планировщик', 'd3de6d4a-aee2-48a4-9f88-a2c82227cbff', 'RU', 'RUB', 'SELLING', 95, false, '75b4ca20-c756-4724-a622-15330ef57e0a', 'd3de6d4a-aee2-48a4-9f88-a2c82227cbff', '2025-01-01 09:25:16', '2025-12-31 09:25:25', NULL, '26681', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('b5af3374-8f3b-42fe-8257-2896f5114cfd', 'Безопасность', '55f82744-3779-4c9d-9af5-2ab7becbb256', NULL, 'RUB', 'EXECUTION', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '36278', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('3d80b39f-8b53-4097-b950-82f99836b4a1', 'Провайдер Трансформер', '0db3c566-ec34-4402-a6cc-2119562434a9', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '60501', false, NULL, NULL, NULL, NULL, true, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('bf62f91c-2451-4f47-a0d2-32d4e81460f9', 'Линия Калибратор Сжатие Шлюз Ассистент', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'EXECUTION', 15, false, '75b4ca20-c756-4724-a622-15330ef57e0a', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-10-01 00:00:00', '2027-12-01 23:59:59', 6579704, '00760', false, NULL, '82db3877-6ee9-4210-b890-bf9facc1d6da', '2dc3a195-3148-4b7a-b7a9-386d45ab0a6a', '4224975c-2063-4e57-b3b8-c314bd383216', false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('2c2b3564-16f5-482a-9be0-85b8f31df35a', 'Разработка Синхронизация Защита Конструктор Скринер', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'EXECUTION', 85, false, '75b4ca20-c756-4724-a622-15330ef57e0a', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-01-01 00:00:00', '2026-12-01 23:59:59', 6579704, '92123', false, NULL, NULL, NULL, NULL, false, true, 'INTERNAL');
INSERT INTO public.projects_anonymized VALUES ('26362c02-debd-4bb8-b9e9-237e01661ead', 'Алгоритм', '889a0a83-fae8-43f8-90ae-7c39ad11a3ef', 'RU', 'RUB', 'EXECUTION', 50, false, 'af7a5314-7102-4b9c-a982-0f050ef34076', '889a0a83-fae8-43f8-90ae-7c39ad11a3ef', '2024-01-01 00:00:00', '2024-12-31 23:59:59', 7262015, '87569', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('2efad0b9-e366-491a-939c-53ba6d766548', 'Диспетчер', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'CLOSED', 50, true, '75b4ca20-c756-4724-a622-15330ef57e0a', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-01-02 09:24:57', '2025-12-30 09:25:07', NULL, '68399', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('620891fa-e45b-41a7-b245-119159d69f77', 'Транзакция Адвайзер', '6ccfe453-1a7e-4662-b01d-f7c66989abf9', '', '', 'EXECUTION', 0, false, NULL, NULL, NULL, NULL, 6579704, '91018', false, NULL, NULL, NULL, NULL, true, false, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('fe0d70c0-58be-45ea-93ab-dd9e22aa9034', 'Шлюз Администратор Профи', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'SELLING', 0, false, '8c0065dd-deb0-4e65-9848-6465e04fe080', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-05-01 09:50:16', '2026-07-01 09:50:27', 4693958, '54375', false, NULL, '3be12f58-5fef-46a4-a002-0395a6e469f5', '2dc3a195-3148-4b7a-b7a9-386d45ab0a6a', '72f9129c-ce12-409c-88b2-80332dcf0444', false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('98f582e2-e53f-4b35-9820-2bb951efa9b5', 'Рендеринг Индексирование Конвейер Терминал Маршрутизация', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'SELLING', 75, false, '75b4ca20-c756-4724-a622-15330ef57e0a', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-03-01 09:25:37', '2025-05-30 09:26:11', NULL, '08912', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('d27245a3-af97-46f8-b4e6-28616836ec28', 'Измеритель', '0db3c566-ec34-4402-a6cc-2119562434a9', 'US', 'RUB', 'EXECUTION', 50, false, '82db3877-6ee9-4210-b890-bf9facc1d6da', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-08-01 00:00:00', '2025-12-31 23:59:59', 6579704, '23084', false, NULL, NULL, NULL, NULL, false, false, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('145e0f16-10a1-429f-b434-8951d4f2b092', 'Лидер Декодер', '6ccfe453-1a7e-4662-b01d-f7c66989abf9', 'RU', 'RUB', 'TECHNICAL_CLOSURE', 50, true, '0118370a-dd62-456f-93ca-a803baeb0e83', '6ccfe453-1a7e-4662-b01d-f7c66989abf9', '2024-02-01 00:00:00', '2026-12-31 23:59:59', 4641385, '98982', false, NULL, NULL, '2dc3a195-3148-4b7a-b7a9-386d45ab0a6a', '4224975c-2063-4e57-b3b8-c314bd383216', false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('569b3dcf-f58f-4cd0-b7bf-8e88c6113b03', 'Линия', '0db3c566-ec34-4402-a6cc-2119562434a9', '', 'RUB', 'SELLING', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, '2025-01-01 12:43:44', '2026-12-01 12:43:48', NULL, '57563', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('3b8f2429-3a26-4391-95c3-cffb46600556', 'Конвертер', 'f0031546-e96a-4bce-b4bb-9f9cabf98f41', 'RU', 'RUB', 'EXECUTION', 25, false, '8c0065dd-deb0-4e65-9848-6465e04fe080', 'f0031546-e96a-4bce-b4bb-9f9cabf98f41', '2024-02-16 00:00:00', '2025-11-30 00:00:00', 269672, '63571', false, NULL, '3be12f58-5fef-46a4-a002-0395a6e469f5', '96e42a7b-f943-447b-b637-4378d65b74b0', 'e963cd13-3646-4e55-b25d-23fda5dadcd9', false, false, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('b16e2fc2-0d44-4579-a9d3-c54a18bd4664', 'Специалист', '55f82744-3779-4c9d-9af5-2ab7becbb256', NULL, 'RUB', 'SELLING', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, '2025-01-01 14:00:37', '2026-12-01 14:00:43', NULL, '86822', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('c33f9eb1-a502-41a3-a6c6-bd1ae039f4fd', 'Трансляция Агрегатор Вычисление Разработка Транзакция', 'f7807b95-1d67-4a99-b868-5422974895f1', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '17791', false, '20', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('40ca8672-6c4d-4cdd-b147-0726e463e147', 'Мост Трекер Сервис Резервирование Хаб', '16b51809-7f1f-48b5-ad88-d3014a835201', NULL, 'RUB', 'SELLING', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, '2025-08-08 03:00:00', '2025-08-15 03:00:00', NULL, '26505', false, '6734', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('971e6b8c-e116-40fd-b09d-b017ba97409c', 'Генералист Хостинг', '775608b3-b8fd-4fb4-9e86-28d2b0f9fc92', NULL, 'RUB', 'EXECUTION', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, '2025-04-02 03:00:00', '2025-04-10 03:00:00', NULL, '65148', false, '6732', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('e28a4fc7-a624-4be3-a427-ddfcff965615', 'Кэширование', '0db3c566-ec34-4402-a6cc-2119562434a9', 'RU', 'RUB', 'TECHNICAL_CLOSURE', 65, false, '374ce3a8-caae-4775-b8eb-7695a58e0473', '0db3c566-ec34-4402-a6cc-2119562434a9', '2025-02-01 00:00:00', '2025-05-31 23:59:59', 2497413, '78058', false, NULL, NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('5e087a63-34f5-4df0-894e-85359e384fc6', 'Администратор Безопасность Брокер Сенсорика Парсер', '775608b3-b8fd-4fb4-9e86-28d2b0f9fc92', NULL, 'RUB', 'EXECUTION', NULL, NULL, '75b4ca20-c756-4724-a622-15330ef57e0a', NULL, '2025-03-31 03:00:00', '2025-04-07 03:00:00', NULL, '10422', false, '6731', NULL, NULL, NULL, false, false, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('a7915cb2-2364-4be9-a43e-e36ad3a44161', 'Сегментатор Интеграция Шина Трансформер Телеметрия', '0b4c1087-094e-4107-89e6-67de48aa01fd', NULL, 'RUB', 'SELLING', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, NULL, NULL, NULL, '33628', false, '19', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('ae7b5b5f-8374-4038-876a-6e220e35213d', 'Валидатор Обновление Трансивер Логист', '56223538-6d30-4571-9f80-78fd4890b6bd', NULL, 'RUB', 'EXECUTION', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, NULL, NULL, NULL, '49003', false, '18', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('8b84a843-bc32-4ada-a72b-0c0843fc7675', 'Эксперт Сопровождение Консультант Мониторинг Привод', '66ca648c-2e52-4a85-a698-a0a2ea89508d', NULL, 'RUB', 'EXECUTION', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, NULL, NULL, NULL, '11320', false, '16', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('3978c0d9-f7a2-4968-93fa-a63ee3f0763f', 'Платформа Измеритель Модернизация Дрон Планировщик', 'cc891a04-8014-4a22-844d-4819b7facb80', NULL, 'RUB', 'SELLING', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, NULL, NULL, NULL, '96486', false, '7', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('848795f8-df09-43e5-8411-34507f7222c4', 'Конвертор Агент Цифровизация Принтер Виртуализация', '55f82744-3779-4c9d-9af5-2ab7becbb256', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, '2025-11-24 03:00:00', NULL, NULL, '65526', false, '15', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('96ccfe28-1888-4dbc-a4fb-c140bdad7725', 'Адаптер Цифровизация Компаратор Сопровождение Миграция', '0b4c1087-094e-4107-89e6-67de48aa01fd', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '30835', false, '14', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('f12a00fb-29fb-4d18-9b11-fde382e493e3', 'Терминал Центр Транзакция', 'fb9ae05c-0980-4127-a5f9-66e9e544fd35', NULL, 'RUB', 'EXECUTION', NULL, NULL, NULL, NULL, '2025-04-02 03:00:00', '2025-04-09 03:00:00', NULL, '37260', false, '6733', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('7f346f66-1f8b-45a5-a08e-b38cd00c781b', 'Метр Трансивер Вычисление Интерфейс', 'cf59dd3a-2f18-4359-bb16-18b18655cfa8', NULL, 'RUB', 'SELLING', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, NULL, NULL, NULL, '60252', false, '10', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('5b12e8dc-79f8-4f14-b032-bfce40e9bf75', 'Синтезатор Адаптер', '6a6392dc-5543-40d2-9013-98d227889de8', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '90455', false, '2', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('6043f2e8-a1cc-42ac-b757-671cffb275d0', 'Диспетчер Метр Провайдер Брокер Реорганизация', '72d1e65d-9add-4e06-a8d3-82f446e70749', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '29207', false, '21', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('1a66c12a-3090-4a02-9190-28f37fbafe77', 'Балансировка Графопостроитель Планировщик', 'f7807b95-1d67-4a99-b868-5422974895f1', NULL, 'RUB', 'SELLING', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, NULL, NULL, NULL, '38702', false, '22', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('e663bef8-ccde-4afc-ae4f-a4b8a0cb6e7b', 'Компонент Координатор Автоматизация Контейнеризация Диспетчер', 'cf59dd3a-2f18-4359-bb16-18b18655cfa8', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '50526', false, '9', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('b8b568d1-b95a-4833-ae10-fd078c8246e3', 'Графопостроитель Администратор Кластеризация Трансформация', '56223538-6d30-4571-9f80-78fd4890b6bd', NULL, 'RUB', 'EXECUTION', NULL, NULL, NULL, NULL, '2025-10-24 03:00:00', NULL, NULL, '43890', false, '5', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('06925ebc-18ab-4dc1-b917-ddde9463f201', 'Декодер Нейросеть Консультант Генералист Измеритель', 'cc891a04-8014-4a22-844d-4819b7facb80', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '75687', false, '8', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('edca353d-8a85-4c25-a8b0-8a6cce1c415c', 'Нейросеть Поддержка Мост Обновление Портал', 'a1532c2a-24ed-4889-9b8a-7bfc90ea5090', NULL, 'RUB', 'SELLING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '80636', false, '4', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('a47cee3e-9544-40de-86fe-a04606911c0d', 'Совершенствование Цифровизация Трансляция Тракер Кластеризация', 'a485473a-e26c-44b9-b5cd-a91def86793d', NULL, 'RUB', 'SELLING', NULL, NULL, '8c0065dd-deb0-4e65-9848-6465e04fe080', NULL, NULL, NULL, NULL, '78441', false, '11', NULL, NULL, NULL, false, true, 'EXTERNAL');
INSERT INTO public.projects_anonymized VALUES ('77bdf6cf-1296-4f50-827d-a0eb29b2f1b5', 'Аккаунтер Управление Принтер Миграция Интеграция', 'f7807b95-1d67-4a99-b868-5422974895f1', NULL, 'RUB', 'SELLING', NULL, NULL, '0118370a-dd62-456f-93ca-a803baeb0e83', NULL, NULL, NULL, NULL, '63895', false, '3', NULL, NULL, NULL, false, true, 'EXTERNAL');


--
-- Data for Name: users_anonymized; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users_anonymized VALUES ('6abd346e-e55a-4c6c-91bf-2d5ee01eb8b3', 'bhpszd5txjpm@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Игнатий', 'Ерофеенко', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('af7a5314-7102-4b9c-a982-0f050ef34076', 'idkee2kggd@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Хоселито', 'Максимец', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('60e37cfd-811c-4d55-afdb-f7b310dff7a2', '7d6o9um7lf7v@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Аланус', 'Харичкин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('aef758de-ec45-46ed-b6d0-8e43945ab461', 'ytz6obi7xf@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Фотий', 'Чернышевский', 'ru', false, true, '2025-10-13 05:26:23.176664', true, false);
INSERT INTO public.users_anonymized VALUES ('7803d22f-90ae-494b-aed1-306345f17994', 'x76l95ffmnf4@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Жан', 'Грищанин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('a0b19d74-6357-47e7-b106-0a5a865cf906', '6zajrdszp3@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Амфилохий', 'Колчин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('8c0065dd-deb0-4e65-9848-6465e04fe080', '9cujx47nxtu2@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Арфаксад', 'Подомарев', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('c77874a5-68e1-4d27-8316-7549afae74cb', 'gikkjj1yjn5u@example.com', '$2b$12$UIW90QlBw9OmRB/L6gdWw.meTxMPoHDQcOUEbi7Y/R1paN35ABQ0a', 'Куприян', 'Завгородний', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('6ecbff98-0b4e-4b53-9836-bb51305d0efa', 'e2kxaf4dx@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Эстебан', 'Плющаков', 'ru', false, true, '2025-11-01 06:34:48.024346', true, false);
INSERT INTO public.users_anonymized VALUES ('374ce3a8-caae-4775-b8eb-7695a58e0473', '32fq1zj5@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Фродо', 'Авершин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('82db3877-6ee9-4210-b890-bf9facc1d6da', '2nwhrwdgcgz@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Федосей', 'Кирьяков', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('350b05d6-12e6-4648-bb93-dae98427eb4d', 'puklvxjyzt@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Филип', 'Кознаков', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('b025e8b1-5f2e-456b-b959-40aef6c2af8b', 'nnfbjdpcv4@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Еремей', 'Терехин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('a9146c09-92a6-4bd6-a9a9-880c5300363c', '510kz7yu@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Дитрих', 'Гашкин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('71bc5b5f-5387-436f-a1dc-8790addd5be1', 'k68p577v@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Этьен', 'Гулин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('75b4ca20-c756-4724-a622-15330ef57e0a', 'tatu1yugwb@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Фродо', 'Рудной', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('52f2aa33-4b00-42ad-8561-74635d7a6a44', '26p7smojqo5@example.com', '$2b$12$ftidnsrDgK273SNa8UN/Pep3niH3ovH0.j9WTciEXNYfIT.xaFhO2', 'Альвизе', 'Кокошилов', 'ru', false, true, '2025-11-11 15:49:31.540862', true, false);
INSERT INTO public.users_anonymized VALUES ('d8f05272-62d6-4d75-af9e-a17007fbdb5b', 'o8y3fn0kgajb@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Исмаил', 'Криванков', 'ru', false, false, '2025-11-14 06:03:10.546311', true, false);
INSERT INTO public.users_anonymized VALUES ('c37917fa-f492-43ae-9c6a-48840dd153db', 'a5t1dbm0m8n@example.com', '$2b$12$cNA0fOhEBTzs3hHMBCyshuR.zZaiEs..QTH3j1Gznkq0ifCtwVM3q', 'Пантелеймон', 'Летецкий', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('242ace2e-2dda-4e73-be11-af19a8dc83a6', 'n6ecxzdob@example.com', '$2b$12$g2/BTOS9rY85N8T.MJPQxOhfBlJWY8yr1BVccPgE0QdjUJ.njoSTa', 'Рашад', 'Ковелин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('535b0940-1691-4d0c-aca3-26ef74d47635', '7lvqw4sn@example.com', '$2b$12$BPga24cBztKVfb7VvLVbt.B7GquQOtFBRgmT0uvYYA2JIZOiqBMei', 'Геласий', 'Звездочкин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('22d2c90a-6770-4697-b24d-34a8b8cd58c6', 'l7jb2036adf@example.com', '$2b$12$hoHu/Uj.Nod8EOP.26NGlOZoNNXtlG5ymzblkfPIJn6h2smuQIN0G', 'Аристон', 'Маренюк', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('3be12f58-5fef-46a4-a002-0395a6e469f5', 'l0flahfibi@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Мирко', 'Тарасов', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('0e36c836-6759-45b6-adcb-5b92568d646f', '24xkbvsna4gd@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Герман', 'Стоюнин', 'ru', false, false, NULL, true, true);
INSERT INTO public.users_anonymized VALUES ('15aa862b-cff0-4708-a06e-2c35314e0643', '0or58mkv9@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Родион', 'Ханыгин', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('0118370a-dd62-456f-93ca-a803baeb0e83', 'hmxx0qwcdj@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Антипа', 'Кошаков', 'ru', false, false, NULL, true, false);
INSERT INTO public.users_anonymized VALUES ('d722b07d-cec3-41b6-ba59-5fa0a58caae2', 'tvgaoi2036r7@example.com', '$2y$10$hNpAiololRPZ3LKplVVnxuR1uznl3XhscNC4M/03x8GGuJJ4kL40S', 'Айварс', 'Антоненков', 'ru', false, false, NULL, true, true);


--
-- PostgreSQL database dump complete
--

\unrestrict rdNMMjRCYoHi4U816thN9jD5wQJsDvhPQQj7gxf4w28fOWIlgXBP9MXyPIyZL1w

