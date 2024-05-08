CREATE SCHEMA restaurant;

CREATE TABLE restaurant.Professions (
  profession_id SERIAL PRIMARY KEY,
  profession_name VARCHAR(255) NOT NULL,
  profession_salary INTEGER NOT NULL,
  profession_start_t TIME NOT NULL,
  profession_end_t TIME NOT NULL
);

CREATE TABLE restaurant.Suppliers (
  supplier_id SERIAL PRIMARY KEY,
  supplier_name VARCHAR(255) NOT NULL,
  supplier_rating INTEGER NOT NULL,
  supplier_comment VARCHAR(255) NOT NULL
);

CREATE TABLE restaurant.Ingredients (
  ingredient_id SERIAL PRIMARY KEY,
  ingredient_name VARCHAR(255) NOT NULL,
  ingredient_price INTEGER NOT NULL,
  ingredient_description VARCHAR(255) NOT NULL,
  ingredient_weight INTEGER NOT NULL,
  supplier_id INTEGER REFERENCES restaurant.Suppliers(supplier_id),
  delivery_date DATE NOT NULL,
  expiry_date DATE NOT NULL
);

CREATE TABLE restaurant.Clients (
  client_id SERIAL PRIMARY KEY,
  client_name VARCHAR(255) NOT NULL,
  client_surname VARCHAR(255) NOT NULL,
  client_table_number INTEGER NOT NULL,
  client_age INTEGER NOT NULL
);

CREATE TABLE restaurant.Staff (
  staff_id SERIAL PRIMARY KEY,
  staff_name VARCHAR(255) NOT NULL,
  staff_surname VARCHAR(255) NOT NULL,
  profession_id INTEGER REFERENCES restaurant.Professions(profession_id),
  staff_phone_number VARCHAR(255) NOT NULL
);

CREATE TABLE restaurant.Orders (
  order_id SERIAL PRIMARY KEY,
  order_date TIMESTAMP NOT NULL,
  client_id INTEGER REFERENCES restaurant.Clients(client_id),
  staff_id INTEGER REFERENCES restaurant.Staff(staff_id),
  order_total_cost INTEGER NOT NULL
);

CREATE TABLE restaurant.Dishes (
  dish_id SERIAL PRIMARY KEY,
  dish_name VARCHAR(255) NOT NULL,
  dish_description VARCHAR(255) NOT NULL,
  dish_price INTEGER NOT NULL,
  dish_category VARCHAR(255) NOT NULL,
  dish_weight INTEGER NOT NULL,
  effective_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  is_current BOOLEAN NOT NULL
);

CREATE TABLE restaurant.Orders_x_Dishes (
  order_id INTEGER REFERENCES restaurant.Orders(order_id),
  dish_id INTEGER REFERENCES restaurant.Dishes(dish_id),
  quantity INTEGER NOT NULL,
  PRIMARY KEY (order_id, dish_id)
);

CREATE TABLE restaurant.Reviews (
  review_id SERIAL PRIMARY KEY,
  review_date TIMESTAMP NOT NULL,
  review_rating INTEGER NOT NULL,
  review_text VARCHAR(255) NOT NULL,
  client_id INTEGER REFERENCES restaurant.Clients(client_id)
);

CREATE TABLE restaurant.Dishes_x_Ingredients (
  dish_id INTEGER REFERENCES restaurant.Dishes(dish_id),
  ingredient_id INTEGER REFERENCES restaurant.Ingredients(ingredient_id),
  ingredient_weight INTEGER NOT NULL,
  PRIMARY KEY (dish_id, ingredient_id)
);