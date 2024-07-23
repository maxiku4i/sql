-- Задание 1: Оконные функции в таблице payment
SELECT 
  payment_id,
  customer_id,
  amount,
  payment_date,
  ROW_NUMBER() OVER (ORDER BY payment_date) AS payment_number_overall,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS payment_number_per_customer,
  SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date, amount) AS running_total_per_customer,
  DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS rank_by_amount_per_customer
FROM payment;
-- Задание 2: Стоимость платежа и стоимость предыдущего платежа
SELECT 
  payment_id,
  customer_id,
  amount,
  payment_date,
  LAG(amount, 1, 0.0) OVER (PARTITION BY customer_id ORDER BY payment_date) AS previous_payment
FROM payment;
-- Задание 3: Разница между текущим и предыдущим платежом
SELECT 
  payment_id,
  customer_id,
  amount,
  payment_date,
  amount - LAG(amount, 1, 0.0) OVER (PARTITION BY customer_id ORDER BY payment_date) AS difference_from_previous
FROM payment;
-- Задание 4: Данные о последней оплате аренды
SELECT 
  payment_id,
  customer_id,
  amount,
  payment_date
FROM (
  SELECT 
    payment_id,
    customer_id,
    amount,
    payment_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS rnk
  FROM payment
) sub
WHERE rnk = 1;
-- Задание 5: Сумма продаж за август 2005 года с нарастающим итогом
SELECT 
  staff_id,
  DATE(payment_date) AS payment_date,
  SUM(amount) OVER (PARTITION BY staff_id ORDER BY DATE(payment_date)) AS running_total
FROM payment
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31';
-- Задание 6: Покупатели, получившие скидку 20 августа 2005 года
WITH numbered_payments AS (
  SELECT 
    customer_id,
    payment_date,
    ROW_NUMBER() OVER (ORDER BY payment_date) AS payment_number
  FROM payment
  WHERE payment_date::date = '2005-08-20'
)
SELECT 
  customer_id,
  payment_date
FROM numbered_payments
WHERE payment_number % 100 = 0;
-- Задание 7: Покупатели для каждой страны по заданным условиям
WITH rental_counts AS (
  SELECT 
    c.customer_id,
    ct.country,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_amount,
    MAX(r.rental_date) AS last_rental_date,
    ROW_NUMBER() OVER (PARTITION BY ct.country ORDER BY COUNT(r.rental_id) DESC) AS most_rentals_rnk,
    ROW_NUMBER() OVER (PARTITION BY ct.country ORDER BY SUM(p.amount) DESC) AS highest_amount_rnk,
    ROW_NUMBER() OVER (PARTITION BY ct.country ORDER BY MAX(r.rental_date) DESC) AS last_rental_rnk
  FROM customer c
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country ct ON ci.country_id = ct.country_id
  JOIN rental r ON c.customer_id = r.customer_id
  JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY c.customer_id, ct.country
)
SELECT 
  country,
  customer_id,
  rental_count,
  total_amount,
  last_rental_date
FROM rental_counts
WHERE most_rentals_rnk = 1
   OR highest_amount_rnk = 1
   OR last_rental_rnk = 1
ORDER BY country, most_rentals_rnk, highest_amount_rnk, last_rental_rnk;
