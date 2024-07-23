-- Задание 1: Выведите уникальные названия городов из таблицы городов
SELECT DISTINCT city 
FROM city;
-- Задание 2: Города, начинающиеся на "L" и заканчивающиеся на "a", без пробелов
SELECT DISTINCT city 
FROM city
WHERE city LIKE 'L%a'
AND city NOT LIKE '% %';
-- Задание 3: Платежи с 17 июня 2005 года по 19 июня 2005 года включительно и стоимостью более 1.00
SELECT payment_id, customer_id, rental_id, amount, payment_date 
FROM payment 
WHERE payment_date BETWEEN '2005-06-17' AND '2005-06-19'
AND amount > 1.00
ORDER BY payment_date;
-- Задание 4: 10 последних платежей за прокат фильмов
SELECT payment_id, customer_id, rental_id, amount, payment_date 
FROM payment 
ORDER BY payment_date DESC 
LIMIT 10;
-- Задание 5: Информация по покупателям
SELECT 
  CONCAT(last_name, ' ', first_name) AS "Фамилия и имя",
  email AS "Электронная почта",
  LENGTH(email) AS "Длина email",
  DATE(last_update) AS "Дата последнего обновления"
FROM customer;
-- Задание 6: Активные покупатели с именами KELLY или WILLIE, переведенные в нижний регистр
SELECT 
  LOWER(first_name) AS "имя",
  LOWER(last_name) AS "фамилия"
FROM customer
WHERE active = 1
AND (first_name = 'KELLY' OR first_name = 'WILLIE');
-- Задание 7: Фильмы с рейтингом “R” и стоимостью аренды от 0.00 до 3.00 включительно и фильмы с рейтингом “PG-13” и стоимостью аренды >= 4.00
SELECT title, rating, rental_rate 
FROM film 
WHERE (rating = 'R' AND rental_rate BETWEEN 0.00 AND 3.00)
OR (rating = 'PG-13' AND rental_rate >= 4.00);
-- Задание 8: Три фильма с самым длинным описанием
SELECT title, description 
FROM film 
ORDER BY LENGTH(description) DESC 
LIMIT 3;
-- Задание 9: Разделить Email на две колонки
SELECT 
  split_part(email, '@', 1) AS "Email до @",
  split_part(email, '@', 2) AS "Email после @"
FROM customer;
-- Задание 10: Разделить Email и скорректировать значения
SELECT 
  initcap(lower(split_part(email, '@', 1))) AS "Email до @",
  initcap(lower(split_part(email, '@', 2))) AS "Email после @"
FROM customer;

