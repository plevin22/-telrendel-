-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Gép: localhost:8889
-- Létrehozás ideje: 2026. Feb 13. 15:14
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
-- Adatbázis: `ételshopuptodata`
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ChangeUserPassword` (IN `p_user_id` INT, IN `p_old_password` VARCHAR(255), IN `p_new_password` VARCHAR(255))   BEGIN
    UPDATE users
    SET password = p_new_password
    WHERE user_id = p_user_id AND password = p_old_password;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ResetUserPassword` (IN `p_user_id` INT, IN `p_new_password` VARCHAR(255))   BEGIN
    UPDATE users
    SET password = p_new_password
    WHERE user_id = p_user_id;
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
(16, 8, 'CHEESEBURGER PIZZA', 'Sajtszósz, mozzarella, marha- és sertéshúsgolyók, hagyma, fűszeres paradicsomszósz, savanyú uborka, ketchup, mustár, szezámmag', '4495.00', 'https://image2url.com/r2/default/images/1770972159976-3ff7a2e5-89bb-4593-8330-b8d26a916f89.png', 1),
(17, 8, 'BBQ NUGGETS', 'Sütőben sült nuggets falatok, mozzarella, BBQ szósz, bacon, zöldpaprika', '4495.00', 'https://image2url.com/r2/default/images/1770024675040-21fc50c9-f2fd-4f56-b106-940dec2ae4ac.png', 1),
(18, 8, 'Margarita', 'Fűszeres paradicsomszósz, Mozzarella sajt', '3795.00', 'https://image2url.com/r2/default/images/1770024703900-b46f61fe-78c7-41e9-ad6f-2de4811d3828.png', 1),
(19, 8, 'Olaszkolbászos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Olaszkolbász', '3995.00', 'https://image2url.com/r2/default/images/1770024739779-25618269-75ff-4f12-b140-8aa68d1e37bc.png', 1),
(20, 8, 'BBQ-Bacon', 'BBQ szósz, Mozzarella sajt, Bacon', '3995.00', 'https://image2url.com/r2/default/images/1770024768408-ac5fc27d-7b6f-4826-8542-d5267db05712.png', 1),
(21, 8, 'Dallas', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Gomba', '3995.00', 'https://image2url.com/r2/default/images/1770024801211-31449f48-118d-4995-be31-07d71ee06fee.png', 1),
(22, 8, 'Hawaii', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Ananász', '3995.00', 'https://image2url.com/r2/default/images/1770024844639-75f619c5-5fba-4ec8-aa1e-ed78a0faba87.png', 1),
(23, 8, 'CARBONARA', 'Fokhagymás szósz, Mozzarella sajt, Sonka, Bacon', '4295.00', 'https://image2url.com/r2/default/images/1770024876108-c26d3b4f-539d-4307-a9d5-7cd50f4c0de1.png', 1),
(24, 8, 'Csirkés-Jalapenos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Fűszeres csirke, Jalapeño paprika', '4295.00', 'https://image2url.com/r2/default/images/1770024902723-bcc2174e-9098-4ddc-955a-7a8b170914a9.png', 1),
(25, 8, 'SokSajtos', 'Fokhagymás szósz, Mozzarella sajt, Cheddar sajt, Mozzarella golyók, Correggio sajt', '4295.00', 'https://image2url.com/r2/default/images/1770024928462-acabe609-1be2-4548-80a0-5d17f092acbc.png', 1),
(26, 8, 'CSOKIS KEKSZ', 'Forró csokis sütemény egyenesen sütőből', '1395.00', 'https://image2url.com/r2/default/images/1770024965320-40ed5656-bd35-4c71-a1c8-17035ab088ec.png', 1),
(27, 8, 'B&J 100 ML Epres Sajttorta', 'Ínycsiklandó epres sajttorta ízű jégkrém eperdarabokkal és gazdag kekszörvényekkel!', '1695.00', 'https://image2url.com/r2/default/images/1770024995931-09f65184-caef-416f-bbf5-bb7eeeda0042.png', 1),
(28, 8, 'B&J 100ML Cookie Dough', 'Vaníliás jégkrém tökéletes találkozása csokis sütemény darabkákkal', '1695.00', 'https://image2url.com/r2/default/images/1770025173526-faafe39a-84ac-4225-b688-16f71130f69f.png', 1),
(29, 8, 'B&J 100ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie sütemény darabkákkal', '1695.00', 'https://image2url.com/r2/default/images/1770025200635-a28e921e-5c14-4ddf-9735-185fd400973c.png', 1),
(30, 8, 'B&J 465ML Brookies&Cream', 'A népszerű Brookies sütemény és vanília jégkrém harmóniája fehér bevonómassza darabokkal', '4995.00', 'https://image2url.com/r2/default/images/1770971735925-83116e76-327c-434c-ba6e-2fb100faf726.png', 1),
(31, 8, 'B&J 465ML Cookie Dough', 'Vaníliás jégkrém csokis sütemény darabkákkal', '4995.00', 'https://image2url.com/r2/default/images/1770971772839-da669329-306a-482e-a58f-c0759569bdb1.png', 1),
(32, 8, 'B&J 465ML Netflix&Chill\'d', 'Földimogyoróvajas jégkrém édes-sós pereccel és brownie darabokkal', '4995.00', 'https://image2url.com/r2/default/images/1770971809217-cc66de36-055f-47a6-9703-446f283f3c29.png', 1),
(33, 8, 'B&J 465ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie darabkákkal', '4995.00', 'https://image2url.com/r2/default/images/1770971990237-87a26063-3017-4133-89ce-341befd762d3.png', 1),
(34, 8, 'MAGNUM PINK LEMONADE 440ML', 'Citromos jégkrém málna szorbéval, fehércsoki bevonattal és pattogó cukorkával', '4445.00', 'https://image2url.com/r2/default/images/1770972017644-ae1c605a-2435-467e-858f-6c32823b832d.png', 1),
(35, 8, 'Magnum 440ML Dupla Mogyorós', 'Csokis-mogyorós és sós karamelles mandula jégkrém', '4445.00', 'https://image2url.com/r2/default/images/1770972071459-8b33680d-8e64-4dbb-a0ad-35473d5f0d3d.png', 1),
(36, 8, 'CHEESEBURGER SÜLT TÉSZTA', 'Friss penne szaftos marha- és sertéshúsgolyókkal, nyúlós mozzarella sajt, savanyú uborka, hagyma, ketchup, mustár és szezámmag', '3695.00', 'https://image2url.com/r2/default/images/1770972374751-e8d30d0f-1b38-4bf2-bf00-0247a1aa066f.png', 1),
(37, 8, 'MAC \'N\' CHEETOS', 'Penne krémes béchamel- és sajtmártással, mozzarella, cheddar és gouda keverékével, ropogós sajtos CHEETOS-szal', '3695.00', 'https://image2url.com/r2/default/images/1770972416246-67d33b23-aae0-4a45-b3a5-e3c84dc83a34.png', 1),
(38, 8, 'MARGHERITA SÜLT TÉSZTA', 'Penne tészta, fűszeres paradicsomszósz, bechamel, dupla mozzarella, mozzarella golyó', '2695.00', 'https://image2url.com/r2/default/images/1770972477795-d8099a64-7ba7-46e6-9f46-9cc1324aa98f.png', 1),
(39, 8, 'Olaszkolbászos sült tészta', 'Penne tészta, napoletta szósz, bechamel, grillezett olaszkolbász, mozzarella', '3695.00', 'https://image2url.com/r2/default/images/1770972529991-41f46bea-d406-417f-8167-95afb99ad43d.png', 1),
(40, 8, 'Fokhagymás sült tészta', 'Penne tészta, fokhagyma szósz, sonka, gomba, lilahagyma, mozzarella', '3495.00', 'https://image2url.com/r2/default/images/1770972672058-3acf4c3f-9156-4641-834c-f03205e203c9.png', 1),
(41, 8, 'VEGGIE SÜLT TÉSZTA', 'Penne tészta, napoletta szósz, bechamel, kaliforniai paprika, gomba, lilahagyma, mozzarella', '3495.00', 'https://image2url.com/r2/default/images/1770972697733-592cbe3a-cbb3-42f5-b077-95e94fb84948.png', 1),
(42, 8, 'CHEESEBURGER MELTS', 'Sajtos csavar tele mozzarellával, marha- és sertéshúsgolyókkal, savanyú uborkával, hagymával, ketchuppal, mustárral és szezámmaggal', '2395.00', 'https://image2url.com/r2/default/images/1770972777553-6bc00347-41b2-4a3d-9b42-1e7d85432edc.png', 1),
(43, 8, 'COCA COLA 0,5L', 'Frissítő üdítő', '995.00', 'https://image2url.com/r2/default/images/1770973095228-563ffe69-f83d-44bd-835b-17d6d6488c4d.png', 1),
(44, 8, 'Fanta Narancs 0,5L', 'Frissítő üdítő', '995.00', 'https://image2url.com/r2/default/images/1770973155532-9475c1e9-c742-4cfd-93f7-f7a3b2d0c7bc.png', 1),
(45, 8, 'NaturAqua szénsavas ásványvíz 0,5L', 'Friss Víz ', '845.00', 'https://image2url.com/r2/default/images/1770973214272-24d75e45-273b-48af-85ca-475c86fa3faa.png', 1),
(46, 1, 'Buddha Tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', 'https://image2url.com/r2/default/images/1770973285113-64662e22-f968-4b2a-ab09-0ba8c4485979.png', 1),
(47, 1, 'Angol Reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770973338365-75d0983c-3c6c-40bf-9fd1-b4b8e19258a6.png', 1),
(48, 1, 'Diet_Etikus Angol reggeli', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770973625474-f681e05e-357a-42c7-89ef-ead9c03e04f0.png', 1),
(49, 1, 'Reggeli Bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', 'https://image2url.com/r2/default/images/1770973713823-cb25042a-2bb7-4d44-9578-5f92296381f9.png', 1),
(50, 1, 'Eggs Florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770974128017-16d68adc-5d21-4310-b16c-2ed55fff4434.png', 1),
(51, 1, 'Eggs Benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770974162680-a82d0468-2065-43c9-aa46-8fed7eec011e.png', 1),
(52, 1, 'Tarja Toast Paradicsomos Babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', 'https://image2url.com/r2/default/images/1770974237984-3ad5f387-9e38-4682-8801-d8ea3b5108a6.png', 1),
(53, 1, 'Croque Madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770974342027-7e56eaa3-97d2-4f05-a229-505b7abaf087.png', 1),
(54, 1, 'Mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770974419265-4a8fc3ef-4492-468e-8c6c-032279117bd6.png', 1),
(55, 1, 'Monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', 'https://image2url.com/r2/default/images/1770974634862-7ea3de13-7e42-4ce2-bdf5-2edf0ee70bb0.png', 1),
(56, 1, 'Klasszikus Bundás Kenyér', 'friss salátával és joghurtos mártogatóssal', '2750.00', 'https://image2url.com/r2/default/images/1770974688000-03957565-4df3-4fbf-8f2f-31e2878f2466.png', 1),
(57, 1, 'Dupla Sajtos Bundás Kenyér', 'dupla sajtos bundás kenyér pirított gombával és nagy salátával', '3350.00', 'https://image2url.com/r2/default/images/1770975110425-6de26042-18d3-4271-8171-0a7ac6d64bfb.png', 1),
(58, 1, 'Kolbászos-Sajtos Bundás Kenyér', 'kolbászos-sajtos bundás kenyér friss salátával', '3650.00', 'https://image2url.com/r2/default/images/1770974919524-e2e6e836-62cf-4e3e-8d4a-77b2b05e9c2f.png', 1),
(59, 1, 'Ciklonburger', 'házi zöldségpogácsa friss salátával', '3450.00', 'https://image2url.com/r2/default/images/1770974978619-dd4ae9e7-9313-42b3-a812-4db3c7967f66.png', 1),
(60, 1, 'Pirított Zöldségek', 'pácolt tofuval és lepénnyel', '3700.00', 'https://image2url.com/r2/default/images/1770975015948-4a4de998-361d-46db-a2df-2d14eb46bece.png', 1),
(61, 1, 'Grillezett Sajt', 'cukkini salátával', '3750.00', 'https://image2url.com/r2/default/images/1770975173495-6b5cf11f-707b-433e-a565-a1396e34830f.png', 1),
(62, 1, 'Shakshuka', 'közel-keleti lecsó tojással', '3650.00', 'https://image2url.com/r2/default/images/1770975228377-f0e95543-77a7-4431-8c04-6bb40599a8ea.png', 1),
(63, 1, 'Buddha Bagel', 'vegán verzió friss zöldségekkel', '3450.00', 'https://image2url.com/r2/default/images/1770975299466-971c9505-3099-4b5b-af3c-72b742b3b00c.png', 1),
(64, 1, 'Vegan Croissant', 'házi készítésű vegán croissant', '3200.00', 'https://image2url.com/r2/default/images/1770975458834-ec9ba246-bf83-4b21-9198-e47f2e62c802.png', 1),
(65, 1, 'Desszert (Szezonális)', 'aktuális desszert a tábláról', '3300.00', 'https://image2url.com/r2/default/images/1770975538945-d2c16ec3-98fe-4414-9180-43b5ecde0135.png', 1),
(86, 1, 'Klasszikus Étcsoki', '69%-os étcsokoládé', '1500.00', 'https://image2url.com/r2/default/images/1770975967081-8d8c82cb-67a8-4ecd-8a3e-fb5e30026555.png', 1),
(87, 1, 'Mocha', 'hot chocolate + espresso shot', '1950.00', 'https://image2url.com/r2/default/images/1770976017266-012593d2-441c-407b-909c-7dec47253cba.png', 1),
(88, 1, 'Chai Latte', 'fűszeres chai tea latte', '1400.00', 'https://image2url.com/r2/default/images/1770976104295-e4f62976-fbcc-45bb-a3e4-e0c1bc5c08de.png', 1),
(89, 1, 'Dirty Chai', 'chai latte + espresso shot', '1750.00', 'https://image2url.com/r2/default/images/1770976154726-8a01490b-6771-4822-b18b-8d54f9e2c25e.png', 1),
(90, 1, 'Sós Karamell Latte', 'salty caramel latte', '1400.00', 'https://image2url.com/r2/default/images/1770976200980-3ecd22e9-e987-47bb-aca4-cef154a3a5e6.png', 1),
(91, 1, 'Dirty Sós Karamell', 'dirty salty caramel', '1750.00', 'https://image2url.com/r2/default/images/1770976272570-11a60eb6-016d-4543-9ba2-df2f777a0e19.png', 1),
(92, 1, 'Kurkuma Latte', 'turmeric latte', '1400.00', 'https://image2url.com/r2/default/images/1770976328972-3669affb-0488-46cd-ad97-b123c3dd1f68.png', 1),
(93, 1, 'Kardamom Latte', 'cardamom latte', '1400.00', 'https://image2url.com/r2/default/images/1770976397341-b13c578d-26d0-4f7d-b64e-53eef1c3e632.png', 1),
(94, 1, 'Dirty Kardamom Latte', 'dirty cardamom latte', '1750.00', 'https://image2url.com/r2/default/images/1770976491585-1e372159-f191-43ac-a4ac-f3992ea77a4c.png', 1),
(95, 1, 'Espresso Tonic', 'espresso + tonic water', '1750.00', 'https://image2url.com/r2/default/images/1770976536280-6e52e510-fd41-477f-910d-b1651b9883e8.png', 1),
(96, 2, 'Buddha Tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', 'https://image2url.com/r2/default/images/1770976806895-eb5adbb3-64ae-4e16-922e-2a208d7263e6.png', 1),
(97, 2, 'Angol Reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770976840000-15699f23-2064-40f9-bec3-a8bf3007c350.png', 1),
(98, 2, 'Diet-Etikus Angol Reggeli', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', 'https://image2url.com/r2/default/images/1770977005172-d1c25687-96f1-4414-a72e-7c83ac10e749.png', 1),
(99, 2, 'Reggeli Bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', 'https://image2url.com/r2/default/images/1770977036701-8b3cb4b5-9622-4096-a094-6d8684f7d58f.png', 1),
(100, 2, 'Eggs Florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770977063751-bff591eb-3c9d-4df0-a4de-18b0bbcd2797.png', 1),
(101, 2, 'Eggs Benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', 'https://image2url.com/r2/default/images/1770977092503-c9a24c5c-042b-49a7-91fa-c8eacb040d70.png', 1),
(102, 2, 'Tarja Toast Paradicsomos Babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', 'https://image2url.com/r2/default/images/1770977171536-ed459c1d-7bce-440b-9965-d3718dffa3f8.png', 1),
(103, 2, 'Croque Madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770977269985-add49ec3-748d-4406-8fda-20af27c7f840.png', 1),
(104, 2, 'Mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', 'https://image2url.com/r2/default/images/1770977303870-3377a0cc-ee58-4f8a-9fb7-dad2559a184f.png', 1),
(105, 2, 'Monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', 'https://image2url.com/r2/default/images/1770977337089-d9f54395-96b7-468e-bf09-1493a9588e7b.png', 1),
(106, 2, 'Vegan Croissant', 'házi készítésű vegán croissant', '3200.00', 'https://image2url.com/r2/default/images/1770977389609-5d06f568-80f9-4326-a93a-32ed4501e8ca.png', 1),
(107, 2, 'Desszert szezonális', 'aktuális desszert a tábláról', '3300.00', 'https://image2url.com/r2/default/images/1770977502312-81e4642a-e253-44bc-bf60-d88a490917d3.png', 1),
(108, 2, 'Csokoládés Brownie', 'puha csokoládés sütemény', '3200.00', 'https://image2url.com/r2/default/images/1770977533400-b8792394-92ca-4a26-8f16-c2ef454d2e34.png', 1),
(109, 2, 'Epres Pohárdesszert', 'friss eper, krém, piskóta', '3350.00', 'https://image2url.com/r2/default/images/1770977564243-6e3497d1-148a-44df-8201-a68a0102f702.png', 1),
(110, 2, 'Citromtorta Szelet', 'citromkrémes tortaszelet', '3400.00', 'https://image2url.com/r2/default/images/1770977600178-01233834-9522-496b-be36-ecb4ab198e97.png', 1),
(111, 2, 'Mogyorós Csokoládétorta', 'krémes csokoládétorta mogyoróval', '3450.00', 'https://image2url.com/r2/default/images/1770977628807-d409ce6b-c774-454a-9bb9-afe49e46f8a1.png', 1),
(112, 2, 'Vaníliás Panna Cotta', 'krémes vanília desszert gyümölccsel', '3300.00', 'https://image2url.com/r2/default/images/1770977714679-0f867475-74aa-4d48-b7bb-dd9b15f68821.png', 1),
(113, 2, 'Almás Pite', 'házi almás pite fahéjjal', '3200.00', 'https://image2url.com/r2/default/images/1770977740410-1d396332-7faa-4d10-98a7-14188a5b3e97.png', 1),
(114, 2, 'Sütőtök Mousse', 'krémes sütőtök mousse', '3350.00', 'https://image2url.com/r2/default/images/1770977772517-999dc9e7-5f8c-4aa9-b139-9f0ba534e871.png', 1),
(115, 2, 'Karamellás Pohárdesszert', 'krémes karamell mousse csokival', '3400.00', 'https://image2url.com/r2/default/images/1770977809204-a08a741a-5648-4fdd-a469-133f4e9eb2ed.png', 1),
(136, 2, 'Espresso', 'klasszikus feketekávé', '750.00', 'https://image2url.com/r2/default/images/1770977994829-550ba32f-3c97-40d0-b888-b6a950265b76.png', 1),
(137, 2, 'Doppio', 'dupla espresso', '1200.00', 'https://image2url.com/r2/default/images/1770978031273-c38f6aaf-9547-48d7-835b-0639297e9722.png', 1),
(138, 2, 'Cappuccino', 'espresso + tejhab', '1200.00', 'https://image2url.com/r2/default/images/1770978076195-1d32f62f-2272-4a86-aa70-4ab5ce8e64e9.png', 1),
(139, 2, 'Latte', 'espresso + gőzölt tej', '1450.00', 'https://image2url.com/r2/default/images/1770978117323-230410ec-5a28-4236-bcdc-37ecab01a452.png', 1),
(140, 2, 'Flat White', 'espresso + mikrohabos tej', '1450.00', 'https://image2url.com/r2/default/images/1770978148199-714318fa-66f7-4841-a56d-97f0bd289b6c.png', 1),
(141, 2, 'Forró Csoki', '69%-os étcsokoládé', '1500.00', 'https://image2url.com/r2/default/images/1770978183403-d3682408-27a9-4ce3-a002-d55e8cb806bb.png', 1),
(142, 2, 'Chai Latte', 'fűszeres chai tea latte', '1400.00', 'https://image2url.com/r2/default/images/1770978244761-0cc08ccf-3fc6-4142-a2bd-e04534e5264a.png', 1),
(143, 2, 'Dirty Chai', 'chai latte + espresso shot', '1750.00', 'https://image2url.com/r2/default/images/1770978272038-84ba62a3-edb3-4278-ad26-f5c47441a66c.png', 1),
(144, 2, 'Matcha Latte', 'matcha tea + gőzölt tej', '1650.00', 'https://image2url.com/r2/default/images/1770978304407-274234be-89b4-4355-a9d9-1c3e11c6255e.png', 1),
(145, 2, 'Házi Gyümölcsös Jeges Tea', 'házi készítésű gyümölcsös jeges tea', '1350.00', 'https://image2url.com/r2/default/images/1770978350736-9e219c21-26b1-4e5c-abbd-41b4339a8242.png', 1),
(146, 3, 'Zengővárkonyi Töltött Szelet Rántva', 'Sonkával, sajttal, csemege uborkával töltve, vegyes körettel', '6490.00', 'https://image2url.com/r2/default/images/1770983299417-d0ac3b4d-4e0f-4a5e-80b7-e9dcc5c8d8bb.png', 1),
(147, 3, 'Csülökpörkölt Kapros-túrós Galuskával', 'Fűszeres, szaftos csülökpörkölt friss kapros-túrós galuskával', '6350.00', 'https://image2url.com/r2/default/images/1770983338797-ce49fa9d-b097-463e-a54a-702eb5809f9b.png', 1),
(148, 3, 'Füstölt Csülkös, Kolbászos Babgulyás', 'Gazdag, füstölt húsos babgulyás kolbásszal', '4935.00', 'https://image2url.com/r2/default/images/1770983398152-6664ae8a-6992-4ea7-89d9-9012b442b2d5.png', 1),
(149, 3, 'Csülök Tál (2 személyes)', 'Csülök páros, rántott csülök, töltött csülök, aszalt szilvás párolt lila káposzta, hagymás törtburgonya, tepsis burgonya, tormás tejföl', '15885.00', 'https://image2url.com/r2/default/images/1770983452278-0cfb1d44-e635-4513-a5b8-2f93483375fb.png', 1),
(150, 3, 'Töltött Csülök Szeletek Tepsis Burgonyával', 'Házi kolbászhússal töltve, tepsis burgonyával', '6490.00', 'https://image2url.com/r2/default/images/1770983500985-cea81a7e-b564-47ef-a1cb-852dd3fc292d.png', 1),
(151, 3, 'Rozmaringos Kacsacomb Hagymás Törtburgonyával', '2db comb, aszaltszilvás párolt lila káposztával', '7530.00', 'https://image2url.com/r2/default/images/1770983559896-2bee46b0-58fc-4533-8f84-3093656dd5e8.png', 1),
(152, 3, 'Rántott Csülök Petrezselymes Burgonyával', 'Ropogós rántott csülök, petrezselymes burgonyával', '6360.00', 'https://image2url.com/r2/default/images/1770983595474-3a7addd8-3490-47a1-8486-edc9b6824dbd.png', 1),
(153, 3, 'Csülkös Rizses Hús', 'Tökéletes ebéd vagy vacsora, laktató, zamatos, egészséges', '6585.00', 'https://image2url.com/r2/default/images/1770983627117-752c388e-c714-48e9-8229-e040a76ebe76.png', 1),
(154, 3, 'Csülök Frissensült', 'Csülök páros hagymás tört burgonyával, aszalt szilvás párolt lila káposztával', '8235.00', 'https://image2url.com/r2/default/images/1770983703588-6b856c54-eb07-4cb7-9ca8-57583ff36a33.png', 1),
(155, 3, 'Fatányéros 1 Személyre', 'Sült hús, friss zöldségek, fűszerek, ízletes köret, hagyományos magyar étel', '8985.00', 'https://image2url.com/r2/default/images/1770983754055-facec08e-5d26-4d1c-82a8-5b6a01129d06.png', 1),
(156, 3, 'Gundel Palacsinta Csokiöntettel', 'Egy ínycsiklandó palacsinta csokoládéöntettel (1db)', '2070.00', 'https://image2url.com/r2/default/images/1770983794331-dade1c5d-38f1-4773-aa5f-52be8361dd0c.png', 1),
(157, 3, 'Diós Palacsinta', 'Édes palacsinta dióval töltve', '1125.00', 'https://image2url.com/r2/default/images/1770983847909-cdcf6851-fe62-41cf-809f-3a069b6ea4a3.png', 1),
(158, 3, 'Fahéjas Palacsinta', 'Édes palacsinta fahéjjal töltve', '1125.00', 'https://image2url.com/r2/default/images/1770984023333-e92ee4b2-3acd-446f-9dbb-b84bd5accd29.png', 1),
(159, 3, 'Kakaós Palacsinta', 'Kakaós palacsinta, klasszikus magyar desszert', '1125.00', 'https://image2url.com/r2/default/images/1770984083071-a5a8422a-01e5-43c2-abb5-3b72b28da240.png', 1),
(160, 3, 'Lekváros Palacsinta', 'Lekvárral töltött palacsinta', '1125.00', 'https://image2url.com/r2/default/images/1770984114425-2cc40ef7-fabf-4ba5-acee-4d3fd607a1d5.png', 1),
(161, 3, 'Lekváros-Diós Palacsinta', 'Lekvár és dió ízkombinációban', '1125.00', 'https://image2url.com/r2/default/images/1770984183091-4fdbaef1-f321-4666-9464-ed42a43f9824.png', 1),
(162, 3, 'Lekváros-Túrós Palacsinta', 'Lekváros és túrós palacsinta', '1125.00', 'https://image2url.com/r2/default/images/1770984610723-cb1dfe3f-4023-4dfa-a762-06720d8f6cc7.png', 1),
(163, 3, 'Mogyorókrémes palacsinta', 'Palacsinta mogyorókrémmel', '1125.00', 'https://image2url.com/r2/default/images/1770984703022-238b0e3f-ce40-407e-9f0a-0dab2745a7fe.png', 1),
(164, 3, 'Mogyorókrémes-Túrós Palacsinta', 'Palacsinta mogyorókrémmel és túróval', '1125.00', 'https://image2url.com/r2/default/images/1770984757546-e787794a-e937-469e-af2d-c25fe762cabd.png', 1),
(165, 3, 'Gesztenyepüré', 'Gazdag és bársonyos gesztenyepüré', '2835.00', 'https://image2url.com/r2/default/images/1770984784289-f62ca39e-69c4-48d6-b378-ae5b17111722.png', 1),
(166, 3, 'Forró Csokoládé', 'Gazdag, sűrű csokoládé ital', '1500.00', 'https://image2url.com/r2/default/images/1770984839891-ad9d92c3-5f39-4d35-a450-450eb9993c86.png', 1),
(167, 3, 'Kávé', 'Frissen főzött feketekávé', '900.00', 'https://image2url.com/r2/default/images/1770984876510-54e17e40-ea83-4bf7-8bf9-1741890c1d2b.png', 1),
(168, 3, 'Espresso', 'Erős, intenzív espresso', '950.00', 'https://image2url.com/r2/default/images/1770984905671-5e44be85-a43e-4196-872d-98365c81235c.png', 1),
(169, 3, 'Cappuccino', 'Kávé tejhabbal', '1200.00', 'https://image2url.com/r2/default/images/1770984935849-42ca5bd1-f749-4899-8e6e-2e14d99a7762.png', 1),
(170, 3, 'Latte', 'Kávé meleg tejjel', '1300.00', 'https://image2url.com/r2/default/images/1770984962448-4a291d12-0f2c-438b-b693-623728f3e97b.png', 1),
(171, 3, 'Fekete Tea', 'Forró fekete tea', '800.00', 'https://image2url.com/r2/default/images/1770984998938-1dea86ec-8532-41e3-87df-4ca3d7d9ac0e.png', 1),
(172, 3, 'Zöld Tea', 'Frissítő zöld tea', '900.00', 'https://image2url.com/r2/default/images/1770985030516-85c6e887-1502-4ead-b736-f25c167482a1.png', 1),
(173, 3, 'Narancslé', 'Frissen facsart narancslé', '1200.00', 'https://image2url.com/r2/default/images/1770985055241-8c67821a-9fd5-45f3-abb4-0942b1cf5c8b.png', 1),
(174, 3, 'Almalé', 'Édes, friss almalé', '1100.00', 'https://image2url.com/r2/default/images/1770985111801-bc39af96-0c7f-457d-89ca-a1adc54ccb2d.png', 1),
(175, 3, 'Szénsavas Üdítő', 'Különböző ízekben', '900.00', 'https://image2url.com/r2/default/images/1770985190442-5d169382-6827-4265-bc34-72e3d7950c93.png', 1),
(176, 4, 'Slim Mint', 'Eper, Menta, Lime, Ananász, Alma', '2490.00', 'https://image2url.com/r2/default/images/1770985350397-4c121345-a5ff-4142-820c-ae7997a44f70.png', 1),
(177, 4, 'Passion Of Fruit', 'Banán, Ananász, Mangó, Alma', '2490.00', 'https://image2url.com/r2/default/images/1770985498519-93743832-3935-4af0-b9f3-7a381644814d.png', 1),
(178, 4, 'Popeye', 'Alma, Spenót, Ananász', '2490.00', 'https://image2url.com/r2/default/images/1770985618132-f3e4b94e-5a12-4d8e-a842-5bb140eaf83d.png', 1),
(179, 4, 'Mr. Avocado', 'Alma, Avokádó, Ananász', '2490.00', 'https://image2url.com/r2/default/images/1770985683893-0460f1e8-eeb5-49ef-8090-1081c49aab54.png', 1),
(180, 4, 'Green Power', 'Petrezselyem, Uborka, Zellerszár, Alma, Banán', '2490.00', 'https://image2url.com/r2/default/images/1770985716107-5b74fa94-2e0d-4a87-aaf9-cefbb1cd7c3e.png', 1),
(181, 4, 'Juicy Mango', 'Mangó, Kiwi, Narancs', '2490.00', 'https://image2url.com/r2/default/images/1770985788903-5e3d1359-85b0-4281-ba31-37a95afbd4d8.png', 1),
(182, 4, 'Vitaminator', 'Banán, Eper, Narancs, Menta', '2490.00', 'https://image2url.com/r2/default/images/1770985817953-036054e9-21c1-435e-992e-f7c0887b6063.png', 1),
(183, 4, 'Captain Kiwi', 'Alma, Kiwi, Banán, Narancs', '2490.00', 'https://image2url.com/r2/default/images/1770985844346-2bd6ea73-13fa-4e34-a48b-0d3dc334da27.png', 1),
(184, 4, 'Chia Mia', 'Chiamag, Alma, Mangó, Eper', '2490.00', 'https://image2url.com/r2/default/images/1770986015065-e7649dfa-0c47-41f6-a4bc-531a302d1ed2.png', 1),
(185, 4, 'Yellow Fellow', 'Alma, Mangó, Barack', '2490.00', 'https://image2url.com/r2/default/images/1770986068913-bd281e8a-e72b-4d8d-9997-6f1b5031800f.png', 1),
(186, 4, 'Müzli Tál', 'Natúr Joghurt, Granola, Zabpehely, Friss & Aszalt Gyümölcsök, Méz', '2990.00', 'https://image2url.com/r2/default/images/1770986240592-22be09d0-1aed-4919-97bf-0617bbec5161.png', 1),
(187, 4, 'NYC Salmon Bagel', 'Füstölt lazac szelet, krémsajt, jégsaláta és lilahagyma', '3090.00', 'https://image2url.com/r2/default/images/1770986278155-c90b99fd-4766-4701-9a75-e8be12447032.png', 1),
(188, 4, 'Füstölt lazacos Bagel', 'Avokádókrém, Uborka, Saláta & Füstölt Lazac', '3090.00', 'https://image2url.com/r2/default/images/1770986313098-a4c89469-0a6a-4c34-a3c2-4a1889bfa90c.png', 1),
(189, 4, 'Avokádókrémes Bagel', 'Avokádókrém, Uborka & Saláta', '2490.00', 'https://image2url.com/r2/default/images/1770986407209-6d5aa7ed-ee5a-45b7-aa94-f6886c6f045f.png', 1),
(190, 4, 'Zöld Pestós & Mozzarellás Bagel', 'Zöld Pestó, Mozzarella, Jégsaláta & Paradicsom', '2790.00', 'https://image2url.com/r2/default/images/1770986449880-7db9a862-3459-4499-84ea-fe0e5573faf2.png', 1),
(191, 4, 'Prosciutto & Bryndza Bagel', 'Bryndza Sajt, Prosciutto, Paradicsom & Jégsaláta', '2790.00', 'https://image2url.com/r2/default/images/1770986491668-7b3f2eaa-732c-4e70-bfcf-c8b65c64cfa9.png', 1),
(192, 4, 'Feta Sajtos Bagel', 'Feta Sajt, Paradicsom, Uborka & Saláta', '2790.00', 'https://image2url.com/r2/default/images/1770986528214-e4b891cb-b214-4e38-b633-226bffc83423.png', 1),
(193, 4, 'Humuszos Bagel', 'Csicseriborsókrém, Uborka & Saláta', '2490.00', 'https://image2url.com/r2/default/images/1770986551811-5d6b84e2-7d8d-4120-a175-2fd03ed2d909.png', 1),
(194, 4, 'Cream Cheese Bagel', 'Krémes sajt', '1890.00', 'https://image2url.com/r2/default/images/1770986573645-f6eec29b-dc8c-441b-be9f-42328b1ca411.png', 1),
(195, 4, 'Zöld Smoothie Tál', 'Banán, Spenót, Fodros Kelkáposzta, Petrezselyem, Menta, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986608391-5ebf1e2b-8733-4253-9ad0-20e54e8085fc.png', 1),
(196, 4, 'Sárga Smoothie Tál', 'Banán, Mangó, Ananász, Lenmag, Chia mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986669160-bcdc739d-2cc5-48f7-8504-31fabfb8a2ab.png', 1),
(197, 4, 'Piros Smoothie Tál', 'Banán, Eper, Málna, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', 'https://image2url.com/r2/default/images/1770986705902-ee3174e6-2b6f-4438-a514-f6e9bdb1b181.png', 1),
(198, 4, 'Mexican Bowl 🌶', 'Avokádó krém, Fekete bab, Kukorica, Lilahagyma, Lime, Jégsaláta, Paradicsom, Tortilla chips, Chilis olívaolaj', '3890.00', 'https://image2url.com/r2/default/images/1770986736581-1ae3773e-e959-4a3b-b91f-3558fad446fe.png', 1),
(199, 4, 'Avokádó Tál', 'Házi avokádókrém, Olívabogyók, Feta Sajt, Paradicsom, Zellerszár, Uborka, Pita vagy Bagel', '4190.00', 'https://image2url.com/r2/default/images/1770986763577-e4254b25-1ba3-4f0b-83c0-dfbea7f4cd0c.png', 1),
(200, 4, 'L.A.X. Tál', 'Füstölt Lazac, Avokádó krém, Paradicsom, Kukorica, Uborka, Saláta, Citrom', '4190.00', 'https://image2url.com/r2/default/images/1770986791384-848d054a-0a66-418d-a2b4-c2f29f32e542.png', 1),
(201, 4, 'Hummus Tál', 'Házi Humusz, Olívabogyók, Feta Sajt, Paradicsom, Cékla, Uborka, Pita vagy Bagel', '3890.00', 'https://image2url.com/r2/default/images/1770986825273-1e19c771-63d1-40b3-ac9e-a4214065efd8.png', 1),
(202, 4, 'Atom', 'Narancs, Eper, Banán, Tej, Méz, Zabpehely', '2490.00', 'https://image2url.com/r2/default/images/1770986893063-71bb3ddf-e316-4f8b-b102-bd62bcbc0979.png', 1),
(203, 4, 'No. 22', 'Szójatej, Goji Bogyó, Chia Mag, Zabpehely, Aszalt gyümölcs, Banán, Lenmag', '2690.00', 'https://image2url.com/r2/default/images/1770986946412-1c7dbb73-4589-4aaa-afbb-887e103ef856.png', 1),
(204, 4, 'FRrØyas DrØm', 'Alma, Mangó, Banán, Szójatej, Méz, Eper, Vanília', '2690.00', 'https://image2url.com/r2/default/images/1770987000054-c4b41a09-cd87-44a0-9fa9-05cbf8d3e741.png', 1),
(205, 4, 'Good Vibes', 'Ananász, Menta, Alma, Citrom, Banán, Jégkása', '2690.00', 'https://image2url.com/r2/default/images/1770987028245-6d4a407c-5817-41b9-85d4-2a0c03b956d1.png', 1),
(206, 5, 'Rántott Csirkemell Körettel', 'Kérlek, válassz köretet!', '2800.00', 'https://image2url.com/r2/default/images/1770987587376-0ea2ad0d-179a-487d-b7e7-ac3c1fc4cdca.png', 1),
(207, 5, 'Húsleves', 'Laktató leves sok hússal és zöldséggel.', '1190.00', 'https://image2url.com/r2/default/images/1770987629718-8abdd8b7-a224-435e-88dd-8c0a86a21709.png', 1),
(208, 5, 'Rántott Zöldség Körettel, Tartármártással', 'Kérlek válassz köretet!', '2800.00', 'https://image2url.com/r2/default/images/1770987693932-398a4caa-851b-440e-ba71-2150c15c9b39.png', 1),
(209, 5, 'Bolognai Sertésborda', 'A bolognai sertésborda egy olasz étel, amelyet ropogósra sütött, fűszeres zsemlemorzsával paníroznak. Olyan omlós és ízletes, hogy nem tudsz majd betelni vele.', '3990.00', 'https://image2url.com/r2/default/images/1770988126439-3f40fd2d-01a8-4601-9ffe-11c269790987.png', 1),
(210, 5, 'Sajttal-Sonkával Töltött Csirkemell Hasábburgonyával', 'Sajttal töltött csirkemell, ropogós hasábburgonyával, ízletes és laktató étel.', '3990.00', 'https://image2url.com/r2/default/images/1770988182104-c6775743-a7b1-4657-a8c3-9f752f9e8adf.png', 1),
(211, 5, 'Bableves', '', '1500.00', 'https://image2url.com/r2/default/images/1770988208647-2038c8e4-c195-4b04-ba5d-13b83f445368.png', 1),
(212, 5, 'Sertéspörkölt Galuskával Választható Coca-Cola Üdítővel', '', '3800.00', 'https://image2url.com/r2/default/images/1770988274895-0c4b6946-d7da-4b5e-97f7-471b6a998cb4.png', 1),
(213, 5, 'Bolognai spagetti választható Coca-Cola üdítővel', '', '3200.00', NULL, 1),
(214, 5, 'Rántott csirkemell hasábburgonyával, választható Coca-Cola üdítővel', '', '3500.00', NULL, 1),
(215, 5, 'Babgulyás', '', '2500.00', NULL, 1),
(216, 5, 'Gyümölcsleves', 'A gyümölcsleves egy finom és egészséges fogás, feltölt energiával és jókedvre derít!', '1550.00', NULL, 1),
(217, 5, 'Bolognai spagetti', 'Kényeztesd az ízlelőbimbóidat az ízletes, krémes bolognai spagettivel! A klasszikus olasz kedvenc, amely bővelkedik az ízekben.', '2800.00', NULL, 1),
(218, 5, 'Sertéspörkölt galuskával', 'Pörkölt galuskával: a magyar konyha klasszikusa. Puha hús, szaftos mártás, finom galuska. Egytálétel, ami mindig jól esik.', '4200.00', NULL, 1),
(219, 5, 'Rántott karaj hasábburgonyával', 'Panírozott hús, ropogós, sült krumplival tálalva, ízletes és laktató étel.', '2800.00', NULL, 1),
(220, 5, 'Szezámmagos csirkemell hasábburgonyával', 'A csirke új dimenziója.', '2800.00', NULL, 1),
(221, 5, 'Corn flakes csirkemell hasábburgonyával', 'Ropogós kukoricapehely, ízletes csirkemell és ropogós hasábburgonya kombinációja.', '2990.00', NULL, 1),
(222, 5, 'Mecseki csirkemell hasábburgonyával', 'Szaftos csirkemell, ropogós hasábburgonya, ízletes fűszerezés, tökéletes étkezés minden alkalomra.', '3990.00', NULL, 1),
(223, 5, 'Mecseki sertésszelet hasábburgonyával', 'Szaftos hús, ropogós hasábburgonya, ízletes fűszerezés, tökéletes választás étteremben.', '3990.00', NULL, 1),
(224, 5, 'Sajttal-sonkával-gombával töltött sertéskaraj hasábburgonyával', 'Sajttal, gombával töltött hús, ropogós hasábburgonyával tálalva, ízletes és laktató étel.', '3990.00', NULL, 1),
(225, 5, 'Rántott sajt jázminrizzsel, tartármártással', 'Nincs is jobb a rántott sajtnál, amikor megkívánod a ropogós falatokat.', '3590.00', NULL, 1),
(226, 5, 'Rántott camembert sajt jázminrizzsel, áfonyalekvárral', 'A rántott sajt egy klasszikus vegetáriánus étel, amelyet ropogósra sütnek, hogy aztán a sajt elolvadjon a szádban.', '3790.00', NULL, 1),
(227, 5, 'Hasábburgonya', 'Frissen és forrón tálalva!', '1100.00', NULL, 1),
(228, 5, 'Petrezselymes burgonya', 'Ízletes petrezselymes burgonya, amely tökéletes köretnek vagy akár főételnek is.', '1390.00', NULL, 1),
(229, 5, 'Steak burgonya', 'Sült burgonya', '1390.00', NULL, 1),
(230, 5, 'Cézár saláta', 'Élvezd Cézár salátánk merész és zamatos ízét, amely semmihez sem fogható ízélményt nyújt!', '2990.00', NULL, 1),
(231, 5, 'Görög saláta', 'Élvezd a roppanós és krémes textúrák tökéletes egyensúlyát minden egyes falatnál!', '2690.00', NULL, 1),
(232, 5, 'Káposztasaláta', 'Tapasztald meg a krémes és a ropogós tökéletes keverékét, klasszikus káposztasalátánkkal - ideális köret grillételekhez, szendvicsekhez és hamburgerekhez!', '850.00', NULL, 1),
(233, 5, 'Csemegeuborka', 'A klasszikus magyar ételekhez tökéletes savanyúság.', '700.00', NULL, 1),
(234, 5, 'Majonéz', 'Tapasztald meg klasszikus majonézünk sima és bársonyos ízét - egy sokoldalú összetevő, amely minden kedvenc ételed tökéletes kiegészítője lehet!', '300.00', NULL, 1),
(235, 5, 'Tartármártás', 'Tapasztald meg az ízek tökéletes egyensúlyát klasszikus tartármártásunkkal!', '400.00', NULL, 1),
(236, 5, 'Diós palacsinta', 'Egy adag 1 darabot tartalmaz', '500.00', NULL, 1),
(237, 6, 'Szezámmagos csirkemellcsíkok', 'Friss salátával tálalva, ropogós szezámmagos csirkecsíkok', '3600.00', NULL, 1),
(238, 6, 'Roston sült csirkemell', 'Balzsamecetes, friss salátával, krokettel', '3900.00', NULL, 1),
(239, 6, 'Sajttal-sonkával töltött csirkemell', 'Rizzsel tálalva, laktató és ízletes', '3900.00', NULL, 1),
(240, 6, 'Sajttal töltött csirkemell', 'Ropogós hasábburgonyával', '3600.00', NULL, 1),
(241, 6, 'Almával-sajttal-dióval töltött csirkemell', 'Rizzsel és áfonyalekvárral tálalva', '4300.00', NULL, 1),
(242, 6, 'Gombás-tejszínes csirkeragu', 'Spagetti tésztával vagy párolt rizzsel', '3600.00', NULL, 1),
(243, 6, 'Rántott vagy roston sült csirkemell', 'Frissen sült, hasábburgonyával', '3600.00', NULL, 1),
(244, 6, 'Sült bőrös császár', 'Fokhagymás burgonyapürével és pácolt almasalátával', '4300.00', NULL, 1),
(245, 6, 'Pacalpörkölt', 'Gazdag, fűszeres pacalpörkölt', '4300.00', NULL, 1),
(246, 6, 'BBQ Oldalas', 'Steakburgonyával és coleslaw salátával tálalva', '5500.00', NULL, 1),
(247, 6, 'Csülök Rite módra', 'Hagyományos módon elkészített csülök', '5500.00', NULL, 1),
(248, 6, 'Brassói aprópecsenye', 'Ízletes aprópecsenye házi fűszerezéssel', '4800.00', NULL, 1),
(249, 6, 'Brownie vaníliafagyival', 'Forró brownie, vaníliafagyival tálalva', '1800.00', NULL, 1),
(250, 6, 'Óriás palacsinta', 'Mogyorós csokoládékrémmel töltve, csokoládészósszal és prémium vaníliafagyival', '2390.00', NULL, 1),
(251, 6, 'Vargabéles', 'Hagyományos magyar desszert', '1800.00', NULL, 1),
(252, 6, 'Gesztenyepüré', 'Krémes gesztenyepüré desszertként', '1690.00', NULL, 1),
(253, 6, 'Angol zöldköret', 'Frissen készített zöldköret köretként', '1400.00', NULL, 1),
(254, 6, 'Házi galuska', 'Puha, házi készítésű galuska köretként', '950.00', NULL, 1),
(255, 6, 'Rizs', 'Párolt rizs köretként', '950.00', NULL, 1),
(256, 6, 'Steakburgonya', 'Sült burgonya steak mellé', '1000.00', NULL, 1),
(257, 6, 'Burgonyapüré', 'Frissen készített krémes burgonyapüré', '1150.00', NULL, 1),
(258, 6, 'Burgonyakrokett', 'Ropogós burgonyakrokett köretként', '950.00', NULL, 1),
(259, 6, 'Hasábburgonya', 'Frissen sült hasábburgonya köretként', '900.00', NULL, 1),
(260, 6, 'Pécsi Radler bodza 0,5l', 'Frissítő bodzás ízesítésű Radler', '790.00', NULL, 1),
(261, 6, 'Pécsi Radler meggy 0,5l', 'Finom meggyes ízesítésű Radler', '790.00', NULL, 1),
(262, 6, 'Gyümölcsfröccs', 'Fagyasztott gyümölcs, fekete ribizli, szóda (0,4 l)', '960.00', NULL, 1),
(263, 6, 'Házi limonádé', 'Friss, házilag készített limonádé (0,1 l)', '250.00', NULL, 1),
(264, 6, 'Ice Tea Barack', 'Barack ízű jeges tea (0,1 l)', '200.00', NULL, 1),
(265, 6, 'Ice Tea Citrom', 'Citrom ízű jeges tea (0,1 l)', '200.00', NULL, 1),
(266, 6, 'Szóda', 'Frissítő szódavíz (0,1 l)', '50.00', NULL, 1),
(267, 7, 'Húsleves gazdagon', 'Laktató leves sok hússal és zöldséggel', '1900.00', NULL, 1),
(268, 7, 'Medvehagymával, füstölt sajttal töltött karaj bundázva hasábburgonyával', 'Füstölt sajttal töltött hús, bundázva, hasábburgonyával tálalva, medvehagymás ízvilággal', '6150.00', NULL, 1),
(269, 7, 'Tejfölös uborkasaláta', 'Klasszikus uborkasaláta, friss és ízletes', '1510.00', NULL, 1),
(270, 7, 'Rántott szelet rizibizivel', 'Ropogós, aranybarna rántott hús, rizibizivel tálalva', '5170.00', NULL, 1),
(271, 7, 'Filézett rántott csirkecomb burgonyapürével', 'Rántott csirkecomb, krémes burgonyapürével, ízletes és laktató', '5620.00', NULL, 1),
(272, 7, 'Rántott camembert áfonyalekvárral, rizzsel', 'Olvadós rántott sajt áfonyalekvárral és rizzsel', '4840.00', NULL, 1),
(273, 7, 'Borzas csirkemell hasábburgonyával', 'Ropogós csirkemell, ízletes hasábburgonyával', '5820.00', NULL, 1),
(274, 7, 'Bolognai spagetti', 'Finom, laktató bolognai spagetti', '4850.00', NULL, 1),
(275, 7, 'Natúr csirkemell kevert friss salátával', 'Omlós csirkemell friss salátával', '5690.00', NULL, 1),
(276, 7, 'Kacsasült petrezselymes burgonyával, párolt lila káposztával', 'Fél kacsa, ízletes burgonyával és káposztával', '6600.00', NULL, 1),
(277, 7, 'Tepsiben sült oldalas petrezselymes burgonyával', 'Sült hús fűszeres burgonyával', '6340.00', NULL, 1),
(278, 7, 'Cigánypecsenye fűszeres héjas burgonyával', 'Hagyományos magyar ízletes, lédús hús', '6340.00', NULL, 1),
(279, 7, 'Gyros tál', 'Fűszeres hús, pita, friss zöldségek és ízletes szószok', '5950.00', NULL, 1),
(280, 7, 'Harcsafilé rántva kukoricasalátával', 'Rántott harcsafilé friss kukoricasalátával', '6150.00', NULL, 1),
(281, 7, 'Vadas zsemlegombóccal', 'Fűszeres, szaftos hús zsemlegombóccal', '6530.00', NULL, 1),
(282, 7, 'Marhapörkölt nokedlivel', 'Hagyományos magyar marhapörkölt nokedlivel', '6530.00', NULL, 1),
(283, 7, 'Töltött káposzta', 'Ízletes, tápláló töltött káposzta', '5490.00', NULL, 1),
(284, 7, 'Csülkös pacalpörkölt főtt burgonyával', 'Szaftos pacalpörkölt főtt burgonyával', '5690.00', NULL, 1),
(285, 7, 'Hasábburgonya', 'Frissen sült, forró hasábburgonya', '1350.00', NULL, 1),
(286, 7, 'Jázminrizs', 'Klasszikus köret, tökéletes minden ételhez', '1250.00', NULL, 1),
(287, 7, 'Rizibizi', 'Fehér rizs zöldborsóval, ízletes és klasszikus', '1350.00', NULL, 1),
(288, 7, 'Kevert friss saláta', 'Jégsaláta, uborka, paradicsom, lila hagyma, paprika', '2630.00', NULL, 1),
(289, 7, 'Görög saláta', 'Jégsaláta, paradicsom, uborka, paprika, feta sajt, olívabogyó', '2960.00', NULL, 1),
(290, 7, 'Somlói galuska', 'Elragadóan könnyű, gazdagon, krémmel tálalva', '1790.00', NULL, 1),
(291, 7, 'Palacsinta (1db)', 'Választható ízesítéssel, friss palacsinta', '800.00', NULL, 1),
(292, 7, 'Tartármártás', 'Klasszikus, ízletes tartármártás', '670.00', NULL, 1),
(293, 7, 'Tejfölös uborkasaláta', 'Klasszikus, friss és ízletes', '1510.00', NULL, 1),
(294, 7, 'Paradicsomsaláta lila hagymával', 'Friss paradicsomsaláta, köretként tökéletes', '1510.00', NULL, 1),
(295, 7, 'Ecetes almapaprika', 'Savanyúság, egyedi ízzel', '1270.00', NULL, 1),
(296, 7, 'Csemegeuborka', 'Kiváló kiegészítő sültek vagy magyaros ételek mellé', '1270.00', NULL, 1),
(297, 7, 'Káposztasaláta', 'Friss, klasszikus káposztasaláta ízzel', '1270.00', NULL, 1),
(298, 7, 'Cékla', 'Fűszeres, savanyú cékla köretként', '1268.00', NULL, 1),
(299, 9, 'Döner kebap', 'Friss pita, friss saláta (válassz húst)', '2490.00', NULL, 1),
(300, 9, 'Dürüm kebap', '30cm tortilla, friss saláta, csípős szósz, joghurtos szósz (válassz húst)', '2690.00', NULL, 1),
(301, 9, 'Döner box', 'Friss saláta, választható szósz (válassz húst és köretet)', '2690.00', NULL, 1),
(302, 9, 'Kebap tál', 'Friss saláta (válassz húst és köretet)', '3890.00', NULL, 1),
(303, 9, 'Duna chéf saláta', 'Kápia paprika, tv paprika, kígyóuborka, paradicsom, friss pita (válassz húst és szószt)', '2890.00', NULL, 1),
(304, 9, 'Sült sajtos kebap tál', 'Sült krumpli, sajt (válassz húst)', '4190.00', NULL, 1),
(305, 9, 'Sült-Zöldséges Sajtos Csirke kebap', 'Friss pita, csirke döner hús, sült paprika, sült padlizsán, feta sajt, jégsaláta, lilakáposzta, lilahagyma, paradicsom, joghurtos és csípős szósz', '2890.00', NULL, 1),
(306, 9, 'Sült-Zöldséges Sajtos Borjú Kebap', 'Friss pita, borjú döner hús, sült paprika, sült padlizsán, feta sajt, jégsaláta, lilakáposzta, lilahagyma, paradicsom, joghurtos és csípős szósz', '2990.00', NULL, 1),
(307, 9, 'Margarita pizza (32cm)', 'Pizzaszósz, sajt, oregánó', '3415.00', NULL, 1),
(308, 9, 'Szalámis pizza (32cm)', 'Pizzaszósz, sajt, szalámi, oregánó', '3915.00', NULL, 1),
(309, 9, 'Vega pizza (32cm)', 'Pizzaszósz, sajt, paradicsom, paprika, hagyma, padlizsán, oregánó', '3350.00', NULL, 1),
(310, 9, 'Csirke Burger', 'Csirkehúspogácsa, friss saláta, hamburgerszósz', '2690.00', NULL, 1),
(311, 9, 'Hamburger', 'Marhahúspogácsa, friss saláta, hamburgerszósz', '2990.00', NULL, 1),
(312, 9, 'Sajtos Burger', 'Marhahúspogácsa, sajt, friss saláta, hamburgerszósz', '3090.00', NULL, 1),
(313, 9, 'Crispy Burger', 'Cornflakes bundában sült enyhén csípős csirke, lilahagyma, paradicsom, hamburgerszósz, jégsaláta, briós zsemle', '3990.00', NULL, 1),
(314, 9, 'Chicken Nuggets 6db', '6 db csirkefalatka', '1790.00', NULL, 1),
(315, 9, 'Panírozott csirkemell tál', '2 db rántott csirkemellszelet, friss saláta, csípős és joghurtos szósz (válassz köretet)', '3990.00', NULL, 1),
(316, 9, 'Rántott camembert sajt', '6 db camembert sajt, friss saláta (válassz köretet)', '3490.00', NULL, 1),
(317, 9, 'Csokoládés baklava', 'Desszert, ami mindig jó választás', '1290.00', NULL, 1),
(318, 9, 'Diós baklava', 'Réteges tészta, ízletes szirup', '1290.00', NULL, 1),
(319, 9, 'Pisztáciás baklava', 'Egy kis boldogság minden falatban', '1390.00', NULL, 1),
(320, 9, 'Ayran sós joghurtital (0,25l)', 'Hűsítő, sós joghurtital, tökéletes fűszeres ételekhez', '490.00', NULL, 1),
(321, 9, 'Fanta Narancs 0,5l', 'Nagyszerű narancsíz, visszaváltási díj 50 Ft', '750.00', NULL, 1),
(322, 9, 'Coca-Cola Zero 0,5l', 'Zero cukor, eredeti Coke íz, visszaváltási díj 50 Ft', '750.00', NULL, 1),
(323, 9, 'Sprite citrom-lime 0,5l', 'Frissítő íz, 100%-ban természetes aromákkal, visszaváltási díj 50 Ft', '750.00', NULL, 1),
(324, 9, 'Duna chéf saláta', 'Kápia paprika, tv paprika, kígyóuborka, paradicsom, friss pita (válassz húst és szószt)', '2890.00', NULL, 1),
(325, 9, 'Falafel tál', '5 db csicseriborsó-fasírt, friss saláta, csípős és joghurtos szósz (válassz köretet)', '2990.00', NULL, 1),
(326, 9, 'Sült-Zöldséges Vega Dürüm', 'Tortilla, friss saláta, sült paprika, sült padlizsán, feta sajt (válassz szószt)', '2790.00', NULL, 1),
(327, 9, 'Palacsinta (1db)', 'Választható ízesítéssel, friss palacsinta', '800.00', NULL, 1),
(328, 9, 'NaturAqua szénsavmentes ásványvíz 0,5l', 'Frissítő, szénsavmentes természetes ásványvíz, visszaváltási díj 50 Ft', '500.00', NULL, 1);

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
(6, 22, 6, 'Pécs, Skibidi utca 3', 'preparing', '4050.00', '2026-02-11 11:33:25'),
(7, 23, 6, 'Pécs, király utca 4', 'preparing', '5490.00', '2026-02-11 20:12:40');

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
(1, 1, 97, 5, '19250.00'),
(2, 1, 96, 1, '3300.00'),
(3, 2, 46, 3, '9900.00'),
(4, 3, 299, 2, '4980.00'),
(5, 3, 301, 1, '2690.00'),
(6, 4, 96, 1, '3300.00'),
(7, 4, 98, 1, '3850.00'),
(8, 5, 46, 2, '6600.00'),
(9, 5, 90, 1, '1400.00'),
(10, 6, 237, 1, '3600.00'),
(11, 6, 263, 1, '250.00'),
(12, 6, 264, 1, '200.00'),
(13, 7, 237, 1, '3600.00'),
(14, 7, 264, 1, '200.00'),
(15, 7, 252, 1, '1690.00');

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
(6, 6, '4050.00', 'cash', 'pending', '2026-02-11 11:33:28'),
(7, 7, '5490.00', 'card', 'paid', '2026-02-11 20:12:43');

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
(1, 1, 'Reggeli Étterem', 'Brunch és reggeli ételekre specializálódott, hangulatos belvárosi kávézó.', '7621 Pécs, Király utca 23-25.', '+36 72 529 910', '08:00 - 15:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024155214-06028561-337c-43e6-8711-5405ebcfa856.png'),
(2, 1, 'Szünet Kávézó', 'Barátságos kávézó reggelivel, ebéddel és minőségi kávékkal.', '7624 Pécs, Ferencesek utcája 8.', '+36 30 911 4292', '08:00 - 18:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024177986-694b0c47-5b3a-474c-831b-8713fbeed57f.png'),
(3, 1, 'Csülök Bár', 'Hagyományos magyar konyha, csülök specialitásokkal és bőséges adagokkal.', '7634 Pécs, Pellérdi út 31.', '+36 70 578 0848', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024019791-057d43bc-1385-4d8f-a2d8-561f05d776b9.png'),
(4, 1, 'Juice&Co. Pécs Smoothie Bar', 'Friss smoothie-k, gyümölcslevek és könnyű reggelik egészséges vonalon.', '7621 Pécs, Jókai utca 1.', NULL, '09:00 - 16:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024105360-3737dba1-3096-488b-9743-ba4bd8d0efaa.png'),
(5, 1, 'Elemózsia Bisztró', 'Kedvező árú bisztró házias ízekkel, főleg reggeli és ebédidőben.', '7624 Pécs, Édesanyák útja 1.', '+36 30 627 4169', '08:00 - 15:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024065545-f6c5e70c-a40f-43ea-9626-344e2a3f27d1.png'),
(6, 1, 'Mátyás Király Vendéglő', 'Magyaros vendéglő klasszikus házias ételekkel, ebédközpontú nyitvatartással.', '7621 Pécs, Ferencesek utcája 9.', '+36 70 604 1797', '11:00 - 16:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024295551-c0c03c06-b4d4-42f0-b3e2-07bb6f3a31f7.png'),
(7, 1, 'Teca Mama Kisvendéglő', 'Házias magyar konyha, vidéki hangulat és kiadós fogások.', '7634 Pécs, Éger köz 10.', '+36 72 332 430', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024214009-9851c5f4-e79c-4088-9619-236184eb1633.png'),
(8, 1, 'Pizza Hut Pécs', 'Nemzetközi pizza lánc klasszikus és prémium pizzákkal.', '7621 Pécs, Irgalmasok utcája 6.', '+36 30 990 5050', '10:00 - 00:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770024132786-254a7d26-4b64-48ba-b1fb-c244e0a3b56c.png'),
(9, 1, 'Best Food Grill Pécs', 'Gyorsétterem grill ételekkel, kebabbal és pizzával a belvárosban.', '7621 Pécs, Széchenyi tér 8.', '+36 72 268 922', '10:30 - 22:00', '2026-01-09 08:51:32', 'https://image2url.com/r2/default/images/1770023942394-b802f1f9-b84a-497a-84e3-01ca3f9df135.png'),
(10, 1, 'Módosított Étterem Név', 'Módosított leírás', 'Pécs, Módosítás utca 18.', '+36 30 999 8888', '09:00 - 23:00', '2026-02-05 12:43:55', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `restaurant_id` int(11) DEFAULT NULL,
  `dish_id` int(11) DEFAULT NULL,
  `rating` tinyint(4) NOT NULL,
  `comment` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(2, 'Teszt Vásárló', 'tesztvásárló', 'vasarlo@example.com', 'ds14%w5', '+36201112222', 'customer', '2025-10-03 09:37:09', 0),
(4, 'exampleadmind', 'exampleadmind', 'exampleadmind@gmail.com', '12sd5@z2', '+360301245235', 'admin', '2025-12-05 10:02:44', 0),
(5, 'exaplerestaurant_owner', 'exaplerestaurant_owner', 'exaplerestaurant_owner@gmail.com', 'tM6%qaR5', '+363042523434', 'restaurant_owner', '2025-12-05 10:03:25', 0),
(6, 'teszt', 'teszt', 'teszt@gmail.com', 'aR7&xpQ1', '+3630131242', 'customer', '2025-12-05 10:16:19', 0),
(7, 'teszt2', 'teszt2', 'teszt2@gmail.com', 'K3m!4tRa', '+3630324246', 'customer', '2025-12-05 10:16:55', 0),
(8, 'teszt3', 'teszt3', 'teszt3@gmail.com', 'pS9#wB2n', '+36301244', 'customer', '2025-12-05 10:18:08', 0),
(9, 'teszt4', 'teszt4', 'teszt4@gmail.com', 'vT9@qR1m', '+2388247849825', 'customer', '2025-12-05 10:19:07', 0),
(10, 'teszt5', 'teszt5', 'teszt5@gmail.com', 'ek39!f2i', '+363012335', 'customer', '2025-12-05 10:19:34', 0),
(11, 'teszt6', 'teszt6', 'teszt6@gmail.com', 'tk569%h', '+363057456', 'customer', '2025-12-05 10:20:58', 0),
(12, 'teszt7', 'teszt7', 'teszt7@gmail.com', 'rj39h&4g', '+36303742384', 'customer', '2025-12-05 10:21:41', 0),
(13, 'teszt8', 'teszt8', 'teszt8@gmail.com', '3kt6s2&g', '+363043422', 'customer', '2025-12-05 10:22:41', 0),
(14, 'teszt9', 'teszt9', 'teszt9@gmail.com', 'ycg42@gj', '+363012345', 'customer', '2025-12-05 10:23:19', 0),
(17, 'Pásztor Kevin', 'pkevin22', 'kevinpasztor10@gmail.com', '$2a$10$sMFsGwD1ykY3v8CvZ6VFoetAWO7N0Pk01KTcC8P9sJ29DABBl8dTa', '06205038648', 'admin', '2026-02-09 10:21:41', 0),
(18, 'Kocsis Szabolcs', 'Yolo', 'kocsis.szabolcs.erno@szechenyi.hu', '$2a$10$Nt2YIrBRwQrOPaFXMxoRnurN1/CWSK9.cuo0EgN2lhNYvJeG31v42', '+36 30 8145152', 'customer', '2026-02-09 12:15:02', 0),
(19, 'John Doe', 'jdoe', 'johndoe@gmail.com', '$2a$10$96oB3ipZVVEJ8R5cXV1ZhuY5Q34u4irBkBO50e20ibTs6.MF8k3t2', '0616704201', 'customer', '2026-02-09 13:10:40', 0),
(20, 'Kocsis Legolas', 'legolas34', 'lajossziauram509@gmail.com', '$2a$10$wPlR/y2t.BmplbY6XZuTyeIH4lvXCPd3CjNyPiqTRSvqIxSmHog5i', '06204325438', 'admin', '2026-02-11 10:06:30', 0),
(21, 'Kis Borbás Dorián Zsolt', 'kbdorian', '092@drxy.hu', '$2a$10$BVdGEzYjHQg01Zf0u3.kVOL2JXtbPbOKZPHb19YBhgQdkf4e.TtDu', '', 'customer', '2026-02-11 10:24:19', 0),
(22, 'Németh Barna Kristóf', 'nbarni6', 'nemet.barnab@gmail.com', '$2a$10$PJaaQzjJiU7zMHBvbam03uYRvoCcBmEzMev.fdM5fBOr1y25DbRYO', '06209876543', 'customer', '2026-02-11 11:32:39', 0),
(23, 'Orsós Friderika', 'ofrid', 'reklamok.reklamok@gmail.com', '$2a$10$pDlZjXBpinGsyC0tjnLmTucUR0SYUvA3N5zV0V8vIWR4HXw7OJXuK', '06207125346', 'customer', '2026-02-11 20:09:43', 0);

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
  ADD KEY `fk_review_dish` (`dish_id`);

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
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `dishes`
--
ALTER TABLE `dishes`
  MODIFY `dish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=329;

--
-- AUTO_INCREMENT a táblához `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `restaurant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

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
  ADD CONSTRAINT `fk_review_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
