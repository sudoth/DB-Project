-- Индексы для увеличения скорости запросов в таблице Orders:
CREATE INDEX ON restaurant.Orders(order_date);
CREATE INDEX ON restaurant.Orders(client_id);


-- Индексы для увеличения скорости запросов в таблице Ingredients:
CREATE INDEX ON restaurant.Ingredients(ingredient_name);
CREATE INDEX ON restaurant.Ingredients(delivery_date);
CREATE INDEX ON restaurant.Ingredients(expiry_date);


-- Индексы для увеличения скорости запросов в таблице Dishes:
CREATE INDEX ON restaurant.Dishes(dish_name);
CREATE INDEX ON restaurant.Dishes(dish_category);


-- Индексы для увеличения скорости запросов в таблице Staff:
CREATE INDEX ON restaurant.Staff(staff_phone_number);


-- Индексы для увеличения скорости запросов в таблице Reviews:
CREATE INDEX ON restaurant.Reviews(review_date);
CREATE INDEX ON restaurant.Clients(client_surname);
