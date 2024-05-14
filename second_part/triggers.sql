-- Функция, обновляющая общую стоимость заказа:
CREATE OR REPLACE FUNCTION update_order_total_cost()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE restaurant.Orders
  SET order_total_cost = (
    SELECT SUM(dish_price * quantity)
    FROM restaurant.Orders_x_Dishes
    JOIN restaurant.Dishes ON restaurant.Orders_x_Dishes.dish_id = restaurant.Dishes.dish_id
    WHERE order_id = NEW.order_id
  )
  WHERE order_id = NEW.order_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер, вызывающий функцию update_order_total_cost():
CREATE OR REPLACE TRIGGER update_order_total_cost_trigger
AFTER INSERT OR UPDATE OR DELETE ON restaurant.Orders_x_Dishes
FOR EACH ROW
EXECUTE FUNCTION update_order_total_cost();


-- Функция, обновляющая количество ингредиентов на складе:
CREATE OR REPLACE FUNCTION update_inventory_on_order_insert()
RETURNS TRIGGER AS
$$
DECLARE
  v_total_weight INTEGER;
  v_total_quantity INTEGER;
BEGIN
  SELECT SUM(d.dish_weight * oxd.quantity)
  INTO v_total_weight
  FROM restaurant.Dishes d
  JOIN restaurant.Orders_x_Dishes oxd ON d.dish_id = oxd.dish_id
  WHERE oxd.order_id = NEW.order_id;

  SELECT SUM(oxd.quantity)
  INTO v_total_quantity
  FROM restaurant.Orders_x_Dishes oxd
  WHERE oxd.order_id = NEW.order_id;

  UPDATE restaurant.Ingredients
  SET ingredient_weight = ingredient_weight - v_total_weight / v_total_quantity
  WHERE ingredient_id IN (
    SELECT di.ingredient_id
    FROM restaurant.Dishes_x_Ingredients di
    JOIN restaurant.Orders_x_Dishes oxd ON di.dish_id = oxd.dish_id
    WHERE oxd.order_id = NEW.order_id
  );

  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Триггер, вызывающий функцию update_inventory_on_order_insert():
CREATE TRIGGER update_inventory_trigger
AFTER INSERT OR UPDATE OR DELETE ON restaurant.Orders_x_Dishes
FOR EACH ROW
EXECUTE FUNCTION update_inventory_on_order_insert();
