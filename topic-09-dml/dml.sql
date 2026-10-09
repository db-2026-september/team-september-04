-- ================================================================
-- SQL DML TEMPLATE (TOPIC 09)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) INSERT scripts for all required tables in your database.
-- 2) At least 10 records per table with meaningful, realistic values.
-- 3) UPDATE / DELETE scripts where they are relevant to business logic.
-- 4) If UPDATE / DELETE are not relevant for a table, add a short note
--    in documentation explaining why.
-- 5) Comments by section so the script is easy to read and run.
--
-- SCRIPT GOALS:
-- - Populate the database with usable test data.
-- - Validate constraints through realistic DML scenarios.
-- - Support the core functionality of your application.
--
-- RECOMMENDED ORDER:
-- 1) Reference data (lookups/dictionaries)
-- 2) Core entities
-- 3) Transactional data
-- 4) Optional UPDATE / DELETE checks
--
-- IMPORTANT:
-- - Use anonymized or privacy-safe sample data where possible.
-- - The script must execute in PostgreSQL.
-- - Submit this as one SQL file.
-- ================================================================

-- Add your DML below this line

-- ================================================
-- [Boris] Таблиця members: вставка, невалідні INSERT, UPDATE, DELETE
-- ================================================

-- -- Вставка валідних даних у таблицю  members (12 записів)
INSERT INTO fitness_center_team4.members (first_name, last_name, email, phone, birth_date, registration_date)
VALUES
  -- Записи з повними даними
  ('Олександр', 'Коваленко', 'o.kovalenko@example.com',   '+380501234567', '1990-05-14', '2022-01-15 10:30:00'),
  ('Анна',      'Шевченко',  'a.shevchenko@example.org',  '+380672345678', '1985-11-22', '2021-08-01 14:15:00'),
  ('Максим',    'Бондаренко','m.bondarenko@example.net',  '+380633456789', '1998-03-30', '2023-03-10 09:00:00'),
  ('Марія',     'Мельник',   'm.melnyk@example.com',      '+380954567890', '2001-07-08', '2023-11-05 18:45:00'),
  ('Дмитро',    'Ткаченко',  'd.tkachenko@domain.com',    '+380975678901', '1978-12-19', '2020-05-20 11:20:00'),
  ('Олена',     'Кравченко', 'o.kravchenko@domain.org',   '+380506789012', '1995-09-02', '2022-09-12 16:00:00'),
  ('Андрій',    'Коваль',    'a.koval@test-mail.com',     '+380687890123', '1992-04-17', '2021-12-01 08:30:00'),

  -- Записи з NULL значеннями (відсутній phone)
  ('Ірина',     'Бойко',     'i.boyko@example.com',       NULL,           '1989-01-25', '2022-04-18 12:10:00'),
  ('Сергій',    'Поліщук',   's.polishchuk@domain.net',   NULL,           '1996-06-11', '2023-01-22 15:40:00'),

  -- Записи з NULL значеннями (відсутній birth_date)
  ('Вікторія',  'Лисенко',   'v.lysenko@test-mail.org',   '+380939012345', NULL,         '2023-06-30 13:00:00'),

  -- Записи з NULL значеннями у двох optional-полях (без phone та без birth_date)
  ('Василь',    'Мороз',     'v.moroz@example.org',       NULL,           NULL,         '2023-09-01 10:00:00'),
  ('Юлія',      'Руденко',   'y.rudenko@domain.com',      NULL,           NULL,         '2024-02-14 17:25:00');



-- ================================================
-- [Boris] Невалідні INSERT (кожен має давати помилку)
-- Запускати по одному, прибравши -- перед рядками
-- ================================================

-- 1. email: після @ немає домену
-- Очікується: violates check constraint "chk_members_email_format"
-- INSERT INTO fitness_center_team4.members
--   (first_name, last_name, email, phone, birth_date, registration_date)
-- VALUES
--   ('Олександр', 'Коваленко', 'o.kovalenko@', '+380501234567', '1990-05-14', '2022-01-15');

-- 2. email: немає символу @
-- Очікується: violates check constraint "chk_members_email_format"
-- INSERT INTO fitness_center_team4.members
--   (first_name, last_name, email, phone, birth_date, registration_date)
-- VALUES
--   ('Олександр', 'Коваленко', 'o.kovalenko.example.com', '+380501234567', '1990-05-14', '2022-01-15');

-- 3. registration_date раніше за birth_date
-- Очікується: violates check constraint "chk_members_reg_date_after_birth"
-- INSERT INTO fitness_center_team4.members
--   (first_name, last_name, email, phone, birth_date, registration_date)
-- VALUES
--   ('Тест', 'Раніше', 'test.earlier@example.com', '+380501111111', '2000-01-01', '1999-12-31');

-- 4. Дублікат email: точно такий самий
-- Очікується: duplicate key value violates unique constraint "members_email_key"
-- INSERT INTO fitness_center_team4.members
--   (first_name, last_name, email, phone, birth_date, registration_date)
-- VALUES
--   ('Олександр', 'Коваленко', 'o.kovalenko@example.com', '+380501234567', '1990-05-14', '2022-01-15');

-- 5. Дублікат email: відрізняється лише регістром (CITEXT)
-- Очікується: duplicate key value violates unique constraint "members_email_key"
-- INSERT INTO fitness_center_team4.members
--   (first_name, last_name, email, phone, birth_date, registration_date)
-- VALUES
--   ('Олександр', 'Коваленко', 'O.kovalenko@example.com', '+380501234567', '1990-05-14', '2022-01-15');


-- ================================================
-- [Boris] UPDATE: оновлення даних учасників
-- ================================================

-- Змінити телефон Олександра Коваленка
-- Умова за іменем, прізвищем і email, щоб змінився лише один рядок
UPDATE fitness_center_team4.members
SET phone = '+380972345111'
WHERE first_name = 'Олександр'
  AND last_name = 'Коваленко'
  AND email = 'o.kovalenko@example.com';

-- Змінити прізвище Анни Шевченко на Винник
-- Умова за телефоном і email, щоб не зачепити інших учасників
UPDATE fitness_center_team4.members
SET last_name = 'Винник'
WHERE phone = '+380672345678'
  AND email = 'a.shevchenko@example.org';


-- ================================================
-- [Boris] DELETE: видалення тестового учасника
-- ================================================

-- Спочатку вставляємо учасника, який не матиме зв'язків
-- з іншими таблицями (memberships, attendance)
INSERT INTO fitness_center_team4.members
  (first_name, last_name, email, phone, birth_date, registration_date)
VALUES
  ('Олег', 'Видалення', 'o.test@gmail.com', '+380531234222', '1985-12-12', '2021-12-01');

-- Видаляємо його за email
-- RETURNING показує, кого саме видалено
DELETE FROM fitness_center_team4.members
WHERE email = 'o.test@gmail.com'
RETURNING member_id, first_name, last_name;

-- Перевірка: має повернути 0 рядків
SELECT * FROM fitness_center_team4.members
WHERE email = 'o.test@gmail.com';


-- ================================================
-- [Oksana] Таблиця trainers: вставка, невалідні INSERT, UPDATE, DELETE
-- ================================================

-- -- Вставка валідних даних у таблицю  trainers (12 записів)

INSERT INTO fitness_center_team4.trainers 
(first_name, last_name, birth_date, phone, email, hire_date) VALUES 
  -- Записи з повними даними
('Андрій', 'Мельник', '1988-04-12', '+380671234501', 'a.melnyk@example.com', '2018-06-15'),
('Ірина', 'Ткаченко', '1992-09-23', '+380501234502', 'i.tkachenko@example.com', '2020-02-10'),
('Владислав', 'Кравченко', '1985-01-17', '+380931234503', 'v.kravchenko@example.com', '2016-11-01'),
('Марія', 'Олійник', '1995-07-08', '+380631234504', 'm.oliinyk@example.com', '2021-05-20'),
('Богдан', 'Лисенко', '1997-02-11', '+380731234507', 'b.lysenko@example.com', '2022-08-01'),
('Катерина', 'Бойко', '1996-08-14', '+380991234510', 'k.boiko@example.com', '2023-01-16'),

-- Записи з NULL значеннями (відсутній birth_date)
('Дмитро', 'Савченко', NULL, '+380661234505', 'd.savchenko@example.com', '2019-09-02'),
('Олена', 'Романюк', NULL, '+380971234506', 'o.romaniuk@example.com', '2017-03-14'),

-- Записи з NULL значеннями (відсутній phone)
('Наталія', 'Ковальчук', '1993-10-19', NULL, 'n.kovalchuk@example.com', '2020-10-12'),
('Сергій', 'Поліщук', '1984-05-30', NULL, 's.polishchuk@example.com', '2015-04-06'),

-- Записи з NULL значеннями у двох optional-полях (без phone та без birth_date)
('Роман', 'Мороз', NULL, NULL, 'r.moroz@example.com', '2019-01-21'),
('Юлія', 'Петренко', NULL, NULL, 'y.petrenko@example.com', '2022-04-18');

-- ================================================
-- [Oksana] Таблиця trainers [Невалідні INSERT] (кожен має давати помилку)
-- Запускати по одному, прибравши -- перед рядками
-- ================================================

-- 1. email: після @ немає домену
-- Очікується: value for domain fitness_center_team4.email_address violates check constraint "email_address_check"
-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--  ('Андрій', 'Мельник', '1988-04-12', '+380671234501', 'a.melnyk2@e', '2018-06-15');

-- 2. email: немає символу @
-- Очікується: value for domain fitness_center_team4.email_address violates check constraint "email_address_check"
-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Андрій', 'Мельник', '1988-04-12', '+380671234501', 'a.melnyk2.example.com', '2018-06-15');

-- 3. Дублікат email: точно такий самий
-- Очікується: duplicate key value violates unique constraint "trainers_email_key"
-- DETAIL:  Key (email)=(a.melnyk@example.com) already exists.

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Арсеній', 'Мельник', '1992-06-26', '+380671234501', 'a.melnyk@example.com', '2018-06-15');

-- 4. Дублікат email: відрізняється лише регістром (CITEXT)
-- Очікується: duplicate key value violates unique constraint "trainers_email_key"
-- DETAIL:  Key (email)=(a.melnyk@example.com) already exists.

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Арсеній', 'Мельник', '1992-06-26', '+380671234501', 'a.Melnyk@example.com', '2018-06-15');

-- 5. Дата народження раніше 1900 року
-- Очікується: new row for relation "trainers" violates check constraint "chk_trainers_birth_date"

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Іван', 'Петренко', '1899-12-31', '+380671234520',
--    'i.petrenko@example.com', '2020-05-10');

-- 6. Дата прийому на роботу раніше дати народження
-- Очікується: violates check constraint "chk_trainers_hire_after_birth"

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Іван', 'Петренко', '1990-05-10', '+380671234521',
--    'i.petrenko2@example.com', '1989-05-10');

-- 7. Відсутня дата прийому на роботу
-- Очікується: null value in column "hire_date" violates not-null constraint

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   ('Іван', 'Петренко', '1990-05-10', '+380671234522',
--    'i.petrenko3@example.com', NULL);

-- 8. Відсутнє ім'я тренера
-- Очікується: null value in column "first_name" violates not-null constraint

-- INSERT INTO fitness_center_team4.trainers
--   (first_name, last_name, birth_date, phone, email, hire_date)
-- VALUES
--   (NULL, 'Петренко', '1990-05-10', '+380671234523',
--    'i.petrenko4@example.com', '2020-05-10');

-- ================================================
-- [Oksana] Таблиця trainers [UPDATE]: оновлення даних тренерів
-- ================================================

-- Змінити телефон для тренера Андрій Мельник
-- Умова за іменем, прізвищем і email, щоб змінився лише один рядок
UPDATE fitness_center_team4.trainers
SET phone = '+380672222222'
WHERE first_name = 'Андрій' 
  AND last_name = 'Мельник'
  AND email = 'a.melnyk@example.com';

-- Змінити прізвище Олена Романюк на Тарасюк
-- Умова за email, щоб не зачепити інших учасників
UPDATE fitness_center_team4.trainers
SET last_name = 'Тарасюк'
WHERE email = 'o.romaniuk@example.com';

-- ================================================
-- [Oksana] Таблиця trainers [DELETE]: видалення тестового учасника
-- ================================================

-- Створимо тестового учасника для перевірки видалення
INSERT INTO fitness_center_team4.trainers
  (first_name, last_name, birth_date, phone, email, hire_date)
VALUES
  ('Євген', 'Кравченко', '1992-06-26', '+380671234501', 'e.kravchenko@example.com', '2018-06-15');

-- Видаляємо його за email
-- RETURNING показує, кого саме видалено по цим колонкам trainer_id, first_name, last_name
DELETE FROM fitness_center_team4.trainers
WHERE email = 'e.kravchenko@example.com'
RETURNING trainer_id, first_name, last_name;

-- Перевірка: має повернути 0 рядків
SELECT * FROM fitness_center_team4.trainers
WHERE email = 'e.kravchenko@example.com';


-- ================================================================
-- [Oleksandr] Таблиці membership_plans та memberships
-- ================================================================
-- Порядок: спочатку membership_plans (довідник тарифів),
-- потім memberships (абонементи), бо memberships посилається
-- і на members, і на membership_plans через FOREIGN KEY.
--
-- member_id та plan_id НЕ прописані числами: вони шукаються
-- за email (UNIQUE у members) та plan_name (UNIQUE у membership_plans).
-- Так скрипт не залежить від того, які id згенерує IDENTITY,
-- а якщо email або назву плану змінять, INSERT впаде з помилкою
-- NOT NULL, а не прив'яже абонемент до чужої людини.
-- ================================================================


-- ================================================
-- [Oleksandr] membership_plans: вставка тарифів (10 записів)
-- ================================================
-- Ціни в гривнях. 'Пробний місяць' має ціну 0.00:
-- це граничне значення для CHECK (price >= 0).
INSERT INTO fitness_center_team4.membership_plans (plan_name, duration_months, price)
VALUES
  ('Пробний місяць',           1,     0.00),
  ('Місячний',                 1,   900.00),
  ('Ранковий місячний',        1,   700.00),
  ('Студентський місячний',    1,   600.00),
  ('Квартальний',              3,  2400.00),
  ('Студентський квартальний', 3,  1600.00),
  ('Піврічний',                6,  4500.00),
  ('Річний',                  12,  8000.00),
  ('Преміум річний',          12, 12000.00),
  ('Сімейний річний',         12, 14000.00);


-- ================================================
-- [Oleksandr] memberships: вставка абонементів (13 записів)
-- ================================================
-- Дані узгоджені з members [Boris]:
-- - start_date не раніше за registration_date клієнта;
-- - end_date = start_date + duration_months плану;
-- - status відповідає датам (поточна дата проєкту: жовтень 2026):
--   expired - строк минув, active - діє, frozen - призупинений,
--   cancelled - клієнт відмовився достроково.
-- Олександр Коваленко та Вікторія Лисенко мають по 2 абонементи
-- (історія + поточний) - це демонструє зв'язок one-to-many.
-- Василь Мороз свідомо без абонемента (знадобиться для DELETE-тесту).
INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date, status)
VALUES
  -- Олександр Коваленко: старий річний (минув) + новий річний (діє)
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'o.kovalenko@example.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Річний'),
   '2022-02-01', '2023-02-01', 'expired'),
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'o.kovalenko@example.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Річний'),
   '2025-11-01', '2026-11-01', 'active'),

  -- Анна Шевченко: квартальний, діє
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'a.shevchenko@example.org'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Квартальний'),
   '2026-08-15', '2026-11-15', 'active'),

  -- Максим Бондаренко: студентський квартальний, минув
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'm.bondarenko@example.net'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Студентський квартальний'),
   '2023-03-10', '2023-06-10', 'expired'),

  -- Марія Мельник: студентський місячний, діє
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'm.melnyk@example.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Студентський місячний'),
   '2026-09-20', '2026-10-20', 'active'),

  -- Дмитро Ткаченко: преміум річний, діє
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'd.tkachenko@domain.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Преміум річний'),
   '2026-01-10', '2027-01-10', 'active'),

  -- Олена Кравченко: піврічний, заморожений
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'o.kravchenko@domain.org'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Піврічний'),
   '2026-05-01', '2026-11-01', 'frozen'),

  -- Андрій Коваль: місячний, минув
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'a.koval@test-mail.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
   '2026-07-01', '2026-08-01', 'expired'),

  -- Ірина Бойко: сімейний річний, діє
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'i.boyko@example.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Сімейний річний'),
   '2026-03-01', '2027-03-01', 'active'),

  -- Сергій Поліщук: ранковий місячний, діє
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 's.polishchuk@domain.net'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Ранковий місячний'),
   '2026-09-15', '2026-10-15', 'active'),

  -- Вікторія Лисенко: пробний (минув) + квартальний (скасований)
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.lysenko@test-mail.org'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Пробний місяць'),
   '2023-06-30', '2023-07-30', 'expired'),
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.lysenko@test-mail.org'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Квартальний'),
   '2026-06-01', '2026-09-01', 'cancelled'),

  -- Юлія Руденко: місячний, діє (status не вказаний -> DEFAULT 'active')
  ((SELECT member_id FROM fitness_center_team4.members WHERE email = 'y.rudenko@domain.com'),
   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
   '2026-10-01', '2026-11-01', DEFAULT);


-- ================================================
-- [Oleksandr] Невалідні INSERT (кожен має давати помилку)
-- Запускати по одному, прибравши -- перед рядками
-- ================================================

-- 1. Дублікат назви плану
-- Очікується: duplicate key value violates unique constraint "membership_plans_plan_name_key"
-- INSERT INTO fitness_center_team4.membership_plans (plan_name, duration_months, price)
-- VALUES ('Місячний', 1, 1000.00);

-- 2. Тривалість плану 0 місяців
-- Очікується: violates check constraint "chk_membership_plans_duration_positive"
-- INSERT INTO fitness_center_team4.membership_plans (plan_name, duration_months, price)
-- VALUES ('Нульовий', 0, 500.00);

-- 3. Від'ємна ціна плану
-- Очікується: violates check constraint "chk_membership_plans_price_non_negative"
-- INSERT INTO fitness_center_team4.membership_plans (plan_name, duration_months, price)
-- VALUES ('Від''ємний', 1, -100.00);

-- 4. Абонемент закінчується раніше, ніж починається
-- Очікується: violates check constraint "chk_memberships_dates_valid"
-- INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date)
-- VALUES (
--   (SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.moroz@example.org'),
--   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
--   '2026-10-10', '2026-10-01');

-- 5. Неіснуючий клієнт (member_id, якого немає в members)
-- Очікується: violates foreign key constraint "fk_memberships_member"
-- INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date)
-- VALUES (
--   99999,
--   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
--   '2026-10-01', '2026-11-01');

-- 6. Неіснуючий тарифний план
-- Очікується: violates foreign key constraint "fk_memberships_plan"
-- INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date)
-- VALUES (
--   (SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.moroz@example.org'),
--   99999,
--   '2026-10-01', '2026-11-01');

-- 7. Статус, якого немає в ENUM membership_status
-- Очікується: invalid input value for enum fitness_center_team4.membership_status: "paused"
-- INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date, status)
-- VALUES (
--   (SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.moroz@example.org'),
--   (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
--   '2026-10-01', '2026-11-01', 'paused');


-- ================================================
-- [Oleksandr] UPDATE: зміна тарифів і статусів абонементів
-- ================================================

-- Підвищення ціни місячного абонемента з 900 до 950 грн.
-- Обмеження схеми: memberships не зберігає ціну продажу, а лише
-- посилається на план. Тому через JOIN нова ціна відобразиться
-- і для вже проданих місячних абонементів.
UPDATE fitness_center_team4.membership_plans
SET price = 950.00
WHERE plan_name = 'Місячний'
RETURNING plan_id, plan_name, price;

-- Заморозка абонемента: Анна (тепер Винник) їде у відпустку.
-- Шукаємо за email, статусом і датами: заморожується лише абонемент,
-- який діє зараз, а не минулі чи майбутні.
UPDATE fitness_center_team4.memberships
SET status = 'frozen'
WHERE member_id = (SELECT member_id FROM fitness_center_team4.members
                   WHERE email = 'a.shevchenko@example.org')
  AND status = 'active'
  AND CURRENT_DATE BETWEEN start_date AND end_date
RETURNING membership_id, member_id, status;

-- Регулярне "прибирання": усі активні абонементи, строк яких минув,
-- переводимо в 'expired'. Результат залежить від дати запуску:
-- у жовтні 2026 може не змінитися жоден рядок, пізніше - кілька.
UPDATE fitness_center_team4.memberships
SET status = 'expired'
WHERE status = 'active'
  AND end_date < CURRENT_DATE
RETURNING membership_id, member_id, end_date, status;


-- ================================================
-- [Oleksandr] DELETE
-- ================================================
-- Реальні абонементи не видаляємо: це історія покупок клієнта.
-- Для скасування є статус 'cancelled'. DELETE доречний лише для
-- помилково створених записів, тому демонструємо його на тестових даних.

-- memberships: адміністратор помилково оформив абонемент Василю Морозу
INSERT INTO fitness_center_team4.memberships (member_id, plan_id, start_date, end_date)
VALUES (
  (SELECT member_id FROM fitness_center_team4.members WHERE email = 'v.moroz@example.org'),
  (SELECT plan_id FROM fitness_center_team4.membership_plans WHERE plan_name = 'Місячний'),
  '2026-10-08', '2026-11-08');

-- Видаляємо помилковий запис; RETURNING показує, що саме видалено
DELETE FROM fitness_center_team4.memberships
WHERE member_id = (SELECT member_id FROM fitness_center_team4.members
                   WHERE email = 'v.moroz@example.org')
  AND start_date = '2026-10-08'
RETURNING membership_id, member_id, start_date;

-- membership_plans: тестовий план без жодного абонемента можна видалити
INSERT INTO fitness_center_team4.membership_plans (plan_name, duration_months, price)
VALUES ('Тестовий план', 1, 1.00);

DELETE FROM fitness_center_team4.membership_plans
WHERE plan_name = 'Тестовий план'
RETURNING plan_id, plan_name;

-- План, який уже використовується в memberships, видалити НЕ можна.
-- Очікується: violates foreign key constraint "fk_memberships_plan"
-- DELETE FROM fitness_center_team4.membership_plans
-- WHERE plan_name = 'Річний';


-- ================================================
-- [Oleksandr] Перевірка результату
-- ================================================
-- Очікується: 10 планів і 13 абонементів
-- (12 клієнтів: двоє мають по 2 абонементи, Василь Мороз — жодного)
SELECT
  (SELECT COUNT(*) FROM fitness_center_team4.membership_plans) AS plans_count,
  (SELECT COUNT(*) FROM fitness_center_team4.memberships)      AS memberships_count;

-- Абонементи з іменами клієнтів і назвами планів
SELECT ms.membership_id,
       m.first_name || ' ' || m.last_name AS member_name,
       p.plan_name,
       ms.start_date,
       ms.end_date,
       ms.status
FROM fitness_center_team4.memberships AS ms
JOIN fitness_center_team4.members AS m ON m.member_id = ms.member_id
JOIN fitness_center_team4.membership_plans AS p ON p.plan_id = ms.plan_id
ORDER BY ms.membership_id;

-- ================================================================
-- [Yehor] Таблиця classes: вставка, невалідні INSERT, UPDATE, DELETE
-- ================================================================
-- Порядок: classes виконується ПІСЛЯ вставки trainers [Oksana],
-- бо classes посилається на trainers через FOREIGN KEY.
--
-- trainer_id НЕ прописаний числами: він шукається за email
-- (UNIQUE у trainers). Так скрипт не залежить від того, які id
-- згенерує IDENTITY, а якщо email зміниться, INSERT впаде з помилкою
-- NOT NULL, а не прив'яже заняття до чужого тренера.
-- ================================================================


-- ================================================
-- [Yehor] classes: вставка валідних даних (12 записів)
-- ================================================
-- Обмеження UNIQUE (trainer_id, schedule_datetime): один тренер
-- не може вести два заняття в один і той самий час.
-- Різні тренери можуть мати заняття в один час (напр. 2026-10-12 10:00).
-- Деякі тренери мають по 2 заняття в різний час (зв'язок one-to-many).
INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
VALUES
  -- Андрій Мельник: силові напрямки
  ('Силове тренування',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
   '2026-10-12 10:00:00'),
  ('Кросфіт',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
   '2026-10-14 18:00:00'),

  -- Ірина Ткаченко: йога
  ('Йога для початківців',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'i.tkachenko@example.com'),
   '2026-10-12 10:00:00'),
  ('Хатха-йога',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'i.tkachenko@example.com'),
   '2026-10-13 19:00:00'),

  -- Владислав Кравченко: бокс
  ('Бокс',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'v.kravchenko@example.com'),
   '2026-10-13 20:00:00'),

  -- Марія Олійник: пілатес
  ('Пілатес',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'm.oliinyk@example.com'),
   '2026-10-15 09:00:00'),

  -- Богдан Лисенко: спінінг
  ('Спінінг',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'b.lysenko@example.com'),
   '2026-10-15 19:30:00'),

  -- Катерина Бойко: зумба
  ('Зумба',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'k.boiko@example.com'),
   '2026-10-16 18:00:00'),

  -- Дмитро Савченко: TRX
  ('TRX-тренування',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'd.savchenko@example.com'),
   '2026-10-17 11:00:00'),

  -- Олена Романюк (тепер Тарасюк): стретчинг
  ('Стретчинг',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'o.romaniuk@example.com'),
   '2026-10-17 12:30:00'),

  -- Наталія Ковальчук: аеробіка
  ('Аеробіка',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'n.kovalchuk@example.com'),
   '2026-10-18 10:00:00'),

  -- Сергій Поліщук: кардіо
  ('Кардіо-інтервали',
   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 's.polishchuk@example.com'),
   '2026-10-18 17:00:00');


-- ================================================
-- [Yehor] Невалідні INSERT (кожен має давати помилку)
-- Запускати по одному, прибравши -- перед рядками
-- ================================================

-- 1. Дублікат: той самий тренер у той самий час
-- Очікується: duplicate key value violates unique constraint "uq_classes_trainer_schedule"
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES (
--   'Дублікат заняття',
--   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
--   '2026-10-12 10:00:00');

-- 2. Неіснуючий тренер (trainer_id, якого немає в trainers)
-- Очікується: violates foreign key constraint "fk_classes_trainer"
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES ('Заняття без тренера', 99999, '2026-10-20 10:00:00');

-- 3. Відсутня назва заняття
-- Очікується: null value in column "class_name" violates not-null constraint
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES (
--   NULL,
--   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
--   '2026-10-20 10:00:00');

-- 4. Відсутній тренер
-- Очікується: null value in column "trainer_id" violates not-null constraint
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES ('Заняття без тренера', NULL, '2026-10-20 10:00:00');

-- 5. Відсутні дата й час заняття
-- Очікується: null value in column "schedule_datetime" violates not-null constraint
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES (
--   'Заняття без часу',
--   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
--   NULL);

-- 6. Назва довша за 100 символів
-- Очікується: value too long for type character varying(100)
-- INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
-- VALUES (
--   repeat('Я', 101),
--   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
--   '2026-10-20 10:00:00');

-- 7. Ручне значення для class_id (GENERATED ALWAYS AS IDENTITY)
-- Очікується: cannot insert a non-DEFAULT value into column "class_id"
-- INSERT INTO fitness_center_team4.classes (class_id, class_name, trainer_id, schedule_datetime)
-- VALUES (
--   1000,
--   'Заняття з ручним id',
--   (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com'),
--   '2026-10-20 10:00:00');


-- ================================================
-- [Yehor] UPDATE: перенесення та зміна занять
-- ================================================

-- Перенести "Бокс" Владислава Кравченка на інший час.
-- Умова за назвою і тренером, щоб змінився лише один рядок.
UPDATE fitness_center_team4.classes
SET schedule_datetime = '2026-10-13 21:00:00'
WHERE class_name = 'Бокс'
  AND trainer_id = (SELECT trainer_id FROM fitness_center_team4.trainers
                    WHERE email = 'v.kravchenko@example.com')
RETURNING class_id, class_name, schedule_datetime;

-- Перейменувати "Зумба" на "Зумба фітнес".
UPDATE fitness_center_team4.classes
SET class_name = 'Зумба фітнес'
WHERE class_name = 'Зумба'
  AND trainer_id = (SELECT trainer_id FROM fitness_center_team4.trainers
                    WHERE email = 'k.boiko@example.com')
RETURNING class_id, class_name, trainer_id;

-- Замінити тренера: "Аеробіку" замість Наталії Ковальчук тепер веде Марія Олійник.
-- Новий час Марії (2026-10-18 10:00) вільний, тому UNIQUE не порушується.
UPDATE fitness_center_team4.classes
SET trainer_id = (SELECT trainer_id FROM fitness_center_team4.trainers
                  WHERE email = 'm.oliinyk@example.com')
WHERE class_name = 'Аеробіка'
  AND trainer_id = (SELECT trainer_id FROM fitness_center_team4.trainers
                    WHERE email = 'n.kovalchuk@example.com')
RETURNING class_id, class_name, trainer_id;

-- Невалідний UPDATE: перенос на час, коли тренер уже зайнятий
-- (Андрій Мельник о 2026-10-12 10:00 веде "Силове тренування").
-- Очікується: duplicate key value violates unique constraint "uq_classes_trainer_schedule"
-- UPDATE fitness_center_team4.classes
-- SET schedule_datetime = '2026-10-12 10:00:00'
-- WHERE class_name = 'Кросфіт';


-- ================================================
-- [Yehor] DELETE: видалення тестового заняття
-- ================================================
-- Реальні заняття, на які вже є записи в attendance, видаляти не можна:
-- це зламає історію відвідувань (FOREIGN KEY fk_attendance_class).
-- DELETE доречний лише для помилково створених занять без відвідувань.

-- Створюємо тестове заняття, яке не має зв'язків з attendance
INSERT INTO fitness_center_team4.classes (class_name, trainer_id, schedule_datetime)
VALUES (
  'Тестове заняття',
  (SELECT trainer_id FROM fitness_center_team4.trainers WHERE email = 'r.moroz@example.com'),
  '2026-12-31 23:00:00');

-- Видаляємо його; RETURNING показує, що саме видалено
DELETE FROM fitness_center_team4.classes
WHERE class_name = 'Тестове заняття'
  AND schedule_datetime = '2026-12-31 23:00:00'
RETURNING class_id, class_name, trainer_id;

-- Перевірка: має повернути 0 рядків
SELECT * FROM fitness_center_team4.classes
WHERE class_name = 'Тестове заняття';

-- Заняття, на яке є записи в attendance, видалити НЕ можна.
-- Очікується (після того як Vasyl додасть дані в attendance):
-- violates foreign key constraint "fk_attendance_class" on table "attendance"
-- DELETE FROM fitness_center_team4.classes WHERE class_name = 'Силове тренування';

-- Тренера, у якого є заняття, видалити НЕ можна.
-- Очікується: violates foreign key constraint "fk_classes_trainer" on table "classes"
-- DELETE FROM fitness_center_team4.trainers WHERE email = 'a.melnyk@example.com';


-- ================================================
-- [Yehor] Перевірка результату
-- ================================================
-- Очікується: 12 занять
SELECT COUNT(*) AS classes_count
FROM fitness_center_team4.classes;

-- Заняття з іменами тренерів
SELECT c.class_id,
       c.class_name,
       t.first_name || ' ' || t.last_name AS trainer_name,
       c.schedule_datetime
FROM fitness_center_team4.classes AS c
JOIN fitness_center_team4.trainers AS t ON t.trainer_id = c.trainer_id
ORDER BY c.schedule_datetime, c.class_id;
