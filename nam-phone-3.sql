-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 15, 2026 at 02:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nam-phone-3`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `province_id` varchar(50) DEFAULT NULL COMMENT 'ID Tỉnh/Thành (GHN/GHTK)',
  `district_id` varchar(50) DEFAULT NULL COMMENT 'ID Quận/Huyện',
  `ward_id` varchar(50) DEFAULT NULL COMMENT 'ID Phường/Xã',
  `address` varchar(255) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `customer_id`, `name`, `phone_number`, `province_id`, `district_id`, `ward_id`, `address`, `is_default`, `created_at`, `updated_at`) VALUES
(1, 11, 'Pham Van Minh', '1637587288', NULL, NULL, NULL, 'Núi Dứa, Đào Mỹ , Lạng Giang, Bắc Giang, Việt Nam', 0, '2024-11-23 03:51:03', '2025-01-09 21:34:04'),
(16, 11, 'Pham Van Minh', '0337587288', NULL, NULL, NULL, 'Ngõ 5thrgbẻb', 0, '2024-11-24 02:01:05', '2025-01-09 21:34:04'),
(17, 11, 'Pham Van Minh', '1637587288', NULL, NULL, NULL, 'Ngõ 5', 0, '2024-11-24 02:58:55', '2025-01-09 21:34:04'),
(18, 13, 'Pham Van Minh', '1637587288', NULL, NULL, NULL, 'thành phố Bắc Giang', 1, '2024-11-25 02:06:56', '2024-12-06 20:31:00'),
(19, 11, 'Pham Van Minh', '1637587288', NULL, NULL, NULL, 'Ngõ 6 đường 422b Vân Canh', 0, '2024-12-16 18:54:42', '2025-01-09 21:34:04'),
(20, 11, 'Pham Van Minh', '1637587288', NULL, NULL, NULL, 'Ngõ 3 khu đô thị vân canh', 1, '2025-01-09 21:34:01', '2025-01-09 21:34:04'),
(26, 20, 'TRUONG HAI NAM', '0382677204', NULL, NULL, NULL, '56/63 Đường Trần Quốc Vượng', 1, '2026-01-20 07:16:56', '2026-01-20 07:17:00'),
(27, 20, 'Trương Hải Nam', '0382677204', NULL, NULL, NULL, 'hồ tùng mậu , cầu giấy ,hà nội', 0, '2026-01-22 03:32:34', '2026-01-22 03:32:34'),
(33, 20, 'TRUONG HAI NAM', '0382677204', '01', '001', '00031', 'dadadaadad, Phường Giảng Võ, Quận Ba Đình, Thành phố Hà Nội', 0, '2026-01-23 11:33:24', '2026-01-23 11:33:24'),
(34, 22, 'minh ngoc', '+84382677204', '36', '366', '14284', 'nam đinh 34, Xã Hải An, Huyện Hải Hậu, Tỉnh Nam Định', 0, '2026-01-27 16:04:35', '2026-01-27 16:04:35');

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'text',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attributes`
--

INSERT INTO `attributes` (`id`, `name`, `slug`, `type`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Kích Thước', 'kich-thuoc', 'text', '2026-01-19 07:59:52', '2026-01-19 07:59:52', NULL),
(2, 'Màu Sắc', 'mau-sac', 'color', '2026-01-19 08:59:27', '2026-01-19 08:59:27', NULL),
(3, 'Dung Lượng', 'dung-luong', 'text', '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_values`
--

CREATE TABLE `attribute_values` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `attribute_id` bigint(20) UNSIGNED NOT NULL,
  `value` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attribute_values`
--

INSERT INTO `attribute_values` (`id`, `attribute_id`, `value`, `code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'M', NULL, '2026-01-19 08:01:03', '2026-01-19 08:44:15', NULL),
(2, 1, 'XL', NULL, '2026-01-19 08:01:10', '2026-01-19 08:37:49', '2026-01-19 08:37:49'),
(3, 1, 'l', NULL, '2026-01-19 08:44:15', '2026-01-19 08:44:15', NULL),
(4, 1, 'xl', NULL, '2026-01-19 08:44:15', '2026-01-19 08:44:15', NULL),
(5, 2, 'Đỏ', '#de3b3b', '2026-01-19 08:59:27', '2026-01-19 08:59:27', NULL),
(6, 2, 'Xanh', '#00f030', '2026-01-19 08:59:27', '2026-01-19 08:59:27', NULL),
(7, 1, 'xxl', NULL, '2026-01-19 09:13:33', '2026-01-19 09:13:33', NULL),
(8, 2, 'đỏ than', '#380000', '2026-01-19 09:13:55', '2026-01-19 09:13:55', NULL),
(9, 3, '64 GB', NULL, '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL),
(10, 3, '128 GB', NULL, '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL),
(11, 3, '256 GB', NULL, '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL),
(12, 3, '512 GB', NULL, '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL),
(13, 3, '1 T', NULL, '2026-01-19 09:43:23', '2026-01-19 09:43:23', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`id`, `name`, `slug`, `logo_url`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Apple', 'apple', 'storage/brands/oNS2ZqyHSpyfYDterb5UEIimPxtdPNglrU6q4Ynz.jpg', 1, '2026-01-18 10:17:28', '2026-01-18 10:17:44', NULL),
(2, 'rac', 'rac', 'storage/brands/5My4hTX7TofEPCLIcmsmFeDyfAxwPugniC2SGFWc.jpg', 1, '2026-01-18 10:37:19', '2026-01-18 10:37:31', NULL),
(3, 'SamSung', 'samsung', 'storage/brands/z2lumQlckPN4LAg2UVicCLFFbafvR4pn01R52kjA.jpg', 1, '2026-01-19 07:12:34', '2026-01-19 07:12:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `variant_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_checked` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `image_page` varchar(255) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `image`, `image_page`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Iphone', 'categories/yQMf22lwrOEAy6pWGnzJpbriCjAtv6cl4QCVNItl.jpg', 'categories/tiKyUHI7Zo1CdsUdC5IuHYtA1iWHiKQQcsC5zI7w.png', 1, '2024-10-08 06:43:28', '2025-11-18 02:53:55', NULL),
(2, 'SamSung', 'categories/eZ3pSqcbqLes9mxNvgFmPzPQaBeberfbe9PCz8W9.jpg', NULL, 1, '2024-10-28 02:05:44', '2025-11-18 05:22:59', NULL),
(3, 'SONY', 'categories/4lSHRXTnnsbfrBvwjkEzzyUOqL2SedTOMogVkWKD.jpg', NULL, 1, '2024-10-28 02:05:53', '2025-11-18 05:27:08', NULL),
(4, 'OPPO', 'categories/89ODh7CLF6O1MdS9FdaLARDZgeICH5OGZJmVroXt.jpg', NULL, 1, '2024-11-20 19:51:35', '2025-11-19 17:38:56', NULL),
(5, 'VIVO', 'categories/ByzPQXuYjkz6Q2jyuoIhmwE1lgCAyfIT1OEqGtgK.jpg', NULL, 1, '2024-11-20 19:54:22', '2025-11-19 17:39:18', NULL),
(6, 'REALME', 'categories/adrc5QlPuGOCWpL3FNmXbeCfqJFQY2cIlevTTEIG.jpg', NULL, 0, '2024-11-20 19:54:57', '2026-01-31 08:57:23', '2026-01-31 08:57:23'),
(7, 'NOKIA', 'categories/qoFeZMwQarN5TNvZ4RhA02BTKekuXhOw4yi9Qs58.jpg', NULL, 1, '2024-11-20 19:55:10', '2025-11-19 17:39:11', NULL),
(8, 'XIAOME', 'categories/4yWh3hFEgELomnMUOA5eTkN3Tl2tqKlUIHxr3rpc.jpg', NULL, 1, '2024-11-20 19:55:34', '2025-11-19 17:39:28', NULL),
(9, 'ASUS', 'categories/fnbDTFCX6jaCw8iLGEvl8FTUxaLjnseRTHrkkLIY.jpg', NULL, 1, '2024-11-20 19:56:18', '2025-11-19 17:39:36', NULL),
(10, 'ITEL', 'categories/qcPvkmVjLIT71Q41ZP46OToJNFfJe0ifhmu7qtZ0.jpg', NULL, 1, '2024-11-20 19:56:44', '2025-11-19 17:39:43', NULL),
(11, 'TECNO', 'categories/gGusQ9SHE0y375e5i5f1uHuCPr8KPMGa6K7NOrR7.jpg', NULL, 1, '2024-11-20 19:57:14', '2025-11-19 17:39:51', NULL),
(12, 'oneplus', 'categories/HwosFktkyqdBgYpHSyw15y9V4HFjYqG6ViweNpch.jpg', 'categories/NoGsl20pA5dhbH1ajghpqkDvyt7LBOZ1pQM87yqN.png', 1, '2024-11-21 00:08:39', '2025-11-19 17:40:00', NULL),
(13, 'hainam', 'categories/lURWbaUpR3kPVYryioA60oP0NLylvMyDPeeFkXUs.jpg', NULL, 1, '2025-11-18 05:20:58', '2026-01-31 08:54:01', NULL),
(14, 'Hai nam', 'categories/C0C8GJ2ywC8X5AO6msnwPeauRU9PHJwVKXFrvzID.jpg', NULL, 0, '2025-11-25 04:51:16', '2025-11-25 04:51:33', '2025-11-25 04:51:33'),
(15, 'Điện Thoại', NULL, NULL, 1, '2026-01-18 11:47:21', '2026-01-18 11:47:21', NULL),
(16, 'hainam33', NULL, NULL, 1, '2026-01-24 03:34:23', '2026-01-24 03:34:23', NULL),
(17, 'sfsfsfsfs', NULL, NULL, 1, '2026-03-15 13:16:48', '2026-03-15 13:16:48', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `category_news`
--

CREATE TABLE `category_news` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category_news`
--

INSERT INTO `category_news` (`id`, `title`, `slug`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Tin tức', '', 1, '2024-11-13 20:27:01', '2024-11-13 20:27:01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `review_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `comment` text NOT NULL,
  `is_admin_reply` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `review_id`, `customer_id`, `user_id`, `comment`, `is_admin_reply`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 13, 'Lifephone cảm ơn quý khách đã tin tưởng', 1, '2024-12-17 03:01:14', '2024-12-17 03:01:14'),
(2, 2, NULL, 13, 'Chúc bạn ngày mới vui vẻ', 1, '2025-01-03 00:09:18', '2025-01-03 00:09:18');

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `email`, `phone`, `subject`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(1, 'TRUONG HAI NAM', 'hainamkid@gmail.com', '0382677204', 'fđâfa', 'fdasfdafasf', 0, '2026-01-24 11:16:08', '2026-01-24 11:16:08');

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `userId` bigint(20) UNSIGNED NOT NULL,
  `customerId` bigint(20) UNSIGNED NOT NULL,
  `status` enum('on','off') NOT NULL DEFAULT 'on',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `userId`, `customerId`, `status`, `created_at`, `updated_at`) VALUES
(1, 7, 11, 'on', '2024-12-04 09:06:22', '2024-12-04 09:06:22'),
(2, 7, 13, 'on', '2024-12-04 09:23:03', '2024-12-04 09:23:03'),
(8, 7, 20, 'on', '2026-01-19 22:58:25', '2026-01-19 22:58:25'),
(9, 7, 22, 'on', '2026-01-27 13:17:32', '2026-01-27 13:17:32');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `gender` enum('male','female','other') NOT NULL DEFAULT 'other',
  `avatar` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Trạng thái tài khoản: true=hoạt động, false=khóa',
  `verification_token` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `email`, `email_verified_at`, `phone`, `address`, `gender`, `avatar`, `password`, `is_verified`, `is_active`, `verification_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(3, NULL, 'pk123.org@gmail.com', NULL, NULL, NULL, 'other', NULL, '$2y$12$IVdwxjd/f.1Rd/f1qLs9Au8z.b4qeWAqD6ueIqLbIELRkIEEOmO8G', 0, 1, 'aaDtanK7KL4U0os09XzqMXP3gTgelp3HZFuC7qFelxnNS0O0dG7AzB8WYz9P', '2024-11-21 09:26:58', '2024-11-21 11:19:04', NULL),
(11, 'quangminh.io.vn', 'minhtit2004vkc@gmail.com', NULL, '1234567899', 'Núi Dứa, Đào Mỹ , Lạng Giang, Bắc Giang, Việt Nam', 'other', 'avatars/1LvoNqBKSffJyL0Qv7kOrlo1G9RGyGoHogej3TpS.jpg', '$2y$12$pHoZdPKFF8bqCuMa0JDFVet.NZJG0n.ixU2MAIwgTUsG1f0f5J3hS', 1, 1, NULL, '2024-11-21 11:40:48', '2025-01-10 07:13:48', NULL),
(13, NULL, 'Minhcun2004vkc@gmail.com', NULL, NULL, NULL, 'other', 'avatars/KhqSJI7UBwS22Ki2SEXwZq3EPiyqFkL39UR9OeYn.jpg', '$2y$12$E7RlQ8kw2sr2nJny6S4AheYiMWKUNfrAiK8FPTnr1KlvLrf3F0lxm', 1, 1, NULL, '2024-11-25 02:00:15', '2024-12-17 06:58:51', NULL),
(20, 'Hải Nam', 'hainamkid@gmail.com', NULL, '0382677204', NULL, 'other', 'avatars/yS2yfblRRvuQfgFKFbKeEi9SDmT2JXH44x9RHFko.jpg', '$2y$12$ye0UKhJB6iHR53adspFaWeI48W6wNfvyKuvqO22u9bYu9PFrY52pW', 1, 1, NULL, '2026-01-19 22:50:12', '2026-01-22 08:25:43', NULL),
(22, 'minh ngoc', 'hainamjobb@gmail.com', '2026-01-27 13:17:05', NULL, NULL, 'female', NULL, '$2y$12$AQtWRe/kEilWPt2hIv27IOFe73f4bw6b8rVi0oo.NwnYw5Jpot4Ri', 1, 1, NULL, '2026-01-27 13:16:44', '2026-01-27 13:17:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`id`, `customer_id`, `product_id`, `created_at`, `updated_at`) VALUES
(23, 11, 3, '2025-01-09 21:15:20', '2025-01-09 21:15:20'),
(24, 11, 15, '2025-01-09 21:15:33', '2025-01-09 21:15:33'),
(25, 11, 7, '2025-01-09 21:15:35', '2025-01-09 21:15:35'),
(26, 11, 12, '2025-01-09 21:15:54', '2025-01-09 21:15:54'),
(29, 20, 19, '2026-01-22 03:32:55', '2026-01-22 03:32:55'),
(30, 20, 20, '2026-01-22 21:56:22', '2026-01-22 21:56:22');

-- --------------------------------------------------------

--
-- Table structure for table `flash_sales`
--

CREATE TABLE `flash_sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flash_sales`
--

INSERT INTO `flash_sales` (`id`, `name`, `start_time`, `end_time`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'sale 12 h', '2026-01-22 00:20:00', '2026-02-01 00:20:00', 1, '2026-01-25 10:20:08', '2026-01-26 17:19:34');

-- --------------------------------------------------------

--
-- Table structure for table `flash_sale_items`
--

CREATE TABLE `flash_sale_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `flash_sale_id` bigint(20) UNSIGNED NOT NULL,
  `product_sku_id` bigint(20) UNSIGNED NOT NULL,
  `discount_price` decimal(15,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `sold_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flash_sale_items`
--

INSERT INTO `flash_sale_items` (`id`, `flash_sale_id`, `product_sku_id`, `discount_price`, `quantity`, `sold_count`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1000.00, 5, 3, '2026-01-25 10:26:33', '2026-01-27 18:27:54'),
(2, 1, 4, 2000.00, 5, 0, '2026-01-26 15:55:04', '2026-01-26 15:55:04');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `conversationId` bigint(20) UNSIGNED NOT NULL,
  `senderId` bigint(20) UNSIGNED NOT NULL,
  `senderType` enum('admin','customer') NOT NULL,
  `content` longtext NOT NULL,
  `iv` varchar(32) NOT NULL,
  `status` enum('unread','read') NOT NULL DEFAULT 'unread',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `conversationId`, `senderId`, `senderType`, `content`, `iv`, `status`, `created_at`, `updated_at`, `type`) VALUES
(1, 1, 11, 'customer', 'f3b88667b7fe6bcf16cd4cd0642c4bf3', 'e3baa55146a9a30116f0bd85753247fe', 'read', '2024-12-04 16:07:25', NULL, 'text'),
(2, 1, 7, 'admin', 'd8bd68311dbe5c325b9fc9e6b8213425', 'd45951d2c163a6f22b6d3c7afafbc562', 'read', '2024-12-04 16:18:20', NULL, 'text'),
(3, 2, 13, 'customer', 'ec5c76d792122bfae0301a112703a945', '7bdd9f3dca622aaf44590276d8e271d5', 'read', '2024-12-04 16:23:10', NULL, 'text'),
(4, 2, 7, 'admin', '279988781c7abe0580d180e3382bceb5', '0067e380bc4796fc3ad7155228489ffb', 'read', '2024-12-04 16:24:23', NULL, 'text'),
(5, 1, 11, 'customer', 'b58cbeb08e036c0b4483899e1506ce78', 'f9d16aefa4393cb9e6983f9bc703177d', 'read', '2024-12-12 14:04:30', NULL, 'text'),
(6, 1, 7, 'admin', '6cd337e05d26fa7f8226455bcdc9dea6', '6133072a9a6f3574e19babb008fb6a40', 'read', '2024-12-12 14:08:53', NULL, 'text'),
(7, 1, 11, 'customer', 'b40a3a7b6f0f277bb01733e5ee665a26', '09d47f5f46e6809ed75d4a9ae5f2ae01', 'read', '2024-12-12 14:15:28', NULL, 'text'),
(8, 1, 11, 'customer', '3722657c17d823882b1ba54eae9f07d1', '6704693fbc5db5a3890b12de93b94cad', 'read', '2024-12-12 14:15:48', NULL, 'text'),
(9, 1, 7, 'admin', '2c0b0c8d9ae7163aa3ce86af6d6f88b2', 'b281164c402724e965f7ffc4371c2af5', 'read', '2024-12-12 14:16:12', NULL, 'text'),
(10, 1, 7, 'admin', 'a322fe72c2773e2c891bfbe0c9eb4550', '79b253ed292a61a28948ba1a29865d22', 'read', '2024-12-12 14:24:55', NULL, 'text'),
(11, 1, 11, 'customer', '042a92cad893ab2fad405655ddb05a31', 'ac3ca0cfe6343128513a04886bf8e457', 'read', '2024-12-12 14:25:32', NULL, 'text'),
(12, 1, 11, 'customer', '863f87ff43bde26415fc471ce4b20bd5', '0f38c3f759fde8c5222d648c94a18e67', 'read', '2024-12-17 03:12:37', NULL, 'text'),
(13, 1, 13, 'admin', '64298f0156ec16d8dc230c80df127c34c2b1213175621968be8a23e8d95b6a5c', 'be2d52c7186490b9f1b8939590aace63', 'read', '2024-12-17 03:13:14', NULL, 'text'),
(14, 2, 13, 'admin', '8799b39e0a196b0f7e08f67d5c6016d06ac760bcea3a27634647a1c2358356cd99494c1897b470da779b6bdaa3c434eb5243a9419963f630c5f033c1f270240043abc327f875edc0e07249690404372f', 'af16225220c489b87f1c4ff1bae0b43e', 'read', '2024-12-17 03:13:41', NULL, 'text'),
(15, 1, 11, 'customer', 'e3db16002564c7691ef8ed31786067737f67955737b35d78e8960439faa4f5f326e5ad8e92ac7eda5bfea3445d073d2c5ddab9eeba81f7ff29fbc36ab0c87eb2', '608e8728932c12f2482ad5ca2b051f33', 'read', '2024-12-17 04:16:08', NULL, 'text');
INSERT INTO `messages` (`id`, `conversationId`, `senderId`, `senderType`, `content`, `iv`, `status`, `created_at`, `updated_at`, `type`) VALUES
(16, 1, 11, 'customer', 'bfbce04d8cdca0555b4aa228e69c39d647f087de6ab75541f437d40e52bdc095c07d46bdd39438b33d6642e960fbf8624e8bd3e0ad78c634bbb029373b238e7a09b40bff218c09e8ced27c350d6d2e17668974dc8ed1b3c11c9cbbd12e3f3f465129939093127fc71953fc73ee07f4b1a9d721c4cad3848557bc7582c8ee16d3e74d99c11c93d8ff4f9013ecf4da3f043f477d19bb32546bacb2b7b3212095c18a07e98ec1712b2fde044d8dc920568ad8af34972133a3326b52b13666033061ca4329cd8f9cc2220ecba3ad5f13fa4c035f313843fab0bbef33abb2d950a50a210fb5a805ab1dc1f8eca2403308af5aaac6073540284003baa4e0b3e0b3953edccb56e1ee55290ae87e622644201fffcef4a556e340f51b26dbc412bd159b1a1f17b974a67dcbc3f654ec17a22ff0dd0bd01b2639f3944670d6512dd4606f97ca0792d002b01f44822ccefdcfd139cbd0c1c04cf5d8c0ebb69e2963b3cbf10b45a68cb73aae5a1455111c3cb1b09d59e1d67a9ea1899f0f4ec0c376b90ebf48f764aa1e26c7c7c63d1982b1bf4c20a9478e7631cc7ad1971728c8584a84cda903a3b318c2609296574c60d6a1cbe5d79d0bd4c16f45b4488187628bd25a5a1e815b587c044493a97454c39a366456e63c354b2393872558f319688509959d16915e3728888e838d3f4de8264fe456c0d03050522ce0cbabc35531ed1fccb9c6dd8293aaef17128beb7e0afc988a27d41f46a091c5a779d665fd5dea675ae8807deab6cda917015a462f35d5f0501a290c1a82b6de4693b2df57ef1bc8077cbc631353aeafcf218b7259916a19bb6e1f99a3417085168d7ea34d363662e23f5770dac1ec62032775d0441618c02e397eb8a4c817e28e0ef52a074c5f015f8e4c5ba597868a0a29fa03e31ae06bdf2aa61716df8c0331dee674619df5aaeb63504811cf4fe0f1e95a65cc345f25b3924848e3f039afc7f62203cb2948df474dfb846f98cdb5f539e07c46faad60f800ff0f971c5c2fe4b753042f753f7b607bf2b6721b18582c1378a310c3711b46ec7df8c2f59adeba02eb0672adff752704db6b2fecdc4f505f3349931c0557cfe684f4df8b9091d9bcea72bda89891b52ef899416293eb6844111135cdff6d4ac9f91e9065f789dc21540576e475010c0fd2171e514e8b0a05c45aa37227009b160da3679849457334713ecf76c569aea20b5a3c66d557982f3737e349e295d7f343b47a51206eda3d98a2d9d82ed4d2d1dccfc0ee3814533e9424c246b706b3371efd3bfaa32c24b5f9933beffb15f42c3491622f3148a6e934577ba134fb8de013afae1b161544945978e40daef64790dddc6222f6fb3b6234b547c37c56f72dd3f401ea69d35bc6c0815b4b3cb6a1b654f9bb5db62a70ddeb12c31dd082b19affc88f7175b45d95553f12c81d9a334dadbe6a119ad48a66dd60aaf77823de723d89ca95eb82298ce978bc53cb1180aa2f75069595a2991d16f924ea59c586b24bee3eb0c68c956465feca37ccec90254654325081fc8d6a45dfabb025c300a8cb3d2754d881c20d040ad8e1a8f845bbbfdefbe325008e4c25187f6e1f3b03765351a89f60833c8b1e2117692fd02046008ec2277bf1d174e476d79be6a54249567d20ee1a92e2ee6de042551f203a3340571eab9c93ad9a3a5ebfc17329c77d4d054b726e3cc034d9fced779cf292ec5deaf5537e5fd6e7f7c17bd60f4acf937dee4ab9dd0babc062db68bb3667e53ec343f0985eac84c72aa0d5ee9c08e736bc5451861a4bdae417acc9d98d0753ea445ed545e783927e3ff170d58b2f2ff2d585c7ff23acfff76a82e20a6ff94c16864ba3386d20b0c3b2854a643e527e5b23c780a105d973bffea7259f8c3cd52ff96c77d675117a3cfe4f5629121cbf3a7f3228fd128911bd6d0e918f19f808faf8a05136bef7e3ea88c7c2d54e972a2851d63e77407e008bb57839cabd8340b247f5690bf36cfc6da934fe23a9f3f208e622e8c14a7d25d38abd481dc8a5f0c1bbeddbea2d059efd8bef531c1ef0dc540861c99aa5a5bc7e90acfe3d9d1c54ae5cbaf35332171ef5e3e0470e8e511c61d7a637eb93e7c1d65fe98bda5c9767cd8b4b6abcbae20217c9236411be41dbe7274438b79d46defb502bd2e2aa873906e102bbcfee9729089e7cba38429ae588aefed91fab828d429d27cf9acf7c2bbbe1f4e1d406745e97f09ee15ea7d136572da738663d5e43b254df7f3cf060ae02de5524e3d6d5e55e99df6f31cbfe3ae123f680ec42509b5f0fe5b989c2415c990a21a648403f5bb84984506aa13d7b01c466d6600007e1a7e69577638f13241f18bc1591ea34fd9c73b2678c4dbc55b2a9de09cad6603bef2914c4e178c259a600468d91faa83a1feb2aed03cc10326f381d59b2767a55070a170420db0ea13125140fe0ca06615393fc883fd426fced26edf52dff6468baede0c9b07989c0d46380a6ac9af1098cc2c249222ca59653d3c136217f3608bf927be650f452d2e2a53ac181148e70027342915290f0d8422d521a10efe051f643e1225258768cad6e313dd0700ea772917b17566fdb21ebc065c34475001d9558043f3a8cb61bb962140b1a4210f3d493d57979701258803a887c20d55f360691ed707e328336bcd3e0c30ac5298d06842c7396f0c2a9c1fe5c38cc678cfa7f8f56371c76605876eee0efac970f0de5cf50219998f95c012ca4185ee82a1658b00551c945c99e7b8d78cb0d5b56f6a1ada0fd403f71cb4e90165706f222e1d1ee624f5fa652b85e153a7109f6bc744fb2cd2a2ec94ac393ea6fd513c7461477b89ca828e931f74d0b9d0ef77ca1f7561b8a31471b7fff3d41f60204dfabcbc44f844b5593db6fce5b519955ad527b8288d0af1f8c46bfcd65319c1fdd02eea1a1ecd832b723728f06051656ec84c21007b00fa43aef57771b6271ced2a8634598b4f2ea3ed4d4c50bd3bbdfe4fd5f15cd0e1d8396c30ed854ba4e5d63b0c1046998bf577b63c2e2df529b5ffaba09209cfc34eb9d1df4aa1eb51b017354f60befa295a8d1c8eac9a482bd4e719e9c2f6545c455352dd48eb1b6b4567c4df8a852963fcc62dc7b39764447d51e5809fd50160ad9439a4224d4841998163fc06230fc51822d84c6b4ed7337b7caa97ec713deac8564efffa3924c76ca7eac8b38d3012e80956389053a65c083931df0722a10ed599f6e98e285ec6b54120cd167d0ce3b08659448d00a554068dbb5a10e2c0fa0bab0865367ce096525842f1200f277a5fdfa4338555171a1fe0541af99a06c8efb9237a5513773c3c27f23e4941af70d2139e0c18afa90fa02ba49b221055c8d830558a3d2a2d49bb7ce4cfb090d51aab98d2be7a3459ef489c0a03fff12d3a06e53567e946d6c79da0828eef60e0fd99bfd7e7cb5654b42e41a1c97bb6d18e1bd4e8ef68671eb15079cc7e654f0c6d6baa095316a82d7636ed7f444573fdf80a0428df0dd1e57cbde4152265db1256be223b40678c7f36deb81da07180d678ba1adb249a25e9445276dfbebd32f5f479fc6118e62addd8e22147cfab3c7b7eeb0fd393051ebb3046c75807d31e1fed16d330b96715c142d1f1bbf3fead32d24966d51cd9e514130f656f0bd30783571da753a7ef24d81be674df941a217dd6a5fc49018c57fab4141b430646a5c37a4995d64450a711fe8eca37a3b1daf99d38d4752190a2cb175612d7fac30c17473d37e3d13c1f0dbbf03d209fc673a34f6fb299d69b287c9670d5f30e8a05221fa0da06f0d48cab995c08a1171bdaa706826c88e1b42cd2a31930246ab826b0ac869bcac8398afcfc95298fa1b2cfdecb5c6542bf5899b2b02623ef599b86275719c52c5f242e2dec088d28e2bb4aaca1ad9f451313d8383d9ec2cb092fb88d2afb8daa8113550700a5ecd2d781ebfc74b64705544873f89e5d255cee4be8ddaffb90ae3b0f3ef1c06970deadba333aa0dc2401f5fe0d3a7a92732a31ace082d8455cc67c7e92d8bf9f0257c9d5f82396d6ac0205b17d07e4246b6b9d0a3a119a81aec5ccd46ba6737096a1c456100199cbd4de19bc29bcdb63b665491574e1387794fe18562cad187b7b96e5867d35c1ad4e9586ada88c63d45190f215c2296bdb7ae2cbabcb076cc68b92c3fca2e01526cc728ae67ae1c899c60e32458df2ef49ef5085dfc603abf59a6193588519be27e8fe143308a078d7c0ca6e6fdb95925603841f099a6f9506b2ed335b0d6f140ef1e9af1b48e89f089ab89c262bc72ed071a682bbac3c6108869dbea6c7a54d867391295515499574731ce45510eaca2d46434775ee13aa3912a092b8f14380f0db3625ed2929c9f63fceecf7942f43f9d309437af91328febafdad409e0aecb43ecff9e44ed4c42538de3993364b21f1fda136d8c7f68e796e2ef72097d5b456cc557a8ee2f3550d5ad3fc29aa939987eba473d435cf84e780f075e9ae473df1dfd36c992c07a492aaa38ee61bda0f351221c0c91e5ca12caa31d7ef2d294636b971ea65ad8d0b07a344c0533ea99a87b97e242fb7cbb588b16796eeeba93be6c5e2bc0f43ef7855561835d3137ccf60e140fe78bb88a41b1c8cb2e261aac61683b32cb566433fe09d1bdec6dc90ae219e0add1ac67ba19469a9bf2ae130b9b45c7e3db50b49d0e51e59468ae510e6d2263182b887d9faa343ff6a3bac33cdec2b9da86ef158fa7aca197434164c03607625c48642b876eeec752ba326d42ce00d1bce821c33cbd8892f38fb963778d85717e173648e00abe65cd381e7a0a48833e6e6d12e153f3a53d0a21d43a7d8f1ce4e75799c3eb80f29da1b1cd9486496794dd30ae382b755b3064249b65110d01955c6834b2933f8f4b8159a9b2e4285ed5d6d0d4aacf05f0997b176d1b8752621bd9c8fc322651d0e99a1e4aa034438f2574ae425f9d320ce15a41e67133268ef917fa3a839b62db4cd08b816916af81eca66aa93a65af2da74aed25c9b95fccfad5430b05fe07bf4061c614aeb5d5b7b593353861ad02fb204b76557fbf2c67327ff92da04e1e78aa74d888c39e247262f79befe14090e0232e1c372390e9e649892ee871ee170eebe140e67685351c342b2fb3457e891713e83d98b80198724b87780ec0b59c02ad0e4e520dcce2674efd5c2c317e38457da0be20577c9c912a87e3f6af392a87861aebeb1e01260f92347498a3e80e063ae6e6d3892df11dffd1077f1d77b3d573e73e7b04403ab75a6da0d12c01fdb0583faac5bbeb24555c5f5e64275123cdd9478ac91c1d88b221f2dad3bdc4826ccbfb3708072788c6b075a7f0bfafa73340f3a9ff1958289e75feab04fa5effd430f52e28ad9611c3b4cfb5184247804d401774cd08ba66bb33aa079544d5df7660a6dd1d6a438df51d846244c3c5cac852c6161d5f259566899c7194963065e9a83f9f20de8f17bf2c488b8236ad3c2d4c2dabf8fa69245344cba20b86883b51e7d0d9afea564772a783f5ae14c234aac927f15c44b1b7c46595a170f8b15ff0f12fc54f5a088462c7fd283031e00815dba8075fdd8248324e2278b4a5297c477975fefca5d65501141efd39496f30df45123f7a2dfe089e9c7ed5b1b15c75195129d85f504a5eb1651ddf45b0ce209680909f407ca6d1d5bca965650dc1ad479fbb6a848feeb16252d06f8681ac08c0de53eeac8aa8ed49058cb583ebf78a28a38077533e44b0b4ec6729c4d74c2da3e3820258b23cfff87ba77dff7b5fe9dd3232b3677dbcc86f5aa4014f6a4b0561a6294b57949690d3755b6d4bfc35d84055187300a68c5bac66db5c26a512394472991ec8f4be3e626f61c2174f9c83072d799631cc54a10fc64c0cb60ac31e8dd26a5dd33dae6ade75227b81ae2c746e70dc232d061eac09ba09d1f76b996679f6247105e99e66c8bf8aa8e800f336ac1604679bdb138c91ae2543e6c0f0244a8b96ba18fa759d54df02a0ccdcc14f1d8966a777c4ebe3ecb4152a10384d9b23992aa8989a5e371db04547b51e2e0e35dc79a551c88a9055d58316a51a9317150db735d060d0f52830d7a169a9cd6e2b607717e9bc4248809d41928e6555b89156bc98a8c598ad05ee6b33fc2f688fb16ef07e18bea97e73636338e614a09cc3b0e530634cd62fabfaabadaaa6fd59c278804c55151cdcb6366c14a439b7b6fee2f396e4c02417bb4a72b4a8c4054dc344138cf6fadc9573869fc9e00bdba36e4a7c091966e5a9adfbe823fe316718c9bf54fd79324220b711bd25c96d71d72b41453a2add282e7f54ba50aacd1c45e56f011b0b47ff4f9aa2ecf332a7ba21a7ca3216b5f5542fcc08f8d5d69dc5908102d1e72f9a1e3f5c6680788a27e19248ee6359d18049db938b0b967e2d77a8cdd01ba3a0f736f7352437b2c2fa2fa390d03a5865f3c9b488efe6d5e3abd2f618cc88e7d85d97d2f5354c99162372521c799db2e15121236055cfa532dba496d2f77894aae61aa1e91cdd9d16d5225908fd8d8d947cc1ed04afe2ff5efa407c646a20b68f01a985b61ba1d82b714af6ac7a070ff6bd0dd72cd4f966ae46c3731bd8d9598be60cc2c032c623d8e9805a6256340ba590f88ef4e4543de4cf6abd1c8141431a4c7accea184dcc15b5f57fc858c78be2bc2dbd3b6e67babff7cbc6a5e37ee30313d24b6061d806a4674f9ebe2dcf19d9cca6b7453b89ee6257c7fc5f9531f67443d39667e51ba7dc410a7b9909bec7342b4ad36511a69d9679c96fea5f27e96070f3b3547bc0a4cf3782a1e3c374a292f6e673ec4c7f9e355570f30d5e70af089ff3ffafd3f4caffacf97a17008be5ba2caee4c9cdb7bd25f79a7b9da869c20182b9481b1cbd82ecbc61447795305b060a017ae18f3cd06fa4783ca58c158085accd9b5988e24ddb751350f2c5ca179dfa79140540f082b681d65ed2881db529e6a697595f4770475b9fc39e38d460d1e87b37568b9ca117ae695a2842926f456815df43067825643213dccfbd798867f8fd214d074ced6f18f0ff2b880d5004c9f1a7badef8b2379fd70b1a311b6cc31aebb52626b9609022f851513acb0da5da44609dd10f456a5093ec88ddd195fa20fe7d05fe741eadaccf6486a48ec4ec17e4c9d2a64b11643e1987b7bfde4d0d8f7a4b9bf45fd06879be90f2412fdc7553d8a51e6fc348e7ff4246c74eb06b0d5ab7cb223f9e675280a4745b57c074be8db125ee69c7af011407ecd0b712cdec35d7a4102f07263ed5f5a26867bc31ff2158eb5a46e89e9159cc3f4a7343d0a2c12667733c319c66ec35dbca62b26a3268a9ba91a45b4b03380d6cd62c0af4087de3390485e93b6138a977062e4b593e9369370528baf2d66c03b3fe38692c1c18b66e8ff670378115eb880061063a139109f95c54598c500e486427f4a1b98c093eb469b173485ef5308bb60552c880b37d952427433b1df713c10176259085b6cc1773c6b3568f8f0d52633eda94ce32ab8e5451875ab16a7b29ff17561659840eef2f9c656d50afc2b28d6828327d88051efa0f829129e2d72e152624d11f6988621465b612dfa7e204c03e404787f5fbf4a7bc7b0e4f60afb008a46834dbfd81d979bcf0fb4f46156342d1106196e688b76c2c92679e7d9f171af5420f9285242f3d6319d82b2c54fa9f0583eaa509c9309d48f8e023decaee062b7237f4cd50bf52262eab38410fcbc3d5a15cb664943795817c5dfbc0794db179a7735ee48001274484be9a356aa916709d7f228e5c786b68cefad40808c88ebca727ef88cc0f2e1b5e74a4a500c18aecb3cd424be39a5fc1c9976af4c45d3023ef2fefba574710b70477535f17145430be902f43ca7d556ec6cde81ec1e113714cefb21f6f83e6068a279043daafae5f63bf7396d789d961a4198e29eb4889c14ce126b2d75a42fcd47d4fd7777855a933414e98167467a7d3d4ae631d507b78a42d6e08976ba39b8215db082636b8dece4d594d42053ea2d0b935c02389d36617811c03f2bb6175e47ce3cd854f0831a4a60db947b5775396910121933c3a9f1889bdf69fffb97c1e1ed270d24832e9d14ecf7a04cd61a5c268a7fd5f5f2934b02bb15b35aa9b3045a1d246557d5bcb2822ed3598ce3413eafa8d8a988e19334ed2a5b4f72c9fbe29bbcd0095da9b9b772248e0680ea3c8c614ebdca9421d810ff9447386a92518cb6f70eb25ff51d4908b60afd078936592732334d5a460e547b167982173855c445fa5de81e5d9cc4bc62b0e7e5d26bac2e62ca96098b66d251a4fadacb295cf5d75ad14e21688048fa9fdc489b97fb951908a200f04216b3ccf3e7b7b906b40df3228edf0a8e1071c96bc331ab3dcec2a00958896f807567caa62aa8bc9f72f7ce0befba2772ff2bfad41f605efafa5c3bc9e93542fa051d2ff65efe0a5683b83d54b2cd3c22ba8de716b8d3d67c1479f8ba42709b3a7deab91bc14b2e748ed8b8f054de2c681beff2d9fb14dca2d8905608dba4fee530fb6ceb2d96f0cccc7c1d805bae47a3bf51df8d0ce3fa5d42df1c77b9c8e5f0d7a75356a0d70a48a2a65f133a2d6a229aa32b4da48f6a511a1dbf2c8b4a545ea5345013df28dcb36343e26f7fa23604093c52b536dde275abe43c2c568ade4fcaaa7bc150f5be44cae35f97cb1639da0b7baa088ac2f4fc2e48f0e28ff4d407fcc08a3344034c2c952f1b6b29fd76954033fdfccea6ed6bbbdadf2a55f073f4923719c240000ec907e40e6b26788b660b17df6fa9c6a2bd41e1bcf6984bfefbb6ee0d07e4ec0e35a09c0d2bc9332e24ee6f7422f367ac3a14fabe0efc84a8de158650118e4e7fdb5bd27e3af109c9e7f2053aca8215f564814b53c7579c1b6bcfbdbaf2074977debd234dfb050b911f857adcf5bfa65949e0ec6d4ac951accdc96f0fd9eea9363f892220947a046b2e1bd13eea72d59d9c7e5ec63480ec4158f555e2d28d60a00ec28d7adfef2b1ccffb5eb091b38ccdd393a075a163e2acaea2d6554d4322833625228d3c332e306812ee1a4db05baff55bcc8b2ae87837e4bdfbd822e980b25d5e75cb157c3750628ade22a3c8c4f030d028127af29225cadab572b7065d3ac5c164f369dadfd8fe4403b6ae2f9474ffe7ad660def4a1c44d49b03a20a380baf91df7f7766c2fe6cae9132989cc67d087d29db6341b408f6232bf083376e144d0adb874e8b15eff42a9198b3e3fd24d27167c132327180209949df161f290b60075416cfb403e5969c2b5091f8b13d4373f16aa769acf4496ec449cea1524fd62abb17cee50711e1da5544d41818e342b3cab9f88408ef818fd40427f1f7c727d7f6156c02965730dcac596207f7c92fc418e4c371a346b3f358f88caec37f8bfaa94af35996ce352a6f02a5688ac760c19de2efa1f10c57b9e6f3abe0db5f739f3bcd350059e88a91404b2048619e0656d7075efd5020bc074d40e8354df6242b7d7240aab36b596786ec07ad1c2233d9f224fa3bdb90bab4b8eedfea6cc5207778389081a4827c8e07a56f0cfdc457f4fe617f543e59d7e94e6355c0ad59d300ae215f59ac69dfe26525763abe5c434da7cfa7e3aa562bc87bdc6fb9cfea9055a38cbfc9aec18705d91d54374769dab3cdf0061ef63dfdc9e99c2a51585f655386b78fc9941a0c6f8543681434dbd92c8999498a8a1caee740365790821895cc59ab2125594785071516ab49994f9686d4d0eed6bfa19921b93aaa6902d9d80e51c14292dfa8099238723366d51a3b3edd93bd78b7a216b1b9d4bee97ad49c12189d99b5649e8baefc38e39e64501ceb23314cfaaf0cb5172b8179c36574113d646c34ae22a1e43891e182aa2be49a6f7d7ce0bfc4227d2f0f4f1f985c915c4e32404f59e3483a2212e3a307153b74ae5609493cb8d90bc05d1525a1e8c1c23b2e554740d5651c2dbb0d271bb1442d7e45d49e1a553495d913b9c591f25f566e1ad50ec205bf12818910ea879058b9867c0d5015de91505cc89f8ccd0ffc92e789705c69ecb42a19b759ad142d555b98655fa6446c35a32aa3e002f61e215f8355f1963b67ba87d1aa69cc6e7a57c9df0ecf517b2859f3690cfa6892eca18b057b21841017022435a9b7642a19ca49152405bc7312c1dffab18b8f6ce4dd36830fd5b772c06c113bd8107fd8d4df8bbb26b7af35c4501a3c7cefe2b5a7ff143ed9fe2b75ce1fbfc643dd516a828c9653f2abf131005f3c3513657842dd7b1e47776124efc5c4c309bf9906ef1b8aa8687ddccf684c68facca9e14d00d82286043cc119eb55a3a4061749a627aa38b1148d7f15094bbd75bebd33f9c56f0108bdfe6c401ef00e7a6c0e62ce1604997cc51f8bfb69b57f2e772acd38f9c62f4e36b9451868f4835c28ca57f6f008aaa46ca94d1b5d1e50ca8cffd0a0e62945d730d577f5702f648889fb2b95d4ed7c5eb43651238aa24be6e172b9363eca1bff86a528bffcc054be3f866af18973cf06a0cb8d256a5174c09f0c4ef3e1c52318d941c3fd599e5b88719512a956306322331737235625b8ce8f9cdd4d9301942441b45bd15ebd469098153dad9820c0a8040d57ce8b0f867332bee5a69f57f8d2dd116182141741c1ce3396a194dbd7a0d29a84ca54031a0d77e4619cb597ce9913630336c158be23d4c1b2772d7e77bb18f5b9aa055f5159272f57b95f892be1657dbfbc4082a4c334bda9c5b35a7e28438d0588d84f24c09bead06f71a569dc1ed6b9cbaaaf6a4fd5796ae0bc06b4bc101429362fb51a7fd755bd52f34ae3b793012eca36bd5771735656b59556dd52c5960eac54fdca8e8ff4f5d582a68216daf8e1f3bee4982339148aa06070ec438349e4e4b3395f6074005b9217bb4176005ebb6b7c6ba2ec675947679bdf180087724aabeafe60a7558ce34b392b1ff006c9b24ea1ab21380fd042e1f92f167eace99705b4cdb1c23657f523d67ada8bd20372df7b34ad923b39161f4f069aafa946ce4809fa513519821ba23c006bf68247a01f498b865c00d0f1b2ed228c1e98a3685a6c57e693d572df97a2bb72e943e905d5874b9f2c846396bf7550e948104576b86ba0ea64b71bbc2e0e3be644e6d4ee66a3df4bd3c7204a5f3ad8fc334888db1ae1a2a82f2cc99bb22ca5cda0e4fe72bf4803553d3ec2a28349b593066aa0d615f7e0b6024d6be0ae55882c3c6dd2db25343ef40fd39910993d95690706312ab8a8b255193226aa8749d32cb79caac8e42860f2b12d76ef123e882a0c58c278c694d9f4c4b58ee1ebf53946936e72597140c4be9c3bdde10478ecf1f8db2d19b3cb6c341283ce22b205a2fa5a18260fd8bf31793e16ee225a898d32b3c23de130e09a378fdd163ebbc66fa1554d2c99e511bc7d3476515441283a8dd33bce30fd39387b28c4776f3139bbfd9d1f41d2f68df9a0492aec6ed757c61414c540ea176d21e8a3657be3930a3843004f4de5cbecc3f1e9292cb492b3d2233df922119738ddd1125637c7f4f7f8b79a236981243fb6c59bcd9b1066a1c977362e4c50c19b3a6b76e6a75676a0ed64475f8eb4a51d08d95eb1acc8545c62d2323fa0d87e03601878e7b3a01c3ced64d1570e859da38a103f282962c9fcc30560fc70154fb884d173b8db86412326e20506cadc0abad984e71ec42ff75d56636ed9d27152264697f79ba7060af5cd345d2508613b5d80008f438f8b31214a7409a594b32b63d891b680ce1524171e76fcb55ae82ab2eeaef0676247b371be527a019ddbfb7817a78230e6f9c3a3205a1eff9291dac31e3a77eb992233c0a537ee315f8c2f10901c865dfcdd5f16bd4315549b8a406a86f09a11ec6fa16d032713a0e3c7353564028a09e2c7357ffc4679b65b906f8da78dae842fb7591d96b35253f03ef51c248fa125b2991e72dff38fae40b7aa6b8c87e0a956390b937c3d030d27b286c94e0f0165b9d532160d15cef345e9053fceb71dbb5a5aa15e12879e603fd2ca19b31500421886c72baa4dfc8a8db6935eb31c8c3332eb71d96ccea204c632233b85759029bd6fed886c31ff7a514b08a8217111e7845ff2ad685f15a02818a7d0a8c955ab1ba967de11c70988e6efc26f78c1080d9e2db0618923e80f9a55ebfd0b5731ef0154a29a396f28e482cbb5ac890464a54a2e39123941a8632faf6b192d2f4a57c6dd5148ee9576396bb661dda628cf6981311166a178f96431171e64ee6bc7d6c5c3cd30c5e42669e252b6052a4143f7b2c20c271dcad3520725003f069f089e94f67714eead38d9961a9ab93a765834650e9c8986e95ad15e9894ccc7bcedb3cfb0855040fae5ad7b5eec3365655725de68414fe9ece9e92467d6983d90b0ecb38201aaca4e305fad47933b5219a529499c3cc04b4f3e35041b7e96a038f2facd1576b212e7076e4fcabcea52d2c32faa02a72dbba4d6aadea08d4399c53b862c2cbcaac0eb85a9fae8fd615fb261a37063961840a581ebdb06d87c4faa60941302d251e89d4c8eec2bfd9327dd2ec9ee289c5eb08969e0b2ceac531247a829422751b9800a3f887b527d81f0bb64c1a4af9fad5af7f1a5ad8f6e16f3fc97c534d18390b1e0c256033e968ecbfc5aac224a8f5e54396071601edb4e36343de4c1ec615231cdf3517f2ab4e131b97a61e82c8b363e016437699a512ba7cbb0c7ef1746e26aae791165c086e5793d78d623cb8adae8dde8be03d32b0e2cae6e2b7d44c5702c5dcce3bd5c6417cf1e22c27d880581197148aa82ddbcc8068a3ec39dc77703c4a60407e10c042afae40302f4261e1fb8d22ce2fe346f8cc58d80b14e1f16a4d924b91127f68ab775e2a964db9d7783e31de8cabe8b103dd777cd0629b6cecd6392d681f5ca4af2ee091e71079ccb22e260d78c79dc2455ccf7105512fd42b2a86ddd0f8a22ab94bbfaa4a8984a5d837493ceb67644dcd52e28d66012b896ba0ab49c80997aed048bf73048874a2f634fcdbf583e77d3bf0e00134c3e5ce4488bd3dead1f6ccbea3afddc5a4ea410a2b96633c72d752e67c32bc2391f621325f227c0e9b80844b9fac1e1f17bf227264f3830c78aacc2c0213cdd599c6f03bf8ccc8a896f6a500264357e886eab025b658cde4aa848efe5940e7937f2386a369c8b7afb2c47c5f451e191477e04ae5a1c9b663fe1719f436d838d414b8da45d43cb71647e6cfcbe4afdc4b14c30fc0ab3aaa536b621ab7dc2e154dd2b638762c5cad37b5c9a28f4b8acdc6fa91130ae0d5ab41b111312277cecb970ee74d0dad42d64c8bf5b1ffc160fa1f91ec06ec471e9600e93f7c9747357702c8ba3ac29600a14879290e36d791d199d39add7b82dfd1b52536384d9e80666faebf68d1fce2cb21ce3f8dc65db0dbd37954105fb7adbd7a4b40c1191c05ff09b9874fedca493bc05d127c22e81d770c2e1e844e83ecd2512a059e760f100e06d60e6d2562325fe9ea1bf7de185bc2fd9e73006c6edcdbab2359158a4644f408c7b157781f75e8bdf0aa074faf04259096dc725b33bcd95b65e699cdeafc43ce1d3ddb9325a3a47886d0e90b01d5b1c691f3d96e0b4f00de85309f7d01320044e6ad4d354b4a8135c962b1b7076157d7a871f0270d97cf0f201d15a06fc94dc7038a27c18305a93167259888aebc5a082783a2c7d9c0668ac9d82e66f7de38a292adc30a888d05786a99e6881eb7de8c0f84144b747e389b63c1d63e802a7e1d1db821077983340ab980f645ac6046451de360c351e75c823dfd11d0b33e406024f096acfedccff977d32dac0e439cdd995d7441c9d1bcddc7a73b15db3a6ba42029c60590070dd06cf0d307dc7dcfcce403ba081af2daac3a235f0c3a04cad8cdd8aa3b05d42091c2ae93929d726b91837f18751e363a160879fbf46fe3052bd0017903fc013fca573d79298e5e7a14b0d9c56a114f915a33562f33056426526c32a218ee353a941231e1a1b2664e78bf908637217e5b35796ad068a2272555b8ef67971c71e6da50e31a523e76b8fa5eeb86d97f414163869dbd4d4ffcaaa4ad9467933b421275ee7e09d036414a686869d986a9d40a0e0e65f69594d99b00e40b3dee5bc7de86c65b4619501f522950f83e0b19dabc0e33b187a4666bfc515928f365e93857b973e0836c4c6b39ef80da6981a34e2565f82e182407214b40e803250e43d636a2da6ff2e8c359afdb775976fc27b1781e816b541a0fb5ee4c817e0155b8c3a51a074a1ededc3f9d86d11f5781e05f1774a07f570eb4d2e9c26a2a1d8a2189d382ba6f2297e10a6ad211d4b6f381b85edb4f53c491809b00dbf754ddc2b864fc74c73c54cec0f2a17537726c77b24e90e004ef4ed118d209c4527ae5011e52c7e5de4d5e9c85f2c207db4fcb8ae14397201b352cc349396c393bc726814453a274a8f7bbf6f2f70599dda9ae7f18025e60efc15fb4aabe6786886dbc74758a137d0bb2fb8e40187bc46b9206eda59ade477c07322c56a6fc626808997df0be5ee5de490be22579699edd74781f16e6fc1977ee247bd8537f89c8a77db6d1e99115e3b1d914e2b2e371153bfc7cb2e4dbfca34ad149eaec804322d98a258e7828c7573ffdac1b197da90610a7fbde829c8c7249831920f314086d6d984003689c4291dcb355134b7066dc099d3e225138832b423650190973157641d79f1e88dcdc8421e35838e60cf3758c74980952e612aa51bbc599892d8f73dc9e32854bb6f738bc58afeb347b1664b0dcdaa1a9a13c9618b2928e5ade3d699737267e191dc71ac682eeb6c6de537a3c1575bab80f291742b648626aa60eeff26f7c15cae6f3e15ee886da61eca6de2968ddebcfe8620d4c10c781c64863945a81adee06a383b60fbca4ddcffc1bc8484b91ef8086ee5d96fc94b0f6846dfe34cacc2e52c7c6eb88a01cef00d62b38c28be22c3d73030a7fc338a74a21875890b91a4bccd31a4d33ba16965d30753533a03e7fafb2f3c4aa5af6512b831c6327686c9e6cfeafecf26ce04b11a6febd3bb451e1bf8d74ab65402309026c7e89b28a5e8863b4634fb698e56519820b45c932d7a03d57d3f739e9cead0a75783ac52fa37d5da4066d79a847bb0bd062ad6b1d2aa63f3f580c0795d7bafbf6a7f1c497cb9efdf038659f8600f2ad919d38e573e8fbfd6027d489a2e8294a762c4d91aeebc0d3083b5dccce2ab615577c9a72623665162895dd6cddd3f8271c717da30b69cbc762691f135bbd5aca2ed3631689313717a9ac69af97f45bce22283116f44b5da6165443ea6a457427cec8541ea19f50dfb3c6cd52f180fad57932c53909ae831f441e3eceb912d24a506098568d3b5342b998602181f507b91ddf19d2acbe8a51a054012f64a3223a92a1b45c1a340727531766b9f39928207f3ef59e3827e0705c2fd9bf845977990be154514a37ca41c5de49b184ada06fc5dea98c02e5c845ea2e83248cd2ab6abe9ed51669b79e711b0dfba834da7922deebc070cddb19c4957bde8ba9b3c80e3ee905ad14d3f675fd1e92145fd332d95f01afe75011d06d46f108c300c30b12cc1b0676623bb5b93507a7ecade4faa209272b6020db1f72f6906ff9a3b299484dc323b9f88a89e5a47a608a2590f3c374d78f384e52752aa9bbe06d7653d3d6cf0b91a50b389ef14a3f0ee6390152e0338bd05211f3e6fcdd382a4d37dddf70674db2635c8fc3f861132c277ebe41c0fb87ba49c9fabde0684b88ddd7033b447bcec85f434cd87da59c6f143e69d8d42a0ee082ccfc93e2b5bc95645658e28db9d35d13e23ddca36aa2159cc08903e76f39302e35a1592efbd91ee271abbded94d624ec6741a805f649a0ce8ce0daa1950cb27ff5ba1ecf793e5fbfa1cefe71f04cddde202a44749a31f5f63f77fe99719052517edefd800d6fecca67a12747ce04b5b42323d476c525752e286c7dce1d45907f0ac89b421d25df0a341dc339af25d55e247b13ef3104ba214f0fe4c9835b4c2bd03728b53ba31729b8f4da66a951289aa58cf060ecd8b70ad299a1a7a82f87c7bd756a9162520d53d1abb700225a46f56976bd4d252a02833019bf91ad6474ab0d0e7b9afc075c60ccce0c1211e18ba69d468cc4a26dc9ec3a530396a9d1892d9c7160da6d398aa27c48760a87fe86249754e2af82bc76e2fff0417d9dcac0122a8e3496f87c1545140b94e47f283141eeddbf3cbbff6163b07d45f495992c15314f281189304b76426c05f6eba081fdd153610868b4f444aa703befe63671d60c14ae63fe8a599261ee7f7369ad9ffda733f5ee7262d713ff110fd425688d3b898392a9ec5e3257a96dcdf44993c9b0881781cda95326b1682b16cef9feec3c183c859e602f3cca5ea72c743b73bfb1a5baa7df1acb355c0247e1995188d372726e393478faecab61230e34cc7217889069ab09dba3e868e593999fd044f5b9fabf1ba1409e93b20126e7375f8c97a74521e92e90c3fa3f39342e9603bb836a2b0dc4c9db9253c53b10054cb575c6af58ae9b4482d8b9919384ff43185798179a9b26a3914b13bd5896ab9fbde2d2d31e5dbfb1fbc9d8af17e343186da03970310f8091f8bbf7c9f31e10e61965b8c52acd7e45d14b2ae3ca50cf0b0a3c377c45447a3912ba68f44483e0f442563e369efe3ed0857878b90f34965baf62391baaf2ef98da68f6834394c90f0f2eb58852afe6ac880eea16f416300be48b48495c7e1091cdeed01b8655f616bf532554d97cdbfe92f2c4dae6f407a9fb6dbe42b03e4be17928af02f316b8d5c11bbf4cb61a97b711a6799878d5d2ba4644095dd0dd1565972f9cffe0c990909a2982c844d310edc56a2328c96d2687703ed8a4d1f71cae98773211b28c344ddd52eb37bf57a3c721be607ccfb43e63bd4e3893e22132a278eba87c1ecc63538f1b118d9c2634a5e120876ce6d9f1ef163c85f19e54cfe79e325a5378293522126ce7c0aff3231697cf4090964f132d66e041c2ef944feb9b51768ea38912e6c72700b67d7b14f1d10ce2088980ef822967e2e98524c085d0b131c542f9cd9a234f089bff36bab9c1d9bfa79b63c6e1d24548b3e01772018378ea565be3bdf817f53e6742f0ff3b6b627da908d74affec0f4f3e4e7d8e3ed89969392be239653b25afb456590683da8f515cdcba55e1da787cb3474f14702015be2a2858ab883fea035e7d7c05ff9cf1a46abf7b4c3f902bebf7f0b62e615d636943b116212673d6e5ddfa8c61fac78cdda449174d331436c0eae824139bc1be61144bc5aa9832ad27251a4430de3cdb2c5b8dd22cab1f57d64806a0209bbabaf6e8fb367cc70fcb537e97e44b7c8e380279410e9d6c741ea001be7632675db7300632f01c6833a5aa0c980c94de466a4457e3cefa2cd97320bfa032a03c538d80b10d52219b78f6b9960640d1cfd98f9daf801817edbdf32baa9fa6dbb533cf0ccd128c9956b17d80bdf07b432e66f47570dcad7c827c9f95967c034e69d4dbf525e720f85c07d62c04fb271d75c6e87a65ce60974a5d19df99e7ed86191907a4d1d2785dcc26354ee3ebb67a7b060ef0495e857614e1441617519715c00f48a017b716983e86654be8d970e23f3dedf3c0c797f6df777c5cb75925c744aa3eeed0c88570d23d3777dbf36aa74f26f70e654748b356c115ca7c9f7ee7ca01d0cc9ebb66b1a566c37576091c125d90c702c20c366695a9c843965a722d4598e39a26822e5cc656ef871f57a99e5386de597e8ccad4b141b5b82a2429c095ea58b680e21d6972491724e961de21420c706bfa92f723076ac275f84ac06cd90aa6c32570aaa7deba4efdbf9456490ce2b4f56e7f8d1749ed7274e7d6fcc6255e1e132498b2a574ffc11be71e7a885f37ddba1bcf652b05c3bd1d8acb560cb3baadd3f35cd2e689d51371112b9a563c4fd3928390165279eeb2a6d8a5022b7a68c329f7f84f0af1c0b49641778eb02dde8cd4b47ed416e42b351bb260a9e15624f0a35291da2aeaeae3646fc5b177780c5df2b0d4a8fc9c45d59c1374202b8a6133be0da08866002bb7c1fd39b50234054b18c594baa8d093ce8b805481815c86fe0bc38ea6928ca32d06f6910148992d6ef3ba28521c4f9bafb995d91c96c019840a7f43153c0e9f114d5e54d85bbaa24390f2ff8b7cd3fcbadae01e8f974a882e052b00b4d88fbcfb1c4024e61426517329b8204ab156e57bfbb0004d083d074cd8c591a01eaf8384fd003da5470cfb7a2c56b09a5aca343c9edeb1ae0309a36d7ca088a17b0df41826370c427068f453f10582fcad33bacdef46a6fc8c4186d6c279b417c0f1fabaffa4bc9def6fd6962ebf234b8bf23d75020b0cd42cfaee96d82c6be520a8e9d6a03e338dacb8aa2b56fa83b86c7d1f5372fe875f1001b932b91ee9b8502fbb36a9b9a8ed734aef2186ac755ea40d67ff99ad06381650be568c79408c2b31b113102e18dc93adf97a6bc3d6cfe9fe38b154a590e6da30b65ef6e755091b0962910adc27d42b653af3e5dbb5401afb1db0c3720b44c427eb33b6e551eecfc41f32e65db0f4648d752e111a2ab63c701c9a1a1cffba7bf215f58e3dd3c536597895687617885101f57f7bcf2c013d93c3193390109f5c8a157a47ea78ddaaf4efc5603f4fb06d7fa8e7ec3b0ea1dd41f58cb081c85d41e9ca55149d7fdacb5093b3685df9e2738c7ed72490be81fa77053d291c420449b273b011e76dab5166d06b3c80d62887ffdfc03da6b0a144caade426130e96576f4a14bfba83389360d1e6eb16933a7751a307f68d686c0615be7358c7dc5ae2a1be543bddc0fc0db526e599cd3a6c7cc7e04975749b6a4bcf19b9d09ad13f8d2b4087bbe6a53f8ddeb7a1d1779fc7db7aae76eae3fb79b88284971db030c21bf99f1db20767ca5583c96fb07907d6caa8b0bba9978bf3fe46604cae8e4431855371927c47125060a277fc4c4b424a44d78561c590578f1a9646968b95d06292e14625122b74054a6ef328f89baa36ae1d836fa82c68f64722dca95233f3d03cb323a38a24259ecd6fdc74ed3e9e52ae882450342ccc2151f47cf228ee4ec3b23251b5dae484681c5b188aedbf67191d35dd78943644a1ac27e33263cf527520939a7829e89b4ea249b9d2b8a328040f78c501f5b0e62833b27721ac0d43e69e72cd2096784b2d9f07c48950d1c02b0b7fbaacd2e8bf43ddcf41a9edf26fcbc2b93dd9f64fa72671ad89851ade0689fa28704b6c4cdaae92483ddb790b24d0d733fb15f3d78ae5f4d0db962736f48640d100f3656749126947c5d14be6e3ee46154e3d6af770e7961b07867a702104dcfdcc46844ca19803da8570f7f41e1285155cd99e1a7325e9d619cd7fe7f01047c3e66d806e82b4c45fcd0b92115d1ad800e08ce6ff752b42c3d20ce475583188c9176daf44d741b11e20d973c7d3cacebe0e9db531693fd3a2d9b0b546bb7c28fb995fa6a818f95cd419ee8d2c12d7c2b41b70a2d787ebb22d4c703f3d6c65ac2ac47225a82aff8fc5d1e0c69842bfda0b066ad481e2a5e5488102c6e31c0099b0ab3cfb1dde02cb04499db6597ae83d5a9d13bd0b383ee08e18ac123426daf80517f4f64cfb8efba790373843f9020c4b8804872e0cedcc16bb2487a3ea73fdc79d6ce198863737ded9fc951fa2c4edbd2acd7d5c504c4d2ec30455699d5094d3b03deaea184bedb98e1e3335a95a5667e33017b308c45d69d83fa60fd70679da5e79483e80a6301f879e4a22c842642fb610d268218ef0e3a1595f21f7ab7da46788af5d0e0e4790f6bb50e17bd801b8340dd51db0be96de3c7efd46168af4fac76d6aa37be9eba84a97a8284b88ce560680c9f01ca96f2f6083106ee79584551a4af5d965bedf1f689c8421009693cd8e7a4cf40c5bc4f31f372d7c54dc38598f7d93698333178d14fdd2c729b14e96e6b33baf3fca7219ced31a80be27a5fe2aec701d1ae73a7822c9d74aad494c3444cad9f273bb18fb73bb14250569984fd5568c9e77ee0021af63daf4f18affff7553c401c31f6c3e3662fab181ec44ebf22d5a1720aca8a1db54b549bd33bd04b4360775575bcba6046c524cefdd21f6eb9dfad5ced7556a57d8cc277d4121a4b9bf6ecd435acea3f31d269b357ababee77b77fc6917368f3eabfe90d60286648a4af9359235e3a2674da76e1409794e308c5f48f600e7195d36a4635560e403faf61d3d36ea6d2227629e140d54704137a1ac64eba98fd327503bf1943ba0d58ecf9a327ae7e80c72cd94ea12bfb25cf337e6aa7ec2f737684e53c1d5d719e1fe4cb8c3969ef45faa515c4ddc0cd5a522c28d330ef7d91d0900cac76274620235a30a1646dfa81f2368ad875862d679a5e39dbe1121b126dcd99933321d62d4d85b9ba24a22c14cfa04908e3bee18b89d37e81f2b3b2e1e634de3a6ec9fadc93ed3b9b86a1c1a010834fbb51463a4aa2d67e6d30eb6f06c08e823412264f89d42d00794953061e11d6bbcaeb115834fc7f4801516493edb3166611f67fb0c1b208e5c5316cbf908aeed6e4a6e33eb1f102d4393479da3e93f40b66524cd3c588a8c25ba18c7a0f540ca6fa5f92ad627bfa46adfb9b15891998c1bc1f956f26cd66dca0b9478bd00ac8e16c2fe8fb754f8281032b9e4cff433752422f0ceeab056698e3c38105045341d7a207320e1ad8d3dd413673370fbd40cfe25170bfedfd110a7cdaa1035881d3ba6f4a770036e3a084a2e0b664f142f20b8ce19beb787349839d394b5dfe988ff241cef0ad9cd4be827e928ba7bb914cdea0c8df5026a10bd4469734f7054fba6825c17fe637557f482651a2759660b193281a4b9009155ef55b875c9be4fefd9beeaf1ac46b4e99f7635d7173507a33670776e033fecf074526b98dd41a754061b47ec92292cbd0c32904c501125439fbce22c7f1210ab5fa75f07d1e3bda085c546d481e1aeb54b4b00117fd9f31de2270b9f1d46d0b8536b7bde01bb1e3e87eb89a9e3dcf5bdf2f57ba56f183f905deaef36b295f07d787c7a06166e62939aaa589f3bdfc5b7cb036d697a6985c4c3c76ffc8adc6fc4e6214719f74af731bf65e7bac8b79d12649eee4a71d848c6ef2c51e0dcf979ea727e5c2f9a9c0fbeb32e1f0d291a4a575b5a81007e18139db15059eaf946e792b5a8ddd7879e6b6a0dd51e97d70092994cd8c7ecdcb0ef249d014538abb6383f0f5a7d51cb33c583f12521780e9128cb27258925b6357a455b781a5aaa255e143059b2dd1afa567b2a7ad6bfb2623b41899eefdd21b4139c8a382b0d8c37686c2a6951fee34d382dbbb3e2188ae997177ec26745cf293c95637558a36dd92435fae8af53cf36d46297f294d3ad28083d20e27f1cf49f7dff0849afd9c88e4bd67b61e12985568954a4d921a512958925c2705c0714f913282d23dbd454528dd937ca79fd7b5f4c0006105c39642db411cc5ad9fc83b5cddc83d712c68cb00ebf8afcea7b558dffe82036e092d9baed0883f2bf7279ecb35192acc10f6828b41d45c261b1e9c9f95c183deec6a1923ec383d606e583b51888db8f743898e69407ecc6d1cb97f1eee8381cce9cc3b2f9b5b73b473d58fcafbdf61d7892b6e841f03a06b60410ca25d303745217fdc77ffabef1d5750ead380a008e3ccfd525ef9cd0826615857a2b50799e7486ef3cd4e0fdd6ce5f65d7aba9a0101879b6d8109396f814c91cdebccc951372d6d96d9f1363cf03a06d6e879407807604a6dbe55b59300e5e77897e2392d8687c3d6140ba3a4a701e683a41488fa71fcef4f070b6f592f15cf8742413c7ea8937cd98d8203423351bb263571f5e7c5c9c90d9593f0290491a327f8655ce532aee0561fb877bcdb2abd10667860e0cb38a1c4bcd962a8e31adc7c2f51f5307518e7db6d4e4a9c7611fe57c760dcc5c8faea94d3a7c4ff7d3287c80f33f0db627b2a9eb837f4b2ddb54201b09d7c0d41a444cc7ccd5e603bf7c34b905acf3a444fb9a557ffdc4d971a854fe99eabd6ceb27f251ad700c53cef9c10953847ef5716e76dc9787555201e146669b123cdeea43b76f42c310d7de19e3e4a518331298a05221e91060d91c69476caa13974c02c772bccd49f73a6aa93f703702262941cf53f3e9a8ba0512ed8ba65f0f095a833766d97298165f29b8dd6b0fca36771eefc95d66081ab25c832b9aa635ee69f0ee9e98fb2ba63172bca6285c1df48cd7bbec08398930cfbb863ecb550dd73e114e63d45deea89fadf1a8cedb5b1d4eff2065be9fd4fcc65ece86db8731a25f7498ca290a83d15b0685aec55901c68baf4f0ab372c70169fae9ec8854f6caeef0e41b39e23d2d721abb48eec755827dd82fb74438681b2211a10920176de0f6ccfc1b3b53f6c1bef193b3e6013b37206d40c56bcc4e7f71a5d4f0a550a7bdd27842cf93e44ca5f6ce7c7bc3d6c95c3907c11f0245baea77653a49d965e4833c5d1f06882d703a13e47e977e493404b62da02c2b1743e49c5633a25ece7087979d474f2a3417c65b5ff108913299cd68a14ee1eefc1cde96a873b56c7f9d7783d0278dc2f427bd2c9a6f96d207a6df72b10f5d1239817b53fe9d016c8eeb1d64b01bdffb17d925026a7497d8fbe004ec13af30b8dd4ce0df4940292ab5b4343e33402086f15b68e42a4efd1611710759e439ac09e9b49c4f6fc1bcf3b9e4afafc821f542ad28c9b73f848812896650f044591bad9075bbad151cee209ca18fcbc4172747f08a1418a09e3580aa929f54a585cc0dc63f6b802d6172d29832bed6c33df16619624be69f97092de775e129ea424cc9d56060299d5fae3ef4404083163f10728fea9e7805317a5ab49615f2aaf245ceb84a1f43ccb0722c11a1a3d1717bf92acddb343f561ecd0d6323569162ad8c97d53a8357474a15707e2f346212288213c4cbb752c47c25a6b4b91f0fe260fbe356ee3cbbffc4e8fe780d2408081a54a8277996ea0c2aecc3809afd92401ac1598038ae68d9212b27e45c197c238ae6678dc3e6c3fb175fe6c26db01e413e19230e19c2f462b84b932eb5926120baedb432a08964b2ade8e86ec10c45384d3b15c30cf9bd798179a1c2ab98425388826a18ab0eabde6ab0582e1fc0fc1651165e4acfe40c6b4c779ae640dea009af398b6c1a2ecf34894542dfc9d0eca2ac11f731392d3d7c63114a4c612a4f23662a0e6a50fd1baab2459d89524f562054b766827afc8ac6b07e198cd2dba96491b4cf341b62122e1b726326babd9c692ede5d57037d30e4c4c0932d7afc9a86503fa48830f8e2bf0965c3e10b776b16842243c4dea977a3841a9515f408f4d60bdd3e5385f0238c159dc5c8aaa5e59453606cffd43dc219e2b5cc0800bd8920664ddaaa9eaa6692267fe9bbcb6bb1cb5b040bad1ef330631124ff762c10598ce2063129e8be5d85a5b64397dba2a371cc4faff475228897c7a23ffc093ab351c44cf82c43acc715b5348497a55bd6ababc2509a8bc2c8b656bca445d2e26a28e3e29667c31c5ee3aa5756c7f87c78326d9029d0b3a968b81b2d91f047844946378fef685927db291e0a1bb854c15f2b3ba4ac351166681871db9e8124ae84590cf901b65fcccdf046f0ca62c5cb7f8a2677d5ed85127fa3923c1c24aa9fcc47c2ed4717e137e68a1adb145698e781aebd1b2688241588c944f4e5b4934fd9026d911bac51d34f1b20b6560584a20bd80a47021d46bc249916d1e0c73fe3c298c71eb2f8d02242c1a0668bc2a5db1df38f371052ebac7265e651af8d5b2ce6a5a16f98deec7a6d4474bfc0bd0267ed1131f756c0467f8987d90270bc447811721b0409756a3f41b273c8afc47879bdf7591dcd2792df07ccb16460e927a132c45352d379d9e2deb65b814d40e35880a42f8a89ffd9ab23ff0ab8a8300c8e8a298f6eec909c329e1b2144a8ba01ab243234cd127add5e40a4fb397afcc1a86d57d12d400c71e0aeb4df5d538c2b2326c5ec285e41aab9dc8796218305a82c4c6f2b86e5f4f8ec6fce6752d582466ccbb4a26474b278584bc0404466634e28cd04cf15b161b3d98c08541a8841895acec92569fb7f1641c6d12b563fb8077b0448626148d239574d29e43233c9cbdc19ccd405c40ce74a8e8052e4f2e6db73d1b313ce85a875e4edfc6fe56c800df5cfdd55e2049919e48e0c6522a9c8b4a3bb2e90030f8f9f34a82ce957b2ad24bb265b728f18abd62f30c27963c1dfe69f78d6f926359a577cdd88a7977875780f80b4fb06a03ab630452d01cdc6fe8ca4678d4bbb2fcf0d9fdabd50907321dc8f326bbde051159cc87f1d77bc8920fc3e331231b76a95e6c195e95f4ad67cc0f4e2a767023ca0831cd98c3f9c06d1181052a0b3baa89360ac27240968c354812a62e2c74f10604c9d6401ced4a7b5f34a6c49006c97ecf7df41a5ece83450274ad3f4ed36d667ee6ba05a3eb764ea4719c19c16b340078a96b743741b8aedd0eafecff3d7d39491ecd866881fd00632d79e4449b7bf27d6de9319c253540baf49bbcbd9a91e020dadb56ea4092341940b08537341ffb27f6aca313fd8ffeeb2547c7d97f54e481f10ad3400db5f3d4dcdf02c1a223e1cc2d22094b896ce77290fb4080eb12a19046242726423f12b30ca2b327e6db8fc777d030321c25ae6ba87336a95e4ba5bdcf66b6eb491560aa5a24b21785ab5ab9d4649f848810f38b20f3ef0b7ab5cda5d5082829e5e0d2e0a18212a31db0ecc31f1c79a0a6b57ffe76801cb3938c1874e08f1a0ed966b279f767829599e313f677632a0835be983b23c89fcbde5d79e5284d3b0916fd68acd5fa086bfcbe93cc483bada834e05a021e5a7baf09690cae14e682423a00852dd1c710d653f99e88f94c293e9c20b31218efda924cc05167a9d3af1671bbb3166ac0578aad09b5c77ba722e93eac99a53dc8027ff0948ce9d8e0d2ea03adff20de8158dc31a3b38dccc2e70a844c22c7538e4efce16a841be3cd049d5905df2632d1b1b2803be09d84ca79c4217ee080b123e32f574b9bfbf2871c6342895c022c66be03dd91175742508ae8fc57adab039515284ab41172423db01836dc4cbdd0db06ce9fbbfb27592960e284b6434dc21069eef92eae9965f499cd17303d61f7837a6d41effa32ade6ec8e83b95993fb4c18609a350a85507d45b9a357eea17ee1118a26d1aa609bb399e241a8e10fea45511c7b6980b48354ce6d4cb58290d3db65aaec89557af14cd042738297c07f63d8d5cd2abce95b0d5bae14184e6bbaf8c878b65ed636262d8125bf40e8b3ef5cf766bc5c562948affb03bc501f1a8754d560f601b51c5eca9407ac70cfe537fbbc91ea059bf2af099a976ae82578cc466dd55e0a7bac10e2a7b36de35eb79233adaed88dd441ad720260dfdfb6d24cec9c7b719e74f472e77e1bbefe83ea010819480a09aee498f6de7fbab4d21a09678ebc87037be499757bbe333c1e54956b09a9143ed9bf7dc69d5b3696af6680d43fb9574e40b77c31068a97e5ddabe1c47494956c5adc00ecd3e655a6da669f25d33e2a430ba98b41d8e1565ef0b290ce55cbdecc8f4c50e2296633a68990fd65c2615634e0912c7729a70b78dfe78fb7f6304b1faf7917019988ab87453cc96e417307494e02349dfbdb3f29f56de7c8a6d0347eb2e453123ab9ea14e915cad4f22385527d9cb9fa8c700c7504e48d583d17278a4092944a5248f593b8ae2d578bb654706b5bbaa9041b7f23de2bffb12b95960b4d2acf2cc46154ed1be93799fdb35f4fa2027adaaad191d80ae9241f35b57472de9e8e8e02897ae52f299de0292a16026302de8e5721e666e60a9480493b15421b0963509a752d1f57b3db6ff1692b134bd8cf423f7959fd389630bef65bb965f4bc29271b8ddbf1094621faed8ed3a1e9e055ef839b3c19d25751206891ff1063cdc2e2c5a5800d8c4b6cb305b90f4d1738ed8e111110bed396a193eddb314b2d98514f21db6173f1a713effc5b64e7279cdc93e955f612740bfe2d2c47325ca95d7628d78a5f7186a1e718ea124b1d9112b0bd203945fd45b4174bf7f4126ae99b8b936195c9d277ac6105c73f5c0b497c13365871c13cb71498a07c03d0667bb66c65f20e922a8cebad12dd4753108a254948913c2b7d35a765e21ac1fbf5c935d50ed78a1176173906197418ee8c48f33fabdec69f94ac0abf9fc8f092f0fea173dc5348f0ca80f7651774df6c28af6fbb726951c21d28f52feefcf863d07cd2225ab07ea4e24860a45c87857c07adc194925f10cc4558f756f93c73a37123998715b22365343f9fdf4efdd4cbc2b057c65e90daec6f02d41d9e76f71233e3ea9af04122b97dda10460265e32e872138dd92a59213ecbcd70828573e10ff4a8ca2410ad399789379e9b2484c9ff9eadcb57218c1fc82f1bd86283b88c48de786b0583e3a9f1dba364a4919afca0d9fce730d614635c70ad7201b80f2b9b76736c08286fa5d84f9682c1f3f6039eab62e620d6ebfd8b5ffc751794671da6719d6e07010256e037fe7a842c852880c5bed0bc100c5e810d443b8ba9f350a1be6b0d4e0235f936b6697a1db7910a09d3cf00e831cf515bab91628bad906bea382276f8574041e25f6134f899cb3c4f5456d6bf11baa21fd6baa671d631e8daa88c7852ac09d438b973d5ac2505eca74f0715d728734df37132e25393708ed3176cb47f8bc03300b8b3d5af15bc8d584de946f8fa1076e324fec049609f85dc062528968af10cf1fdca9dabdb6c59c380c022a6dc5305071de44a275393410d61a082364b74497832c254f3e6fa4100c7a8b59d85a8a8abb3e0df6b38760326bc8e753d964c697f87615595ca98f7e99ecb3d45715669b1018c1ec3855a426ae1c1829af21c8ea72197085ad4eee3e24d5fbf872a5d86e91ccdd12ca122707b1a7dc3d52ec6756334fcb1c4c3e86abd2fbc5d1e76412a420f842a0fa8a2bbd7e58427339b4ed81ddf0e8e452eb4da333fd011c5b8a996fd1cc6a13147994c466333f9c27e2ab4c8f38c79f198c945b9560443db0254284ac01a1c90dcd157185274d1e09bfc743bb61e304c151affdc8a04af4a614a35b2a296ffe4cd795d59202d7215348c0fd5b304c7f6c47bab0389f7dfb4eb64ad69c6937a6540350c97c4861e588194d1e7bf55842d1139437a4180cb53b3e98f85028bb2e399316cbab89eb63a0197f8f18a3e5a32900f11389924289e11b4c8770e06fc8ef4ff03082d2a76f141a90b7261765ee436419571fd1768405f3e273268755280ca6f4f572a008db73130786c981843f5b0c4514751e92fb528424a7962d91d3c4c96595ad24dca02e72c8041c5c8c675fccd72d424ccf0b91994ff64cda65f229e0b81c0d42eb24b82b5b6fa079239fea2e195152b25a334405b509a54ccbf56fe7a4894a9b51e12be06aa3e0f64a10dbd4e15480ea5e53385d5230801f0d77873de75595453a56614a0d0c81dea6b14c3cf37ec484525b0e1252b2c8334036d6838060298865e8b039e29bc7ae90a418157ae7c55725f5e05f98c728a5e05e7a30a0a2d3ac2f78bb5f6b81b12ccc2ce256490352dc32e2afe7bc6bd47f4814b22d7958e814bfd25ae26e4e119bf4f9682584b5d3c7ac60b45d0d6706f99a781ff037cb356870ccf06c7b19c46681605e8183ffe8fe5a2ffd3a1361a5733b6b4a5989a49f1ddbb82d71ccbc7156785664525999f7b98ed415c6cb85492e1cf5d430a8999c9060601707e2e0843f7777db4f4726f20d2d2c6f7fbaeb6c333b3ce5880596a0696e76e6c916e97a3fe5f0b43dd32eeb5d9f7877718e1f99fc3494b9667d235653c78e6b4684c674b185e9c2fe06d15582c09257ed0aaa7a64c95a8e4f99a47712d5247170d12e2439565633b9343b3e751336dcd92d25ad35fd320c83235b3656e065c61db968cfa26f273455c925d4e0ad9a5f2758e0d89278d40fcbc3ba40bbcc0942042694f31e5db70d7ace8d0065343baf4a3cb38e170dc53a1055bb03560f56e3d68bce42ce2fb5cfb84fe98e14dc696d2179dd3356c4c6336c5e1891ed64f9e9758023f56b097d56285e71afbf7caf57b0b3025df05c9b7ac91c71e6bf7bc7b4db636dac7abd096e7a4bdd77cad91b9a65279aac4db0fcb6aa2a1a939e567e24502471f427038bfcbce365c588096ced711fbd488d20ef860285b6bf704f191b1cda5a88894de5a4876a2d7eafdd69195d45f987d1d06cbe4826dc667bfa50b7042b32afb28561dd2c5e8a0f52e999ea573f991a8f7d30c95eb7c94ccdb7beca9464acdb0bf5d472d9822f27c79a35296b53faf729d6bb10a67b61bc5e1711f0d35dc9000ac58f3b0d16d66a413bcadb5f1515a778e7b34d25c665f3730e5fb8e95fb5d14bb3a423fb24b62a96e01acdf63ef3b6d84fc91d2d1956084945d699df1a70ec670aa4617188d7cce7fe403da40dfd0b8d0abc8e6db2fcf5271a342b1e33b62092d8f1304b87432b4d70ee7bb331eade8e40cdf6179fdbc50d4b04e75c82ccaac729a6281f7c7b8376e477bb2a293a34fcd1a5fa30cc8a4bccd1be303fdd17d42c18a4c5c9a8d600a0397eab2afb899750131c1011dc8497118c284c9c9bd03d8b18672de6e8132531b39cccaa78bb9fae602037f35bb231483c6b75a072d80910f3ecefffd32b84d62e35bdfd521b773cb6fa514b4124679741efe7afd64f7213ed87478495f0e5d4adbdb66a4a2199a90280b909bf3f8e29a798900619639e3b90c6b367dcc1d16533763dd8fa74df0cad321c5e04dd22aacc665405adf509fc0d64899646cade6399ac19e7ec78adffe14ddea4fc82585ed058d7347b99e1fa461ccadb35cca89e3a1c3980ac335af0ad0a0c824fd10c53e114f7a8756df0d7bc00488e8c0818936de451969d1655caf23dc5db29f0924121da360c9011ba515fbc92277cae0173a456959cbfb370672f4c0132c7b76279c99a8a5eb679e5ca26a1d252f59e6d4f900050ba312f17c67cb7f4b753bca05329db890375360ee15636417ee8035c15eb0071aa4f2a98ff41c8b22707c1a62dee82e4d185954a512038a0c4be4ff8304e491bff00d525624158d1bb9b945274b767a6f79a2f492c051d86051cd2cc5baf90ca0d1feedf61d18ca614f80fd8d50dd0138914e9cb6f8346aba5f09ee340ed99bbc0c86059f2f18f71ec210834a3aa0646d1cba99597b7fe1c1207adc410857b3085cd605fa2f7e6cc9e920f701e9509005339437e1d57b7a51cbd6e65172ccf79903f8f813532df6e361ef3cbfa35308ca0d88982dbea710e2ad297201c0acdd305351ab3d35bc5554230ab6fa19bb1aa63fb1c4d43a4d83261041d546a7ea04e1de35f6299bd09f60248be6e65e676304e78e569f8bda4609e23832a8ceb15fd92c96f86910476c885c1a5b14e22e37470f029263e6f9d9d9040a61684e7290ed3c8767aceab678c1c76eee4967641e46a886009b7ada5bad5702f72435811d0bcf9bfd931187d1b20ee6f9dd10c9559ededba87c5760fd792ac2c1f27037ac8cf3d160d62abc853f32f0ded1f68366937dc6d189164b227b1977a1bfb2bd4dcd85b6ed851e6e7a8b379db8388848f254d34b7b76d9bdd2cde895108ae16751db7227a54c007c1709c51b219287707fe0c8095e473a1b0dccf793d4c8fa19d84dd1fa40e9e8f5740f0afe416667beaa0736c0e60aa202b181b495ebe56ec10f3af69531284f794e5ff0fe87210e48627bf71e37e1bf498762f136310cb238464239db5fee184c95db51cd07dbafdea970a86de8f5fa3958af2935e4a0745555892aefd1438cd75bb6348a41241643de650830f1e61fe0d12cbce921a229d1ae1e67e9d6a60cd3b91261a959e0d8134f89b1ab660b67a464126a3a50a8a64039643b621a2b6e946150fc7106057a9583d88a2c7a59b2d9a034284b17e99a389bc4c0615cdeab65f43559e1cd0ea74ce2834cfd77e239f2549649799366a69c20627db87ee498bf9f2fc14351f9f0f0bbe82fcbefe0c769492250b8ea3d8d1395577337a4dfcd9189ab851b3a6ae46fd897767d221e09de22060a97c4b2ebb6afbb402b53558cfc1999fc76cd4a196d6231f61c1e2cb42a1ba762cccb0a5848a736053e03841075d165d109cca9d29816eab94787bd8adcec2a2f2dbc5e2be9144fe821d48f3bd1d57fa098313d2cdf4d3af9409d40fb7e6993eadfcd360ebbae5ec35d718b4ca5fa575d89cd483f3b6e0e231a5ab60261808683e728ee315378c5189df24fa5a65561c4028b9142972a6074712382ee8c2a7ba6e77d773dbfd3c4639e8208172048ab97ca76f2a36654015da17eb3bb52bcddcfc9eb369b116381971fb7d526149dae5b4a479781892613f3b15a4975adc10b343647896970fa78fb2b4d50f8d6f20fddfb621f711abf0ef1d297db28c6f20c9d069720a1d7297aeb7a3247519951e4e5a71649b2cad7e5b375181005b1dcb2b01a0ca5f2e7f3cb62380481589584a151709ba1c402db828e69d8e305b55d5b6574362e5b24402f1e521dee0866fb53efe3ee040fd19bdacb4d92f77d4015544d988c3718fc206eadfdf0631459edcf40cf12be41a19d23a6575962f5d0965286eb9dc532e317f1ad6440cd9c210670c223121a00efaebdfda4b0d014dedbee489a3b62a654aeca78ce647f3676529bed293e55bdb64b8e0b8689f3a7536d889d32e8cb23b563f7fabef1517be447e30937bce0e8574adc185ecc18d898bf2ca4860aa5416914bfce2bc23794955eab51b4231a942fb969db52e2727b96a593df4543e2c0081ab7ac663328282c820e63ebe7f0c6cfc06d77eec2c3b53a85dc7871f52c155b8ad5a6c8795461d54ba12c3e95bfd100cc8153dc5b30246accb163300403ecbb6c18e3036b552a14d3d0178fd8b2a1655a78db7c72ae62444d4d12275f6c1c3e2f296602f37de98cf7028e4ea11e41bacf8e50d602df2b0aaef061187a7bc4e78e630880d990532c4267e3bf32339a109aa4abc5f76971a3e4a9efbe6618b585151f708a5766f157f169b790dfe947360e2690d2c382ccd30ebaee82abc27d0be8962e031db54049b2960644ceb9acf265dbb94da3d004dc5afedcbe82670bb5e6b3e211d2f173f75e602799cd69d39511bd892d6d1de5b841bffd6bda71566fd739f5da632ce3dfb972e9d38aa7089c9b267d79710abb22fc68cdb3908cc0a2148fc0b435f93489f6f582f541e59c295d18b37d34f25a40b2e7b6b4e157f9dec9716a7cb7c827ec23b8f51b6fa510750d49c2c374adb665ef8fd2262f1f2c630640aa65010be517b0cf1fd0062e92852e0d3c1583985f646e3413ecc8cbae0cc647e5101a8aa65506c44b0b6c599959714c85adad62eb986ea7273d343983189ed4b541d116b6b4baa13fe065110cacc8dc4309c9ee94ae69d0900f9cbe998b6147906234eb5023515b54f5993dae24c0a690463c1133afe43b13347c7054eb6e9f4ab18b809cbc8abb6578fd693e7caa9598edb2f03529646e2fae2ca85f7bafebad1b7c6b18407281d492a3fadcb7863578fc25e11dbbe5d154f37537b0b700fd78bde6e0c51921d96183777943d52da1f35aa492778c01dc08fcc0d6921810b2e471247326e0bc1e3c5e091394ba30106a823de94a30ed6dd882f7670c4a1364fbe47456a49a7fb7001336ca1a7caa3f22645707931f1fb519937bc12e58a65cd2a782f615b3ce3e0308509f2e8a8dc2dcabfebf2a4d76881c7c0c8e9d6e79d70d4acafaf8fa492167c29253dcb4288962fce84588121f5d7cdf712e17ca7904448a55c996eee9fa50d3a87d68e90d953e9bda8743f76f8cb31dd2fb3bb349a8d933f12961bdaa8d32117b86b8396d48cb03f7f8156892723e48754203382bdb01b092078e4a167f1a41b7dc3c280c08b55f532e18bc6c49f7d93616059718511d41b53c14ad5c5f2d94bd673f94573d56c775f64f2367f002f955c9ff5581f44ff87f0807d815c85eb7e2b852d0e6213df7edf992fca9ec8eca632023448e2cb8df93d90f8a99d05c02b5d37bc9cc6ca9faf2e0caf2042a26fad1ab2751b14912b084c663867a07687bad6a4ac17f51e8f5c0b93a27c06002a1e0d6e45432d3acb84c6efdcc5a1923017baca5102af1d48f618f2744452243af69cab20dd1674d76855c393f1cee69fcd0232b52dfb15fb0e20c3bb4148d6d9ca2a3fafe62bcab58aae3f441f6b927e18cd9cdacc6ef36c3f3d53545b1476e7f5c03558c22f1db5b0f8531c789de88fb2db10d2adabc7dcd825762cc64774d47859ae97476a94f363b613f06931e14994d66d0e66f95dddf2c2d3bbc9b4aac4b796ce59e3987fb7b4c2c453c6d8e673af9b00bc5da67b4318a6c4caccc2eb301c73a179905f10f040f0c115f958f45184f3844253fe49171d0ec3b259d38470dafe84700e61e00eb845b457410a2bcb6c42f0d0c358fed32727771631b61c3c9027c73f54abd90194bb514d37b99cde6a4dddaf76072eb0fbfa46f3b9d2abd00782a7aa3fc6767bb1adb1ceaf88a18150a1c1e16cb1c63881cc7cb3dbdf4550af6c0b65d8ac9a85bef70f68b3abc0d5761a83f152e29950db07f903e6135baedb9581db9603bb6e24ea9fddf5bca8c21bf6a4c5dd63e560d895f8e4f208e58c7066cf8486e0253a75b2782d93d40663adbaa2d74d0c11dd2d5ed2ba3700d49c965a41d73e320381c555b1408ce2f4a9be10bd03daf6ab7bd3b10297e91ff785e9425b2f0a39d5d15139da712e52fb945308cfb88cd07ec4b0b22ec3771ff2c14d252394fe121ad2a276a17b26a6b81747995291291f87101eec6c8e5896319d9f64f6dc5312974644ae5f5f09673e555793f9c6704d4b5955fc94c9140012cea87db186f32865012590c9a943508410605528c5bd06582c6c2a620a7ba439edd80af56be8aaf9b3426baba527fafada1e5b5ebca004d04e29d68e43efc998ef63abdc22212288a936f455fb7bbfb19956aa2e2b93fed79ff5fb74e614d38ba87d83b1587b3242c082d37b39babc165fac1d5cfb61b0886fb47b7218bf31dae3777093c833603ce7111d800597ad7a6e78c51f30364d80806b83f465ac2d2f57d723aa0f0affc303c0becd67f808fcd36cf37292264edcd3b2e67356926af6af0c64946c1fa7712088fa8c4d276157ee3e623549f8c6d50d4c5379067515ed084cabf5fb85ecb074ff3d57cc99546486bf7772f5f77867f40c12277ddd2ee22c27f03ed9a928403e5beba4525dc74b4fd3add0136dde216326b8b4b11aa8526d398f50bd4703022e36f7aaf1f0dbe90b9cb34bb29c3e7679f135abe962c9119fc807c2b2714c02129ea6b8d99f1a732fc60f89e9306dc3557d93e071f255f1372a487d1143c174ce4ea9764084c815d12ff51639466b97a4f7a06ad61eb259c95f3f2dab8bba891577ed978d593d274dd0cdab09f025fd668ef8603ca2d77599ec3fe86aa7897856a5a63fb0b35d9b859115e652995e34b73fe958f36e5772b2342d0a493b8699a88a549c9d3147a19768ecc60243a3b2224074f310a8d8461d6b7769477841c6798c9eaa66e50e79dc92f42293bc67c5bb3ac84cd33570334b53f6d106c89ed604ebd4cb6a308e898a548ecfafaceb23d10560a7d0292bbff7159db5e25ca467058680e6f2b5fed2e90d6543e6fb715243d904975cc48d727f1c14c8aa1e808c112b5dfed1d7225b84d3ec10bfe30f6dd7616157ded0901ab18db39bf4c8cd1ff6dbce454776f1a04a80df57d206eb3f1508b81c477395a7b1ffe33f3bf7cd4c67ee98dd996c17178d7bb34d8dc70f80da523bfc9929b6821cf7b25d89eecfb2239d7528870e98ffae832b8b9bdd88d14689ea6c737ff73425490e1500f50c1ab46bd83c03c81ddb107c0107205c4f3e4f7fbb8f6784046cde26018423d7a0b64aad857fdd21db1268ab45688ef529b39d096381461389c7c4f42fec3cee9c123902c7e9e984fb125191184c714f01396593840a54ac3a83a6fbcfa4e229a8e85c70c923b04b657d3213c39e5d177cb0b5f5e8b9d76508b2f8cf87d99e189b259bc692b09ff221a09e4d9c5a445224cd47b6b4f35076b0d599615d7a9dcc28717369f68fd32111c34df88ad60adf8e70d3f6863fc6aef96584e5827b8cd856455dc5b2cb564b74c03dd0619eddf9453fbd8afff9f9b1b11a3f637e148477d50efa9997e6aab45e4926c3f980ddbab9cd9267d088ed6c073de8a80ec3f15f21d6a0c68ce1fcfb1c4e15c6d273631b315709370aedb89edde28ab4ab2c714bdfdd9d565192d8bd33640d26fb388137cf3d7b14e3af3fc860b0b6e81c4787d7fd54e484e1db4497abdd1b5f0b628b21013e5b9a15b682b562fe2031e7f3cbe881cdbd45a6f92f23f54ec2fd9f8b48f21e4c60efe19c302b4559ae4519446e420cc7795d45bee6c2940eb81d4bd41a099c2e099f455b8ec7ce8f4b422df6356c1b8a330d51bc8530833587a09a6eb1fff0ee1cac6786e11a2b87a1197021a23ed07ce85bfeb2b6ed6abf8a6004103dc6386e1b65be1aeae547dd7adab766b5f381a7b4be96d4363ad317216d16c0a25c20ff8d8e5affdfa75616d59f1366e0e22ab4734a34f9d7bf5d444b232264bfeb07dfe5ded0b00b4ae11fbc263d2958278b10f7fd0ba4711b3ecbb8102835d198c39a30e7afdf68e0a74f2c88fc57edb0e0ebcfdcaa8cd388fc46925283b54edec33e9f759942c2d2bea8a163e45cb8b982b410a907b453815764eb9c81b5a8701e078765af79c7172c480fe376ed2aacb3090cb850447da0f7650accffae24a889de9dc9cb890a53583d9cf8632aaa9501ff8cf29d4dc9621d559b2a0ff1520b6c5a51f63ebf21599c03a9655567a39aba0ede7f77cbd96c177f8cec84df27479e9683b57428d0180a7923252bd16fcdd2c81c3e39416f2b98afb68581286cc993f11f8cd37a703883911d6d0c7127e921a068959f78e8b3336da34b0b41c0a3d3b677c4be2ce42feb1168d8f8da24060bd2fce246f96c6b00a0d266899e7384d3dc5b1862fae4b113989ee43e023964523e45e7482cd9d013f33c551e34ec51181920fca2111e732e178d1c73a026206aa58dd89213d87e62b9dbffc65841201824bb42d4a1c77dc8dc850e129f5f030f8eb4b2bb1630e85378d4e8209a5567ec119afebd9926f79b86a4fe2d7b7ce7a8bbde7d4ca0a28a2bcf00c79716b64687f99fa35677456642d82c1578b0b3c105d3a55d26871403d46d0808c4336d6f4925da67a2c5f1bc9160e3b61e1978388e3922ab3a08706fe504aa5842c650ebb186fcdd1df7f0611a88606a1761f7f42f308591df8bb3f43b727b914752589cb078190ac296eaffde2316528f9e0f4e227a002b825af424befbb8d8af9b358e79ea92fd77efd47d3f870a0e39a99d037e8edeac7e8b87589edb9d4a2386e6d6add50478d8230d7b9dd0d281eabca0e40fb19fcf3393f1cc9a4d11796c8922c3e22813f9814560cdb17eab5d46c058d3c934bce79d409b19610073f1f6b6afd6a5e364468a68db77913533e6764ab6755a46fca51db320df742b964f612fac1186180c537d3a8e782c14d083b429b7eb9e7fd23723dc40ec744fbb37e7d2d078f20fe1c2b916f2e2147dfdbf7628090f5db4c5c468acc0cc9dddeab28a2ad9bc27858f2d161cf45f612ef457b63ac04383dae91b9cd70fc5e618c83176f5c7f43a9df296abd3840f3eb1d24300a9e4b36ef2f4732166ed71be45e747f1072a427ba2016d84980ea93609b539ca7b551cc1f5f26f690d6c5da145d1089a1208d8289102a0956c092db163948a9bfe709f63f085affce34e25a6edf749291db7214b597d51e74fb9693c6a8c9107b02cae2286b3e446ef544e94e876290872d35ef3e1b4ee4951f5fc0f93bd0e8d6096dd647a3596e4f54371cbe6f7558cedcc2e3ed4866d05569faacc9ecdaf53ddcedca6b5f4a39669401e865d161d0cf4e5ec2b5db7a447554d9165a53ed411dcad73df932a53407effaca693a5bf96519b56594ad7930a9c1f18753dc3b6f42f0dc224fd7d8889e335efcba7ec903131a7b296701af93523d7feb3f9a4a2b18e8e034c4c51aebf07daff11e17189780971673f2114057375dbaaf148a42ca61f078625b2570b8cfe1a322a45a62a53dcdbe51d9bad5f5153f1220407969be6845f161391ba6e568de7cf3c924c872abbdaa3280bfafeafd349d19517ee7a5e8889b24afed41b9ef389dd9f6d8b23dc945ee3e854f78fd44500d5ef6fea5dd0e3e224bc72367f9dcf3dadbcead3e44d172c0872dac7a1d2edf0f7d88e0b3c502306cfbfddad2a296c1bb20566b27df81fa7c6b936a8df6c450f83333a3256ac7974a42c8de956a4801cbf8fc631cef889fe1a80b03aefa50e5aebea6c35369bef2d5e7db5ec40b6abc3ae5f93e6d0570e7a03cca5e5863438cc72e8f9cca4ed466d93defc967601b1e188b6856613518e733583a1eaff797a8e5159a2892274a31d15e9ad924221d7e82138667cb2db5707de3ab59aa2664d62dc60c99f459a4b52ad0b0e4abe56a1b3777473d6c4680e9c71e7ba778ff86c4f0dfb98e497f84deeb14a85872af045196c0a8f5d913c21eabb1d93f30a38ecf9f8ce2774bd1ca4b7133aa7503d4b6681c32f688ceb12906f8232edee071642fe7cbeab30e0723257456a0edbc7e83f4dc3f39cf4cc4682b8b96ca70287596e9587de5db6012c45b63e0c83f57179932b57746a4dd7dc159a64c0ddd4aaee4433a6f366c0c03a5010e65cdd702f05cf41821139bcc8a64ea7bf3efa554b517859178a92c924c8bcf1c8c501b70ec4471550fe2fe5c35f323cd99d82e9bceb0d6b1ccda28f48596bc6cfa8c9c079a1e378ab4fa11e05ddf8133f9f2af118ecef4553070e0e1d71b10261245169d7096c302f79f19b33911f93c581f8d21aac9af3b423bc34d71bef2c24ecef654e350ba6e2838f8a56fc678f30d456f5a04353267046126a7085faeb9a39d247a7fa97a6bd14ef67d047ffdd2de5207bd8293aa643f55b891d658f5e3f31f1682fc876314835c67302fa69105020773b85a4b0d43fdda0e41b991bee450a6d2452a55f61d5d8eb5655221f992ef538d4b14a10fc2adff56f618e6079e94c613e46c0faced69c8a9729b0b4db6e6fcf1a821fe21b3f251ed339c5bb28a7708a0c68ad333cd814a6207e2681094c239e33228c2d022e90ce26c5732fac87219fd738ec2c074105a61b495eb2f3505ec77fe2d9a41b7046da10e2ebc487914498921612d896b98f6ca2a428c18abb6f245ccf0524a23e00b4a04dea573319eee86c9e05277ec2c15508b63f2e4d6b8becacf633c218a86f836484d104133c0eee134dd99200bcc216e1ec1ff1b43429b18681c78c983260453c4015d4c3414b0b88a5f3a2160bcbaf755ea505669a2bc610d1a74511fa9379fc20f559be60b3ad4591add10c01fa31b6193c8910d6fe1f084234d4ee491875ecd55136312d81f4f8dde55dae95c55665807d713e7b02b3cb25c6473a7d28c698907227937b4f8a38ca69dc95ec49066ff009449a2212c4916f8127609afd4c0930e48fb2371deca6cd8dc8ece265ced1185ff87749583beea4a9dc90058d56cdda0328dd933c40af666de28a7263ab32765248541cfdcf95b9a4bc1a1b46c71e733e8e9a1a4b8fa7b0ba8c919bf699459720bf1bf3ae28c61b9a9cc46d0fa2511fcf18e7d36ca2e92e038faf1996d1dc4e75c0843143c7bacacf754aee0a38d3aa98496fb368f8214efc7da089260ecd3116dedf678b27960d654253cba042e924198513b672e4ca61b203eb7f64e15431045e36172665b9c5e85dc10a884bf4cd21a05bdcd66f4c99e8136e2ca14372088c05cd8524cb7e981b6ce9183779a5ab273322642ce4e3f7c99ea5ca98f76e8c3ea3ce073c8511491f1c83edd25217b9f76b6c63fc75af4b6d6b9f922b8e5dba8dacb2a924079090ec4c4a3d74638cf0bb7d461b4f89b0b8cf5704474d7fb25931a5b4ffb72cf39f97d729a0ba9136b8d070c794b923c88bef2bb8c333300bd525c7383cfb9a4d0d7a143977ed3bf0bcdca467b8da4ee2ebb57ab9d6da99d13459b6fae27ca5e2b778983bd6f512849538c5b6573fa17835aa9100765b4c0c56c7ac379d182030a1720729b5979662f0a58de894b8e4a963dbdc37a7f266a555a914e6b53d43a02aa50f501d9b37191acbc2acc8f6f06b25365b68afab195da6b8e0dfb3848c9cc7c4bb97692142063bc60a5bb502aa511db8bdf57ab7c78182b5938959cfc7e0e4912cb0d9168eb4ff8d8b5096fd8c05e19ba9a292db197f21a95666ba11cc02091f3dff8bd11c767ffc774cf593f1682af3752db369ceb159f4457ba8c15c612b6971eb19040147eaf54419213a7fb6306cb23c166a11498f6da2c974b3ef28dfd931792fd9a6ca047b9c076888e4aab3eb433c259b1fce2d6bb9eb9500d650c33169dd93eb54cefa2a3ccb6fce38bc502ab25cf01983b477d40f1b6df6ab4d0cea2fc1db8f698442164d1216bd20d56c099c4365ac4ffd9ae545c7736bdd5ba466de7acd2f76dcd1e12559c6daaae6f9d314e2105ef114b2ab6c22b04edccc5aba3cb2ac5b9017fd8afe5aaa6af35101f7c41beddeb09831ad2a18353272e0dde7267e87305d3a02f7bfbefb54247755697ba418a0e026afc88f9da89b3cddb94b1862544df9c9096646baed78e8d46909849735921715c40a106dfd07ee10834ba55dd6a3f9af5995556c75ea1ebf983e1161beb782f720590fcb5cd513f7980720678de103cb7117d0b68c0295fd3b91cc3acf791afa1f4ec825d68be7685ec904d71ed6e63cc12384d948630dbd64ee9367a81b0e361032685af78d7ebce37589d9b61caee3a37c5c4aee76ecea795738ee50385dc0649c0b1a14bc84f1413f7a13fd1592751957e9dd8cc7303cf9ae409f962f3cedc2eceba1ce7948dc64304330582d8cba8d5d01d2263636a4f60b214d9a19775c53c8d37db6afb639fa65e2db3ac4dc8fbd7cbb67893d923bc228b803a775cc168566b2ac2b973b6d082a6bf38170602af0aca5c4998089b0e7ad81c1f5fa92413e0dfbd0b71ceecf9013ebb888406b5ad5d9422446af562a7c96a5a01ded942e2b7d9046869ec0bc1e29719686891be0ffd5eb9ae0aa3d44fda96356b2b823b0de62f816ced8d0abe9e24f5b3e3476e23ddf80822015da0c1d3d5df01d74dc07e49d4c1f6a51d4e081ab321b245c3121b5bf391d58f89d2720a52a5f6a3b013bceb351bbad6cc574a9f1c1049f7950c8b7d900fc067a119b4a6883bfa78838edcfd98bb4920e13129605bff4c843c890182605731a3d96a2ca1c9f24de5c924b2fa4ba371f70053fd4036ba1968f7d59ee12b6acd7a58396d91dc967f6a075743107db8ff1ec0c9b32c0e7094aa07fb02559fbb5dc8daf6422ed3e89f3e0c91958d3969db92a227125c5e7c46cdc88ff5912ae746bb30a594ef4aed0cfeef0ff7ca9e36d6f2c16f9fbb950d0e623ff82e0bb725eb86c8fce27cf11a4e779f8edf5628d6421bcd3d642c5fc76f320e20fae520de94e711ee2d8f1ddae34504e313d4257cc12d1afaf92977e550ad6f0d088161037ec8551a5ac74bd30a34e9c0bcc998a15009405bfa788d1d382870db02541472f03a3f39709ca40f703f408ec780e5cbf63cf8f243277d936e963b5d2445cb887df341f1a625a063e25d8b5e81cdcfc0c50cebb1994879493397ec64742172b3bde1721356b8c1e0ef7acec94241488148fe96c3bd73b04ef51187e4f160f21961fc017d87401f5d77761fb56f7c0b0828ea20a3b543718c9bb5aba9c7ebb57690320021c0ebad247057339b9872eeb775dc685840ab87c8b0acd64e4b883d53eb20d9d4975c8b76a89817b797158a3cdc106780b1d6e6342aa3f783fb1b118ea8a1f2fa0d1cff42c0298b5c3f928768297d470329d9d9ab53cda648cac856b8b4c9b079132e5825623f21eb7e9588802820e316985a5c2de116760daa4ec08853c85891ab133cddd908c33143862716ade226e7a924d04844213747474f95bf8884b6a3e470ad0f0676bed64292c3b85696255eea4fb64f64326d2c36ba19c3d6c1c825b411ca7581faf08188f727212d868139391896d0fa8dcea186506ca3378dd49f57625e005130fbbf4c6322497c2b4ddf73c6dc2d517ca9735fdb1231d5fb504f6243d830f28e841a9b5b2bc12d84f9084aef5acbe917c5c25769ca7eef9b647334ace4c1855c9452a4f0e1176c886b7c1e568b7c3d851ba80464ec52a65189874b4f84f6ce5622e139c93ba090714a458d5053a2f13cde8347ac7e13a90b072a6a5294a7b4d2fa695cc29e0b17a88e20d02c832f87002fd578d85c442095565352626e0b256c56229482bf1a75fe910c6c758f7318d56c206b75e0f4db1b317c8ce9a3123407f496e57def1ba8357b641ed7e165d1c92e9e151c7bb91769ec50249d690c4955028288a60b997f2975580706529c3502f8490c6c44a3e3eab91f61b64fd02bfdb34066ed169f075cdc3f634fb8009a29f9215cf3ea0293d0ef3947bdbe127dff4fe231f26f9ef5f8a965dc9c77c01f6f4eb6f638832b67606f588aabb1d6e3ce72ca6a807292278ba0b2176996378caa49092a333ecbcafed78c3c8e825f9fa38ee505ba09728894c1017cebcdbed1f64c6e7ffc1f4ceda34eea55e2cb6c499fe00b5a437894459234b85440daeab22019bcd7a93a7d59e596f5d7304c8f414e17808c0a5b8e2aec97461586e619f85dfcc60603a1ab39deff5fc312eee37689a64c34da586a1c071be462697c6f1c8bac489a1370396127c36a35cbd6f6edabdf7c88badde0d6e5537ff320afe6a4b42afdca4302ae612624adcddd69ac862c43fe04e65fc5a2e7a8900ac8adedd1b778061fe9f2471631dd7acac10bbf0bdf2d3acac07848e0a7523e564b8e9daa14f7d67cf9efa91c20a54a3dd950cbb60eb52f7fa31a8e14aee998868450595612b5c1b3d27bea3e8ee0086448cf3e74153875d6d8b67d6b25bddb636f336bcc03e85144779a851d34e37797bb47607f33a6f4d31ffefa5dd4e4ef037ffbe79b947d8c0190df13e79a6a999f93fe9afbfbac7385c3575a9b06006c4e2efbb00dacc3a8b89161192a451aabd107891edc556018c4c15e42541a2c2aee81fc9bcf095ffbc2423c643ed9acb677c93f26085b2a48abccc767a4dc216052fcb9c521e66951dcca5e9f47e27f4ea1ae3b8ce1e76d7aeecbf5215ca82bf5db86c394cea741324592cfcdf489ce8cc0fde8f4618606dc45efd84fa8cab7bd07d1e78d6005a9e7aa1a3a812c174815c7fca85c64418b48bfa5cb0526d17b0e54638ecab5d3afac7d9224c6e73d39b3a5b5a975fa83a0eb62648580547224439f3eb0b8f6af858f9d897e4303c36f233043da6e5246ee2d3a0760d12829208b0af46f71b4ee86cb9f5918117474b1314eec2f3b2be71045d10fc64c80c4f389e159fb477840ecf84f5a29ce17b059485dbd7d864d1b8c0ee686010396acdba4c4746fbb8fde800f1d9a2081ef2fb025459e1eeca817371d841aa5d2f9568f3e73ba9b05aa5511eb441eccd46fe09ece21cec173ba5deacc238c3371b39e99dc17c2b5f5fe1e97c463b0c485aaaab3ec0efc23fb3a5ae1b4842b662604b990d0a5ceecfe058c93f64fbafb3ba4f4940c4660bbe534d6ebcd520a65211e37a6d5555d4aab7c6bef615b912af96ab290c679753678ccb3b6e8f08bde4ae477bfe55cacd4d84d0ce19c42502ba48ae7fa44e701a8216e13b377277d15c7ac3027ba03556873a9b808e8993fdec44f2e056e776483589e25f3f8cf33c819ddc8c08d08cfbf3b5f8c9521fbb1a91cf87cbd41bfb28638cdcb889a7cd51c5ca15bdeb1a3969ada43608865cb5bacb2c0aa094e84448cf448fd541ef2c1d6522eacbde11efaae611f5414dbc04d5f35ebc16089dfa4058d35423b06c1b6dbff997a47b12e22fda300a9c026d717d09b48d5686038f48eb399649c9d055575fa523dd184c054f58ab845d341c9ab86e1982db0bde33d94e63005b8dbeaf01d1aef6b1ba2030b1cc048db0fc866a04a444d9ce46f97e61807e8264289b0eb1c94b5bb9850a1c2a841a63ee7a0d1aba8b016eba1ee552245fdcf9b789bf503db3cef4378367cf6148cdb4518aa0924f48990bb6b92c3f8036872bb77144f02ff7a8cda5d9b6813f1c0c243d76d6d7d6e2acb3f385ee23ec8a3cd607c7d528d0681b7b5cf3143a27d607bdf2130c909fe223cd8a242e639b5c896c1922b5ed3016ef8036652305ea5db1b5a5f03be05760108d3980ddd4373261037e687ab0bbac26fd5097218e95892eabb847eb8d8074bbfb64aef589531e50a479170ad0ec16637c731eb73ccba3e614a98042ab8a4f6c348e3a82a971803e0e73582ea5f679aaf1e5d1e5d1aee77c4858e6d5682fb99513e773480309970fad6f610c02b623a4ddd923b2990e1c9f95ec891e50b9621a68e32296d672d6e386e9f687dca5fc998901a713e88bafce5a9a06f41ebf6cb50c8d0294d553dbd275b9182fc007b49ece5b5eb961803f803e559bb808247bb7f419036bc256b3fd3ee5d33785e8f9b39693cfa14bc78a7394f41c948119af7178543f8db32184a14d7b3ff9e804b603738bf246e223a0b8fbdfa72e807e58c042f7e4b5a79fd93aea21e1655b5e5df60b35a7cc9b4a7aeacdb08183f6ae91f357b748b7866e933e3390271f03fad248a11fdfeb3f01020350c0fda20af82a69882f809d46c281b3ea2fbe500b0a90bcceae48ecf7e5cf6a93af61d06c19ab78d5a9571311cf1febad0865a3c682f9418fb9b713b64daefc66bc43c090a7fbaaa0ba45f0232654aeee7a9bea1e3f30c752e16b6d05c1fc697e49cd9407ee6ff81f56ade01b3eeaf113f64a3f4393e8cf75d0ff5c659d67b61331221a62af9fae651a7a1fe40bdcb0308291013527dbf0fa73d322013fe72b4b67a91e84dc387abea62a71dc8ae289bb07fb672f3a5c72503b421647189ae2cc2103ddcaeeb6899ff961034ea484f4fa1c8648c100fb16c1ef0f99299f7729e93b8d1267b3e13bb0838dc1b8e16c870b8156aa3bce9ff9e917975ff15cfd5946e702c0b8c6f3db03a3dacd20ace22245e0b26147fbcebc0fc9c42dd92dbb15c63b5a263c7ddd25e2ed115c7fcf094cf5dcd27ef04653511829aeb92e326c9c54ab09e41f916bbe8d706391fb7e80161f1ae9f3b7a33582813deb1277baf1b3901f71c1e9d0c1a29eed2b9f987e016ed70bd5cad5ca032c50437a1bdb12e4741c7961540b8e5ee19d63ed3811118e3f15d05e28a95f762bd57045d5334c07045bd3a3dc80da33c61cffeab311e954be2d87e7dd0d0855bf56f9d7d114e9fb0ede3aa02fe3a4d84c11e59279f4f2b589a59f0b683fa28850cb7c54fc421050c1c932d8913a30b372799bd6ad600e0653c30dce2d45a17ebc7f10019a6f766aaf987d019ebe9a1b8ac23f6ca46a89937e769185c9ef80da3bb94019f7aac120095871664ab56744d4819316b73c10230e4230faaa7259e8209584583c73e297051d5d7860a716374a312e99bd7c3bbefb8ec5a8f19001813bd5aab8d6e7235414281078d185ff97d3c62791e725960ae08d64f4a127b4b7e827f187022cdc9330839f814cc7996ec670b1ac7ceba72ccfb5ea0b9e45cb546bd1d36af46411ad5e12c56d0d4e6aac58cb4a94a11927634e782ec729751a88d2c3c69bd799e297559b3e4b84311d7ad9fb55e3e2c742e22d78cd10111a8b6924326f55c0071db614cd289792055687f74613cfd98bb89f8d95985795a87197bbc7d3911d6945ef24d0f626c208f46a5b4b959943da252df65d7f71694f4bbdaa6fc69a93e54099c591782b10d9d54946954c9d22f838f99bbf68bcfb5fd91a919050c3598a492c32a0cc6de1ec763e21e9128377254fa0a7eb8fa902bb1c3e1bba4ff1ee7d892d94c2318d628ae2dd469f18c6a416a53149d120a4fd0d76e5e066ae5babeb575e9bd1c87216c7df35b0e5ef198cc8e4c99375d308fffb5c40b494baf371aa1734b26f024d83bf45ebc9cc4a30de8bc43bab29ceb3aff2df33389640ec061073d945f46a4649bdf8f80f56d33c841b5a48ce011c9dfa3a1f55889994209f855a49cc808d0185bfad55393834ed28645e9703a2329173df5cb9088e9fc7571a15fbebe385da3542abfee6faf0ca8bf0b4be008ade63dcb9d751a8e01a82f483536884d8180238f68638aab05c63f85a63833aceca9e396d74895e3c1b2ca6589bf84d9b059b3d268b9a412a9415bd12b9a91e1444e4f88f5635300e4a6543eb4a5cedf5b5a76e9c0965371a61206a711d0ee7408d9f82360f5525850ce891acd2b547d7426c0b0e0fa7d0f8cba84fa8f520bc55569be8b0308b6e3d443f19a702eb958de5eeac379df8e4daad8600b14ab7f825d18f1a2764c51778e0ed2ecf216a7f2a30259dcf5b7b5db5770b64bf033068aa89189a582500320f190632e37624f19807b7e7d498a5025fbe6b26ec3196de4263549d6fb31e14ef7b3f9ef5e1e1e5b788d2e76668ede7636a7c60c812085cd37e5343639766cb2d9f1821327535033d505b530356b6d40649d8118c9aefe686dcc4b0e9c9fd0b521bef652e4fda0c976e7e5a2c75eed36ade88ef0311359d03b9fef5ac2d9da33049f504d48c2f0a0cd82057b7484a3e906a4d9c6d28e66464c299746cee64fcd64e8f5dc95a1bca981c0070bfc321bc2680a0409225660af8e268644c59c9cf3a435966877b5d9c0f5b276f95d0d01566909ea09ca4e79ddd60dcd0def6636a2b1fe1addd30d917cb467d35d587ebe57e157c3a97a909277d794aaf56a5569098edb7c814f01d2ff92aaed63e9d579e8275ea7d5a84cea704c148144fa32d536c4d55a7b6b2f23f1afb50e18737e1f64117e974c430a6ab9fe33b2cde86d195badc681268b4b2773610071fa346d0afbe9a51ddb197e8f6a436d605ffb260d6604ffe72a46512bfdd444f61bf405ce02d105a91042bbe346e39963614db1dbc7cef73e47935282525d35b0830455fdc8792647ae2213cdd3caea64c9557b7f2dcf044f5a7fa9fd2aff09f576ee7c89beae0e7fd9e2c26e21d743a91f40ae6a15265c04e934ff91c4f11769fa8d2cea14df91205a29c50648b4d7b6c6db61e4abc134ea841f69bf1f38361766c45707f4e0ca087c5e29b771b0f1de61036e84dfec4b61ca0d01240deddf92824d6901256ef6bf9d0267d7e4d31232288faf742e6efc1db2507a4e663807e8f57112a17c1f566657a8d7cf3252aee2f370dd2206bdca8b9907a9563ee8339ca33692c0700bac325f3af5c0b10737b49dcc68839800cb1c9a44a6f5e5bdcc8f2cb0c5a4c3c6f3276844b506bf15e48316448e35e329979ace138c518f73c92b848205e50ff83733346e2eda5151c346feec672a6fa0bd4b4b2cfcf17edea15a026708672e833dd7cb3bf80e4d6f012b1e3318eaeb20a367df1fa746aa33be7893a09f49cd327541184a12526ea7a1a7623e98e0b97b8cef5f1b983723cf8e1ac8a9cdde2e4fa231e5612af8f656648471b6fd3440100886a2e54929154eb8b933a4ce106a14a985030708a173975ecb19d3ae085734702c6df35f1e36e01ceb240c238cc8f2161c76ca8b368844e860b926d1d3fb35f0e3af203ab5298b434260e552c4a04d8c67a2da80ee637bf403a3a629d6f84356414de785a0d5ffb4602da43aadb05f53d8958f590d20766586c746641c2d5f561ff8204738a69c0c30995bf0cf8b627b5a833c6d7441b37ae2bbd470b6e4214ff4a0ca0289871f8cbaad47c37d84d96f5c7a1091a678f88b4634eae75a18ce91fe7c7b3ddbf7553d88fe2f0ed447b4f5a86c750c79b12ffc9402c85a9371ae5a202cbc5a8f869b18d59939dadee819d6bcb0b99ed50538ac40aa5306d43d596c6cdc002255e5ee994f9d483f3da4ba9438f0233404e6be58eabf1f2340e343047b682832d48514eb8c2d915d04d4658aec2e66b5396a7b093e681e9aa7196e03e23cbf822093832f7d8e828d78f9ff9ccdd91c7d8c40bb8b6d90f898e487df4e173bedba6d2fb6c35cd241dffb885485345bc7011273157c911089b1723505b06586456bfc8baa0cd46481135bd03bbb38ee6f0aa09c1c7d66ef590054efe69cc029b598ad6fdbbca052ff3d2ac6bf650feaebb3a3a25cb64daf516c1c288caf96e607794b84ef55293b2513a376680103176493d4623ba7d219dc45f1a6dcc875890807b3da1ee20eecf92e91ac0fc76ce412346e2b2e9c66e9779647f169a527eae90b3b5490242470df29e54a84a600f4d7a403e7d7c220107223ba186a32cc671b92a219d288b35fe74cb07a101718034087a76b247e66d718258962069dbdde7266891f5a216e8fccd7200c7566e0d09e4d5728226be61eae1262cf3334fca5442e5b7ba50fa8982a9df4c554f6ba05d4fd48a295385e0ad42b7d0b63801685ee10b8cd61ce1de89ab067a7dbd3aee0052c6458ef0a521f8584f7db6e1d8b4251d3d9804aa379aad56e0b2e12639ece252329b8e81360fa706e6dc740a696a4329fcca00464a795c5418274e4b943bb888b5a8e54d3a96d8adb440a6bb3c76e1fbbf0deec75003c21cc4e4522436b2a40c948306496abce845a5d53a798ea943478eda3fa8c95646296c0998d7b00e3922f72e1493a937956fbc6e3f0456ff141ce257090497469710dd0a03e7bb139a6a53df6ea2ae0d1e45237e2b39fbdc5698438e2ab4368d404de05e2c799397f468290d2e2a92462494e43ad92c26471f61083fb5ddbf6200e49b4743d42c6cfe46b2ab7daa2e12b00ff7f8b493e10fdeaeedc0d8db5cb96b4f4b686e031fdeafa9b8a90d02daa1e85cbf008365b0131b3b34d9aa538335ac38b5a93387386926df5c41dead0975ac4c466c28dc170c4c99f69a751cef8a8b60df1c335dcc3bfaa9626b49fb159bae8dadc651d08eb17b28e2948ca85bece3ad55916566bc9fee7d081bba82fd3d751049d6aa3839d912cc5fb59e3b75c26de068487138cea457dfd4c79085248f7bb89713b265dd9af8c83a05cf57958a93f9081bac01f0834c9417dafb526997534d0a7438d3a67ef0ab417cf09376edf90a6310292e8a857d85269615d0e63f007ed7ea1ccef36a7ca622c0f55144d0dcd820b439aa9452a19a51535ecf3510417ff8cb022e4e508d5c013bb8ecc8d5791da63597bafb3029f40f4d6982590b36b2915b80eb1c6f05056dd2f5108842171112ee8e87cca0975b6aee83d7493dbe14a37d3d773f7c051dd6e580999b6e021e00153ef7b26aedf628e42ab0d198e1e3fcfd9c428bb3443743188055836c4b9243a26cbd7863a5020042fddceed6ae836ee8bb5087482af1378659ff937207cdba065f3849469e7e26d4dad74782b918176aa376f891402debde2c8b2558ca4bc603d57bcafca41d2c513f6d84d5596f6bf3acc503df9913363597534426e2cd5ec70a061b4cd0643949c55e8a74cd99083047b8c36a5d164873ddac8c0c90913a9dada926459762377fba312e56395f15e8356d89ad8d4367688eee448a7b2d65d12e41f2fd29d14c32e454129d013ecf32c31566f2b8e8afa719b95c56d6e532f6a7304e93e29b8484ba2ba7d5e956e49cfcd5521b2f99467ef28956d11fcc9ccf43af42c5599e08a1f5882f38635713b8abf30103b25c940f172a303aef904fa19655acd0b1961de53fb69e1519cc7f520bf19299a06457b524292192d19e734a536cfaa834edce9ebdf791b213e3799658205e0dba62b6eec0b73f9bdbb031f70181f168ce3f087b2cfe831d5240e8d38f267321881a4754f5c28a707040eb1558a275e6e6d177662975d35cc488cf069e3fbf3832960215bd9f06bb5778e626d0fddfb1e63f0f2676eb80ee0f1fc4adb29c8285ef5119333121df862901146116cade82f999c1adfd1da95edac7e3d9fd52ddb0495e4867421d45a6cb8a350467a0e10549bb60d03b6154fba87fb31e1fde6fca35059b5a6c478ba14fb30385eb1fc2adbb0fd52ccb2e2acbee2921855575140ec71082717e313fc0637b490b799515aa6e68ed2e3446bf112ad9539640238c877150f3a497ac4b8b85c91f5d1e10bf6fee9cdc298ef91d0c6b6764b74d0ce2ef08c0d9343333e8c8c63b3cafd67960144c52ed6706943d60e90ccaca705b0043b9229c19d9da4b0cb4aa1e82fae9886e4c3b3c751b8a631448e59bcfd0b157aa24db152b93cf092d9187a9e2bea4081d0a265132c520daf6a6c8901ce42fbf4c7c8407a364512b579b8ef0a79d850e1c69fe9e0f80b7e26b801caded5d7de3de08f87e1fd8b29e432e56f433b86abe2b69ebfd07ee9996c8a4ce2ecd9766eec2cfb21631e1cd66741612e128eb8c7b03101c246a308d4b2766cb80d8ecd8b4857a3b493475f94e2d64d220461f173246c3fd1d23243de45aaccedd335cd29590e1031f35244bbb697a7cf5bc138ab18a1659590891f23dda66e7b59bb09035fcf97c78cf14162952ec37e20ce058c7781373b4875b8eda4fc56356a1f5193e673501fc1284a7d31a6a0392560c658e1b83dbf27cd1646b7190c8da4517f85b7778fcf642e30944577663dd12b6d931b5c90b16411e841b1b64f77a876c36b4dcef256556fa4766900607e1b07068fc93a965a9963a6eefbdfcc4b20ce0b98dd4d0a94f5cf6c5b400a86c59abe1b3123ac24b6d91b3d6a4f8ad0dad3f12d68da58fa19cc2d4905c188a40366a411fbfe0413d1a3211d0468771dafc7681fa366a358949346787cfa5e01d36b7226ce33c49cf39a73c6dbafb7eb0dd0b04286be8872f393f7d68cc33199d30a30d463defc9fd5055c4230eb93dd748f849609d438e20547716508a2b8981436da9167682bbe42128a0630c6eabb5cbe8e365f34f7efe265270ff6ac3f0af98159477d6e09ac0223158f4a4f1cdec37731bd410f989cf1e3071933d2017dbb01a070f7af81cb826d87621ddcfdd6ccdaf692bd33299c08a2ebb4e0ffad5cb08014452ba3c09a88b264e72cc640a17ca2e360721b693fd5e0701c31f651903177f6aac20be519ed4ea01d2985a8870a6e79de4f1ed5e70fcbc4202349512011b8f2d4981f77a232b12690cfe8db2779d8f79f4bd698d19c1a9dd8dd7a445ca55163c90267d834982437d12c8b177790836793b408e442f0c87f10d4336f169e483b9b241245ef869e90faa9403910fa8d47e569d640b590c2177bcd33bfb2c1a691049317e7e51bd58592741dd49e07697913f9ac22037a6178cf66a0c561794ca9897496499d76c9dec06786deaf01c90cce623e320b0d5e4d34277d447d8e92776abaa2afca1f62187627da9b6466afcd4f38485a989951c2e34f6cf295590cb299b789c6a0efe5ea5c1b41488f89cf54605ba5fd0f471725e9e86b9ca95495ee0abecc8950e673559e24ba57ea02d8901259e83e86299505a6a6c9cd2e2b0d313ef7dec2c40ec4bffa42fa758d04ceeec7b6eff01d8371c8834d065287010fd0a5bb6db9310751cbc455ebc827249e418f976e6b79082af50ce95bd98de58b7802fec6293726c29bb1836bd57cd804a5611424ed6488a60d73090faf7199166312390d44e354e825648069abbce060ed8b14aac38cbe574d446fd137c8b433f540739760f26ae9b32fc6473e0a9db57043f5f7e4322fe3a860ed3568d515d18e117b1772f17a18d1c464d4a52ad1782336755dd1585d7e424eda250b286ac692e8adc2ae10380b028d2fccf34da61d381be4b23afa5208b113ea8e871503509f93ea345b2a9ce951ac294c44bcabf624a64455613d59724de55f6f4ac0b17cc5360c7b4ac616071dc754338f3e51186c3e77fcb113260755ed1658652df1a0a0e254842fbbaf0512b324cce31941dfe3a0f49027b975b6161287c84029e14cec40af2ce3b10628f835e1141c96ed531eddcff3b8bb7ffd0f59bdd9cad44e92116650fd0d53f5036e584c31c15283b3abe32366606d7073daabb323407d58a8992cd7187b73d69d3a49013364fe930a58c4039c086241e269f589091e3b8b21b2f9fda2a4d0c65f99fce2991c1db94ddb5a61fc45406d67e9fd599416fcf31d720ea200fe890e949a79de4cfe34e343bdf9c9127c202ce78f988c9a52b2a47fdc3389f3d54aa1a8acd2e01df2b4e78de0f379a92c2917a9598a699bb1ed4a28d90c3ff28c51191a062d9c9c75c37a0addce11549e0f7c62571375e0bfa75334d2331358d1a9d56621bd354aface62749fc36a597a2060174969177fb77f5ad986d3f86f2abef0eaba374f4f4fe955eab608bf73f485adc9fab2c1bf108f444f9da150984449f73e9a687fe131bd7c63198b1c0871339ecfafe73ef0af876404e340d7afa2d8040d16e0d2cc83fdb93cd27500ffb95f9b658b5dfbeab971f2506463ca96a48e0fc5c71641e25ecb1496e3fed214b2c3c359cd21d0ac5532d895ae6d0cef56688981904e2e09dea172cf07e2e1e37dbaeb7a4e0284cc2c71c5bcf0a5a45f4e3c97d8c664662c0c7cb8e34b3ad896653880d91e3aed77ed67f7e7f48cddb883ca6d02f38085a5a52f0b54623abdeae0690b4a098f1c81d5176555a4d69434be2d16a75011926dd5e44579573fd64645c3344f2b37e9736728850cf838b98430f19ab538fc2be056f222cf349a85c5c009a6abbeeafe8fde2b25eaf3f2fe6f62f962ac5c9ae13e916b04b8fc2868ea05d420cd14955f4fbc9d5d8e00bd63d17fc09de018f4e2c51dce916accb2db98b1702f152add46325c1821a2be6a08fe98e73481589c32b04ac288a480856b03ca67fdcd54453207d3e07514246ef16972b8e2cbb87883a42ec5f252004d1fe47816133f5ee9ae8a914f6ebb6132f10c19d56c393dda651134e831ed58dae367f5a82eb0341775fa9b5af02b8071d7441bc25646e83294e8e18e3d9a28f74562dacdc70f2380c0478b2c93197ee9d3c62bb188f9c3b4c67f8669e83b87124ee51a3c81194ca8c43ef24547d0c3bb182597a70abdb229c617bd1082e2513957bb056891518dc034782808911924b3efe4a142635f6785ffeed9f04dd7c2eeb9db019fa45f0cafe227229042c020307f75aa9bbe6c76c089d2359403873b156dda7b155249eee87c85b51a7437653e049851924c18bc2ca54fd68f1cf80d041ffabd60b9bf6a4bb0c63ce3a1f4277f4dfddc8ac76ca6ea09a7576ec0f454b39e9affec45b2d01792e8488db3e6330e2af2018836872d6f3d2145f8ac27c72297f6b49e237f47d97ba3cf006d766407e6b6fed7011087ac50b202e86adb6ec544e896009f9c60e9ea8b10c21da8cb89e0c05926ad290776b22cd19d8951deae4d243b7bd0d07d3556187b3e8e1bbc1a2b123fe89276805f27713d7bd46182449849107e43fddced21028fa6aad9aea5903ea15af2ffdc012a6633adcecd71b0ef4588947760af72ffc57e380bf904e03554a3ed8f89f8df1edef5a6cfa9e66d98c3a83910331ab335eec7a4923ceb19ac0d59cdf1c136d996ae709bf0958966e2677a077d5278e7afe442295427e337db353765e5e7485ca3898a814d685202c6e09e16dc1977b6807939f8a5944d8240ab537fac17972ba6aba9b5db36f1098652242ef703dd36ccd2958941d0eecc93fc4efdd3c73e96862be37e42ca79c1f9e811c0bba36848877015c8c4b69d4edc2b65c700dab2107aff0f5616906d34fa6a551e4da6b3deac3ed320ab854e66ce26faab4841be91b26d62038b6bf5b060fa3ea6b1f719191fa93dfd14d620b2a36a384c3fe9439f18f5f52213e23e59d7a3cae11e1b46f7cc814ae35b97b32a1e989120949fee8c7702f1efac937ad6b2f70ebb8ac08234bcd22981d5146d6ce3c2e9304a20cae69525de4798de434ed0648ce5ce24d3e6f5d7120eb807edf6b7f5456a687b7e49a56b05407a4883af6c15f63c99d96897d85aa631dbe8b747b6125848580e901766bee78209e037f513d107c25e88cc5640579e2f0ec056bf99a5ce3b6c5c86be7e7208b43b452d4f27b761f23cf6a1d500bfe77abf3c1ad9fd4621d76ab46601b786f20bc3457771a64bd9980a616e4e6ec60e4dc4ea1be0a4adb9ebaf7be4b797cc3d4c9f620ec646a01d6a51a940ac3e55d962b1b80303766a5f5d3f976aeea1291deb0043f637df8c0b2df642a7425bb5ebd5a25f0de40343775ebf8f5db8dbdc04cf1afbcb1c02024666a66e6387d2eda0fb6bf8f10fa3f54497f16dbce738da2f60f35c3dfc503f942cbdd667280256e8ce5432341e4e8f5d5f181c1e45d7bc4876e15988126c737dc862600edb5a16efe08b1fd0f230049ca1246fec2c74fc1c848e4b85e04654a7a8ecb8461eee4738e9c0fe1ac619511cb6655223da5edb3718975e2d3fac4f56af96f75877d2c7e3887c338bff108a217906a0e1a3f1cc56c30e20137dd812725faca913a69fe8935c521608955314b08bb7e5c7176e51571c37c720f753794939240cca8eeef5559b3eae664eb9d8a402c8634d6fc185ec15c5d33bb0e784b97e6b621a176b9ae74b1cf0ea9b7ab8bb532669f436e4d6cfbd9cbbb20831447e28a9b2d47e12e41c33a2209a253ca0f55a6654551ef2da0fa32f9274a6fdaa98f6041db6aa148c29678896af5cf08796d5ebaa260bdf7880375ac5ad13d640987bdb8ea823e742fc07da156114862c367d5f97b235374d6fe46f7fa1e251cb76b481b7dc08de7db15de71d3c30aa777520dd1b8f6ae32a3b158b19f467158a291c146d183c74d173be7f16f23f83f70b91cd70582dbbfeb36118ba9241395a783057e611e44a5bf2cb9f08c4dc12dce5367a30d41ff9dabe24b499edc4ccef0130bad4d084e47c21f4bc1a07f74db936c8dc4cdc0d94869cfe5397ff5f986dbe3e0331c880acbdf532af7febfc4eec5c870190c9bb6c2c79fb2665a94ccd0c6c63e70991fd64c1f37e2e7c61bd6c5b0080a58e47a2b8d707fe127ddd758d5825ff989f2344744d691d72e67ee300cf5a57c03e636e254996eff6faa08903dd5316c1c7df6365c20e0ae5cab2cd599a4c7f8b18baa1a7a26210db34e5d85d5aa9fdf7413f00c31b870a3450afd96a36d8b91048e8c7151c1c64ce025cb9c5368d84069b275a2fffd45c42d21f92b5ad042313510a77b033f66ee16a6ddfbe0cb8e677997a7a6630e9c56143923f9a5162724795621a02ecf64e6dc609180776afc31817d5c7ef02823696821abbff54305a87b7eea21149857071e3da8c289d8dbc34bad3a19bc25b350a76bb6f9a5f05fa5bb1ea93281bfa30b2eb8ae01970b8a6b2f002444b267b3a2396090a93ae91938459f03be4cdbacf2772d35e87f399f74c50a0ae985e9342c56563fccf88e0fd12305794adca715549771d8957360efbc2a81586f0efafd71a35de1dfde2423e23427c9fc8ba5351fcca89e5ed76467ff7858c2cd9b43ffad691161d7360c2c4e5fd0cb71f2ba11afa3bb07bfb54b86248a2014f53fe0e859a53bb19e41397c292f32b59555f68140251cbbcbd23849195ae37381fcd48238fe8969f715e615bcf4e1b0de96d8255cc0e88c0330c134f5e26e0b3dfb1c6922b93410c79bea403a2746654be1e958df0892bf8c618e474ca3d757354d4423bc4328bb4240ccad1b84fe05178f840317e323ee251204feaba0bc6e43315ef131073279025bf2a63e4202ba695c7317e39edafabae0ab6c2ad83a3b0f2e2ec99477893abf6430dba558b5a3059b17a507239e97381f38c53349893d4d2b3d73c100d8653a059eac1edd61edc0b1ba7ee10c8f2d480480eeaf7969fcb290319ad16944fcf96136c29b95f85944a3336fba9076e6ae580918f42137970b3d2261a7a4a094c6cd70c02b3a936615c574ae681ad11404afca493beabad656cfcbdc65202f23c9b41b77cecb5f4a107c98ed056b254a1e8023c55a611e88da61ddfb53169bcb16f162ee5a5620ea020700b50dbcdedf1c6f2a65afb9ebdec8018115315a4483c726c0ef4b81b4f45ab9cf32e881fd9a3782c8cc329f59037f6bc13e869cd9610c452b8a00eb9707e7fe19bb9ec080ce14df8f99ea38abe67ac39f97fe9b9ce42f978f351e8f649df432a03fa0a96ef4146855d3bca45166b6560d2f40e4c4edb1be2d16b7400e59063968429107117e603012b19c7bd4207131318992f4dd8f917ddf2680c0fd24636e3a31f254c30382dcb1c457c17b42dbe4cf13d310108b16161dabee357fcbe76bc23c36384d78f7a11f997e265af3d33e00f4e96e53d67ca27552507eebecea991181ca1cf80ba92c6f605343ece3f00347210cf3cadfbacced3e51e6d8f636d88704d210328b1bfba905dd40d5b1b94fdc1c193ab213059f9465a012ed230e84f4d1ffd8610abd05d7254a3d2fd6daa1678190aa5ed60340c6d1ad8634cff54d0c0eedf22a5dea174cf1ce6ec06bd26386f61000e21033aa322cddee69cb36392565060117f5ac6020d77381d092b403186fdb2e5a3475c003b90ab76f8e43b96d48d7bce9e25e014ba87842532da071e99bb551fe9e66f9b6c11ad55afa857bb02a21d0912715d20264fd90a3e4e91a31edc820bad980bf8c297b56d4298c0c333e063f0082140c0a2e636693d22d0390c76c2dede63a0ccfbe8fa75de6db9f605c86181801ddc98628412b3a74ccfb353c94f2d5c6ea6f1a42e1fbd6a6819921165f4d6dc48ba1eaee979a68223ec899d591c48473e37478432265debfa3b6c0e9c68664e69c333a20f35064c1e94df43f1d00042f87b6e8cb619b5b768427f006c591e888f535459eead3387975bae4c2e8d940a1a1082a22c76ee0423b66cae01487e95948084dace72351c099f9cf19e2fee268e3c7690686a11847322335e441ea04cbf860dd7e5b766ff6c9cca4495464f88eb46f3c80a6bd11b003c5c55d0c21c6092f3048565cd7f76bb15c36fbc45226db18ab0e19a3f65bb66850563bcc34f7cdf7dc156ba8e5bf12d1457433cfc4b6113c8cdf28b148f6292f89a56b1f3bb44c2cdeb1f41e7b9ab6eef578524d031eab2219139e6934198895c2e28e13c9653f58c2eadd870f3c2ecd8effdb72ab80e16fd5168c820ccaebce079cc25131355157cdf49036ac13338acf89935bc7289d8ec51fda54fdf5df7b7d32dd626073e8556343755a0265e54b1c47aeebe101e342b98ff7b1069fad34a35e7542ebda2eb8bbb6289185bc807651e2a6c195fd53330611fe6189a7807520d8637c585da906807b0e3c18cf23e398c2468e64e6859a91a2b0c6f7aa67b702248a0bb21161013fc004e4a0a8f9015f6edbda904debbef9e08f551fbcd01d43f08b7a1146d268c611f99431a2a3ff75f2fa70aefe814cadfcdccd6e0177729a9b9fc96bfbc2bdd3d0468c81640f72b8476dbe25faada33c4d79bddf42dce77a436eaf1e62d18064860291be668319278b7a449a23cde49dcb7dddf1a9c63c9960cfd0bb776b699f9dffcc29c287fcfff5ef1599173718e7e45fd75adcecb2d9fe0323d6978aedb65dfc9fff085d1d0463a20d760c7fc8633c51c95eb3bb7e29c5d4c55055a0c5bc2bd67d8faa5b79810aae420f3797ee1c7c947a75c14beaadee495978340e59c263f7c616be4ad3445a078565e5aebd0a00129e981984a7ec08241c833c55014e196f1bc97a0cd581b1fe142197ddb360e2821f5c73fb8886de0849631c6adc157ae4cdebad13725bfa58431faaa42eafabba278f78d164d5c1e46f49ba3ab442b37329124745216f55e54b9952ebc07d6da53ed24a605382300b57c4b6ae67bc2ea6e2ff58524611547cfd05149f28200c225ccec14b464b65d1c3de4cb83daef754fdfaa8624b8b187377960408b940390dcb1c0fe8bb7ac9ce543eeb9414cf4d717f1e48776a605c57790416674326ffd8cc2956f4f2830235dcea2c424fca3b16a845918aeec3302470e909fadb739f9928adb6f27614601ef7605b753f2bb14e36e866ab9704b82512aa37d56e0c18ce0d52dc11d243805cba26b8bddf1a149ff4dc4e1c3fc783a5bc4e4d832658d44a9715764e85dd1b868beafdac05a9b48674e0230e54e8d11b006264567e871fe1fa2af24fb1f97741a3929104a035f9dc0413c8318143f493c767da29b7dea3877b5adadcf1cc53c0691c41dbe4404292c30979a50c06169fc2f219abc147cb037d2d4913d5a85963714a2f56d6bf45b8bfe819de7cd55498f89459e5a39c3f83edba7d048adc11c5c6d1af30f58aaa4dbd2024b8931935a270bf4b337eb9fe40f31b203a61e2fc6a1791636ae81a84a1d4780623e7b4b741067e5826adf97ecb8e86e9329c7706c83334cb0319f8fb12c5b114a9bc07bac87f1fb7a14d6f6e5ec3ab366d9e2e84e58ff24cfb9890813e23ed6ae9a420b8b9e048e708279f009087cc0ea0ef4da37014b46fa023f0cf152eea9e47c603f62940cf5ebe3db9541b9b809fb2af836b718c1351c203b0fd5ea7aa2a67776c4abc0bd4d1e627e9997f335128df47a94bdaa79e039f14486063c9d7a75538f5a631a43de1ef8227e3241bb38b3bad0e8555b2cefd41b4e1995f4aa16d0654d3fe82a4ab608da6cf4a3e0eecaaacfe6c75ca53242eab3f58bc4e725693f5f0c4a31baaf7b6a6a84cfb8745571eeb4980fd61256ffa3ceae1f16ed71f54f6dd413ec05fc762ea39a1e8cd1fea7d563c2b0c7f757a949a6e18f097adc1c68cc82316c6c078480b1f152743d26afef12e2a073b9e4d0ab9299f81a298a5e3ddf237b255af0e0f63b71deab342c7e20d7b9861ed66a63d7ca12ee0d50bbcd98f5cdab9134cfc3ea79405d98ccdb4209dab6b28fa3482453c2376b5a9f763b808628049397ab4f92a105cc5843b3d115f1a55ced0685a0f0811c79dd0f5ec905957facf852ca264cc04801f781531983d12a37c738e00c802322c730c85c1b769d7440360bb5441f3d265c06f3eb3c98946c9d85705a2ebf5bbf61ae64e7e47da939deb50a0921b48270b63ec57e4c8dabbc79bf260e24e8961edacaacdd7e3f3735caa6b3fe0b3489222d5b4b64e189b2750f45682f8c74d6e7cab6999b0e9dc3f8a5d35c1dda81192b9564e000bcadcdf1cb0245740468a716c22f998a69777e8f8ffff6b5e644719890004454eee0118d03fc34c1da7977da0d13b82a2ef2fcc7c798dddbd08ea725533a0af90a4a5eea328f90e3c2bbfd13abc1552bbcb205f0a54dda6dc983c4348322569899dcc52fc95dafca497a4766897d7201ddf0eaa8bfaeb302c7f8db06c50f3156bb3c3d5ac9e1013abd36e890faff4a4ded707e82ba5f88eccb92cb45f74f389b560e870a310cc159ac3b1884addbdce1f05aceaba5b0934cbc3803d780be1184a695c0d4e3f3770bc6db173623f6493f0141a11ae0b4fb1c04fc4c359361947259023a13e67cb3601f3012738ac49b061e7813676268507930a66dc44906c0a9b1f3be75380120af677554507dc3dd13bacdd53cdaaff921cf05edac315b0a4625583928d9a6cc4ce28913aeb8cb218d61a3270f01657cd90c016995b742a5730019dc309e0400a8747ae916d8c2b3aef7f85e2775a1ed7ceb068fa92634a1c9a3816881902f30f24d014a5eb322ec3183560d09543b01c92dc7705d03a1728f5587889be5e0ca2b72159daf70d477a96eed94262e456697f63a9cf33eaa4fc220ecd9e013693ef0ae8c784056abbfa52860ca5651052de66e1a4348712d972f7b966170facbed7e44518b540a82abf0b69cea652bb0b64cebd1f51738e5fc1646b7534b22f13024ef07586bdb79c9902247158136efbc121ca3106a2916023b106f8f214b788f1b34c2521a07a6f16e3f1c4be788b8e7dd80acb7ee6abd200311e8dea486ae63a4912afa223782726c900e9de7c9c5946be511e2a0b57311a3be5af237449017c75a1ad97d4075413c173e8b40bd9382e07a7680e9670a36b9d4514e8b23d3b5f1d5c8b391837f897bf8602bf1476690304ae2d11f8f5402e075ee2f9eb44139f236c75f33b012a48e1d91e40ae30efa655067ac0c68d476c6b334fb8a2948dd8037b21a4836464e83464583010fd2d073e7a75dee7a8d7fc60cf72b74c087c3bf7b17fd72b80ccc99c5adc14574f03ac08bebb5a926ff7de9b2657543878ae06a1dc8aa87fd4dc414b6036c4ac29d99dc0d1f083e767e3710c0efa0d5eda342b848af136442ad9a59034c1f27fee40aa87b697ecd6d0b85e8504bee69e4ff1c45a2a259f3a9992ddc681019acefc8e2bc01a22e361edd0d4051e868959236944f8fc1c1355e836e59fbc3ab5906df7399142667bf9c9c6dc6b8ac2d17feb1d06aaa0ee7b3257314289956067f8172d4a8474f8ed433a3044087ad07403f433ed40601db205e123ccdfb033840e15456e21d55f2cca5e4533122897e87bfe57e3b0e21c61bb1ff1294f5b822c7c82aeb6ee95790841741a20c89572948539d7864957c943839d1cdcbbf69653acbd5f668d00f0636c79eb06c6b42af9ba5c71105e23d274c3cf3b81995ebf6f610f3dbbb3958fdda55bde985146af06233998eedcab92435e0b3e2d18413a9fa529675684e8c5f0ce50dde26bbe7bfba20a9b528843bdcab63c7aa421dbc7e537e4c64b78c28e0a0626054ab0b8def00052e565edae7f1d6b7c2f83834ff601fd6ba74b0c214c967de9f302cc7e06ea02ccd9aed5eb1f706f0939318cc3dc290b03974f2c6f31c214f7130c35987d25e0ee2ac06ff4e707b22779991b9e82e32bf9e4aa1e223f7fe83433bc5932d18d2c27ed90b9ec5cd66e32b4fe86b9513c82387a1166c601cc03db080c886315cb34eecdad692888e08fa706b18105d3403570ce78f8fde2bfdecde538e0ca0b94c5b7f961018ca94ccd47ca46e3cca5a1f03b2eea75f31c7abbba9ceb521fa6fe40084dd08bf60b0b5d74a96fcfdf2c4972549d92cbabed70feec0f7a3b8021018284636b186dfd80591050700cb606e1b6b86a76518bf0471f6bde1cf62b2d4244277212392cf5018c33bcbb4559b5e33dbbf112e0900c6c91a201c62428e1039ebbea638e1ddb3c19e543571b8b335d1ccc57061e8d1e43cf6af54bbda3f1542803cc1f4097e0fcd24243dbda4bcb782b875eb1eaa21daf62cd5ec0f320be1917053cb5008eaa09b53e5f5576ed49787af53979401811c2288c19699eca3ac9a97c3aaaa249be25e1128cda3360dc35fa7515ee6156890efef192ce2ed860cf6a3ec192c0a4ff5c67b72c4c2c1da782a2b4031f239d86e0230c1f4ad7741c05559c221daf30673f5b95dc813f2a30125a324a23491ca70b5245af71ad0f96cbf144c78ac56bba1c8f2f16d1ada3b2a8d2d069a84198dec9289b50c0a1238fcf082d3f155201b208b40cbbaa7e49783c20a824c676331ab1004d304a26d60ba2bf5953c937cd6d05f9aef3257ab21559a0f72359b16c5f881b001d7bd85fd36ee9b57501a8362d9f693a6b0cd977f28de2d88917f711815548034d1f71dd17647181276974dd7c11b38da3e8b61a74b4e9967becb0245e02d2dcb5a0d67d008b042da0f4d817719489a5820433dc3a8243ee881c5a16f0275328821fe2f104fe781fab74c60aca58700fd441c320e605bebfca2fcefb753a6c281e1b5bfad6c3e5c9905a0858026a4eacef4bf93c0c9c6f0d5f188045fc9c26b8da64ecdacaba69cebe46db9492668195b006d5c50fb983fab522de1bf99b19916ed7b29c8f66c0a3e7716838bae31851fe4b41b08edc7c9399cf248c78fd3459ada971d1d0edf8e4bb34ded778ffb880e61b9ce9bbd3292c9cfefa4677ef1ff22e66a7066b435b179e1756513e3982aede68024e4559a13ed39d1db70355abf88c4bf4b63b78427d8d58ae71cde3e8655a16a686887c9bf162f945e5e41e1310d060110cd42a7071ef2d40e252505629d157299d0378a175c3d19b5bc8fbb9fb1aa2cd301cafa9b973148f453e40e6da38f934fed6d9a292cbd11defd9f38ae1afb8a985b798bb1912b41ca57ab737d13b0defd96bbdd00dd74aa1c299bb311105bb741ca879b4288f89e1cfbb30fd83572848199bd7804438845a10b997b6717aaf810e75a572b2b1a972024cbae7b050dfcf57ed77d685d9d065735546b8a3904e20807c9548cb893595b253eb559849b5acf10af05102ff7674bf7b776031bc14273970596e601146f5e016f04beb31b8592b1b5f9310801979b57c7231125be12134f97ad2548232c4ff398fb2cc3dd03c0cac16bbda887e79c5addf70e2133e78ee6cef08a34377406430e16335d4ca523d257c96c2dbd1e97f316581a8048a66217132899c217ec07b40dd166c7d95b4ed41bd59defa79e02ac1b17ad675eb1aac33e12e1799c4998c8fa03658c2a5b691f08228b7142180c578e6577ea757c92c409787d9104a5844e14c86713bb978a60b6c0007e173108f9f5c0af954571d6c056f5c59f6e4a85ead7f29759bd94ad618f9771a34703242912c08e0f6a6a9171c1e5f866e702fd1bc8e7116ce80a3353520fa55be19634582bde0c8418f8ea245b4f8dbb23e7cdd2197ee8544db9fbfbd8a7d6ea0a6c91787fdcce768276aed32060cf36bf216d6d3050c5b3a59359117b05ebcf27949c6c8a208b6d16c761e0631a7317d2a914c231fe953e5d3259e9b49bb99a06bd14442013253c11493a29eef930e8cf4d1f8d3a5d88c2fd7cf5087dbd2d755e93bc7938bf09aeab1a8476d298bb0ade2e097786157e865a1a967cb8981f438054f88c0e0ec77e097df542ea4210a4adee610cdd4dddc4953699a9994d3c719e3a7e885d90ac89dc861aafdc269f29e633f612de9075ebbc39c7995abb0804cdc4d15449fd725f61f594bc12eb575ffa9c7ea574bae128e27f59d04f5245f274d8f8ec63d0a0bdc1b6fc0dfa5745af800dc1b50cab4274af3f99a5923fd3eaa9ca9338c3cb23ec033c44bafcd06e84809b27e700cffdfcc9acd11653f015e213b88b70855bb9985d05594d759623093e5ebc9bd3bee108454d9f2d5dbe062ab8b6763e142fffb8ade521cf8cb979364dd436528e583c7659177ceb1c0104e825a0cea93025c54b3cbdcb4ae67bf4a270b483c6c7d07b0936ff1beb5d19036c357b1d229734452e1a3f4489d364bc2d294b1bf826fbc508b470de66533101c5d1eacec3b1d736982d2b8ea36b617a6824c786ff6d89e6629be3b71211177c4196f32b586e4b233ac52630fd1fef88a23c31fb2006e893f683354de95adfd1bac1a3973b42662e0eb7db9be30b56e109e554dac97bb7792d4da27559040702f1ea3d90d4bf2b16619023a5fee3007806f3bf869190a821013ede19435260db04c8d97162b28bb27f76bd0b7d24edb5090ff4560920d7836aa929c152669522018abf85a17d37966d7adf95b231be45d0e3826020b62ea90549735f45fbddb9cab717d5297cd3969c00742344f33171dfdf4be0f5492d09b7bca2e5c5df27ce586daf727589f7a77566461977cf14df41d1183410a3ccf8aae7cac0efd08cf7abba4da69b0f30f4c9478b418d68ed6740a5f1d18215be16ae22c5eac055ede3345ab2b620ee8316ea2032d9a292602cde83cac825a8443400725a678ff1e4b3325b9c49b02a7a24e7b49b08f079329d14e6857a96bc81d4442513de9b8d441cf18714b734bcd12583ac02ebe44e1cddfc46fb3c9004be35b99506fdb8e84aec6801085b534972ccab7753c0cd88e52c94a94d9ae06ebd1f579e0ae19784816c9adf97662c232534f177efb7b7b49766c53b73ebfbec23f934aaddc3cfac744b0deb265bf8aa74d7e2c4a7211e229163c814d14770efe527acaacded81f9f2db6f8df468c488f174c83f25ffb927ff7f58911416c928690e214fddf5be5f0c9db2ae979d2066395a0e31157208971cad92c3cd8872b348501c2748f88d1296275d61af75e532f4e50c1b010cfa98d5c70c8198b5582ab6aa0be739e00a4cc878afbb5f22c4e28c56edd361b5f0903c5beae759a6f4cf9f595298404630371cb1689522a773a61cb63e676b0837b53dcde50e0f221eece08949d02879f1898b89c415341d1114e38d6ce62fbed8b968e2e9fd87ed6cc8314de4471c3527cc664500436fa9556fe15c59ffedd1f2748e412da9c72c2f4f9686186e7849b06e1b4c2ac8dc9470d24132a73416fede556f8442a19a0d4c4cb7ccc853be7c92deede5d3aa6872e922fa359a37bfa1b4007f341f71c6296ac4623d4286b7a215dff11535cbc77adf21d6b079f59cc8adf143b94d228cf3938f57577df488bab5932dc44847a1f952d7a502cc2bd94a534212ba951862c9840d2407ea12b6cf67f5ca57c8c9b6932b40a8f35d5971ad4cd7e2ccfdcf167c8df2044e861fec28e1a3a78756a1decc97a8ba3a42ad5f9aab834c5f60cb4b722a199aa78c48071ec8440ed94b5a5d904fe4c25196e32bb17354a41ec14f4fb8e8b257fd051fa8b1d30be4dfd948c711925ec946fa21a3218bfc021e0a1da04fab057b7608cca44ceeb3c22d841501d2c40d33aa84395b7565875b4f3e2dd651489bbd248473c02cb1af54acd77113bed8b9016f2c77247e62f29f909e53dbe06bbd4026d91bb9394445c04272e3ec65ff563a1beacf5c685dcfbd8fc73e71c09bb45e47ede6b75f50d9b616bfb2c410b7b2fc763279d96eb8706a58dc0e662feec883fd907989a526ac0ea7bed4422c6817943fc03aa766aa410f99f7119aaf8eea6e5ccc48b4d239d38fd1990b6a504396bbe97f5b359af98a1f627b5fbe91974dc92924b2b1ad14e5a0abe42274b6c48f8f1af8a38cee68d1d134e2ea103eedcb57f7163453a309e3e6f05fe29356573b11eaac5ac3bbd1dc42eb36789141da8ca52ae318860e9dbd4bf9187770af5ca70bc369f8300127c4b16a4c352c36cef2727214ebfd5bb1cd80166356e84f77e848062b90a834a28c13f070209e84c8a079139d544295a2bdc14e14964f9214186b65685c903464548095269a9de5adb07e3f3f915cd176dbefe7bbcea75eef8822f89eaae03c0a3aea4354aa2a89a71a3f6657be9365ada7afb260c38c9ba2bfd0386a9b02886efe940643473f73c6ba92f4abd735f7a1ae6c462f88b4e469bf1ec7db0308cdfbc289b6e2f8e19b9630da1a4e8bb59cac5384a585ddb19cfa57c317ada1b367e459036ef576e2469c1649c777312a18e24f55993d1cdf4a9b51afbc7fd3a2ba4ebbf1935b5aab82d662e8ba0578f59bf8602715b90c96969682f4b2429e8324447bf3aba844df3c9ff4c69fa9dd2103cda453f0cfc371ed3db9ccfa72ca4bdf05b54c93e439855776ebbf86f11ab57641a99dce4ca85b5f1ef288f2c450114c19c0d770bd4285a91b48e45a7622db13e64dc417e83dbc0ccac1fd2c6f65bc58a23429d4ea65c3026373d7554e200e0a4e1c79f7134f9d6027a8d6961695223070f5d4e65ac8c81f7150707719710c68533a89237ac278959bf99586c35f02770ed76b2a339cb15c18c99e1339e4ecff758a01d77b45a93a9aa3f3a7ecb76c0d9a771df2ecfcdf855ac4606ddff63199fb19f7d4f071bc094bccdc2e610ab1f55b6ceced8fe3468b67b617e957724c2d50b51340cddd95c592dc80eba396d88acd39f51bfdf3c442677a2ba07a345a99404701f2439f7c6b3ad4845791c2a1d7c3e350ab4266923a24375c61b7b5f1670fe455825f21fece54775126976f91e97c26115d04e6b79a3c5818b9cb42de11360e57c14883183543b5ff9273c8b754e992f56380c8db6228a0026a8c17f86777f1c290d2e11ace883a2f0a83e315f74318ebe0cb6c1b4be0343963c8116293ff3be1ff5a3ef08fd300a3b5e75f966b2411ce53addedb2aba3cdbf588da515327eaf490c9b0335ad0f58f86d37b7a66649bf0d8deed2b0abd2e028de6410b08072ed3747e7cd8a91768ee6486f880aacc020da36f19b4606917a34afcf5ad610389df2000ecafd790214dbde1fe86c8bff97169d6a68d2e002b8aa2c1834b1ad23d1b60f2ec4097fa479d6360f6048f3d8535f0b304b0f4f4a6a48d4111ef2a2bb4671627143ddc5c08e5ffed9fa753145bbf36c0ebb819b1fac878659777e72cab9d83bd38e9b0fd8d5c5d06d4eb4d87281a1a98a914e3d4757cb1274bc10ca1d17dc11968df3d354b36d0c4dc46a5b9ee91987127268bae1d8173525fea5d5b8afdd0a0832f43b21853c57af1e0ebdb13ac9bdb1b8f3dc03a46b04267428a3952f4935282a14de80cfdf2808d32c199da652253cda33a60a595566ce11d0ca5f04e535907136210340bdcb796ca4d936766d06fd5f17869bde73ea9fa01013f6fe7da82f3ec595cc53976861678bc2e18d3bfc160c4811fe99904da318432d33712e23c3637fdc825e0c26b4bf2716ab444937d954d14a7c40780a28ae8ed52a9efdee3e2cdb8e6e5da550ef295f75db9302b1cb7347111c17abadb3ade23ba1fe2596d5e0ce09572dc4e364635f9cee4d1fa31013da7dacb64fea20f1df14e9e89458ecfb0744351cb02065befac2a0893b751311998eff709b36d5e54d9a8553f6b2b05ea838a4c65cea8150a45da2c871ef6d5ff9e6c94ac0a51444f6621ef8e5e7869d89f6b0bbc6e73fc5c017e1ed86b82007338e5883e5664b7aa8fecff38bacac33d558df35e2c68adbd87ecf1e87e870151d54a6cbaa95a0b84b1f94266da0bc5afa204c3979381fe45d7b6fdf127f060638792cbaf1860e1f7ecdc66135626cf396c66c60deb48bfd087b6533282032e4fbf2cc607cf81cbf29f42ce274a7f3315daa1d0ae97581e29af4a553716e7dca71c626bd2c6c1b59a86b331756e8bbade7bbf808f34f5fe4f792ba7e32591f9403babdbb28fc2179cced148bb4942021d91a5d8dfec2b0ff5b9dbbb665cd368ea7093d5710522ffe9d6e13d3daa7fb05267a2ea2983bd7f389feaaa46cc4186d014e6f849c234a917d9108438e7714cbe1e61b6e11a0bf6555a5e18503a7c207a34b8e1f2d312eda5699b1eca3edb76d4defd932d9dc7c379ce6006551ebdf787516292ba5aee69b9fb4db962a78d23641d6d9b47a973e7357003b2e28d709dc93af35b41d8c2beb6bedb65f8efa6c6faac75a09846d1dd7c4f4dd7dcde780ca0a22b2a5d207c8655b92cdc1354214689bb1c2f686884307ada0234c2c6ad677ee83e1765345b438d5513f344439c190462d0e61157c0dec9296a8f42013f914ef54cbbf0c83e61d9c3cef1f104915b99ee4a2741c2561ab6332738f8109718dfc6247854146aee08960833513fcd21913213fc9cce1ca7c66f36405f2b95bf595305e28b17376ddff980bb0a1b6d757e3e863219635a08be5d1d88f8baa535356f31c41b42f27d8a931953c51865b073445d1581de1518eba4d1548e22bc36072eb6082ec5b624298ca397bf6297701f4261836ee1e6c11545e679ada8887110afd4be0b3fb7132b47298c922c5ac8b25033236d0e031a1b6ab6583469ec3a818337d9d9051d2ec8144dc007e87ac3e859696b0fbdca0bcc4b246af765ba54217033f5bef397b954a387247c13ca87a918d89edbc91b6e5abbeb3f9a73bf4ad2bb9438b5ef3b55d62bba10c7916dbbb237bc2ca6b19dee7b9c25601c585fed51b6635d9330988e86e1fb1ed43cf701474462b885340d28f04f329d9d50f5bf4c5872b24afc1af880144cc5fdeb884c26a4d7eb8f6c95a5b70cab2364fd4b179f314910b489ac2c755ab09c6a756321ad55cd4ddc55c56db360be9911e6ed932bd96e41e92b3d824c3e8379aa9cdc04c331d15c9aef51e7eb3939472bd453e123952253c9d8e11d149049e2569e16c5a478ea5c9e44ee3f2f57050c4e3fbf2b29a7ca42ac1476f3798b396476b2e5c7cdcdc9b67446c5a501196cef841def614524a93f6c1d3cc471d22f7e594fbd0469084020b1d5a5dc2a4406df2f98e3c4c9f0bdc338c1f9c40b21686b5c7be0945a121f3351edf45ec7ebfc0270b366f391afe2c009158c7869d3a4c2e052206d1db6d5f8010357cf0a745273857e7a8e4bd1becb71826530ec5149ed676cc1d53fbe76628d651649545fa3161bc3002f1a1ae1d5951af76a4b7a2517aeea536842510da2e83bbb5577a120e7ce104bd88db6dfe9373349bb960c9abb9032e711be986d3fc86fdaf2542c89f19901c4410282261f56188a3e9507f0e9c055be4eac9ba2dfa5e7318137fe39e993a2156fde873f3a847b7c0fc89cecf3eccb08694def99efd54453be4c5ed4b5c5341a3beffbf997cd1b5ba59159cab8619dc7d44450fb832aa2422702f0f4f9bcad9e6d6192c39416605147c7ad958882eb4eb978d33c4de6ad86d2cbc74babfa5dc0b6122cd487edd6e872dfb491d1610a3a8be9d83ad333b61368ae70845ee29f04405e8066035a8341796145aa3c210ceecbc33c222c82bc992ca4bed74f6fca47503af566619765bce1326335eefa40a3f50400e8553d1ec665fd04b9de57c1e6726d4fa40a62cad4d03b001e8ee3018b0eb00b4744ba7dea720a2de1f238cdae4609a43e28be734b0c702351651bcac7c8139b634b015277935bf1d13611f072659dc9f4f08fb561d5f6f73f676d49ffd2342e769d056e902e8d5aef442ee2264d942d5968ede53d538a0c68cc42bfa11b6b103623a34c1782a850d149c56552b41c565e1770226eb8c06b0c0a3387c80133ff2b54b2198eb8bb51dc8aa66977d132dc811be9c8b6867be696d79c3804f6c329cb28e88fb984f9eafc4498d61036dd8e169cfdb39ce0edacc9aba2f40896e59de65b5055fb36e80894347fdfa0721b32f7c130fb073c3f2b661b450815e7e6614c728794fd3b94b91dd1e2b88cd79b23cf043fcd8f15c0c27023e0dde36bc0a629f6a57f9b8a9f0f441cf3acbecc512ef9c2c55df6bf587e1bfac58038a161d607bb135251893edd34712358ca735ea36c6f0278655e4b69683b9c3269e63d0f35c09cde719c8ff35267441eea1c0f400d19228488d9a3d897e1bbd3186e8762abce7d766e245e89a39c79b9f7cad223e3ac22e161069a19959aff7a83fc8c8361ecc82239dd08f956ba8390f09c8458eda08ef7153081de5bddaa68b5ec878722a68fd9daab3f75efd5b3655077b830c0ded86999d2fc2ff9775264cf2cbc29e48a6c8fa0bb1dacaad7f1aa2c1372608855313fbeaf0b7826b845d93cc3cab46b7cfdbcf757447713253be00a98c5041a7ff68877409a122dda34c1352a337371b2b84a6b1337bf887e502b7ee7977d53dd25d36e97aa2b50e80b5a8a2d68630a64da5f13b9eff2a8a4229945267204935eef44d894b62c38d9176bd4dc9ae2bfb9801365eee244fcc1121ccb94f58ab767bf41148a9aef0495829ed81d0dc2464ff49288a4027a7f489a5f493b1064266e474a2eef89c56e5c2a4685c0605a29f20fc5f4b33ba4910ab79fafdd87c39c7b3bfd84379b9848cd84972116c6b57b379ad99eef59e52bdbcac83e81670728ee27d935b909c95d28ce0d4f65b7a4ef51f8671c2b36d478da02c9fd318605f138e3d719501b55bb02e4812a725aaa3d9fef8ff5d827870c5f41f4247d43f11b052c317a659dec6934592c45d52e6a3c8d04dd1cd61256d0800951bf9b68f3e02d4b14569858103feb7220ae4aea304fda78a968574f06ca8a5b2f8d0f71e0c7e59887ca4a48b80d0d8c373d99fba71420423862787cd0efa010987968f2b9b6e133dbd4e7de8c7dbc2b41dadd2cbf4a2c42102b0224aebbacae876f4a1ad270499141a8da229ec02b477d88a5e055256700b8e975e2fc48e8006546b5668bdd48613098bcc8aa55962e13660d1292316a6bda8f9839860c0ecd341124219e4fa97574748792984c1d333b49f78678e709b1fa819252fe000e659db53c8388cf06c130b8976cf526e73a2b488b12d62774a4a05d50b601b437d23dfb23383ed262ead0e366bb43520cb1effe4dc191902c155acf6643deea3f38a98a34768fe16017c9362cfd16b7819b87c03813c87b62b1c1b508e0239178b57a4a3c709749b4ec047e1d832728e6fe91fbfddba7f0369d69464c71a597aaaa9846f67de2bb5576eedfb219cd9fe9dbe4e84615c7ed68a19a5fdf5026f4ed9375933d3ac88bbdfbd52d5b9283b101d133e13d11d50933a1ff4a4234e7c8004125da43e5f813cc7db7acb5406827f9f28aa018533eef18ebb8454a88665cdfe4ee331c60483cec8977cbcb4d1883001ca492a353491677130864f1b7de41aa0adba4b38ce860e21987342ecd4e9dbfa66f654803f54d7058ec9625f4bbdf130376de1a43d57946e5ae35b0cff6874bc723ee4a0e5dc06967795bb2392a9f26145a967104ede776e8381651bcfced9a0cbdd69b41f3695fc9d1efbcfa4fb8d38ca4b1b3e726c15bc1709684d15672d9ae25e6e43a831181309a7f93abd36d5b784c074d19169fcc3c63d90036959ff768b186853fb8f77b071c38e90061ee7aa00931216dba6cc854a12244b638f41a935110040774f29b7ea4c1196d975cb2a49979865bd7eee32d757a58ca1fcac1265783232ad1cc5ae55f4b4fe4a84c97c087309369c4c8a9fa8d90101bc152bae4513d1301eb784415a0bd7600491f5a85821293dd8fc9ae7864301e65fa701dca227b7a84ee0686b3f23691f4c8b7db100c1f3605449368898b3d2adc0193e347de5b7821e9c10cfacc5add3d4d21dedf115c8ad2ea98b1573e8da99c02608da43a71e98066ddf1ca74d845a21f9ea6259e3fc5db2aacc83cbc60d4dd8906cd9e7648aa922680a3fefc41c715dcfcbb8888cdc9b300efac838105bfa8fd8f3a99ae61ff651dc09ea6db5d1f2c85cf6121723d596e75e8c50121e9b892831ba5d10651fe7eaf89498c7cf581d012e20ef2248626bec06a51e55558bad4a764987d92d61f0d0777c9651b5f4913b921faba7345ba7e988560a279998a4d630ab4539bd36102dd194f28edac1406974b284c16ed68c608c7481158721d281586c06627b3d42663374a395a0fb2a723fc5acc7d42507cd6f28b0e6187f9565db1d3852c922ee1846db8d014761706af9ba88b8be62e8deeb0485d19026524d12206eb01fb66ffcb8349e80d89d7e529e382f2f25ea8b5c9249311f3d1ee6adaf4d985902ea7888359a89fbef312b88ab10a8d08340e88867c018fd75f5ce74184d62fd01abce4d62e92bac3b62b3b880ebb5ac74260141d56bacfd0787b23f5206ca94af283d73add9031877cf4cc9c53dc67ec2526ab5f7ba9be1fee2929df9ab862807b691ffb978956fa040e16ed40c276d57e6ef04e9ede37f42678c285809a91c484704c8524d464cfd4aa936a54523e54376e9e7ee750c6d0a1d934960dd038b23b9258ed8f7fa86f376cd060187293612e800e8ff7effc458deeacaeae62f92f771a903f2ff2e4ed9863cffa1944c5bf4e20aa7439ae6b3a1070f0316f435809a8b24ea827958d0721a502d0cdbe90a308b17cda31159b38d2dc1ab7c01f89dd6bfb7e4daeafff2bbf434a59c0bafc2d107cabf804b8abfebddf7b890a788b1f2251f99b445aeb9659777ead84d6c51fb682510683758ec7a2b1cf097f2eadee7d8aa7e7b38c9930fc938cbf6b3a0a4df5e546566781b0f0fe3053fe793522730f141ed461da582ab9cce161d4a9c2d3f42e2437cb684ef1324429aaabb020cb3b403990de1ce3d6420db18b468e68592596a46ecc010e82d715b7ca491bdae20f9a7cfc61126e2935d4b5d596418ef22dbe9fbee5f56d4da464319e8b231559334e5512ac291ed9134fed4743fac4d33f1c02604f5dbd0ff4ed7c14680a5d5137f96ff9fb8c7199bfdf5f3d43284b4843f877ad7638f386aedf264a32e7e2270bc5b7da4168a62b0b7376db0fb13909b5d71f8da9f8560be7ef657606a4055f91877af158cff2ae8250dbed0b255908df68ea97ba62c3fee3e7d2d3aa21d7bbea7034e10f44ddf22bf3066ed19847088aeea81d6884d6bbb43e7fd757cbe79173f1e5e1da5f5fe0ba864bef8f99157fb1ce4b198ee9757c5c93a0c9a8b0b7b80cf070db0e78299c98b793e0aaca8fa80558cd3b51ec8bcfcbacda0396245f2365832271dfe060b309b4665640a36a304e0a77f1747c84c57774698e36292286436a6968f06a4c3c27f373a39cd378214a4cea2241875f5ccb3a4c6b7d59124c7f8b69b8839652c72f40a5fdeafccc7e19c48618118c3bbf93f3b33c65651df7c2065565c9d42d63d41ba9782247771fb8e3965408022f7cfbbccbfea1a3476f7af95f746879668569093a2e76d3dfcecb4a8ae3d3a09843f40cd26a71397ea1fef70cfc10d5e0310c0ab315ef9fcda7e38d6ffb2db92909d0fcdeca0651b613245827a9576eb99569d4165de885ccd3bc5e08ef3f86b32d349094e2c72fd54d45273928a0ed121d44a5e88d6c5d57eef75ea53018413adf4392e783823225e1c78791ee39ee0541accbc4f18b2b12104bbc12d7c36c1f1f006768161ba66cb518a2ad94806f00daa0933a3609d4a531d985f17fdba200003ae06d11eb9903386732bd5f4ef563b4b49d24d4eefce01f77afe5ba688e24e0495948eb1b013bc757b7541b04680102a7b18f665494cd3c7621a43b1f7ffde25366157fa1fb5d85e30393d03f80989e73c60b028361b4d11200b01f449c1191cc4e01ec454175a6be9f1389e42ec49c7f0eda0b2f10cc2ef6a22835586007b9e58fd27ddb86ea631493104a2e646318d5bf8f1be2722ad63bdbeb768cabd03ff63ce1a0862a7341cd53d1c8323618df61bcf5dcf2f18edcf05c1822519ae4e08d7005b26bb4e9104cbc8aaafb7fbc73a1bbd959111d9bd0fcf8359c37bbfa67c6f52f28aa24cb59bcaddc055383a8b88bf9371989855a9454387633173a83f379730cb330a574f4a9b25a91d748778daca650f9e218091f46838645c4bfc6eaaad91017aa8c44209a9522e7858029657d898ee8bcc0d4500047f96db0f413f5102e0a41435c4fcc454360a04b575fcb89f3f13f269ae701bd11f4c6f0edfbd3ad5467a2d233d6d718317fac513226c1aca6a821b26d394f7bc13c665e684a2a7d3e7caee73b0d8498cef371bdda387bca62b50b70206d2ccd510dfedc9bf6c67f243bef20e09eb0d1a0864f1d97051f8f3368116ca0fd5ace084e9e6d35b9c1b01bc2765f9db44d2334ad8edb6007dd7d62540cadc681fccc1c248ae7f82e84cbbeb77cdcb97886db46bc874f78f271475296fc1f41eafdbd5ea68875e8e246332b4f9a855e815ab79a066ca142bd7cb35a5b52d21fc1a0fcb031c54d43a93443c11fdac0acaa5bcb55cda39d1ed5b25821fb7ed2e2bf3b793a18855d49fac738aa28f154729a68f9d61fc4adc524876800794b54cac83ca62ac85f7d07b42dc54ca270fd706919775a340d245e1fb7997426b819cb83470c92ce6615aaafc894ced9a94a11ba52aced6b9409a3c6791aa7c9e179fd52c0e8160e758e2a08368de72b1c46615c1c2692451ec292b0d49369a33e5d975151a8d4961dc69bbf1be4a155c9e6c21014d5be981dccd47ced1e48f34f0ebf284487a1d16d4d5e8d8ad6129039b4a4b22232ea5b835f0094a72d8c0c225e958998c4d9f820b011aee444acfa4800b3ad1b4a7be8318b846694b97abc100213657e5f157000bd48978bbc3f74da6f906931756376cd833e6fa07d12622ac49608179636d196ef8130bd1cde2ff8bd83a3653d99f129df18e1f3a0889419cceaa620199a506b7036d5c6357370e4a36d5e6862005897f8bd0dbc28080389ec6e681f72e612c12f0436d7e84e5921d96b956ccf10fac68c89e720c8332cd46764a7502b7f00cf616d6651405bfa6c7c9f50449f9248bff76c19022e16a8abe293231a443a7193daf9d095193d458d96326ea8cd10b913a65064136005d5fc0b0005a5cf4a229888b190e40454a09a638218a61d75d173ca55948b5dfabf031804e7b80145a10397522b80fe83fd7d1e836d31e6dea3e743809585aa7b88cf2d0c0686f33d2a2b8c1b473ec52930fea16d158cfbd4d6998111565f695c473e44fd0d847e2a8be33d79acb8753206ad0359ae7937f378de78f6bee7a1dcdffe554c2cdcac5aa7928e0f092fc80d27633cb29e82d22fd2ba0c26093ce72ff713948a0503d150e6179d7d90de67af8f59193b5331711d820433e34d6288ee41a50fb0741fe5b1da05798cef4facdac8b287c0fab319911208bc70e4705a2b46f66702ce4f7bb40d2de82c497a9a46925ed5f12ab532a32fde12f152d26d85bb62d0682e9286d06d1f2f1f21c79d43ddbc21d94b361d67d8f4e53924d0a5ae428fc1ddcff30279b29def24de59d51825bfdd5f766ee11942c9e55c8007341dc0f814733e352eb6067aeb1e2310fe976292da88aad52983e393565167cd6505d78dfd9fe827ca4f8ce4fb30e6d680bc7d61d805e05405821ba94c11e813ccabcaacfa2425d901446964c4ea72720b343985185ab7f8d671b058dd6aa0d8a5c242b47a0984d76376fe8be0c4c27c2b5a97b736697da414088bcd58cf4a1afed74e062450b142bf31e5707fb59eb0d9573b7a7b681fbae1314f861e6e1a2bd7bc563825cd2129202864bce99bfe7bdcd23733b2eda45cdf522348c116bf351163c1f7833d88ef49d246433867dfcaf4850f5b30c17e0e768175dabc7147427307ef4640ca5a27fc28e4930e2af3991184ede121af115a94640c13990aba5f002a7b0eddafa8a070e0b0a12d5d4f5e928b4c9f8165ef24a7d6e3d10dcacce87a404a261a24d2488546a5d2ee742995787d6179d01eb4e534f7da1a1358f9662ea90d8b441ad8081b700a2d8cd79a6e6f8def698d41e68628575c07d19fa7553612170cb26df199abfe325e777ee3588f88a57601e4b8907cefd12dced88237f842a780c0eb240f80906594f8ae24647e716c1481a8c699dd3f478db6803d2171fc05c778bc931450c2bb5251549211f9005edf383f802cf2092836727747f2b5bf802ed33b1bce8358ce5c32cf546034e7d678aa2eb48fc2831c8c0c6fcb6363c6b2b0f986e15f316e1fd25437656a944a62dbd0025e7833cfa0b62f232fed0e601d5be2396e262b60f8a6cb34a333304f2fb2e1469fe1f389d0023b29a0b6e6f31b6c2f30be25ba1d37f152aa937ff71d49a0ac1a529450a6fecc042fffaeb7951dde4cc74f38e08d75c489979225501dbbf1b54644088b30c87caa38f8c48037281632c32983a3f91869600cd9bfe3e3f39c8264ef49693b107c123f03836dd4b79e85de504b129b437e7661b72bd13af88a307372e0becf5d306837a346ea65846613d0beb56ba748e95cba885169e1f038f6b948250ac1119112371edcf6267cc7d2e1117eea233e34ec75ceee4c0c333b5d33751805bc34bda7bb28af404b8d8564e1c50a0f8552e950e2a9fa2e3927be37f8cf6e4e9cb5fc8603c8358de2e59950b62b43eb99deedbe95a3a8417c52cc416053749254e23d2a043b6bd28150c77eed1ca7e54714a0fad32c1a628a2824d20c80e6755b2d8d1523185f76afaccfedad4b3b921945a67899d01a6fcaf15807c11fef774b76124e0d4ce68b95a0ec196dce7c5900dd9762b0586305173e98778f93ecd5367627fbac8bc594aeb29333bcf24a66313b6bf3d89bab65e086f28e81846672167134e86d0f4ac2f31a30fae973e8e6eef452859d57f9bf84bfb81b52b2d11f937465fdbc395c411a1b6a86ebb98657702a8038f7bb83d1e5b8ddf5e29e19e5c4e1ad75635a1be47c19620f89a5adc0a4e6b40247c73c2ef0b8d4d516d0a094154b5c1f1d2560fa04de0a181433a4dbf810ae968a27bc6a0b751f82876a662d0598277cdda411800a6f07e199a13c43265c36db7f7cbe8a6f160030dbbed8521ea5b9d5ded26c3d5dde7a634bb5db3832c0ec281f02e9bd06b1354ec356a813e3a2251156a11182399636ae56d2408b5758869da17135f8107301def59cc1b8681dd03266da7cea187dddc1ab1a218bcb889e4babaaf4625d8c4297de25a5da13450862fb2fd2581591066383fbafcb04aec5b63d0ac29bf85aebf3508bdf1b59556ef85ee51a1ec91d46ff86658ca55abaf932aa399d44aba5bda6b06781e5f9a185ee6d627716b1390dd33a5d69091e58a37fc4216aa64d6481b8ccf0c04bb50bd44c3754510769582e3c74a6126c88d3b71369817b7bc90ddc5e3e4f3e0b969e491a168aff28cc8d6def071782de290d23235d7f0e9b9d6f943502dcaae6f0078acc5834652384375f4677406fb2ca3df4768c29fa4d8d7f3df89e0a1075d1a8a08573f49ce7205790bf19633b88974963ac27c95dc1aad67a9c79fabeed76f90d5e9e244b5a15a60ed3534dcfe47f389829935a800a360f714560a7ee2472acbcaa1ce5cd0fd661a5e6fa076ad0ed97c4754cce08e2a20ed5d32a3efdf0a6cb0150fc89937efbdef324f764713b33646902264d68caef69c174f2002da5ee855a9740c8440d0e2f8bdb942466cd8fc17cf4e7e7edf27fd0842b3047318149bd30d13cf1f718cc6c8961ade3a73e9e63f9f33f9c1163752773138b8fea8b6d7167eb7ce8fb314111d4be951f567ce0ad2ee54a6ba33f2196ff73e1d2294bdf5f3123f0c4ecb9d7a52581b2344ad921b7ae508deaa99f94c93d884053a0790f280f46c664bb5f14031dda32518fe93ae1ba906686a04275959341c3cbabeeec6f923523aac3fdfc8c0e3fe4b0f706ba7b15c702bf24c35c45eb66eaa406c7b3693cda76164c85da014f63d9e2b34dfb5323511853a62c1592f14d2dd65aa8ce01994d830bded2576ff4ef804e1d35bbe5b1c1308611096f02f610fcda33f61f16632c1ba1be16ab1d48af80c0b74ae0495816e7b40e15557ba3890b440888e9f905d5fea1adf13a810377f2ae066af5bfcd6b4b0e78b98da25a2378d63e0d6e8a47a1fe218a6b0fcf3e3718996da2d91aaa2ee2b6ff38f48755cfd909a6b64b449b0a65f88653451c9d12475af869ce89e2cb29016813d2d5d95cdc2b3a8dac0b544f6099bf0e0b7fe48338daf99f15986cc6099e645af01fa1698cd488c3d77752e41ae3bb132f79e46ec0db3cfe5c65fc7d0d0c1e2ff8324dd7fb217e0315845e47f08a17c7e810b9017bb7975e135754b8e26731d6f542ee95225a7a4c2fb20099a9d92f4523e48736fc8c48d3e4f3a798f11f328138d7de8e431907cea2c8f7f433a239b355ab0218c9a760e47ec8f5201c3b8c772679812a84a010a4f896d630a3782b81e065b5389327311c9951ba0fcde133d47ebe2c58ed7d96ed88839c413479ec93f84913d221650a3704ea58998f85d7d4cafd8cbb55d9d80add6a48f02b9dfb21facff4a304683edbfb878abb96f60abb3e2189fbb7ee1728d411dd8a70c5a022041a21b8ba93a2298978149a7cb93e83b5fbc5bea3d341b0c3c4edd52e27e8869baf0fa6c72f5096a68cd8bd65eb20fd54eaf3f66c75cf0078e26017793bcafeed9ae48eacc1b3edb1e98ecd68957f6aefab2aeb4545da4c4bd1e4f6f07f8e2c25bffcc52516e9b468d891c22cd931544a463b8d44ae8df11d8808be86e58d411f9dd59ff89b501323913fea055275bd2afb6b76b4211b7263732023877fc77e3f5a5ac917d4427926f535e053ce1d1736927dd70b246c667578e1edaebda2b8a0ac368ccd85f487e579fbbb8d0e006bacd4352c6fe5871cbd71bb4c6cb4fe44cd57d7a12686e4301a949020b42f216725f752bacf127046860ef62f6e4650297ce29d8211e2bff43f6d67a00a32d8431db2bdcc8dc8a06f238211255b5ae9d603897bdcb7228cb4cde649c93d924ecda0f199e6408b92f0127c8aa9b72c1fe01723d327510af55fecba856dc5a2e3ffc21a99ca4f2f8ef7b8f685664a2b91e58f9402f0fda913a5cbd586f39d5fcc079fc018444afe5585d560d38142f27383a4747a77602b0e58cf16dc3d5581a19c0f741722b111f3c8f9b3bbfb50eaf9e0d14b60a0647323eb208421abaa2d9005a487b5e3104e9937f195ca424c76d79ac476a74beea605989248e2af6fd5387f156595ccc221aebfc103dcb9879c1fa669297ae81542c0d2fcba74701c0d4c28b285522787efe002bed9416c9932e17b3cb7d651e582c7621058f9d1d09e9e54c5584b2fb2e62e4fb44b94b1acfbb8b867ba46857844fc0a5a41724674101d064694774af0032c99b2acb442ac858883e181cc5f8fdcfe1b4961e8954a6d5d6adedcc9dd98200e184169f70fbb76421613c948d9ef5197ae755dc5a688cc5ef5dc2b', '788365c8880e0dc52d3df40cf337ef83', 'read', '2024-12-17 04:16:33', NULL, 'img');
INSERT INTO `messages` (`id`, `conversationId`, `senderId`, `senderType`, `content`, `iv`, `status`, `created_at`, `updated_at`, `type`) VALUES
(17, 1, 11, 'customer', '6b48e6f953a5430df4b968510e3f9c0308d7782c987d3c04e78f30bb58071a47908317c091446d906ea4a4c3ebb348fb', '346eb3eccfc127d3fb425dbdcdd6a3f0', 'read', '2024-12-17 04:21:06', NULL, 'text'),
(18, 1, 11, 'customer', '3f455787c3f864746bcc79c5c8dade31', '75d37e97424e10b281063fc5229c6471', 'read', '2024-12-17 09:33:14', NULL, 'text'),
(19, 1, 13, 'admin', '2ebdcdd0e99e5f06ee72430fd5e16dd1db5ab18c1eb7bf16d8b04b0892a574a6', 'ca6e387d26c3f68b6915ee8617e4ca4e', 'read', '2024-12-17 09:33:33', NULL, 'text'),
(20, 1, 11, 'customer', '30a3c0250dec98e99ed5459841a8b103', 'f4b91a7c2d8b923b17eb020a3b186097', 'read', '2024-12-17 15:13:23', NULL, 'text'),
(21, 1, 11, 'customer', 'c8eb9c14c6b47bf0dbc23471082a8f88d0f7b9c377885ffc38e62d3f638cfefb7b1f46af4a36ad9ec32c85349543b6a7', '034c5eece50b6b0556a4f70d95ccf479', 'read', '2024-12-17 15:13:35', NULL, 'text'),
(22, 1, 13, 'admin', 'eebb8fbbf4db3062a7b526004b533ea76e46a86fc16ae1c24bfd4e133d1fce0e', 'ba6259e36afaaeb4dbf497f0999350aa', 'read', '2024-12-17 15:13:59', NULL, 'text'),
(23, 1, 11, 'customer', '7afb693ab9b363f95689a6afc02b9b9daf011f9398e697ed34e321d85eac5214', '92287b22411af38cdfbaafcd05fe1a5c', 'read', '2024-12-18 00:50:34', NULL, 'text'),
(24, 1, 11, 'customer', '08008ac1beee3c00c942d692ce64486f', '76bbd73fbccde8e5bdc1c207eb537fdf', 'read', '2024-12-18 01:40:26', NULL, 'text'),
(25, 1, 11, 'customer', 'c0cf5602ffd9ee1d97bb3a18e16d4498', 'f042e12c6591a8670ec5c709076d79fe', 'read', '2024-12-18 02:07:06', NULL, 'text'),
(26, 1, 13, 'admin', '8df01f0bec6b972323b28fb2aacc6a6b', '658498a9202cdcaad95682e17248a633', 'read', '2024-12-18 02:07:23', NULL, 'text'),
(27, 1, 11, 'customer', 'cab74f9196c95699f6481376355163c9', '79635e838e427ce9801ef9e78fb249d4', 'read', '2025-01-03 14:33:21', NULL, 'text'),
(28, 1, 11, 'customer', '7cb39de7ef191224b37925607840933c', '67e444ede878beef50ff868c2c095ad7', 'read', '2025-01-03 14:35:04', NULL, 'text'),
(29, 1, 11, 'customer', '95e7940e075959ea4a220d20f1d5d760', 'ff4b7993a393ab7d828d152fa2bf7146', 'read', '2025-01-03 14:35:52', NULL, 'text'),
(30, 1, 18, 'admin', '85a6f7cab408296dacba139e3987aea5', '1bac31f32cfbf2461c0bfa6908605d2e', 'read', '2025-01-03 14:36:33', NULL, 'text'),
(31, 1, 18, 'admin', '2303dfdcd7500fd25795391483135686', '9484811eb53a38a17ada5043d9999281', 'read', '2025-01-03 14:37:30', NULL, 'text'),
(32, 1, 11, 'customer', '26c3d9108f2ef79dab5d5eebb88b716e', 'a930e1e9edfb8eda30c5121d04ed9586', 'read', '2025-01-10 04:26:00', NULL, 'text');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2024_09_25_145831_create_categories_table', 1),
(6, '2024_09_25_150006_create_products_table', 1),
(7, '2024_09_25_150054_create_product_variants_table', 1),
(8, '2024_09_25_150137_create_vouchers_table', 1),
(9, '2024_09_25_150213_create_orders_table', 1),
(10, '2024_09_25_150257_create_order_items_table', 1),
(11, '2024_09_25_150325_create_reviews_table', 1),
(12, '2024_09_27_094033_create_colors_table', 1),
(13, '2024_09_27_094038_create_capacities_table', 1),
(14, '2024_09_27_100111_remove_variant_columns_from_product_variants_table', 1),
(15, '2024_09_27_100557_add_color_id_and_capacity_id_to_product_variants_table', 1),
(16, '2024_09_27_101451_create_conversations_table', 1),
(17, '2024_09_27_101539_create_messages_table', 1),
(18, '2024_09_27_171418_add_soft_deletes_to_categories_table', 1),
(19, '2024_09_27_181820_remove_stock_from_products_table', 1),
(20, '2024_09_28_084335_add_soft_deletes_to_products_table', 1),
(21, '2024_09_30_134945_add_product_code_to_products_table', 1),
(22, '2024_10_02_083518_add_gallery_images_to_products_table', 1),
(23, '2024_10_02_090342_add_gallery_image_to_products_table', 1),
(24, '2024_10_07_034808_add_avatar_to_users_table', 1),
(25, '2024_10_18_075152_add_views_to_products_table', 2),
(26, '2024_10_09_074942_add_status_to_categories_table', 3),
(27, '2024_10_09_101319_add_deleted_at_to_capacities_table', 3),
(28, '2024_10_09_110526_add_status_to_capacities_table', 3),
(29, '2024_10_09_111022_update_colors_table', 3),
(30, '2024_11_04_084924_add_admin_id_to_conversations_table', 4),
(31, '2024_11_04_090000_add_receiver_id_to_messages_table', 5),
(32, '2024_09_29_112006_change_reviews_table', 6),
(33, '2024_10_02_112903_create_categories_news_table', 6),
(34, '2024_10_02_113625_create_news_table', 6),
(35, '2024_10_06_093816_change_news_table', 6),
(36, '2024_10_21_014224_change_news_table', 6),
(37, '2024_10_23_023930_update_status_in_news_table', 6),
(38, '2024_10_29_124626_change_category_news_table', 6),
(39, '2024_10_29_141254_change_category_news2_table', 6),
(40, '2024_11_07_154425_add_deleted_at_to_vouchers_table', 7),
(41, '2024_11_10_170636_add_fields_to_orders_table', 7),
(42, '2024_11_12_155435_add_total_price_to_order_items_table', 7),
(43, '2024_11_16_162836_remove_shipping_columns_from_orders_table', 7),
(44, '2024_11_17_124924_change_category_news_table', 8),
(45, '2024_11_20_031624_create_subscriptions_table', 9),
(46, '2024_11_20_041518_create_sent_emails_table', 10),
(47, '2024_11_21_040047_add_image_to_categories_table', 11),
(48, '2024_11_21_065540_add_image_page_to_categories_table', 12),
(49, '2024_11_21_122031_create_customers_table', 13),
(50, '2024_11_21_161952_add_name_to_customers_table', 14),
(51, '2024_11_21_170953_add_is_verified_to_customers_table', 15),
(52, '2024_11_17_180927_add_status_to_orders_table', 16),
(53, '2024_11_18_024946_add_order_code_to_orders_table', 17),
(54, '2024_11_22_150857_create_addresses_table', 17),
(55, '2024_11_24_084640_add_name_and_phone_number_to_addresses_table', 18),
(56, '2024_11_24_090858_create_favorites_table', 19),
(57, '2024_11_23_070442_add_customer_id_to_orders_table', 20),
(58, '2024_11_25_095715_update_total_price_in_order_items_table', 21),
(59, '2024_12_03_131854_add_image_to_voucher_table', 22),
(60, '2024_12_01_051504_create_conversations_table', 23),
(61, '2024_12_01_051739_create_messages_table', 24),
(62, '2024_11_28_141204_update_status_column_in_orders_table', 25),
(63, '2024_11_29_081558_update_status_enum_in_orders_table', 26),
(64, '2024_11_29_084645_add_payment_date_to_orders_table', 27),
(65, '2024_11_29_084830_add_additional_status_to_orders_table', 28),
(66, '2024_12_01_182853_create_carts_table', 29),
(67, '2024_12_02_183006_create_order_notifications_table', 30),
(68, '2024_12_04_160422_update_total_price_in_orders_table', 31),
(69, '2024_12_08_144213_add_type_to_messages_table', 32),
(70, '2024_12_08_160945_change_content_column_type_in_messages_table', 33),
(71, '2024_12_08_150103_update_news_table', 34),
(72, '2024_12_12_151251_add_staff_id_to_orders_table', 35),
(73, '2024_11_23_070214_remove_user_id_from_orders_table', 36),
(74, '2024_12_17_081511_create_voucher_usages_table', 36),
(75, '2024_12_17_092250_add_user_id_to_orders_table', 37),
(76, '2024_12_17_082751_create_comments_table', 38),
(77, '2024_12_17_095111_add_customer_id_to_reviews_table', 39),
(78, '2025_01_03_064220_add_name_and_image_url_to_order_items_table', 40),
(79, '2025_01_03_073308_add_is_active_to_users_table', 41),
(80, '2025_01_08_135830_add_is_checked_to_carts_table', 42),
(81, '2024_12_17_033032_update_news_table', 43),
(82, '2024_12_17_042429_create_resets_table', 43),
(83, '2024_12_17_082751_create_comment_table', 44),
(84, '2025_11_18_090322_add_is_active_to_customers_table', 44),
(85, '2025_11_18_091919_add_soft_deletes_to_customers_table', 45),
(86, '2025_12_23_090747_create_brands_table', 46),
(87, '2025_12_23_090753_add_brand_and_price_to_products_table', 46),
(88, '2025_12_23_091233_create_product_images_table', 46),
(89, '2025_12_23_091326_add_columns_to_products_table', 46),
(90, '2025_12_23_091451_upgrade_product_variants_table', 46),
(91, '2025_12_23_091557_create_transactions_table', 46),
(92, '2026_01_18_065325_add_soft_deletes_to_brands_table', 47),
(93, '2026_01_18_203911_add_slug_to_products_table', 48),
(94, '2026_01_19_101659_clean_up_legacy_tables', 49),
(95, '2026_01_19_115448_create_attributes_tables', 49),
(96, '2026_01_19_115548_create_product_skus_tables', 49),
(97, '2026_01_19_122310_upgrade_orders_and_transactions', 49),
(98, '2026_01_19_122334_create_flash_sales_tables', 49),
(99, '2026_01_19_123226_final_cleanup_database', 50),
(100, '2026_01_19_144134_add_soft_deletes_to_eav_tables', 51),
(101, '2026_01_19_163011_add_soft_deletes_to_product_images_table', 52),
(102, '2026_01_20_070347_update_carts_table_for_dynamic_skus', 53),
(103, '2026_01_20_111256_fix_foreign_key_carts_table', 54),
(104, '2026_01_20_134314_create_vouchers_table', 55),
(105, '2026_01_20_134537_create_voucher_usages_table', 55),
(106, '2026_01_20_145758_fix_order_items_foreign_key', 56),
(107, '2026_01_22_121507_upgrade_database_to_pro_level', 57),
(108, '2026_01_22_121918_fix_order_statuses', 58),
(109, '2026_01_24_175641_create_contacts_table', 59),
(110, '2026_01_24_184952_upgrade_vouchers_table', 60),
(111, '2026_01_25_034847_create_shipping_rates_table', 61),
(112, '2026_01_25_043253_add_scope_to_vouchers_table', 61),
(113, '2026_01_25_043335_add_shipping_discount_to_orders_table', 61),
(114, '2026_01_27_211345_add_seo_fields_to_news_table', 62),
(115, '2026_01_27_230957_update_columns_for_customers_and_vouchers', 63),
(116, '2026_01_27_231227_add_used_at_to_voucher_usages', 64);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `meta_title` varchar(80) DEFAULT NULL,
  `meta_description` varchar(180) DEFAULT NULL,
  `focus_keyword` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `short_content` varchar(255) NOT NULL,
  `author_id` bigint(20) UNSIGNED NOT NULL,
  `category_news_id` bigint(20) UNSIGNED NOT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `image_alt` varchar(255) DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `status` enum('Công khai','Bản nháp','Đã lên lịch') NOT NULL DEFAULT 'Bản nháp',
  `published_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `scheduled_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `title`, `meta_title`, `meta_description`, `focus_keyword`, `content`, `short_content`, `author_id`, `category_news_id`, `thumbnail`, `image_alt`, `slug`, `status`, `published_at`, `created_at`, `updated_at`, `views`, `scheduled_at`, `deleted_at`) VALUES
(6, 'realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?', NULL, NULL, NULL, '<p><img alt=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572678/realme-c75-6.jpg\" title=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" /></p>\r\n\r\n<h2>Thị trường&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" rel=\"noopener\" target=\"_blank\" title=\"smartphone\">smartphone</a>&nbsp;cạnh tranh khốc liệt hiện nay, ngo&agrave;i hiệu năng, camera, thiết kế,... th&igrave; độ bền cũng l&agrave; một yếu tố được người d&ugrave;ng quan t&acirc;m h&agrave;ng đầu.&nbsp;<a href=\"https://www.thegioididong.com/dtdd/realme-c75-8gb-128gb\" rel=\"noopener\" target=\"_blank\" title=\"realme C75\">realme C75</a>&nbsp;nổi l&ecirc;n như một ứng cử vi&ecirc;n s&aacute;ng gi&aacute; trong ph&acirc;n kh&uacute;c điện thoại bền bỉ. Vậy realme C75 c&oacute; thực sự xứng đ&aacute;ng với danh xưng smartphone si&ecirc;u bền bỉ?</h2>\r\n\r\n<h3><strong>Điện thoại như thế n&agrave;o th&igrave; được cho l&agrave; si&ecirc;u bền bỉ?</strong></h3>\r\n\r\n<p>Một chiếc điện thoại được coi l&agrave; &quot;si&ecirc;u bền bỉ&quot; cần phải vượt qua những thử th&aacute;ch khắc nghiệt về cả phần cứng lẫn phần mềm. Về phần cứng, thiết bị phải c&oacute; khả năng chống chịu va đập, chống nước, chống bụi tốt, hoạt động ổn định trong điều kiện m&ocirc;i trường khắc nghiệt như nhiệt độ cao, độ ẩm cao,... Về phần mềm, hệ điều h&agrave;nh phải được tối ưu h&oacute;a để hoạt động mượt m&agrave;, ổn định trong thời gian d&agrave;i.</p>\r\n\r\n<h3><strong>realme C75 - &quot;Chiến binh&quot; bền bỉ với loạt ti&ecirc;u chuẩn khắt khe</strong></h3>\r\n\r\n<p><img alt=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572678/realme-c75-3.jpg\" title=\"realme C75 liệu có xứng đáng vớirealme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" /></p>\r\n\r\n<p>realme C75 kh&ocirc;ng chỉ l&agrave; một chiếc smartphone th&ocirc;ng thường, m&agrave; c&ograve;n l&agrave; một &quot;chiến binh&quot; thực thụ với khả năng chống chịu ấn tượng. Nh&agrave; sản xuất đ&atilde; trang bị cho realme C75 h&agrave;ng loạt ti&ecirc;u chuẩn độ bền khắt khe, gi&uacute;p thiết bị &quot;sống s&oacute;t&quot; qua những thử th&aacute;ch cam go. Đầu ti&ecirc;n phải kể đến khả năng chống va đập đạt chuẩn độ bền SGS. Điều n&agrave;y c&oacute; nghĩa l&agrave; người d&ugrave;ng c&oacute; thể y&ecirc;n t&acirc;m sử dụng m&agrave; kh&ocirc;ng phải lo lắng về những va chạm, rơi rớt trong qu&aacute; tr&igrave;nh sử dụng h&agrave;ng ng&agrave;y.</p>\r\n\r\n<p><img alt=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572678/realme-c75-4.jpg\" title=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" /></p>\r\n\r\n<p>Chưa dừng lại ở đ&oacute;, realme C75 c&ograve;n đạt chuẩn độ bền qu&acirc;n đội MIL-STD-810H của Mỹ. Ti&ecirc;u chuẩn n&agrave;y y&ecirc;u cầu thiết bị phải hoạt động ổn định trong điều kiện khắc nghiệt như nhiệt độ cao, độ ẩm cao, &aacute;p suất thấp, bức xạ mặt trời,... realme C75 đ&atilde; chứng minh được khả năng &quot;chịu đựng&quot; phi thường của m&igrave;nh, sẵn s&agrave;ng đồng h&agrave;nh c&ugrave;ng người d&ugrave;ng trong mọi ho&agrave;n cảnh.</p>\r\n\r\n<p><img alt=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572678/realme-c75-5.jpg\" title=\"realme C75 liệu có xứng đáng với \'danh xưng\' điện thoại siêu bền bỉ?\" /></p>\r\n\r\n<p>Đặc biệt, realme C75 đạt cả chuẩn kh&aacute;ng nước v&agrave; bụi IP68 v&agrave; IP69. Với chuẩn IP68, thiết bị c&oacute; thể &quot;ng&acirc;m m&igrave;nh&quot; dưới nước ở độ s&acirc;u 1.5 m&eacute;t trong 30 ph&uacute;t. Ấn tượng hơn, chuẩn IP69 cho ph&eacute;p realme C75 chịu được &aacute;p lực tia nước mạnh v&agrave; thậm ch&iacute; l&agrave; nước s&ocirc;i 80 độ C trong thời gian ngắn. Kết hợp với c&ocirc;ng nghệ Sonic Wave Water Ejection gi&uacute;p đẩy nước ra khỏi loa, người d&ugrave;ng ho&agrave;n to&agrave;n y&ecirc;n t&acirc;m khi sử dụng điện thoại dưới trời mưa, v&ocirc; t&igrave;nh l&agrave;m rơi xuống nước,...</p>\r\n\r\n<h3><strong>Kh&ocirc;ng chỉ bền bỉ, realme C75 c&ograve;n l&agrave; một smartphone to&agrave;n diện</strong></h3>\r\n\r\n<p>B&ecirc;n cạnh độ bền &quot;nồi đồng cối đ&aacute;&quot;, realme C75 c&ograve;n ghi điểm với những yếu tố kh&aacute;c, mang đến trải nghiệm người d&ugrave;ng to&agrave;n diện. realme C75 sở hữu thiết kế hiện đại, trẻ trung với mặt lưng chuyển sắc gradient. M&aacute;y c&oacute; độ mỏng chỉ 7.99 mm v&agrave; trọng lượng 196 gam, mang lại cảm gi&aacute;c cầm nắm thoải m&aacute;i.</p>\r\n\r\n<p><img alt=\"realme C75 liệu có xứng đáng với \" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572678/realme-c75-1.jpg\" title=\"realme C75 liệu có xứng đáng với \" /></p>\r\n\r\n<p>M&agrave;n h&igrave;nh IPS LCD 6.72 inch, độ ph&acirc;n giải Full HD+ cho trải nghiệm xem phim, chơi game sống động. Tần số qu&eacute;t 90 Hz gi&uacute;p c&aacute;c thao t&aacute;c vuốt chạm mượt m&agrave; hơn. Về hiệu năng, realme C75 được trang bị chip Helio G92 Max kết hợp với RAM 8 GB v&agrave; bộ nhớ trong lần lượt 128 GB - 256 GB - 512 GB đ&aacute;p ứng tốt nhu cầu sử dụng h&agrave;ng ng&agrave;y, chơi game giải tr&iacute;.</p>', 'dfhntfnfgn', 13, 1, 'uploads/thumbnail/vreliWJlU2K7y6uyInn11n0YFDZKGMpzvbGCArN7.jpg', NULL, 'rsdgggggggggggggggggggggggggggggggggggggggggg', 'Công khai', '2025-11-20 00:42:22', '2024-11-30 08:40:15', '2026-01-27 14:03:11', 0, NULL, '2026-01-27 14:03:11'),
(7, 'realme Neo7 chính thức xác nhận sẽ trang bị viên pin khủng 7000mAh', NULL, NULL, NULL, '<p>zcc</p>', 'sd', 13, 1, 'uploads/thumbnail/kFdXAQIrtyFZSjaK8Q6pZxky6odsnrTpt9QeocZr.jpg', NULL, 'vsdv', 'Công khai', '2025-11-20 00:42:13', '2024-12-02 00:34:14', '2025-11-19 17:42:13', 0, NULL, NULL),
(8, 'realme Neo7 chính thức xác nhận sẽ trang bị viên pin khủng 7000mAh', NULL, NULL, NULL, '<p><img alt=\"realme Neo7\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572688/rmno71.jpg\" title=\"realme Neo7\" /></p>\r\n\r\n<p>realme Neo7 dự kiến ra mắt v&agrave;o ng&agrave;y 11/12 tại Trung Quốc (Ảnh: realme)</p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/dtdd-realme\" rel=\"noopener\" target=\"_blank\" title=\"realme\">realme</a>&nbsp;đ&atilde; ch&iacute;nh thức x&aacute;c nhận rằng chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" rel=\"noopener\" target=\"_blank\" title=\"smartphone\">smartphone</a>&nbsp;realme Neo7 sẽ ra mắt v&agrave;o ng&agrave;y 11/12 tại Trung Quốc. D&ugrave; ng&agrave;y ra mắt to&agrave;n cầu vẫn chưa được tiết lộ, nhưng thiết bị tầm trung n&agrave;y đ&atilde; g&acirc;y được nhiều ch&uacute; &yacute;. realme vừa x&aacute;c nhận rằng Neo7 sẽ được trang bị vi&ecirc;n pin Titan 7000 mAh, một t&iacute;nh năng hiếm thấy ngay cả ở ph&acirc;n kh&uacute;c flagship.</h2>\r\n\r\n<p>realme đ&atilde; hợp t&aacute;c với Ningde New Energy (CATL) để ph&aacute;t triển pin Titan, c&oacute; khả năng sử dụng c&ocirc;ng nghệ pin Si/C gi&uacute;p tăng mật độ năng lượng v&agrave; giảm trọng lượng d&ugrave; dung lượng cao. Sự hợp t&aacute;c n&agrave;y l&agrave;m tăng th&ecirc;m uy t&iacute;n cho khả năng cung cấp hiệu suất vượt trội của vi&ecirc;n pin.</p>\r\n\r\n<p><img alt=\"CATL\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572688/007dP9zpgy1hw5r0ofd0fj30u01hcgxe.jpg\" title=\"CATL\" /></p>\r\n\r\n<p>Theo c&aacute;c tin đồn trước đ&acirc;y, Neo7 sẽ hỗ trợ sạc c&oacute; d&acirc;y SuperVOOC 80 W. Ngo&agrave;i ra, m&aacute;y dự kiến sẽ c&oacute; m&agrave;n h&igrave;nh độ ph&acirc;n giải 1.5K lớn. Về hiệu năng, thiết bị sẽ được trang bị vi xử l&yacute; Dimensity 9300 Plus, đ&atilde; đạt số điểm ấn tượng 2.4 triệu điểm trong b&agrave;i kiểm tra hiệu năng từ leaker nổi tiếng Digital Chat Station.</p>\r\n\r\n<p>Th&ocirc;ng điệp &ldquo;Chất lượng &gt; IP68&rdquo; từng được realme h&eacute; lộ cho thấy Neo7 c&oacute; thể đạt chuẩn kh&aacute;ng bụi v&agrave; nước IP69, điều hiếm thấy ngay cả tr&ecirc;n c&aacute;c flagship v&agrave; thiết bị hiệu năng cao. Về gi&aacute; b&aacute;n, realme Neo7 c&oacute; mức gi&aacute; khởi điểm khoảng 2499 CNY (~ 8.73 triệu đồng).</p>\r\n\r\n<p><img alt=\"realme Neo7\" src=\"https://cdnv2.tgdd.vn/mwg-static/common/News/1572688/007dP9zpgy1hw6bxx0m9tj30u01hctj0.jpg\" title=\"realme Neo7\" /></p>\r\n\r\n<p>Trong th&aacute;ng 11, &ocirc;ng Xu Qi &ndash; Ph&oacute; chủ tịch realme, Gi&aacute;m đốc Marketing to&agrave;n cầu v&agrave; Chủ tịch realme Trung Quốc &ndash; đ&atilde; tiết lộ rằng h&atilde;ng sẽ t&aacute;ch bạch 2 d&ograve;ng sản phẩm, cụ thể: D&ograve;ng cao cấp &ldquo;realme GT series&rdquo; v&agrave; d&ograve;ng tập trung v&agrave;o e-sports &ldquo;realme Neo series&rdquo;. realme khẳng định Neo7 sẽ mang lại &ldquo;hiệu năng, thời lượng pin v&agrave; chất lượng mạnh nhất&rdquo; trong tầm gi&aacute;.</p>\r\n\r\n<p>Bạn c&oacute; mong chờ sự ra mắt của realme Neo7?</p>\r\n\r\n<p>Nếu bạn y&ecirc;u th&iacute;ch thương hiệu realme v&agrave; đang t&igrave;m kiếm điện thoại c&oacute; khả năng sạc si&ecirc;u nhanh, mời bạn xem qua một số mẫu điện thoại từ thương hiệu n&agrave;y đang được b&aacute;n ở&nbsp;<a href=\"https://www.thegioididong.com/\" rel=\"noopener\" target=\"_blank\" title=\"Thế Giới Di Động\" type=\"Thế Giới Di Động\">Thế Giới Di Động</a>&nbsp;tại n&uacute;t m&agrave;u cam b&ecirc;n dưới nh&eacute;!</p>\r\n\r\n<p><strong><a href=\"https://www.thegioididong.com/dtdd-realme-sac-sieu-nhanh\" rel=\"nofollow noopener\" target=\"_blank\" title=\"MUA ĐIỆN THOẠI REALME SẠC NHANH\" type=\"MUA ĐIỆN THOẠI REALME GIÁ TỐT \">ĐIỆN THOẠI REALME SẠC SI&Ecirc;U NHANH</a></strong></p>', 'realme Neo7 chính thức xác nhận sẽ trang bị viên pin khủng 7000mAh', 13, 1, 'uploads/thumbnail/gMJg31HbcD2G23xFEEPXTXIABdezgLWaqF71FMsH.jpg', NULL, 'realme-neo7-chinh-thuc-xac-nhan-se-trang-bi-vien-pin-khung-7000mah', 'Công khai', '2025-11-25 12:38:26', '2024-12-02 00:39:05', '2025-11-25 05:38:26', 0, NULL, NULL),
(9, 'dêdêdedêdêdedêdedededededêffedfề', NULL, NULL, NULL, '<p>dfdfffffffffffffffffffffffffff</p>', 'df', 7, 1, NULL, NULL, 'dededededededededededededeffedfe', 'Công khai', '2024-12-17 08:18:54', '2024-12-17 01:18:54', '2024-12-17 01:19:04', 0, NULL, '2024-12-17 01:19:04'),
(10, 'OPPO xác nhận sẽ ra mắt A5 Pro vào ngày 24/12', NULL, NULL, NULL, '<p><strong>OPPO mới đ&acirc;y vừa x&aacute;c nhận họ sẽ ra mắt&nbsp;<a href=\"https://cellphones.com.vn/mobile/oppo.html\" target=\"_blank\">điện thoại OPPO</a>&nbsp;A5 Pro tại qu&ecirc; nh&agrave; Trung Quốc v&agrave;o ng&agrave;y 24/12 tới. Như t&ecirc;n gọi cho thấy, đ&acirc;y l&agrave; sản phẩm kế nhiệm của A3 Pro, vốn nổi tiếng về độ bền.</strong></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, th&ocirc;ng số kỹ thuật ch&iacute;nh của&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">điện thoại th&ocirc;ng minh</a>&nbsp;n&agrave;y vừa được tiết lộ tr&ecirc;n cơ quan chứng nhận TENAA.</p>\r\n\r\n<p><img alt=\"OPPO A5 Pro sẽ ra mắt ngày 24/12\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/Oppo-A5-Pro-ngay-ra-mat-1.jpg\" style=\"height:1200px; width:645px\" title=\"OPPO A5 Pro sẽ ra mắt ngày 24/12\" /></p>\r\n\r\n<p>OPPO A5 Pro sẽ ra mắt ng&agrave;y 24/12</p>\r\n\r\n<p>Theo đ&oacute;, OPPO A5 Pro được ph&aacute;t hiện tr&ecirc;n cơ quan chứng nhận TENAA với số model PKP110. Đ&uacute;ng như dự đo&aacute;n, chứng nhận n&agrave;y đ&atilde; tiết lộ hầu như mọi thứ về thiết bị. Cụ thể, danh s&aacute;ch tiết lộ mẫu điện thoại tầm trung sắp tới của OPPO sẽ được trang bị&nbsp;<a href=\"https://cellphones.com.vn/man-hinh.html\" target=\"_blank\">m&agrave;n h&igrave;nh</a>&nbsp;OLED phẳng 6.7 inch, hỗ trợ độ ph&acirc;n giải 2,412 x 1,080 pixel, tần số qu&eacute;t 120Hz v&agrave; độ s&acirc;u m&agrave;u 10 bit. M&agrave;n h&igrave;nh n&agrave;y được t&iacute;ch hợp m&aacute;y qu&eacute;t dấu v&acirc;n tay b&ecirc;n dưới để bảo mật.</p>\r\n\r\n<p>B&ecirc;n trong, A5 Pro được cung cấp sức mạnh đến từ con chip 8 nh&acirc;n c&oacute; xung nhịp tối đa 2.5GHz, đi k&egrave;m dung lượng RAM 8GB hoặc 12GB. N&oacute; c&ograve;n mang đến c&aacute;c t&ugrave;y chọn bộ nhớ trong 256GB v&agrave; 256GB, mang tới kh&ocirc;ng gian lưu trữ rộng r&atilde;i cho người d&ugrave;ng.</p>\r\n\r\n<p><img alt=\"OPPO A5 Pro có cấu hình khá tốt\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/Oppo-A5-Pro-ngay-ra-mat-cover.jpg\" style=\"height:675px; width:1200px\" title=\"OPPO A5 Pro có cấu hình khá tốt\" /></p>\r\n\r\n<p>OPPO A5 Pro c&oacute; cấu h&igrave;nh kh&aacute; tốt</p>\r\n\r\n<p>Về khả năng nhiếp ảnh, OPPO A5 Pro được trang bị&nbsp;<a href=\"https://cellphones.com.vn/phu-kien/camera.html\" target=\"_blank\">camera</a>&nbsp;trước 16 megapixel v&agrave; cụm camera k&eacute;p ph&iacute;a sau, gồm cảm biến ch&iacute;nh 50 megapixel v&agrave; m&aacute;y ảnh phụ 2 megapixel. Điện thoại được cung cấp năng lượng bởi pin 5,840mAh (gi&aacute; trị định mức). Hiện tại, kh&ocirc;ng c&oacute; th&ocirc;ng tin về khả năng sạc nhanh của A5 Pro. Thiết bị sẽ c&oacute; k&iacute;ch thước 161.5 x 74.85 x 7.67mm v&agrave; nặng khoảng 186 gram.&nbsp;</p>\r\n\r\n<p>Nguồn: Gizmochina</p>\r\n\r\n<p><strong>Xem th&ecirc;m:&nbsp;<a href=\"https://cellphones.com.vn/sforum/oppo-a5-pro-lo-cau-hinh\">OPPO A5 Pro lộ cấu h&igrave;nh chi tiết: Chip Dimensity 7300, pin 6000 mAh v&agrave; camera k&eacute;p 50MP</a></strong></p>\r\n\r\n<p><a href=\"https://cellphones.com.vn/\" target=\"_blank\">CellphoneS</a>&nbsp;hiện đang b&aacute;n kh&aacute; nhiều điện thoại OPPO chất lượng với gi&aacute; phải chăng m&agrave; bạn c&oacute; thể tham khảo ở danh s&aacute;ch b&ecirc;n dưới:</p>', 'OPPO xác nhận sẽ ra mắt A5 Pro vào ngày 24/12', 13, 1, 'uploads/thumbnail/slbWpL4s4vJqGe0I3Y4wRjxM4N91xocXwHAKDCrV.jpg', NULL, 'oppo-xac-nhan-se-ra-mat-a5-pro-vao-ngay-2412', 'Công khai', '2025-11-20 00:42:03', '2024-12-17 09:47:56', '2025-11-19 17:42:03', 0, NULL, NULL),
(11, 'Samsung có thể ra mắt “ốp lưng từ tính” mới cho Galaxy S25', NULL, NULL, NULL, '<h1>Samsung c&oacute; thể ra mắt &ldquo;ốp lưng từ t&iacute;nh&rdquo; mới cho Galaxy S25</h1>\r\n\r\n<p><strong>Đầu tuần n&agrave;y, một b&aacute;o c&aacute;o tiết lộ&nbsp;<a href=\"https://cellphones.com.vn/mobile/samsung/galaxy-s/s25-series.html\" target=\"_blank\">Galaxy S25 Series</a>&nbsp;c&oacute; hỗ trợ&nbsp;<a href=\"https://cellphones.com.vn/sforum\" target=\"_blank\">c&ocirc;ng nghệ</a>&nbsp;sạc kh&ocirc;ng d&acirc;y Qi2. Tuy nhi&ecirc;n, nguồn tin n&agrave;y kh&ocirc;ng chắc liệu c&aacute;c flagship tiếp theo của Samsung c&oacute; sử dụng Magnetic Power Profile (MPP) của Qi2 cho c&aacute;c phụ kiện c&oacute; căn chỉnh từ t&iacute;nh hay kh&ocirc;ng.</strong></p>\r\n\r\n<p>Giờ đ&acirc;y, một r&ograve; rỉ mới cho thấy Samsung dường như sẽ ph&aacute;t h&agrave;nh ốp lưng từ t&iacute;nh cho c&aacute;c&nbsp;<a href=\"https://cellphones.com.vn/mobile/samsung.html\" target=\"_blank\">điện thoại Galaxy</a>&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25.html\" target=\"_blank\">S25</a>&nbsp;sắp ra mắt của m&igrave;nh .</p>\r\n\r\n<p><img alt=\"Samsung có thể ra mắt ốp lưng từ tính cho dòng Galaxy S25\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/op-lung-tu-tinh-Galaxy-S25.jpg\" style=\"height:674px; width:1200px\" title=\"Samsung có thể ra mắt ốp lưng từ tính cho dòng Galaxy S25\" /></p>\r\n\r\n<p>Samsung c&oacute; thể ra mắt ốp lưng từ t&iacute;nh cho d&ograve;ng Galaxy S25</p>\r\n\r\n<p>Cụ thể, một nh&agrave; b&aacute;n lẻ&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">điện thoại</a>&nbsp;từ Phần Lan đ&atilde; v&ocirc; t&igrave;nh c&ocirc;ng bố th&ocirc;ng tin về c&aacute;c biến thể m&agrave;u của tất cả c&aacute;c điện thoại d&ograve;ng Galaxy S25 c&ugrave;ng với tất cả c&aacute;c phụ kiện ch&iacute;nh thức của ch&uacute;ng. Th&ocirc;ng tin cũng bao gồm c&aacute;c biến thể lưu trữ cho cả ba điện thoại sắp ra mắt.</p>\r\n\r\n<p>Theo nguồn tin n&agrave;y th&igrave; Samsung dường như sẽ ra mắt &ldquo;Ốp lưng từ t&iacute;nh&rdquo; cho Galaxy S25,&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25-plus.html\" target=\"_blank\">Galaxy S25+</a>&nbsp;v&agrave;&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25-ultra.html\" target=\"_blank\">Galaxy S25 Ultra</a>. Phụ kiện n&agrave;y sẽ chỉ c&oacute; m&agrave;u trong suốt cho cả ba điện thoại. Dự kiến, ốp lưng từ t&iacute;nh c&oacute; thể hoạt động với sạc kh&ocirc;ng d&acirc;y Qi2 v&agrave; căn chỉnh từ t&iacute;nh th&ocirc;ng qua bộ sạc kh&ocirc;ng d&acirc;y tương th&iacute;ch Qi2. Hy vọng, n&oacute; cũng sẽ tương th&iacute;ch với c&aacute;c phụ kiện Qi2 hoặc MagSafe kh&aacute;c như v&iacute;, sạc dự ph&ograve;ng.</p>\r\n\r\n<p>Cần lưu &yacute; rằng, d&ugrave; Qi2 t&iacute;ch hợp hệ thống MagSafe của&nbsp;<a href=\"https://cellphones.com.vn/apple\" target=\"_blank\">Apple</a>&nbsp;(gọi l&agrave; MPP) để căn chỉnh từ t&iacute;nh, nhưng đ&acirc;y l&agrave; t&iacute;nh năng t&ugrave;y chọn v&agrave; c&aacute;c thương hiệu c&oacute; thể loại trừ t&iacute;nh năng n&agrave;y v&agrave; vẫn nhận được chứng nhận Qi2.</p>\r\n\r\n<p>Samsung c&oacute; thể ra mắt c&aacute;c ốp lưng v&agrave; bao da ch&iacute;nh thức kh&aacute;c cho d&ograve;ng Galaxy S25. Ch&uacute;ng được liệt k&ecirc; b&ecirc;n dưới.</p>\r\n\r\n<ul>\r\n	<li>Clear Case (trong suốt)</li>\r\n	<li>Kindsuit Case (Đen, V&agrave;ng, X&aacute;m, Xanh nhạt)</li>\r\n	<li>Rugged Case (Đen)</li>\r\n	<li>Standing Grip Case (Đen, X&aacute;m, Trắng)</li>\r\n	<li>Silicone Case (Đen, Xanh lam, Xanh lam nhạt, Xanh bạc h&agrave;, Đỏ)</li>\r\n</ul>\r\n\r\n<p>Nếu th&ocirc;ng tin n&agrave;y l&agrave; ch&iacute;nh x&aacute;c, đ&acirc;y sẽ l&agrave; lần đầu ti&ecirc;n Samsung ra mắt Ốp lưng Kindsuit cho điện thoại d&ograve;ng Galaxy S. Hiện tại, ốp lưng n&agrave;y chỉ c&oacute; sẵn cho d&ograve;ng Galaxy Z m&agrave;n h&igrave;nh gập.</p>', 'Samsung có thể ra mắt “ốp lưng từ tính” mới cho Galaxy S25', 13, 1, 'uploads/thumbnail/DY4tROCCv7zjX9e8Gpm4xWES5Vx3BWXIxbRlhzSX.jpg', NULL, 'samsung-co-the-ra-mat-op-lung-tu-tinh-moi-cho-galaxy-s25', 'Công khai', '2025-11-25 12:38:55', '2024-12-17 09:52:50', '2025-11-25 05:38:55', 0, NULL, NULL),
(12, 'Dòng Galaxy S25 có thể được trang bị sạc MagSafe/Qi2 tiên tiến', NULL, NULL, NULL, '<h1>D&ograve;ng Galaxy S25 c&oacute; thể được trang bị sạc MagSafe/Qi2 ti&ecirc;n tiến</h1>\r\n\r\n<p><strong>Trong nhiều th&aacute;ng qua, ch&uacute;ng ta đ&atilde; li&ecirc;n tục được nh&igrave;n thấy th&ocirc;ng tin r&ograve; rỉ về d&ograve;ng Galaxy&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25.html\" target=\"_blank\">S25</a>&nbsp;xuất hiện tr&ecirc;n c&aacute;c trang mạng.</strong></p>\r\n\r\n<p>H&ocirc;m nay, một nguồn kh&aacute; uy t&iacute;n cho biết&nbsp;<a href=\"https://cellphones.com.vn/mobile/samsung.html\" target=\"_blank\">Samsung</a>&nbsp;c&oacute; thể ra mắt c&aacute;c flagship tiếp theo của m&igrave;nh v&agrave;o th&aacute;ng 1 năm sau với một t&iacute;nh năng kh&aacute; th&uacute; vị, đ&oacute; l&agrave; sạc kh&ocirc;ng d&acirc;y Qi2.</p>\r\n\r\n<p><img alt=\"Dòng Galaxy S25 có thể được trang bị sạc MagSafe/Qi2 tiên tiến\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/Galaxy-S25-sac-khong-day-Qi2.jpg\" style=\"height:674px; width:1200px\" title=\"Dòng Galaxy S25 có thể được trang bị sạc MagSafe/Qi2 tiên tiến\" /></p>\r\n\r\n<p>D&ograve;ng Galaxy S25 c&oacute; thể được trang bị sạc MagSafe/Qi2 ti&ecirc;n tiến</p>\r\n\r\n<p>Cụ thể, leaker nổi tiếng Ice Universe cho biết d&ograve;ng Galaxy S25 sẽ hỗ trợ Qi2 cho sạc kh&ocirc;ng d&acirc;y. Qi2 dựa tr&ecirc;n ti&ecirc;u chuẩn MagSafe của&nbsp;<a href=\"https://cellphones.com.vn/apple\" target=\"_blank\">Apple</a>&nbsp;v&agrave; c&oacute; t&iacute;nh năng căn chỉnh từ t&iacute;nh cho c&aacute;c thiết bị, phụ kiện được hỗ trợ. Mặc d&ugrave;&nbsp;<a href=\"https://cellphones.com.vn/sforum\" target=\"_blank\">c&ocirc;ng nghệ</a>&nbsp;n&agrave;y đ&atilde; được c&ocirc;ng bố c&aacute;ch đ&acirc;y hai năm, nhưng hiện c&oacute; kh&aacute; &iacute;t thương hiệu &aacute;p dụng n&oacute; cho thiết bị của m&igrave;nh.</p>\r\n\r\n<p>Samsung chưa sử dụng Qi2 trong bất kỳ&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">smartphone</a>&nbsp;n&agrave;o đ&atilde; ph&aacute;t h&agrave;nh của m&igrave;nh, nhưng c&oacute; một thiết bị của họ tương th&iacute;ch với Qi2, đ&oacute; l&agrave; Galaxy Ring. Galaxy S25,&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25-plus.html\" target=\"_blank\">Galaxy S25+</a>&nbsp;v&agrave;&nbsp;<a href=\"https://cellphones.com.vn/dien-thoai-samsung-galaxy-s25-ultra.html\" target=\"_blank\">Galaxy S25 Ultra</a>&nbsp;c&oacute; thể l&agrave; những sản phẩm Samsung tiếp theo hỗ trợ Qi2. Hơi đ&aacute;ng tiếc l&agrave; c&oacute; vẻ như ch&uacute;ng vẫn chỉ hỗ trợ c&ocirc;ng suất tối đa 15W.</p>\r\n\r\n<p>Qi2 cũng hỗ trợ một số phụ kiện c&oacute; căn chỉnh từ t&iacute;nh. V&igrave; vậy, bạn c&oacute; thể sử dụng ốp lưng, bao da v&agrave; v&iacute; gắn v&agrave;o Galaxy S25 bằng từ t&iacute;nh. D&ugrave; vậy, căn chỉnh từ t&iacute;nh l&agrave; một t&iacute;nh năng t&ugrave;y chọn trong Qi2 n&ecirc;n Samsung c&oacute; thể chọn kh&ocirc;ng hỗ trợ. Trong trường hợp đ&oacute;, bạn c&oacute; thể tạm biệt c&aacute;c phụ kiện từ t&iacute;nh. C&ugrave;ng chờ xem nh&eacute;!</p>', 'Dòng Galaxy S25 có thể được trang bị sạc MagSafe/Qi2 tiên tiến', 13, 1, 'uploads/thumbnail/FtLbsIovkbr0ba0OYXyuxzbaa3NJbiGnFE1EpgvN.jpg', NULL, 'dong-galaxy-s25-co-the-duoc-trang-bi-sac-magsafeqi2-tien-tien', 'Công khai', '2025-11-20 00:41:49', '2024-12-17 09:54:34', '2025-11-19 17:41:49', 0, NULL, NULL),
(13, 'Điện thoại đầu tiên của Elon Musk', NULL, NULL, NULL, '<h2><strong>Thiết kế tương tự c&aacute;c flapship kh&aacute;c</strong></h2>\r\n\r\n<p>Kh&ocirc;ng c&oacute; bất kỳ một th&ocirc;ng tin n&agrave;o bị r&ograve; rỉ từ nh&agrave; sản xuất, nhưng c&aacute;c nh&agrave; thiết kế s&aacute;ng tạo chỉ ra rằng, điện thoại Tesla được thiết kế tương tự như những chiếc flagship lớn của c&aacute;c &#39;&ocirc;ng lớn&#39; ng&agrave;nh&nbsp;<a href=\"https://cellphones.com.vn/sforum\" target=\"_blank\">c&ocirc;ng nghệ</a>&nbsp;như Google, Apple v&agrave; Samsung. Tesla Phone sở hữu vẻ bề ngo&agrave;i được trau chuốt vu&ocirc;ng vức, một số n&uacute;t ở c&aacute;c cạnh b&ecirc;n ngo&agrave;i v&agrave; đi k&egrave;m ba đến bốn&nbsp;<a href=\"https://cellphones.com.vn/phu-kien/camera.html\" target=\"_blank\">camera</a>&nbsp;ph&iacute;a sau.</p>\r\n\r\n<p><img alt=\"Thiết kế của điện thoại Tesla sẽ giống với các flapship khác\" src=\"https://cellphones.com.vn/sforum/wp-content/uploads/2023/02/thong_tin_ve_dien_thoai_tesla_4.jpg\" style=\"height:667px; width:1000px\" title=\"Thiết kế của điện thoại Tesla sẽ giống với các flapship khác\" /></p>\r\n\r\n<p>Thiết kế của điện thoại Tesla sẽ giống với c&aacute;c flapship kh&aacute;c</p>\r\n\r\n<p>Ngo&agrave;i ra, th&acirc;n m&aacute;y được l&agrave;m bằng kim loại, nổi bật nhất ch&iacute;nh l&agrave; logo Tesla giữa để kết nối to&agrave;n bộ g&oacute;i lại với nhau. Nh&igrave;n tổng quan, chiếc Tesla Phone sẽ c&oacute; thiết kế đi theo hướng tối giản, v&ocirc; c&ugrave;ng b&oacute;ng bẩy v&agrave; đặc biệt nhất l&agrave; n&oacute; tr&ocirc;ng như một thiết bị sang trọng cao cấp.</p>\r\n\r\n<h2><strong>Th&ocirc;ng số kỹ thuật l&agrave; điểm nhấn kh&aacute;c biệt của Tesla Phone</strong></h2>\r\n\r\n<p>Tiếp tục l&agrave; sự im lặng từ ph&iacute;a Tesla, tất cả c&aacute;c th&ocirc;ng tin m&agrave; mọi người nhận được chỉ l&agrave; sự mơ hồ v&agrave; đồn đo&aacute;n. Tin tức lần n&agrave;y cũng vậy, họ đồn đo&aacute;n chiếc điện thoại th&ocirc;ng minh n&agrave;y sẽ chạy tr&ecirc;n bộ vi xử l&yacute; l&otilde;i t&aacute;m của Tesla. Đ&acirc;y l&agrave; bộ vi được sử dụng để chạy&nbsp;<a href=\"https://cellphones.com.vn/man-hinh.html\" target=\"_blank\">m&agrave;n h&igrave;nh</a>&nbsp;b&ecirc;n trong &ocirc; t&ocirc; của h&atilde;ng xe Tesla.Nếu điều n&agrave;y thực sự xảy ra th&igrave; chiếc Tesla Phone sẽ th&agrave;nh th&agrave;nh chiếc điện thoại th&ocirc;ng minh c&oacute; bộ xử l&yacute; ch&iacute;nh kh&aacute;c biệt nhất tr&ecirc;n thị trường smartphone hiện nay.</p>\r\n\r\n<p><img alt=\"Thông số kỹ thuật có thể là điểm nhấn trên điện thoại của Elon Musk\" src=\"https://cellphones.com.vn/sforum/wp-content/uploads/2023/02/thong_tin_ve_dien_thoai_tesla_3.jpg\" style=\"height:666px; width:1000px\" title=\"Thông số kỹ thuật có thể là điểm nhấn trên điện thoại của Elon Musk\" /></p>\r\n\r\n<p>Th&ocirc;ng số kỹ thuật c&oacute; thể l&agrave; điểm nhấn tr&ecirc;n điện thoại của Elon Musk</p>\r\n\r\n<p>Chưa dừng lại ở đ&oacute;, một số người cũng cho biết th&ecirc;m rằng, Elon Musk sẽ cho điện thoại Tesla Pi kết nối với dịch vụ internet vệ tinh Starlink. Đồng thời, chiếc điện thoại n&agrave;y cũng được &aacute;p dụng c&ocirc;ng nghệ sạc năng lượng mặt trời để nạp năng lượng cho pin.</p>\r\n\r\n<h2><strong>Tesla Phone sẽ chạy hệ điều h&agrave;nh TeslaOS</strong></h2>\r\n\r\n<p>Một số tin đồn về hệ điều h&agrave;nh của điện thoại Tesla đ&atilde; khiến cho c&aacute;c fan của Elon Musk hết sức th&iacute;ch th&uacute; v&agrave; mong đợi. Họ dự đo&aacute;n, Tesla Pi sẽ chạy tr&ecirc;n một hệ điều h&agrave;nh chưa hề tồn tại cho đến thời điểm n&agrave;y v&agrave; n&oacute; c&oacute; t&ecirc;n l&agrave; TeslaOS.</p>\r\n\r\n<p><img alt=\"Hệ điều hành Tesla OS v8.0 trên xe ô tô\" src=\"https://cellphones.com.vn/sforum/wp-content/uploads/2023/02/thong_tin_ve_dien_thoai_tesla_10.jpg\" style=\"height:720px; width:1280px\" title=\"Hệ điều hành Tesla OS v8.0 trên xe ô tô\" /></p>\r\n\r\n<p>Hệ điều h&agrave;nh Tesla OS v8.0 tr&ecirc;n xe &ocirc; t&ocirc;</p>\r\n\r\n<p>Hệ điều h&agrave;nh n&agrave;y c&oacute; thể sử dụng tr&ecirc;n nhiều thiết bị kh&aacute;c nhau bởi t&iacute;nh linh hoạt của n&oacute; v&agrave; c&oacute; thể n&oacute; sẽ sử dụng phi&ecirc;n bản Android. Tuy nhi&ecirc;n, Musk đ&atilde; từng tuy&ecirc;n bố sẽ kh&ocirc;ng bao giờ tham gia v&agrave;o &ldquo;sự độc quyền&rdquo; của Google hay Apple trong ng&agrave;nh smarrtphone.</p>\r\n\r\n<h2><strong>Gi&aacute; điện thoại Tesla v&agrave; ng&agrave;y ph&aacute;t h&agrave;nh</strong></h2>\r\n\r\n<p>Th&ocirc;ng tin về ng&agrave;y ph&aacute;t h&agrave;nh v&agrave; gi&aacute; điện thoại cũng chỉ l&agrave; những sự suy đo&aacute;n ho&agrave;n to&agrave;n v&ocirc; căn cứ. Một số người cho rằng Tesla sẽ cho ra mắt chiếc điện thoại th&ocirc;ng minh đầu ti&ecirc;n của h&atilde;ng v&agrave;o khoảng đầu năm 2023.</p>\r\n\r\n<p><img alt=\"Điện thoại Tesla sẽ được thiết kế để tương thích trên xe hơi\" src=\"https://cellphones.com.vn/sforum/wp-content/uploads/2023/02/thong_tin_ve_dien_thoai_tesla_1.jpg\" style=\"height:663px; width:1000px\" title=\"Điện thoại Tesla sẽ được thiết kế để tương thích trên xe hơi\" /></p>\r\n\r\n<p>Điện thoại Tesla sẽ được thiết kế để tương th&iacute;ch tr&ecirc;n xe hơi</p>\r\n\r\n<p>Nhưng ch&uacute;ng ta n&ecirc;n biết rằng, để sản xuất ra chiếc điện thoại th&ocirc;ng minh sẽ mất rất nhiều thời gian. Vậy ở đ&acirc;y, Musk chỉ đưa ra &yacute; tưởng của m&igrave;nh v&agrave;o th&aacute;ng 11 năm 2022, như vậy, ch&uacute;ng ta kh&ocirc;ng n&ecirc;n mong đợi n&oacute; ra mắt sẽ ra mắt trước năm 2024.Về phần gi&aacute; cả của chiếc điện thoại n&agrave;y, c&aacute;c chuy&ecirc;n gia ph&acirc;n t&iacute;ch v&agrave; định gi&aacute; phỏng đo&aacute;n sẽ &iacute;t nhất 1,000 đ&ocirc; la (khoảng chừng 24 triệu đồng). Đ&acirc;y chỉ l&agrave; mức gi&aacute; phỏng chừng, c&oacute; thể gi&aacute; khi ra mắt sẽ cao hơn cho một chiếc điện thoại ho&agrave;n chỉnh v&agrave; c&oacute; đủ sức cạnh tranh với Apple v&agrave; Samsung.</p>', 'Điện thoại đầu tiên của Elon Musk', 13, 1, 'uploads/thumbnail/pOXdGVRuf2aI5760ZKBWP8uyRjkx1o7TEHDLUY8D.jpg', NULL, 'dien-thoai-dau-tien-cua-elon-musk', 'Công khai', '2025-11-20 00:41:40', '2024-12-17 09:56:48', '2025-11-19 17:41:40', 0, NULL, NULL),
(14, 'Màn hình chống chói của Galaxy S24 Ultra bị lỗi', NULL, NULL, NULL, '<h1>M&agrave;n h&igrave;nh chống ch&oacute;i của Galaxy S24 Ultra bị lỗi khiến người d&ugrave;ng kh&oacute; chịu, bạn c&oacute; bị kh&ocirc;ng?</h1>\r\n\r\n<p><strong>Theo một r&ograve; rỉ mới, mẫu flagship&nbsp;<a href=\"https://cellphones.com.vn/samsung-galaxy-s24-ultra.html\" target=\"_blank\">Galaxy S24 Ultra</a>&nbsp;của&nbsp;<a href=\"https://cellphones.com.vn/mobile/samsung.html\" target=\"_blank\">Samsung</a>&nbsp;dường như đang gặp vấn đề về lớp phủ chống ch&oacute;i mới của&nbsp;<a href=\"https://cellphones.com.vn/man-hinh.html\" target=\"_blank\">m&agrave;n h&igrave;nh</a>.</strong></p>\r\n\r\n<p>Chưa đầy một năm sau khi&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">điện thoại</a>&nbsp;ra mắt, lớp phủ n&agrave;y bắt đầu bong ra, đặc biệt l&agrave; ở những khu vực được sử dụng nhiều nhất để cuộn v&agrave; trong một số trường hợp, lỗi xuất hiện xung quanh c&aacute;c cạnh của m&agrave;n h&igrave;nh.</p>\r\n\r\n<p><img alt=\"Nhiều người dùng Galaxy S24 Ultra đang phàn nàn về lỗi lớp phủ chống chói màn hình\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/man-hinh-chong-choi-Galaxy-S24-Ultra-1.jpg\" style=\"height:675px; width:1200px\" title=\"Nhiều người dùng Galaxy S24 Ultra đang phàn nàn về lỗi lớp phủ chống chói màn hình\" /></p>\r\n\r\n<p>Nhiều người d&ugrave;ng Galaxy&nbsp;<a href=\"https://cellphones.com.vn/samsung-galaxy-s24.html\" target=\"_blank\">S24</a>&nbsp;Ultra đang ph&agrave;n n&agrave;n về lỗi lớp phủ chống ch&oacute;i m&agrave;n h&igrave;nh</p>\r\n\r\n<p>Theo đ&oacute;, nhiều người d&ugrave;ng Galaxy S24 Ultra hiện ph&agrave;n n&agrave;n rằng lớp phủ chống ch&oacute;i của Galaxy S24 Ultra, t&iacute;nh năng g&oacute;p phần tạo n&ecirc;n m&agrave;n h&igrave;nh sắc n&eacute;t v&agrave; kh&ocirc;ng bị ch&oacute;i, đang xuống cấp sớm hơn nhiều so với dự kiến. Một người d&ugrave;ng X, @xeetechcare, đ&atilde; đăng h&igrave;nh ảnh cho thấy m&agrave;n h&igrave;nh bị bong tr&oacute;c ở cạnh phải v&agrave; c&oacute; đốm tr&ecirc;n khắp bề mặt.</p>\r\n\r\n<p>Người n&agrave;y x&aacute;c nhận rằng, điện thoại kh&ocirc;ng bị ảnh hưởng bởi bất kỳ yếu tố b&ecirc;n ngo&agrave;i n&agrave;o như ch&igrave;a kh&oacute;a hoặc tiền xu trong t&uacute;i quần, loại trừ c&aacute;c nguy&ecirc;n nh&acirc;n phổ biến g&acirc;y hư hỏng m&agrave;n h&igrave;nh. Tuy nhi&ecirc;n, c&aacute;c vết xước vẫn c&ograve;n nh&igrave;n thấy được v&agrave; những người d&ugrave;ng kh&aacute;c cũng chia sẻ những c&acirc;u chuyện tương tự, cho thấy Galaxy S24 Ultra thực sự đang gặp vấn đề về lớp phủ chống ch&oacute;i của m&agrave;n h&igrave;nh.</p>\r\n\r\n<p><img alt=\"Lớp phủ chống chói màn hình Galaxy S24 Ultra bị lỗi ở vị trí người dùng thường sử dụng hoặc ở cạnh màn hình\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/man-hinh-chong-choi-Galaxy-S24-Ultra-2.jpg\" style=\"height:1200px; width:900px\" title=\"Lớp phủ chống chói màn hình Galaxy S24 Ultra bị lỗi ở vị trí người dùng thường sử dụng hoặc ở cạnh màn hình\" /></p>\r\n\r\n<p>Lớp phủ chống ch&oacute;i m&agrave;n h&igrave;nh Galaxy S24 Ultra bị lỗi ở vị tr&iacute; người d&ugrave;ng thường sử dụng hoặc ở cạnh m&agrave;n h&igrave;nh</p>\r\n\r\n<p>Một số người d&ugrave;ng kh&aacute;c đ&atilde; chia sẻ h&igrave;nh ảnh về thiết bị của họ, cho thấy c&aacute;c vết hằn vĩnh viễn do lớp phủ bị m&ograve;n, c&oacute; vẻ như dễ bị trầy xước nhỏ do bản chất tương đối mềm hơn so với lớp k&iacute;nh b&ecirc;n dưới. Một người d&ugrave;ng c&oacute; t&ecirc;n Hannes Brecher từ Notebookcheck nhấn mạnh rằng, lớp phủ c&oacute; thể qu&aacute; mỏng manh để chịu được sự hao m&ograve;n th&ocirc;ng thường, điều n&agrave;y c&oacute; thể giải th&iacute;ch tại sao rất nhiều người d&ugrave;ng gặp phải vấn đề n&agrave;y ngay sau khi mua thiết bị.</p>\r\n\r\n<p>Hiện tại, Samsung vẫn chưa b&igrave;nh luận về vấn đề n&agrave;y, khiến người d&ugrave;ng kh&ocirc;ng chắc chắn liệu hư hỏng m&agrave;n h&igrave;nh c&oacute; được bảo h&agrave;nh hay kh&ocirc;ng hoặc liệu đ&oacute; c&oacute; phải l&agrave; lỗi thiết kế c&oacute; thể ảnh hưởng đến nhiều thiết bị Galaxy S24 Ultra hơn kh&ocirc;ng. Đ&atilde; c&oacute; b&aacute;o c&aacute;o trong Cộng đồng Samsung về &ldquo;lớp phủ oleophobic bong ra&rdquo;. Tuy nhi&ecirc;n, c&ocirc;ng ty đ&atilde; từ chối bảo h&agrave;nh, với l&yacute; do đ&oacute; l&agrave; hao m&ograve;n tự nhi&ecirc;n.</p>\r\n\r\n<p><img alt=\"Khá nhiều người đã lên diễn đàn công nghệ để phàn nàn lỗi lớp phủ chống chói màn hình Galaxy S24 Ultra\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/man-hinh-chong-choi-Galaxy-S24-Ultra-3.jpg\" style=\"height:532px; width:1200px\" title=\"Khá nhiều người đã lên diễn đàn công nghệ để phàn nàn lỗi lớp phủ chống chói màn hình Galaxy S24 Ultra\" /></p>\r\n\r\n<p>Kh&aacute; nhiều người đ&atilde; l&ecirc;n diễn đ&agrave;n&nbsp;<a href=\"https://cellphones.com.vn/sforum\" target=\"_blank\">c&ocirc;ng nghệ</a>&nbsp;để ph&agrave;n n&agrave;n lỗi lớp phủ chống ch&oacute;i m&agrave;n h&igrave;nh Galaxy S24 Ultra</p>\r\n\r\n<p>Do đ&oacute;, người d&ugrave;ng Galaxy S24 Ultra được khuy&ecirc;n n&ecirc;n chăm s&oacute;c m&agrave;n h&igrave;nh cẩn thận hơn. Chỉ n&ecirc;n vệ sinh m&agrave;n h&igrave;nh bằng vải sợi nhỏ, tr&aacute;nh bất kỳ dung dịch vệ sinh n&agrave;o c&oacute; khả năng l&agrave;m hỏng th&ecirc;m lớp phủ chống ch&oacute;i. Mặc d&ugrave; sử dụng miếng d&aacute;n bảo vệ m&agrave;n h&igrave;nh c&oacute; thể gi&uacute;p ngăn ngừa hư hỏng, nhưng n&oacute; cũng sẽ l&agrave;m lớp phủ chống phản chiếu b&ecirc;n dưới miếng d&aacute;n mất t&aacute;c dụng, khiến người d&ugrave;ng phải đ&aacute;nh đổi giữa khả năng bảo vệ v&agrave; chất lượng hiển thị.</p>\r\n\r\n<p>Nguồn: Gizmochina</p>', 'Màn hình chống chói của Galaxy S24 Ultra bị lỗi', 13, 1, 'uploads/thumbnail/PTF0mx8wAAKVLcejP5qlnik74SLkmEtVGbIhfld1.jpg', NULL, 'man-hinh-chong-choi-cua-galaxy-s24-ultra-bi-loi', 'Công khai', '2025-11-20 00:41:31', '2024-12-17 09:58:53', '2026-01-27 18:07:53', 7, NULL, NULL),
(15, 'OPPO công bố dịch vụ cao cấp cho dòng Find X8', NULL, NULL, NULL, '<h1>OPPO c&ocirc;ng bố dịch vụ cao cấp cho d&ograve;ng Find X8, bao gồm thay m&agrave;n h&igrave;nh miễn ph&iacute;</h1>\r\n\r\n<p><strong><a href=\"https://cellphones.com.vn/mobile/oppo.html\" target=\"_blank\">OPPO</a>&nbsp;đ&atilde; ra mắt d&ograve;ng Find X8 v&agrave;o th&aacute;ng 11, đ&aacute;nh dấu sự trở lại của họ tr&ecirc;n ph&acirc;n kh&uacute;c smartphone cao cấp tại một số thị trường ch&iacute;nh.</strong></p>\r\n\r\n<p>Giờ đ&acirc;y, c&ocirc;ng ty muốn h&acirc;m mộ cảm thấy thoải m&aacute;i khi sở hữu một chiếc flagship đắt tiền khi vừa c&ocirc;ng bố Dịch vụ cao cấp ở một số quốc gia.</p>\r\n\r\n<p><img alt=\"OPPO công bố dịch vụ cao cấp cho dòng Find X8\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/dich-vu-sua-chua-OPPO-1.jpg\" style=\"height:599px; width:1200px\" title=\"OPPO công bố dịch vụ cao cấp cho dòng Find X8\" /></p>\r\n\r\n<p>OPPO c&ocirc;ng bố dịch vụ cao cấp cho d&ograve;ng Find X8</p>\r\n\r\n<p>Theo đ&oacute;, OPPO Find X8 v&agrave; Find X8 Pro được bảo h&agrave;nh quốc tế tại 62 quốc gia v&agrave; khu vực. Bạn c&oacute; thể t&igrave;m đến trung t&acirc;m dịch vụ OPPO tại quốc gia của m&igrave;nh để được hỗ trợ, sửa chữa, bảo tr&igrave; v&agrave; cập nhật phần mềm. OPPO đ&atilde; tuyển dụng v&agrave; đ&agrave;o tạo hơn 12,000 nh&acirc;n vi&ecirc;n sửa chữa v&agrave; kỹ sư tr&ecirc;n to&agrave;n thế giới để gi&uacute;p bảo dưỡng&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">điện thoại</a>&nbsp;của bạn.</p>\r\n\r\n<p>C&ocirc;ng ty sẽ cung cấp g&oacute;i bảo vệ&nbsp;<a href=\"https://cellphones.com.vn/man-hinh.html\" target=\"_blank\">m&agrave;n h&igrave;nh</a>&nbsp;miễn ph&iacute; cho chủ sở hữu Find X8 series tại c&aacute;c thị trường như Indonesia, Việt Nam v&agrave; Malaysia. G&oacute;i n&agrave;y bao gồm thay m&agrave;n h&igrave;nh miễn ph&iacute; một lần cho c&aacute;c hư hỏng do tai nạn. Ngo&agrave;i ra, thời gian bảo h&agrave;nh được gia hạn th&ecirc;m 12 th&aacute;ng.</p>\r\n\r\n<p><img alt=\"Người dùng OPPO Find X8 sẽ được thay màn hình miễn phí\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/dich-vu-sua-chua-OPPO-2.jpg\" style=\"height:400px; width:1200px\" title=\"Người dùng OPPO Find X8 sẽ được thay màn hình miễn phí\" /></p>\r\n\r\n<p>Người d&ugrave;ng OPPO Find X8 sẽ được thay m&agrave;n h&igrave;nh miễn ph&iacute;</p>\r\n\r\n<p>Tại một số thị trường được chọn, người d&ugrave;ng sẽ c&oacute; thể gọi đến đường d&acirc;y n&oacute;ng để được trợ gi&uacute;p. Người tiếp nhận c&oacute; thể hướng dẫn họ đến c&aacute;c trung t&acirc;m dịch vụ (nơi bạn sẽ được tiếp cận c&aacute;c dịch vụ cao cấp để khắc phục lỗi một c&aacute;ch nhanh ch&oacute;ng) v&agrave; bạn sẽ được mượn điện thoại cao cấp trong khi thiết bị của m&igrave;nh đang được sửa chữa. C&aacute;c trung t&acirc;m dịch vụ cũng c&oacute; thể thực hiện c&aacute;c bước bảo tr&igrave; như vệ sinh thiết bị của bạn. Nếu kh&ocirc;ng c&oacute; trung t&acirc;m bảo h&agrave;nh, sửa chữa n&agrave;o gần đ&oacute;, OPPO sẽ cung cấp dịch vụ sửa chữa miễn ph&iacute; tại c&aacute;c khu vực được chọn, do đ&oacute; bạn vẫn sẽ nhận được dịch vụ sửa chữa theo c&ugrave;ng ti&ecirc;u chuẩn.</p>', 'OPPO công bố dịch vụ cao cấp cho dòng Find X8', 13, 1, 'uploads/thumbnail/AhwleGwElFYIfXHpS4eovkT7XUvFIWbyLcF5reb8.jpg', NULL, 'oppo-cong-bo-dich-vu-cao-cap-cho-dong-find-x8', 'Công khai', '2025-11-20 00:41:04', '2024-12-17 10:01:09', '2025-11-19 17:41:04', 0, NULL, NULL),
(16, 'Vivo Y300 5G ra mắt với chip Dimensity 6300', 'dadada', 'dadada', 'adadad', '<h1>Vivo Y300 5G ra mắt với chip Dimensity 6300, pin 6500 mAh v&agrave; camera k&eacute;p 50MP, gi&aacute; từ 4.88 triệu đồng</h1>\r\n\r\n<p><strong>Đ&uacute;ng như th&ocirc;ng b&aacute;o trước đ&oacute;, vivo h&ocirc;m nay đ&atilde; ch&iacute;nh thức ra mắt một chiếc smartphone tầm trung mới tại thị trường Trung Quốc, c&oacute; t&ecirc;n gọi l&agrave; vivo Y300 5G.</strong></p>\r\n\r\n<p>Điểm nhấn của điện thoại n&agrave;y đến từ thiết kế bắt mắt, cấu h&igrave;nh phần cứng kh&aacute; mạnh mẽ v&agrave; đi k&egrave;m nhiều t&iacute;nh năng th&uacute; vị.</p>\r\n\r\n<p><img alt=\"vivo Y300 5G ra mắt\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/vivo-Y300-5G-ra-mat-1.jpg\" style=\"height:675px; width:1200px\" title=\"vivo Y300 5G ra mắt\" /></p>\r\n\r\n<p>vivo Y300 5G ra mắt</p>\r\n\r\n<p>Cụ thể, vivo Y300 5G được trang bị&nbsp;<a href=\"https://cellphones.com.vn/man-hinh.html\" target=\"_blank\">m&agrave;n h&igrave;nh</a>&nbsp;AMOLED cao cấp, c&oacute; k&iacute;ch thước 6.77 inch, hỗ trợ độ ph&acirc;n giải Full-HD+ v&agrave; tần số qu&eacute;t 120Hz mượt m&agrave;. M&agrave;n h&igrave;nh sử dụng thiết kế đục lỗ để chứa&nbsp;<a href=\"https://cellphones.com.vn/phu-kien/camera.html\" target=\"_blank\">camera</a>&nbsp;selfie 8MP với ống k&iacute;nh khẩu độ f/2.05. Ở mặt sau,&nbsp;<a href=\"https://cellphones.com.vn/mobile.html\" target=\"_blank\">điện thoại th&ocirc;ng minh</a>&nbsp;n&agrave;y sở hữu hệ thống camera k&eacute;p chất lượng, bao gồm cảm biến ch&iacute;nh 50MP v&agrave; m&aacute;y ảnh phụ 2MP.</p>\r\n\r\n<p><img alt=\"Điện thoại mới của vivo có cấu hình khá tốt\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/vivo-Y300-5G-ra-mat-3.jpg\" style=\"height:675px; width:1200px\" title=\"Điện thoại mới của vivo có cấu hình khá tốt\" /></p>\r\n\r\n<p>Điện thoại mới của vivo c&oacute; cấu h&igrave;nh kh&aacute; tốt</p>\r\n\r\n<p>B&ecirc;n trong, vivo Y300 5G được cung cấp sức mạnh đến từ con chip MediaTek Dimensity 6300 được x&acirc;y dựng tr&ecirc;n tiến tr&igrave;nh 6nm ti&ecirc;n tiến, c&oacute; 8 nh&acirc;n với xung nhịp tối đa 2.4GHz. Điện thoại c&ograve;n sở hữu dung lượng RAM l&ecirc;n tới 12GB v&agrave; bộ nhớ trong tối đa 512GB, mang tới khả năng đa nhiệm ấn tượng cũng như kh&ocirc;ng gian lưu trữ cực kỳ rộng r&atilde;i.</p>\r\n\r\n<p>Điểm nhấn của vivo Y300 5G c&ograve;n đến từ vi&ecirc;n pin 6,500 mAh ấn tượng với hỗ trợ sạc nhanh 44W trong th&acirc;n m&aacute;y mỏng 7.85mm. Điện thoại được c&agrave;i sẵn giao diện người d&ugrave;ng OriginOS 5 ngay khi xuất xưởng, c&oacute; hệ thống loa stereo chất lượng.</p>\r\n\r\n<p><img alt=\"vivo Y300 5G có camera kép 50MP + 2MP ở mặt sau\" src=\"https://cdn-media.sforum.vn/storage/app/media/trannghia/vivo-Y300-5G-ra-mat-2.jpg\" style=\"height:1200px; width:1181px\" title=\"vivo Y300 5G có camera kép 50MP + 2MP ở mặt sau\" /></p>\r\n\r\n<p>vivo Y300 5G c&oacute; camera k&eacute;p 50MP + 2MP ở mặt sau</p>\r\n\r\n<p>vivo Y300 5G c&oacute; c&aacute;c t&ugrave;y chọn m&agrave;u Xanh l&aacute; c&acirc;y, Trắng v&agrave; Đen. N&oacute; c&oacute; gi&aacute; khởi điểm từ 1,399 Yuan (khoảng 4.88 triệu đồng) cho biến thể 8GB/128GB. C&aacute;c biến thể 8GB/256GB, 12GB/256GB v&agrave; 12GB/512GB c&oacute; gi&aacute; lần lượt l&agrave; 1,599 Yuan (khoảng 5.57 triệu đồng), 1,799 Yuan (khoảng 6.27 triệu đồng), 1,999 Yuan (khoảng 6.96 triệu đồng).</p>', 'Vivo Y300 5G ra mắt với chip Dimensity 6300,', 13, 1, 'uploads/thumbnail/FqPjItnl6UI5IzSS6EhVbf2E4xfRTW7jPxxLCPnw.jpg', 'Vivo Y300 5G ra mắt với chip Dimensity 6300', 'vivo-y300-5g-ra-mat-voi-chip-dimensity-6300', 'Công khai', '2025-11-20 00:40:50', '2024-12-17 10:02:28', '2026-01-27 17:30:14', 0, NULL, NULL),
(17, 'rveve', NULL, NULL, NULL, '<p>vfdbdbdg</p>', 'dbddntyntynyn', 13, 1, 'uploads/thumbnail/Bi8rrnE5MKhks3fBOsUf0trsrm6y2niur1JxX5tO.jpg', NULL, 'rveve', 'Công khai', '2025-01-03 09:28:44', '2025-01-03 02:28:44', '2025-01-03 02:29:35', 0, NULL, '2025-01-03 02:29:35'),
(18, 'fafaffffff', 'fdafafddđ', 'dfafafaf', 'fafa', '<p>dfadfdafdafa</p>', 'sdadadada', 13, 1, 'uploads/thumbnail/vbioxCJ0T3EQ2xyh7UYY2qcvUoYmk9R82EKmGd8K.jpg', 'dâfafafa', 'fafaffffff', 'Công khai', '2026-01-29 03:14:47', '2026-01-27 16:30:59', '2026-01-28 20:15:04', 1, NULL, NULL),
(19, 'ffadfaf', 'fdafadf', 'gagadsfsdfasfaf', 'fadfadfa', '<p>dfaddfafafa</p>', 'fdaffafa', 13, 1, 'uploads/thumbnail/jquwQqcmwe3yC4ZRdgVJ8utp6lvehRDqEzwpeN26.jpg', 'fdafafad', 'ffadfaf', 'Công khai', '2026-01-29 03:09:03', '2026-01-28 20:09:03', '2026-01-28 20:27:01', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_code` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `shipping_province_id` varchar(50) DEFAULT NULL,
  `shipping_district_id` varchar(50) DEFAULT NULL,
  `shipping_ward_id` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `subtotal` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Tổng tiền hàng (chưa ship, chưa giảm)',
  `shipping_fee` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Phí vận chuyển',
  `tax_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Thuế (nếu có)',
  `total_price` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `shipping_discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `grand_total` decimal(15,2) DEFAULT 0.00,
  `payment_status` enum('unpaid','paid','refunded','failed') NOT NULL DEFAULT 'unpaid',
  `status` enum('Chờ xác nhận','Đã xác nhận','Đang chuẩn bị hàng','Đang giao hàng','Giao hàng thất bại','Đã hoàn thành','Đã hủy','Trả hàng/Hoàn tiền') NOT NULL DEFAULT 'Chờ xác nhận',
  `cancel_reason` text DEFAULT NULL COMMENT 'Lý do hủy đơn',
  `canceled_by` enum('customer','admin','system') DEFAULT NULL COMMENT 'Người hủy đơn',
  `shipping_method` varchar(100) DEFAULT NULL COMMENT 'Đơn vị vận chuyển (GHN, GHTK...)',
  `tracking_number` varchar(100) DEFAULT NULL COMMENT 'Mã vận đơn',
  `staff_id` bigint(20) UNSIGNED DEFAULT NULL,
  `additional_status` varchar(255) DEFAULT NULL,
  `voucher_id` bigint(20) UNSIGNED DEFAULT NULL,
  `shipping_voucher_id` bigint(20) UNSIGNED DEFAULT NULL,
  `voucher_code` varchar(50) DEFAULT NULL COMMENT 'Mã voucher đã dùng',
  `shipping_voucher_code` varchar(255) DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `customer_id`, `order_code`, `name`, `address`, `shipping_province_id`, `shipping_district_id`, `shipping_ward_id`, `phone`, `email`, `description`, `payment_method`, `subtotal`, `shipping_fee`, `tax_amount`, `total_price`, `discount_amount`, `shipping_discount_amount`, `grand_total`, `payment_status`, `status`, `cancel_reason`, `canceled_by`, `shipping_method`, `tracking_number`, `staff_id`, `additional_status`, `voucher_id`, `shipping_voucher_id`, `voucher_code`, `shipping_voucher_code`, `payment_date`, `created_at`, `updated_at`) VALUES
(89, 10, NULL, '0B894EE7', 'Pham Van Minh', 'Ngõ 5', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 12000000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đang giao hàng', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-08 07:50:32', '2025-01-10 06:56:51'),
(90, 10, 11, 'D3E53CE8', 'Pham Van Minh', 'Ngõ 6 đường 422b Vân Canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 20000000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-09 21:08:30', '2025-01-10 06:58:46'),
(91, 10, 11, 'E3866A69', 'Pham Van Minh', 'Ngõ 6 đường 422b Vân Canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 21190000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-09 21:12:40', '2025-01-10 06:57:39'),
(92, 15, 11, 'F46BDFBB', 'Pham Van Minh', 'Ngõ 6 đường 422b Vân Canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'Thanh toán trực tuyến (VNPay)', 0.00, 0.00, 0.00, 64290000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đã xác nhận', NULL, NULL, NULL, NULL, NULL, 'Đã thanh toán', NULL, NULL, NULL, NULL, '2025-01-09 21:20:27', '2025-01-09 21:17:10', '2025-01-09 22:16:53'),
(93, 13, 11, '09EF0CF9', 'Pham Van Minh', 'Ngõ 6 đường 422b Vân Canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 17000000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-09 21:22:54', '2025-01-09 22:30:19'),
(94, NULL, 11, '144644BF', 'Pham Van Minh', 'Ngõ 3 khu đô thị vân canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'Thanh toán trực tuyến (VNPay)', 0.00, 0.00, 0.00, 44000000.00, 0.00, 0.00, 0.00, 'failed', 'Đã hủy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-09 23:42:12', '2025-01-09 23:42:36'),
(95, 13, 11, '4D142C67', 'Pham Van Minh', 'Ngõ 3 khu đô thị vân canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 24000000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đang giao hàng', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-10 06:57:21', '2025-01-10 07:01:31'),
(96, 13, 11, 'AD883077', 'Pham Van Minh', 'Ngõ 3 khu đô thị vân canh', NULL, NULL, NULL, '1637587288', 'minhtit2004vkc@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 4790000.00, 0.00, 0.00, 0.00, 'unpaid', 'Đã hủy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-01-10 07:23:04', '2025-11-18 04:49:52'),
(103, NULL, NULL, '9A1E87F9', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 23950000.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-20 18:00:17', '2025-11-20 18:00:17'),
(105, NULL, NULL, 'E4C492DD', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'duclong.yn@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 15000.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-25 03:00:44', '2025-11-25 03:00:44'),
(111, NULL, 20, '77E0AA2B', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 37600.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-20 07:55:58', '2026-01-20 07:55:58'),
(112, NULL, 20, '8CD529BD', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 37600.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-20 08:01:33', '2026-01-20 08:01:33'),
(113, NULL, 20, '9E8697DB', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 37600.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-20 08:06:16', '2026-01-20 08:06:16'),
(114, NULL, 20, 'E62BA93E', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 37600.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-20 08:25:22', '2026-01-20 08:25:22'),
(115, NULL, 20, '335F2CA9', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 37600.00, 0.00, 0.00, 0.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-20 08:45:57', '2026-01-20 08:45:57'),
(116, NULL, 20, '658600AE', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 2200.00, 0.00, 0.00, 0.00, 'paid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL, NULL, '2026-01-22 07:23:02', '2026-01-20 08:59:20', '2026-01-22 07:23:02'),
(117, NULL, 20, 'ORDYQCLF1TJ', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 0.00, 0.00, 0.00, 4200.00, 0.00, 0.00, 0.00, 'paid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL, NULL, '2026-01-22 07:09:33', '2026-01-20 09:13:41', '2026-01-22 07:09:33'),
(118, NULL, 20, 'ORD-BOEDKKFYXD', 'Minh Ngọc', 'fadfafadfafa, Xã Bình Ba, Huyện Châu Đức, Tỉnh Bà Rịa - Vũng Tàu', '77', '750', '26578', '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 8000.00, 30000.00, 0.00, 38000.00, 0.00, 0.00, 38000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-22 21:24:42', '2026-01-22 21:24:42'),
(119, NULL, 20, 'ORD-0QQTS4YQMC', 'Trần Minh Ngọc', 'Số 4534, dfh, Xã Mỹ Hưng, Huyện Mỹ Lộc, Tỉnh Nam Định', '36', '358', '13729', '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 6000.00, 30000.00, 0.00, 36000.00, 0.00, 0.00, 36000.00, 'paid', 'Đã hoàn thành', NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL, NULL, '2026-01-22 21:28:10', '2026-01-22 21:27:06', '2026-01-22 21:28:10'),
(120, NULL, 20, 'ORD-HZVF59MXHR', 'Hải Nam', 'fadfafa, Xã Mai Lạp, Huyện Chợ Mới, Tỉnh Bắc Kạn', '06', '065', '02095', '0382677204', 'hainamkid@gmail.com', 'ẻwrewrwerw', 'COD', 5000.00, 30000.00, 0.00, 35000.00, 0.00, 0.00, 35000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-23 11:30:12', '2026-01-23 11:30:12'),
(121, NULL, 20, 'ORD-Y1CFJ5RPSM', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 4200.00, 30000.00, 0.00, 34200.00, 0.00, 0.00, 34200.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-23 11:31:54', '2026-01-23 11:31:54'),
(122, NULL, 20, 'ORD-BHYD8MORCV', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 4200.00, 30000.00, 0.00, 34200.00, 0.00, 0.00, 34200.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-23 11:58:24', '2026-01-23 11:58:24'),
(123, NULL, 20, 'ORD-VKCHFO7YLX', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 2100.00, 30000.00, 0.00, 32100.00, 0.00, 0.00, 32100.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-23 11:59:05', '2026-01-23 11:59:05'),
(124, NULL, 20, 'ORD-E8XI0Q6E1B', 'Minh Ngọc Yêu', '75 Nam ngoc, Xã Hải Anh, Huyện Hải Hậu, Tỉnh Nam Định', '36', '366', '14236', '0382677204', 'hainamkid@gmail.com', 'yêu minh ngọc', 'COD', 5000.00, 30000.00, 0.00, 35000.00, 0.00, 0.00, 35000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-23 11:59:59', '2026-01-23 11:59:59'),
(125, NULL, 20, 'ORD-WUT72Z0P4T', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 6000.00, 30000.00, 0.00, 36000.00, 0.00, 0.00, 36000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-24 20:37:46', '2026-01-24 20:37:46'),
(126, NULL, 20, 'ORD-UW5SXNICXR', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 10000.00, 35000.00, 0.00, 14000.00, 1000.00, 0.00, 14000.00, 'unpaid', 'Đã hủy', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-25 00:14:46', '2026-01-25 06:23:48'),
(127, NULL, 20, 'ORD-A1SBM7ZO63', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 252000.00, 35000.00, 0.00, 237000.00, 20000.00, 0.00, 237000.00, 'unpaid', 'Đã hủy', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-25 06:16:59', '2026-01-25 06:23:38'),
(128, NULL, 20, 'ORD-OVTOYMCC6N', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 252000.00, 35000.00, 0.00, 237000.00, 20000.00, 0.00, 237000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(129, NULL, 20, 'ORD-ODXHI5J8RF', 'TRUONG HAI NAM', '56/63 Đường Trần Quốc Vượng', NULL, NULL, NULL, '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 4000.00, 35000.00, 0.00, 38600.00, 400.00, 0.00, 38600.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-25 06:33:47', '2026-01-25 06:33:47'),
(132, NULL, 22, 'ORD-QGPSQFRLQT', 'minh ngoc', 'nam đinh 34, Xã Hải An, Huyện Hải Hậu, Tỉnh Nam Định', '36', '366', '14284', '+84382677204', 'hainamjobb@gmail.com', NULL, 'COD', 501000.00, 35000.00, 0.00, 486000.00, 20000.00, 0.00, 486000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-27 16:13:09', '2026-01-27 16:13:09'),
(133, NULL, 22, 'ORD-VEV6BQXXXE', 'minh ngoc', 'nam đinh 34, Xã Hải An, Huyện Hải Hậu, Tỉnh Nam Định', '36', '366', '14284', '+84382677204', 'hainamjobb@gmail.com', NULL, 'COD', 250000.00, 35000.00, 0.00, 235000.00, 20000.00, 0.00, 235000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-27 16:49:27', '2026-01-27 16:49:27'),
(134, NULL, 22, 'ORD-A49NKYBVHC', 'minh ngoc', 'nam đinh 34, Xã Hải An, Huyện Hải Hậu, Tỉnh Nam Định', '36', '366', '14284', '+84382677204', 'hainamjobb@gmail.com', NULL, 'COD', 750000.00, 35000.00, 0.00, 735000.00, 20000.00, 0.00, 735000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-27 17:08:34', '2026-01-27 17:08:34'),
(135, NULL, 20, 'ORD-78C78FPOVP', 'TRUONG HAI NAM', 'dadadaadad, Phường Giảng Võ, Quận Ba Đình, Thành phố Hà Nội', '01', '001', '00031', '0382677204', 'hainamkid@gmail.com', NULL, 'COD', 252000.00, 35000.00, 0.00, 237000.00, 20000.00, 0.00, 237000.00, 'unpaid', 'Chờ xác nhận', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'TET2026', NULL, NULL, '2026-01-27 18:27:54', '2026-01-27 18:27:54');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `sku_code` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `variant_id` bigint(20) UNSIGNED DEFAULT NULL,
  `variant_options` text DEFAULT NULL COMMENT 'Snapshot thuộc tính (Màu, Size) dạng Text/JSON',
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `sku_code`, `name`, `image_url`, `variant_id`, `variant_options`, `quantity`, `price`, `total_price`, `created_at`, `updated_at`) VALUES
(82, 89, 6, NULL, 'Điện thoại Sony Xperia 1VI 12GB 256GB', 'uploads/avtproduct/Su4QlgPITMY54RwukXmpySn8Jt6tyxtwBCPMipmV.jpg', NULL, NULL, 1, 12000000.00, 12000000.00, '2025-01-08 07:50:32', '2025-01-08 07:50:32'),
(83, 90, 3, NULL, 'Samsung Galaxy S24 Ultra 12GB 256GB', 'uploads/avtproduct/tbjPXH4yCBWPNYqSa0ZxKS1lFIZwVabAGqA5JSOY.jpg', NULL, NULL, 1, 20000000.00, 20000000.00, '2025-01-09 21:08:30', '2025-01-09 21:08:30'),
(84, 91, 12, NULL, 'Xiaomi Redmi Note 13 Pro Plus 5G 8GB 256GB', 'uploads/avtproduct/po23nbEfO9lGTk6jjEskikjBQv0if0tPcFmmaqnc.jpg', NULL, NULL, 1, 9190000.00, 9190000.00, '2025-01-09 21:12:40', '2025-01-09 21:12:40'),
(85, 91, 6, NULL, 'Điện thoại Sony Xperia 1VI 12GB 256GB', 'uploads/avtproduct/Su4QlgPITMY54RwukXmpySn8Jt6tyxtwBCPMipmV.jpg', NULL, NULL, 1, 12000000.00, 12000000.00, '2025-01-09 21:12:40', '2025-01-09 21:12:40'),
(86, 92, 7, NULL, 'realme 13+ 5G (8GB 256GB)', 'uploads/avtproduct/Y0dbW8ES0RA2r1ynnSnGyxjZYXDFNveBdwSSZoJn.jpg', NULL, NULL, 1, 9290000.00, 9290000.00, '2025-01-09 21:17:10', '2025-01-09 21:17:10'),
(87, 92, 3, NULL, 'Samsung Galaxy S24 Ultra 12GB 256GB', 'uploads/avtproduct/tbjPXH4yCBWPNYqSa0ZxKS1lFIZwVabAGqA5JSOY.jpg', NULL, NULL, 1, 20000000.00, 20000000.00, '2025-01-09 21:17:10', '2025-01-09 21:17:10'),
(88, 92, 3, NULL, 'Samsung Galaxy S24 Ultra 12GB 256GB', 'uploads/avtproduct/tbjPXH4yCBWPNYqSa0ZxKS1lFIZwVabAGqA5JSOY.jpg', 2, NULL, 1, 18000000.00, 18000000.00, '2025-01-09 21:17:10', '2025-01-09 21:17:10'),
(89, 92, 5, NULL, 'iPhone 13 128GB | Chính hãng VN/A suawr', 'uploads/avtproduct/7pYHMvc2edP0wyHT3BwbgABIJLAoID8KwFMn47Hv.jpg', NULL, NULL, 1, 17000000.00, 17000000.00, '2025-01-09 21:17:10', '2025-01-09 21:17:10'),
(90, 93, 5, NULL, 'iPhone 13 128GB | Chính hãng VN/A suawr', 'uploads/avtproduct/7pYHMvc2edP0wyHT3BwbgABIJLAoID8KwFMn47Hv.jpg', NULL, NULL, 1, 17000000.00, 17000000.00, '2025-01-09 21:22:54', '2025-01-09 21:22:54'),
(91, 94, 6, NULL, 'Điện thoại Sony Xperia 1VI 12GB 256GB', 'uploads/avtproduct/Su4QlgPITMY54RwukXmpySn8Jt6tyxtwBCPMipmV.jpg', NULL, NULL, 2, 12000000.00, 24000000.00, '2025-01-09 23:42:12', '2025-01-09 23:42:12'),
(92, 94, 3, NULL, 'Samsung Galaxy S24 Ultra 12GB 256GB', 'uploads/avtproduct/tbjPXH4yCBWPNYqSa0ZxKS1lFIZwVabAGqA5JSOY.jpg', NULL, NULL, 1, 20000000.00, 20000000.00, '2025-01-09 23:42:12', '2025-01-09 23:42:12'),
(93, 95, 15, NULL, 'VIvo Y3000', 'uploads/avtproduct/XC0Y5sWvGbrmMiOdcglpniyPs1KyuaVO4aRT8d8V.jpg', NULL, NULL, 1, 24000000.00, 24000000.00, '2025-01-10 06:57:21', '2025-01-10 06:57:21'),
(94, 96, 14, NULL, 'TECNO CAMON 30S 8GB 256GB', 'uploads/avtproduct/5mc4sVbokLqivVfzcN4SLoMpiopqLZA5v3hkDivA.jpg', NULL, NULL, 1, 4790000.00, 4790000.00, '2025-01-10 07:23:04', '2025-01-10 07:23:04'),
(102, 103, 14, NULL, 'TECNO CAMON 30S 8GB 256GB', 'uploads/avtproduct/zBmhkxxaC8X4NhAR5AHVHl4IC7Nutbg8NMJ7q7IP.jpg', NULL, NULL, 5, 4790000.00, 23950000.00, '2025-11-20 18:00:17', '2025-11-20 18:00:17'),
(105, 105, 16, NULL, 'fafdaf', 'uploads/avtproduct/vPRZI5Q0knFcbVYSdo03wQR8TPgwHU6uStKiQqQF.jpg', NULL, NULL, 1, 15000.00, 15000.00, '2025-11-25 03:00:44', '2025-11-25 03:00:44'),
(116, 113, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, NULL, 10, 2000.00, 20000.00, '2026-01-20 08:06:16', '2026-01-20 08:06:16'),
(117, 114, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, NULL, 10, 2000.00, 20000.00, '2026-01-20 08:25:22', '2026-01-20 08:25:22'),
(118, 115, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, NULL, 10, 2000.00, 20000.00, '2026-01-20 08:45:58', '2026-01-20 08:45:58'),
(119, 115, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 2, NULL, 8, 2200.00, 17600.00, '2026-01-20 08:45:58', '2026-01-20 08:45:58'),
(120, 116, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 2, NULL, 1, 2200.00, 2200.00, '2026-01-20 08:59:20', '2026-01-20 08:59:20'),
(121, 117, 19, NULL, 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 3, NULL, 2, 2100.00, 4200.00, '2026-01-20 09:13:41', '2026-01-20 09:13:41'),
(122, 118, 20, 'IPHONE21PR-699-64G', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 5, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"64 GB\"}', 4, 2000.00, 8000.00, '2026-01-22 21:24:42', '2026-01-22 21:24:42'),
(123, 119, 20, 'IPHONE21PR-699-64G', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 5, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"64 GB\"}', 3, 2000.00, 6000.00, '2026-01-22 21:27:06', '2026-01-22 21:27:06'),
(124, 120, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 2500.00, 5000.00, '2026-01-23 11:30:12', '2026-01-23 11:30:12'),
(125, 121, 19, 'IPHONE20PR-938-XAN-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 3, '{\"M\\u00e0u S\\u1eafc\":\"Xanh\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 2100.00, 4200.00, '2026-01-23 11:31:54', '2026-01-23 11:31:54'),
(126, 122, 19, 'IPHONE20PR-938-XAN-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 3, '{\"M\\u00e0u S\\u1eafc\":\"Xanh\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 2100.00, 4200.00, '2026-01-23 11:58:24', '2026-01-23 11:58:24'),
(127, 123, 19, 'IPHONE20PR-938-XAN-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 3, '{\"M\\u00e0u S\\u1eafc\":\"Xanh\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 1, 2100.00, 2100.00, '2026-01-23 11:59:05', '2026-01-23 11:59:05'),
(128, 124, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 2500.00, 5000.00, '2026-01-23 11:59:59', '2026-01-23 11:59:59'),
(129, 125, 20, 'IPHONE21PR-699-64G', 'iPhone 21 pro Max', 'http://lifephone-nam-blade-attribute.test/storage/uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 5, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"64 GB\"}', 3, 2000.00, 6000.00, '2026-01-24 20:37:46', '2026-01-24 20:37:46'),
(130, 126, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'http://lifephone-nam-blade-attribute.test/storage/uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, NULL, 5, 2000.00, 10000.00, '2026-01-25 00:14:46', '2026-01-25 00:14:46'),
(131, 127, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'http://lifephone-nam-blade-attribute.test/storage/uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, NULL, 1, 2000.00, 2000.00, '2026-01-25 06:16:59', '2026-01-25 06:16:59'),
(132, 127, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'http://lifephone-nam-blade-attribute.test/storage/uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, NULL, 1, 250000.00, 250000.00, '2026-01-25 06:16:59', '2026-01-25 06:16:59'),
(133, 128, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '\"{\\\"M\\u00e0u S\\u1eafc\\\":\\\"\\u0110\\u1ecf\\\",\\\"Dung L\\u01b0\\u1ee3ng\\\":\\\"128 GB\\\"}\"', 1, 250000.00, 250000.00, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(134, 128, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, '\"{\\\"M\\u00e0u S\\u1eafc\\\":\\\"\\u0110\\u1ecf\\\",\\\"Dung L\\u01b0\\u1ee3ng\\\":\\\"128 GB\\\"}\"', 1, 2000.00, 2000.00, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(135, 129, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 2000.00, 4000.00, '2026-01-25 06:33:47', '2026-01-25 06:33:47'),
(136, 132, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 250000.00, 500000.00, '2026-01-27 16:13:09', '2026-01-27 16:13:09'),
(137, 132, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 1, 1000.00, 1000.00, '2026-01-27 16:13:09', '2026-01-27 16:13:09'),
(138, 133, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 1, 250000.00, 250000.00, '2026-01-27 16:49:27', '2026-01-27 16:49:27'),
(139, 134, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 3, 250000.00, 750000.00, '2026-01-27 17:08:34', '2026-01-27 17:08:34'),
(140, 135, 20, 'IPHONE21PR-699-128', 'iPhone 21 pro Max', 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', 6, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 1, 250000.00, 250000.00, '2026-01-27 18:27:54', '2026-01-27 18:27:54'),
(141, 135, 19, 'IPHONE20PR-938-128', 'iPhone 20 pro Max', 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', 1, '{\"M\\u00e0u S\\u1eafc\":\"\\u0110\\u1ecf\",\"Dung L\\u01b0\\u1ee3ng\":\"128 GB\"}', 2, 1000.00, 2000.00, '2026-01-27 18:27:54', '2026-01-27 18:27:54');

-- --------------------------------------------------------

--
-- Table structure for table `order_notifications`
--

CREATE TABLE `order_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_notifications`
--

INSERT INTO `order_notifications` (`id`, `order_id`, `is_read`, `created_at`, `updated_at`) VALUES
(29, 89, 0, '2025-01-08 07:50:32', '2025-01-08 07:50:32'),
(30, 90, 0, '2025-01-09 21:08:30', '2025-01-09 21:08:30'),
(31, 91, 0, '2025-01-09 21:12:40', '2025-01-09 21:12:40'),
(32, 92, 0, '2025-01-09 21:20:27', '2025-01-09 21:20:27'),
(33, 93, 0, '2025-01-09 21:22:54', '2025-01-09 21:22:54'),
(34, 95, 0, '2025-01-10 06:57:21', '2025-01-10 06:57:21'),
(35, 96, 0, '2025-01-10 07:23:04', '2025-01-10 07:23:04'),
(39, 103, 0, '2025-11-20 18:00:17', '2025-11-20 18:00:17'),
(40, 105, 0, '2025-11-25 03:00:44', '2025-11-25 03:00:44'),
(46, 115, 0, '2026-01-20 08:45:58', '2026-01-20 08:45:58'),
(47, 116, 0, '2026-01-20 08:59:20', '2026-01-20 08:59:20'),
(48, 117, 0, '2026-01-20 09:13:41', '2026-01-20 09:13:41'),
(49, 117, 0, '2026-01-22 06:56:26', '2026-01-22 06:56:26'),
(50, 117, 0, '2026-01-22 07:09:08', '2026-01-22 07:09:08'),
(51, 117, 0, '2026-01-22 07:09:22', '2026-01-22 07:09:22'),
(52, 117, 0, '2026-01-22 07:09:33', '2026-01-22 07:09:33'),
(53, 116, 0, '2026-01-22 07:12:27', '2026-01-22 07:12:27'),
(54, 116, 0, '2026-01-22 07:16:50', '2026-01-22 07:16:50'),
(55, 116, 0, '2026-01-22 07:21:53', '2026-01-22 07:21:53'),
(56, 116, 0, '2026-01-22 07:23:02', '2026-01-22 07:23:02'),
(57, 118, 0, '2026-01-22 21:24:42', '2026-01-22 21:24:42'),
(58, 119, 0, '2026-01-22 21:27:06', '2026-01-22 21:27:06'),
(59, 119, 0, '2026-01-22 21:27:51', '2026-01-22 21:27:51'),
(60, 119, 0, '2026-01-22 21:27:59', '2026-01-22 21:27:59'),
(61, 119, 0, '2026-01-22 21:28:04', '2026-01-22 21:28:04'),
(62, 119, 0, '2026-01-22 21:28:10', '2026-01-22 21:28:10'),
(63, 120, 0, '2026-01-23 11:30:12', '2026-01-23 11:30:12'),
(64, 121, 0, '2026-01-23 11:31:54', '2026-01-23 11:31:54'),
(65, 122, 0, '2026-01-23 11:58:24', '2026-01-23 11:58:24'),
(66, 123, 0, '2026-01-23 11:59:05', '2026-01-23 11:59:05'),
(67, 124, 0, '2026-01-23 11:59:59', '2026-01-23 11:59:59'),
(68, 125, 0, '2026-01-24 20:37:46', '2026-01-24 20:37:46'),
(69, 126, 0, '2026-01-25 00:14:46', '2026-01-25 00:14:46'),
(70, 127, 0, '2026-01-25 06:16:59', '2026-01-25 06:16:59'),
(71, 128, 0, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(72, 129, 0, '2026-01-25 06:33:47', '2026-01-25 06:33:47'),
(73, 132, 0, '2026-01-27 16:13:09', '2026-01-27 16:13:09'),
(74, 133, 0, '2026-01-27 16:49:27', '2026-01-27 16:49:27'),
(75, 134, 0, '2026-01-27 17:08:34', '2026-01-27 17:08:34'),
(76, 135, 0, '2026-01-27 18:27:54', '2026-01-27 18:27:54');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_code` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `weight` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Cân nặng (gram)',
  `length` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Chiều dài (cm)',
  `width` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Chiều rộng (cm)',
  `height` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Chiều cao (cm)',
  `min_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_code`, `name`, `slug`, `weight`, `length`, `width`, `height`, `min_price`, `is_active`, `is_featured`, `description`, `category_id`, `brand_id`, `image_url`, `created_at`, `updated_at`, `deleted_at`, `views`) VALUES
(1, 'sdxs', 'Quang Minh', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>acsac</p>', 1, NULL, 'uploads/avtproduct/Bw4CzSDODGElIogQZe3fXOSHpbqd6UapbKJ1cqCJ.jpg', '2024-10-08 06:44:03', '2024-11-02 00:26:38', '2024-11-02 00:26:38', 23),
(2, 'sdxsss', 'Samsung Galaxy S24 Ultra 12GB 256GB', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>Mới, đầy đủ phụ kiện từ nh&agrave; sản xuất</p>\r\n\r\n<p>Điện thoại th&ocirc;ng minh<br />\r\n2. C&aacute;p truyền dữ liệu<br />\r\n3. Que lấy sim<br />\r\n* Galaxy S24 Ultra kh&ocirc;ng bao gồm củ sạc.</p>\r\n\r\n<p>Bảo h&agrave;nh 12 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh Ch&iacute;nh h&atilde;ng. 1 đổi 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng từ nh&agrave; sản xuất.&nbsp;<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>\r\n\r\n<p>Gi&aacute; sản phẩm đ&atilde; bao gồm VAT</p>', 2, NULL, 'uploads/avtproduct/EkPwK3tgagKdYn7CHHT78oG831RaSWRFRXm81KQA.jpg', '2024-10-23 09:52:24', '2025-11-18 18:45:55', NULL, 72),
(3, 'vsvdfd', 'Samsung Galaxy S24 Ultra 12GB 256GB', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>Mới, đầy đủ phụ kiện từ nh&agrave; sản xuất</p>\r\n\r\n<p>Điện thoại th&ocirc;ng minh<br />\r\n2. C&aacute;p truyền dữ liệu<br />\r\n3. Que lấy sim<br />\r\n* Galaxy S24 Ultra kh&ocirc;ng bao gồm củ sạc.</p>\r\n\r\n<p>Bảo h&agrave;nh 12 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh Ch&iacute;nh h&atilde;ng. 1 đổi 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng từ nh&agrave; sản xuất.&nbsp;<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>\r\n\r\n<p>Gi&aacute; sản phẩm đ&atilde; bao gồm VAT</p>', 2, NULL, 'uploads/avtproduct/bNK2lf9NZm8oCY3fkBuNrR86DkmwJq1eVrCXXGi6.jpg', '2024-10-28 01:29:03', '2025-11-11 04:52:07', NULL, 57),
(4, 'trsdfsfvsg', 'iPhone 15 128GB | Chính hãng VN/A', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>M&aacute;y mới 100% , ch&iacute;nh h&atilde;ng Apple Việt Nam.<br />\r\nCellphoneS hiện l&agrave; đại l&yacute; b&aacute;n lẻ uỷ quyền iPhone ch&iacute;nh h&atilde;ng VN/A của Apple Việt Nam</p>\r\n\r\n<p>Hộp, S&aacute;ch hướng dẫn, C&acirc;y lấy sim, C&aacute;p Type C</p>\r\n\r\n<p>1 ĐỔI 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng nh&agrave; sản xuất. Bảo h&agrave;nh 12 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh ch&iacute;nh h&atilde;ng Apple: CareS.vn<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>\r\n\r\n<p>Gi&aacute; sản phẩm đ&atilde; bao gồm VAT</p>', 1, NULL, 'uploads/avtproduct/OVsCsB5UbgIqOqStHglFLxmTSgpKMD79qhPJX0nU.jpg', '2024-10-28 01:30:10', '2025-12-23 03:09:13', NULL, 147),
(5, '00Dawqw', 'iPhone 13 128GB | Chính hãng VN/A suawr', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>&nbsp;</p>\r\n\r\n<p>Th&ocirc;ng tin sản phẩm</p>\r\n\r\n<p>M&aacute;y mới 100% , ch&iacute;nh h&atilde;ng Apple Việt Nam.<br />\r\nCellphoneS hiện l&agrave; đại l&yacute; b&aacute;n lẻ uỷ quyền iPhone ch&iacute;nh h&atilde;ng VN/A của Apple Việt Nam</p>\r\n\r\n<p>Hộp, S&aacute;ch hướng dẫn, C&acirc;y lấy sim, C&aacute;p Lightning - Type C</p>\r\n\r\n<p>1 ĐỔI 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng nh&agrave; sản xuất. Bảo h&agrave;nh 12 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh ch&iacute;nh h&atilde;ng Apple: CareS.vn<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>', 1, NULL, 'uploads/avtproduct/tD0IMfVK4GfpW4PIRdAj43o8YRParSAxeu2LxvCk.jpg', '2024-11-20 06:40:40', '2026-01-31 08:48:54', '2026-01-31 08:48:54', 103),
(6, 'dvdvdv', 'Điện thoại Sony Xperia 1VI 12GB 256GB', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của Điện thoại Sony Xperia 1VI 12GB 256GB</h2>\r\n\r\n<ul>\r\n	<li>M&agrave;n h&igrave;nh OLED, k&iacute;ch thước m&agrave;n h&igrave;nh 6.5 inches cho trải nghiệm xem phim v&agrave; chơi game đắm ch&igrave;m hơn.</li>\r\n	<li>Bộ xử l&yacute; Snapdragon 8 Gen 3 Mobile Platform cho hiệu năng mạnh mẽ, xử l&yacute; mượt m&agrave; mọi t&aacute;c vụ, kể cả những game nặng nhất.</li>\r\n	<li>Pin dung lượng lớn 5000mAh cho thời gian sử dụng l&acirc;u d&agrave;i, đ&aacute;p ứng nhu cầu sử dụng cả ng&agrave;y d&agrave;i của bạn.</li>\r\n	<li>Chịu nước IPX5/X8, chống bụi IP6X cho bạn y&ecirc;n t&acirc;m sử dụng trong mọi điều kiện thời tiết.</li>\r\n</ul>\r\n\r\n<blockquote>\r\n<p><a href=\"https://cellphones.com.vn/dien-thoai-sony-xperia-1-vi.html\" target=\"_blank\" title=\"Sony Xperia 1 VI\"><strong>Sony Xperia 1 VI</strong></a>&nbsp;12GB 256GB l&agrave; flagship mới của nh&agrave; Sony với chipset&nbsp;<strong>Snapdragon 8 Gen 3 tiến tr&igrave;nh 4nm</strong>, bộ nhớ&nbsp;<strong>RAM 12GB</strong>&nbsp;v&agrave; dung lượng lưu trữ 256GB. M&agrave;n h&igrave;nh 6.5 inch chất lượng&nbsp;<strong>FHD+</strong>, tần số qu&eacute;t&nbsp;<strong>120Hz</strong>&nbsp;c&ugrave;ng&nbsp;<strong>tấm nền OLED</strong>&nbsp;chất lượng. Camera ch&iacute;nh&nbsp;<strong>48MP</strong>&nbsp;với cảm biến Exmor T c&ugrave;ng camera selfie 12mP. Pin lớn tới&nbsp;<strong>5000mAh</strong>&nbsp;v&agrave; 30W c&ocirc;ng nghệ sạc nhanh Qi cho trải nghiệm th&uacute; vị.</p>\r\n</blockquote>\r\n\r\n<h2><strong>V&igrave; sao n&ecirc;n mua điện thoại&nbsp;Sony Xperia 1 VI?</strong></h2>\r\n\r\n<p><strong>Điện thoại&nbsp;Sony Xperia 1 VI</strong>&nbsp;l&agrave; sản phẩm thuộc thương hiệu SONY, thương hiệu nổi tiếng với c&aacute;c thiết bị quay chụp. Vậy điện thoại mới n&agrave;y c&oacute; g&igrave; nổi bật đ&aacute;ng để mua trải nghiệm? Dưới đ&acirc;y l&agrave;&nbsp;<strong>top 4 l&yacute; do n&ecirc;n mua Sony Xperia 1 VI</strong>:</p>\r\n\r\n<p>- Ống k&iacute;nh macro 85 - 170mm v&agrave; ống k&iacute;nh tele quang học: Chụp ảnh chất lượng</p>', 3, NULL, 'uploads/avtproduct/KlKshXHhmLwMH6tesbwPgRrqjANrhQMK1UxZFT99.jpg', '2024-11-20 07:28:27', '2025-12-13 20:17:11', NULL, 104),
(7, 'me001', 'realme 13+ 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của realme 13+ 5G (8GB 256GB)</h2>\r\n\r\n<ul>\r\n	<li>Realme 13+ 5G sử dụng bộ vi xử l&yacute; hiện đại, mang đến trải nghiệm mượt m&agrave; cho c&aacute;c t&aacute;c vụ đa nhiệm v&agrave; chơi game.</li>\r\n	<li>M&agrave;n h&igrave;nh Full HD+ với tần số qu&eacute;t cao 120Hz cho h&igrave;nh ảnh mượt m&agrave; v&agrave; sắc n&eacute;t khi lướt web, xem video hoặc chơi game.</li>\r\n	<li>Hỗ trợ kết nối 5G gi&uacute;p truy cập Internet nhanh ch&oacute;ng v&agrave; ổn định, ph&ugrave; hợp cho nhu cầu c&ocirc;ng việc v&agrave; giải tr&iacute; trực tuyến.</li>\r\n	<li>Pin dung lượng lớn với c&ocirc;ng nghệ sạc nhanh, gi&uacute;p người d&ugrave;ng c&oacute; thể sử dụng l&acirc;u d&agrave;i m&agrave; kh&ocirc;ng lo lắng về việc sạc lại thường xuy&ecirc;n.</li>\r\n</ul>\r\n\r\n<p><strong>realme 13+ 5G</strong>&nbsp;ch&iacute;nh h&atilde;ng l&agrave; sản phẩm ra mắt tiếp theo được người d&ugrave;ng săn đ&oacute;n rất nhiều hiện nay với đầy đủ c&aacute;c điểm mạnh vượt trội hơn so với đối thủ như chips xử l&yacute; vượt bậc, sạc nhanh l&ecirc;n đến 80W v&agrave; c&oacute; khả năng kh&aacute;ng nước tốt hơn so với thế hệ tiền nhiệm. C&ugrave;ng kh&aacute;m ph&aacute; chi tiết nhất về điện thoại trước thềm ra mắt để xem c&oacute; n&ecirc;n mua điện thoại n&agrave;y ngay kh&ocirc;ng nh&eacute;!</p>', 6, NULL, 'uploads/avtproduct/cpUX0cZmrxJRVLMQ5lxqM0S38YrAwvL5lY5zJUlH.jpg', '2024-12-04 07:24:21', '2026-01-31 08:57:23', '2026-01-31 08:57:23', 27),
(8, 'me001', 'realme 13+ 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của realme 13+ 5G (8GB 256GB)</h2>\r\n\r\n<ul>\r\n	<li>Realme 13+ 5G sử dụng bộ vi xử l&yacute; hiện đại, mang đến trải nghiệm mượt m&agrave; cho c&aacute;c t&aacute;c vụ đa nhiệm v&agrave; chơi game.</li>\r\n	<li>M&agrave;n h&igrave;nh Full HD+ với tần số qu&eacute;t cao 120Hz cho h&igrave;nh ảnh mượt m&agrave; v&agrave; sắc n&eacute;t khi lướt web, xem video hoặc chơi game.</li>\r\n	<li>Hỗ trợ kết nối 5G gi&uacute;p truy cập Internet nhanh ch&oacute;ng v&agrave; ổn định, ph&ugrave; hợp cho nhu cầu c&ocirc;ng việc v&agrave; giải tr&iacute; trực tuyến.</li>\r\n	<li>Pin dung lượng lớn với c&ocirc;ng nghệ sạc nhanh, gi&uacute;p người d&ugrave;ng c&oacute; thể sử dụng l&acirc;u d&agrave;i m&agrave; kh&ocirc;ng lo lắng về việc sạc lại thường xuy&ecirc;n.</li>\r\n</ul>\r\n\r\n<p><strong>realme 13+ 5G</strong>&nbsp;ch&iacute;nh h&atilde;ng l&agrave; sản phẩm ra mắt tiếp theo được người d&ugrave;ng săn đ&oacute;n rất nhiều hiện nay với đầy đủ c&aacute;c điểm mạnh vượt trội hơn so với đối thủ như chips xử l&yacute; vượt bậc, sạc nhanh l&ecirc;n đến 80W v&agrave; c&oacute; khả năng kh&aacute;ng nước tốt hơn so với thế hệ tiền nhiệm. C&ugrave;ng kh&aacute;m ph&aacute; chi tiết nhất về điện thoại trước thềm ra mắt để xem c&oacute; n&ecirc;n mua điện thoại n&agrave;y ngay kh&ocirc;ng nh&eacute;!</p>', 6, NULL, 'uploads/avtproduct/viYOOtQvsC4bTyekSsYSkQXzbh39FISdvOt0jSnS.jpg', '2024-12-04 07:25:47', '2024-12-04 07:32:17', '2024-12-04 07:32:17', 0),
(9, 'me001', 'realme 13+ 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của realme 13+ 5G (8GB 256GB)</h2>\r\n\r\n<ul>\r\n	<li>Realme 13+ 5G sử dụng bộ vi xử l&yacute; hiện đại, mang đến trải nghiệm mượt m&agrave; cho c&aacute;c t&aacute;c vụ đa nhiệm v&agrave; chơi game.</li>\r\n	<li>M&agrave;n h&igrave;nh Full HD+ với tần số qu&eacute;t cao 120Hz cho h&igrave;nh ảnh mượt m&agrave; v&agrave; sắc n&eacute;t khi lướt web, xem video hoặc chơi game.</li>\r\n	<li>Hỗ trợ kết nối 5G gi&uacute;p truy cập Internet nhanh ch&oacute;ng v&agrave; ổn định, ph&ugrave; hợp cho nhu cầu c&ocirc;ng việc v&agrave; giải tr&iacute; trực tuyến.</li>\r\n	<li>Pin dung lượng lớn với c&ocirc;ng nghệ sạc nhanh, gi&uacute;p người d&ugrave;ng c&oacute; thể sử dụng l&acirc;u d&agrave;i m&agrave; kh&ocirc;ng lo lắng về việc sạc lại thường xuy&ecirc;n.</li>\r\n</ul>\r\n\r\n<p><strong>realme 13+ 5G</strong>&nbsp;ch&iacute;nh h&atilde;ng l&agrave; sản phẩm ra mắt tiếp theo được người d&ugrave;ng săn đ&oacute;n rất nhiều hiện nay với đầy đủ c&aacute;c điểm mạnh vượt trội hơn so với đối thủ như chips xử l&yacute; vượt bậc, sạc nhanh l&ecirc;n đến 80W v&agrave; c&oacute; khả năng kh&aacute;ng nước tốt hơn so với thế hệ tiền nhiệm. C&ugrave;ng kh&aacute;m ph&aacute; chi tiết nhất về điện thoại trước thềm ra mắt để xem c&oacute; n&ecirc;n mua điện thoại n&agrave;y ngay kh&ocirc;ng nh&eacute;!</p>', 6, NULL, 'uploads/avtproduct/U6oJfuvoDctlIXznDZglq7DLtUNRMIBXypcOklp7.jpg', '2024-12-04 07:27:27', '2024-12-04 07:32:13', '2024-12-04 07:32:13', 0),
(10, 'me001', 'realme 13+ 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của realme 13+ 5G (8GB 256GB)</h2>\r\n\r\n<ul>\r\n	<li>Realme 13+ 5G sử dụng bộ vi xử l&yacute; hiện đại, mang đến trải nghiệm mượt m&agrave; cho c&aacute;c t&aacute;c vụ đa nhiệm v&agrave; chơi game.</li>\r\n	<li>M&agrave;n h&igrave;nh Full HD+ với tần số qu&eacute;t cao 120Hz cho h&igrave;nh ảnh mượt m&agrave; v&agrave; sắc n&eacute;t khi lướt web, xem video hoặc chơi game.</li>\r\n	<li>Hỗ trợ kết nối 5G gi&uacute;p truy cập Internet nhanh ch&oacute;ng v&agrave; ổn định, ph&ugrave; hợp cho nhu cầu c&ocirc;ng việc v&agrave; giải tr&iacute; trực tuyến.</li>\r\n	<li>Pin dung lượng lớn với c&ocirc;ng nghệ sạc nhanh, gi&uacute;p người d&ugrave;ng c&oacute; thể sử dụng l&acirc;u d&agrave;i m&agrave; kh&ocirc;ng lo lắng về việc sạc lại thường xuy&ecirc;n.</li>\r\n</ul>\r\n\r\n<p><strong>realme 13+ 5G</strong>&nbsp;ch&iacute;nh h&atilde;ng l&agrave; sản phẩm ra mắt tiếp theo được người d&ugrave;ng săn đ&oacute;n rất nhiều hiện nay với đầy đủ c&aacute;c điểm mạnh vượt trội hơn so với đối thủ như chips xử l&yacute; vượt bậc, sạc nhanh l&ecirc;n đến 80W v&agrave; c&oacute; khả năng kh&aacute;ng nước tốt hơn so với thế hệ tiền nhiệm. C&ugrave;ng kh&aacute;m ph&aacute; chi tiết nhất về điện thoại trước thềm ra mắt để xem c&oacute; n&ecirc;n mua điện thoại n&agrave;y ngay kh&ocirc;ng nh&eacute;!</p>', 6, NULL, 'uploads/avtproduct/GYXbqeBHg8Y03bnZ2P9I5LvYMnIBDqpAlx94mqtw.jpg', '2024-12-04 07:28:57', '2024-12-04 07:31:47', '2024-12-04 07:31:47', 0),
(11, 'me001', 'realme 13+ 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của realme 13+ 5G (8GB 256GB)</h2>\r\n\r\n<ul>\r\n	<li>Realme 13+ 5G sử dụng bộ vi xử l&yacute; hiện đại, mang đến trải nghiệm mượt m&agrave; cho c&aacute;c t&aacute;c vụ đa nhiệm v&agrave; chơi game.</li>\r\n	<li>M&agrave;n h&igrave;nh Full HD+ với tần số qu&eacute;t cao 120Hz cho h&igrave;nh ảnh mượt m&agrave; v&agrave; sắc n&eacute;t khi lướt web, xem video hoặc chơi game.</li>\r\n	<li>Hỗ trợ kết nối 5G gi&uacute;p truy cập Internet nhanh ch&oacute;ng v&agrave; ổn định, ph&ugrave; hợp cho nhu cầu c&ocirc;ng việc v&agrave; giải tr&iacute; trực tuyến.</li>\r\n	<li>Pin dung lượng lớn với c&ocirc;ng nghệ sạc nhanh, gi&uacute;p người d&ugrave;ng c&oacute; thể sử dụng l&acirc;u d&agrave;i m&agrave; kh&ocirc;ng lo lắng về việc sạc lại thường xuy&ecirc;n.</li>\r\n</ul>\r\n\r\n<p><strong>realme 13+ 5G</strong>&nbsp;ch&iacute;nh h&atilde;ng l&agrave; sản phẩm ra mắt tiếp theo được người d&ugrave;ng săn đ&oacute;n rất nhiều hiện nay với đầy đủ c&aacute;c điểm mạnh vượt trội hơn so với đối thủ như chips xử l&yacute; vượt bậc, sạc nhanh l&ecirc;n đến 80W v&agrave; c&oacute; khả năng kh&aacute;ng nước tốt hơn so với thế hệ tiền nhiệm. C&ugrave;ng kh&aacute;m ph&aacute; chi tiết nhất về điện thoại trước thềm ra mắt để xem c&oacute; n&ecirc;n mua điện thoại n&agrave;y ngay kh&ocirc;ng nh&eacute;!</p>', 6, NULL, 'uploads/avtproduct/LdvOoA4ZCpBfbWjZtWtBEfgd2W6KqKJF70Tuj67J.jpg', '2024-12-04 07:29:52', '2024-12-04 07:30:07', '2024-12-04 07:30:07', 0),
(12, 'me002', 'Xiaomi Redmi Note 13 Pro Plus 5G 8GB 256GB', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>Mới, đầy đủ phụ kiện từ nh&agrave; sản xuất</p>\r\n\r\n<p>M&aacute;y, sạc, C&aacute;p USB Type-C, Dụng cụ lấy SIM, Vỏ bảo vệ, Hướng dẫn sử dụng nhanh</p>\r\n\r\n<p>Bảo h&agrave;nh 18 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh Ch&iacute;nh h&atilde;ng. 1 đổi 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng từ nh&agrave; sản xuất.&nbsp;<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>\r\n\r\n<p>Gi&aacute; sản phẩm đ&atilde; bao gồm VAT</p>', 8, NULL, 'uploads/avtproduct/5zJntCYpHYJtjgNV3e4fOP94gIcin4Z9ymUVvF1k.jpg', '2024-12-04 07:36:39', '2025-12-13 20:17:14', NULL, 21),
(13, 'oppo001', 'OPPO Reno12 F 5G (8GB 256GB)', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>Mới, đầy đủ phụ kiện từ nh&agrave; sản xuất</p>\r\n\r\n<p>Bảo h&agrave;nh 12 th&aacute;ng tại trung t&acirc;m bảo h&agrave;nh Ch&iacute;nh h&atilde;ng. 1 đổi 1 trong 30 ng&agrave;y nếu c&oacute; lỗi phần cứng từ nh&agrave; sản xuất.&nbsp;<a href=\"https://cellphones.com.vn/chinh-sach-bao-hanh\" target=\"_blank\">(xem chi tiết)</a></p>\r\n\r\n<p>Gi&aacute; sản phẩm đ&atilde; bao gồm VAT</p>', 4, NULL, 'uploads/avtproduct/jWMuFrz2CWuXIvjqshNEVBbHdtXnUPz1K137riwk.jpg', '2024-12-04 07:39:05', '2024-12-17 22:25:30', '2024-12-17 22:25:30', 13),
(14, 'trch001', 'TECNO CAMON 30S 8GB 256GB', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h2>Đặc điểm nổi bật của TECNO CAMON 30S 8GB 256GB</h2>\r\n\r\n<ul>\r\n	<li>M&agrave;n h&igrave;nh AMOLED&nbsp;6.78&nbsp;inches - Hiển thị h&igrave;nh ảnh rực rỡ, sắc n&eacute;t, mang lại trải nghiệm giải tr&iacute; v&agrave; xem phim tuyệt vời.</li>\r\n	<li>Chipset&nbsp;Mediatek G100-&nbsp;Hiệu suất ổn định, đ&aacute;p ứng tốt nhu cầu chơi game v&agrave; c&aacute;c t&aacute;c vụ nặng.</li>\r\n	<li>RAM 8GB + Bộ nhớ trong 256GB: Cung cấp hiệu năng mạnh mẽ, cho ph&eacute;p người d&ugrave;ng lưu trữ nhiều ứng dụng v&agrave; dữ liệu m&agrave; kh&ocirc;ng lo đầy bộ nhớ.</li>\r\n	<li>Chất lượng h&igrave;nh ảnh sắc n&eacute;t, hỗ trợ nhiều t&iacute;nh năng chụp ảnh chuy&ecirc;n nghiệp, ph&ugrave; hợp cho nhu cầu chụp ảnh cao cấp.</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Điện thoại Tecno Camon 30S sở hữu cấu h&igrave;nh ấn tượng với vi xử l&yacute; MediaTek Helio G100 6nm, tối ưu h&oacute;a hiệu suất hoạt động v&agrave; khả năng tiết kiệm pin. M&aacute;y được trang bị CPU 8 l&otilde;i (2 l&otilde;i Cortex-A76 v&agrave; 6 l&otilde;i Cortex-A55), hoạt động ở tốc độ 2.2GHz, mang lại khả năng xử l&yacute; mạnh mẽ c&aacute;c t&aacute;c vụ từ cơ bản đến n&acirc;ng cao. Với RAM 8GB v&agrave; bộ nhớ trong 256GB, người d&ugrave;ng c&oacute; kh&ocirc;ng gian lưu trữ rộng r&atilde;i v&agrave; khả năng đa nhiệm hiệu quả m&agrave; kh&ocirc;ng lo giật lag.&nbsp;</p>', 11, NULL, 'uploads/avtproduct/zBmhkxxaC8X4NhAR5AHVHl4IC7Nutbg8NMJ7q7IP.jpg', '2024-12-04 07:43:55', '2025-11-20 17:59:25', NULL, 46),
(15, 'vivo-y300', 'VIvo Y3000', NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<p>vivo Y300 5G c&oacute; c&aacute;c t&ugrave;y chọn m&agrave;u Xanh l&aacute; c&acirc;y, Trắng v&agrave; Đen. N&oacute; c&oacute; gi&aacute; khởi điểm từ 1,399 Yuan (khoảng 4.88 triệu đồng) cho biến thể 8GB/128GB. C&aacute;c biến thể 8GB/256GB, 12GB/256GB v&agrave; 12GB/512GB c&oacute; gi&aacute; lần lượt l&agrave; 1,599 Yuan (khoảng 5.57 triệu đồng), 1,799 Yuan (khoảng 6.27 triệu đồng), 1,999 Yuan (khoảng 6.96 triệu đồng).</p>', 5, NULL, 'uploads/avtproduct/k0uERt17IYYdirOpkv91feWSSHHbZmZUKBw4jHJR.jpg', '2024-12-17 10:04:49', '2025-11-20 18:00:51', NULL, 35),
(16, 'IPHONE14PROMAX', 'Iphone 14 Pro Max', 'iphone-14-pro-max', 0.00, 0.00, 0.00, 0.00, 1200.00, 1, 0, '<h2><strong>V&igrave; sao n&ecirc;n mua iPhone 14 Pro Max 256GB Cũ 99,9%?</strong></h2>\r\n\r\n<p>Mua&nbsp;<strong>&nbsp;iPhone 14 Pro Max 256GB cũ 99,9%</strong>&nbsp;l&agrave; c&aacute;ch th&ocirc;ng minh để sở hữu một flagship cao cấp với mức gi&aacute; tiết kiệm hơn. So với m&aacute;y mới, phi&ecirc;n bản cũ vẫn đảm bảo trải nghiệm mạnh mẽ từ thiết kế, m&agrave;n h&igrave;nh đến hiệu năng. Dưới đ&acirc;y l&agrave; những l&yacute; do bạn n&ecirc;n chọn mua:</p>\r\n\r\n<ul>\r\n	<li><strong>Tiết kiệm chi ph&iacute; đ&aacute;ng kể</strong>: Gi&aacute; iPhone 14 Pro Max 256GB cũ rẻ hơn nhiều so với m&aacute;y mới, gi&uacute;p bạn sở hữu một chiếc flagship cao cấp m&agrave; kh&ocirc;ng cần chi qu&aacute; nhiều.</li>\r\n	<li><strong>Chất lượng đảm bảo</strong>:&nbsp;<a href=\"https://bachlongmobile.com/product-old/\" rel=\"noopener\" target=\"_blank\"><strong>M&aacute;y cũ</strong></a>&nbsp;thường sẽ được kiểm tra kỹ lưỡng, đảm bảo ngoại h&igrave;nh đẹp, linh kiện nguy&ecirc;n zin v&agrave; hiệu suất ổn định, mang lại trải nghiệm sử dụng mượt m&agrave;.</li>\r\n	<li><strong>Ch&iacute;nh s&aacute;ch bảo h&agrave;nh đầy đủ</strong>: Khi mua tại cửa h&agrave;ng uy t&iacute;n, bạn sẽ nhận được bảo h&agrave;nh r&otilde; r&agrave;ng, hỗ trợ đổi trả nếu c&oacute; lỗi từ nh&agrave; sản xuất.</li>\r\n	<li><strong>Trải nghiệm flagship với gi&aacute; hợp l&yacute;</strong>: D&ugrave; l&agrave; m&aacute;y cũ, iPhone 14 Pro Max 256GB vẫn giữ nguy&ecirc;n những ưu điểm vượt trội như m&agrave;n h&igrave;nh OLED sắc n&eacute;t, hiệu năng mạnh mẽ v&agrave; hệ thống camera cao cấp.</li>\r\n</ul>\r\n\r\n<p><img alt=\"Vì sao nên mua iPhone 14 Pro Max 256GB Cũ 99,9%?\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/6_113.jpg\" style=\"height:500px; width:952px\" /></p>\r\n\r\n<p>Nếu bạn muốn sở hữu một chiếc iPhone cao cấp với mức gi&aacute; hợp l&yacute;, iPhone 14 Pro Max 256GB cũ chắc chắn l&agrave; lựa chọn đ&aacute;ng c&acirc;n nhắc!</p>\r\n\r\n<h2><strong>Điểm nổi bật của iPhone 14 Pro Max 256GB Cũ 99,9%</strong></h2>\r\n\r\n<p><strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;vẫn giữ nguy&ecirc;n những ưu điểm của một flagship cao cấp, từ thiết kế sang trọng, m&agrave;n h&igrave;nh sắc n&eacute;t đến hiệu năng mạnh mẽ. Dưới đ&acirc;y l&agrave; những điểm nổi bật gi&uacute;p chiếc iPhone n&agrave;y trở th&agrave;nh lựa chọn đ&aacute;ng c&acirc;n nhắc:</p>\r\n\r\n<h3><strong>M&agrave;n h&igrave;nh rực rỡ, h&igrave;nh ảnh ch&acirc;n thực</strong></h3>\r\n\r\n<p><strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;sở hữu m&agrave;n h&igrave;nh<strong>&nbsp;OLED 6.7 inch</strong>&nbsp;với c&ocirc;ng nghệ Super Retina XDR, mang đến chất lượng hiển thị sắc n&eacute;t v&agrave; m&agrave;u sắc ch&acirc;n thực. Độ ph&acirc;n giải 2796 x 1290 pixel gi&uacute;p từng chi tiết được t&aacute;i hiện r&otilde; r&agrave;ng, kết hợp c&ugrave;ng dải m&agrave;u rộng P3 v&agrave; HDR10 cho trải nghiệm xem phim, chơi game hay l&agrave;m việc đều trở n&ecirc;n sống động.</p>\r\n\r\n<p><img alt=\"Màn hình iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/1_221.jpg\" style=\"height:500px; width:952px\" /></p>\r\n\r\n<p>Kh&ocirc;ng chỉ vậy, Apple c&ograve;n trang bị độ s&aacute;ng tối đa l&ecirc;n đến 2000 nits, gi&uacute;p hiển thị r&otilde; ngay cả dưới &aacute;nh s&aacute;ng mặt trời. Tần số qu&eacute;t 120Hz với c&ocirc;ng nghệ ProMotion mang đến thao t&aacute;c vuốt chạm mượt m&agrave;, phản hồi nhanh ch&oacute;ng. Đ&acirc;y l&agrave; yếu tố quan trọng gi&uacute;p iPhone 14 Pro Max cũ vẫn giữ vững vị thế của một flagship cao cấp.</p>\r\n\r\n<h3><strong>Hiệu năng vượt trội nhờ v&agrave;o chip A16 Bionic</strong></h3>\r\n\r\n<p>B&ecirc;n trong&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;l&agrave; con&nbsp;<strong>chip A16 Bionic</strong>&nbsp;mạnh mẽ, sản xuất tr&ecirc;n tiến tr&igrave;nh 4nm, gi&uacute;p tối ưu cả hiệu năng lẫn mức ti&ecirc;u thụ điện năng. So với thế hệ trước, con chip n&agrave;y mang lại tốc độ xử l&yacute; nhanh hơn, cải thiện đ&aacute;ng kể khả năng đa nhiệm v&agrave; hỗ trợ mượt m&agrave; c&aacute;c t&aacute;c vụ nặng như chỉnh sửa video, chơi game đồ họa cao.</p>\r\n\r\n<p><img alt=\"Hiệu năng iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/2_218.jpg\" style=\"height:500px; width:952px\" /></p>\r\n\r\n<p>GPU 5 nh&acirc;n tr&ecirc;n A16 Bionic cũng gi&uacute;p xử l&yacute; đồ họa mạnh mẽ hơn 50% so với A15 Bionic. Nhờ đ&oacute;, c&aacute;c tựa game nặng như Genshin Impact hay PUBG Mobile đều c&oacute; thể chạy với mức đồ họa cao m&agrave; kh&ocirc;ng gặp t&igrave;nh trạng giật lag. Hệ thống Neural Engine cải tiến cũng gi&uacute;p iPhone 14 Pro Max cũ xử l&yacute; c&aacute;c t&aacute;c vụ AI th&ocirc;ng minh hơn, đặc biệt l&agrave; trong chụp ảnh v&agrave; tối ưu năng lượng.</p>\r\n\r\n<h3><strong>Camera 48MP &ndash; Chụp n&eacute;t, zoom xa cực chất</strong></h3>\r\n\r\n<p>Camera ch&iacute;nh của&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;được n&acirc;ng cấp l&ecirc;n 48MP, sử dụng cảm biến Quad-Pixel hiện đại gi&uacute;p tăng khả năng thu s&aacute;ng, mang lại những bức ảnh sắc n&eacute;t ngay cả trong điều kiện thiếu s&aacute;ng. Ngo&agrave;i ra, chế độ ProRAW gi&uacute;p lưu giữ h&igrave;nh ảnh với đầy đủ chi tiết, cho ph&eacute;p hậu kỳ chuy&ecirc;n nghiệp hơn.</p>\r\n\r\n<p><img alt=\"Camera iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/3_190.jpg\" style=\"height:500px; width:952px\" /></p>\r\n\r\n<p>Hệ thống camera c&ograve;n hỗ trợ zoom quang học 6X, gi&uacute;p chụp ảnh xa m&agrave; vẫn giữ được độ n&eacute;t cao. C&aacute;c t&iacute;nh năng như Action Mode gi&uacute;p quay video chống rung cực tốt, Night Mode hỗ trợ chụp thiếu s&aacute;ng ấn tượng, v&agrave; Cinematic Mode cho ph&eacute;p quay video 4K với hiệu ứng l&agrave;m mờ hậu cảnh chuy&ecirc;n nghiệp. Tất cả gi&uacute;p iPhone 14 Pro Max cũ trở th&agrave;nh một lựa chọn l&yacute; tưởng cho những ai đam m&ecirc; nhiếp ảnh v&agrave; quay phim.</p>\r\n\r\n<h3><strong>Thời lượng pin ấn tượng l&ecirc;n đến 29 giờ</strong></h3>\r\n\r\n<p>Sở hữu vi&ecirc;n pin dung lượng<strong>&nbsp;4352mAh</strong>,&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;c&oacute; thể hoạt động suốt cả ng&agrave;y d&agrave;i m&agrave; kh&ocirc;ng cần lo lắng về sạc pin. Theo Apple c&ocirc;ng bố, thiết bị c&oacute; thể ph&aacute;t video li&ecirc;n tục trong 29 giờ v&agrave; ph&aacute;t nhạc l&ecirc;n đến 95 giờ, gi&uacute;p người d&ugrave;ng thoải m&aacute;i sử dụng m&agrave; kh&ocirc;ng gi&aacute;n đoạn.</p>\r\n\r\n<p><img alt=\"Thời lượng pin ấn tượng lên đến 29 giờ\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/4_171.jpg\" style=\"height:500px; width:952px\" /></p>\r\n\r\n<p>Ngo&agrave;i ra, m&aacute;y hỗ trợ sạc nhanh 20W, gi&uacute;p sạc 50% pin chỉ trong 30 ph&uacute;t. iPhone 14 Pro Max cũ cũng tương th&iacute;ch với sạc kh&ocirc;ng d&acirc;y MagSafe 15W v&agrave; sạc chuẩn Qi 7.5W, mang lại sự tiện lợi khi nạp năng lượng. Với thời lượng pin ấn tượng c&ugrave;ng nhiều c&ocirc;ng nghệ tiết kiệm năng lượng tr&ecirc;n chip A16 Bionic, chiếc flagship n&agrave;y vẫn l&agrave; một trong những smartphone c&oacute; thời gian sử dụng tốt nhất hiện nay.</p>', 15, 1, 'uploads/avtproduct/otlgMsCzzCuiHeEKp5TuY1AnvKyIIarnornNQZm0.jpg', '2025-11-18 03:09:43', '2026-01-19 20:37:25', NULL, 21),
(17, 'IPHONE17PROMAX', 'iPhone 17 pro Max', 'iphone-17-pro-max', 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0, '<h1>iPhone 17 Pro Max c&oacute; mấy m&agrave;u? Gợi &yacute; m&agrave;u hợp mệnh iFans</h1>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\" rel=\"noreferrer noopener\" target=\"_blank\"><strong>Apple</strong>&nbsp;<strong>iPhone 17 Pro Max</strong></a><strong>&nbsp;c&oacute; mấy m&agrave;u l&agrave; c&acirc;u hỏi được rất nhiều iFans quan t&acirc;m khi Apple th&ocirc;ng b&aacute;o ra mắt c&aacute;c phi&ecirc;n bản&nbsp;<a href=\"https://viettelstore.vn/dtdd/apple/iphone-17\" rel=\"noreferrer noopener\" target=\"_blank\">iPhone 17</a>&nbsp;năm nay. Theo c&ocirc;ng bố ch&iacute;nh thức từ Apple, iPhone 17 Pro Max c&oacute; 3 m&agrave;u gồm: Bạc, Xanh Đậm, v&agrave; Cam Vũ Trụ</strong>.<strong>&nbsp;Để t&igrave;m hiểu chi tiết cũng như chọn m&agrave;u hợp mệnh cho chiếc&nbsp;<a href=\"https://viettelstore.vn/dtdd-apple-iphone\" rel=\"noreferrer noopener\" target=\"_blank\">điện thoại iPhone</a>&nbsp;của m&igrave;nh, bạn h&atilde;y theo d&otilde;i b&agrave;i viết dưới đ&acirc;y của Viettel Store.</strong></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h2><strong>Điện thoại iPhone 17 Pro Max c&oacute; mấy m&agrave;u?</strong></h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h3><strong>Bảng m&agrave;u iPhone 17 Pro Max</strong></h3>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<table>\r\n	<tbody>\r\n		<tr>\r\n			<td><strong>STT</strong></td>\r\n			<td><strong>C&aacute;c m&agrave;u iPhone 17 Pro Max</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td>1</td>\r\n			<td>iPhone 17 Pro Max m&agrave;u Bạc</td>\r\n		</tr>\r\n		<tr>\r\n			<td>2</td>\r\n			<td>iPhone 17 Pro Max m&agrave;u Xanh Đậm</td>\r\n		</tr>\r\n		<tr>\r\n			<td>3</td>\r\n			<td>iPhone 17 Pro Max m&agrave;u Cam Vũ Trụ</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p><em>Bảng m&agrave;u iPhone 17 Pro Max</em></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-2tb-pid355578.html\"><img alt=\"iPhone 17 Pro Max 2TB\" src=\"https://cdn1.viettelstore.vn/images/Product/ProductImage/medium/17-Pro-Pro-Max-Cam1.jpg\" /></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-2tb-pid355578.html\">iPhone 17 Pro Max 2TB</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-2tb-pid355578.html\">62,990,000 ₫</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-2tb-pid355578.html\"><del>63,990,000 ₫</del></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-2tb-pid355578.html\">Mua ngay</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-1tb-pid355089.html\"><img alt=\"iPhone 17 Pro Max 1TB\" src=\"https://cdn1.viettelstore.vn/images/Product/ProductImage/medium/17-Pro-Pro-Max-Xanhdam1.jpg\" /></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-1tb-pid355089.html\">iPhone 17 Pro Max 1TB</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-1tb-pid355089.html\">49,490,000 ₫</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-1tb-pid355089.html\"><del>50,990,000 ₫</del></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-1tb-pid355089.html\">Mua ngay</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-512gb-pid355088.html\"><img alt=\"iPhone 17 Pro Max 512GB\" src=\"https://cdn1.viettelstore.vn/images/Product/ProductImage/medium/17-Pro-Pro-Max-bac11227077986.jpg\" /></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-512gb-pid355088.html\">iPhone 17 Pro Max 512GB</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-512gb-pid355088.html\">42,990,000 ₫</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-512gb-pid355088.html\"><del>44,490,000 ₫</del></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-512gb-pid355088.html\">Mua ngay</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\"><img alt=\"iPhone 17 Pro Max 256GB\" src=\"https://cdn1.viettelstore.vn/images/Product/ProductImage/medium/17-Pro-Pro-Max-Cam11990372886.jpg\" /></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\">iPhone 17 Pro Max 256GB</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\">36,990,000 ₫</a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\"><del>37,990,000 ₫</del></a></p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-max-pid355086.html\">Mua ngay</a></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-pid355082.html\" rel=\"noreferrer noopener\" target=\"_blank\"><strong>iPhone 17 Pro</strong></a>&nbsp;Max ch&iacute;nh thức ra mắt với 3 t&ugrave;y chọn m&agrave;u sắc, bao gồm: Bạc, Xanh Đậm, v&agrave; đặc biệt m&agrave;u ho&agrave;n to&agrave;n mới Cam Vũ Trụ. Theo c&aacute;c&nbsp;<strong><a href=\"https://viettelstore.vn/tin-tuc/review-iphone-17\" rel=\"noreferrer noopener\" target=\"_blank\">đ&aacute;nh gi&aacute; iPhone 17</a></strong>&nbsp;phi&ecirc;n bản Pro Max, mỗi m&agrave;u đều mang phong c&aacute;ch sang trọng, bền bỉ nhờ chất liệu nh&ocirc;m nguy&ecirc;n khối cao cấp, gi&uacute;p người d&ugrave;ng dễ d&agrave;ng lựa chọn phi&ecirc;n bản ph&ugrave; hợp với c&aacute; t&iacute;nh v&agrave; sở th&iacute;ch của m&igrave;nh.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img alt=\"iphone 17 pro max có mấy màu\" src=\"https://news.vio.vn/wp-content/uploads/2025/09/iphone-17-pro-max.jpg\" /></p>\r\n\r\n<p><em>iPhone 17 Pro Max c&oacute; 3 m&agrave;u: Bạc, Xanh Đậm, Cam Vũ Trụ</em></p>\r\n\r\n<h3><strong>iPhone 17 Pro Max m&agrave;u Bạc</strong></h3>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Trong bảng m&agrave;u iPhone 17 Pro Max, m&agrave;u Bạc nổi bật với vẻ ngo&agrave;i tinh tế, thanh lịch v&agrave; hiện đại &ndash; một lựa chọn ho&agrave;n hảo cho những ai y&ecirc;u th&iacute;ch sự tối giản nhưng vẫn to&aacute;t l&ecirc;n đẳng cấp. Sắc bạc trung t&iacute;nh ph&ugrave; hợp với cả nam v&agrave; nữ.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Với nam giới, iPhone 17 Pro Max m&agrave;u bạc mang lại cảm gi&aacute;c chỉn chu, chuy&ecirc;n nghiệp v&agrave; phong th&aacute;i tự tin. C&ograve;n với nữ giới, đ&acirc;y l&agrave; gam m&agrave;u của sự thanh tho&aacute;t, tinh tế v&agrave; thời thượng, gi&uacute;p khẳng định gu thẩm mỹ ri&ecirc;ng biệt.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Sự kết hợp giữa sắc bạc sang trọng v&agrave; khung nh&ocirc;m nguy&ecirc;n khối bền bỉ tạo n&ecirc;n một thiết kế đậm chất tương lai, vừa nhẹ nh&agrave;ng m&agrave; vẫn đầy c&aacute; t&iacute;nh &ndash; phản &aacute;nh đ&uacute;ng tinh thần đổi mới m&agrave; iPhone 17 Pro Max mang lại.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img alt=\"iPhone 17 Pro Max chất liệu nhôm nguyên khối nhẹ bền\" src=\"https://news.vio.vn/wp-content/uploads/2025/09/iphone-17-3-2.jpg\" style=\"height:579px; width:579px\" /></p>\r\n\r\n<p><em>iPhone 17 Pro Max chất liệu nh&ocirc;m nguy&ecirc;n khối nhẹ bền</em></p>\r\n\r\n<p><strong>Xem th&ecirc;m:</strong></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li><a href=\"https://viettelstore.vn/tin-tuc/iphone-17-co-chong-nuoc-khong\" rel=\"noreferrer noopener\" target=\"_blank\"><strong><strong>iPhone 17 c&oacute; chống nước kh&ocirc;ng</strong></strong></a><strong><strong>? Sự thật khiến nhiều người bất ngờ</strong></strong></li>\r\n	<li><a href=\"https://viettelstore.vn/tin-tuc/iphone-17-co-may-loai\" rel=\"noreferrer noopener\" target=\"_blank\"><strong>iPhone 17 c&oacute; mấy loại</strong></a><strong>? To&agrave;n cảnh c&aacute;c phi&ecirc;n bản mới nhất của Apple</strong></li>\r\n	<li><strong><a href=\"https://viettelstore.vn/dien-thoai/iphone-air-pid355092.html\" rel=\"noreferrer noopener\" target=\"_blank\">iPhone Air</a></strong>: M&agrave;u sắc sang trọng, tinh tế</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h3><strong>iPhone 17 Pro Max m&agrave;u Xanh Đậm</strong></h3>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>iPhone 17 Pro Max m&agrave;u Xanh Đậm mang vẻ đẹp sang trọng, hiện đại nhưng vẫn trẻ trung v&agrave; nổi bật. Điểm th&uacute; vị l&agrave; sắc Xanh Đậm trong bảng m&agrave;u iPhone 17 Pro Max ph&ugrave; hợp cho cả nam v&agrave; nữ. Với nam giới, sắc xanh đậm mang đến sự lịch l&atilde;m, chững chạc v&agrave; mạnh mẽ.&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Trong khi đ&oacute;, với nữ giới, m&agrave;u n&agrave;y lại tạo n&eacute;t thanh lịch, c&aacute; t&iacute;nh v&agrave; cuốn h&uacute;t. Đ&acirc;y l&agrave; một trong những phi&ecirc;n bản hứa hẹn được iFans ưa chuộng nhất trong số c&aacute;c m&agrave;u iPhone 17.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img alt=\"iphone 17 pro max có mấy màu\" src=\"https://news.vio.vn/wp-content/uploads/2025/09/iphone-17-pro-max-xanh-%C4%91%E1%BA%ADm.jpg\" /></p>\r\n\r\n<p><em>iPhone 17 Pro Max m&agrave;u Xanh Đậm sang trọng</em></p>\r\n\r\n<h3><strong>iPhone 17 Pro Max m&agrave;u Cam Vũ Trụ</strong></h3>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>iPhone 17 Pro Max m&agrave;u Cam Vũ Trụ l&agrave; m&agrave;u sắc đặc biệt nhất, lần đầu ti&ecirc;n xuất hiện tr&ecirc;n d&ograve;ng Pro Max. M&agrave;u Cam Vũ trụ l&agrave; lựa chọn mới mẻ v&agrave; độc đ&aacute;o, mang đến cảm gi&aacute;c trẻ trung, năng động v&agrave; tr&agrave;n đầy năng lượng.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Sắc cam ph&ugrave; hợp cho cả nam v&agrave; nữ. Nam giới khi sử dụng gam m&agrave;u n&agrave;y sẽ to&aacute;t l&ecirc;n sự tự tin, quyết đo&aacute;n v&agrave; kh&aacute;c biệt. Trong khi đ&oacute;, nữ giới lại trở n&ecirc;n nổi bật, c&aacute; t&iacute;nh v&agrave; đầy cuốn h&uacute;t. Đ&acirc;y l&agrave; phi&ecirc;n bản d&agrave;nh cho những iFans muốn khẳng định c&aacute; t&iacute;nh v&agrave; kh&ocirc;ng ngại trở th&agrave;nh t&acirc;m điểm.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img alt=\"iphone 17 pro max có mấy màu\" src=\"https://news.vio.vn/wp-content/uploads/2025/09/iphone-17-pro-max-m%C3%A0u-cam.jpg\" /></p>\r\n\r\n<p><em>M&agrave;u Cam Vũ Trụ lần đầu ti&ecirc;n xuất hiện tr&ecirc;n iPhone 17 Pro Max</em></p>\r\n\r\n<h2><strong>Điện thoại iPhone 17 Pro Max m&agrave;u n&agrave;o đẹp nhất</strong></h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>iPhone 17 Pro Max được Apple giới thiệu với 3 phi&ecirc;n bản m&agrave;u sắc. Trong đ&oacute;, m&agrave;u Cam Vũ Trụ v&agrave; Bạc đang l&agrave; hai m&agrave;u được iFans đ&aacute;nh gi&aacute; cao nhất nhờ vẻ ngo&agrave;i sang trọng, dễ phối hợp phụ kiện v&agrave; ph&ugrave; hợp phong thủy cho nhiều mệnh.&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Tuy nhi&ecirc;n, mỗi t&ugrave;y chọn trong bảng m&agrave;u iPhone 17 Pro Max đều mang n&eacute;t c&aacute; t&iacute;nh ri&ecirc;ng: Bạc, Xanh Đậm trung t&iacute;nh bền bỉ, c&ograve;n Cam Vũ Trụ th&igrave; trẻ trung, nổi bật. T&ugrave;y v&agrave;o sở th&iacute;ch v&agrave; phong c&aacute;ch, người d&ugrave;ng c&oacute; thể lựa chọn m&agrave;u sắc ph&ugrave; hợp nhất để vừa đẹp mắt vừa hợp mệnh.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>XEM TH&Ecirc;M:</strong></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li><strong><a href=\"https://viettelstore.vn/dien-thoai/iphone-17-pro-1tb-pid355085.html\" rel=\"noreferrer noopener\" target=\"_blank\">iPhone 17 Pro 1TB</a>&nbsp;c&oacute; gi&aacute; bao nhi&ecirc;u?</strong></li>\r\n	<li><a href=\"https://viettelstore.vn/tin-tuc/ghi-hinh-kep-tren-iphone\" rel=\"noreferrer noopener nofollow\" target=\"_blank\"><strong>Ghi h&igrave;nh k&eacute;p</strong></a>&nbsp;(Dual Capture) tr&ecirc;n iPhone 17 &ndash; Vũ kh&iacute; cho nh&agrave; s&aacute;ng tạo nội dung</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h2><strong>Gợi &yacute; c&aacute;ch chọn m&agrave;u hợp mệnh cho iFans</strong></h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Trong phong thủy, việc chọn m&agrave;u sắc kh&ocirc;ng chỉ mang &yacute; nghĩa thẩm mỹ m&agrave; c&ograve;n ảnh hưởng đến năng lượng, may mắn v&agrave; sự c&acirc;n bằng trong cuộc sống. Theo đ&oacute;, c&aacute;c m&agrave;u iPhone 17 Pro Max đều mang đến cho iFans nhiều lựa chọn ph&ugrave; hợp từng bản mệnh:</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li><strong>Mệnh Kim</strong>: Hợp với m&agrave;u Bạc, tượng trưng cho sự tinh khiết, s&aacute;ng suốt v&agrave; bền vững.</li>\r\n	<li><strong>Mệnh Mộc</strong>: Ph&ugrave; hợp với Xanh Đậm gi&uacute;p thu h&uacute;t năng lượng t&iacute;ch cực, gia tăng may mắn v&agrave; t&agrave;i lộc.</li>\r\n	<li><strong>Mệnh Thủy</strong>: Hợp với Bạc v&agrave; Xanh Đậm, mang lại sự c&acirc;n bằng, linh hoạt v&agrave; th&ocirc;ng minh.</li>\r\n	<li><strong>Mệnh Hỏa</strong>: N&ecirc;n chọn Cam Vũ Trụ để thể hiện sự mạnh mẽ, nhiệt huyết v&agrave; s&aacute;ng tạo.</li>\r\n	<li><strong>Mệnh Thổ</strong>: Th&iacute;ch hợp với gam Xanh Đậm hoặc Cam Vũ Trụ, gi&uacute;p củng cố sự ổn định v&agrave; vững chắc.</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h2><strong>Bảng so s&aacute;nh tổng quan m&agrave;u sắc iPhone 17 Pro Max</strong></h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>C&aacute;c m&agrave;u iPhone 17 Pro Max đều thể hiện c&aacute; t&iacute;nh ri&ecirc;ng, từ sang trọng, hiện đại cho đến trẻ trung, năng động. Bảng dưới đ&acirc;y sẽ gi&uacute;p bạn c&oacute; c&aacute;i nh&igrave;n to&agrave;n diện hơn:</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<table>\r\n	<tbody>\r\n		<tr>\r\n			<td><strong>M&agrave;u sắc</strong></td>\r\n			<td><strong>Đặc điểm nổi bật</strong></td>\r\n			<td><strong>Đối tượng ph&ugrave; hợp</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td>Bạc</td>\r\n			<td>Sang trọng, tao nh&atilde;, mang hơi thở hiện đại</td>\r\n			<td>Nữ giới, người th&iacute;ch sự tối giản, tinh tế</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Xanh Đậm</td>\r\n			<td>Mới lạ, trẻ trung nhưng vẫn sang trọng</td>\r\n			<td>Người trẻ, cả nam v&agrave; nữ y&ecirc;u th&iacute;ch sự c&aacute; t&iacute;nh</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Cam Vũ Trụ</td>\r\n			<td>Nổi bật, năng động, kh&aacute;c biệt</td>\r\n			<td>Người th&iacute;ch sự ph&aacute; c&aacute;ch, hợp với cả nam v&agrave; nữ c&oacute; gu thời trang ri&ecirc;ng</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p><em>Đối tượng ph&ugrave; hợp với từng phi&ecirc;n bản m&agrave;u sắc iPhone 17 Pro Max</em></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h2><strong>Bảng so s&aacute;nh m&agrave;u sắc iPhone 17 với c&aacute;c phi&ecirc;n bản tiền nhiệm</strong></h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Từ iPhone 15 đến iPhone 17, Apple li&ecirc;n tục thay đổi bảng m&agrave;u để đ&aacute;p ứng thị hiếu đa dạng của người d&ugrave;ng. Nếu iPhone 15 mang phong c&aacute;ch trẻ trung, iPhone 16 tạo điểm nhấn với sắc Desert Titanium mới lạ, th&igrave; đến thế hệ iPhone mới năm nay, Apple đ&atilde; tối giản hơn với c&aacute;c lựa chọn m&agrave;u sắc độc đ&aacute;o, ấn tượng.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Bảng dưới đ&acirc;y sẽ gi&uacute;p bạn dễ d&agrave;ng h&igrave;nh dung sự kh&aacute;c biệt giữa c&aacute;c thế hệ.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<table>\r\n	<tbody>\r\n		<tr>\r\n			<td><strong>Phi&ecirc;n bản</strong></td>\r\n			<td><strong>iPhone 15 Series&nbsp;</strong></td>\r\n			<td><strong>iPhone 16 Series</strong></td>\r\n			<td><strong>Thế hệ iPhone mới</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td><strong>Pro / Pro Max</strong></td>\r\n			<td>M&agrave;u Đen Titanium, M&agrave;u Trắng Titanium, M&agrave;u Xanh Titanium, M&agrave;u Nguy&ecirc;n Bản Titanium</td>\r\n			<td>M&agrave;u Đen Titan, M&agrave;u Trắng Titan, M&agrave;u Nguy&ecirc;n Bản Titan, M&agrave;u Titan Sa Mạc</td>\r\n			<td>Bạc, Xanh Đậm, Cam Vũ Trụ</td>\r\n		</tr>\r\n		<tr>\r\n			<td><strong>Ti&ecirc;u chuẩn</strong></td>\r\n			<td>Đen, Xanh Dương, Xanh L&aacute;, Hồng, V&agrave;ng</td>\r\n			<td>Xanh Ultramarine, Xanh Ngọc Lam (Teal), Hồng, Trắng, Đen</td>\r\n			<td>T&iacute;m Oải Hương, Xanh L&aacute; X&ocirc; Thơm, Xanh Lam Kh&oacute;i, Trắng, Đen</td>\r\n		</tr>\r\n		<tr>\r\n			<td><strong>iPhone Air</strong></td>\r\n			<td>&ndash;</td>\r\n			<td>&ndash;</td>\r\n			<td>Trắng M&acirc;y, Đen Kh&ocirc;ng Gian, Xanh Da Trời, V&agrave;ng Nhạt</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p><em>Bảng so s&aacute;nh c&aacute;c m&agrave;u sắc iPhone 17 với c&aacute;c phi&ecirc;n bản tiền nhiệm</em></p>', 1, 1, 'uploads/avtproduct/sdEfQ1j0kWnv0y16fenG1g7bt66PT7k7Qa6qfW4c.jpg', '2025-11-25 05:32:04', '2026-01-22 21:57:45', NULL, 49),
(18, 'IPHONE18PROMAX', 'iPhone 18 pro Max', 'iphone-18-pro-max', 0.00, 0.00, 0.00, 0.00, 2000.00, 1, 1, '<p>fdadadadadaddad</p>', 15, 1, 'uploads/avtproduct/GvS0L23fsoEsavXYs0OPhIbELnCS9dxWGv6Blk2c.jpg', '2026-01-18 13:40:05', '2026-01-22 21:57:37', NULL, 7),
(19, 'IPHONE20PR-938', 'iPhone 20 pro Max', 'iphone-20-pro-max', 0.00, 0.00, 0.00, 0.00, 2000.00, 1, 1, '<h2><strong>V&igrave; sao n&ecirc;n mua iPhone 14 Pro Max 256GB Cũ 99,9%?</strong></h2>\r\n\r\n<p>Mua&nbsp;<strong>&nbsp;iPhone 14 Pro Max 256GB cũ 99,9%</strong>&nbsp;l&agrave; c&aacute;ch th&ocirc;ng minh để sở hữu một flagship cao cấp với mức gi&aacute; tiết kiệm hơn. So với m&aacute;y mới, phi&ecirc;n bản cũ vẫn đảm bảo trải nghiệm mạnh mẽ từ thiết kế, m&agrave;n h&igrave;nh đến hiệu năng. Dưới đ&acirc;y l&agrave; những l&yacute; do bạn n&ecirc;n chọn mua:</p>\r\n\r\n<ul>\r\n	<li><strong>Tiết kiệm chi ph&iacute; đ&aacute;ng kể</strong>: Gi&aacute; iPhone 14 Pro Max 256GB cũ rẻ hơn nhiều so với m&aacute;y mới, gi&uacute;p bạn sở hữu một chiếc flagship cao cấp m&agrave; kh&ocirc;ng cần chi qu&aacute; nhiều.</li>\r\n	<li><strong>Chất lượng đảm bảo</strong>:&nbsp;<a href=\"https://bachlongmobile.com/product-old/\" rel=\"noopener\" target=\"_blank\"><strong>M&aacute;y cũ</strong></a>&nbsp;thường sẽ được kiểm tra kỹ lưỡng, đảm bảo ngoại h&igrave;nh đẹp, linh kiện nguy&ecirc;n zin v&agrave; hiệu suất ổn định, mang lại trải nghiệm sử dụng mượt m&agrave;.</li>\r\n	<li><strong>Ch&iacute;nh s&aacute;ch bảo h&agrave;nh đầy đủ</strong>: Khi mua tại cửa h&agrave;ng uy t&iacute;n, bạn sẽ nhận được bảo h&agrave;nh r&otilde; r&agrave;ng, hỗ trợ đổi trả nếu c&oacute; lỗi từ nh&agrave; sản xuất.</li>\r\n	<li><strong>Trải nghiệm flagship với gi&aacute; hợp l&yacute;</strong>: D&ugrave; l&agrave; m&aacute;y cũ, iPhone 14 Pro Max 256GB vẫn giữ nguy&ecirc;n những ưu điểm vượt trội như m&agrave;n h&igrave;nh OLED sắc n&eacute;t, hiệu năng mạnh mẽ v&agrave; hệ thống camera cao cấp.</li>\r\n</ul>\r\n\r\n<p><img alt=\"Vì sao nên mua iPhone 14 Pro Max 256GB Cũ 99,9%?\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/6_113.jpg\" /></p>\r\n\r\n<p>Nếu bạn muốn sở hữu một chiếc iPhone cao cấp với mức gi&aacute; hợp l&yacute;, iPhone 14 Pro Max 256GB cũ chắc chắn l&agrave; lựa chọn đ&aacute;ng c&acirc;n nhắc!</p>\r\n\r\n<h2><strong>Điểm nổi bật của iPhone 14 Pro Max 256GB Cũ 99,9%</strong></h2>\r\n\r\n<p><strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;vẫn giữ nguy&ecirc;n những ưu điểm của một flagship cao cấp, từ thiết kế sang trọng, m&agrave;n h&igrave;nh sắc n&eacute;t đến hiệu năng mạnh mẽ. Dưới đ&acirc;y l&agrave; những điểm nổi bật gi&uacute;p chiếc iPhone n&agrave;y trở th&agrave;nh lựa chọn đ&aacute;ng c&acirc;n nhắc:</p>\r\n\r\n<h3><strong>M&agrave;n h&igrave;nh rực rỡ, h&igrave;nh ảnh ch&acirc;n thực</strong></h3>\r\n\r\n<p><strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;sở hữu m&agrave;n h&igrave;nh<strong>&nbsp;OLED 6.7 inch</strong>&nbsp;với c&ocirc;ng nghệ Super Retina XDR, mang đến chất lượng hiển thị sắc n&eacute;t v&agrave; m&agrave;u sắc ch&acirc;n thực. Độ ph&acirc;n giải 2796 x 1290 pixel gi&uacute;p từng chi tiết được t&aacute;i hiện r&otilde; r&agrave;ng, kết hợp c&ugrave;ng dải m&agrave;u rộng P3 v&agrave; HDR10 cho trải nghiệm xem phim, chơi game hay l&agrave;m việc đều trở n&ecirc;n sống động.</p>\r\n\r\n<p><img alt=\"Màn hình iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/1_221.jpg\" /></p>\r\n\r\n<p>Kh&ocirc;ng chỉ vậy, Apple c&ograve;n trang bị độ s&aacute;ng tối đa l&ecirc;n đến 2000 nits, gi&uacute;p hiển thị r&otilde; ngay cả dưới &aacute;nh s&aacute;ng mặt trời. Tần số qu&eacute;t 120Hz với c&ocirc;ng nghệ ProMotion mang đến thao t&aacute;c vuốt chạm mượt m&agrave;, phản hồi nhanh ch&oacute;ng. Đ&acirc;y l&agrave; yếu tố quan trọng gi&uacute;p iPhone 14 Pro Max cũ vẫn giữ vững vị thế của một flagship cao cấp.</p>\r\n\r\n<h3><strong>Hiệu năng vượt trội nhờ v&agrave;o chip A16 Bionic</strong></h3>\r\n\r\n<p>B&ecirc;n trong&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;l&agrave; con&nbsp;<strong>chip A16 Bionic</strong>&nbsp;mạnh mẽ, sản xuất tr&ecirc;n tiến tr&igrave;nh 4nm, gi&uacute;p tối ưu cả hiệu năng lẫn mức ti&ecirc;u thụ điện năng. So với thế hệ trước, con chip n&agrave;y mang lại tốc độ xử l&yacute; nhanh hơn, cải thiện đ&aacute;ng kể khả năng đa nhiệm v&agrave; hỗ trợ mượt m&agrave; c&aacute;c t&aacute;c vụ nặng như chỉnh sửa video, chơi game đồ họa cao.</p>\r\n\r\n<p><img alt=\"Hiệu năng iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/2_218.jpg\" /></p>\r\n\r\n<p>GPU 5 nh&acirc;n tr&ecirc;n A16 Bionic cũng gi&uacute;p xử l&yacute; đồ họa mạnh mẽ hơn 50% so với A15 Bionic. Nhờ đ&oacute;, c&aacute;c tựa game nặng như Genshin Impact hay PUBG Mobile đều c&oacute; thể chạy với mức đồ họa cao m&agrave; kh&ocirc;ng gặp t&igrave;nh trạng giật lag. Hệ thống Neural Engine cải tiến cũng gi&uacute;p iPhone 14 Pro Max cũ xử l&yacute; c&aacute;c t&aacute;c vụ AI th&ocirc;ng minh hơn, đặc biệt l&agrave; trong chụp ảnh v&agrave; tối ưu năng lượng.</p>\r\n\r\n<h3><strong>Camera 48MP &ndash; Chụp n&eacute;t, zoom xa cực chất</strong></h3>\r\n\r\n<p>Camera ch&iacute;nh của&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;được n&acirc;ng cấp l&ecirc;n 48MP, sử dụng cảm biến Quad-Pixel hiện đại gi&uacute;p tăng khả năng thu s&aacute;ng, mang lại những bức ảnh sắc n&eacute;t ngay cả trong điều kiện thiếu s&aacute;ng. Ngo&agrave;i ra, chế độ ProRAW gi&uacute;p lưu giữ h&igrave;nh ảnh với đầy đủ chi tiết, cho ph&eacute;p hậu kỳ chuy&ecirc;n nghiệp hơn.</p>\r\n\r\n<p><img alt=\"Camera iPhone 14 Pro Max 256GB Cũ 99,9%\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/3_190.jpg\" /></p>\r\n\r\n<p>Hệ thống camera c&ograve;n hỗ trợ zoom quang học 6X, gi&uacute;p chụp ảnh xa m&agrave; vẫn giữ được độ n&eacute;t cao. C&aacute;c t&iacute;nh năng như Action Mode gi&uacute;p quay video chống rung cực tốt, Night Mode hỗ trợ chụp thiếu s&aacute;ng ấn tượng, v&agrave; Cinematic Mode cho ph&eacute;p quay video 4K với hiệu ứng l&agrave;m mờ hậu cảnh chuy&ecirc;n nghiệp. Tất cả gi&uacute;p iPhone 14 Pro Max cũ trở th&agrave;nh một lựa chọn l&yacute; tưởng cho những ai đam m&ecirc; nhiếp ảnh v&agrave; quay phim.</p>\r\n\r\n<h3><strong>Thời lượng pin ấn tượng l&ecirc;n đến 29 giờ</strong></h3>\r\n\r\n<p>Sở hữu vi&ecirc;n pin dung lượng<strong>&nbsp;4352mAh</strong>,&nbsp;<strong>iPhone 14 Pro Max 256GB Cũ 99,9%</strong>&nbsp;c&oacute; thể hoạt động suốt cả ng&agrave;y d&agrave;i m&agrave; kh&ocirc;ng cần lo lắng về sạc pin. Theo Apple c&ocirc;ng bố, thiết bị c&oacute; thể ph&aacute;t video li&ecirc;n tục trong 29 giờ v&agrave; ph&aacute;t nhạc l&ecirc;n đến 95 giờ, gi&uacute;p người d&ugrave;ng thoải m&aacute;i sử dụng m&agrave; kh&ocirc;ng gi&aacute;n đoạn.</p>\r\n\r\n<p><img alt=\"Thời lượng pin ấn tượng lên đến 29 giờ\" src=\"https://beta-api.bachlongmobile.com/media/.renditions/wysiwyg/4_171.jpg\" /></p>\r\n\r\n<p>Ngo&agrave;i ra, m&aacute;y hỗ trợ sạc nhanh 20W, gi&uacute;p sạc 50% pin chỉ trong 30 ph&uacute;t. iPhone 14 Pro Max cũ cũng tương th&iacute;ch với sạc kh&ocirc;ng d&acirc;y MagSafe 15W v&agrave; sạc chuẩn Qi 7.5W, mang lại sự tiện lợi khi nạp năng lượng. Với thời lượng pin ấn tượng c&ugrave;ng nhiều c&ocirc;ng nghệ tiết kiệm năng lượng tr&ecirc;n chip A16 Bionic, chiếc flagship n&agrave;y vẫn l&agrave; một trong những smartphone c&oacute; thời gian sử dụng tốt nhất hiện nay.</p>', 15, 1, 'uploads/avtproduct/yysDtxgZ2mot2NMQWa08DSbuI1zHikVhGDPipNmy.jpg', '2026-01-19 10:35:45', '2026-01-29 18:17:25', NULL, 113),
(20, 'IPHONE21PR-699', 'iPhone 21 pro Max', 'iphone-21-pro-max', 10.00, 10.00, 10.00, 10.00, 200000.00, 1, 0, '<p>dsfasfadsfasf</p>', 15, 1, 'uploads/avtproduct/kN0yP5ZIagvzMeUODzg3ooSn5i54uwTyv6tGZSbt.jpg', '2026-01-22 07:55:52', '2026-01-27 18:28:52', NULL, 18);

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_url`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 18, 'storage/uploads/product_gallery/Nx32pYLBNTCOtTZtiNA9JjndUCc7vBEx7Y4bkgMb.jpg', 0, '2026-01-18 13:40:05', '2026-01-18 13:40:05', NULL),
(2, 18, 'storage/uploads/product_gallery/7d8pwxg1jD0QeCiY1mcZD48uNKjvvoIr4PbLwGza.jpg', 0, '2026-01-18 13:40:05', '2026-01-18 13:40:05', NULL),
(3, 18, 'storage/uploads/product_gallery/CH71s15NuRfKyWliJTXGYaYO7tX6LOKLhQwSgX6k.jpg', 0, '2026-01-18 13:40:05', '2026-01-18 13:40:05', NULL),
(4, 16, 'uploads/product_gallery/RLairNgBc0W8ZCPh6zrG2QzYTbmoRsDib2sap7CV.jpg', 0, '2026-01-18 14:08:59', '2026-01-18 14:08:59', NULL),
(5, 16, 'uploads/product_gallery/mpCl2t7CMu0K7o9p8faT9CROemiOZiqlM56Tfllk.jpg', 0, '2026-01-18 14:08:59', '2026-01-18 14:08:59', NULL),
(6, 16, 'uploads/product_gallery/xSWZmNpy6OBVnBEg0dIAIQixA1udUesmEKQcLlq2.jpg', 0, '2026-01-18 14:08:59', '2026-01-18 14:08:59', NULL),
(7, 16, 'uploads/product_gallery/fiiLHFPE8QCPf8VTiuBIrhxja0upQPbZ252vktxx.jpg', 0, '2026-01-18 14:08:59', '2026-01-18 14:08:59', NULL),
(9, 17, 'uploads/product_gallery/sE5Eqs557t8hEhuw0LCcsn026EizEwkgzQIM4yCq.jpg', 0, '2026-01-19 02:02:30', '2026-01-19 02:02:30', NULL),
(10, 17, 'uploads/product_gallery/4e5z7gmG3HM3iHU9ScDJu2ZU0M8rxE13EwSflfAX.jpg', 0, '2026-01-19 02:02:30', '2026-01-19 02:02:30', NULL),
(11, 17, 'uploads/product_gallery/EMpSyJQSiSct0lYeZufk6nU6PmlfVLnqfn8kpEJw.jpg', 0, '2026-01-19 02:02:30', '2026-01-19 02:02:30', NULL),
(12, 19, 'uploads/product_gallery/FYd031kVzMO5TscglOMx5W6u3aAFyIyXJTuRUvll.jpg', 0, '2026-01-19 10:35:45', '2026-01-19 10:35:45', NULL),
(13, 19, 'uploads/product_gallery/F141Ls5gHjYmupRBPEOOlU551ol4mr5FACzeOZqN.jpg', 0, '2026-01-19 10:35:45', '2026-01-19 10:35:45', NULL),
(14, 19, 'uploads/product_gallery/gUGq1IC3Kbr5dRtMEG2FeJKQ7e2CY5XfVoCwWPnY.jpg', 0, '2026-01-19 10:35:45', '2026-01-19 10:35:45', NULL),
(15, 20, 'uploads/product_gallery/ofy9n6d8ZuuVqhxQIwhcTBiyH7f5X6iG901bTHIf.jpg', 0, '2026-01-22 07:55:52', '2026-01-22 07:55:52', NULL),
(16, 20, 'uploads/product_gallery/tm6D2nTFdl87inWHDVjrLUGhqMEIFU7EDtHouAn0.jpg', 0, '2026-01-22 07:55:52', '2026-01-22 07:55:52', NULL),
(17, 20, 'uploads/product_gallery/6S5nc8etIAG58qcBLIgB8fZIcSw4H6jLrmOHP3Be.jpg', 0, '2026-01-22 07:55:52', '2026-01-22 07:55:52', NULL),
(18, 20, 'uploads/product_gallery/aPGRnfKbDk67aaGjkFvaR1txLEZRotrkW5ykrQ8a.jpg', 0, '2026-01-22 07:55:52', '2026-01-22 07:55:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_skus`
--

CREATE TABLE `product_skus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `sku_code` varchar(255) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `market_price` decimal(15,2) DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_skus`
--

INSERT INTO `product_skus` (`id`, `product_id`, `sku_code`, `price`, `market_price`, `stock`, `image`, `is_default`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 19, 'IPHONE20PR-938-128', 2000.00, 2100.00, 4, NULL, 0, '2026-01-19 10:35:45', '2026-01-27 18:27:54', NULL),
(2, 19, 'IPHONE20PR-938-256', 2200.00, 2300.00, 1, NULL, 0, '2026-01-19 10:35:45', '2026-01-20 08:59:20', NULL),
(3, 19, 'IPHONE20PR-938-XAN-128', 2100.00, 2200.00, 3, NULL, 0, '2026-01-19 10:35:45', '2026-01-23 11:59:05', NULL),
(4, 19, 'IPHONE20PR-938-THA-512', 2500.00, 3000.00, 10, NULL, 0, '2026-01-19 10:55:51', '2026-01-19 10:55:51', NULL),
(5, 20, 'IPHONE21PR-699-64G', 200000.00, 220000.00, 0, NULL, 0, '2026-01-22 07:55:52', '2026-01-25 06:16:14', NULL),
(6, 20, 'IPHONE21PR-699-128', 250000.00, 300000.00, 3, NULL, 0, '2026-01-22 07:55:52', '2026-01-27 18:27:54', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rating` int(11) NOT NULL DEFAULT 1,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `customer_id`, `user_id`, `rating`, `comment`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 5, 11, NULL, 4, 'sản phẩm tốt sẽ quay lại ủng hộ shop', '2024-12-17 03:00:10', '2024-12-17 03:00:10', NULL),
(2, 7, 11, NULL, 5, 'điện thoại rất tốt tôi rất thích', '2024-12-17 06:54:32', '2024-12-17 06:54:32', NULL),
(3, 3, 11, NULL, 5, 'sản phẩm chất lượng tôi sẽ mua lại', '2025-01-09 21:43:00', '2025-01-09 21:43:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sent_emails`
--

CREATE TABLE `sent_emails` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sent_emails`
--

INSERT INTO `sent_emails` (`id`, `subject`, `message`, `sent_at`, `created_at`, `updated_at`) VALUES
(2, 'Xin chào quý khách', '<p>ch&agrave;o qu&yacute; kh&aacute;ch</p>', '2024-11-20 19:31:17', '2024-11-20 19:31:17', '2024-11-20 19:31:17'),
(3, 'sale cực sốc duy nhất trong ngày hôm nay', '<p>ồ yes</p>', '2024-12-12 08:44:49', '2024-12-12 08:44:49', '2024-12-12 08:44:49'),
(4, 'sale cực sốc giảm 20% từ ngày 12/12 đến 16/12', '<h2><strong>Săn h&agrave;ng xả kho đồng giảm gi&aacute; cực sốc giảm đến 70%</strong></h2>\r\n\r\n<p>Đồng giảm được xem l&agrave; một biện ph&aacute;p k&iacute;ch cầu của c&aacute;c nh&atilde;n h&agrave;ng để đ&aacute;nh mạnh hơn v&agrave;o thị trường. CellphoneS cũng vậy, để đẩy mạnh nhu cầu của người ti&ecirc;u d&ugrave;ng, hệ thống ph&acirc;n phối b&aacute;n lẻ h&agrave;ng đầu Việt Nam cung cấp đến người ti&ecirc;u d&ugrave;ng c&aacute;c chương tr&igrave;nh đồng giảm gi&aacute; tr&ecirc;n từng sản phẩm cực sock với gi&aacute; trị đồng giảm tối đa l&ecirc;n đến 70%.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img alt=\"đồng giảm\" src=\"https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/accessories/dong-giam_1.jpg\" /></p>\r\n\r\n<h3><strong>Điện thoại</strong></h3>\r\n\r\n<p>Những chiếc điện thoại mới nhất cập bến thị trường Việt Nam th&ocirc;ng qua &ldquo;cảng&rdquo; ph&acirc;n phối CellphoneS lu&ocirc;n được người ti&ecirc;u d&ugrave;ng ch&agrave;o đ&oacute;n bởi chất lượng sản phẩm ho&agrave;n hảo, chương tr&igrave;nh ưu đ&atilde;i cực phong ph&uacute; v&agrave; chế độ hậu m&atilde;i hấp dẫn.</p>\r\n\r\n<p><strong><em>Ngo&agrave;i những m&oacute;n h&agrave;ng điện thoại ngon bổ rẻ. Hiện nay, CellphoneS đang mở đại tiệc&nbsp;<a href=\"https://cellphones.com.vn/phu-kien-giam-gia\" target=\"_blank\" title=\"săn sale 12/12\">săn sale 12/12</a>&nbsp;d&agrave;nh ri&ecirc;ng cho phụ kiện. Nếu c&oacute; nhu cầu c&ugrave;ng t&igrave;m hiểu để sở hữu ngay những m&oacute;n đồ ch&iacute;nh h&atilde;ng ngay nh&eacute;!</em></strong></p>', '2024-12-12 09:21:59', '2024-12-12 09:21:59', '2024-12-12 09:21:59'),
(30, 'Săn hàng xả kho đồng giảm giá cực sốc giảm đến 70%', '<h2><strong>Săn h&agrave;ng xả kho đồng giảm gi&aacute; cực sốc giảm đến 70%</strong></h2>\r\n\r\n<p>Đồng giảm được xem l&agrave; một biện ph&aacute;p k&iacute;ch cầu của c&aacute;c nh&atilde;n h&agrave;ng để đ&aacute;nh mạnh hơn v&agrave;o thị trường. CellphoneS cũng vậy, để đẩy mạnh nhu cầu của người ti&ecirc;u d&ugrave;ng, hệ thống ph&acirc;n phối b&aacute;n lẻ h&agrave;ng đầu Việt Nam cung cấp đến người ti&ecirc;u d&ugrave;ng c&aacute;c chương tr&igrave;nh đồng giảm gi&aacute; tr&ecirc;n từng sản phẩm cực sock với gi&aacute; trị đồng giảm tối đa l&ecirc;n đến 70%.</p>\r\n\r\n<p><img alt=\"đồng giảm\" src=\"https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/accessories/dong-giam_1.jpg\" style=\"float:left\" /></p>', '2024-12-13 06:40:31', '2024-12-13 06:40:31', '2024-12-13 06:40:31'),
(31, 'Sale Cực Sốc - Giá Cực Bốc', '<p>L&agrave; trang b&aacute;n lẻ đồ ti&ecirc;u d&ugrave;ng H&agrave;n Quốc h&agrave;ng đầu tại Việt Nam, tự h&agrave;o l&agrave; nơi kh&aacute;ch h&agrave;ng c&oacute; thể t&igrave;m thấy những sản phẩm chất lượng c&ugrave;ng dịch vụ cao cấp. Với ti&ecirc;u&nbsp;...</p>', '2024-12-13 06:42:27', '2024-12-13 06:42:27', '2024-12-13 06:42:27');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_rates`
--

CREATE TABLE `shipping_rates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `province_id` varchar(255) NOT NULL,
  `district_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `fee` decimal(15,2) NOT NULL DEFAULT 30000.00,
  `min_order_free` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sku_values`
--

CREATE TABLE `sku_values` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_sku_id` bigint(20) UNSIGNED NOT NULL,
  `attribute_id` bigint(20) UNSIGNED NOT NULL,
  `attribute_value_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sku_values`
--

INSERT INTO `sku_values` (`id`, `product_sku_id`, `attribute_id`, `attribute_value_id`) VALUES
(1, 1, 2, 5),
(2, 1, 3, 10),
(3, 2, 2, 5),
(4, 2, 3, 11),
(5, 3, 2, 6),
(6, 3, 3, 10),
(7, 4, 2, 8),
(8, 4, 3, 12),
(9, 5, 2, 5),
(10, 5, 3, 9),
(11, 6, 2, 5),
(12, 6, 3, 10);

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `email`, `created_at`, `updated_at`) VALUES
(1, 'minhtit2004vkc@gmail.com', '2024-11-19 20:40:22', '2024-11-19 20:40:22'),
(3, 'minhpqph37702@fpt.edu.vn', '2024-11-21 10:38:28', '2024-11-21 10:38:28'),
(4, 'minh2005vkc@gmail.com', '2024-12-13 06:23:28', '2024-12-13 06:23:28');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_method` varchar(255) NOT NULL,
  `transaction_code` varchar(255) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `response_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response_data`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `role` enum('admin','staff','customer') NOT NULL DEFAULT 'customer',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `avatar`, `email`, `email_verified_at`, `role`, `is_active`, `password`, `remember_token`, `created_at`, `updated_at`, `password_reset_token`) VALUES
(7, 'admin Lifephone', 'avatars/QYa6X0Qpte0BTnyt6hFMrzFxB2KhreGCIvlr4eqW.jpg', 'minh2005vkc@gmail.com', NULL, 'admin', 1, '$2y$10$1fo8qOTiEiDTPa/hY7vF3eFoRdn9C0WEhj.txoEBTWztn0v7t7C5G', NULL, '2024-11-21 05:08:33', '2024-12-17 06:57:00', NULL),
(10, 'nhân viên chốt đơn', 'avatars/DH153iWB3La49NvsuXuUZzitKslik1TgVtRgFKgr.jpg', 'minhpqph37702@fpt.edu.vn', NULL, 'staff', 1, '$2y$12$0iE5k5InOuJLVIvoJIHCsOZD.ML1Qy8tnkaz1nMy1ig5Gd6ql6QNi', NULL, '2024-11-27 06:53:38', '2025-01-09 22:27:08', NULL),
(13, 'hainam', 'avatars/FPUiGBwaIE2rBhNjql6YhFvfeTYdDy1KPIDYvW3B.jpg', 'hainamkid@gmail.com', NULL, 'admin', 1, '$2y$10$Z.bm0B7XHX7qI0nbrUxbw.yfpgLoVdZ/lI12UUWzTdLf3jbR29.Ea', NULL, '2024-12-01 20:54:12', '2025-11-18 18:37:48', NULL),
(15, 'quangminh.io.vn', NULL, 'pk123.org@gmail.com', NULL, 'staff', 1, '$2y$12$FAvLcmVl.zZ/xs9qcgnzxuIi9NyKRFrhbJEguOiQ2Gw0OOpC1uLr6', NULL, '2024-12-02 02:34:32', '2024-12-02 02:34:32', NULL),
(18, 'duy tan', NULL, 'minh2003vkc@gmail.com', NULL, 'staff', 0, '$2y$12$wr3jcxOZj96rO4OH/ImvAeRqs4O.p0XZwupdQ6wl3TmOtJtwThGlm', NULL, '2024-12-15 07:43:49', '2025-11-04 03:31:23', NULL),
(19, 'nhân viên chốt đơn 003', 'avatars/kcsk3eOPcIyQjWaH7w4MwjWJrfxgg6RmMLLmBH2o.png', 'minhtit2002vkc@gmail.com', NULL, 'staff', 0, '$2y$12$QyJL6BYTiP4eF9ZbUdDeKOHEnVFdAsmc7HlKjhYxNhLdPuBDI1kEm', NULL, '2024-12-16 10:07:17', '2025-01-03 03:28:01', NULL),
(20, 'Minh Ngọc', 'avatars/iooq7PlBCUdqkRmnbwgaC8viDLwUl4nrwqriQnPr.jpg', 'namthph40654@fpt.edu.vn', NULL, 'staff', 1, '$2y$12$aydZKp.jhmSd5/dObo7gD.xxMnL8LLaL9dXexX6n2DOFTpx7r7BGi', NULL, '2025-11-19 18:40:58', '2025-11-19 18:40:58', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `scope` enum('order','shipping') NOT NULL DEFAULT 'order',
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `type` enum('percent','fixed') NOT NULL DEFAULT 'percent',
  `discount_percentage` decimal(8,2) DEFAULT NULL,
  `discount_amount_fixed` decimal(15,2) DEFAULT NULL,
  `max_discount_amount` decimal(15,2) DEFAULT NULL,
  `min_order_value` decimal(15,2) NOT NULL,
  `usage_limit` int(11) NOT NULL DEFAULT 0,
  `limit_per_user` int(11) NOT NULL DEFAULT 1,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vouchers`
--

INSERT INTO `vouchers` (`id`, `code`, `scope`, `description`, `image`, `type`, `discount_percentage`, `discount_amount_fixed`, `max_discount_amount`, `min_order_value`, `usage_limit`, `limit_per_user`, `start_date`, `end_date`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'TET2026', 'order', 'Giảm 50k từ 200k', 'http://lifephone-nam-blade-attribute.test/storage/uploads/vouchers/GelopNmBa6yidlY7uREDpFXGKSN7ssT1aVoLWrH1.jpg', 'percent', 10.00, 0.00, 20000.00, 100.00, 100, 20, '2026-01-23 19:03:00', '2026-01-30 02:11:00', '2026-01-24 12:13:01', '2026-01-27 12:42:38', NULL),
(2, 'FREESHIP2026', 'shipping', 'Giam ship', 'http://lifephone-nam-blade-attribute.test/storage/uploads/vouchers/gztFAwMKGr7sAwHykSPMCTAV3P3RhtrOmDyo0rPt.jpg', 'fixed', 0.00, 30000.00, 0.00, 1000.00, 100, 20, '2026-01-23 06:39:00', '2026-01-29 13:44:00', '2026-01-24 23:57:38', '2026-01-27 12:31:15', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `voucher_usages`
--

CREATE TABLE `voucher_usages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `voucher_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `voucher_usages`
--

INSERT INTO `voucher_usages` (`id`, `customer_id`, `order_id`, `used_at`, `voucher_id`, `created_at`, `updated_at`) VALUES
(1, 20, NULL, NULL, 1, '2026-01-25 00:14:46', '2026-01-25 00:14:46'),
(2, 20, NULL, NULL, 2, '2026-01-25 00:14:46', '2026-01-25 00:14:46'),
(3, 20, NULL, NULL, 1, '2026-01-25 06:16:59', '2026-01-25 06:16:59'),
(4, 20, NULL, NULL, 2, '2026-01-25 06:16:59', '2026-01-25 06:16:59'),
(5, 20, NULL, NULL, 1, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(6, 20, NULL, NULL, 2, '2026-01-25 06:24:44', '2026-01-25 06:24:44'),
(7, 20, NULL, NULL, 1, '2026-01-25 06:33:47', '2026-01-25 06:33:47'),
(8, 22, 132, '2026-01-27 16:13:09', 1, NULL, NULL),
(9, 22, 132, '2026-01-27 16:13:09', 2, NULL, NULL),
(10, 22, 133, '2026-01-27 16:49:27', 1, NULL, NULL),
(11, 22, 133, '2026-01-27 16:49:27', 2, NULL, NULL),
(12, 22, 134, '2026-01-27 17:08:34', 1, NULL, NULL),
(13, 22, 134, '2026-01-27 17:08:34', 2, NULL, NULL),
(14, 20, 135, '2026-01-27 18:27:54', 1, NULL, NULL),
(15, 20, 135, '2026-01-27 18:27:54', 2, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attributes_slug_unique` (`slug`);

--
-- Indexes for table `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attribute_values_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `brands_slug_unique` (`slug`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `carts_customer_id_foreign` (`customer_id`),
  ADD KEY `carts_product_id_foreign` (`product_id`),
  ADD KEY `carts_variant_id_foreign` (`variant_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category_news`
--
ALTER TABLE `category_news`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_news_slug_unique` (`slug`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_review_id_foreign` (`review_id`),
  ADD KEY `comments_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversations_userid_foreign` (`userId`),
  ADD KEY `conversations_customerid_foreign` (`customerId`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_email_unique` (`email`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `favorites_customer_id_product_id_unique` (`customer_id`,`product_id`),
  ADD KEY `favorites_product_id_foreign` (`product_id`);

--
-- Indexes for table `flash_sales`
--
ALTER TABLE `flash_sales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `flash_sale_items`
--
ALTER TABLE `flash_sale_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `flash_sale_items_flash_sale_id_product_sku_id_unique` (`flash_sale_id`,`product_sku_id`),
  ADD KEY `flash_sale_items_product_sku_id_foreign` (`product_sku_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_conversationid_foreign` (`conversationId`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `news_slug_unique` (`slug`),
  ADD KEY `news_author_id_foreign` (`author_id`),
  ADD KEY `news_category_news_id_foreign` (`category_news_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_voucher_id_foreign` (`voucher_id`),
  ADD KEY `orders_customer_id_foreign` (`customer_id`),
  ADD KEY `orders_staff_id_foreign` (`staff_id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`),
  ADD KEY `order_items_variant_id_foreign` (`variant_id`);

--
-- Indexes for table `order_notifications`
--
ALTER TABLE `order_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_notifications_order_id_foreign` (`order_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_category_id_foreign` (`category_id`),
  ADD KEY `products_brand_id_foreign` (`brand_id`),
  ADD KEY `products_min_price_index` (`min_price`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_images_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_skus_sku_code_unique` (`sku_code`),
  ADD KEY `product_skus_product_id_foreign` (`product_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reviews_product_id_foreign` (`product_id`),
  ADD KEY `reviews_user_id_foreign` (`user_id`),
  ADD KEY `reviews_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `sent_emails`
--
ALTER TABLE `sent_emails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shipping_rates`
--
ALTER TABLE `shipping_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipping_rates_province_id_index` (`province_id`),
  ADD KEY `shipping_rates_district_id_index` (`district_id`);

--
-- Indexes for table `sku_values`
--
ALTER TABLE `sku_values`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku_values_product_sku_id_attribute_id_unique` (`product_sku_id`,`attribute_id`),
  ADD KEY `sku_values_attribute_id_foreign` (`attribute_id`),
  ADD KEY `sku_values_attribute_value_id_foreign` (`attribute_value_id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subscriptions_email_unique` (`email`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_order_id_foreign` (`order_id`),
  ADD KEY `transactions_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vouchers_code_unique` (`code`);

--
-- Indexes for table `voucher_usages`
--
ALTER TABLE `voucher_usages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `voucher_usages_customer_id_foreign` (`customer_id`),
  ADD KEY `voucher_usages_voucher_id_foreign` (`voucher_id`),
  ADD KEY `voucher_usages_order_id_index` (`order_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attribute_values`
--
ALTER TABLE `attribute_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `category_news`
--
ALTER TABLE `category_news`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `flash_sales`
--
ALTER TABLE `flash_sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `flash_sale_items`
--
ALTER TABLE `flash_sale_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT for table `order_notifications`
--
ALTER TABLE `order_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `product_skus`
--
ALTER TABLE `product_skus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sent_emails`
--
ALTER TABLE `sent_emails`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `shipping_rates`
--
ALTER TABLE `shipping_rates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sku_values`
--
ALTER TABLE `sku_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `voucher_usages`
--
ALTER TABLE `voucher_usages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD CONSTRAINT `attribute_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carts_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carts_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `product_skus` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_customerid_foreign` FOREIGN KEY (`customerId`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `conversations_userid_foreign` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flash_sale_items`
--
ALTER TABLE `flash_sale_items`
  ADD CONSTRAINT `flash_sale_items_flash_sale_id_foreign` FOREIGN KEY (`flash_sale_id`) REFERENCES `flash_sales` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `flash_sale_items_product_sku_id_foreign` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_conversationid_foreign` FOREIGN KEY (`conversationId`) REFERENCES `conversations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `news_category_news_id_foreign` FOREIGN KEY (`category_news_id`) REFERENCES `category_news` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_voucher_id_foreign` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_variant_id_foreign_new` FOREIGN KEY (`variant_id`) REFERENCES `product_skus` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_notifications`
--
ALTER TABLE `order_notifications`
  ADD CONSTRAINT `order_notifications_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD CONSTRAINT `product_skus_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sku_values`
--
ALTER TABLE `sku_values`
  ADD CONSTRAINT `sku_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sku_values_attribute_value_id_foreign` FOREIGN KEY (`attribute_value_id`) REFERENCES `attribute_values` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sku_values_product_sku_id_foreign` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `voucher_usages`
--
ALTER TABLE `voucher_usages`
  ADD CONSTRAINT `voucher_usages_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `voucher_usages_voucher_id_foreign` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
