-- Запрос на вывод списка клиентов, оставивших отзывы с оценкой 5:
SELECT 
  c.client_name,
  r.review_text,
  r.review_rating
FROM 
  restaurant.Clients c
JOIN 
  restaurant.Reviews r ON c.client_id = r.client_id
WHERE 
  r.review_rating = 5;


-- Запрос на вывод списка блюд категории "Итальянская кухня" и их покупаемости: 
SELECT
  dish_name,
  dish_description,
  (SELECT COUNT(*) 
    FROM
      restaurant.Orders_x_Dishes 
    WHERE
      dish_id = Dishes.dish_id) AS total_orders
FROM
  restaurant.Dishes
WHERE
  dish_category = 'Японская кухня';


-- Запрос на вывод средней зарплаты по каждой профессии:
SELECT 
  p.profession_name,
  AVG(p.profession_salary) AS avg_salary
FROM 
  restaurant.Professions p
JOIN 
  restaurant.Staff s ON p.profession_id = s.profession_id
GROUP BY 
  p.profession_name;


-- Запрос на вывод количества заказов, сделанных каждым сотрудником за последний месяц:
SELECT 
  s.staff_id,
  s.staff_name,
  s.staff_surname,
  COUNT(o.order_id) AS total_orders
FROM 
  restaurant.Staff s
JOIN 
  restaurant.Orders o ON s.staff_id = o.staff_id
WHERE 
  o.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 
  s.staff_id, s.staff_name
ORDER BY 
  total_orders DESC;


--Список из десяти самых продаваемых блюд:
SELECT
  d.dish_name,
  d.dish_description,
  SUM(od.quantity) AS total_sold
FROM
  restaurant.Dishes d
JOIN
  restaurant.Orders_x_Dishes od ON d.dish_id = od.dish_id
GROUP BY
  d.dish_name,
  d.dish_description
ORDER BY
  total_sold DESC
LIMIT 10;


-- Список наиболее часто покупаемой категорий блюд и общее количество заказов по этой категории:
SELECT
  d.dish_category,
  COUNT(*) AS total_orders
FROM
  restaurant.Orders_x_Dishes od
JOIN
  restaurant.Dishes d ON od.dish_id = d.dish_id
GROUP BY
  d.dish_category
ORDER BY
  total_orders DESC
LIMIT 5;


-- Количетсво клиентов по возрастным группам:
SELECT 
  CASE
    WHEN client_age BETWEEN 18 AND 30 THEN '18-30'
    WHEN client_age BETWEEN 31 AND 40 THEN '31-40'
    WHEN client_age BETWEEN 41 AND 50 THEN '41-50'
   ELSE '50+'
  END AS age_group,
  COUNT(*) AS total_clients
FROM
  restaurant.Clients
GROUP BY
  age_group
ORDER BY
  age_group;


-- Срдений вес блюд по категориям:
SELECT 
  d.dish_category,
  AVG(d.dish_weight) AS avg_dish_weight
FROM
  restaurant.Dishes d
JOIN
  restaurant.Dishes_x_Ingredients di ON d.dish_id = di.dish_id
GROUP BY 
  d.dish_category
ORDER BY
  avg_dish_weight DESC;


-- Список клиентов, заказавших блюда итальянской кухни:
SELECT DISTINCT 
  c.client_id, c.client_name, c.client_surname
FROM
  restaurant.Clients c
JOIN
  restaurant.Orders o ON c.client_id = o.client_id
JOIN
  restaurant.Orders_x_Dishes od ON o.order_id = od.order_id
WHERE 
  od.dish_id IN (
    SELECT
      dish_id 
    FROM
      restaurant.Dishes 
    WHERE
      dish_category = 'Итальянская кухня'
  )
ORDER BY
  client_id;



-- Вот запрос на вывод самых дорогих ингредиентов и их поставщиков:
SELECT
    i.ingredient_name,
    i.ingredient_price,
    i.supplier_id,
    s.supplier_name
FROM
    restaurant.Ingredients i
JOIN
    restaurant.Suppliers s ON i.supplier_id = s.supplier_id
ORDER BY
    i.ingredient_price DESC
LIMIT 10;
