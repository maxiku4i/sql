-- Задание 1: Фильмы со специальным атрибутом "Behind the Scenes"
SELECT *
FROM film
WHERE special_features @> '{"Behind the Scenes"}';
-- Задание 2:
-- Вариант 2: Использование функции unnest
SELECT *
FROM film
WHERE 'Behind the Scenes' IN (SELECT unnest(special_features));
-- Вариант 3: Использование функции array_position
SELECT *
FROM film
WHERE array_position(special_features, 'Behind the Scenes') IS NOT NULL;
-- Задание 3: Использование CTE для подсчета аренды фильмов со специальным атрибутом "Behind the Scenes"
WITH behind_the_scenes_films AS (
    SELECT film_id
    FROM film
    WHERE special_features @> '{"Behind the Scenes"}'
)
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN behind_the_scenes_films ON inventory.film_id = behind_the_scenes_films.film_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY rental_count DESC;
-- Задание 4: Использование подзапроса для подсчета аренды фильмов со специальным атрибутом "Behind the Scenes"
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN (
    SELECT film_id
    FROM film
    WHERE special_features @> '{"Behind the Scenes"}'
) AS behind_the_scenes_films ON inventory.film_id = behind_the_scenes_films.film_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY rental_count DESC;
-- Задание 5: Создание материализованного представления
CREATE MATERIALIZED VIEW customer_behind_the_scenes_rentals AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS num_behind_the_scenes_rentals
FROM
    customer c
JOIN
    rental r ON c.customer_id = r.customer_id
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN
    film f ON i.film_id = f.film_id
WHERE
    f.special_features::text LIKE '%Behind the Scenes%'
GROUP BY
    c.customer_id, c.first_name, c.last_name;
-- Задание 6: Анализ скорости выполнения запросов с использованием CTE
EXPLAIN ANALYZE
WITH behind_the_scenes_films AS (
    SELECT film_id
    FROM film
    WHERE special_features @> '{"Behind the Scenes"}'
)
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN behind_the_scenes_films ON inventory.film_id = behind_the_scenes_films.film_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY rental_count DESC;

-- Анализ скорости выполнения запросов с использованием подзапроса
EXPLAIN ANALYZE
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN (
    SELECT film_id
    FROM film
    WHERE special_features @> '{"Behind the Scenes"}'
) AS behind_the_scenes_films ON inventory.film_id = behind_the_scenes_films.film_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY rental_count DESC;
-- Задание 7: Сведения о первой продаже каждого сотрудника
SELECT staff_id, payment_id, amount, payment_date
FROM (
    SELECT staff_id, payment_id, amount, payment_date,
           ROW_NUMBER() OVER (PARTITION BY staff_id ORDER BY payment_date) AS row_num
    FROM payment
) AS first_sales
WHERE row_num = 1;





