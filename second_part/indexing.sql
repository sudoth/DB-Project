CREATE INDEX ON restaurant.Orders(order_date);
CREATE INDEX ON restaurant.Orders(client_id);

CREATE INDEX ON restaurant.Ingredients(ingredient_name);
CREATE INDEX ON restaurant.Ingredients(delivery_date);
CREATE INDEX ON restaurant.Ingredients(expiry_date);

CREATE INDEX ON restaurant.Dishes(dish_name);
CREATE INDEX ON restaurant.Dishes(dish_category);

CREATE INDEX ON restaurant.Staff(staff_phone_number);

CREATE INDEX ON restaurant.Reviews(review_date);
CREATE INDEX ON restaurant.Clients(client_surname);
