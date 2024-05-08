-- Представление для более удобного управления персоналом:
CREATE VIEW ManagementStaff AS
SELECT
  s.staff_id,
  s.staff_name,
  s.staff_surname,
  p.profession_name,
  p.profession_salary,
  p.profession_start_t,
  p.profession_end_t
FROM
  restaurant.Staff s
JOIN
  restaurant.Professions p ON s.profession_id = p.profession_id;


-- Представление для аналитики отзывов клиентов:
CREATE VIEW AnalyticsReviews AS
SELECT
  r.review_id,
  r.review_date,
  r.review_rating,
  r.review_text,
  c.client_name,
  c.client_surname
FROM
  restaurant.Reviews r
JOIN
  restaurant.Clients c ON r.client_id = c.client_id;


-- Представление для оценки стоимости каждого элемента меню:
CREATE VIEW MenuItemCosts AS
SELECT
  d.dish_id,
  d.dish_name,
  d.dish_price AS selling_price,
  SUM(i.ingredient_price) AS total_cost,
  ARRAY_AGG(i.ingredient_name) AS ingredients
FROM
  restaurant.Dishes d
JOIN
  restaurant.Dishes_x_Ingredients dx ON d.dish_id = dx.dish_id
JOIN
  restaurant.Ingredients i ON dx.ingredient_id = i.ingredient_id
GROUP BY
  d.dish_id, d.dish_name, d.dish_price;


-- Представление для удобной работы с заказами:
CREATE VIEW OrdersInfo AS
SELECT 
  o.order_id,
  o.order_date,
  c.client_name,
  c.client_surname,
  s.staff_name,
  s.staff_surname,
  d.dish_name,
  d.dish_description,
  d.dish_price,
  o.order_total_cost
FROM 
  restaurant.Orders o
JOIN 
  restaurant.Clients c ON o.client_id = c.client_id
JOIN 
  restaurant.Staff s ON o.staff_id = s.staff_id
JOIN 
  restaurant.Orders_x_Dishes od ON o.order_id = od.order_id
JOIN 
  restaurant.Dishes d ON od.dish_id = d.dish_id;
