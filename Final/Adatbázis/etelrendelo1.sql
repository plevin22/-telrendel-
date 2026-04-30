-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Gép: localhost:3306
-- Létrehozás ideje: 2026. Ápr 27. 10:52
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
-- Adatbázis: `etelrendelo1`
--

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddDelivery` (IN `p_order_id` INT, IN `p_delivery_address` TEXT, IN `p_delivery_time` DATETIME, IN `p_status` ENUM('pending','dispatched','delivering','completed','failed'))   BEGIN
    INSERT INTO delivery(order_id, delivery_address, delivery_time, status)
    VALUES(p_order_id, p_delivery_address, p_delivery_time, p_status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddDish` (IN `restaurant_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `price` DECIMAL(10,2), IN `image_url` VARCHAR(255), IN `available` BOOLEAN)   BEGIN
    INSERT INTO dishes (restaurant_id, name, description, price, image_url, available) VALUES (restaurant_id, name, description, price, image_url, available);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrder` (IN `p_user_id` INT, IN `p_restaurant_id` INT, IN `p_delivery_address` TEXT, IN `p_status` ENUM('pending','preparing','delivering','completed','cancelled'), IN `p_total_price` DECIMAL(10,2))   BEGIN
    INSERT INTO orders (user_id, restaurant_id, delivery_address, status, total_price)
    VALUES (p_user_id, p_restaurant_id, p_delivery_address, p_status, p_total_price);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrderItem` (IN `order_id` INT, IN `dish_id` INT, IN `quantity` INT, IN `price` DECIMAL(10,2))   BEGIN
    INSERT INTO order_items (order_id, dish_id, quantity, price) VALUES (order_id, dish_id, quantity, price);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddPayment` (IN `p_order_id` INT, IN `p_amount` DECIMAL(10,2), IN `p_method` ENUM('card','cash','paypal'), IN `p_status` ENUM('pending','paid','failed'))   BEGIN
    INSERT INTO payments (order_id, amount, method, status)
    VALUES (p_order_id, p_amount, p_method, p_status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRestaurant` (IN `owner_id` INT, IN `name` VARCHAR(255), IN `description` TEXT, IN `address` TEXT, IN `phone` VARCHAR(50), IN `open_hours` VARCHAR(100))   BEGIN
    INSERT INTO restaurants (owner_id, name, description, address, phone, open_hours) VALUES (owner_id, name, description, address, phone, open_hours);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRestaurantHours` (IN `p_restaurant_id` INT, IN `p_day_of_week` ENUM('Hétfő','Kedd','Szerda','Csütörtök','Péntek','Szombat','Vasárnap'), IN `p_open_time` TIME, IN `p_close_time` TIME)   BEGIN
    INSERT INTO restaurant_hours(restaurant_id, day_of_week, open_time, close_time)
    VALUES(p_restaurant_id, p_day_of_week, p_open_time, p_close_time);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddReview` (IN `p_user_id` INT, IN `p_restaurant_id` INT, IN `p_dish_id` INT, IN `p_rating` TINYINT, IN `p_comment` TEXT)   BEGIN
    INSERT INTO reviews(user_id, restaurant_id, dish_id, rating, comment)
    VALUES(p_user_id, p_restaurant_id, p_dish_id, p_rating, p_comment);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ChangeUserPassword` (IN `p_user_id` INT, IN `p_new_password` VARCHAR(255))   BEGIN
    UPDATE users
    SET password = p_new_password
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CountDishesByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT COUNT(*) AS total
    FROM dishes
    WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CountDishesPerRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT restaurant_id, COUNT(*) AS total_dishes
    FROM dishes
    WHERE restaurant_id = p_restaurant_id
    GROUP BY restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CountUsersByRole` ()   BEGIN
    SELECT role, COUNT(*) AS total
    FROM users
    GROUP BY role;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreatePasswordResetToken` (IN `p_user_id` INT, IN `p_token` VARCHAR(255), IN `p_expires_at` DATETIME)   BEGIN
    DELETE FROM password_reset_tokens WHERE user_id = p_user_id;
    INSERT INTO password_reset_tokens (user_id, token, expires_at)
    VALUES (p_user_id, p_token, p_expires_at);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser` (IN `p_name` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_phone` VARCHAR(50), IN `p_role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    INSERT INTO users (name, username, email, password, phone, role, banned)
    VALUES (p_name, p_username, p_email, p_password, p_phone, p_role, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDelivery` (IN `p_delivery_id` INT)   BEGIN
    DELETE FROM delivery WHERE delivery_id = p_delivery_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDish` (IN `p_dish_id` INT)   BEGIN
    DELETE FROM dishes WHERE dish_id = p_dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrder` (IN `p_order_id` INT)   BEGIN
    DELETE FROM orders WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrderItem` (IN `p_order_item_id` INT)   BEGIN
    DELETE FROM order_items WHERE order_item_id = p_order_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePayment` (IN `p_payment_id` INT)   BEGIN
    DELETE FROM payments WHERE payment_id = p_payment_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    DELETE FROM restaurants WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteRestaurantHours` (IN `p_hours_id` INT)   BEGIN
    DELETE FROM restaurant_hours WHERE hours_id = p_hours_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteReview` (IN `p_review_id` INT)   BEGIN
    DELETE FROM reviews WHERE review_id = p_review_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `p_user_id` INT)   BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ForgotUserPassword` (IN `p_user_id` INT, IN `p_new_password` VARCHAR(255))   BEGIN
    UPDATE users
    SET password = p_new_password
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetActiveOrdersByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * 
    FROM orders
    WHERE restaurant_id = p_restaurant_id AND status IN ('pending','preparing','delivering');
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailableDishesByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * 
    FROM dishes
    WHERE restaurant_id = p_restaurant_id AND available = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAverageRatingByDish` (IN `p_dish_id` INT)   BEGIN
    SELECT AVG(rating) AS average_rating, COUNT(*) AS total_reviews
    FROM reviews
    WHERE dish_id = p_dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAverageRatingByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT AVG(rating) AS average_rating, COUNT(*) AS total_reviews
    FROM reviews
    WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCheapestDishByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * 
    FROM dishes
    WHERE restaurant_id = p_restaurant_id
    ORDER BY price ASC
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDeliveryByOrder` (IN `p_order_id` INT)   BEGIN
    SELECT * FROM delivery WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDishById` (IN `p_dish_id` INT)   BEGIN
    SELECT * FROM dishes WHERE dish_id = p_dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDishByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * FROM dishes WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMostExpensiveDishByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * 
    FROM dishes
    WHERE restaurant_id = p_restaurant_id
    ORDER BY price DESC
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMostOrderedDishByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT oi.dish_id, d.name, SUM(oi.quantity) AS total_ordered
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN dishes d ON oi.dish_id = d.dish_id
    WHERE o.restaurant_id = p_restaurant_id
    GROUP BY oi.dish_id
    ORDER BY total_ordered DESC
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderById` (IN `p_order_id` INT)   BEGIN
    SELECT * FROM orders WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderItemById` (IN `p_order_item_id` INT)   BEGIN
    SELECT * FROM order_items WHERE order_item_id = p_order_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderItemsByOrder` (IN `p_order_id` INT)   BEGIN
    SELECT * FROM order_items WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByUser` (IN `p_user_id` INT)   BEGIN
    SELECT * FROM orders WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPasswordResetToken` (IN `p_token` VARCHAR(255))   BEGIN
    SELECT * FROM password_reset_tokens WHERE token = p_token;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPaymentById` (IN `p_payment_id` INT)   BEGIN
  SELECT *
  FROM payments
  WHERE payment_id = p_payment_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPaymentByOrder` (IN `p_order_id` INT)   BEGIN
  SELECT *
  FROM payments
  WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPendingDeliveries` ()   BEGIN
    SELECT * 
    FROM delivery
    WHERE status IN ('pending','dispatched');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRecentReviews` (IN `p_limit` INT)   BEGIN
    SELECT r.review_id, r.rating, r.comment, r.created_at, u.name AS user_name, d.name AS dish_name, res.name AS restaurant_name
    FROM reviews r
    LEFT JOIN users u ON r.user_id = u.user_id
    LEFT JOIN dishes d ON r.dish_id = d.dish_id
    LEFT JOIN restaurants res ON r.restaurant_id = res.restaurant_id
    ORDER BY r.created_at DESC
    LIMIT p_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRecentUsers` (IN `p_limit` INT)   BEGIN
    SELECT *
    FROM users
    ORDER BY created_at DESC
    LIMIT p_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRestaurantHours` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * FROM restaurant_hours WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReviewById` (IN `p_review_id` INT)   BEGIN
    SELECT * FROM reviews WHERE review_id = p_review_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReviewsByDish` (IN `p_dish_id` INT)   BEGIN
    SELECT * FROM reviews WHERE dish_id = p_dish_id ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReviewsByRestaurant` (IN `p_restaurant_id` INT)   BEGIN
    SELECT * FROM reviews WHERE restaurant_id = p_restaurant_id ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReviewsByUser` (IN `p_user_id` INT)   BEGIN
    SELECT * FROM reviews WHERE user_id = p_user_id ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTopRatedDishesByRestaurant` (IN `p_restaurant_id` INT, IN `p_limit` INT)   BEGIN
    SELECT dish_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count
    FROM reviews
    WHERE restaurant_id = p_restaurant_id
    GROUP BY dish_id
    ORDER BY avg_rating DESC, review_count DESC
    LIMIT p_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTopRatedRestaurants` (IN `p_limit` INT)   BEGIN
    SELECT restaurant_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count
    FROM reviews
    GROUP BY restaurant_id
    ORDER BY avg_rating DESC, review_count DESC
    LIMIT p_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalSpentByUser` (IN `p_user_id` INT)   BEGIN
    SELECT user_id, SUM(total_price) AS total_spent
    FROM orders
    WHERE user_id = p_user_id AND status='completed'
    GROUP BY user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserById` (IN `p_user_id` INT)   BEGIN
    SELECT * FROM users WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserReviewsWithDetails` (IN `p_user_id` INT)   BEGIN
    SELECT r.review_id, r.rating, r.comment, r.created_at, d.name AS dish_name, res.name AS restaurant_name
    FROM reviews r
    LEFT JOIN dishes d ON r.dish_id = d.dish_id
    LEFT JOIN restaurants res ON r.restaurant_id = res.restaurant_id
    WHERE r.user_id = p_user_id
    ORDER BY r.created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsersByRole` (IN `p_role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    SELECT * FROM users WHERE role = p_role;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ImportRestaurantHoursFromOpenHours` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE r_id INT;
    DECLARE oh VARCHAR(100);
    DECLARE open_t TIME;
    DECLARE close_t TIME;
    
    DECLARE cur CURSOR FOR
        SELECT restaurant_id, open_hours FROM restaurants;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO r_id, oh;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Feltételezzük, hogy az open_hours formátuma mindig "HH:MM - HH:MM"
        SET open_t = TIME(SUBSTRING_INDEX(oh,' - ',1));
        SET close_t = TIME(SUBSTRING_INDEX(oh,' - ',-1));

        -- Minden napra feltöltjük ugyanazt a nyitvatartást
        INSERT INTO restaurant_hours(restaurant_id, day_of_week, open_time, close_time)
        VALUES
            (r_id,'Hétfő',open_t,close_t),
            (r_id,'Kedd',open_t,close_t),
            (r_id,'Szerda',open_t,close_t),
            (r_id,'Csütörtök',open_t,close_t),
            (r_id,'Péntek',open_t,close_t),
            (r_id,'Szombat',open_t,close_t),
            (r_id,'Vasárnap',open_t,close_t);
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Login` (IN `p_email` VARCHAR(255))   BEGIN
    SELECT *
    FROM users
    WHERE email = p_email
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MarkPasswordResetTokenAsUsed` (IN `p_token` VARCHAR(255))   BEGIN
    UPDATE password_reset_tokens SET used = TRUE WHERE token = p_token;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchDishesByName` (IN `p_name` VARCHAR(255))   BEGIN
    SELECT * 
    FROM dishes
    WHERE name LIKE CONCAT('%', p_name, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchDishesByPriceRange` (IN `p_min` DECIMAL(10,2), IN `p_max` DECIMAL(10,2))   BEGIN
    SELECT * 
    FROM dishes
    WHERE price BETWEEN p_min AND p_max;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchRestaurantsByAddress` (IN `p_address` VARCHAR(255))   BEGIN
    SELECT * 
    FROM restaurants
    WHERE address LIKE CONCAT('%', p_address, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchReviewsByComment` (IN `p_keyword` VARCHAR(255))   BEGIN
    SELECT * FROM reviews WHERE comment LIKE CONCAT('%', p_keyword, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchUsersByEmail` (IN `p_email` VARCHAR(255))   BEGIN
    SELECT * FROM users
    WHERE email LIKE CONCAT('%', p_email, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchUsersByName` (IN `p_name` VARCHAR(255))   BEGIN
    SELECT * FROM users
    WHERE name LIKE CONCAT('%', p_name, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDeliveryStatus` (IN `p_delivery_id` INT, IN `p_status` ENUM('pending','dispatched','delivering','completed','failed'))   BEGIN
    UPDATE delivery
    SET status = p_status
    WHERE delivery_id = p_delivery_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDish` (IN `p_dish_id` INT, IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_price` DECIMAL(10,2), IN `p_image_url` VARCHAR(255), IN `p_available` BOOLEAN)   BEGIN
    UPDATE dishes
    SET name = p_name,
        description = p_description,
        price = p_price,
        image_url = p_image_url,
        available = p_available
    WHERE dish_id = p_dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrder` (IN `p_order_id` INT, IN `p_status` VARCHAR(20), IN `p_total_price` DECIMAL(10,2))   BEGIN
    UPDATE orders
    SET
        status = p_status,
        total_price = p_total_price
    WHERE order_id = p_order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderItem` (IN `p_order_item_id` INT, IN `p_quantity` INT, IN `p_price` DECIMAL(10,2))   BEGIN
    UPDATE order_items
    SET quantity = p_quantity,
        price = p_price
    WHERE order_item_id = p_order_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePayment` (IN `p_payment_id` INT, IN `p_status` VARCHAR(20))   BEGIN
    UPDATE payments
    SET status = p_status
    WHERE payment_id = p_payment_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRestaurant` (IN `p_restaurant_id` INT, IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_address` TEXT, IN `p_phone` VARCHAR(50), IN `p_open_hours` VARCHAR(100))   BEGIN
    UPDATE restaurants
    SET
        name = p_name,
        description = p_description,
        address = p_address,
        phone = p_phone,
        open_hours = p_open_hours
    WHERE restaurant_id = p_restaurant_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRestaurantHours` (IN `p_hours_id` INT, IN `p_open_time` TIME, IN `p_close_time` TIME)   BEGIN
    UPDATE restaurant_hours
    SET open_time = p_open_time,
        close_time = p_close_time
    WHERE hours_id = p_hours_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateReview` (IN `p_review_id` INT, IN `p_rating` TINYINT, IN `p_comment` TEXT)   BEGIN
    UPDATE reviews
    SET rating = p_rating,
        comment = p_comment
    WHERE review_id = p_review_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `p_user_id` INT, IN `p_name` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_phone` VARCHAR(50), IN `p_role` ENUM('customer','admin','restaurant_owner'), IN `p_banned` TINYINT(1))   BEGIN
    UPDATE users
    SET name = p_name,
        username = p_username,
        email = p_email,
        password = p_password,
        phone = p_phone,
        role = p_role,
        banned = p_banned
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `delivery`
--

CREATE TABLE `delivery` (
  `delivery_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `delivery_address` text NOT NULL,
  `delivery_time` datetime DEFAULT NULL,
  `status` enum('pending','dispatched','delivering','completed','failed') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `delivery`
--

INSERT INTO `delivery` (`delivery_id`, `order_id`, `delivery_address`, `delivery_time`, `status`) VALUES
(1, 15, '7621 Pécs, Király utca 25.', '2026-02-23 14:30:00', 'delivering');

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
  `available` tinyint(1) DEFAULT '1',
  `type` enum('étel','ital','desszert') NOT NULL DEFAULT 'étel'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `dishes`
--

INSERT INTO `dishes` (`dish_id`, `restaurant_id`, `name`, `description`, `price`, `image_url`, `available`, `type`) VALUES
(16, 8, 'CHEESEBURGER PIZZA', 'Sajtszósz, mozzarella, marha- és sertéshúsgolyók, hagyma, fűszeres paradicsomszósz, savanyú uborka, ketchup, mustár, szezámmag', '4495.00', 'https://image2url.com/r2/default/images/1770972159976-3ff7a2e5-89bb-4593-8330-b8d26a916f89.png', 1, 'étel'),
(17, 8, 'BBQ NUGGETS', 'Sütőben sült nuggets falatok, mozzarella, BBQ szósz, bacon, zöldpaprika', '4495.00', 'https://image2url.com/r2/default/images/1770024675040-21fc50c9-f2fd-4f56-b106-940dec2ae4ac.png', 1, 'étel'),
(18, 8, 'Margarita', 'Fűszeres paradicsomszósz, Mozzarella sajt', '3795.00', 'https://image2url.com/r2/default/images/1770024703900-b46f61fe-78c7-41e9-ad6f-2de4811d3828.png', 1, 'étel'),
(19, 8, 'Olaszkolbászos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Olaszkolbász', '3995.00', 'https://image2url.com/r2/default/images/1770024739779-25618269-75ff-4f12-b140-8aa68d1e37bc.png', 1, 'étel'),
(20, 8, 'BBQ-Bacon', 'BBQ szósz, Mozzarella sajt, Bacon', '3995.00', 'https://image2url.com/r2/default/images/1770024768408-ac5fc27d-7b6f-4826-8542-d5267db05712.png', 1, 'étel'),
(21, 8, 'Dallas', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Gomba', '3995.00', 'https://image2url.com/r2/default/images/1770024801211-31449f48-118d-4995-be31-07d71ee06fee.png', 1, 'étel'),
(22, 8, 'Hawaii', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Ananász', '3995.00', 'https://image2url.com/r2/default/images/1770024844639-75f619c5-5fba-4ec8-aa1e-ed78a0faba87.png', 1, 'étel'),
(23, 8, 'CARBONARA', 'Fokhagymás szósz, Mozzarella sajt, Sonka, Bacon', '4295.00', 'https://image2url.com/r2/default/images/1770024876108-c26d3b4f-539d-4307-a9d5-7cd50f4c0de1.png', 1, 'étel'),
(24, 8, 'Csirkés-Jalapenos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Fűszeres csirke, Jalapeño paprika', '4295.00', 'https://image2url.com/r2/default/images/1770024902723-bcc2174e-9098-4ddc-955a-7a8b170914a9.png', 1, 'étel'),
(25, 8, 'SokSajtos', 'Fokhagymás szósz, Mozzarella sajt, Cheddar sajt, Mozzarella golyók, Correggio sajt', '4295.00', 'https://image2url.com/r2/default/images/1770024928462-acabe609-1be2-4548-80a0-5d17f092acbc.png', 1, 'étel'),
(26, 8, 'CSOKIS KEKSZ', 'Forró csokis sütemény egyenesen sütőből', '1395.00', 'https://image2url.com/r2/default/images/1770024965320-40ed5656-bd35-4c71-a1c8-17035ab088ec.png', 1, 'desszert'),
(27, 8, 'B&J 100 ML Epres Sajttorta', 'Ínycsiklandó epres sajttorta ízű jégkrém eperdarabokkal és gazdag kekszörvényekkel!', '1695.00', 'https://image2url.com/r2/default/images/1770024995931-09f65184-caef-416f-bbf5-bb7eeeda0042.png', 1, 'desszert'),
(28, 8, 'B&J 100ML Cookie Dough', 'Vaníliás jégkrém tökéletes találkozása csokis sütemény darabkákkal', '1695.00', 'https://image2url.com/r2/default/images/1770025173526-faafe39a-84ac-4225-b688-16f71130f69f.png', 1, 'desszert'),
(29, 8, 'B&J 100ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie sütemény darabkákkal', '1695.00', 'https://image2url.com/r2/default/images/1770025200635-a28e921e-5c14-4ddf-9735-185fd400973c.png', 1, 'desszert'),
(30, 8, 'B&J 465ML Brookies&Cream', 'A népszerű Brookies sütemény és vanília jégkrém harmóniája fehér bevonómassza darabokkal', '4995.00', 'https://image2url.com/r2/default/images/1770971735925-83116e76-327c-434c-ba6e-2fb100faf726.png', 1, 'desszert'),
(31, 8, 'B&J 465ML Cookie Dough', 'Vaníliás jégkrém csokis sütemény darabkákkal', '4995.00', 'https://image2url.com/r2/default/images/1770971772839-da669329-306a-482e-a58f-c0759569bdb1.png', 1, 'desszert'),
(32, 8, 'B&J 465ML Netflix&Chill\'d', 'Földimogyoróvajas jégkrém édes-sós pereccel és brownie darabokkal', '4995.00', 'https://image2url.com/r2/default/images/1770971809217-cc66de36-055f-47a6-9703-446f283f3c29.png', 1, 'desszert'),
(33, 8, 'B&J 465ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie darabkákkal', '4995.00', 'https://image2url.com/r2/default/images/1770971990237-87a26063-3017-4133-89ce-341befd762d3.png', 1, 'desszert'),
(34, 8, 'MAGNUM PINK LEMONADE 440ML', 'Citromos jégkrém málna szorbéval, fehércsoki bevonattal és pattogó cukorkával', '4445.00', 'https://image2url.com/r2/default/images/1770972017644-ae1c605a-2435-467e-858f-6c32823b832d.png', 1, 'desszert'),
(35, 8, 'Magnum 440ML Dupla Mogyorós', 'Csokis-mogyorós és sós karamelles mandula jégkrém', '4445.00', 'https://image2url.com/r2/default/images/1770972071459-8b33680d-8e64-4dbb-a0ad-35473d5f0d3d.png', 1, 'desszert'),
(36, 8, 'CHEESEBURGER SÜLT TÉSZTA', 'Friss penne szaftos marha- és sertéshúsgolyókkal, nyúlós mozzarella sajt, savanyú uborka, hagyma, ketchup, mustár és szezámmag', '3695.00', 'https://image2url.com/r2/default/images/1770972374751-e8d30d0f-1b38-4bf2-bf00-0247a1aa066f.png', 1, 'étel'),
(37, 8, 'MAC \'N\' CHEETOS', 'Penne krémes béchamel- és sajtmártással, mozzarella, cheddar és gouda keverékével, ropogós sajtos CHEETOS-szal', '3695.00', 'https://image2url.com/r2/default/images/1770972416246-67d33b23-aae0-4a45-b3a5-e3c84dc83a34.png', 1, 'étel'),
(38, 8, 'MARGHERITA SÜLT TÉSZTA', 'Penne tészta, fűszeres paradicsomszósz, bechamel, dupla mozzarella, mozzarella golyó', '2695.00', 'https://image2url.com/r2/default/images/1770972477795-d8099a64-7ba7-46e6-9f46-9cc1324aa98f.png', 1, 'étel'),
(39, 8, 'Olaszkolbászos sült tészta', 'Penne tészta, napoletta szósz, bechamel, grillezett olaszkolbász, mozzarella', '3695.00', 'https://image2url.com/r2/default/images/1770972529991-41f46bea-d406-417f-8167-95afb99ad43d.png', 1, 'étel'),
(40, 8, 'Fokhagymás sült tészta', 'Penne tészta, fokhagyma szósz, sonka, gomba, lilahagyma, mozzarella', '3495.00', 'https://image2url.com/r2/default/images/1770972672058-3acf4c3f-9156-4641-834c-f03205e203c9.png', 1, 'étel'),
(41, 8, 'VEGGIE SÜLT TÉSZTA', 'Penne tészta, napoletta szósz, bechamel, kaliforniai paprika, gomba, lilahagyma, mozzarella', '3495.00', 'https://image2url.com/r2/default/images/1770972697733-592cbe3a-cbb3-42f5-b077-95e94fb84948.png', 1, 'étel'),
(42, 8, 'CHEESEBURGER MELTS', 'Sajtos csavar tele mozzarellával, marha- és sertéshúsgolyókkal, savanyú uborkával, hagymával, ketchuppal, mustárral és szezámmaggal', '2395.00', 'https://image2url.com/r2/default/images/1770972777553-6bc00347-41b2-4a3d-9b42-1e7d85432edc.png', 1, 'étel'),
(43, 8, 'COCA COLA 0,5L', 'Frissítő üdítő', '995.00', 'https://image2url.com/r2/default/images/1770973095228-563ffe69-f83d-44bd-835b-17d6d6488c4d.png', 1, 'ital'),
(44, 8, 'Fanta Narancs 0,5L', 'Frissítő üdítő', '995.00', 'https://image2url.com/r2/default/images/1770973155532-9475c1e9-c742-4cfd-93f7-f7a3b2d0c7bc.png', 1, 'ital'),
(45, 8, 'NaturAqua szénsavas ásványvíz 0,5L', 'Friss Víz ', '845.00', 'https://image2url.com/r2/default/images/1770973214272-24d75e45-273b-48af-85ca-475c86fa3faa.png', 1, 'ital'),
(46, 1, 'Buddha Tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '5800.00', 'https://image2url.com/r2/default/images/1770973285113-64662e22-f968-4b2a-ab09-0ba8c4485979.png', 1, 'étel'),
(47, 1, 'Angol Reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770973338365-75d0983c-3c6c-40bf-9fd1-b4b8e19258a6.png', 1, 'étel'),
(48, 1, 'Diet_Etikus Angol reggeli', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770973625474-f681e05e-357a-42c7-89ef-ead9c03e04f0.png', 1, 'étel'),
(49, 1, 'Reggeli Bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', 'https://image2url.com/r2/default/images/1770973713823-cb25042a-2bb7-4d44-9578-5f92296381f9.png', 1, 'étel'),
(50, 1, 'Eggs Florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770974128017-16d68adc-5d21-4310-b16c-2ed55fff4434.png', 1, 'étel'),
(51, 1, 'Eggs Benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770974162680-a82d0468-2065-43c9-aa46-8fed7eec011e.png', 1, 'étel'),
(52, 1, 'Tarja Toast Paradicsomos Babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', 'https://image2url.com/r2/default/images/1770974237984-3ad5f387-9e38-4682-8801-d8ea3b5108a6.png', 1, 'étel'),
(53, 1, 'Croque Madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770974342027-7e56eaa3-97d2-4f05-a229-505b7abaf087.png', 1, 'étel'),
(54, 1, 'Mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770974419265-4a8fc3ef-4492-468e-8c6c-032279117bd6.png', 1, 'étel'),
(55, 1, 'Monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', 'https://image2url.com/r2/default/images/1770974634862-7ea3de13-7e42-4ce2-bdf5-2edf0ee70bb0.png', 1, 'étel'),
(56, 1, 'Klasszikus Bundás Kenyér', 'friss salátával és joghurtos mártogatóssal', '2750.00', 'https://image2url.com/r2/default/images/1770974688000-03957565-4df3-4fbf-8f2f-31e2878f2466.png', 1, 'étel'),
(57, 1, 'Dupla Sajtos Bundás Kenyér', 'dupla sajtos bundás kenyér pirított gombával és nagy salátával', '3500.00', 'https://image2url.com/r2/default/images/1770975110425-6de26042-18d3-4271-8171-0a7ac6d64bfb.png', 1, 'étel'),
(58, 1, 'Kolbászos-Sajtos Bundás Kenyér', 'kolbászos-sajtos bundás kenyér friss salátával', '3650.00', 'https://image2url.com/r2/default/images/1770974919524-e2e6e836-62cf-4e3e-8d4a-77b2b05e9c2f.png', 1, 'étel'),
(59, 1, 'Ciklonburger', 'házi zöldségpogácsa friss salátával', '3450.00', 'https://image2url.com/r2/default/images/1770974978619-dd4ae9e7-9313-42b3-a812-4db3c7967f66.png', 1, 'étel'),
(60, 1, 'Pirított Zöldségek', 'pácolt tofuval és lepénnyel', '3700.00', 'https://image2url.com/r2/default/images/1770975015948-4a4de998-361d-46db-a2df-2d14eb46bece.png', 1, 'étel'),
(61, 1, 'Grillezett Sajt', 'cukkini salátával', '3750.00', 'https://image2url.com/r2/default/images/1770975173495-6b5cf11f-707b-433e-a565-a1396e34830f.png', 1, 'étel'),
(62, 1, 'Shakshuka', 'közel-keleti lecsó tojással', '3650.00', 'https://image2url.com/r2/default/images/1770975228377-f0e95543-77a7-4431-8c04-6bb40599a8ea.png', 1, 'étel'),
(63, 1, 'Buddha Bagel', 'vegán verzió friss zöldségekkel', '3450.00', 'https://image2url.com/r2/default/images/1770975299466-971c9505-3099-4b5b-af3c-72b742b3b00c.png', 1, 'étel'),
(64, 1, 'Vegan Croissant', 'házi készítésű vegán croissant', '3200.00', 'https://image2url.com/r2/default/images/1770975458834-ec9ba246-bf83-4b21-9198-e47f2e62c802.png', 1, 'étel'),
(65, 1, 'Desszert (Szezonális)', 'aktuális desszert a tábláról', '3300.00', 'https://image2url.com/r2/default/images/1770975538945-d2c16ec3-98fe-4414-9180-43b5ecde0135.png', 1, 'desszert'),
(86, 1, 'Klasszikus Étcsoki', '69%-os étcsokoládé', '1500.00', 'https://image2url.com/r2/default/images/1770975967081-8d8c82cb-67a8-4ecd-8a3e-fb5e30026555.png', 1, 'desszert'),
(87, 1, 'Mocha', 'hot chocolate + espresso shot', '1950.00', 'https://image2url.com/r2/default/images/1770976017266-012593d2-441c-407b-909c-7dec47253cba.png', 1, 'ital'),
(88, 1, 'Chai Latte', 'fűszeres chai tea latte', '1400.00', 'https://image2url.com/r2/default/images/1770976104295-e4f62976-fbcc-45bb-a3e4-e0c1bc5c08de.png', 1, 'ital'),
(89, 1, 'Dirty Chai', 'chai latte + espresso shot', '1750.00', 'https://image2url.com/r2/default/images/1770976154726-8a01490b-6771-4822-b18b-8d54f9e2c25e.png', 1, 'ital'),
(90, 1, 'Sós Karamell Latte', 'salty caramel latte', '1400.00', 'https://image2url.com/r2/default/images/1770976200980-3ecd22e9-e987-47bb-aca4-cef154a3a5e6.png', 1, 'ital'),
(91, 1, 'Dirty Sós Karamell', 'dirty salty caramel', '1750.00', 'https://image2url.com/r2/default/images/1770976272570-11a60eb6-016d-4543-9ba2-df2f777a0e19.png', 1, 'desszert'),
(92, 1, 'Kurkuma Latte', 'turmeric latte', '1400.00', 'https://image2url.com/r2/default/images/1770976328972-3669affb-0488-46cd-ad97-b123c3dd1f68.png', 1, 'ital'),
(93, 1, 'Kardamom Latte', 'cardamom latte', '1400.00', 'https://image2url.com/r2/default/images/1770976397341-b13c578d-26d0-4f7d-b64e-53eef1c3e632.png', 1, 'ital'),
(94, 1, 'Dirty Kardamom Latte', 'dirty cardamom latte', '1750.00', 'https://image2url.com/r2/default/images/1770976491585-1e372159-f191-43ac-a4ac-f3992ea77a4c.png', 1, 'ital'),
(95, 1, 'Espresso Tonic', 'espresso + tonic water', '1750.00', 'https://image2url.com/r2/default/images/1770976536280-6e52e510-fd41-477f-910d-b1651b9883e8.png', 1, 'ital'),
(146, 3, 'Zengővárkonyi Töltött Szelet Rántva', 'Sonkával, sajttal, csemege uborkával töltve, vegyes körettel', '6490.00', 'https://image2url.com/r2/default/images/1770983299417-d0ac3b4d-4e0f-4a5e-80b7-e9dcc5c8d8bb.png', 1, 'étel'),
(147, 3, 'Csülökpörkölt Kapros-túrós Galuskával', 'Fűszeres, szaftos csülökpörkölt friss kapros-túrós galuskával', '6350.00', 'https://image2url.com/r2/default/images/1770983338797-ce49fa9d-b097-463e-a54a-702eb5809f9b.png', 1, 'étel'),
(148, 3, 'Füstölt Csülkös, Kolbászos Babgulyás', 'Gazdag, füstölt húsos babgulyás kolbásszal', '4935.00', 'https://image2url.com/r2/default/images/1770983398152-6664ae8a-6992-4ea7-89d9-9012b442b2d5.png', 1, 'étel'),
(149, 3, 'Csülök Tál (2 személyes)', 'Csülök páros, rántott csülök, töltött csülök, aszalt szilvás párolt lila káposzta, hagymás törtburgonya, tepsis burgonya, tormás tejföl', '15885.00', 'https://image2url.com/r2/default/images/1770983452278-0cfb1d44-e635-4513-a5b8-2f93483375fb.png', 1, 'étel'),
(150, 3, 'Töltött Csülök Szeletek Tepsis Burgonyával', 'Házi kolbászhússal töltve, tepsis burgonyával', '6490.00', 'https://image2url.com/r2/default/images/1770983500985-cea81a7e-b564-47ef-a1cb-852dd3fc292d.png', 1, 'étel'),
(151, 3, 'Rozmaringos Kacsacomb Hagymás Törtburgonyával', '2db comb, aszaltszilvás párolt lila káposztával', '7530.00', 'https://image2url.com/r2/default/images/1770983559896-2bee46b0-58fc-4533-8f84-3093656dd5e8.png', 1, 'étel'),
(152, 3, 'Rántott Csülök Petrezselymes Burgonyával', 'Ropogós rántott csülök, petrezselymes burgonyával', '6360.00', 'https://image2url.com/r2/default/images/1770983595474-3a7addd8-3490-47a1-8486-edc9b6824dbd.png', 1, 'étel'),
(153, 3, 'Csülkös Rizses Hús', 'Tökéletes ebéd vagy vacsora, laktató, zamatos, egészséges', '6585.00', 'https://image2url.com/r2/default/images/1770983627117-752c388e-c714-48e9-8229-e040a76ebe76.png', 1, 'étel'),
(154, 3, 'Csülök Frissensült', 'Csülök páros hagymás tört burgonyával, aszalt szilvás párolt lila káposztával', '8235.00', 'https://image2url.com/r2/default/images/1770983703588-6b856c54-eb07-4cb7-9ca8-57583ff36a33.png', 1, 'étel'),
(155, 3, 'Fatányéros 1 Személyre', 'Sült hús, friss zöldségek, fűszerek, ízletes köret, hagyományos magyar étel', '8985.00', 'https://image2url.com/r2/default/images/1770983754055-facec08e-5d26-4d1c-82a8-5b6a01129d06.png', 1, 'étel'),
(156, 3, 'Gundel Palacsinta Csokiöntettel', 'Egy ínycsiklandó palacsinta csokoládéöntettel (1db)', '2070.00', 'https://image2url.com/r2/default/images/1770983794331-dade1c5d-38f1-4773-aa5f-52be8361dd0c.png', 1, 'desszert'),
(157, 3, 'Diós Palacsinta', 'Édes palacsinta dióval töltve', '1125.00', 'https://image2url.com/r2/default/images/1770983847909-cdcf6851-fe62-41cf-809f-3a069b6ea4a3.png', 1, 'desszert'),
(158, 3, 'Fahéjas Palacsinta', 'Édes palacsinta fahéjjal töltve', '1125.00', 'https://image2url.com/r2/default/images/1770984023333-e92ee4b2-3acd-446f-9dbb-b84bd5accd29.png', 1, 'desszert'),
(159, 3, 'Kakaós Palacsinta', 'Kakaós palacsinta, klasszikus magyar desszert', '1125.00', 'https://image2url.com/r2/default/images/1770984083071-a5a8422a-01e5-43c2-abb5-3b72b28da240.png', 1, 'desszert'),
(160, 3, 'Lekváros Palacsinta', 'Lekvárral töltött palacsinta', '1125.00', 'https://image2url.com/r2/default/images/1770984114425-2cc40ef7-fabf-4ba5-acee-4d3fd607a1d5.png', 1, 'desszert'),
(161, 3, 'Lekváros-Diós Palacsinta', 'Lekvár és dió ízkombinációban', '1125.00', 'https://image2url.com/r2/default/images/1770984183091-4fdbaef1-f321-4666-9464-ed42a43f9824.png', 1, 'desszert'),
(162, 3, 'Lekváros-Túrós Palacsinta', 'Lekváros és túrós palacsinta', '1125.00', 'https://image2url.com/r2/default/images/1770984610723-cb1dfe3f-4023-4dfa-a762-06720d8f6cc7.png', 1, 'desszert'),
(163, 3, 'Mogyorókrémes palacsinta', 'Palacsinta mogyorókrémmel', '1125.00', 'https://image2url.com/r2/default/images/1770984703022-238b0e3f-ce40-407e-9f0a-0dab2745a7fe.png', 1, 'desszert'),
(164, 3, 'Mogyorókrémes-Túrós Palacsinta', 'Palacsinta mogyorókrémmel és túróval', '1125.00', 'https://image2url.com/r2/default/images/1770984757546-e787794a-e937-469e-af2d-c25fe762cabd.png', 1, 'desszert'),
(165, 3, 'Gesztenyepüré', 'Gazdag és bársonyos gesztenyepüré', '2835.00', 'https://image2url.com/r2/default/images/1770984784289-f62ca39e-69c4-48d6-b378-ae5b17111722.png', 1, 'desszert'),
(166, 3, 'Forró Csokoládé', 'Gazdag, sűrű csokoládé ital', '1500.00', 'https://image2url.com/r2/default/images/1770984839891-ad9d92c3-5f39-4d35-a450-450eb9993c86.png', 1, 'ital'),
(167, 3, 'Kávé', 'Frissen főzött feketekávé', '900.00', 'https://image2url.com/r2/default/images/1770984876510-54e17e40-ea83-4bf7-8bf9-1741890c1d2b.png', 1, 'ital'),
(168, 3, 'Espresso', 'Erős, intenzív espresso', '950.00', 'https://image2url.com/r2/default/images/1770984905671-5e44be85-a43e-4196-872d-98365c81235c.png', 1, 'ital'),
(169, 3, 'Cappuccino', 'Kávé tejhabbal', '1200.00', 'https://image2url.com/r2/default/images/1770984935849-42ca5bd1-f749-4899-8e6e-2e14d99a7762.png', 1, 'ital'),
(170, 3, 'Latte', 'Kávé meleg tejjel', '1300.00', 'https://image2url.com/r2/default/images/1770984962448-4a291d12-0f2c-438b-b693-623728f3e97b.png', 1, 'ital'),
(171, 3, 'Fekete Tea', 'Forró fekete tea', '800.00', 'https://image2url.com/r2/default/images/1770984998938-1dea86ec-8532-41e3-87df-4ca3d7d9ac0e.png', 1, 'ital'),
(172, 3, 'Zöld Tea', 'Frissítő zöld tea', '900.00', 'https://image2url.com/r2/default/images/1770985030516-85c6e887-1502-4ead-b736-f25c167482a1.png', 1, 'ital'),
(173, 3, 'Narancslé', 'Frissen facsart narancslé', '1200.00', 'https://image2url.com/r2/default/images/1770985055241-8c67821a-9fd5-45f3-abb4-0942b1cf5c8b.png', 1, 'ital'),
(174, 3, 'Almalé', 'Édes, friss almalé', '1100.00', 'https://image2url.com/r2/default/images/1770985111801-bc39af96-0c7f-457d-89ca-a1adc54ccb2d.png', 1, 'ital'),
(175, 3, 'Szénsavas Üdítő', 'Különböző ízekben', '900.00', 'https://image2url.com/r2/default/images/1770985190442-5d169382-6827-4265-bc34-72e3d7950c93.png', 1, 'ital'),
(176, 4, 'Slim Mint', 'Eper, Menta, Lime, Ananász, Alma', '2490.00', 'https://image2url.com/r2/default/images/1770985350397-4c121345-a5ff-4142-820c-ae7997a44f70.png', 1, 'ital'),
(177, 4, 'Passion Of Fruit', 'Banán, Ananász, Mangó, Alma', '2490.00', 'https://image2url.com/r2/default/images/1770985498519-93743832-3935-4af0-b9f3-7a381644814d.png', 1, 'ital'),
(178, 4, 'Popeye', 'Alma, Spenót, Ananász', '2490.00', 'https://image2url.com/r2/default/images/1770985618132-f3e4b94e-5a12-4d8e-a842-5bb140eaf83d.png', 1, 'ital'),
(179, 4, 'Mr. Avocado', 'Alma, Avokádó, Ananász', '2490.00', 'https://image2url.com/r2/default/images/1770985683893-0460f1e8-eeb5-49ef-8090-1081c49aab54.png', 1, 'ital'),
(180, 4, 'Green Power', 'Petrezselyem, Uborka, Zellerszár, Alma, Banán', '2490.00', 'https://image2url.com/r2/default/images/1770985716107-5b74fa94-2e0d-4a87-aaf9-cefbb1cd7c3e.png', 1, 'ital'),
(181, 4, 'Juicy Mango', 'Mangó, Kiwi, Narancs', '2490.00', 'https://image2url.com/r2/default/images/1770985788903-5e3d1359-85b0-4281-ba31-37a95afbd4d8.png', 1, 'ital'),
(182, 4, 'Vitaminator', 'Banán, Eper, Narancs, Menta', '2490.00', 'https://image2url.com/r2/default/images/1770985817953-036054e9-21c1-435e-992e-f7c0887b6063.png', 1, 'ital'),
(183, 4, 'Captain Kiwi', 'Alma, Kiwi, Banán, Narancs', '2490.00', 'https://image2url.com/r2/default/images/1770985844346-2bd6ea73-13fa-4e34-a48b-0d3dc334da27.png', 1, 'ital'),
(184, 4, 'Chia Mia', 'Chiamag, Alma, Mangó, Eper', '2490.00', 'https://image2url.com/r2/default/images/1770986015065-e7649dfa-0c47-41f6-a4bc-531a302d1ed2.png', 1, 'ital'),
(185, 4, 'Yellow Fellow', 'Alma, Mangó, Barack', '2490.00', 'https://image2url.com/r2/default/images/1770986068913-bd281e8a-e72b-4d8d-9997-6f1b5031800f.png', 1, 'ital'),
(186, 4, 'Müzli Tál', 'Natúr Joghurt, Granola, Zabpehely, Friss & Aszalt Gyümölcsök, Méz', '2990.00', 'https://image2url.com/r2/default/images/1770986240592-22be09d0-1aed-4919-97bf-0617bbec5161.png', 1, 'étel'),
(187, 4, 'NYC Salmon Bagel', 'Füstölt lazac szelet, krémsajt, jégsaláta és lilahagyma', '3090.00', 'https://image2url.com/r2/default/images/1770986278155-c90b99fd-4766-4701-9a75-e8be12447032.png', 1, 'étel'),
(188, 4, 'Füstölt lazacos Bagel', 'Avokádókrém, Uborka, Saláta & Füstölt Lazac', '3090.00', 'https://image2url.com/r2/default/images/1770986313098-a4c89469-0a6a-4c34-a3c2-4a1889bfa90c.png', 1, 'étel'),
(189, 4, 'Avokádókrémes Bagel', 'Avokádókrém, Uborka & Saláta', '2490.00', 'https://image2url.com/r2/default/images/1770986407209-6d5aa7ed-ee5a-45b7-aa94-f6886c6f045f.png', 1, 'étel'),
(190, 4, 'Zöld Pestós & Mozzarellás Bagel', 'Zöld Pestó, Mozzarella, Jégsaláta & Paradicsom', '2790.00', 'https://image2url.com/r2/default/images/1770986449880-7db9a862-3459-4499-84ea-fe0e5573faf2.png', 1, 'étel'),
(191, 4, 'Prosciutto & Bryndza Bagel', 'Bryndza Sajt, Prosciutto, Paradicsom & Jégsaláta', '2790.00', 'https://image2url.com/r2/default/images/1770986491668-7b3f2eaa-732c-4e70-bfcf-c8b65c64cfa9.png', 1, 'étel'),
(192, 4, 'Feta Sajtos Bagel', 'Feta Sajt, Paradicsom, Uborka & Saláta', '2790.00', 'https://image2url.com/r2/default/images/1770986528214-e4b891cb-b214-4e38-b633-226bffc83423.png', 1, 'étel'),
(193, 4, 'Humuszos Bagel', 'Csicseriborsókrém, Uborka & Saláta', '2490.00', 'https://image2url.com/r2/default/images/1770986551811-5d6b84e2-7d8d-4120-a175-2fd03ed2d909.png', 1, 'étel'),
(194, 4, 'Cream Cheese Bagel', 'Krémes sajt', '1890.00', 'https://image2url.com/r2/default/images/1770986573645-f6eec29b-dc8c-441b-be9f-42328b1ca411.png', 1, 'étel'),
(195, 4, 'Zöld Smoothie Tál', 'Banán, Spenót, Fodros Kelkáposzta, Petrezselyem, Menta, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986608391-5ebf1e2b-8733-4253-9ad0-20e54e8085fc.png', 1, 'étel'),
(196, 4, 'Sárga Smoothie Tál', 'Banán, Mangó, Ananász, Lenmag, Chia mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986669160-bcdc739d-2cc5-48f7-8504-31fabfb8a2ab.png', 1, 'étel'),
(197, 4, 'Piros Smoothie Tál', 'Banán, Eper, Málna, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986705902-ee3174e6-2b6f-4438-a514-f6e9bdb1b181.png', 1, 'étel'),
(198, 4, 'Mexican Bowl 🌶', 'Avokádó krém, Fekete bab, Kukorica, Lilahagyma, Lime, Jégsaláta, Paradicsom, Tortilla chips, Chilis olívaolaj', '3890.00', 'https://image2url.com/r2/default/images/1770986736581-1ae3773e-e959-4a3b-b91f-3558fad446fe.png', 1, 'étel'),
(199, 4, 'Avokádó Tál', 'Házi avokádókrém, Olívabogyók, Feta Sajt, Paradicsom, Zellerszár, Uborka, Pita vagy Bagel', '4190.00', 'https://image2url.com/r2/default/images/1770986763577-e4254b25-1ba3-4f0b-83c0-dfbea7f4cd0c.png', 1, 'étel'),
(200, 4, 'L.A.X. Tál', 'Füstölt Lazac, Avokádó krém, Paradicsom, Kukorica, Uborka, Saláta, Citrom', '4190.00', 'https://image2url.com/r2/default/images/1770986791384-848d054a-0a66-418d-a2b4-c2f29f32e542.png', 1, 'étel'),
(201, 4, 'Hummus Tál', 'Házi Humusz, Olívabogyók, Feta Sajt, Paradicsom, Cékla, Uborka, Pita vagy Bagel', '3890.00', 'https://image2url.com/r2/default/images/1770986825273-1e19c771-63d1-40b3-ac9e-a4214065efd8.png', 1, 'étel'),
(202, 4, 'Atom', 'Narancs, Eper, Banán, Tej, Méz, Zabpehely', '2490.00', 'https://image2url.com/r2/default/images/1770986893063-71bb3ddf-e316-4f8b-b102-bd62bcbc0979.png', 1, 'ital'),
(203, 4, 'No. 22', 'Szójatej, Goji Bogyó, Chia Mag, Zabpehely, Aszalt gyümölcs, Banán, Lenmag', '2690.00', 'https://image2url.com/r2/default/images/1770986946412-1c7dbb73-4589-4aaa-afbb-887e103ef856.png', 1, 'ital'),
(204, 4, 'FRrØyas DrØm', 'Alma, Mangó, Banán, Szójatej, Méz, Eper, Vanília', '2690.00', 'https://image2url.com/r2/default/images/1770987000054-c4b41a09-cd87-44a0-9fa9-05cbf8d3e741.png', 1, 'ital'),
(205, 4, 'Good Vibes', 'Ananász, Menta, Alma, Citrom, Banán, Jégkása', '2690.00', 'https://image2url.com/r2/default/images/1770987028245-6d4a407c-5817-41b9-85d4-2a0c03b956d1.png', 1, 'ital'),
(206, 5, 'Rántott Csirkemell Körettel', 'Kérlek, válassz köretet!', '2800.00', 'https://image2url.com/r2/default/images/1770987587376-0ea2ad0d-179a-487d-b7e7-ac3c1fc4cdca.png', 1, 'étel'),
(207, 5, 'Húsleves', 'Laktató leves sok hússal és zöldséggel.', '1190.00', 'https://image2url.com/r2/default/images/1770987629718-8abdd8b7-a224-435e-88dd-8c0a86a21709.png', 1, 'étel'),
(208, 5, 'Rántott Zöldség Körettel, Tartármártással', 'Kérlek válassz köretet!', '2800.00', 'https://image2url.com/r2/default/images/1770987693932-398a4caa-851b-440e-ba71-2150c15c9b39.png', 1, 'étel'),
(209, 5, 'Bolognai Sertésborda', 'A bolognai sertésborda egy olasz étel, amelyet ropogósra sütött, fűszeres zsemlemorzsával paníroznak. Olyan omlós és ízletes, hogy nem tudsz majd betelni vele.', '3990.00', 'https://image2url.com/r2/default/images/1770988126439-3f40fd2d-01a8-4601-9ffe-11c269790987.png', 1, 'étel'),
(210, 5, 'Sajttal-Sonkával Töltött Csirkemell Hasábburgonyával', 'Sajttal töltött csirkemell, ropogós hasábburgonyával, ízletes és laktató étel.', '3990.00', 'https://image2url.com/r2/default/images/1770988182104-c6775743-a7b1-4657-a8c3-9f752f9e8adf.png', 1, 'étel'),
(211, 5, 'Bableves', '', '1500.00', 'https://image2url.com/r2/default/images/1770988208647-2038c8e4-c195-4b04-ba5d-13b83f445368.png', 1, 'étel'),
(212, 5, 'Sertéspörkölt Galuskával Választható Coca-Cola Üdítővel', '', '3800.00', 'https://image2url.com/r2/default/images/1770988274895-0c4b6946-d7da-4b5e-97f7-471b6a998cb4.png', 1, 'étel'),
(213, 5, 'Bolognai Spagetti Választható Coca-Cola Üdítővel', '', '3200.00', 'https://image2url.com/r2/default/images/1771231645947-d4a91490-30bf-4d4c-8590-ea95d5b13946.png', 1, 'étel'),
(214, 5, 'Rántott Csirkemell Hasábburgonyával, Választható Coca-Cola Üdítővel', '', '3500.00', 'https://image2url.com/r2/default/images/1771231723984-1047d8ba-b5ac-4c71-9901-a608bb26c0aa.png', 1, 'étel'),
(215, 5, 'Babgulyás', '', '2500.00', 'https://image2url.com/r2/default/images/1771231746071-8bc55cc1-8473-4757-b7a3-db61187b3794.png', 1, 'étel'),
(216, 5, 'Gyümölcsleves', 'A gyümölcsleves egy finom és egészséges fogás, feltölt energiával és jókedvre derít!', '1550.00', 'https://image2url.com/r2/default/images/1771231783542-a8dd35be-cf7a-46f5-a09b-5d7c5f3f7210.png', 1, 'étel'),
(217, 5, 'Bolognai Spagetti', 'Kényeztesd az ízlelőbimbóidat az ízletes, krémes bolognai spagettivel! A klasszikus olasz kedvenc, amely bővelkedik az ízekben.', '2800.00', 'https://image2url.com/r2/default/images/1771231836412-4367b0fe-e8a5-4ac2-b2db-764fb1fcd39f.png', 1, 'étel'),
(218, 5, 'Sertéspörkölt Galuskával', 'Pörkölt galuskával: a magyar konyha klasszikusa. Puha hús, szaftos mártás, finom galuska. Egytálétel, ami mindig jól esik.', '4200.00', 'https://image2url.com/r2/default/images/1771231873743-8cd489b1-152e-4183-b06c-417ca5694ed1.png', 1, 'étel'),
(219, 5, 'Rántott Karaj Hasábburgonyával', 'Panírozott hús, ropogós, sült krumplival tálalva, ízletes és laktató étel.', '2800.00', 'https://image2url.com/r2/default/images/1771231962067-186280dd-f443-491c-be50-915c1f46c0de.png', 1, 'étel'),
(220, 5, 'Szezámmagos Csirkemell Hasábburgonyával', 'A csirke új dimenziója.', '2800.00', 'https://image2url.com/r2/default/images/1771231991921-f8b47af6-9fd0-475b-aea5-382236a4e488.png', 1, 'étel'),
(221, 5, 'Corn Flakes Csirkemell Hasábburgonyával', 'Ropogós kukoricapehely, ízletes csirkemell és ropogós hasábburgonya kombinációja.', '2990.00', 'https://image2url.com/r2/default/images/1771232053901-1b235136-6064-4111-8ddd-ad647f52000f.png', 1, 'étel'),
(222, 5, 'Mecseki Csirkemell Hasábburgonyával', 'Szaftos csirkemell, ropogós hasábburgonya, ízletes fűszerezés, tökéletes étkezés minden alkalomra.', '3990.00', 'https://image2url.com/r2/default/images/1771232084701-fff55901-2463-4529-aa6b-8f986a42ef89.png', 1, 'étel'),
(223, 5, 'Mecseki Sertésszelet Hasábburgonyával', 'Szaftos hús, ropogós hasábburgonya, ízletes fűszerezés, tökéletes választás étteremben.', '3990.00', 'https://image2url.com/r2/default/images/1771232192260-dc68634e-f8ca-4497-a113-d3ce174c6582.png', 1, 'étel'),
(224, 5, 'Sajttal-Sonkával-Gombával Töltött Sertéskaraj Hasábburgonyával', 'Sajttal, gombával töltött hús, ropogós hasábburgonyával tálalva, ízletes és laktató étel.', '3990.00', 'https://image2url.com/r2/default/images/1771232233479-918947b9-3566-40cb-b75f-8248fa15a707.png', 1, 'étel'),
(225, 5, 'Rántott Sajt Jázminrizzsel, Tartármártással', 'Nincs is jobb a rántott sajtnál, amikor megkívánod a ropogós falatokat.', '3590.00', 'https://image2url.com/r2/default/images/1771232353065-c3cef65e-895b-40aa-b5b3-8a2331614902.png', 1, 'étel'),
(226, 5, 'Rántott Camembert Sajt Jázminrizzsel, Áfonyalekvárral', 'A rántott sajt egy klasszikus vegetáriánus étel, amelyet ropogósra sütnek, hogy aztán a sajt elolvadjon a szádban.', '3790.00', 'https://image2url.com/r2/default/images/1771232398978-686a8cad-d433-4164-9f53-0eb441f5aa4a.png', 1, 'étel'),
(227, 5, 'Hasábburgonya', 'Frissen és forrón tálalva!', '1100.00', 'https://image2url.com/r2/default/images/1771232436339-537d595f-ee1e-403b-8bee-8cb4b67d927c.png', 1, 'étel'),
(228, 5, 'Petrezselymes Burgonya', 'Ízletes petrezselymes burgonya, amely tökéletes köretnek vagy akár főételnek is.', '1390.00', 'https://image2url.com/r2/default/images/1771232474982-0bdef5db-76da-4da6-baf4-3c0a21a10116.png', 1, 'étel'),
(229, 5, 'Steak Burgonya', 'Sült burgonya', '1390.00', 'https://image2url.com/r2/default/images/1771232506218-9bda87b1-e93a-40d4-9406-4366064b19e1.png', 1, 'étel'),
(230, 5, 'Cézár Saláta', 'Élvezd Cézár salátánk merész és zamatos ízét, amely semmihez sem fogható ízélményt nyújt!', '2990.00', 'https://image2url.com/r2/default/images/1771232535127-96f9a055-c5db-41cb-afbd-2a26d123d4b1.png', 1, 'étel'),
(231, 5, 'Görög Saláta', 'Élvezd a roppanós és krémes textúrák tökéletes egyensúlyát minden egyes falatnál!', '2690.00', 'https://image2url.com/r2/default/images/1771232561186-23fc7ca3-8532-4815-a4bb-d391adbf169d.png', 1, 'étel'),
(232, 5, 'Káposztasaláta', 'Tapasztald meg a krémes és a ropogós tökéletes keverékét, klasszikus káposztasalátánkkal - ideális köret grillételekhez, szendvicsekhez és hamburgerekhez!', '850.00', 'https://image2url.com/r2/default/images/1771232587978-1fa24b91-e391-4b20-b3b5-291fbd647352.png', 1, 'étel'),
(233, 5, 'Csemegeuborka', 'A klasszikus magyar ételekhez tökéletes savanyúság.', '700.00', 'https://image2url.com/r2/default/images/1771232676737-10735580-9455-4777-b994-1f2153a5dd1a.png', 1, 'étel'),
(234, 5, 'Majonéz', 'Tapasztald meg klasszikus majonézünk sima és bársonyos ízét - egy sokoldalú összetevő, amely minden kedvenc ételed tökéletes kiegészítője lehet!', '300.00', 'https://image2url.com/r2/default/images/1771232704964-302a83d5-28ee-40ca-8cc7-9fa49be353d6.png', 1, 'étel'),
(235, 5, 'Tartármártás', 'Tapasztald meg az ízek tökéletes egyensúlyát klasszikus tartármártásunkkal!', '400.00', 'https://image2url.com/r2/default/images/1771232779040-c2490f2a-79ed-429c-947d-8699afb73761.png', 1, 'étel'),
(236, 5, 'Diós Palacsinta', 'Egy adag 1 darabot tartalmaz', '500.00', 'https://image2url.com/r2/default/images/1771232827483-5c99b62d-cf8a-47c6-8fd8-8856fb1d50dc.png', 1, 'desszert'),
(237, 6, 'Szezámmagos Csirkemellcsíkok', 'Friss salátával tálalva, ropogós szezámmagos csirkecsíkok', '3600.00', 'https://image2url.com/r2/default/images/1771232887077-118bc58d-0301-4c8e-8fdb-f7fa0dbc2d48.png', 1, 'étel'),
(238, 6, 'Roston Sült Csirkemell', 'Balzsamecetes, friss salátával, krokettel', '3900.00', 'https://image2url.com/r2/default/images/1771232935227-c2ba3421-cac8-4e29-b344-7a81bc63e693.png', 1, 'étel'),
(239, 6, 'Sajttal-Sonkával Töltött Csirkemell', 'Rizzsel tálalva, laktató és ízletes', '3900.00', 'https://image2url.com/r2/default/images/1771233068984-60842584-5ff6-4776-b1bf-ff8200d7bd22.png', 1, 'étel'),
(240, 6, 'Sajttal Töltött Csirkemell', 'Ropogós hasábburgonyával', '3600.00', 'https://image2url.com/r2/default/images/1771233332425-b3e9e933-701a-44cf-b0a2-f227155c81b0.png', 1, 'étel'),
(241, 6, 'Almával-Sajttal-Dióval Töltött Csirkemell', 'Rizzsel és áfonyalekvárral tálalva', '4300.00', 'https://image2url.com/r2/default/images/1771233409362-e110d39a-a9d9-4750-8bb8-fa43c0ab4e89.png', 1, 'étel'),
(242, 6, 'Gombás-Tejszínes Csirkeragu', 'Spagetti tésztával vagy párolt rizzsel', '3600.00', 'https://image2url.com/r2/default/images/1771233443221-39291142-10c7-464e-a13b-6c3c3442d15d.png', 1, 'étel'),
(243, 6, 'Rántott Vagy Roston Sült Csirkemell', 'Frissen sült, hasábburgonyával', '3600.00', 'https://image2url.com/r2/default/images/1771233546110-72d39c23-9534-470d-8a48-00d395442a8f.png', 1, 'étel'),
(244, 6, 'Sült Bőrös Császár', 'Fokhagymás burgonyapürével és pácolt almasalátával', '4300.00', 'https://image2url.com/r2/default/images/1771233589531-dc0a6220-47b0-4271-b67d-5bdf87747833.png', 1, 'étel'),
(245, 6, 'Pacalpörkölt', 'Gazdag, fűszeres pacalpörkölt', '4300.00', 'https://image2url.com/r2/default/images/1771233619491-0f4949b3-d02f-49ee-b3c5-35ecedafb9cc.png', 1, 'étel'),
(246, 6, 'BBQ Oldalas', 'Steakburgonyával és coleslaw salátával tálalva', '5500.00', 'https://image2url.com/r2/default/images/1771233654165-e1bded5d-d156-4d2f-8bce-abfe4719a28b.png', 1, 'étel'),
(247, 6, 'Csülök Rite Módra', 'Hagyományos módon elkészített csülök', '5500.00', 'https://image2url.com/r2/default/images/1771233686463-2893a824-ae4d-4212-afdb-4b909f2639dc.png', 1, 'étel'),
(248, 6, 'Brassói Aprópecsenye', 'Ízletes aprópecsenye házi fűszerezéssel', '4800.00', 'https://image2url.com/r2/default/images/1771233715855-ed3c6bd4-89e5-40a8-8ff1-c2ffd393bd3f.png', 1, 'étel'),
(249, 6, 'Brownie Vaníliafagyival', 'Forró brownie, vaníliafagyival tálalva', '1800.00', 'https://image2url.com/r2/default/images/1771233742433-eefe5fd0-36c4-438f-9b55-8c429053401a.png', 1, 'desszert'),
(250, 6, 'Óriás Palacsinta', 'Mogyorós csokoládékrémmel töltve, csokoládészósszal és prémium vaníliafagyival', '2390.00', 'https://image2url.com/r2/default/images/1771233793251-16392f05-d4bd-4715-bc51-20c288b837ee.png', 1, 'desszert'),
(251, 6, 'Vargabéles', 'Hagyományos magyar desszert', '1800.00', 'https://image2url.com/r2/default/images/1771233820514-c1985354-6a48-49af-ae96-4e7f60fee9da.png', 1, 'desszert'),
(252, 6, 'Gesztenyepüré', 'Krémes gesztenyepüré desszertként', '1690.00', 'https://image2url.com/r2/default/images/1771233893043-7f20dbbe-0b3c-4ec5-bd4b-59a3472f74b4.png', 1, 'desszert'),
(253, 6, 'Angol Zöldköret', 'Frissen készített zöldköret köretként', '1400.00', 'https://image2url.com/r2/default/images/1771233867958-d610915f-d342-4f61-b8cd-06ddf635e623.png', 1, 'étel'),
(254, 6, 'Házi Galuska', 'Puha, házi készítésű galuska köretként', '950.00', 'https://image2url.com/r2/default/images/1771233956850-f6b0dacb-49a8-477d-8522-41e1bd7511b1.png', 1, 'desszert'),
(255, 6, 'Rizs', 'Párolt rizs köretként', '950.00', 'https://image2url.com/r2/default/images/1771233990725-dbc04604-8217-4f24-826d-7a551a26bfad.png', 1, 'étel'),
(256, 6, 'Steakburgonya', 'Sült burgonya steak mellé', '1000.00', 'https://image2url.com/r2/default/images/1771234022117-dd84c387-2a9d-4c7c-b9c9-34197cd13c17.png', 1, 'étel'),
(257, 6, 'Burgonyapüré', 'Frissen készített krémes burgonyapüré', '1150.00', 'https://image2url.com/r2/default/images/1771234048552-989f08f0-416a-45ed-9d04-4a9c296230bb.png', 1, 'étel'),
(258, 6, 'Burgonyakrokett', 'Ropogós burgonyakrokett köretként', '950.00', 'https://image2url.com/r2/default/images/1771234077458-337f1e9c-e706-426b-91c7-5cb7c214b89c.png', 1, 'étel'),
(259, 6, 'Hasábburgonya', 'Frissen sült hasábburgonya köretként', '900.00', 'https://image2url.com/r2/default/images/1771234110533-dc6b2c3e-da1b-4fe4-9f3c-edd8560e1b6e.png', 1, 'étel'),
(260, 6, 'Pécsi Radler Bodza 0,5l', 'Frissítő bodzás ízesítésű Radler', '790.00', 'https://image2url.com/r2/default/images/1771234171652-a6f5c530-6282-4a31-9553-9ead02741177.png', 1, 'ital'),
(261, 6, 'Pécsi Radler Meggy 0,5l', 'Finom meggyes ízesítésű Radler', '790.00', 'https://image2url.com/r2/default/images/1771234198418-2f3a1473-45b8-4629-b80e-4dcc6d58a949.png', 1, 'ital'),
(262, 6, 'Gyümölcsfröccs', 'Fagyasztott gyümölcs, fekete ribizli, szóda (0,4 l)', '960.00', 'https://image2url.com/r2/default/images/1771235573190-4f13f9c1-4a14-40c3-a751-625165921ccf.png', 1, 'ital'),
(263, 6, 'Házi Limonádé', 'Friss, házilag készített limonádé (0,1 l)', '250.00', 'https://image2url.com/r2/default/images/1771235605766-61a36152-6575-49b0-b355-b9be4eebf4b7.png', 1, 'étel'),
(264, 6, 'Ice Tea Barack', 'Barack ízű jeges tea (0,1 l)', '200.00', 'https://image2url.com/r2/default/images/1771235669710-8db532b1-5b41-4bab-9a05-2bd447fc3cbf.png', 1, 'ital'),
(265, 6, 'Ice Tea Citrom', 'Citrom ízű jeges tea (0,1 l)', '200.00', 'https://image2url.com/r2/default/images/1771235713351-1cb39083-eed7-4467-96d4-de3cdacda225.png', 1, 'ital'),
(266, 6, 'Szóda', 'Frissítő szódavíz (0,1 l)', '50.00', 'https://image2url.com/r2/default/images/1771235753881-7801468d-07c3-4eb8-9bca-20e365d9bfcc.png', 1, 'ital'),
(267, 7, 'Húsleves Gazdagon', 'Laktató leves sok hússal és zöldséggel', '1900.00', 'https://image2url.com/r2/default/images/1771234273406-4c01358b-e1df-4c45-a15a-51a9214bf560.png', 1, 'étel'),
(268, 7, 'Medvehagymával, Füstölt Sajttal Töltött Karaj Bundázva Hasábburgonyával', 'Füstölt sajttal töltött hús, bundázva, hasábburgonyával tálalva, medvehagymás ízvilággal', '6150.00', 'https://image2url.com/r2/default/images/1771234325287-656776f5-f9ce-4147-942f-ed97628c0531.png', 1, 'étel'),
(269, 7, 'Tejfölös Uborkasaláta', 'Klasszikus uborkasaláta, friss és ízletes', '1510.00', 'https://image2url.com/r2/default/images/1771234355385-b74a4b11-9f51-48cb-b039-707c7a09e0e3.png', 1, 'étel'),
(270, 7, 'Rántott Szelet Rizibizivel', 'Ropogós, aranybarna rántott hús, rizibizivel tálalva', '5170.00', 'https://image2url.com/r2/default/images/1771234391757-c601a1b2-bd4e-4213-b220-99a939275aa7.png', 1, 'étel'),
(271, 7, 'Filézett Rántott Csirkecomb Burgonyapürével', 'Rántott csirkecomb, krémes burgonyapürével, ízletes és laktató', '5620.00', 'https://image2url.com/r2/default/images/1771234450150-7e360960-1506-45fd-8ab7-c492f224ff86.png', 1, 'étel'),
(272, 7, 'Rántott Camembert Áfonyalekvárral, Rizzsel', 'Olvadós rántott sajt áfonyalekvárral és rizzsel', '4840.00', 'https://image2url.com/r2/default/images/1771234499809-bdba33b5-14cf-4d28-b19f-937573010865.png', 1, 'étel'),
(273, 7, 'Borzas Csirkemell Hasábburgonyával', 'Ropogós csirkemell, ízletes hasábburgonyával', '5820.00', 'https://image2url.com/r2/default/images/1771234540046-002eaa59-f260-46de-b783-d1e58f34176a.png', 1, 'étel'),
(274, 7, 'Bolognai Spagetti', 'Finom, laktató bolognai spagetti', '4850.00', 'https://image2url.com/r2/default/images/1771234581498-6e3fee91-935d-4b44-ad3e-8ec343c5bc44.png', 1, 'étel'),
(275, 7, 'Natúr Csirkemell Kevert Friss Salátával', 'Omlós csirkemell friss salátával', '5690.00', 'https://image2url.com/r2/default/images/1771234621142-a9e49c2a-0b92-457b-9e51-de1c331864a8.png', 1, 'étel'),
(276, 7, 'Kacsasült Petrezselymes Burgonyával, Párolt Lila Káposztával', 'Fél kacsa, ízletes burgonyával és káposztával', '6600.00', 'https://image2url.com/r2/default/images/1771234668434-dcdc1a2b-8afa-4ce0-8f67-002c41157e02.png', 1, 'étel'),
(277, 7, 'Tepsiben Sült Oldalas Petrezselymes Burgonyával', 'Sült hús fűszeres burgonyával', '6340.00', 'https://image2url.com/r2/default/images/1771234726301-0156d6da-96cd-4a7d-80a8-21e22111932e.png', 1, 'étel'),
(278, 7, 'Cigánypecsenye Fűszeres Héjas Burgonyával', 'Hagyományos magyar ízletes, lédús hús', '6340.00', 'https://image2url.com/r2/default/images/1771234776661-2afa498a-8d22-4b4e-8c12-85277217b1de.png', 1, 'étel'),
(279, 7, 'Gyros Tál', 'Fűszeres hús, pita, friss zöldségek és ízletes szószok', '5950.00', 'https://image2url.com/r2/default/images/1771234816139-111f97a9-0287-46fd-9299-1fe71297c156.png', 1, 'étel'),
(280, 7, 'Harcsafilé Rántva Kukoricasalátával', 'Rántott harcsafilé friss kukoricasalátával', '6150.00', 'https://image2url.com/r2/default/images/1771234852319-caaf7f05-b468-44b0-8f25-c6af1caa67ab.png', 1, 'étel'),
(281, 7, 'Vadas Zsemlegombóccal', 'Fűszeres, szaftos hús zsemlegombóccal', '6530.00', 'https://image2url.com/r2/default/images/1771234883329-972badaa-fe59-42aa-b260-a6d6ed3d12dc.png', 1, 'étel'),
(282, 7, 'Marhapörkölt Nokedlivel', 'Hagyományos magyar marhapörkölt nokedlivel', '6530.00', 'https://image2url.com/r2/default/images/1771234911636-3518d769-b31f-4465-9069-73aa07cb1110.png', 1, 'étel'),
(283, 7, 'Töltött Káposzta', 'Ízletes, tápláló töltött káposzta', '5490.00', 'https://image2url.com/r2/default/images/1771234986917-ed704579-71d4-4d43-b1ef-d1c6f5c500e4.png', 1, 'étel'),
(284, 7, 'Csülkös Pacalpörkölt Főtt Burgonyával', 'Szaftos pacalpörkölt főtt burgonyával', '5690.00', 'https://image2url.com/r2/default/images/1771235016116-fb42e620-3f36-4e06-a708-962d23484570.png', 1, 'étel'),
(285, 7, 'Hasábburgonya', 'Frissen sült, forró hasábburgonya', '1350.00', 'https://image2url.com/r2/default/images/1771235042921-f49d6d76-656a-4ac2-84f5-87a6b9546a53.png', 1, 'étel'),
(286, 7, 'Jázminrizs', 'Klasszikus köret, tökéletes minden ételhez', '1250.00', 'https://image2url.com/r2/default/images/1771235066554-12e2e235-c5e9-4575-8b1c-8786a557c3f2.png', 1, 'étel'),
(287, 7, 'Rizibizi', 'Fehér rizs zöldborsóval, ízletes és klasszikus', '1350.00', 'https://image2url.com/r2/default/images/1771235091957-f7cdbc87-daa0-4e0b-a97c-9d406bcbc1a8.png', 1, 'étel'),
(288, 7, 'Kevert Friss Saláta', 'Jégsaláta, uborka, paradicsom, lila hagyma, paprika', '2630.00', 'https://image2url.com/r2/default/images/1771235120379-bc1f596f-6730-4c25-b8a9-9ce628bcf1e9.png', 1, 'étel'),
(289, 7, 'Görög Saláta', 'Jégsaláta, paradicsom, uborka, paprika, feta sajt, olívabogyó', '2960.00', 'https://image2url.com/r2/default/images/1771235143789-17bb651c-9e43-46b5-ae62-735b30cd8fb7.png', 1, 'étel'),
(290, 7, 'Somlói Galuska', 'Elragadóan könnyű, gazdagon, krémmel tálalva', '1790.00', 'https://image2url.com/r2/default/images/1771235173374-0ff2ea98-ef81-466b-bcb2-523d24e4ec21.png', 1, 'étel'),
(291, 7, 'Palacsinta (1db)', 'Választható ízesítéssel, friss palacsinta', '800.00', 'https://image2url.com/r2/default/images/1771235216693-daf9a94e-e816-4749-ba78-87e4e55eadad.png', 1, 'desszert'),
(292, 7, 'Tartármártás', 'Klasszikus, ízletes tartármártás', '670.00', 'https://image2url.com/r2/default/images/1771235251240-088185e5-9af4-4060-8a5c-6cb550930472.png', 1, 'étel'),
(293, 7, 'Tejfölös Uborkasaláta', 'Klasszikus, friss és ízletes', '1510.00', 'https://image2url.com/r2/default/images/1771235291799-0cf7b7e2-2b35-4e1a-897f-f78302535b64.png', 1, 'étel'),
(294, 7, 'Paradicsomsaláta Lila Hagymával', 'Friss paradicsomsaláta, köretként tökéletes', '1510.00', 'https://image2url.com/r2/default/images/1771235357410-e48dad29-ab6a-4cdd-b275-c747e6ba0c3a.png', 1, 'étel'),
(295, 7, 'Ecetes Almapaprika', 'Savanyúság, egyedi ízzel', '1270.00', 'https://image2url.com/r2/default/images/1771235384623-337e5818-5d0d-4cd9-8d2d-0729af4cffd9.png', 1, 'étel'),
(296, 7, 'Csemegeuborka', 'Kiváló kiegészítő sültek vagy magyaros ételek mellé', '1270.00', 'https://image2url.com/r2/default/images/1771235414110-ba0bb352-2657-42c9-b07e-12905a097313.png', 1, 'étel'),
(297, 7, 'Káposztasaláta', 'Friss, klasszikus káposztasaláta ízzel', '1270.00', 'https://image2url.com/r2/default/images/1771235441993-aecec25f-f690-4e05-8d32-15d3f89d7f3a.png', 1, 'étel'),
(298, 7, 'Cékla', 'Fűszeres, savanyú cékla köretként', '1268.00', 'https://image2url.com/r2/default/images/1771235473744-01752185-0965-4986-8def-3414c720c1b7.png', 1, 'étel'),
(299, 9, 'Döner Kebap', 'Friss pita, friss saláta (válassz húst)', '2490.00', 'https://image2url.com/r2/default/images/1771235874868-0b691230-c5d2-4710-a165-54258fc97d4e.png', 1, 'étel'),
(300, 9, 'Dürüm Kebap', '30cm tortilla, friss saláta, csípős szósz, joghurtos szósz (válassz húst)', '2690.00', 'https://image2url.com/r2/default/images/1771235930604-9b4d248b-aca0-44df-84e2-8257fed76672.png', 1, 'étel'),
(301, 9, 'Döner Box', 'Friss saláta, választható szósz (válassz húst és köretet)', '2690.00', 'https://image2url.com/r2/default/images/1771235958654-50f313f5-f92f-4cb9-b6f8-af51345bca71.png', 1, 'étel'),
(302, 9, 'Kebap Tál', 'Friss saláta (válassz húst és köretet)', '3890.00', 'https://image2url.com/r2/default/images/1771235991611-0454e1af-2320-49da-9d31-deeefd643457.png', 1, 'étel'),
(303, 9, 'Duna Chéf Saláta', 'Kápia paprika, tv paprika, kígyóuborka, paradicsom, friss pita (válassz húst és szószt)', '2890.00', 'https://image2url.com/r2/default/images/1771236018222-7d14888e-32ee-4520-bb15-9a5d95336e41.png', 1, 'étel'),
(304, 9, 'Sült Sajtos Kebap Tál', 'Sült krumpli, sajt (válassz húst)', '4190.00', 'https://image2url.com/r2/default/images/1771236074553-1c4c3e06-9fea-4e50-b953-eb2de21b0302.png', 1, 'étel'),
(305, 9, 'Sült-Zöldséges Sajtos Csirke Kebap', 'Friss pita, csirke döner hús, sült paprika, sült padlizsán, feta sajt, jégsaláta, lilakáposzta, lilahagyma, paradicsom, joghurtos és csípős szósz', '2890.00', 'https://image2url.com/r2/default/images/1771236108263-0b9c0de1-c166-406d-be7a-da31d6058cdd.png', 1, 'étel'),
(306, 9, 'Sült-Zöldséges Sajtos Borjú Kebap', 'Friss pita, borjú döner hús, sült paprika, sült padlizsán, feta sajt, jégsaláta, lilakáposzta, lilahagyma, paradicsom, joghurtos és csípős szósz', '2990.00', 'https://image2url.com/r2/default/images/1771236143037-ab475ffe-c786-468c-a37c-1d4735d72620.png', 1, 'étel'),
(307, 9, 'Margarita Pizza (32cm)', 'Pizzaszósz, sajt, oregánó', '3415.00', 'https://image2url.com/r2/default/images/1771236187481-100b387e-d95a-4b94-a128-9a57f0ff62ce.png', 1, 'étel'),
(308, 9, 'Szalámis Pizza (32cm)', 'Pizzaszósz, sajt, szalámi, oregánó', '3915.00', 'https://image2url.com/r2/default/images/1771236238042-af0da7df-96d2-4c62-87c0-c507d7f38d0c.png', 1, 'étel'),
(309, 9, 'Vega Pizza (32cm)', 'Pizzaszósz, sajt, paradicsom, paprika, hagyma, padlizsán, oregánó', '3350.00', 'https://image2url.com/r2/default/images/1771236272611-426d40bf-06c2-4bba-ac61-ec0c1b244a93.png', 1, 'étel'),
(310, 9, 'Csirke Burger', 'Csirkehúspogácsa, friss saláta, hamburgerszósz', '2690.00', 'https://image2url.com/r2/default/images/1771236302110-aaf5a2d5-e105-4724-84ab-d506a8789148.png', 1, 'étel'),
(311, 9, 'Hamburger', 'Marhahúspogácsa, friss saláta, hamburgerszósz', '2990.00', 'https://image2url.com/r2/default/images/1771236346283-866af666-06bf-48f9-8ebc-0ca46f359303.png', 1, 'étel'),
(312, 9, 'Sajtos Burger', 'Marhahúspogácsa, sajt, friss saláta, hamburgerszósz', '3090.00', 'https://image2url.com/r2/default/images/1771236381792-08c3448e-6aee-4189-9b56-f22bb02e7fa2.png', 1, 'étel'),
(313, 9, 'Crispy Burger', 'Cornflakes bundában sült enyhén csípős csirke, lilahagyma, paradicsom, hamburgerszósz, jégsaláta, briós zsemle', '3990.00', 'https://image2url.com/r2/default/images/1771236409519-8331de0d-fbc8-4f8f-8443-a02cfb6e6a83.png', 1, 'étel'),
(314, 9, 'Chicken Nuggets 6db', '6 db csirkefalatka', '1790.00', 'https://image2url.com/r2/default/images/1771236451005-65452af2-6c0d-46eb-bbf1-f91231cc18a3.png', 1, 'étel'),
(315, 9, 'Panírozott Csirkemell Tál', '2 db rántott csirkemellszelet, friss saláta, csípős és joghurtos szósz (válassz köretet)', '3990.00', 'https://image2url.com/r2/default/images/1771236487802-e3e46a9f-8c6e-4ae4-86a9-6106f1678727.png', 1, 'étel'),
(316, 9, 'Rántott Camembert Sajt', '6 db camembert sajt, friss saláta (válassz köretet)', '3490.00', 'https://image2url.com/r2/default/images/1771236618517-594d5fc9-2aaf-41e2-9979-3f45bcd9f128.png', 1, 'étel'),
(317, 9, 'Csokoládés Baklava', 'Desszert, ami mindig jó választás', '1290.00', 'https://image2url.com/r2/default/images/1771236679372-87d7dcfc-c5b0-4cf5-9bb5-4666cbe499da.png', 1, 'desszert'),
(318, 9, 'Diós Baklava', 'Réteges tészta, ízletes szirup', '1290.00', 'https://image2url.com/r2/default/images/1771236710580-b42bac63-aa07-4799-a86d-45a5c3f81475.png', 1, 'desszert'),
(319, 9, 'Pisztáciás Baklava', 'Egy kis boldogság minden falatban', '1390.00', 'https://image2url.com/r2/default/images/1771236753284-92782e56-56af-4ea4-9208-284947c87e19.png', 1, 'desszert'),
(320, 9, 'Ayran Sós Joghurtital (0,25l)', 'Hűsítő, sós joghurtital, tökéletes fűszeres ételekhez', '490.00', 'https://image2url.com/r2/default/images/1771236795016-5f5f1eaa-feaa-40d5-b5a0-78c76ef8c85f.png', 1, 'ital'),
(321, 9, 'Fanta Narancs 0,5l', 'Nagyszerű narancsíz, visszaváltási díj 50 Ft', '750.00', 'https://image2url.com/r2/default/images/1771236835498-b5a2cded-8fbc-4546-8983-b3167f49545b.png', 1, 'ital'),
(322, 9, 'Coca-Cola Zero 0,5l', 'Zero cukor, eredeti Coke íz, visszaváltási díj 50 Ft', '750.00', 'https://image2url.com/r2/default/images/1771236864834-b054f4fa-a7a4-4c4c-97c2-e21b359b15a6.png', 1, 'ital'),
(323, 9, 'Sprite Citrom-Lime 0,5l', 'Frissítő íz, 100%-ban természetes aromákkal, visszaváltási díj 50 Ft', '750.00', 'https://image2url.com/r2/default/images/1771236897114-93289ad9-34e0-4956-8c74-6368ee5abf1e.png', 1, 'ital'),
(324, 9, 'Duna Chéf Saláta', 'Kápia paprika, tv paprika, kígyóuborka, paradicsom, friss pita (válassz húst és szószt)', '2890.00', 'https://image2url.com/r2/default/images/1771236925175-dec3fdfc-894e-4f7e-83a5-07d8d9a91942.png', 1, 'étel'),
(325, 9, 'Falafel Tál', '5 db csicseriborsó-fasírt, friss saláta, csípős és joghurtos szósz (válassz köretet)', '2990.00', 'https://image2url.com/r2/default/images/1771236998624-75f0bba5-96a0-45ba-a27f-d3f24f737b3b.png', 1, 'étel'),
(326, 9, 'Sült-Zöldséges Vega Dürüm', 'Tortilla, friss saláta, sült paprika, sült padlizsán, feta sajt (válassz szószt)', '2790.00', 'https://image2url.com/r2/default/images/1771237028535-8dde8b85-b68d-4b4b-804e-6447844e60a5.png', 1, 'étel'),
(327, 9, 'Palacsinta (1db)', 'Választható ízesítéssel, friss palacsinta', '800.00', 'https://image2url.com/r2/default/images/1771237055800-60f1c566-0d6f-4cc5-acbe-326fd7eae0bc.png', 1, 'desszert');
INSERT INTO `dishes` (`dish_id`, `restaurant_id`, `name`, `description`, `price`, `image_url`, `available`, `type`) VALUES
(328, 9, 'NaturAqua Szénsavmentes Ásványvíz 0,5l', 'Frissítő, szénsavmentes természetes ásványvíz, visszaváltási díj 50 Ft', '500.00', 'https://image2url.com/r2/default/images/1771237080917-96ff4f20-fce3-4e28-9d62-fd8bc29c6759.png', 1, 'ital'),
(329, 2, 'Csirkés Wrap', 'Grillezett csirkehús friss salátával, paradicsommal, mozzarellával, uborkával és BBQ szósszal, tortilla lapba tekerve.', '3055.00', 'https://image2url.com/r2/default/images/1771588615838-54fa94c7-305f-4aaa-b1ca-282f0976f061.png', 1, 'étel'),
(330, 2, 'Guacamole Wrap', 'Friss saláta, mozzarella, házi guacamole krém és főtt tojás tortilla lapba tekerve.', '3210.00', 'https://image2url.com/r2/default/images/1771588645164-63e840e3-5e28-43d8-a2a6-f20efcb12e65.png', 1, 'étel'),
(331, 2, 'Lazac Bagel', 'Philadelphiai krémsajt, füstölt lazac, paradicsom, mozzarella és friss saláta bagelben. Gluténmentes változat kérhető.', '2820.00', 'https://image2url.com/r2/default/images/1771588681078-8b3a1b5b-182b-42a0-be18-0310de69225a.png\r\n', 1, 'étel'),
(332, 2, 'Caprese Wrap', 'Friss saláta, mozzarella, paradicsom és pesztó szósszal töltött tortilla wrap.', '2820.00', 'https://image2url.com/r2/default/images/1771588712065-65f0b08b-1174-40e6-b08e-c81b88d4b6c7.png', 1, 'étel'),
(333, 2, 'Vegán Málnás Croissant', 'Vegán croissant málna töltelékkel, ropogós külsővel és puha belsővel.', '1105.00', 'https://image2url.com/r2/default/images/1771588744397-10a420a8-51b7-49db-8c95-d35d722f632c.png', 1, 'étel'),
(334, 2, 'Vegán Narancsos Croissant', 'Vegán croissant narancsos töltelékkel, könnyed és friss ízvilággal.', '1105.00', 'https://image2url.com/r2/default/images/1771588783897-77849c7b-a918-4e5a-b799-7c7b3857c35a.png', 1, 'étel'),
(335, 2, 'Pisztáciás Croissant', 'Vajas croissant gazdag pisztáciás töltelékkel.', '1105.00', 'https://image2url.com/r2/default/images/1771588805928-9a7db4eb-b3ab-412e-9343-e2058a457722.png', 1, 'étel'),
(336, 2, 'Bagel Humusz', 'Friss bagel humuszkrémmel, salátával és paradicsommal. Gluténmentes opció kérhető.', '2275.00', 'https://image2url.com/r2/default/images/1771589038682-36175d09-99d6-41dd-99dd-a75adc99651b.png', 1, 'étel'),
(337, 2, 'Mozzarellás Bagel', 'Philadelphiai krémsajt, paradicsom, mozzarella és friss saláta bagelben.', '2535.00', 'https://image2url.com/r2/default/images/1771589143123-a3e8e852-4f86-4b21-82e0-40cfb57dbec7.png', 1, 'étel'),
(338, 2, 'Vaníliás jeges kávé', 'Espresso egy gombóc vanília fagylalttal, tejjel, tejszínhabbal és jéggel.', '1950.00', 'https://image2url.com/r2/default/images/1771589178407-82352449-37ef-4ddd-a633-6dcc50f95e96.png', 1, 'ital'),
(339, 2, 'Orange espresso', 'Frissen facsart narancslé espressoval és jéggel különleges frissítőként.', '1690.00', 'https://image2url.com/r2/default/images/1771589216152-7a41969d-226f-4179-8d6e-970117948779.png', 1, 'ital'),
(340, 2, 'E.T.', 'Espresso Fever Tree tonikkal és jéggel, frissítő kávékülönlegesség.', '1950.00', 'https://image2url.com/r2/default/images/1771590096857-f09d22bf-3266-42ca-bb9b-44c65825c0d2.png', 1, 'ital'),
(341, 2, 'Vegan Hot Chocolate', 'Mandulatejjel készült forró csokoládé holland kakaóporral és kókusztejszínnel.', '1400.00', 'https://image2url.com/r2/default/images/1771590144475-869a0469-dc8e-4c93-93f2-d5a935512be0.png', 1, 'ital'),
(342, 2, 'Matcha Latte', 'Krémes matcha latte prémium zöld tea porból és tejjel készítve.', '1850.00', 'https://image2url.com/r2/default/images/1771590310575-985a5ab6-2acb-4348-abf5-79bf1faae2a2.png', 1, 'ital'),
(343, 2, 'Mangó Matcha Latte', 'Matcha latte mangó ízesítéssel, friss és egzotikus ízvilággal.', '1950.00', 'https://image2url.com/r2/default/images/1771590349366-8410e781-91b4-466a-9263-f9eb580e132d.png', 1, 'ital'),
(344, 2, 'V60 2dl', 'Világos pörkölésű, filteres V60 kávé a CrackerJack pörkölőtől.', '1050.00', 'https://image2url.com/r2/default/images/1771590383681-f56f6cbb-6f91-4a19-b3c0-ea0fdfc09a7c.png', 1, 'ital'),
(345, 2, 'V60 3dl', 'Világos pörkölésű, filteres V60 kávé a CrackerJack pörkölőtől nagyobb adagban.', '1570.00', 'https://image2url.com/r2/default/images/1771590383681-f56f6cbb-6f91-4a19-b3c0-ea0fdfc09a7c.png', 1, 'ital'),
(346, 2, 'V60 4dl', 'Világos pörkölésű, filteres V60 kávé a CrackerJack pörkölőtől extra adagban.', '2095.00', 'https://image2url.com/r2/default/images/1771590383681-f56f6cbb-6f91-4a19-b3c0-ea0fdfc09a7c.png', 1, 'ital'),
(347, 2, 'Green Mango', 'Mangó, spenót, gyömbér, citrom és kókuszital frissítő smoothie formájában.', '2170.00', 'https://image2url.com/r2/default/images/1771590416615-9a693f18-1212-4391-9604-dcc0338446e0.png', 1, 'ital'),
(348, 2, 'Spring Love', 'Eper, banán, alma és mandulaital krémes smoothie formában.', '2170.00', 'https://image2url.com/r2/default/images/1771590432668-b17a2f35-4fff-45bc-929a-d5ef6505ce51.png', 1, 'ital'),
(349, 2, 'Berry Banana', 'Eper, erdei gyümölcs, banán és mandulaital harmonikus smoothie.', '2170.00', 'https://image2url.com/r2/default/images/1771590453941-9e18c915-0ae5-4790-a990-36b8adeb0e36.png', 1, 'ital'),
(350, 2, 'Summer Love', 'Mangó, banán, ananász, menta és kókusztej vegán smoothie.', '2170.00', 'https://image2url.com/r2/default/images/1771590474372-aaf5aa90-d52b-4a60-a40b-4c6875c0dc98.png', 1, 'ital'),
(351, 2, 'Fresh Orange Juice', '100%-os frissen facsart narancslé, adalékanyag nélkül.', '1550.00', 'https://image2url.com/r2/default/images/1771590494122-d458af94-c6da-4974-bff2-f5685c9311fe.png', 1, 'ital'),
(352, 2, 'Magnó-Lime kocka', 'Friss lime-os sütemény krémes állaggal és üde citrusos ízvilággal.', '1625.00', 'https://image2url.com/r2/default/images/1771590525430-79e5b4dd-11d5-4844-8c64-e668ce15e896.png', 1, 'desszert'),
(353, 2, 'Málna-Passió gyümölcs kocka', 'Málnás és passiógyümölcsös sütemény friss, gyümölcsös ízekkel.', '1625.00', 'https://image2url.com/r2/default/images/1771590554290-d2f1d9e3-7bbe-49f5-b152-9e4679d8d2ac.png', 1, 'desszert'),
(354, 2, 'Gluténmentes karamellás mandula torta', 'Gluténmentes torta karamellás és mandulás ízvilággal.', '1550.00', 'https://image2url.com/r2/default/images/1771590577655-fca07060-5c85-4e1d-83ae-e5b355f621e8.png', 1, 'desszert');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `delivery_address` text,
  `status` enum('pending','preparing','delivering','completed','cancelled') DEFAULT 'pending',
  `total_price` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `restaurant_id`, `delivery_address`, `status`, `total_price`, `created_at`) VALUES
(1, 18, 2, 'Nincs megadva', 'completed', '22550.00', '2026-02-09 12:36:46'),
(2, 18, 1, '7681 Pécs Király utca 3.', 'completed', '9900.00', '2026-02-09 12:44:49'),
(3, 19, 9, 'Nincs megadva', 'completed', '7670.00', '2026-02-09 13:12:14'),
(4, 20, 2, 'Pécs, Király utca 5', 'preparing', '7150.00', '2026-02-11 10:07:39'),
(5, 21, 1, 'Pécs, Szabolcsi út 4', 'preparing', '8000.00', '2026-02-11 10:26:05'),
(7, 23, 6, 'Pécs, király utca 4', 'preparing', '5490.00', '2026-02-11 20:12:40'),
(8, 17, 2, 'Pécs, király utca 4', 'cancelled', '3300.00', '2026-02-18 09:43:32'),
(9, 17, 2, 'Pécs, király utca 4', 'preparing', '3300.00', '2026-02-18 11:49:58'),
(10, 17, 3, 'Pécs, király utca 4', 'completed', '15885.00', '2026-02-18 11:50:17'),
(11, 17, 4, 'Pécs, király utca 4', 'preparing', '2490.00', '2026-02-18 11:50:34'),
(12, 17, 5, 'Pécs, király utca 4', 'completed', '300.00', '2026-02-18 11:52:00'),
(13, 17, 1, 'Pécs, király utca 4', 'completed', '3850.00', '2026-02-18 11:52:14'),
(14, 17, 4, 'Pécs, király utca 4', 'completed', '2490.00', '2026-02-18 11:52:35'),
(15, 17, 2, 'Pécs, király utca 4', 'completed', '3300.00', '2026-02-18 16:15:40'),
(16, 24, 3, 'Pécs, Citrom utca 4', 'completed', '7250.00', '2026-02-18 16:25:34'),
(17, 24, 2, 'Pécs, Citrom utca 4', 'completed', '6500.00', '2026-02-18 16:45:47'),
(18, 24, 3, 'Pécs, Citrom utca 7', 'preparing', '6490.00', '2026-02-18 16:47:35'),
(21, 17, 2, 'Pécs, Citrom utca 4', 'preparing', '3300.00', '2026-02-19 08:01:00'),
(22, 17, 2, 'Pécs, Citrom utca 7', 'completed', '7150.00', '2026-02-19 08:28:27'),
(23, 27, 2, 'Pécs, Citrom utca 4', 'completed', '273750.00', '2026-02-19 12:22:34'),
(24, 28, 2, 'Pécs, Citrom utca 7', 'preparing', '2820.00', '2026-02-20 13:04:11'),
(25, 17, 2, 'Pécs, Citrom utca 4', 'completed', '3055.00', '2026-02-24 09:17:51'),
(26, 17, 5, 'Pécs, Citrom utca 4', 'preparing', '3990.00', '2026-02-24 15:36:59'),
(27, 37, 2, 'Pécs, Citrom utca 4', 'completed', '2095.00', '2026-02-25 10:26:42'),
(28, 38, 2, 'Pécs, Citrom utca 7', 'completed', '6110.00', '2026-03-02 08:29:38'),
(29, 39, 1, 'Pécs, Citrom utca 7', 'completed', '3450.00', '2026-03-02 09:59:55'),
(30, 40, 1, 'Pécs, Citrom utca 4', 'completed', '18750.00', '2026-03-03 08:30:47'),
(31, 41, 1, 'Pécs, Citrom utca 4', 'completed', '7700.00', '2026-03-03 08:42:55'),
(33, 17, 2, 'Pécs, Citrom utca 9', 'preparing', '3055.00', '2026-03-13 09:27:06'),
(34, 43, 1, 'Pécs, Siklósi út 5', 'completed', '7900.00', '2026-03-27 10:02:55'),
(35, 17, 2, 'Pécs, király utca 4', 'preparing', '6265.00', '2026-03-30 08:01:06'),
(36, 17, 2, 'Pécs, király utca 4', 'preparing', '3055.00', '2026-04-22 08:36:45');

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

--
-- A tábla adatainak kiíratása `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `dish_id`, `quantity`, `price`) VALUES
(3, 2, 46, 3, '9900.00'),
(4, 3, 299, 2, '4980.00'),
(5, 3, 301, 1, '2690.00'),
(8, 5, 46, 2, '6600.00'),
(9, 5, 90, 1, '1400.00'),
(13, 7, 237, 1, '3600.00'),
(14, 7, 264, 1, '200.00'),
(15, 7, 252, 1, '1690.00'),
(18, 10, 149, 1, '15885.00'),
(19, 11, 176, 1, '2490.00'),
(20, 12, 234, 1, '300.00'),
(21, 13, 47, 1, '3850.00'),
(22, 14, 179, 1, '2490.00'),
(24, 16, 147, 1, '6350.00'),
(25, 16, 167, 1, '900.00'),
(28, 18, 146, 1, '6490.00'),
(52, 24, 332, 1, '2820.00'),
(53, 25, 329, 1, '3055.00'),
(54, 26, 207, 1, '1190.00'),
(55, 26, 206, 1, '2800.00'),
(56, 27, 346, 1, '2095.00'),
(57, 28, 329, 2, '6110.00'),
(58, 29, 49, 1, '3450.00'),
(59, 30, 46, 5, '18750.00'),
(60, 31, 47, 2, '7700.00'),
(63, 33, 329, 1, '3055.00'),
(64, 34, 88, 1, '1400.00'),
(65, 34, 61, 1, '3750.00'),
(66, 34, 56, 1, '2750.00'),
(67, 35, 329, 1, '3055.00'),
(68, 35, 330, 1, '3210.00'),
(69, 36, 329, 1, '3055.00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `token_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `used` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`token_id`, `user_id`, `token`, `expires_at`, `created_at`, `used`) VALUES
(6, 17, '37847024-25b6-4306-aa96-bd932672776e', '2026-03-24 11:27:03', '2026-03-24 10:27:02', 1),
(7, 37, '7a379aec-c4e3-4ebc-b53a-933cde9cdfd4', '2026-03-24 11:28:30', '2026-03-24 10:28:29', 0);

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

--
-- A tábla adatainak kiíratása `payments`
--

INSERT INTO `payments` (`payment_id`, `order_id`, `amount`, `method`, `status`, `created_at`) VALUES
(1, 1, '22550.00', 'card', 'paid', '2026-02-09 12:36:46'),
(2, 2, '9900.00', 'cash', 'pending', '2026-02-09 12:44:49'),
(3, 3, '7670.00', 'paypal', 'paid', '2026-02-09 13:12:15'),
(4, 4, '7150.00', 'paypal', 'paid', '2026-02-11 10:07:41'),
(5, 5, '8000.00', 'card', 'paid', '2026-02-11 10:26:07'),
(7, 7, '5490.00', 'card', 'paid', '2026-02-11 20:12:43'),
(8, 8, '3300.00', 'card', 'paid', '2026-02-18 09:43:32'),
(9, 9, '3300.00', 'cash', 'pending', '2026-02-18 11:49:59'),
(10, 10, '15885.00', 'paypal', 'paid', '2026-02-18 11:50:17'),
(11, 11, '2490.00', 'paypal', 'paid', '2026-02-18 11:50:34'),
(12, 12, '300.00', 'cash', 'pending', '2026-02-18 11:52:00'),
(13, 13, '3850.00', 'cash', 'pending', '2026-02-18 11:52:14'),
(14, 14, '2490.00', 'cash', 'pending', '2026-02-18 11:52:36'),
(15, 15, '3300.00', 'cash', 'pending', '2026-02-18 16:15:41'),
(16, 16, '7250.00', 'card', 'paid', '2026-02-18 16:25:35'),
(17, 17, '6500.00', 'paypal', 'paid', '2026-02-18 16:45:47'),
(18, 18, '6490.00', 'paypal', 'paid', '2026-02-18 16:47:35'),
(21, 21, '3300.00', 'paypal', 'paid', '2026-02-19 08:01:01'),
(22, 22, '7150.00', 'paypal', 'paid', '2026-02-19 08:28:30'),
(23, 23, '273750.00', 'cash', 'pending', '2026-02-19 12:22:39'),
(24, 24, '2820.00', 'cash', 'pending', '2026-02-20 13:04:17'),
(25, 25, '3055.00', 'card', 'paid', '2026-02-24 09:17:55'),
(26, 26, '3990.00', 'paypal', 'paid', '2026-02-24 15:37:03'),
(27, 27, '2095.00', 'cash', 'pending', '2026-02-25 10:26:45'),
(28, 28, '6110.00', 'card', 'paid', '2026-03-02 08:29:42'),
(29, 29, '3450.00', 'card', 'paid', '2026-03-02 09:59:58'),
(30, 30, '18750.00', 'card', 'paid', '2026-03-03 08:30:49'),
(31, 31, '7700.00', 'card', 'paid', '2026-03-03 08:42:58'),
(33, 33, '3055.00', 'card', 'paid', '2026-03-13 09:27:08'),
(34, 34, '7900.00', 'cash', 'pending', '2026-03-27 10:02:58'),
(35, 35, '6265.00', 'paypal', 'paid', '2026-03-30 08:01:10'),
(36, 36, '3055.00', 'paypal', 'paid', '2026-04-22 08:36:50');

--
-- Eseményindítók `payments`
--
DELIMITER $$
CREATE TRIGGER `check_payment_amount` BEFORE INSERT ON `payments` FOR EACH ROW BEGIN
    DECLARE order_total DECIMAL(10,2);

  
    SELECT total_price INTO order_total
    FROM orders
    WHERE order_id = NEW.order_id;

    IF NEW.amount <> order_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A fizetés összege nem egyezik a rendelés összegével!';
    END IF;
END
$$
DELIMITER ;

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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `restaurants`
--

INSERT INTO `restaurants` (`restaurant_id`, `owner_id`, `name`, `description`, `address`, `phone`, `open_hours`, `created_at`, `image_path`) VALUES
(1, 28, 'Reggeli Étterem', 'Brunch és reggeli ételekre specializálódott, hangulatos belvárosi kávézó.', '7621 Pécs, Király utca 23-25.', '+36 72 529 910', '08:00 - 13:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024155214-06028561-337c-43e6-8711-5405ebcfa856.png'),
(2, 29, 'Szünet Kávézó', 'Barátságos kávézó reggelivel, ebéddel és minőségi kávékkal.', '7624 Pécs, Ferencesek utcája 8.', '+36 30 911 4292', '08:00 - 18:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024177986-694b0c47-5b3a-474c-831b-8713fbeed57f.png'),
(3, 30, 'Csülök Bár', 'Hagyományos magyar konyha, csülök specialitásokkal és bőséges adagokkal.', '7634 Pécs, Pellérdi út 31.', '+36 70 578 0848', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024019791-057d43bc-1385-4d8f-a2d8-561f05d776b9.png'),
(4, 31, 'Juice&Co. Pécs Smoothie Bar', 'Friss smoothie-k, gyümölcslevek és könnyű reggelik egészséges vonalon.', '7621 Pécs, Jókai utca 1.', '+36 30 824 3015', '09:00 - 16:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024105360-3737dba1-3096-488b-9743-ba4bd8d0efaa.png'),
(5, 32, 'Elemózsia Bisztró', 'Kedvező árú bisztró házias ízekkel, főleg reggeli és ebédidőben.', '7624 Pécs, Édesanyák útja 1.', '+36 30 627 4169', '08:00 - 15:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024065545-f6c5e70c-a40f-43ea-9626-344e2a3f27d1.png'),
(6, 33, 'Mátyás Király Vendéglő', 'Magyaros vendéglő klasszikus házias ételekkel, ebédközpontú nyitvatartással.', '7621 Pécs, Ferencesek utcája 9.', '+36 70 604 1797', '11:00 - 16:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024295551-c0c03c06-b4d4-42f0-b3e2-07bb6f3a31f7.png'),
(7, 34, 'Teca Mama Kisvendéglő', 'Házias magyar konyha, vidéki hangulat és kiadós fogások.', '7634 Pécs, Éger köz 10.', '+36 72 332 430', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024214009-9851c5f4-e79c-4088-9619-236184eb1633.png'),
(8, 35, 'Pizza Hut Pécs', 'Nemzetközi pizza lánc klasszikus és prémium pizzákkal.', '7621 Pécs, Irgalmasok utcája 6.', '+36 30 990 5050', '10:00 - 00:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024132786-254a7d26-4b64-48ba-b1fb-c244e0a3b56c.png'),
(9, 36, 'Best Food Grill Pécs', 'Gyorsétterem grill ételekkel, kebabbal és pizzával a belvárosban.', '7621 Pécs, Széchenyi tér 8.', '+36 72 268 922', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770023942394-b802f1f9-b84a-497a-84e3-01ca3f9df135.png');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `restaurant_id` int(11) DEFAULT NULL,
  `dish_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `rating` tinyint(4) NOT NULL,
  `comment` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `reviews`
--

INSERT INTO `reviews` (`review_id`, `user_id`, `restaurant_id`, `dish_id`, `order_id`, `rating`, `comment`, `created_at`) VALUES
(1, 17, 2, NULL, 15, 5, 'Nagyon finom volt de fogalmam sincs már mit vettem.', '2026-02-18 16:43:48'),
(3, 24, 2, NULL, 17, 4, 'szuper', '2026-02-18 17:05:03'),
(7, 17, 2, NULL, 22, 5, 'szupi', '2026-02-19 08:33:15'),
(8, 27, 2, NULL, 23, 1, 'Ehetetlen volt, kibasztam a kukába', '2026-02-19 12:26:30'),
(9, 17, 3, NULL, 10, 5, 'oké', '2026-02-23 12:11:02'),
(10, 17, 4, NULL, 14, 5, 'Nagyon finom volt az étel, gyors kiszállítás!', '2026-02-23 12:33:46'),
(12, 17, 2, NULL, 25, 4, 'jó', '2026-02-24 09:19:20'),
(13, 17, 1, NULL, 13, 4, 'szuperjó', '2026-02-24 15:37:26'),
(14, 37, 2, NULL, 27, 5, 'fincsi', '2026-02-26 09:09:54'),
(15, 17, 5, NULL, 12, 4, 'good', '2026-03-02 08:30:32'),
(16, 38, 2, NULL, 28, 1, 'bad', '2026-03-02 08:32:45'),
(17, 39, 1, NULL, 29, 5, 'great', '2026-03-02 10:02:05'),
(18, 41, 1, NULL, 31, 1, 'really bad taste', '2026-03-03 08:45:34');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `review_items`
--

CREATE TABLE `review_items` (
  `review_item_id` int(11) NOT NULL,
  `review_id` int(11) NOT NULL,
  `dish_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `review_items`
--

INSERT INTO `review_items` (`review_item_id`, `review_id`, `dish_id`) VALUES
(21, 9, 149),
(22, 10, 179),
(24, 12, 329),
(25, 13, 47),
(26, 14, 346),
(27, 15, 234),
(28, 16, 329),
(29, 17, 49),
(30, 18, 47);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `role` enum('customer','admin','restaurant_owner') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `banned` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`user_id`, `name`, `username`, `email`, `password`, `phone`, `role`, `created_at`, `banned`) VALUES
(1, 'KLSZ', 'klsz', 'klsz@gmail.com', 'klsz12345', '+36201234567', 'restaurant_owner', '2025-10-03 09:37:09', 0),
(2, 'Teszt Vásárló', 'tesztvásárló9', 'vasarlo@example.com', 'ds14%w5', '+36201112222', 'admin', '2025-10-03 09:37:09', 0),
(4, 'exampleadmind', 'exampleadmind', 'exampleadmind@gmail.com', '12sd5@z2', '+360301245235', 'admin', '2025-12-05 10:02:44', 0),
(5, 'exaplerestaurant_owner', 'exaplerestaurant_owner', 'exaplerestaurant_owner@gmail.com', 'tM6%qaR5', '+363042523434', 'restaurant_owner', '2025-12-05 10:03:25', 0),
(7, 'teszt2', 'teszt2', 'teszt2@gmail.com', 'K3m!4tRa', '+3630324246', 'customer', '2025-12-05 10:16:55', 0),
(8, 'teszt3', 'teszt3', 'teszt3@gmail.com', 'pS9#wB2n', '+36301244', 'customer', '2025-12-05 10:18:08', 0),
(9, 'teszt4', 'teszt4', 'teszt4@gmail.com', 'vT9@qR1m', '+2388247849825', 'customer', '2025-12-05 10:19:07', 0),
(10, 'teszt5', 'teszt5', 'teszt5@gmail.com', 'ek39!f2i', '+363012335', 'customer', '2025-12-05 10:19:34', 0),
(11, 'teszt6', 'teszt6', 'teszt6@gmail.com', 'tk569%h', '+363057456', 'customer', '2025-12-05 10:20:58', 0),
(13, 'teszt8', 'teszt8', 'teszt8@gmail.com', '3kt6s2&g', '+363043422', 'customer', '2025-12-05 10:22:41', 0),
(14, 'teszt9', 'teszt9', 'teszt9@gmail.com', 'ycg42@gj', '+363012345', 'customer', '2025-12-05 10:23:19', 0),
(17, 'Pásztor Kevin Ispán', 'pkevin22', 'kevinpasztor10@gmail.com', '$2a$10$srYW6Pro1CnyxsJmXTCpbeU8rRS2jI2I3GKd7u4fzULW57CneWxV.', '06205038648', 'admin', '2026-02-09 10:21:41', 0),
(18, 'Kocsis Szabolcs', 'Yolo', 'kocsis.szabolcs.erno@szechenyi.hu', '$2a$10$Nt2YIrBRwQrOPaFXMxoRnurN1/CWSK9.cuo0EgN2lhNYvJeG31v42', '+36 30 8145152', 'customer', '2026-02-09 12:15:02', 0),
(19, 'John Doe', 'jdoe', 'johndoe@gmail.com', '$2a$10$96oB3ipZVVEJ8R5cXV1ZhuY5Q34u4irBkBO50e20ibTs6.MF8k3t2', '0616704201', 'customer', '2026-02-09 13:10:40', 0),
(20, 'Kocsis Legolas', 'legolas34', 'lajossziauram509@gmail.com', '$2a$10$wPlR/y2t.BmplbY6XZuTyeIH4lvXCPd3CjNyPiqTRSvqIxSmHog5i', '06204325438', 'admin', '2026-02-11 10:06:30', 0),
(21, 'Kis Borbás Dorián Zsolt', 'kbdorian', '092@drxy.hu', '$2a$10$BVdGEzYjHQg01Zf0u3.kVOL2JXtbPbOKZPHb19YBhgQdkf4e.TtDu', '', 'customer', '2026-02-11 10:24:19', 0),
(23, 'Orsós Friderika', 'ofrid', 'reklamok.reklamok@gmail.com', '$2a$10$pDlZjXBpinGsyC0tjnLmTucUR0SYUvA3N5zV0V8vIWR4HXw7OJXuK', '06207125346', 'customer', '2026-02-11 20:09:43', 0),
(24, 'Customer Teszt', 'cteszt', 'customet@gmail.com', 'Customer1_', '16201234321', 'customer', '2026-02-18 09:55:42', 0),
(27, 'Orsós Ádám', 'skibidihunter', 'erik23toth@gmail.com', '$2a$10$XJvhnyW2VVo.G5G1iQISJeN7T80yUSVK/vDy0drHOBOmEA5njvxRq', '36305401243', 'admin', '2026-02-19 12:21:01', 0),
(28, 'Reggeli Étterem Tulajdonos', 'reggeli_owner', 'reggeli.etterem@klszfaloda.hu', '$2a$10$KPpeb6VFM.iTXwlcggg8NuwKfzXGMsDVzbdtlK2mTXHAO/prr3PPa', '+36301001001', 'restaurant_owner', '2026-02-20 11:19:31', 0),
(29, 'Szünet Kávézó Tulajdonos', 'szunet_owner', 'szunet.kavezo@klszfaloda.hu', '$2a$10$Lb5F2Z6h6MM1Cr40q0LNNu43E3nJk59V/clEV.FzTBZAIpUq6hT8m', '+36301002002', 'restaurant_owner', '2026-02-20 11:19:57', 0),
(30, 'Csülök Bár Tulajdonos', 'csulok_owner', 'csulok.bar@klszfaloda.hu', '$2a$10$GiiEJmgdtuJsA.YDdZC4q.dZCIXg1Y7AnD5TYzZmDHfI4ecGxhwii', '+36301003003', 'restaurant_owner', '2026-02-20 11:20:05', 0),
(31, 'Juice&Co Tulajdonos', 'juiceco_owner', 'juiceco.smoothie@klszfaloda.hu', '$2a$10$HrDq/sGvEKZghupXMCMQYePZxeFSK.tw6bYVFYWSvgjgfLlzZ7wtG', '+36301004004', 'restaurant_owner', '2026-02-20 11:20:13', 0),
(32, 'Elemózsia Bisztró Tulajdonos', 'elemozsia_owner', 'elemozsia.bisztro@klszfaloda.hu', '$2a$10$uFnItlVwN5dIEuBoALxqEeMhGT0HdXdIZtOOOWwGn19A49fFdtzUS', '+36301005005', 'restaurant_owner', '2026-02-20 11:20:20', 0),
(33, 'Mátyás Király Vendéglő Tulajdonos', 'matyas_owner', 'matyas.vendeglo@klszfaloda.hu', '$2a$10$CexiwhKckZyoUPc5OX/nwuBEnKS/ANIR9IcCqV1EHS5v2.QXFhWWK', '+36301006006', 'restaurant_owner', '2026-02-20 11:20:41', 0),
(34, 'Teca Mama Tulajdonos', 'tecamama_owner', 'tecamama.kisvendeglo@klszfaloda.hu', '$2a$10$0SsvRcCQHHdHZQkH5SfEk.XkMfoNQ8wc9lhqcgzUNon7rq8GawuKy', '+36301007007', 'restaurant_owner', '2026-02-20 11:20:50', 0),
(35, 'Pizza Hut Tulajdonos', 'pizzahut_owner', 'pizzahut.pecs@klszfaloda.hu', '$2a$10$WwcjtoEMs5.b.4Fqo6DHXe.H4Bg8owJtTlu6FK81rXTEM1uHo.E1u', '+36301008008', 'restaurant_owner', '2026-02-20 11:20:58', 0),
(36, 'Best Food Grill Tulajdonos', 'bestfood_owner', 'bestfood.grill@klszfaloda.hu', '$2a$10$SxCvSBdCLi1UIWMMvuuaL.g5eDugb4Qn73cVT4pwiXBhS20BjCDGq', '+36301009009', 'restaurant_owner', '2026-02-20 11:21:07', 0),
(37, 'Nagy István Márk', 'nagyistimrk', 'vizsgacim12@gmail.com', '$2a$10$Wj6yBAZ/idw06MmWciwTquszVMf/JFH.UBM2LZF19ZD40bccAdA2q', '06203423569', 'customer', '2026-02-25 10:25:28', 0),
(38, 'Little Guy', 'lilguy', 'lilguy2@gmail.com', '$2a$10$QXE/az6DZ6v6PAB6fuXMPu4Uz.zb/rYTSPTmpeoWQYbe19LrTcN8W', '06207125346', 'customer', '2026-03-02 08:28:02', 0),
(39, 'Big Peter', 'bigpete', 'bigpete3@gmail.com', '$2a$10$GufdIr2wUi1cCpGqbhT60.ZIr/a47TX7.Z07WipBmJXPJ687Xlr2W', '06702546758', 'admin', '2026-03-02 09:59:02', 0),
(40, 'Big Adam', 'badam', 'badam@gmail.com', '$2a$10$r/imWzQY3WjRhtJZdY1heeopNHbqRA9co0AYbYTLS5v4UETvMi0Ym', '06201234567', 'customer', '2026-03-03 08:28:35', 0),
(41, 'Kocsis Szabolcs Ernő', 'Szabika023', 'szabika123@gmail.com', '$2a$10$cXhrJARUa7N1uBKFAdqSiOO5eRG67.qqpjfys8S77wxI8/8jyT6Z2', '36305401243', 'customer', '2026-03-03 08:41:35', 0),
(42, 'Kevin Pasztor', 'kevin', 'kevinke@gmail.com', '$2a$10$FDRh5qyHwVH/aGhxowewhOBQqtGJ/q92KSomgp168SFNPqsyFUlD.', '999999999999', 'customer', '2026-03-03 08:54:20', 0),
(43, 'Kis Pista', 'kpisti69420', 'kpisti67@gmail.com', '$2a$10$Q6lvwPJY2UPEyLkTXNsMguL5n9baMW4j1vcepmmK9CjYSBL3.316C', '+36205038648', 'customer', '2026-03-27 09:38:10', 0),
(44, 'Kis Ádám', 'kadam2', 'kadam@gmail.com', '$2a$10$WCF14Y2jevjePU7OVdNzsefzMUl2U/mEt2RKbV3fuw.VKGEIg0yMu', '06201239876', 'customer', '2026-04-22 08:40:48', 0);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`delivery_id`),
  ADD KEY `order_id` (`order_id`);

--
-- A tábla indexei `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`dish_id`),
  ADD KEY `fk_dishes_restaurants` (`restaurant_id`);

--
-- A tábla indexei `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_order_restaurant` (`restaurant_id`),
  ADD KEY `fk_orders_users` (`user_id`);

--
-- A tábla indexei `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `fk_dish` (`dish_id`),
  ADD KEY `fk_order_items_orders` (`order_id`);

--
-- A tábla indexei `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`token_id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- A tábla indexei `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_payments_orders` (`order_id`);

--
-- A tábla indexei `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`restaurant_id`),
  ADD KEY `fk_owner` (`owner_id`);

--
-- A tábla indexei `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `fk_review_user` (`user_id`),
  ADD KEY `fk_review_restaurant` (`restaurant_id`),
  ADD KEY `fk_review_dish` (`dish_id`),
  ADD KEY `fk_review_order` (`order_id`);

--
-- A tábla indexei `review_items`
--
ALTER TABLE `review_items`
  ADD PRIMARY KEY (`review_item_id`),
  ADD KEY `review_id` (`review_id`),
  ADD KEY `dish_id` (`dish_id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `delivery`
--
ALTER TABLE `delivery`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `dishes`
--
ALTER TABLE `dishes`
  MODIFY `dish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=355;

--
-- AUTO_INCREMENT a táblához `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT a táblához `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT a táblához `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `token_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT a táblához `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `restaurant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT a táblához `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT a táblához `review_items`
--
ALTER TABLE `review_items`
  MODIFY `review_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `dishes`
--
ALTER TABLE `dishes`
  ADD CONSTRAINT `fk_dishes_restaurants` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_dish` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_payments_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `restaurants`
--
ALTER TABLE `restaurants`
  ADD CONSTRAINT `fk_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_review_dish` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `review_items`
--
ALTER TABLE `review_items`
  ADD CONSTRAINT `review_items_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `review_items_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
