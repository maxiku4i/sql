-- Задание 1: Адрес, город и страна проживания каждого покупателя
SELECT 
  c.customer_id,
  c.first_name || ' ' || c.last_name AS full_name,
  a.address,
  a.address2,
  ct.city,
  co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id;
-- Задание 2.1: Количество покупателей для каждого магазина
SELECT 
  s.store_id,
  COUNT(c.customer_id) AS customer_count
FROM store s
JOIN customer c ON s.store_id = c.store_id
GROUP BY s.store_id;
-- Задание 2.2: Магазины с количеством покупателей больше 300
SELECT 
  s.store_id,
  COUNT(c.customer_id) AS customer_count
FROM store s
JOIN customer c ON s.store_id = c.store_id
GROUP BY s.store_id
HAVING COUNT(c.customer_id) > 300;
-- Задание 2.3: Информация о магазинах с количеством покупателей больше 300, включая город и продавца
SELECT 
  s.store_id,
  ct.city,
  COUNT(c.customer_id) AS customer_count,
  st.first_name AS staff_first_name,
  st.last_name AS staff_last_name
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN staff st ON s.manager_staff_id = st.staff_id
GROUP BY s.store_id, ct.city, st.first_name, st.last_name
HAVING COUNT(c.customer_id) > 300;
-- Задание 3: Топ-5 покупателей по количеству арендованных фильмов
SELECT 
  c.customer_id,
  c.first_name || ' ' || c.last_name AS full_name,
  COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC
LIMIT 5;
-- Задание 4: Аналитические показатели для каждого покупателя
SELECT 
  c.customer_id,
  c.first_name || ' ' || c.last_name AS full_name,
  COUNT(r.rental_id) AS total_rentals,
  ROUND(SUM(p.amount)) AS total_payment,
  MIN(p.amount) AS min_payment,
  MAX(p.amount) AS max_payment
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name;
-- Задание 5: Пары городов без одинаковых названий
SELECT 
  c1.city AS city1,
  c2.city AS city2
FROM city c1
CROSS JOIN city c2
WHERE c1.city <> c2.city;
-- Задание 6: Среднее количество дней возврата фильмов для каждого покупателя
SELECT 
  c.customer_id,
  c.first_name || ' ' || c.last_name AS full_name,
  AVG(EXTRACT(DAY FROM (r.return_date - r.rental_date))) AS avg_return_days
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
-- Задание 8: Фильмы, которые ни разу не брали в аренду
SELECT 
  f.film_id,
  f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;
-- Задание 9: Количество продаж каждого продавца и колонка "Премия"
SELECT 
  st.staff_id,
  st.first_name || ' ' || st.last_name AS full_name,
  COUNT(p.payment_id) AS total_sales,
  CASE 
    WHEN COUNT(p.payment_id) > 7300 THEN 'Да'
    ELSE 'Нет'
  END AS "Премия"
FROM staff st
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY st.staff_id, st.first_name, st.last_name;
