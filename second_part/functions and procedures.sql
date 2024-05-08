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
-- CALL CalculateOrderTotalCost(1); - пример вызова.

-- Функцию, выводящая какие ингридиенты и в каких количествах нужны для выполнения этого заказа:
CREATE OR REPLACE FUNCTION GetIngredientsForOrder(order_id INTEGER)
RETURNS TABLE (
    ingredient_name VARCHAR(255),
    ingredient_quantity INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.ingredient_name,
        oxd.quantity AS ingredient_quantity
    FROM
        restaurant.Orders_x_Dishes oxd
    JOIN
        restaurant.Dishes_x_Ingredients dxi ON oxd.dish_id = dxi.dish_id
    JOIN
        restaurant.Ingredients i ON dxi.ingredient_id = i.ingredient_id
    WHERE
        oxd.order_id = GetIngredientsForOrder.order_id;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM GetIngredientsForOrder(1);- пример вызова.

