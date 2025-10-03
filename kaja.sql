-- phpMyAdmin SQL Dump
-- Compatible with phpMyAdmin 5.x and MySQL 8.0+

-- --------------------------------------------------------
-- Database and table structure
-- --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS `my_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `my_database`;

-- --------------------------------------------------------
-- Table: users
-- --------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255),
  `email` VARCHAR(255) UNIQUE,
  `password_hash` VARCHAR(255),
  `phone` VARCHAR(50),
  `address` TEXT,
  `role` ENUM('customer', 'admin', 'restaurant_owner') DEFAULT 'customer',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table: restaurants
-- --------------------------------------------------------
DROP TABLE IF EXISTS `restaurants`;
CREATE TABLE `restaurants` (
  `restaurant_id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner_id` INT NOT NULL,
  `name` VARCHAR(255),
  `description` TEXT,
  `address` TEXT,
  `phone` VARCHAR(50),
  `open_hours` VARCHAR(100),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_owner` FOREIGN KEY (`owner_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table: dishes
-- --------------------------------------------------------
DROP TABLE IF EXISTS `dishes`;
CREATE TABLE `dishes` (
  `dish_id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `name` VARCHAR(255),
  `description` TEXT,
  `price` DECIMAL(10,2),
  `image_url` VARCHAR(255),
  `available` BOOLEAN DEFAULT TRUE,
  CONSTRAINT `fk_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table: orders
-- --------------------------------------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `status` ENUM('pending', 'preparing', 'delivering', 'completed', 'cancelled') DEFAULT 'pending',
  `total_price` DECIMAL(10,2),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table: order_items
-- --------------------------------------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `order_item_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `dish_id` INT NOT NULL,
  `quantity` INT,
  `price` DECIMAL(10,2),
  CONSTRAINT `fk_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_dish` FOREIGN KEY (`dish_id`) REFERENCES `dishes`(`dish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table: payments
-- --------------------------------------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `amount` DECIMAL(10,2),
  `method` ENUM('card', 'cash', 'paypal'),
  `status` ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Sample data
-- --------------------------------------------------------

-- Étterem tulajdonos user
INSERT INTO `users` (`name`, `email`, `password_hash`, `phone`, `address`, `role`, `created_at`) VALUES
('KLSZ', 'klsz@gmail.com', 'klsz12345', '+36201234567', 'Budapest, Fő utca 1.', 'restaurant_owner', CURRENT_TIMESTAMP);

-- Vásárló user
INSERT INTO `users` (`name`, `email`, `password_hash`, `phone`, `address`, `role`, `created_at`) VALUES
('Teszt Vásárló', 'vasarlo@example.com', 'vasarlo123', '+36201112222', 'Debrecen, Vásárló utca 3.', 'customer', CURRENT_TIMESTAMP);

-- Étterem
INSERT INTO `restaurants` (`owner_id`, `name`, `description`, `address`, `phone`, `open_hours`, `created_at`) VALUES
(1, 'KLSZ', 'Kedvenc helyed pizzára, burgerekre és desszertekre!', 'Budapest, Fő utca 2.', '+36201234568', 'H-V: 11:00 - 22:00', CURRENT_TIMESTAMP);

-- Ételek
INSERT INTO `dishes` (`restaurant_id`, `name`, `description`, `price`, `image_url`, `available`) VALUES
(1, 'Margherita Pizza', 'Paradicsomszósz, mozzarella, friss bazsalikom', 2290.00, '', TRUE),
(1, 'Pepperoni Pizza', 'Paradicsomszósz, mozzarella, pepperoni kolbász', 2490.00, '', TRUE),
(1, 'Hawaii Pizza', 'Paradicsomszósz, sonka, ananász, mozzarella', 2390.00, '', TRUE),
(1, 'Négysajtos Pizza', 'Mozzarella, gorgonzola, parmezán, edami', 2590.00, '', TRUE),
(1, 'Classic Hamburger', 'Marhahúspogácsa, saláta, paradicsom, uborka, szósz', 1890.00, '', TRUE),
(1, 'Cheeseburger', 'Marhahús, cheddar sajt, saláta, paradicsom, ketchup', 1990.00, '', TRUE),
(1, 'Bacon Burger', 'Marhahús, bacon, cheddar, pirított hagyma, BBQ szósz', 2190.00, '', TRUE),
(1, 'Vega Burger', 'Zöldségpogácsa, saláta, paradicsom, vegán majonéz', 1790.00, '', TRUE),
(1, 'Sült krumpli', 'Klasszikus hasábburgonya', 790.00, '', TRUE),
(1, 'Sajtos sült krumpli', 'Ropogós krumpli olvasztott sajttal', 990.00, '', TRUE),
(1, 'BBQ sült krumpli', 'Hasábburgonya BBQ szósszal és baconnel', 1090.00, '', TRUE),
(1, 'Csokoládétorta szelet', 'Gazdag, csokis tortaszelet tejszínhabbal', 990.00, '', TRUE),
(1, 'Tiramisu', 'Klasszikus olasz desszert kávéval és mascarponeval', 1190.00, '', TRUE),
(1, 'Fagylalt kehely', '3 gombóc fagylalt, öntet és tejszínhab', 890.00, '', TRUE),
(1, 'Palacsinta nutellával', 'Friss palacsinta nutella töltelékkel', 890.00, '', TRUE);

-- --------------------------------------------------------
-- CRUD Példák
-- --------------------------------------------------------

-- USERS
INSERT INTO `users` (`name`, `email`, `password_hash`, `phone`, `address`, `role`) 
VALUES ('Új Felhasználó', 'uj@example.com', 'jelszo123', '+36203334444', 'Szeged, Fő tér 1.', 'customer');
SELECT * FROM `users`;
UPDATE `users` SET `phone` = '+36209998877' WHERE `user_id` = 2;
DELETE FROM `users` WHERE `user_id` = 3;

-- RESTAURANTS
INSERT INTO `restaurants` (`owner_id`, `name`, `description`, `address`, `phone`, `open_hours`)
VALUES (1, 'Új Étterem', 'Modern streetfood hely', 'Miskolc, Fő út 5.', '+36205556666', 'H-V: 10:00 - 21:00');
SELECT * FROM `restaurants`;
UPDATE `restaurants` SET `open_hours` = 'H-V: 09:00 - 22:00' WHERE `restaurant_id` = 1;
DELETE FROM `restaurants` WHERE `restaurant_id` = 2;

-- DISHES
INSERT INTO `dishes` (`restaurant_id`, `name`, `description`, `price`, `available`)
VALUES (1, 'Teszt Pizza', 'Szalámival és extra sajttal', 2990.00, TRUE);
SELECT * FROM `dishes`;
UPDATE `dishes` SET `price` = 3190.00, `available` = FALSE WHERE `dish_id` = 1;
DELETE FROM `dishes` WHERE `dish_id` = 2;

-- ORDERS
INSERT INTO `orders` (`user_id`, `restaurant_id`, `status`, `total_price`) 
VALUES (2, 1, 'pending', 2490.00);
SELECT * FROM `orders`;
UPDATE `orders` SET `status` = 'completed' WHERE `order_id` = 1;
DELETE FROM `orders` WHERE `order_id` = 2;

-- ORDER_ITEMS
INSERT INTO `order_items` (`order_id`, `dish_id`, `quantity`, `price`)
VALUES (1, 1, 2, 4580.00);
SELECT * FROM `order_items`;
UPDATE `order_items` SET `quantity` = 3 WHERE `order_item_id` = 1;
DELETE FROM `order_items` WHERE `order_item_id` = 2;

-- PAYMENTS
INSERT INTO `payments` (`order_id`, `amount`, `method`, `status`) 
VALUES (1, 2490.00, 'card', 'paid');
SELECT * FROM `payments`;
UPDATE `payments` SET `status` = 'failed' WHERE `payment_id` = 1;
DELETE FROM `payments` WHERE `payment_id` = 2;
