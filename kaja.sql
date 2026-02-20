CREATE DATABASE my_database;
USE my_database;
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(255),
  phone VARCHAR(50),
  address TEXT,
  role ENUM('customer', 'admin', 'restaurant_owner') DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurants (
  restaurant_id INT PRIMARY KEY,
  owner_id INT NOT NULL,
  name VARCHAR(255),
  description TEXT,
  address TEXT,
  phone VARCHAR(50),
  open_hours VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE dishes (
  dish_id INT PRIMARY KEY,
  restaurant_id INT NOT NULL,
  name VARCHAR(255),
  description TEXT,
  price DECIMAL(10,2),
  image_url VARCHAR(255),
  available BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT NOT NULL,
  restaurant_id INT NOT NULL,
  status ENUM('pending', 'preparing', 'delivering', 'completed', 'cancelled') DEFAULT 'pending',
  total_price DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  dish_id INT NOT NULL,
  quantity INT,
  price DECIMAL(10,2),
  CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_dish FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
);

CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  amount DECIMAL(10,2),
  method ENUM('card', 'cash', 'paypal'),
  status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO users (user_id, name, email, password_hash, phone, address, role, created_at) VALUES
(1, 'KLSZ', 'klsz@gmail.com', 'klsz12345', '+36201234567', 'Budapest, Fő utca 1.', 'restaurant_owner', CURRENT_TIMESTAMP);

INSERT INTO restaurants (restaurant_id, owner_id, name, description, address, phone, open_hours, created_at) VALUES
(1, 1, 'KLSZ', 'Kedvenc helyed pizzára, burgerekre és desszertekre!', 'Budapest, Fő utca 2.', '+36201234568', 'H-V: 11:00 - 22:00', CURRENT_TIMESTAMP);

INSERT INTO dishes (dish_id, restaurant_id, name, description, price, image_url, available) VALUES
(1, 1, 'Margherita Pizza', 'Paradicsomszósz, mozzarella, friss bazsalikom', 2290.00, '', TRUE),
(2, 1, 'Pepperoni Pizza', 'Paradicsomszósz, mozzarella, pepperoni kolbász', 2490.00, '', TRUE),
(3, 1, 'Hawaii Pizza', 'Paradicsomszósz, sonka, ananász, mozzarella', 2390.00, '', TRUE),
(4, 1, 'Négysajtos Pizza', 'Mozzarella, gorgonzola, parmezán, edami', 2590.00, '', TRUE),
(5, 1, 'Classic Hamburger', 'Marhahúspogácsa, saláta, paradicsom, uborka, szósz', 1890.00, '', TRUE),
(6, 1, 'Cheeseburger', 'Marhahús, cheddar sajt, saláta, paradicsom, ketchup', 1990.00, '', TRUE),
(7, 1, 'Bacon Burger', 'Marhahús, bacon, cheddar, pirított hagyma, BBQ szósz', 2190.00, '', TRUE),
(8, 1, 'Vega Burger', 'Zöldségpogácsa, saláta, paradicsom, vegán majonéz', 1790.00, '', TRUE),
(9, 1, 'Sült krumpli', 'Klasszikus hasábburgonya', 790.00, '', TRUE),
(10, 1, 'Sajtos sült krumpli', 'Ropogós krumpli olvasztott sajttal', 990.00, '', TRUE),
(11, 1, 'BBQ sült krumpli', 'Hasábburgonya BBQ szósszal és baconnel', 1090.00, '', TRUE),
(12, 1, 'Csokoládétorta szelet', 'Gazdag, csokis tortaszelet tejszínhabbal', 990.00, '', TRUE),
(13, 1, 'Tiramisu', 'Klasszikus olasz desszert kávéval és mascarponeval', 1190.00, '', TRUE),
(14, 1, 'Fagylalt kehely', '3 gombóc fagylalt, öntet és tejszínhab', 890.00, '', TRUE),
(15, 1, 'Palacsinta nutellával', 'Friss palacsinta nutella töltelékkel', 890.00, '', TRUE);
