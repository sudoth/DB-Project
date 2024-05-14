-- Процедура для подсчета суммарной стоимости заказа:
CREATE OR REPLACE PROCEDURE CalculateOrderTotalCost(order_id_input INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
  total_cost INTEGER;
BEGIN
  total_cost := 0;

  SELECT SUM(d.dish_price * od.quantity)
  INTO total_cost
  FROM restaurant.Orders_x_Dishes od
  JOIN restaurant.Dishes d ON od.dish_id = d.dish_id
  WHERE od.order_id = order_id_input;

  RAISE NOTICE 'Суммарная стоимость заказа с идентификатором % составляет % рублей', order_id_input, total_cost;
END;
$$;
-- Пример вызова функции: CALL CalculateOrderTotalCost(1); 


-- Функция, возвращающая прибыль ресторана за заданный промежуток времени:
CREATE OR REPLACE FUNCTION calculate_profit_for_period(start_date DATE, end_date DATE) RETURNS INTEGER AS $$
DECLARE
  period_profit INTEGER;
BEGIN
  SELECT SUM(order_total_cost)
  INTO period_profit
  FROM restaurant.Orders
  WHERE order_date >= start_date AND order_date <= end_date;

  RETURN period_profit;
END;
$$ LANGUAGE plpgsql;
-- Пример вызова функции:
-- SELECT calculate_profit_for_period('2024-04-19', '2024-05-05');


-- Функция, добавляющая новый заказ:
CREATE OR REPLACE FUNCTION insert_order_with_dishes(
  p_client_id INTEGER,
  p_staff_id INTEGER,
  p_dish_ids INTEGER[]
)
RETURNS VOID AS $$
DECLARE
  v_order_id INTEGER;
  v_dish_id INTEGER;
BEGIN
  INSERT INTO restaurant.Orders (order_date, client_id, staff_id, order_total_cost)
  VALUES (CURRENT_TIMESTAMP, p_client_id, p_staff_id, -1)
  RETURNING order_id INTO v_order_id;
  
  FOREACH v_dish_id IN ARRAY p_dish_ids LOOP
    INSERT INTO restaurant.Orders_x_Dishes (order_id, dish_id, quantity)
    VALUES (v_order_id, v_dish_id, 1);
  END LOOP;
END;
$$
LANGUAGE plpgsql;
-- Пример вызова функции:
-- SELECT insert_order_with_dishes(1, 10, ARRAY[1, 3, 5]::INTEGER[]);