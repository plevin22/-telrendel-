-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Gép: localhost:8889
-- Létrehozás ideje: 2026. Jan 09. 10:33
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    INSERT INTO users (name, email, password, phone, address, role) VALUES (name, email, password, phone, address, role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser` (IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    INSERT INTO users (name, email, password, phone, address, role)
    VALUES (name, email, password, phone, address, role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDish` (IN `p_dish_id` INT)   BEGIN
    DELETE FROM dishes WHERE dish_id = p_dish_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrder` (IN `order_id` INT)   BEGIN
    DELETE FROM orders WHERE order_id = order_id;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `p_user_id` INT)   BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `user_id` INT, IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255), IN `phone` VARCHAR(50), IN `address` TEXT, IN `role` ENUM('customer','admin','restaurant_owner'))   BEGIN
    UPDATE users
    SET name = name,
        email = email,
        password = password,
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
(16, 8, 'CHEESEBURGER PIZZA', 'Sajtszósz, mozzarella, marha- és sertéshúsgolyók, hagyma, fűszeres paradicsomszósz, savanyú uborka, ketchup, mustár, szezámmag', '4495.00', NULL, 1),
(17, 8, 'BBQ NUGGETS', 'Sütőben sült nuggets falatok, mozzarella, BBQ szósz, bacon, zöldpaprika', '4495.00', NULL, 1),
(18, 8, 'Margarita', 'Fűszeres paradicsomszósz, Mozzarella sajt', '3795.00', NULL, 1),
(19, 8, 'Olaszkolbászos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Olaszkolbász', '3995.00', NULL, 1),
(20, 8, 'BBQ-Bacon', 'BBQ szósz, Mozzarella sajt, Bacon', '3995.00', NULL, 1),
(21, 8, 'Dallas', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Gomba', '3995.00', NULL, 1),
(22, 8, 'Hawaii', 'Fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Ananász', '3995.00', NULL, 1),
(23, 8, 'CARBONARA', 'Fokhagymás szósz, Mozzarella sajt, Sonka, Bacon', '4295.00', NULL, 1),
(24, 8, 'Csirkés-Jalapenos', 'Fűszeres paradicsomszósz, Mozzarella sajt, Fűszeres csirke, Jalapeño paprika', '4295.00', NULL, 1),
(25, 8, 'SokSajtos', 'Fokhagymás szósz, Mozzarella sajt, Cheddar sajt, Mozzarella golyók, Correggio sajt', '4295.00', NULL, 1),
(26, 8, 'CSOKIS KEKSZ', 'Forró csokis sütemény egyenesen sütőből', '1395.00', NULL, 1),
(27, 8, 'B&J 100 ML Epres Sajttorta', 'Ínycsiklandó epres sajttorta ízű jégkrém eperdarabokkal és gazdag kekszörvényekkel!', '1695.00', NULL, 1),
(28, 8, 'B&J 100ML Cookie Dough', 'Vaníliás jégkrém tökéletes találkozása csokis sütemény darabkákkal', '1695.00', NULL, 1),
(29, 8, 'B&J 100ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie sütemény darabkákkal', '1695.00', NULL, 1),
(30, 8, 'B&J 465ML Brookies&Cream', 'A népszerű Brookies sütemény és vanília jégkrém harmóniája fehér bevonómassza darabokkal', '4995.00', NULL, 1),
(31, 8, 'B&J 465ML Cookie Dough', 'Vaníliás jégkrém csokis sütemény darabkákkal', '4995.00', NULL, 1),
(32, 8, 'B&J 465ML Netflix&Chill\'d', 'Földimogyoróvajas jégkrém édes-sós pereccel és brownie darabokkal', '4995.00', NULL, 1),
(33, 8, 'B&J 465ML Choco Fudge Brownie', 'Csokoládés jégkrém brownie darabkákkal', '4995.00', NULL, 1),
(34, 8, 'MAGNUM PINK LEMONADE 440ML', 'Citromos jégkrém málna szorbéval, fehércsoki bevonattal és pattogó cukorkával', '4445.00', NULL, 1),
(35, 8, 'Magnum 440ML Dupla Mogyorós', 'Csokis-mogyorós és sós karamelles mandula jégkrém', '4445.00', NULL, 1),
(36, 8, 'CHEESEBURGER SÜLT TÉSZTA', 'Friss penne szaftos marha- és sertéshúsgolyókkal, nyúlós mozzarella sajt, savanyú uborka, hagyma, ketchup, mustár és szezámmag', '3695.00', NULL, 1),
(37, 8, 'MAC \'N\' CHEETOS', 'Penne krémes béchamel- és sajtmártással, mozzarella, cheddar és gouda keverékével, ropogós sajtos CHEETOS-szal', '3695.00', NULL, 1),
(38, 8, 'MARGHERITA SÜLT TÉSZTA', 'Penne tészta, fűszeres paradicsomszósz, bechamel, dupla mozzarella, mozzarella golyó', '2695.00', NULL, 1),
(39, 8, 'Olaszkolbászos sült tészta', 'Penne tészta, napoletta szósz, bechamel, grillezett olaszkolbász, mozzarella', '3695.00', NULL, 1),
(40, 8, 'Fokhagymás sült tészta', 'Penne tészta, fokhagyma szósz, sonka, gomba, lilahagyma, mozzarella', '3495.00', NULL, 1),
(41, 8, 'VEGGIE SÜLT TÉSZTA', 'Penne tészta, napoletta szósz, bechamel, kaliforniai paprika, gomba, lilahagyma, mozzarella', '3495.00', NULL, 1),
(42, 8, 'CHEESEBURGER MELTS', 'Sajtos csavar tele mozzarellával, marha- és sertéshúsgolyókkal, savanyú uborkával, hagymával, ketchuppal, mustárral és szezámmaggal', '2395.00', NULL, 1),
(43, 8, 'BBQ NUGGETS SÜLT TÉSZTA', 'Sütőben sült nuggets falatok, mozzarella, BBQ szósz, bacon, zöldpaprika', '3695.00', NULL, 1),
(44, 8, 'Sonkás-Csirkés sült tészta', 'Penne tészta, fokhagymás szósz, Sonka, Kebab csirke, Zöldpaprika, mozzarella', '3695.00', NULL, 1),
(45, 8, 'Capricciosa sült tészta', 'Penne tészta, fűszeres paradicsomszósz, Mozzarella sajt, Sonka, Gomba, Fekete olíva, Koktélparadicsom', '4295.00', NULL, 1),
(46, 1, 'buddha tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', NULL, 1),
(47, 1, 'angol reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(48, 1, 'diet_etikus angol', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(49, 1, 'reggeli bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', NULL, 1),
(50, 1, 'eggs florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(51, 1, 'eggs benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(52, 1, 'tarja toast paradicsomos babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', NULL, 1),
(53, 1, 'croque madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(54, 1, 'mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(55, 1, 'monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', NULL, 1),
(56, 1, 'klasszikus bundás kenyér', 'friss salátával és joghurtos mártogatóssal', '2750.00', NULL, 1),
(57, 1, 'dupla sajtos bundás kenyér', 'dupla sajtos bundás kenyér pirított gombával és nagy salátával', '3350.00', NULL, 1),
(58, 1, 'kolbászos-sajtos bundás kenyér', 'kolbászos-sajtos bundás kenyér friss salátával', '3650.00', NULL, 1),
(59, 1, 'ciklonburger', 'házi zöldségpogácsa friss salátával', '3450.00', NULL, 1),
(60, 1, 'pirított zöldségek', 'pácolt tofuval és lepénnyel', '3700.00', NULL, 1),
(61, 1, 'grillezett sajt', 'cukkini salátával', '3750.00', NULL, 1),
(62, 1, 'shakshuka', 'közel-keleti lecsó tojással', '3650.00', NULL, 1),
(63, 1, 'buddha bagel', 'vegán verzió friss zöldségekkel', '3450.00', NULL, 1),
(64, 1, 'vegan croissant', 'házi készítésű vegán croissant', '3200.00', NULL, 1),
(65, 1, 'desszert szezonális', 'aktuális desszert a tábláról', '3300.00', NULL, 1),
(66, 1, 'buddha tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', NULL, 1),
(67, 1, 'angol reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(68, 1, 'diet_etikus angol', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(69, 1, 'reggeli bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', NULL, 1),
(70, 1, 'eggs florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(71, 1, 'eggs benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(72, 1, 'tarja toast paradicsomos babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', NULL, 1),
(73, 1, 'croque madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(74, 1, 'mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(75, 1, 'monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', NULL, 1),
(76, 1, 'klasszikus bundás kenyér', 'friss salátával és joghurtos mártogatóssal', '2750.00', NULL, 1),
(77, 1, 'dupla sajtos bundás kenyér', 'dupla sajtos bundás kenyér pirított gombával és nagy salátával', '3350.00', NULL, 1),
(78, 1, 'kolbászos-sajtos bundás kenyér', 'kolbászos-sajtos bundás kenyér friss salátával', '3650.00', NULL, 1),
(79, 1, 'ciklonburger', 'házi zöldségpogácsa friss salátával', '3450.00', NULL, 1),
(80, 1, 'pirított zöldségek', 'pácolt tofuval és lepénnyel', '3700.00', NULL, 1),
(81, 1, 'grillezett sajt', 'cukkini salátával', '3750.00', NULL, 1),
(82, 1, 'shakshuka', 'közel-keleti lecsó tojással', '3650.00', NULL, 1),
(83, 1, 'buddha bagel', 'vegán verzió friss zöldségekkel', '3450.00', NULL, 1),
(84, 1, 'vegan croissant', 'házi készítésű vegán croissant', '3200.00', NULL, 1),
(85, 1, 'desszert szezonális', 'aktuális desszert a tábláról', '3300.00', NULL, 1),
(86, 1, 'klasszikus étcsoki', '69%-os étcsokoládé', '1500.00', NULL, 1),
(87, 1, 'mocha', 'hot chocolate + espresso shot', '1950.00', NULL, 1),
(88, 1, 'chai latte', 'fűszeres chai tea latte', '1400.00', NULL, 1),
(89, 1, 'dirty chai', 'chai latte + espresso shot', '1750.00', NULL, 1),
(90, 1, 'sós karamell latte', 'salty caramel latte', '1400.00', NULL, 1),
(91, 1, 'dirty sós karamell', 'dirty salty caramel', '1750.00', NULL, 1),
(92, 1, 'kurkuma latte', 'turmeric latte', '1400.00', NULL, 1),
(93, 1, 'kardamom latte', 'cardamom latte', '1400.00', NULL, 1),
(94, 1, 'dirty kardamom latte', 'dirty cardamom latte', '1750.00', NULL, 1),
(95, 1, 'espresso tonic', 'espresso + tonic water', '1750.00', NULL, 1),
(96, 2, 'Buddha tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', NULL, 1),
(97, 2, 'Angol reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(98, 2, 'Diet-etikus angol', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(99, 2, 'Reggeli bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', NULL, 1),
(100, 2, 'Eggs Florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(101, 2, 'Eggs Benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(102, 2, 'Tarja toast paradicsomos babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', NULL, 1),
(103, 2, 'Croque Madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(104, 2, 'Mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(105, 2, 'Monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', NULL, 1),
(106, 2, 'Vegan croissant', 'házi készítésű vegán croissant', '3200.00', NULL, 1),
(107, 2, 'Desszert szezonális', 'aktuális desszert a tábláról', '3300.00', NULL, 1),
(108, 2, 'Csokoládés brownie', 'puha csokoládés sütemény', '3200.00', NULL, 1),
(109, 2, 'Epres pohárdesszert', 'friss eper, krém, piskóta', '3350.00', NULL, 1),
(110, 2, 'Citromtorta szelet', 'citromkrémes tortaszelet', '3400.00', NULL, 1),
(111, 2, 'Mogyorós csokoládétorta', 'krémes csokoládétorta mogyoróval', '3450.00', NULL, 1),
(112, 2, 'Vaníliás panna cotta', 'krémes vanília desszert gyümölccsel', '3300.00', NULL, 1),
(113, 2, 'Almás pite', 'házi almás pite fahéjjal', '3200.00', NULL, 1),
(114, 2, 'Sütőtök mousse', 'krémes sütőtök mousse', '3350.00', NULL, 1),
(115, 2, 'Karamellás pohárdesszert', 'krémes karamell mousse csokival', '3400.00', NULL, 1),
(116, 2, 'Buddha tál', 'friss saláta, marinált csicseriborsó, fekete homoki bab, paradicsom, tofu, cukkínis vinaigrette, pirított magvak, csírák, onsen tojás', '3300.00', NULL, 1),
(117, 2, 'Angol reggeli', '2 tükörtojás, kolbász, pirított gomba, hurka, bacon, paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(118, 2, 'Diet-etikus angol', '1 tükörtojás, kolbász, bacon, dupla pirított gomba, dupla paradicsomos bab, sült paradicsom, angol muffin', '3850.00', NULL, 1),
(119, 2, 'Reggeli bagel', 'szalonnás rántotta, sajt, majonéz házi bagelben, savanyúsággal', '3450.00', NULL, 1),
(120, 2, 'Eggs Florentine', 'angol muffin, spenót, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(121, 2, 'Eggs Benedict', 'angol muffin, sonka, onsen tojás, hollandi mártás', '3650.00', NULL, 1),
(122, 2, 'Tarja toast paradicsomos babbal', 'vajas kovászos kenyér, lassan sült tarja, tükörtojás, zöldparadicsom szósz', '3750.00', NULL, 1),
(123, 2, 'Croque Madame', 'sonkás-sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(124, 2, 'Mademoiselle', 'sajtos kenyér besamel mártással és tükörtojással', '3750.00', NULL, 1),
(125, 2, 'Monsieur', 'sonkás-sajtos kenyér besamel mártással', '3750.00', NULL, 1),
(126, 2, 'Vegan croissant', 'házi készítésű vegán croissant', '3200.00', NULL, 1),
(127, 2, 'Desszert szezonális', 'aktuális desszert a tábláról', '3300.00', NULL, 1),
(128, 2, 'Csokoládés brownie', 'puha csokoládés sütemény', '3200.00', NULL, 1),
(129, 2, 'Epres pohárdesszert', 'friss eper, krém, piskóta', '3350.00', NULL, 1),
(130, 2, 'Citromtorta szelet', 'citromkrémes tortaszelet', '3400.00', NULL, 1),
(131, 2, 'Mogyorós csokoládétorta', 'krémes csokoládétorta mogyoróval', '3450.00', NULL, 1),
(132, 2, 'Vaníliás panna cotta', 'krémes vanília desszert gyümölccsel', '3300.00', NULL, 1),
(133, 2, 'Almás pite', 'házi almás pite fahéjjal', '3200.00', NULL, 1),
(134, 2, 'Sütőtök mousse', 'krémes sütőtök mousse', '3350.00', NULL, 1),
(135, 2, 'Karamellás pohárdesszert', 'krémes karamell mousse csokival', '3400.00', NULL, 1),
(136, 2, 'Espresso', 'klasszikus feketekávé', '750.00', NULL, 1),
(137, 2, 'Doppio', 'dupla espresso', '1200.00', NULL, 1),
(138, 2, 'Cappuccino', 'espresso + tejhab', '1200.00', NULL, 1),
(139, 2, 'Latte', 'espresso + gőzölt tej', '1450.00', NULL, 1),
(140, 2, 'Flat white', 'espresso + mikrohabos tej', '1450.00', NULL, 1),
(141, 2, 'Forró csoki', '69%-os étcsokoládé', '1500.00', NULL, 1),
(142, 2, 'Chai latte', 'fűszeres chai tea latte', '1400.00', NULL, 1),
(143, 2, 'Dirty chai', 'chai latte + espresso shot', '1750.00', NULL, 1),
(144, 2, 'Matcha latte', 'matcha tea + gőzölt tej', '1650.00', NULL, 1),
(145, 2, 'Házi gyümölcsös jeges tea', 'házi készítésű gyümölcsös jeges tea', '1350.00', NULL, 1),
(146, 3, 'Zengővárkonyi töltött szelet rántva', 'Sonkával, sajttal, csemege uborkával töltve, vegyes körettel', '6490.00', NULL, 1),
(147, 3, 'Csülökpörkölt kapros-túrós galuskával', 'Fűszeres, szaftos csülökpörkölt friss kapros-túrós galuskával', '6350.00', NULL, 1),
(148, 3, 'Füstölt csülkös, kolbászos babgulyás', 'Gazdag, füstölt húsos babgulyás kolbásszal', '4935.00', NULL, 1),
(149, 3, 'Csülök tál (2 személyes)', 'Csülök páros, rántott csülök, töltött csülök, aszalt szilvás párolt lila káposzta, hagymás törtburgonya, tepsis burgonya, tormás tejföl', '15885.00', NULL, 1),
(150, 3, 'Töltött csülök szeletek tepsis burgonyával', 'Házi kolbászhússal töltve, tepsis burgonyával', '6490.00', NULL, 1),
(151, 3, 'Rozmaringos kacsacomb hagymás törtburgonyával', '2db comb, aszaltszilvás párolt lila káposztával', '7530.00', NULL, 1),
(152, 3, 'Rántott csülök petrezselymes burgonyával', 'Ropogós rántott csülök, petrezselymes burgonyával', '6360.00', NULL, 1),
(153, 3, 'Csülkös rizses hús', 'Tökéletes ebéd vagy vacsora, laktató, zamatos, egészséges', '6585.00', NULL, 1),
(154, 3, 'Csülök frissensült', 'Csülök páros hagymás tört burgonyával, aszalt szilvás párolt lila káposztával', '8235.00', NULL, 1),
(155, 3, 'Fatányéros 1 személyre', 'Sült hús, friss zöldségek, fűszerek, ízletes köret, hagyományos magyar étel', '8985.00', NULL, 1),
(156, 3, 'Gundel palacsinta csokiöntettel', 'Egy ínycsiklandó palacsinta csokoládéöntettel (1db)', '2070.00', NULL, 1),
(157, 3, 'Diós palacsinta', 'Édes palacsinta dióval töltve', '1125.00', NULL, 1),
(158, 3, 'Fahéjas palacsinta', 'Édes palacsinta fahéjjal töltve', '1125.00', NULL, 1),
(159, 3, 'Kakaós palacsinta', 'Kakaós palacsinta, klasszikus magyar desszert', '1125.00', NULL, 1),
(160, 3, 'Lekváros palacsinta', 'Lekvárral töltött palacsinta', '1125.00', NULL, 1),
(161, 3, 'Lekváros-diós palacsinta', 'Lekvár és dió ízkombinációban', '1125.00', NULL, 1),
(162, 3, 'Lekváros-túrós palacsinta', 'Lekváros és túrós palacsinta', '1125.00', NULL, 1),
(163, 3, 'Mogyorókrémes palacsinta', 'Palacsinta mogyorókrémmel', '1125.00', NULL, 1),
(164, 3, 'Mogyorókrémes-túrós palacsinta', 'Palacsinta mogyorókrémmel és túróval', '1125.00', NULL, 1),
(165, 3, 'Gesztenyepüré', 'Gazdag és bársonyos gesztenyepüré', '2835.00', NULL, 1),
(166, 3, 'Forró csokoládé', 'Gazdag, sűrű csokoládé ital', '1500.00', NULL, 1),
(167, 3, 'Kávé', 'Frissen főzött feketekávé', '900.00', NULL, 1),
(168, 3, 'Espresso', 'Erős, intenzív espresso', '950.00', NULL, 1),
(169, 3, 'Cappuccino', 'Kávé tejhabbal', '1200.00', NULL, 1),
(170, 3, 'Latte', 'Kávé meleg tejjel', '1300.00', NULL, 1),
(171, 3, 'Fekete tea', 'Forró fekete tea', '800.00', NULL, 1),
(172, 3, 'Zöld tea', 'Frissítő zöld tea', '900.00', NULL, 1),
(173, 3, 'Narancslé', 'Frissen facsart narancslé', '1200.00', NULL, 1),
(174, 3, 'Almalé', 'Édes, friss almalé', '1100.00', NULL, 1),
(175, 3, 'Szénsavas üdítő', 'Különböző ízekben', '900.00', NULL, 1),
(176, 4, 'Slim mint', 'Eper, Menta, Lime, Ananász, Alma', '2490.00', NULL, 1),
(177, 4, 'Passion of fruit', 'Banán, Ananász, Mangó, Alma', '2490.00', NULL, 1),
(178, 4, 'Popeye', 'Alma, Spenót, Ananász', '2490.00', NULL, 1),
(179, 4, 'Mr. Avocado', 'Alma, Avokádó, Ananász', '2490.00', NULL, 1),
(180, 4, 'Green power', 'Petrezselyem, Uborka, Zellerszár, Alma, Banán', '2490.00', NULL, 1),
(181, 4, 'Juicy mango', 'Mangó, Kiwi, Narancs', '2490.00', NULL, 1),
(182, 4, 'Vitaminator', 'Banán, Eper, Narancs, Menta', '2490.00', NULL, 1),
(183, 4, 'Captain kiwi', 'Alma, Kiwi, Banán, Narancs', '2490.00', NULL, 1),
(184, 4, 'Chia mia', 'Chiamag, Alma, Mangó, Eper', '2490.00', NULL, 1),
(185, 4, 'Yellow fellow', 'Alma, Mangó, Barack', '2490.00', NULL, 1),
(186, 4, 'Müzli tál', 'Natúr Joghurt, Granola, Zabpehely, Friss & Aszalt Gyümölcsök, Méz', '2990.00', NULL, 1),
(187, 4, 'NYC Salmon Bagel', 'Füstölt lazac szelet, krémsajt, jégsaláta és lilahagyma', '3090.00', NULL, 1),
(188, 4, 'Füstölt lazacos Bagel', 'Avokádókrém, Uborka, Saláta & Füstölt Lazac', '3090.00', NULL, 1),
(189, 4, 'Avokádókrémes Bagel', 'Avokádókrém, Uborka & Saláta', '2490.00', NULL, 1),
(190, 4, 'Zöld Pestós & Mozzarellás Bagel', 'Zöld Pestó, Mozzarella, Jégsaláta & Paradicsom', '2790.00', NULL, 1),
(191, 4, 'Prosciutto & Bryndza Bagel', 'Bryndza Sajt, Prosciutto, Paradicsom & Jégsaláta', '2790.00', NULL, 1),
(192, 4, 'Feta sajtos Bagel', 'Feta Sajt, Paradicsom, Uborka & Saláta', '2790.00', NULL, 1),
(193, 4, 'Humuszos Bagel', 'Csicseriborsókrém, Uborka & Saláta', '2490.00', NULL, 1),
(194, 4, 'Cream Cheese Bagel', 'Krémes sajt', '1890.00', NULL, 1),
(195, 4, 'Zöld smoothie tál', 'Banán, Spenót, Fodros Kelkáposzta, Petrezselyem, Menta, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', NULL, 1),
(196, 4, 'Sárga smoothie tál', 'Banán, Mangó, Ananász, Lenmag, Chia mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', NULL, 1),
(197, 4, 'Piros smoothie tál', 'Banán, Eper, Málna, Lenmag, Chia Mag, Zabpehely, Goji Bogyó, Kókusz', '2990.00', NULL, 1),
(198, 4, 'Mexican Bowl 🌶', 'Avokádó krém, Fekete bab, Kukorica, Lilahagyma, Lime, Jégsaláta, Paradicsom, Tortilla chips, Chilis olívaolaj', '3890.00', NULL, 1),
(199, 4, 'Avokádó Tál', 'Házi avokádókrém, Olívabogyók, Feta Sajt, Paradicsom, Zellerszár, Uborka, Pita vagy Bagel', '4190.00', NULL, 1),
(200, 4, 'L.A.X. Tál', 'Füstölt Lazac, Avokádó krém, Paradicsom, Kukorica, Uborka, Saláta, Citrom', '4190.00', NULL, 1),
(201, 4, 'Hummus Tál', 'Házi Humusz, Olívabogyók, Feta Sajt, Paradicsom, Cékla, Uborka, Pita vagy Bagel', '3890.00', NULL, 1),
(202, 4, 'Atom', 'Narancs, Eper, Banán, Tej, Méz, Zabpehely', '2490.00', NULL, 1),
(203, 4, 'No. 22', 'Szójatej, Goji Bogyó, Chia Mag, Zabpehely, Aszalt gyümölcs, Banán, Lenmag', '2690.00', NULL, 1),
(204, 4, 'FRrØyas drØm', 'Alma, Mangó, Banán, Szójatej, Méz, Eper, Vanília', '2690.00', NULL, 1),
(205, 4, 'Good Vibes', 'Ananász, Menta, Alma, Citrom, Banán, Jégkása', '2690.00', NULL, 1),
(206, 5, 'Rántott csirkemell körettel', 'Kérlek, válassz köretet!', '2800.00', NULL, 1),
(207, 5, 'Húsleves', 'Laktató leves sok hússal és zöldséggel.', '1190.00', NULL, 1),
(208, 5, 'Rántott zöldség körettel, tartármártással', 'Kérlek válassz köretet!', '2800.00', NULL, 1),
(209, 5, 'Bolognai sertésborda', 'A bolognai sertésborda egy olasz étel, amelyet ropogósra sütött, fűszeres zsemlemorzsával paníroznak. Olyan omlós és ízletes, hogy nem tudsz majd betelni vele.', '3990.00', NULL, 1),
(210, 5, 'Sajttal-sonkával töltött csirkemell hasábburgonyával', 'Sajttal töltött csirkemell, ropogós hasábburgonyával, ízletes és laktató étel.', '3990.00', NULL, 1),
(211, 5, 'Bableves', '', '1500.00', NULL, 1),
(212, 5, 'Sertéspörkölt galuskával választható Coca-Cola üdítővel', '', '3800.00', NULL, 1),
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
(1, 1, 'Reggeli Étterem', 'Brunch és reggeli ételekre specializálódott, hangulatos belvárosi kávézó.', '7621 Pécs, Király utca 23-25.', '+36 72 529 910', '08:00 - 15:00', '2026-01-09 08:51:32'),
(2, 1, 'Szünet Kávézó', 'Barátságos kávézó reggelivel, ebéddel és minőségi kávékkal.', '7624 Pécs, Ferencesek utcája 8.', '+36 30 911 4292', '08:00 - 18:00', '2026-01-09 08:51:32'),
(3, 1, 'Csülök Bár', 'Hagyományos magyar konyha, csülök specialitásokkal és bőséges adagokkal.', '7634 Pécs, Pellérdi út 31.', '+36 70 578 0848', '10:30 - 22:00', '2026-01-09 08:51:32'),
(4, 1, 'Juice&Co. Pécs Smoothie Bar', 'Friss smoothie-k, gyümölcslevek és könnyű reggelik egészséges vonalon.', '7621 Pécs, Jókai utca 1.', NULL, '09:00 - 16:00', '2026-01-09 08:51:32'),
(5, 1, 'Elemózsia Bisztró', 'Kedvező árú bisztró házias ízekkel, főleg reggeli és ebédidőben.', '7624 Pécs, Édesanyák útja 1.', '+36 30 627 4169', '08:00 - 15:00', '2026-01-09 08:51:32'),
(6, 1, 'Mátyás Király Vendéglő', 'Magyaros vendéglő klasszikus házias ételekkel, ebédközpontú nyitvatartással.', '7621 Pécs, Ferencesek utcája 9.', '+36 70 604 1797', '11:00 - 16:00', '2026-01-09 08:51:32'),
(7, 1, 'Teca Mama Kisvendéglő', 'Házias magyar konyha, vidéki hangulat és kiadós fogások.', '7634 Pécs, Éger köz 10.', '+36 72 332 430', '10:30 - 22:00', '2026-01-09 08:51:32'),
(8, 1, 'Pizza Hut Pécs', 'Nemzetközi pizza lánc klasszikus és prémium pizzákkal.', '7621 Pécs, Irgalmasok utcája 6.', '+36 30 990 5050', '10:00 - 00:00', '2026-01-09 08:51:32'),
(9, 1, 'Best Food Grill Pécs', 'Gyorsétterem grill ételekkel, kebabbal és pizzával a belvárosban.', '7621 Pécs, Széchenyi tér 8.', '+36 72 268 922', '10:30 - 22:00', '2026-01-09 08:51:32');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text,
  `role` enum('customer','admin','restaurant_owner') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `phone`, `address`, `role`, `created_at`) VALUES
(1, 'KLSZ', 'klsz@gmail.com', 'klsz12345', '+36201234567', '', 'restaurant_owner', '2025-10-03 09:37:09'),
(2, 'Teszt Vásárló', 'vasarlo@example.com', 'ds14%w5', '+36201112222', 'Pécs, Varsó utca 24', 'customer', '2025-10-03 09:37:09'),
(4, 'exampleadmind', 'exampleadmind@gmail.com', '12sd5@z2', '+360301245235', 'Pécs, Varsó utca 36', 'admin', '2025-12-05 10:02:44'),
(5, 'exaplerestaurant_owner', 'exaplerestaurant_owner@gmail.com', 'tM6%qaR5', '+363042523434', 'Pécs, Varsó utca 45', 'restaurant_owner', '2025-12-05 10:03:25'),
(6, 'teszt', 'teszt@gmail.com', 'aR7&xpQ1', '+3630131242', 'Pécs, Varsó utca 59', 'customer', '2025-12-05 10:16:19'),
(7, 'teszt2', 'teszt2@gmail.com', 'K3m!4tRa', '+3630324246', 'Pécs, Varsó utca 7.', 'customer', '2025-12-05 10:16:55'),
(8, 'teszt3', 'teszt3@gmail.com', 'pS9#wB2n', '+36301244', 'Pécs, Varsó utca 3', 'customer', '2025-12-05 10:18:08'),
(9, 'teszt4', 'teszt4@gmail.com', 'vT9@qR1m', '+2388247849825', 'Pécs, Varsó utca 51', 'customer', '2025-12-05 10:19:07'),
(10, 'teszt5', 'teszt5@gmail.com', 'ek39!f2i', '+363012335', 'Pécs, Varsó utca 40', 'customer', '2025-12-05 10:19:34'),
(11, 'teszt6', 'teszt6@gmail.com', 'tk569%h', '+363057456', 'Pécs, Varsó utca 87', 'customer', '2025-12-05 10:20:58'),
(12, 'teszt7', 'teszt7@gmail.com', 'rj39h&4g', '+36303742384', 'Pécs, Varsó utca 76', 'customer', '2025-12-05 10:21:41'),
(13, 'teszt8', 'teszt8@gmail.com', '3kt6s2&g', '+363043422', 'Pécs, Varsó utca 11', 'customer', '2025-12-05 10:22:41'),
(14, 'teszt9', 'teszt9@gmail.com', 'ycg42@gj', '+363012345', 'Pécs, Varsó utca 50', 'customer', '2025-12-05 10:23:19'),
(15, 'teszt10', 'teszt10@gmail.com', 'gjr36@fj', '+363023423525', 'Pécs, Varsó utca 98', 'customer', '2025-12-05 10:25:27'),
(16, 'teszt11', 'teszt11@gmail.com', 'gkzi794%', '+363023489', 'Pécs, Varsó utca 79', 'customer', '2025-12-05 10:25:58'),
(17, 'teszt12', 'teszt12@gmail.com', 'gjru572&', '+363023242335', 'Pécs, Varsó utca 66', 'customer', '2025-12-05 10:26:34');

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
  MODIFY `dish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=329;

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
  MODIFY `restaurant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

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
