-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Gép: localhost:8889
-- Létrehozás ideje: 2025. Dec 08. 08:40
-- Kiszolgáló verziója: 5.7.24
-- PHP verzió: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `étel shop`
--

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddDish` (IN `restaurant_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `price` DECIMAL(10,2), IN `image_url` VARCHAR(255), IN `available` BOOLEAN)   BEGIN
    INSERT INTO dishes (restaurant_id, name, description, price, image_url, available) VALUES (restaurant_id, name, description, price, image_url, available);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrder` (IN `user_id` INT, IN `restaurant_id` INT, IN `status` ENUM('pending','preparing','delivering','completed','cancelled'), IN `total_price` DECIMAL(10,2))   BEGIN
    INSERT INTO orders (user_id, restaurant_id, status, total_price) VALUES (user_id, restaurant_id, status, total_price);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrderItem` (IN `order_id` INT, IN `dish_id` INT, IN `quantity` INT, IN `price` DECIMAL(10,2))   BEGIN
    INSERT INTO order_items (order_id, dish_id, quantity, price) VALUES (order_id, dish_id, quantity, price);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddPayment` (IN `order_id` INT, IN `amount` DECIMAL(10,2), IN `method` ENUM('card','cash','paypal'), IN `status` ENUM('pending','paid','failed'))   BEGIN
    INSERT INTO payments (order_id, amount, method, status) VALUES (order_id, amount, method, status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRestaurant` (IN `owner_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `address` TEXT, IN `phone` VARCHAR(50), IN `open_hours` VARCHAR(100))   BEGIN
    INSERT INTO restaurants (owner_id, name, description, address, phone, open_hours) VALUES (owner_id, name, description, address, phone, open_hours);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password_hash` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    INSERT INTO users (name, email, password_hash, phone, address, role) VALUES (name, email, password_hash, phone, address, role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser` (IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password_hash` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    INSERT INTO users (name, email, password_hash, phone, address, role)
    VALUES (name, email, password_hash, phone, address, role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDish` (IN `dish_id` INT)   BEGIN
    DELETE FROM dishes WHERE dish_id = dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrder` (IN `order_id` INT)   BEGIN
    DELETE FROM orders WHERE order_id = order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrderItem` (IN `order_item_id` INT)   BEGIN
    DELETE FROM order_items WHERE order_item_id = order_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePayment` (IN `payment_id` INT)   BEGIN
    DELETE FROM payments WHERE payment_id = payment_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteRestaurant` (IN `restaurant_id` INT)   BEGIN
    DELETE FROM restaurants WHERE restaurant_id = restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `user_id` INT)   BEGIN
    DELETE FROM users WHERE user_id = user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllDishes` ()   BEGIN
    SELECT * FROM dishes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllOrderItems` ()   BEGIN
    SELECT * FROM order_items;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllOrders` ()   BEGIN
    SELECT * FROM orders;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllPayments` ()   BEGIN
    SELECT * FROM payments;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllRestaurants` ()   BEGIN
    SELECT * FROM restaurants;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllUsers` ()   BEGIN
    SELECT * FROM users;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserById` (IN `user_id` INT)   BEGIN
    SELECT * FROM users WHERE user_id = user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDish` (IN `dish_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `price` DECIMAL(10,2), IN `image_url` VARCHAR(255), IN `available` BOOLEAN)   BEGIN
    UPDATE dishes SET name = name, description = description, price = price, image_url = image_url, available = available WHERE dish_id = dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrder` (IN `order_id` INT, IN `status` ENUM('pending','preparing','delivering','completed','cancelled'), IN `total_price` DECIMAL(10,2))   BEGIN
    UPDATE orders SET status = status, total_price = total_price WHERE order_id = order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderItem` (IN `order_item_id` INT, IN `quantity` INT, IN `price` DECIMAL(10,2))   BEGIN
    UPDATE order_items SET quantity = quantity, price = price WHERE order_item_id = order_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePayment` (IN `payment_id` INT, IN `status` ENUM('pending','paid','failed'))   BEGIN
    UPDATE payments SET status = status WHERE payment_id = payment_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRestaurant` (IN `restaurant_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `address` TEXT, IN `phone` VARCHAR(50), IN `open_hours` VARCHAR(100))   BEGIN
    UPDATE restaurants SET name = name, description = description, address = address, phone = phone, open_hours = open_hours WHERE restaurant_id = restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `user_id` INT, IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password_hash` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    UPDATE users
    SET name = name,
        email = email,
        password_hash = password_hash,
        phone = phone,
        address = address,
        role = role
    WHERE user_id = user_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `dishes`
--

CREATE TABLE `dishes` (
  `dish_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `price` decimal(10,2) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `available` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `dishes`
--

INSERT INTO `dishes` (`dish_id`, `restaurant_id`, `name`, `description`, `price`, `image_url`, `available`) VALUES
(1, 1, 'Margherita Pizza', 'Paradicsomszósz, mozzarella, friss bazsalikom', '2290.00', '', 1),
(2, 1, 'Pepperoni Pizza', 'Paradicsomszósz, mozzarella, pepperoni kolbász', '2490.00', '', 1),
(3, 1, 'Hawaii Pizza', 'Paradicsomszósz, sonka, ananász, mozzarella', '2390.00', '', 1),
(4, 1, 'Négysajtos Pizza', 'Mozzarella, gorgonzola, parmezán, edami', '2590.00', '', 1),
(5, 1, 'Classic Hamburger', 'Marhahúspogácsa, saláta, paradicsom, uborka, szósz', '1890.00', '', 1),
(6, 1, 'Cheeseburger', 'Marhahús, cheddar sajt, saláta, paradicsom, ketchup', '1990.00', '', 1),
(7, 1, 'Bacon Burger', 'Marhahús, bacon, cheddar, pirított hagyma, BBQ szósz', '2190.00', '', 1),
(8, 1, 'Vega Burger', 'Zöldségpogácsa, saláta, paradicsom, vegán majonéz', '1790.00', '', 1),
(9, 1, 'Sült krumpli', 'Klasszikus hasábburgonya', '790.00', '', 1),
(10, 1, 'Sajtos sült krumpli', 'Ropogós krumpli olvasztott sajttal', '990.00', '', 1),
(11, 1, 'BBQ sült krumpli', 'Hasábburgonya BBQ szósszal és baconnel', '1090.00', '', 1),
(12, 1, 'Csokoládétorta szelet', 'Gazdag, csokis tortaszelet tejszínhabbal', '990.00', '', 1),
(13, 1, 'Tiramisu', 'Klasszikus olasz desszert kávéval és mascarponeval', '1190.00', '', 1),
(14, 1, 'Fagylalt kehely', '3 gombóc fagylalt, öntet és tejszínhab', '890.00', '', 1),
(15, 1, 'Palacsinta nutellával', 'Friss palacsinta nutella töltelékkel', '890.00', '', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `status` enum('pending','preparing','delivering','completed','cancelled') DEFAULT 'pending',
  `total_price` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `dish_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `method` enum('card','cash','paypal') DEFAULT NULL,
  `status` enum('pending','paid','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `restaurants`
--

CREATE TABLE `restaurants` (
  `restaurant_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `address` text,
  `phone` varchar(50) DEFAULT NULL,
  `open_hours` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `restaurants`
--

INSERT INTO `restaurants` (`restaurant_id`, `owner_id`, `name`, `description`, `address`, `phone`, `open_hours`, `created_at`) VALUES
(1, 1, 'KLSZ', 'Kedvenc helyed pizzára, burgerekre és desszertekre!', 'Budapest, Fő utca 2.', '+36201234568', 'H-V: 11:00 - 22:00', '2025-10-03 09:37:09');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text,
  `role` enum('customer','admin','restaurant_owner') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password_hash`, `phone`, `address`, `role`, `created_at`) VALUES
(1, 'KLSZ', 'klsz@gmail.com', 'klsz12345', '+36201234567', 'Budapest, Fő utca 1.', 'restaurant_owner', '2025-10-03 09:37:09'),
(2, 'Teszt Vásárló', 'vasarlo@example.com', 'vasarlo123', '+36201112222', 'Debrecen, Vásárló utca 3.', 'customer', '2025-10-03 09:37:09'),
(3, 'examplecustomer', 'examplecustomer@gmail.com', '12345', '+363012334234', 'Sigma land', 'customer', '2025-12-05 10:01:26'),
(4, 'exampleadmind', 'exampleadmind@gmail.com', '1234567', '+360301245235', 'Sigma', 'admin', '2025-12-05 10:02:44'),
(5, 'exaplerestaurant_owner', 'exaplerestaurant_owner@gmail.com', '21355355', '+363042523434', 'mogger land', 'restaurant_owner', '2025-12-05 10:03:25'),
(6, 'teszt', 'teszt@gmail.com', '12345678', '+3630131242', 'kiskunfélegyháza', 'customer', '2025-12-05 10:16:19'),
(7, 'teszt2', 'teszt2@gmail.com', '12234221', '+3630324246', 'pécs', 'customer', '2025-12-05 10:16:55'),
(8, 'teszt3', 'teszt3@gmail.com', '12414', '+36301244', 'budapest', 'customer', '2025-12-05 10:18:08'),
(9, 'teszt4', 'teszt4@gmail.com', '+360312414', '2388247849825', 'Kecskemét', 'customer', '2025-12-05 10:19:07'),
(10, 'teszt5', 'teszt5@gmail.com', '37329832328', '+363012335', 'Szeged', 'customer', '2025-12-05 10:19:34'),
(11, 'teszt6', 'teszt6@gmail.com', '23874225987', '+363057456', 'Bécs', 'customer', '2025-12-05 10:20:58'),
(12, 'teszt7', 'teszt7@gmail.com', '23462344298427', '+36303742384', 'Pécs1', 'customer', '2025-12-05 10:21:41'),
(13, 'teszt8', 'teszt8@gmail.com', '23874823975298', '+363043422', 'Debrecen', 'customer', '2025-12-05 10:22:41'),
(14, 'teszt9', 'teszt9@gmail.com', '93277892892', '+363012345', 'Szigetvar', 'customer', '2025-12-05 10:23:19'),
(15, 'teszt10', 'teszt10@gmail.com', '824723894479', '+363023423525', 'Hosoktere', 'customer', '2025-12-05 10:25:27'),
(16, 'teszt11', 'teszt11@gmail.com', '3472395724819', '+363023489', 'Budaivam', 'customer', '2025-12-05 10:25:58'),
(17, 'teszt12', 'teszt12@gmail.com', '235346453', '+363023242335', 'Uranvaros', 'customer', '2025-12-05 10:26:34');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`dish_id`),
  ADD KEY `fk_restaurant` (`restaurant_id`);

--
-- A tábla indexei `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_user` (`user_id`),
  ADD KEY `fk_order_restaurant` (`restaurant_id`);

--
-- A tábla indexei `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `fk_order` (`order_id`),
  ADD KEY `fk_dish` (`dish_id`);

--
-- A tábla indexei `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_payment_order` (`order_id`);

--
-- A tábla indexei `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`restaurant_id`),
  ADD KEY `fk_owner` (`owner_id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `dishes`
--
ALTER TABLE `dishes`
  MODIFY `dish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `restaurant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `dishes`
--
ALTER TABLE `dishes`
  ADD CONSTRAINT `fk_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_dish` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `restaurants`
--
ALTER TABLE `restaurants`
  ADD CONSTRAINT `fk_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
