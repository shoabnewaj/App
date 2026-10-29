-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: ychatapp
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ychatapp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ychatapp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ychatapp`;

--
-- Table structure for table `ads`
--

DROP TABLE IF EXISTS `ads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `creator_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `creator_id` (`creator_id`),
  CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ads`
--

LOCK TABLES `ads` WRITE;
/*!40000 ALTER TABLE `ads` DISABLE KEYS */;
INSERT INTO `ads` VALUES (3,'Learn Java Web Development','Master servlets, JSP, WebSockets, and database connectivity. Enroll today!','1777595584097_tropical-plant-transparent-background_1308-75855.avif','https://www.oracle.com/java/',1,'2026-06-05 17:36:05'),(4,'Premium Coffee Beans','100% organic Arabica coffee beans roasted locally. Free shipping on first order!','starbucks_coffee_ad.png','https://www.starbucks.com',3,'2026-06-05 17:36:05');
/*!40000 ALTER TABLE `ads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked_users`
--

DROP TABLE IF EXISTS `blocked_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocked_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `blocker_id` int NOT NULL,
  `blocked_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_block` (`blocker_id`,`blocked_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_users`
--

LOCK TABLES `blocked_users` WRITE;
/*!40000 ALTER TABLE `blocked_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_interactions`
--

DROP TABLE IF EXISTS `comment_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778808475 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_interactions`
--

LOCK TABLES `comment_interactions` WRITE;
/*!40000 ALTER TABLE `comment_interactions` DISABLE KEYS */;
INSERT INTO `comment_interactions` VALUES (1778758250,1778748106,1,'LOVE'),(1778808437,1778804714,1,'LIKE'),(1778808444,1779010293,2,'LIKE'),(1778808445,1779025982,3,'LIKE'),(1778808447,1779010293,3,'LOVE'),(1778808448,1,1,'LIKE'),(1778808451,1778804714,2,'LOVE'),(1778808453,1779069773,2,'LOVE'),(1778808461,1779077066,1,'LOVE'),(1778808466,1779157538,1,'LIKE'),(1778808467,1779161635,1,'LOVE'),(1778808468,1779166165,5,'CARE'),(1778808469,1779173469,2,'LIKE'),(1778808470,1779157538,2,'LOVE'),(1778808471,1779211597,2,'LIKE'),(1778808472,1779778980,1,'LIKE'),(1778808474,1783081740,1,'LOVE');
/*!40000 ALTER TABLE `comment_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `comment_text` text,
  `file_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1791776577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1779778989,100,2,'Wow, so beautiful! I want to visit Japan too!',NULL,'2026-06-05 17:36:05'),(1779778990,100,3,'Indeed! Spring is the best time to visit Fuji.',NULL,'2026-06-05 17:36:05'),(1779778991,101,1,'Love that apple! Looks so fresh!',NULL,'2026-06-05 17:36:05'),(1779778992,103,2,'Hanabi is spectacular! Wish I was there.',NULL,'2026-06-05 17:36:05'),(1783081740,265,1,'hello❤️','1783081740577_spectacular-flight-vivid-green-bird_191095-78393.avif','2026-07-03 12:29:00'),(1791776576,268,1,'Fff',NULL,'2026-10-12 03:42:56');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversation_archives`
--

DROP TABLE IF EXISTS `conversation_archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conversation_archives` (
  `user_name` varchar(100) NOT NULL,
  `partner_name` varchar(100) NOT NULL,
  `archived_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`,`partner_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversation_archives`
--

LOCK TABLES `conversation_archives` WRITE;
/*!40000 ALTER TABLE `conversation_archives` DISABLE KEYS */;
/*!40000 ALTER TABLE `conversation_archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creator_tips`
--

DROP TABLE IF EXISTS `creator_tips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creator_tips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `post_id` int DEFAULT NULL,
  `amount` double NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'COMPLETED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  CONSTRAINT `creator_tips_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `creator_tips_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creator_tips`
--

LOCK TABLES `creator_tips` WRITE;
/*!40000 ALTER TABLE `creator_tips` DISABLE KEYS */;
/*!40000 ALTER TABLE `creator_tips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_rsvps`
--

DROP TABLE IF EXISTS `event_rsvps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_rsvps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `user_id` int NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_id` (`event_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `event_rsvps_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `event_rsvps_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_rsvps`
--

LOCK TABLES `event_rsvps` WRITE;
/*!40000 ALTER TABLE `event_rsvps` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_rsvps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `event_date` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `followers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `follower_id` int NOT NULL,
  `following_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `follower_id` (`follower_id`,`following_id`),
  KEY `following_id` (`following_id`),
  CONSTRAINT `followers_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `followers_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
INSERT INTO `followers` VALUES (3,2,1,'2026-05-17 05:32:28'),(5,4,1,'2026-05-19 01:05:20'),(6,5,1,'2026-05-19 05:13:53'),(7,1,2,'2026-05-19 18:52:26'),(8,4,2,'2026-05-20 00:15:38'),(9,7,1,'2026-05-20 01:03:04'),(10,7,2,'2026-05-20 01:03:22'),(11,7,4,'2026-05-20 01:03:41'),(12,10,2,'2026-05-20 06:07:54'),(13,1,4,'2026-05-20 06:18:16'),(14,4,16,'2026-05-20 06:41:34'),(15,2,1000000,'2026-10-11 08:47:47');
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int DEFAULT NULL,
  `receiver_id` int DEFAULT NULL,
  `status` enum('PENDING','ACCEPTED','DECLINED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sender_id` (`sender_id`,`receiver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friendships`
--

DROP TABLE IF EXISTS `friendships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friendships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id1` int NOT NULL,
  `user_id2` int NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_friendship` (`user_id1`,`user_id2`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friendships`
--

LOCK TABLES `friendships` WRITE;
/*!40000 ALTER TABLE `friendships` DISABLE KEYS */;
INSERT INTO `friendships` VALUES (71,1,3,'ACCEPTED','2026-06-05 17:36:05'),(72,1,4,'ACCEPTED','2026-06-05 17:36:05'),(73,1,5,'ACCEPTED','2026-06-05 17:36:05'),(74,1,6,'ACCEPTED','2026-06-05 17:36:05'),(75,1,7,'ACCEPTED','2026-06-05 17:36:05'),(76,1,19,'ACCEPTED','2026-06-05 17:36:05'),(77,2,3,'ACCEPTED','2026-06-05 17:36:05'),(78,2,4,'ACCEPTED','2026-06-05 17:36:05'),(79,2,5,'ACCEPTED','2026-06-05 17:36:05'),(80,2,6,'ACCEPTED','2026-06-05 17:36:05'),(81,2,7,'ACCEPTED','2026-06-05 17:36:05'),(82,2,19,'ACCEPTED','2026-06-05 17:36:05'),(83,3,4,'ACCEPTED','2026-06-05 17:36:05'),(84,3,5,'ACCEPTED','2026-06-05 17:36:05'),(85,3,6,'ACCEPTED','2026-06-05 17:36:05'),(86,3,7,'ACCEPTED','2026-06-05 17:36:05'),(87,3,19,'ACCEPTED','2026-06-05 17:36:05'),(88,4,5,'ACCEPTED','2026-06-05 17:36:05'),(89,4,6,'ACCEPTED','2026-06-05 17:36:05'),(90,4,7,'ACCEPTED','2026-06-05 17:36:05'),(91,4,19,'ACCEPTED','2026-06-05 17:36:05'),(92,5,6,'ACCEPTED','2026-06-05 17:36:05'),(93,5,7,'ACCEPTED','2026-06-05 17:36:05'),(94,5,19,'ACCEPTED','2026-06-05 17:36:05'),(95,6,7,'ACCEPTED','2026-06-05 17:36:05'),(96,6,19,'ACCEPTED','2026-06-05 17:36:05'),(97,7,19,'ACCEPTED','2026-06-05 17:36:05'),(98,20,1,'ACCEPTED','2026-06-09 05:01:32'),(101,12,1,'ACCEPTED','2026-07-03 12:20:26'),(102,1,2,'ACCEPTED','2026-07-03 12:23:56'),(103,1,1000000,'ACCEPTED','2026-08-21 13:29:30'),(104,2,1000000,'PENDING','2026-10-11 08:47:44'),(105,1,1000005,'PENDING','2026-10-21 04:51:01');
/*!40000 ALTER TABLE `friendships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_members`
--

DROP TABLE IF EXISTS `group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_members` (
  `group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_members`
--

LOCK TABLES `group_members` WRITE;
/*!40000 ALTER TABLE `group_members` DISABLE KEYS */;
INSERT INTO `group_members` VALUES (1,1,'2026-06-05 17:36:05'),(1,2,'2026-06-05 17:36:05'),(1,3,'2026-06-05 17:36:05'),(1,4,'2026-06-05 17:36:05'),(1,5,'2026-06-05 17:36:05'),(1,6,'2026-06-05 17:36:05'),(1,7,'2026-06-05 17:36:05'),(1,19,'2026-06-05 17:36:05'),(2,1,'2026-06-05 17:36:05'),(2,2,'2026-06-05 17:36:05'),(2,3,'2026-06-05 17:36:05'),(2,4,'2026-06-05 17:36:05'),(2,5,'2026-06-05 17:36:05'),(2,6,'2026-06-05 17:36:05'),(2,7,'2026-06-05 17:36:05'),(2,19,'2026-06-05 17:36:05');
/*!40000 ALTER TABLE `group_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `creator_id` int NOT NULL,
  `cover_pic` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `creator_id` (`creator_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'Technology & Future','A group for tech enthusiasts and developers to discuss AI, WebSockets, and Java.',1,'1777594655453_nyc-skyline.png','2026-06-05 17:36:05'),(2,'Travel Club','Share your travel stories, photos, and recommendations.',3,'1777599760882_fuji.jpg','2026-06-05 17:36:05');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hidden_content`
--

DROP TABLE IF EXISTS `hidden_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hidden_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `item_type` varchar(20) NOT NULL,
  `item_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_item` (`user_id`,`item_type`,`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hidden_content`
--

LOCK TABLES `hidden_content` WRITE;
/*!40000 ALTER TABLE `hidden_content` DISABLE KEYS */;
INSERT INTO `hidden_content` VALUES (1,1,'POST',248,'2026-05-21 00:21:47'),(2,2,'POST',255,'2026-05-21 05:21:16'),(3,1,'POST',104,'2026-06-08 11:37:02'),(4,2,'POST',104,'2026-06-12 06:23:00');
/*!40000 ALTER TABLE `hidden_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `reaction_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'LIKE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_post_user_like` (`post_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketplace_items`
--

DROP TABLE IF EXISTS `marketplace_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marketplace_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `seller_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `marketplace_items_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketplace_items`
--

LOCK TABLES `marketplace_items` WRITE;
/*!40000 ALTER TABLE `marketplace_items` DISABLE KEYS */;
INSERT INTO `marketplace_items` VALUES (3,'Vintage Film Camera','Classic 35mm film camera in perfect working condition. Includes 50mm f/1.8 lens.',120.00,'1777595584097_tropical-plant-transparent-background_1308-75855.avif',1,'2026-06-05 17:36:05'),(4,'Noise Cancelling Headphones','Sony WH-1000XM4 in black. Gently used, comes with original carrying case and cables.',180.00,'1777594655453_nyc-skyline.png',3,'2026-06-05 17:36:05');
/*!40000 ALTER TABLE `marketplace_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` varchar(50) NOT NULL,
  `receiver_id` varchar(50) NOT NULL,
  `message_text` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) DEFAULT '0',
  `is_edited` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint(1) DEFAULT '0',
  `reply_to_id` int DEFAULT NULL,
  `reply_to_text` text,
  `file_url` varchar(500) DEFAULT NULL,
  `message_type` varchar(50) DEFAULT NULL,
  `reactions` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'rani','sakura','hi','2026-05-19 04:02:40',1,0,0,NULL,NULL,NULL,NULL,NULL),(2,'sakura','rani','hi','2026-05-19 04:07:05',1,0,0,NULL,NULL,NULL,NULL,NULL),(3,'higurashi','rani','hi','2026-05-19 04:07:09',1,0,0,NULL,NULL,NULL,NULL,NULL),(4,'higurashi','rani','hi','2026-05-19 04:07:15',1,0,0,NULL,NULL,NULL,NULL,NULL),(5,'higurashi','sakura','hi','2026-05-19 04:07:23',1,0,0,NULL,NULL,NULL,NULL,NULL),(6,'sakura','higurashi','hello','2026-05-19 04:07:32',0,0,0,NULL,NULL,NULL,NULL,NULL),(7,'higurashi','sakura','hi','2026-05-20 00:13:29',1,0,0,NULL,NULL,NULL,NULL,NULL),(8,'sakura','higurashi','ohayo gozai mas','2026-05-20 00:13:33',0,0,0,NULL,NULL,NULL,NULL,NULL),(9,'higurashi','sakura','[FILE:img/1779236021100_agent-smith-firing-his-gun.jpg]','2026-05-20 00:13:41',1,0,0,NULL,NULL,NULL,NULL,NULL),(10,'sakura','higurashi','[FILE:img/1779236031697_photo-png.avif]','2026-05-20 00:13:51',0,0,0,NULL,NULL,NULL,NULL,NULL),(11,'sakura','higurashi','😀Hello','2026-05-20 00:14:04',0,0,0,NULL,NULL,NULL,NULL,NULL),(12,'higurashi','sakura','😉','2026-05-20 00:14:04',1,0,0,NULL,NULL,NULL,NULL,NULL),(13,'sakura','rani','Reacted 👍 to your story','2026-05-20 00:15:11',1,0,0,NULL,NULL,NULL,NULL,NULL),(14,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:13',1,0,0,NULL,NULL,NULL,NULL,NULL),(15,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:13',1,0,0,NULL,NULL,NULL,NULL,NULL),(16,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:13',1,0,0,NULL,NULL,NULL,NULL,NULL),(17,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:14',1,0,0,NULL,NULL,NULL,NULL,NULL),(18,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:14',1,0,0,NULL,NULL,NULL,NULL,NULL),(19,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:14',1,0,0,NULL,NULL,NULL,NULL,NULL),(20,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:14',1,0,0,NULL,NULL,NULL,NULL,NULL),(21,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:14',1,0,0,NULL,NULL,NULL,NULL,NULL),(22,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:15',1,0,0,NULL,NULL,NULL,NULL,NULL),(23,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:15',1,0,0,NULL,NULL,NULL,NULL,NULL),(24,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(25,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(26,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(27,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(28,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(29,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(30,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(31,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(32,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(33,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(34,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(35,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:21',1,0,0,NULL,NULL,NULL,NULL,NULL),(36,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:21',1,0,0,NULL,NULL,NULL,NULL,NULL),(37,'sakura','rani','Reacted ❤️ to your story','2026-05-20 00:15:21',1,0,0,NULL,NULL,NULL,NULL,NULL),(38,'newaj','rani','[FILE:img/1779241691873_nyc-skyline.png]','2026-05-20 01:48:11',1,0,0,NULL,NULL,NULL,NULL,NULL),(39,'rani','newaj','[FILE:img/1779241704533_fuji-mountain-cherry-blossoms-spring-japan.jpg]','2026-05-20 01:48:24',0,0,0,NULL,NULL,NULL,NULL,NULL),(40,'rani','newaj','[FILE:img/1779241740134_chrome_proxy.exe]','2026-05-20 01:49:00',0,0,0,NULL,NULL,NULL,NULL,NULL),(41,'sakura','higurashi','hi','2026-05-20 06:11:01',0,0,0,NULL,NULL,NULL,NULL,NULL),(42,'sakura','higurashi','[FILE:img/1779257468095_fuji.jpg]','2026-05-20 06:11:08',0,0,0,NULL,NULL,NULL,NULL,NULL),(43,'新宿　太郎','higurashi','マトリックス新作出るんですかね？','2026-05-20 06:12:22',0,0,0,NULL,NULL,NULL,NULL,NULL),(44,'higurashi','sakura','😃','2026-05-20 06:13:31',1,0,0,NULL,NULL,NULL,NULL,NULL),(45,'sakura','rani','Reacted 👍 to your story','2026-05-20 06:14:00',1,0,0,NULL,NULL,NULL,NULL,NULL),(46,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:02',1,0,0,NULL,NULL,NULL,NULL,NULL),(47,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:02',1,0,0,NULL,NULL,NULL,NULL,NULL),(48,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:02',1,0,0,NULL,NULL,NULL,NULL,NULL),(49,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:06',1,0,0,NULL,NULL,NULL,NULL,NULL),(50,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:06',1,0,0,NULL,NULL,NULL,NULL,NULL),(51,'sakura','rani','Reacted 🥰 to your story','2026-05-20 06:14:06',1,0,0,NULL,NULL,NULL,NULL,NULL),(52,'sakura','rani','dd','2026-05-20 06:14:09',1,0,0,NULL,NULL,NULL,NULL,NULL),(53,'higurashi','harada','😄','2026-05-20 06:41:54',0,0,0,NULL,NULL,NULL,NULL,NULL),(54,'harada','higurashi','😄😄','2026-05-20 06:42:14',0,0,0,NULL,NULL,NULL,NULL,NULL),(55,'higurashi','harada','😄😄😄','2026-05-20 06:42:21',0,0,0,NULL,NULL,NULL,NULL,NULL),(56,'sakura','rani','[FILE:img/1779608194394_tropical-plant-transparent-background_1308-75855.avif]','2026-05-24 07:36:34',1,0,0,NULL,NULL,NULL,NULL,NULL),(58,'sakura','Gemini AI','amar app ti kemon holo?','2026-06-01 07:10:02',0,0,0,NULL,NULL,NULL,NULL,NULL),(59,'Gemini AI','sakura','Error: Gemini API Key is not configured. Please set the GEMINI_API_KEY environment variable or configure it in the gemini.properties file in the project root.','2026-06-01 07:10:02',0,0,0,NULL,NULL,NULL,NULL,NULL),(60,'sakura','Gemini AI','amar appti kemon holo?','2026-06-01 07:20:24',0,0,0,NULL,NULL,NULL,NULL,NULL),(61,'Gemini AI','sakura','Error calling Gemini API: Status Code 503\nDetails: {\n  \"error\": {\n    \"code\": 503,\n    \"message\": \"This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.\",\n    \"status\": \"UNAVAILABLE\"\n  }\n}\n','2026-06-01 07:20:30',0,0,0,NULL,NULL,NULL,NULL,NULL),(62,'sakura','Gemini AI','n8n ki?','2026-06-01 09:29:41',0,0,0,NULL,NULL,NULL,NULL,NULL),(63,'Gemini AI','sakura','n8n to **otwartoźródłowe narzędzie do automatyzacji przepływów pracy (workflow automation)**.\n\nPozwala łączyć różne aplikacje i serwisy (np. Slack, Google Sheets, CRM, bazy danych, API) oraz automatyzować zadania bez potrzeby pisania skomplikowanego kodu.\n\nDziała na zasadzie wizualnego budowania scenariuszy (workflowów) przy użyciu węzłów (nodes), które reprezentują konkretne akcje, wyzwalacze (triggers) lub integracje.\n\n**Kluczowe cechy n8n:**\n\n*   **Otwartoźródłowe:** Możesz hostować je na własnym serwerze (co daje większą kontrolę i prywatność) lub korzystać z wersji chmurowej (n8n Cloud).\n*   **Wizualny interfejs:** Umożliwia tworzenie złożonych automatyzacji poprzez przeciąganie i upuszczanie węzłów.\n*   **Wiele integracji:** Obsługuje setki popularnych aplikacji i usług.\n*   **Niskokodowe/Bezkodowe (Low-code/No-code):** Dostępne zarówno dla programistów, jak i osób bez zaawansowanej wiedzy technicznej. Programiści mogą również pisać własne węzły w JavaScript, co daje ogromną elastyczność.\n*   **Elastyczność:** Można je wykorzystać do automatyzacji niemal wszystkiego – od prostych powiadomień po złożone procesy biznesowe (np. synchronizacja danych, generowanie raportów, obsługa klientów).\n\nCzęsto porównuje się je do takich narzędzi jak Zapier czy Make (dawniej Integretomat), ale n8n oferuje większą elastyczność i możliwość hostowania na własnym serwerze, co bywa kluczowe dla wielu firm i deweloperów.\n\nPodsumowując, to potężne narzędzie do tworzenia inteligentnych i zautomatyzowanych procesów.','2026-06-01 09:29:49',0,0,0,NULL,NULL,NULL,NULL,NULL),(64,'sakura','Gemini AI','n8n ki ? shohoj vabe bujhiye daw','2026-06-01 11:19:34',0,0,0,NULL,NULL,NULL,NULL,NULL),(65,'Gemini AI','sakura','Error: Gemini API Key is not configured. Please set the GEMINI_API_KEY environment variable or configure it in the gemini.properties file in the project root.','2026-06-01 11:19:34',0,0,0,NULL,NULL,NULL,NULL,NULL),(66,'sakura','Gemini AI','n8n ki ?','2026-06-01 11:27:07',0,0,0,NULL,NULL,NULL,NULL,NULL),(67,'Gemini AI','sakura','Error calling Gemini API: Status Code 503\nDetails: {\n  \"error\": {\n    \"code\": 503,\n    \"message\": \"This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.\",\n    \"status\": \"UNAVAILABLE\"\n  }\n}\n','2026-06-01 11:27:09',0,0,0,NULL,NULL,NULL,NULL,NULL),(68,'sakura','Gemini AI','n8n ki?','2026-06-01 11:30:23',0,0,0,NULL,NULL,NULL,NULL,NULL),(69,'Gemini AI','sakura','n8n (উচ্চারণ \"এন-এইট-এন\") হলো একটি শক্তিশালী, ফ্রি এবং ওপেন-সোর্স ওয়ার্কফ্লো অটোমেশন টুল।\n\nসহজভাবে বলতে গেলে, এটি আপনাকে বিভিন্ন অ্যাপ্লিকেশন, সার্ভিস এবং API-কে (যেমন Google Sheets, Slack, Trello, ইমেইল, কাস্টম ডেটাবেস ইত্যাদি) একে অপরের সাথে কানেক্ট করে স্বয়ংক্রিয়ভাবে কাজ করানোর সুযোগ করে দেয়।\n\nএটার মূল কাজগুলো হলো:\n\n1.  **অ্যাপ্লিকেশন কানেক্ট করা**: আপনি n8n ব্যবহার করে বিভিন্ন সফটওয়্যার এবং অনলাইন সার্ভিসকে একসাথে যুক্ত করতে পারেন।\n2.  **ওয়ার্কফ্লো তৈরি করা**: এটি একটি ভিজ্যুয়াল ইন্টারফেস (ড্র্যাগ অ্যান্ড ড্রপ) ব্যবহার করে কাজ করে, যেখানে আপনি \"নোড\" (যা একটি নির্দিষ্ট কাজ বা অ্যাপ রিপ্রেজেন্ট করে) ব্যবহার করে একটি নির্দিষ্ট ধাপের পর আরেকটি ধাপকে সাজিয়ে একটি স্বয়ংক্রিয় কাজ বা \"ওয়ার্কফ্লো\" তৈরি করতে পারেন।\n3.  **কাজ স্বয়ংক্রিয় করা**: একবার ওয়ার্কফ্লো তৈরি হয়ে গেলে, এটি নির্দিষ্ট শর্ত পূরণ হলেই স্বয়ংক্রিয়ভাবে কাজ করা শুরু করে। যেমন, একটি নতুন ইমেইল আসলে স্বয়ংক্রিয়ভাবে একটি Google Sheet-এ ডেটা যোগ করা, অথবা একটি নতুন টাস্ক তৈরি হলে Slack-এ নোটিফিকেশন পাঠানো।\n\n**n8n-এর কিছু গুরুত্বপূর্ণ বৈশিষ্ট্য:**\n\n*   **ওপেন-সোর্স (Open-Source)**: এটি বিনামূল্যে ব্যবহার করা যায় এবং এর সোর্স কোড সবার জন্য উন্মুক্ত, তাই আপনি এটি কাস্টমাইজ করতে পারেন।\n*   **সেল্ফ-হোস্টেবল (Self-Hostable)**: আপনি আপনার নিজের সার্ভারে n8n ইন্সটল করতে পারেন, যার ফলে আপনার ডেটার উপর আপনার সম্পূর্ণ নিয়ন্ত্রণ থাকে এবং থার্ড-পার্টি সার্ভিসের উপর নির্ভরতা কমে।\n*   **লো-কোড/নো-কোড (Low-Code/No-Code)**: এর ভিজ্যুয়াল এডিটর ব্যবহার করে কোডিং জ্ঞান ছাড়াই বেশিরভাগ ওয়ার্কফ্লো তৈরি করা যায়। তবে চাইলে জাভাস্ক্রিপ্ট ব্যবহার করে কাস্টম লজিকও যোগ করা যায়।\n*   **বিস্তৃত ইন্টিগ্রেশন**: এটি শত শত অ্যাপ এবং সার্ভিসের সাথে কানেক্ট হতে পারে, এবং নতুন ইন্টিগ্রেশন তৈরি করাও বেশ সহজ।\n\nসংক্ষেপে, n8n আপনার প্রতিদিনের পুনরাবৃত্তিমূলক কাজগুলোকে স্বয়ংক্রিয় করে সময় এবং শ্রম বাঁচাতে সাহায্য করে। এটি অনেকটা আপনার জন্য একটি ডিজিটাল অ্যাসিস্ট্যান্টের মতো, যা বিভিন্ন অ্যাপের মধ্যে সেতু বন্ধন করে আপনার নির্দেশনা অনুযায়ী কাজ করে।','2026-06-01 11:30:30',0,0,0,NULL,NULL,NULL,NULL,NULL),(70,'sakura','Gemini AI','n8n は何ですか？','2026-06-01 11:31:01',0,0,0,NULL,NULL,NULL,NULL,NULL),(71,'Gemini AI','sakura','Error calling Gemini API: Status Code 503\nDetails: {\n  \"error\": {\n    \"code\": 503,\n    \"message\": \"This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.\",\n    \"status\": \"UNAVAILABLE\"\n  }\n}\n','2026-06-01 11:31:03',0,0,0,NULL,NULL,NULL,NULL,NULL),(72,'sakura','Gemini AI','n8nはなんですか？','2026-06-01 11:53:39',0,0,0,NULL,NULL,NULL,NULL,NULL),(73,'Gemini AI','sakura','n8n（エイトエヌ）は、オープンソースのワークフロー自動化ツールです。\n\n簡単に言うと、**様々なアプリケーション、サービス、APIを連携させて、タスクを自動化したり、データをやり取りしたりするためのツール**です。Zapier（ザピアー）やMake（旧Integromat）といったサービスに似ていますが、n8nには以下のような特徴があります。\n\n1.  **オープンソースであること**:\n    *   ソフトウェアのコードが公開されているため、透明性が高く、自由にカスタマイズしたり、コミュニティの貢献によって機能が改善されたりします。\n\n2.  **セルフホスト可能であること**:\n    *   自分のサーバーやクラウド環境にn8nをインストールして実行できます。これにより、データのプライバシーをより細かく管理できたり、長期的に見たコストを抑えられたりする可能性があります。もちろん、提供されているクラウドサービス版を利用することも可能です。\n\n3.  **視覚的なワークフローエディタ**:\n    *   ドラッグ＆ドロップで「ノード」（各アプリケーションや機能を表すブロック）をつなぎ合わせ、ワークフローを視覚的に構築できます。コードをほとんど書かずに（ローコード/ノーコード）、複雑な自動化を組むことができます。\n\n**具体的に何ができるの？**\n\n*   **データ連携**: 例えば、新しい顧客情報がCRMに追加されたら、自動的にマーケティングツールにも登録する。\n*   **通知の自動化**: 新しいメールが届いたら、SlackやDiscordに通知を送る。\n*   **SNS投稿の自動化**: ブログ記事が公開されたら、自動でTwitterやFacebookに投稿する。\n*   **データ処理と変換**: 複数のソースからデータを取得し、整形して別のシステムに送る。\n*   **定期的なタスクの実行**: 毎日特定の時間にレポートを生成し、メールで送信する。\n\n開発者だけでなく、ビジネスユーザーでも手軽に自動化を構築できるため、業務効率化に役立つ強力なツールとして注目されていますよ。','2026-06-01 11:53:47',0,0,0,NULL,NULL,NULL,NULL,NULL),(74,'sakura','rani','😍','2026-06-02 06:36:35',1,0,0,NULL,NULL,NULL,NULL,NULL),(75,'rani','sakura','😜🥰','2026-06-02 06:36:44',1,0,0,NULL,NULL,NULL,NULL,NULL),(76,'sakura','rani','😭','2026-06-11 04:44:23',1,0,0,NULL,NULL,NULL,NULL,NULL),(77,'rani','sakura','😢','2026-06-11 04:44:32',1,0,0,NULL,NULL,NULL,NULL,NULL),(78,'rani','sakura','img/1781153096811_voice_message.webm','2026-06-11 04:44:56',1,0,0,NULL,NULL,NULL,NULL,NULL),(79,'sakura','Gemini AI','amar app ta kemon holo?','2026-06-12 06:14:47',0,0,0,NULL,NULL,NULL,NULL,NULL),(80,'Gemini AI','sakura','আপনার অ্যাপটা কেমন হলো, সেটা তো আমি দেখতে বা ব্যবহার করতে পারছি না! আমি তো একটি AI, তাই কোনো অ্যাপ সরাসরি দেখে মতামত দেওয়া আমার পক্ষে সম্ভব নয়।\n\nতবে, আপনি যদি আমাকে আপনার অ্যাপ সম্পর্কে কিছু তথ্য দেন—যেমন:\n\n*   অ্যাপটি কী কাজ করে?\n*   এটার প্রধান বৈশিষ্ট্যগুলো কী কী?\n*   কারা এটা ব্যবহার করবে?\n*   এর ডিজাইন বা ইউজার ইন্টারফেস কেমন?\n\n...তাহলে আমি সেই তথ্যের ভিত্তিতে আপনাকে কিছু সাধারণ মতামত, পরামর্শ বা প্রশ্ন করতে পারি, যা আপনাকে আপনার অ্যাপের মূল্যায়ন করতে সাহায্য করবে।\n\nতো, আপনার অ্যাপ সম্পর্কে একটু বিস্তারিত বলবেন কি?','2026-06-12 06:14:51',0,0,0,NULL,NULL,NULL,NULL,NULL),(81,'Billie eilish ','sakura','.','2026-08-21 13:32:10',1,0,0,NULL,NULL,NULL,NULL,NULL),(82,'Billie eilish ','sakura','Hi','2026-08-21 13:32:20',1,0,0,NULL,NULL,NULL,NULL,NULL),(83,'sakura','Billie eilish','img/1787319244010_voice_1787319243941.webm','2026-08-21 13:34:04',0,0,0,NULL,NULL,NULL,NULL,NULL),(84,'Billie eilish ','sakura','Call jay','2026-08-21 13:37:22',1,0,0,NULL,NULL,NULL,NULL,NULL),(85,'sakura','Billie eilish','ki problem?','2026-08-21 13:39:03',0,0,0,NULL,NULL,NULL,NULL,NULL),(86,'sakura','Gemini AI','Translate the following into clear, fluent Bengali:\n','2026-09-21 09:56:06',0,0,0,NULL,NULL,NULL,NULL,NULL),(87,'Gemini AI','sakura','Error calling Gemini API: Status Code 400\nDetails: {\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"API key not valid. Please pass a valid API key.\",\n    \"status\": \"INVALID_ARGUMENT\",\n    \"details\": [\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.ErrorInfo\",\n        \"reason\": \"API_KEY_INVALID\",\n        \"domain\": \"googleapis.com\",\n        \"metadata\": {\n          \"service\": \"generativelanguage.googleapis.com\"\n        }\n      },\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.LocalizedMessage\",\n        \"locale\": \"en-US\",\n        \"message\": \"API key not valid. Please pass a valid API key.\"\n      }\n    ]\n  }\n}\n','2026-09-21 09:56:08',0,0,0,NULL,NULL,NULL,NULL,NULL),(88,'sakura','Gemini AI','api ki?','2026-09-21 09:56:35',0,0,0,NULL,NULL,NULL,NULL,NULL),(89,'Gemini AI','sakura','Error calling Gemini API: Status Code 400\nDetails: {\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"API key not valid. Please pass a valid API key.\",\n    \"status\": \"INVALID_ARGUMENT\",\n    \"details\": [\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.ErrorInfo\",\n        \"reason\": \"API_KEY_INVALID\",\n        \"domain\": \"googleapis.com\",\n        \"metadata\": {\n          \"service\": \"generativelanguage.googleapis.com\"\n        }\n      },\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.LocalizedMessage\",\n        \"locale\": \"en-US\",\n        \"message\": \"API key not valid. Please pass a valid API key.\"\n      }\n    ]\n  }\n}\n','2026-09-21 09:56:37',0,0,0,NULL,NULL,NULL,NULL,NULL),(90,'sakura','Gemini AI','hello','2026-09-21 10:05:31',0,0,0,NULL,NULL,NULL,NULL,NULL),(91,'Gemini AI','sakura','Error calling Gemini API: Status Code 400\nDetails: {\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"API key not valid. Please pass a valid API key.\",\n    \"status\": \"INVALID_ARGUMENT\",\n    \"details\": [\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.ErrorInfo\",\n        \"reason\": \"API_KEY_INVALID\",\n        \"domain\": \"googleapis.com\",\n        \"metadata\": {\n          \"service\": \"generativelanguage.googleapis.com\"\n        }\n      },\n      {\n        \"@type\": \"type.googleapis.com/google.rpc.LocalizedMessage\",\n        \"locale\": \"en-US\",\n        \"message\": \"API key not valid. Please pass a valid API key.\"\n      }\n    ]\n  }\n}\n','2026-09-21 10:05:32',0,0,0,NULL,NULL,NULL,NULL,NULL),(92,'sakura','Gemini AI','pet ki vabe komabo?','2026-09-21 10:10:55',0,0,0,NULL,NULL,NULL,NULL,NULL),(93,'sakura','Gemini AI','ki holo?','2026-09-21 10:25:44',0,0,0,NULL,NULL,NULL,NULL,NULL),(94,'rani','sakura','img/1790132326651_voice_1790132326670.webm','2026-09-23 02:58:46',1,0,0,NULL,NULL,NULL,NULL,NULL),(95,'sakura','minato','hello','2026-10-10 06:07:12',0,0,0,NULL,NULL,NULL,NULL,NULL),(96,'Billie eilish ','sakura','Koi','2026-10-10 14:33:23',1,0,0,NULL,NULL,NULL,NULL,NULL),(97,'sakura','Billie eilish ','কেমন আছো?','2026-10-10 14:36:19',1,0,0,NULL,NULL,NULL,NULL,NULL),(98,'sakura','Billie eilish ','এই আইডি তে কল করো','2026-10-11 08:29:04',1,0,0,NULL,NULL,NULL,NULL,NULL),(99,'Billie eilish ','sakura','Hi','2026-10-11 08:30:05',1,0,0,NULL,NULL,NULL,NULL,NULL),(100,'Billie eilish ','sakura','Hlw','2026-10-11 08:31:04',1,0,0,NULL,NULL,NULL,NULL,NULL),(101,'Billie eilish ','sakura','Ko','2026-10-11 08:31:17',1,0,0,NULL,NULL,NULL,NULL,NULL),(102,'Billie eilish ','sakura','Kotha sunina','2026-10-11 08:32:47',1,0,0,NULL,NULL,NULL,NULL,NULL),(103,'sakura','Billie eilish ','Video call koro','2026-10-11 08:33:12',1,0,0,NULL,NULL,NULL,NULL,NULL),(104,'sakura','Billie eilish ','img/1791707611841_voice_1791707611317.webm','2026-10-11 08:33:32',1,0,0,NULL,NULL,NULL,NULL,NULL),(105,'rani','Billie eilish','Hi','2026-10-11 08:48:18',0,0,0,NULL,NULL,NULL,NULL,NULL),(106,'sakura','Billie eilish ','Hello','2026-10-12 03:43:43',0,0,0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_preferences`
--

DROP TABLE IF EXISTS `notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_preferences` (
  `user_id` int NOT NULL,
  `category` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`,`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_preferences`
--

LOCK TABLES `notification_preferences` WRITE;
/*!40000 ALTER TABLE `notification_preferences` DISABLE KEYS */;
INSERT INTO `notification_preferences` VALUES (1,'friends',0),(1,'live',0),(1,'messages',1),(1,'posts',1);
/*!40000 ALTER TABLE `notification_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(30) DEFAULT 'GENERAL',
  `link` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,3,'? You posted something!',0,'2026-04-22 08:03:26','GENERAL',NULL),(2,3,'? You posted something!',0,'2026-04-22 08:07:03','GENERAL',NULL),(3,3,'sakura sent you a friend request!',0,'2026-04-24 00:04:18','GENERAL',NULL),(4,2,'rani accepted your friend request!',1,'2026-04-24 01:00:08','GENERAL',NULL),(5,2,'newaj sent you a friend request!',1,'2026-04-24 04:20:03','GENERAL',NULL),(6,3,'newaj sent you a friend request!',0,'2026-04-24 04:20:26','GENERAL',NULL),(7,1,'rani accepted your friend request!',1,'2026-04-24 04:21:00','GENERAL',NULL),(8,1,'sakura accepted your friend request!',1,'2026-04-24 04:21:36','GENERAL',NULL),(9,1,'? You posted something!',1,'2026-04-24 06:52:58','GENERAL',NULL),(10,1,'? You posted something!',1,'2026-04-24 06:53:25','GENERAL',NULL),(11,3,'? You posted something!',0,'2026-04-27 02:39:57','GENERAL',NULL),(12,2,'📝 You posted something!',1,'2026-04-28 08:49:26','GENERAL',NULL),(13,2,'📝 Post Published!',1,'2026-04-28 09:37:10','GENERAL',NULL),(14,2,'📝 Post Published!',1,'2026-04-28 09:37:31','GENERAL',NULL),(15,1,'rani commented on your post: \"👍hi\"',1,'2026-05-19 06:51:09','GENERAL',NULL),(16,1,'shah sent you a friend request.',1,'2026-05-19 08:00:33','GENERAL',NULL),(17,1,'Test unread notification',1,'2026-05-19 15:33:28','GENERAL',NULL),(18,1,'Test unread notification with emoji 👥',1,'2026-05-19 15:38:25','GENERAL',NULL),(19,4,'rani commented on your post: \"❤️hello\"',1,'2026-05-19 17:26:37','GENERAL',NULL),(20,1,'rani reacted with LIKE to your post: \"Goodbye \"',1,'2026-05-19 18:29:46','GENERAL',NULL),(21,1,'rani reacted with LIKE to your post: \"Goodbye \"',1,'2026-05-19 18:29:57','GENERAL',NULL),(22,6,'sakura accepted your friend request.',0,'2026-05-19 18:42:53','GENERAL',NULL),(23,2,'sakura reacted with LOVE to your post: \"Hanabi\"',1,'2026-05-19 18:48:55','GENERAL',NULL),(24,2,'sakura commented on your post: \"nice\"',1,'2026-05-19 18:49:05','GENERAL',NULL),(25,1,'higurashi reacted with LIKE to your post: \"sleepy\"',1,'2026-05-20 00:12:42','GENERAL',NULL),(26,1,'higurashi sent you a message: \"hi\"',1,'2026-05-20 00:13:29','GENERAL',NULL),(27,4,'sakura sent you a message: \"ohayo gozai mas\"',1,'2026-05-20 00:13:33','GENERAL',NULL),(28,1,'higurashi sent you an image',1,'2026-05-20 00:13:41','GENERAL',NULL),(29,4,'sakura sent you an image',1,'2026-05-20 00:13:51','GENERAL',NULL),(30,4,'sakura sent you a message: \"😀Hello\"',1,'2026-05-20 00:14:04','GENERAL',NULL),(31,1,'higurashi sent you a message: \"😉\"',1,'2026-05-20 00:14:04','GENERAL',NULL),(32,2,'sakura reacted to your story: 👍',1,'2026-05-20 00:15:11','GENERAL',NULL),(33,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:13','GENERAL',NULL),(34,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:13','GENERAL',NULL),(35,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(36,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(37,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(38,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(39,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(40,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:14','GENERAL',NULL),(41,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:15','GENERAL',NULL),(42,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:15','GENERAL',NULL),(43,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:19','GENERAL',NULL),(44,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:19','GENERAL',NULL),(45,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:19','GENERAL',NULL),(46,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:19','GENERAL',NULL),(47,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:19','GENERAL',NULL),(48,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(49,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(50,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(51,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(52,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(53,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:20','GENERAL',NULL),(54,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:21','GENERAL',NULL),(55,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:21','GENERAL',NULL),(56,2,'sakura reacted to your story: ❤️',1,'2026-05-20 00:15:21','GENERAL',NULL),(57,2,'higurashi reacted with LIKE to your post: \"Hanabi\"',1,'2026-05-20 00:15:31','GENERAL',NULL),(58,2,'higurashi reacted with LOVE to your post: \"Hanabi\"',1,'2026-05-20 00:15:32','GENERAL',NULL),(59,2,'higurashi reacted with HAHA to your post: \"Hanabi\"',1,'2026-05-20 00:15:33','GENERAL',NULL),(61,2,'newaj sent you a friend request.',1,'2026-05-20 01:03:20','GENERAL',NULL),(62,4,'newaj sent you a friend request.',1,'2026-05-20 01:03:39','GENERAL',NULL),(63,7,'sakura accepted your friend request.',1,'2026-05-20 01:04:26','GENERAL',NULL),(64,7,'rani accepted your friend request.',1,'2026-05-20 01:05:54','GENERAL',NULL),(65,2,'newaj sent you an image',1,'2026-05-20 01:48:11','GENERAL',NULL),(66,5,'rani sent you an image',1,'2026-05-20 01:48:24','GENERAL',NULL),(67,7,'rani sent you an image',1,'2026-05-20 01:48:24','GENERAL',NULL),(69,5,'rani sent you a file',1,'2026-05-20 01:49:00','GENERAL',NULL),(70,7,'rani sent you a file',1,'2026-05-20 01:49:00','GENERAL',NULL),(72,1,'testtest2 shared your post: \"sleepy\"',1,'2026-05-20 06:06:21','GENERAL',NULL),(73,1,'userA commented on your post: \"aa\"',1,'2026-05-20 06:09:26','GENERAL',NULL),(74,4,'sakura sent you a message: \"hi\"',1,'2026-05-20 06:11:01','GENERAL',NULL),(75,4,'sakura sent you an image',1,'2026-05-20 06:11:08','GENERAL',NULL),(76,10,'userA reacted with ANGRY to your post: \"Shared from sakura: ...\"',1,'2026-05-20 06:11:56','GENERAL',NULL),(77,4,'新宿　太郎 sent you a message: \"マトリックス新作出るんですかね？\"',1,'2026-05-20 06:12:22','GENERAL',NULL),(78,1,'higurashi sent you a message: \"😃\"',1,'2026-05-20 06:13:31','GENERAL',NULL),(79,2,'sakura reacted to your story: 👍',1,'2026-05-20 06:14:00','GENERAL',NULL),(80,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:02','GENERAL',NULL),(81,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:02','GENERAL',NULL),(82,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:02','GENERAL',NULL),(83,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:06','GENERAL',NULL),(84,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:06','GENERAL',NULL),(85,2,'sakura reacted to your story: 🥰',1,'2026-05-20 06:14:06','GENERAL',NULL),(86,2,'sakura replied to your story: \"dd\"',1,'2026-05-20 06:14:09','GENERAL',NULL),(87,1,'higurashi reacted with CARE to your post: \"Live Broadcast\"',1,'2026-05-20 06:14:49','GENERAL',NULL),(89,1,'newaj replied to your comment: \"@sakura hi👍\"',1,'2026-05-20 06:21:40','GENERAL',NULL),(90,7,'higurashi accepted your friend request.',1,'2026-05-20 06:35:55','GENERAL',NULL),(91,16,'higurashi sent you a friend request.',1,'2026-05-20 06:41:09','GENERAL',NULL),(92,16,'higurashi sent you a message: \"😄\"',1,'2026-05-20 06:41:54','GENERAL',NULL),(93,4,'harada accepted your friend request.',0,'2026-05-20 06:41:55','GENERAL',NULL),(94,4,'harada sent you a message: \"😄😄\"',0,'2026-05-20 06:42:14','GENERAL',NULL),(95,16,'higurashi sent you a message: \"😄😄😄\"',1,'2026-05-20 06:42:21','GENERAL',NULL),(96,2,'newaj reacted with CARE to your post: \"Hanabi\"',1,'2026-05-20 06:57:29','GENERAL',NULL),(97,12,'sakura accepted your friend request. [LINK:UsersProfileServlet?userName=sakura]',0,'2026-05-20 07:27:58','GENERAL',NULL),(98,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:21:09','GENERAL',NULL),(99,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:21:09','GENERAL',NULL),(100,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:21:09','GENERAL',NULL),(101,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:21:09','GENERAL',NULL),(102,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:21:09','GENERAL',NULL),(103,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:21:09','GENERAL',NULL),(104,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:25:44','GENERAL',NULL),(105,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:25:44','GENERAL',NULL),(106,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:25:44','GENERAL',NULL),(107,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:25:44','GENERAL',NULL),(108,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:25:44','GENERAL',NULL),(109,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:25:44','GENERAL',NULL),(110,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:32:42','GENERAL',NULL),(111,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:32:42','GENERAL',NULL),(112,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:32:42','GENERAL',NULL),(113,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:32:42','GENERAL',NULL),(114,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 00:32:42','GENERAL',NULL),(115,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 00:32:42','GENERAL',NULL),(116,1,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',1,'2026-05-21 00:45:05','GENERAL',NULL),(117,7,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',1,'2026-05-21 00:45:05','GENERAL',NULL),(118,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 01:58:25','GENERAL',NULL),(119,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 01:58:25','GENERAL',NULL),(120,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 01:58:25','GENERAL',NULL),(121,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 01:58:25','GENERAL',NULL),(122,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 01:58:25','GENERAL',NULL),(123,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 01:58:25','GENERAL',NULL),(124,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 03:43:42','GENERAL',NULL),(125,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 03:43:42','GENERAL',NULL),(126,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 03:43:42','GENERAL',NULL),(127,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 03:43:42','GENERAL',NULL),(128,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 03:43:42','GENERAL',NULL),(129,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 03:43:42','GENERAL',NULL),(130,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 04:00:48','GENERAL',NULL),(131,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 04:00:48','GENERAL',NULL),(132,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 04:00:48','GENERAL',NULL),(133,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 04:00:48','GENERAL',NULL),(134,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 04:00:48','GENERAL',NULL),(135,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 04:00:48','GENERAL',NULL),(136,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:20:18','GENERAL',NULL),(137,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:20:18','GENERAL',NULL),(138,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:20:18','GENERAL',NULL),(139,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:20:18','GENERAL',NULL),(140,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:20:18','GENERAL',NULL),(141,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:20:18','GENERAL',NULL),(142,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:28:14','GENERAL',NULL),(143,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:28:14','GENERAL',NULL),(144,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:28:14','GENERAL',NULL),(145,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:28:14','GENERAL',NULL),(146,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:28:14','GENERAL',NULL),(147,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:28:14','GENERAL',NULL),(148,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:39:41','GENERAL',NULL),(149,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:39:41','GENERAL',NULL),(150,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-21 05:39:41','GENERAL',NULL),(151,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:39:41','GENERAL',NULL),(152,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:39:41','GENERAL',NULL),(153,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-21 05:39:41','GENERAL',NULL),(154,1,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',1,'2026-05-21 05:41:49','GENERAL',NULL),(155,7,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',0,'2026-05-21 05:41:49','GENERAL',NULL),(156,1,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',1,'2026-05-21 05:48:13','GENERAL',NULL),(157,7,'rani is live now! [LINK:UsersPostServlet?watchLive=rani]',0,'2026-05-21 05:48:13','GENERAL',NULL),(158,2,'sakura reacted with LIKE to your post: \"Shared from rani: oh...\" [LINK:UsersPostServlet#post-card-208]',1,'2026-05-24 07:17:45','GENERAL',NULL),(159,2,'sakura reacted with LIKE to your post: \"Shared from rani: oh...\" [LINK:UsersPostServlet#post-card-208]',1,'2026-05-24 07:17:46','GENERAL',NULL),(160,2,'sakura sent you an image [LINK:messages.jsp?userName=sakura]',1,'2026-05-24 07:36:34','GENERAL',NULL),(161,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-25 06:01:43','GENERAL',NULL),(162,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-25 06:01:43','GENERAL',NULL),(163,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-25 06:01:43','GENERAL',NULL),(164,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-25 06:01:43','GENERAL',NULL),(165,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-25 06:01:43','GENERAL',NULL),(166,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-25 06:01:43','GENERAL',NULL),(167,16,'newaj reacted with LOVE to your post: \"みんなすごい\" [LINK:UsersPostServlet#post-card-248]',0,'2026-05-25 06:05:56','GENERAL',NULL),(168,2,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-26 07:01:25','GENERAL',NULL),(169,4,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-26 07:01:25','GENERAL',NULL),(170,5,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',1,'2026-05-26 07:01:25','GENERAL',NULL),(171,6,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-26 07:01:25','GENERAL',NULL),(172,7,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-26 07:01:25','GENERAL',NULL),(173,12,'sakura is live now! [LINK:UsersPostServlet?watchLive=sakura]',0,'2026-05-26 07:01:25','GENERAL',NULL),(175,20,'sakura accepted your friend request.',0,'2026-06-09 05:01:50','GENERAL',NULL),(178,1,'rani accepted your friend request.',1,'2026-06-12 06:16:34','GENERAL',NULL),(179,20,'sakura accepted your friend request.',0,'2026-06-30 04:52:23','GENERAL',NULL),(180,12,'sakura accepted your friend request.',0,'2026-07-03 12:20:26','GENERAL',NULL),(181,1,'You are now friends with userA! [MSG:userA]',1,'2026-07-03 12:20:26','GENERAL',NULL),(182,5,'sakura accepted your friend request.',0,'2026-07-03 12:20:32','GENERAL',NULL),(183,1,'You are now friends with Newaj! [MSG:Newaj]',1,'2026-07-03 12:20:32','GENERAL',NULL),(184,2,'sakura sent you a friend request.',1,'2026-07-03 12:23:56','GENERAL',NULL),(185,2,'sakura is live now: Live Broadcast',1,'2026-07-03 12:28:00','GENERAL',NULL),(186,4,'sakura is live now: Live Broadcast',0,'2026-07-03 12:28:00','GENERAL',NULL),(187,5,'sakura is live now: Live Broadcast',0,'2026-07-03 12:28:00','GENERAL',NULL),(188,7,'sakura is live now: Live Broadcast',0,'2026-07-03 12:28:00','GENERAL',NULL),(190,1,'Billie eilish  accepted your friend request.',1,'2026-08-21 13:30:50','GENERAL',NULL),(191,1000000,'You are now friends with sakura! [MSG:sakura]',0,'2026-08-21 13:30:50','GENERAL',NULL),(192,999999,'sakura: pet ki vabe komabo?',0,'2026-09-21 10:10:55','GENERAL',NULL),(193,999999,'sakura: ki holo?',0,'2026-09-21 10:25:44','GENERAL',NULL),(194,3,'sakura: hello',0,'2026-10-10 06:07:12','GENERAL',NULL),(195,1,'rani accepted your friend request.',1,'2026-10-10 06:07:56','GENERAL',NULL),(196,1000000,'sakura: এই আইডি তে কল করো',0,'2026-10-11 08:29:04','GENERAL',NULL),(197,1000000,'rani sent you a friend request.',0,'2026-10-11 08:47:44','GENERAL',NULL),(198,1000000,'sakura: Hello',0,'2026-10-12 03:43:43','GENERAL',NULL),(199,1000005,'sakura sent you a friend request.',0,'2026-10-21 04:51:01','GENERAL',NULL);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `amount` double NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `status` varchar(30) DEFAULT 'COMPLETED',
  `purpose` varchar(100) DEFAULT 'BLUE_TICK',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_options`
--

DROP TABLE IF EXISTS `poll_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `poll_options_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_options`
--

LOCK TABLES `poll_options` WRITE;
/*!40000 ALTER TABLE `poll_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `poll_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_votes`
--

DROP TABLE IF EXISTS `poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `option_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_vote` (`option_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `poll_votes_ibfk_1` FOREIGN KEY (`option_id`) REFERENCES `poll_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `poll_votes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_votes`
--

LOCK TABLES `poll_votes` WRITE;
/*!40000 ALTER TABLE `poll_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `poll_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `polls`
--

DROP TABLE IF EXISTS `polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int DEFAULT NULL,
  `question` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `polls`
--

LOCK TABLES `polls` WRITE;
/*!40000 ALTER TABLE `polls` DISABLE KEYS */;
/*!40000 ALTER TABLE `polls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_comments`
--

DROP TABLE IF EXISTS `post_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `comment_text` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `post_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_comments`
--

LOCK TABLES `post_comments` WRITE;
/*!40000 ALTER TABLE `post_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_drafts`
--

DROP TABLE IF EXISTS `post_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_drafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `feeling` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_post_drafts_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_drafts`
--

LOCK TABLES `post_drafts` WRITE;
/*!40000 ALTER TABLE `post_drafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_interactions`
--

DROP TABLE IF EXISTS `post_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `post_id` (`post_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `post_interactions_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_interactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_interactions`
--

LOCK TABLES `post_interactions` WRITE;
/*!40000 ALTER TABLE `post_interactions` DISABLE KEYS */;
INSERT INTO `post_interactions` VALUES (121,265,1,'CARE','2026-07-03 12:28:35'),(122,268,1,'LOVE','2026-07-16 11:59:21'),(132,280,1,'LOVE','2026-10-18 03:56:54');
/*!40000 ALTER TABLE `post_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_poll_options`
--

DROP TABLE IF EXISTS `post_poll_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_poll_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `poll_id` (`poll_id`),
  CONSTRAINT `post_poll_options_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `post_polls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_poll_options`
--

LOCK TABLES `post_poll_options` WRITE;
/*!40000 ALTER TABLE `post_poll_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_poll_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_poll_votes`
--

DROP TABLE IF EXISTS `post_poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_poll_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `option_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_post_poll_user` (`poll_id`,`user_id`),
  KEY `option_id` (`option_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `post_poll_votes_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `post_polls` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_poll_votes_ibfk_2` FOREIGN KEY (`option_id`) REFERENCES `post_poll_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_poll_votes_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_poll_votes`
--

LOCK TABLES `post_poll_votes` WRITE;
/*!40000 ALTER TABLE `post_poll_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_poll_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_polls`
--

DROP TABLE IF EXISTS `post_polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_polls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `question` varchar(500) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `post_id` (`post_id`),
  CONSTRAINT `post_polls_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_polls`
--

LOCK TABLES `post_polls` WRITE;
/*!40000 ALTER TABLE `post_polls` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_polls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_views`
--

DROP TABLE IF EXISTS `post_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_views` (
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `view_date` date NOT NULL,
  `viewed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`,`user_id`,`view_date`),
  KEY `idx_post_views_post` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_views`
--

LOCK TABLES `post_views` WRITE;
/*!40000 ALTER TABLE `post_views` DISABLE KEYS */;
INSERT INTO `post_views` VALUES (101,1,'2026-10-29','2026-10-29 10:11:01'),(102,1,'2026-10-29','2026-10-29 10:11:00'),(264,1,'2026-10-29','2026-10-29 10:11:00'),(276,1,'2026-10-29','2026-10-29 10:10:57');
/*!40000 ALTER TABLE `post_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `content` text,
  `file_name` varchar(255) DEFAULT NULL,
  `post_type` varchar(50) DEFAULT NULL,
  `feeling` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `share_count` int DEFAULT '0',
  `group_id` int DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `original_post_id` int DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `publish_status` varchar(20) NOT NULL DEFAULT 'PUBLISHED',
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (100,1,'Enjoying the beautiful cherry blossoms in Japan! 🌸 #Spring #Fuji','1779241704533_fuji-mountain-cherry-blossoms-spring-japan.jpg','image','happy','2026-06-05 17:36:05',0,NULL,713,NULL,NULL,'PUBLISHED'),(101,2,'Hello World! An apple a day keeps the doctor away. 🍎 Healthy life!','1779010244789_photo-png.avif','image','blessed','2026-06-05 17:36:05',0,NULL,708,NULL,NULL,'PUBLISHED'),(102,3,'Stunning view of the New York City skyline tonight! 🗽 #NYC #Travel','1777594655453_nyc-skyline.png','image','excited','2026-06-05 17:36:05',0,NULL,689,NULL,NULL,'PUBLISHED'),(103,5,'Watching the spectacular fireworks (Hanabi)! 🎆 Absolutely breathtaking.','1779215410927_IMG_0739.mov','REEL','amazing','2026-06-05 17:36:05',0,NULL,691,NULL,NULL,'PUBLISHED'),(104,19,'Testing out the new live streaming video feature! 🎥 Check it out.','1779165448413_live_video.webm','video','cool','2026-06-05 17:36:05',0,NULL,691,NULL,NULL,'PUBLISHED'),(264,5,'Just compiled our group project, everything is running smoothly!',NULL,'text',NULL,'2026-06-05 17:36:05',0,1,691,NULL,NULL,'PUBLISHED'),(265,1,'Here is the Fuji mountain view!','1777599760882_fuji.jpg','image',NULL,'2026-06-05 17:36:05',1,2,713,NULL,NULL,'PUBLISHED'),(268,1,'Shared from sakura: Here is the Fuji mountain view!','1777599760882_fuji.jpg','image',NULL,'2026-07-03 12:29:16',0,NULL,275,NULL,NULL,'PUBLISHED'),(275,1,'Hello World','1791802266415_nyc-skyline.png','image','','2026-10-12 10:51:06',0,NULL,0,NULL,NULL,'PUBLISHED'),(276,5,'Test post from automated verification',NULL,'original','Happy','2026-10-17 12:21:12',0,NULL,0,NULL,NULL,'PUBLISHED'),(277,1,NULL,NULL,'original',NULL,'2026-10-17 23:16:59',0,NULL,0,NULL,NULL,'PUBLISHED'),(278,1,NULL,NULL,'original',NULL,'2026-10-17 23:17:47',0,NULL,0,NULL,NULL,'PUBLISHED'),(279,1,'Live Broadcast by sakura',NULL,'video',NULL,'2026-10-17 23:17:48',0,NULL,0,NULL,NULL,'PUBLISHED'),(280,1,'heelo',NULL,'original','','2026-10-18 03:32:42',0,NULL,0,NULL,NULL,'PUBLISHED'),(281,1,NULL,NULL,'original',NULL,'2026-10-18 07:08:28',0,NULL,0,NULL,NULL,'PUBLISHED'),(282,1,'hello','1792922985648_image3.png','image','','2026-10-25 10:09:45',0,NULL,0,NULL,NULL,'PUBLISHED');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `replies`
--

DROP TABLE IF EXISTS `replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `text` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `replies`
--

LOCK TABLES `replies` WRITE;
/*!40000 ALTER TABLE `replies` DISABLE KEYS */;
INSERT INTO `replies` VALUES (1,1778804714,2,'hello','2026-05-15 00:42:21',NULL),(2,1778822479,1,'@sakura hi','2026-05-15 15:08:31',NULL),(3,1779010293,3,'@rani 😡','2026-05-17 14:10:28',NULL),(4,1779010293,1,'@minato  hello','2026-05-17 17:32:23',NULL),(5,1779147650,4,'@sakura k','2026-05-19 02:02:30',NULL),(6,1779173469,2,'@rani hi','2026-05-19 06:51:24',NULL),(7,1779257732,7,'@sakura hi👍','2026-05-20 06:21:40',NULL),(8,1779778980,1,'@sakura hello','2026-05-26 07:03:19',NULL),(9,1783081740,1,'@sakura hi','2026-07-03 12:29:39','1783081779958_nyc-skyline.png');
/*!40000 ALTER TABLE `replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply_interactions`
--

DROP TABLE IF EXISTS `reply_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply_interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reply_id` int NOT NULL,
  `user_id` int NOT NULL,
  `type` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_reply_user` (`reply_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply_interactions`
--

LOCK TABLES `reply_interactions` WRITE;
/*!40000 ALTER TABLE `reply_interactions` DISABLE KEYS */;
INSERT INTO `reply_interactions` VALUES (1,1,1,'LIKE','2026-05-15 02:46:48'),(6,4,1,'LIKE','2026-05-17 17:32:36'),(10,3,2,'LIKE','2026-05-18 00:09:51'),(13,7,7,'LIKE','2026-05-20 06:21:43'),(14,9,1,'CARE','2026-07-03 12:29:50');
/*!40000 ALTER TABLE `reply_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_posts`
--

DROP TABLE IF EXISTS `saved_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `post_id` int DEFAULT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_save` (`user_id`,`post_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `saved_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_posts_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_posts`
--

LOCK TABLES `saved_posts` WRITE;
/*!40000 ALTER TABLE `saved_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `saved_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `media_url` varchar(255) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `view_count` int DEFAULT '0',
  `audience` varchar(16) NOT NULL DEFAULT 'PUBLIC',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `stories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` VALUES (3,2,'1779211319898_att.0WO_H5Y3J_jKFoeowie98YOE-tqi7iyBV4SA8Ni1swY.mp4','Sweet ','2026-09-28 09:01:23',13,'PUBLIC'),(4,1,'1779778942752_tropical-plant-transparent-background_1308-75855.avif','Hello Story!','2026-09-28 09:01:23',0,'PUBLIC');
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_views`
--

DROP TABLE IF EXISTS `story_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `story_id` int NOT NULL,
  `viewer_id` int NOT NULL,
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_story_viewer` (`story_id`,`viewer_id`),
  KEY `viewer_id` (`viewer_id`),
  CONSTRAINT `story_views_ibfk_1` FOREIGN KEY (`story_id`) REFERENCES `stories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `story_views_ibfk_2` FOREIGN KEY (`viewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_views`
--

LOCK TABLES `story_views` WRITE;
/*!40000 ALTER TABLE `story_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `story_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_claims`
--

DROP TABLE IF EXISTS `user_claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_claims` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `claim_type` varchar(50) DEFAULT NULL,
  `description` text,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_claims_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_claims`
--

LOCK TABLES `user_claims` WRITE;
/*!40000 ALTER TABLE `user_claims` DISABLE KEYS */;
INSERT INTO `user_claims` VALUES (1,4,'a@a.a','POST_REPORT','Reported POST ID: 247\nReason: Nudity or Sexual Content\nAdditional Details: ','PENDING','2026-05-20 06:42:59');
/*!40000 ALTER TABLE `user_claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_posts_view`
--

DROP TABLE IF EXISTS `user_posts_view`;
/*!50001 DROP VIEW IF EXISTS `user_posts_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_posts_view` AS SELECT 
 1 AS `posts_id`,
 1 AS `name`,
 1 AS `users_id`,
 1 AS `profile_pic`,
 1 AS `content`,
 1 AS `file_name`,
 1 AS `post_type`,
 1 AS `feeling`,
 1 AS `created_at`,
 1 AS `share_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_relationships`
--

DROP TABLE IF EXISTS `user_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_relationships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int DEFAULT NULL,
  `receiver_id` int DEFAULT NULL,
  `type` enum('FOLLOW','FRIEND_REQUEST') DEFAULT NULL,
  `status` enum('PENDING','ACCEPTED','DECLINED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sender_id` (`sender_id`,`receiver_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_relationships`
--

LOCK TABLES `user_relationships` WRITE;
/*!40000 ALTER TABLE `user_relationships` DISABLE KEYS */;
INSERT INTO `user_relationships` VALUES (1,2,3,NULL,'ACCEPTED','2026-04-24 00:04:18'),(2,1,2,NULL,'ACCEPTED','2026-04-24 04:20:03'),(3,1,3,NULL,'ACCEPTED','2026-04-24 04:20:26');
/*!40000 ALTER TABLE `user_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `operating_system` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Current Location',
  `last_active` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_session` (`session_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
INSERT INTO `user_sessions` VALUES (1,1,'5B31E91404914B58772151A0FB8F162D','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 01:33:00','2026-10-17 01:33:00',1),(2,5,'1D260D65777D15B394BDAB227ADB6C8A','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 01:45:51','2026-10-17 01:45:51',1),(3,5,'641DF934240D59616C03BD1C2EF6726F','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 01:46:01','2026-10-17 01:46:01',1),(4,5,'3F219259EAD42A39FB26BB40955502D5','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 01:46:27','2026-10-17 01:46:27',1),(5,1,'2CBAB5E6A47EE9A464E11A9C3F103213','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 01:47:25','2026-10-17 01:47:25',1),(6,5,'8874593AD9AF5F78A8EE984578FC6F42','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 01:50:02','2026-10-17 01:50:02',1),(7,5,'667B7ACF597AB19B7169A7B8502F3611','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 01:53:56','2026-10-17 01:53:56',1),(8,5,'B86A4C4478A15F3239826A249765C8FB','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 02:06:16','2026-10-17 02:06:16',1),(9,1,'7783C4D0E27FDB5C4A44AA5C8486FFFC','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 02:07:30','2026-10-17 02:07:30',1),(10,1,'5C64195FD6AE3D7FA7554E4FD7F66880','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 02:08:08','2026-10-17 02:08:08',1),(11,5,'9E1029FE7860C0C795E7915B1234FC74','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 02:13:01','2026-10-17 02:13:01',1),(12,5,'3FC9F69315F15EB9B1581F9AE910CD9E','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 02:14:39','2026-10-17 02:14:39',1),(13,1,'9079563584B53520FDEDB644853D9693','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 03:18:13','2026-10-17 03:18:13',1),(14,1,'8D18EDD442A08464DF8B675C4AC45BEB','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 11:15:12','2026-10-17 11:15:12',1),(15,1,'612A2818D1F583792EAF4A8D95AA987F','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 11:15:12','2026-10-17 11:15:12',1),(16,5,'570AE5ADE454576A5AFCC3AE827A5A7A','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:13:29','2026-10-17 12:13:29',1),(17,5,'AA727F80DC635DE0ADAC8A0ACAD3E603','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:13:49','2026-10-17 12:13:49',1),(18,5,'3E11B0DA71B218AC6FE746FECAD48679','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:15:10','2026-10-17 12:15:10',1),(19,1,'EEAA93570005758BE10DF2EBC726F973','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 12:17:00','2026-10-17 12:17:00',1),(20,1,'D11BB7C39A0E469C108E2F4E8509EB48','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 12:17:00','2026-10-17 12:17:00',1),(21,5,'5F8FA6D7FB2755B2F6C63F409328AF2D','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:21:12','2026-10-17 12:21:12',1),(22,5,'828CA0A3F0BD865E132EAC165B67E872','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:21:35','2026-10-17 12:21:35',1),(23,1,'B0371058FC5B0053A9A0A34BC510F871','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-17 12:26:13','2026-10-17 12:26:13',1),(24,5,'B027C347172C094D1E9BE9590D99D1D5','172.18.0.1','Python-urllib/3.9','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-17 12:30:32','2026-10-17 12:30:32',1),(25,1,'5F79500E4495173753C1A605D33647F4','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 23:16:02','2026-10-17 23:16:02',1),(26,1,'8901A51286B9AD940C1055077E0B7DB0','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 23:16:02','2026-10-17 23:16:02',1),(27,1,'37D49ACB1D3B51539448988722EAE54D','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-17 23:16:28','2026-10-17 23:16:28',1),(28,1,'BA5692944DE4FEB4D6049CF21CC6FFA7','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-18 03:31:58','2026-10-18 03:31:58',1),(29,1,'1E56C9D5E3BF3D084BED84EF328E9EEF','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-18 03:32:28','2026-10-18 03:32:28',1),(30,1,'017B31E7139EC04FB3ADA86488E9ABC5','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-18 06:45:42','2026-10-18 06:45:42',1),(31,1,'F888BBF6E71A937CD968C106D2256826','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-21 04:49:15','2026-10-21 04:49:15',1),(32,1,'9B71D6494CA9657C57F2B7E3C6566015','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-25 05:48:47','2026-10-25 05:48:47',1),(33,1,'9E1D44C25DE479209B61543784F7C8AF','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-25 09:23:38','2026-10-25 09:23:38',1),(34,1,'7D4300349C4D20968CA817A6FD6D2403','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-25 10:05:37','2026-10-25 10:05:37',1),(35,1,'A78629D436BCCD723B228420578E2627','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-25 10:31:19','2026-10-25 10:31:19',1),(36,1,'72DA2E2F628E9F578800C531887C3DC9','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-25 14:09:34','2026-10-25 14:09:34',1),(37,1,'30CE04B117440121DD3A2071D756D577','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-25 14:09:34','2026-10-25 14:09:34',1),(38,1,'CE6B040979781645F2F75EAB67BCF3BB','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-25 14:10:04','2026-10-25 14:10:04',1),(39,1,'5A47944FCB63AEEF9397E3AC89033220','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-26 07:51:22','2026-10-26 07:51:22',1),(40,1,'6B2E1AABF0224470113A5807CE5AAEB2','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-26 07:51:22','2026-10-26 07:51:22',1),(41,1,'76D6C278B7D6C527835A575AB3EC349C','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-27 01:41:53','2026-10-27 01:41:53',1),(42,1,'8AD81969F33E0D824F46B27C46E21779','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-27 01:41:53','2026-10-27 01:41:53',1),(43,1,'6AABE616BE45FF8E5702C0DCC6507B97','172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Desktop / Laptop','Google Chrome','Windows','Active Session','2026-10-27 11:03:48','2026-10-27 11:03:48',1),(44,1,'7BE28546FFE4500F879C2E82DE6B1FAF','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-28 06:06:20','2026-10-28 06:06:20',1),(45,1,'4E371F2EAAB9BE542A92A500616F16A1','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-28 06:06:20','2026-10-28 06:06:20',1),(46,1,'991A660FF0F7F4A18042D7E93DE5D940','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 09:42:55','2026-10-29 09:42:55',1),(47,1,'B0A7A562649E6A5F6416C072884FCD24','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 09:42:55','2026-10-29 09:42:55',1),(48,1,'1E09018ECF32DF13F70CF8BCD3F7A58F','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 10:02:07','2026-10-29 10:02:07',1),(49,1,'E34930785E96AA036B898CF977DC1F7F','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 10:02:07','2026-10-29 10:02:07',1),(50,1,'76A821962FEA7AC520C1D995BDDCD399','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 10:03:34','2026-10-29 10:03:34',1),(51,1,'2B4BFF9015C21806A6D57A5AD54C500E','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-29 10:19:19','2026-10-29 10:19:19',1),(52,1,'9A7EAA7711EA4D43384FE3054405A923','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-29 10:23:59','2026-10-29 10:23:59',1),(53,1,'8B5D2E49A0F1894BD66CF581B7C314CA','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 10:25:32','2026-10-29 10:25:32',1),(54,1,'56044F25C11AFD3B7913674FB4695803','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0.1 Mobile/15E148 Safari/604.1','Mobile','Apple Safari','macOS','Active Session','2026-10-29 10:25:32','2026-10-29 10:25:32',1),(55,1,'69EEA624FF43DA34A9EF3C1DF564E924','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-29 10:27:27','2026-10-29 10:27:27',1),(56,1,'0A6258D9F33D250C088150DA4E0AB10E','172.18.0.1','curl/8.21.0','Desktop / Laptop','Browser','Operating System','Active Session','2026-10-29 10:32:41','2026-10-29 10:32:41',1),(57,2,'FA17A0219C924592A626C0BCED0A7FE9','172.18.0.1','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/22H374 [FBAN/FBIOS;FBAV/584.0.0.33.109;FBBV/1093507478;FBDV/iPhone11,8;FBMD/iPhone;FBSN/iOS;FBSV/18.7.10;FBSS/2;FBCR/;FBID/phone;FBLC/en_JP;FBOP/80','Mobile','Browser','macOS','Active Session','2026-10-29 11:58:12','2026-10-29 11:58:12',1);
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `temp` varchar(255) DEFAULT NULL,
  `cover_pic` varchar(255) DEFAULT NULL,
  `bio` text,
  `phone` varchar(20) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `hometown` varchar(100) DEFAULT NULL,
  `current_city` varchar(100) DEFAULT NULL,
  `workplace` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `relationship_status` varchar(30) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` bigint DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'USER',
  `is_banned` tinyint(1) NOT NULL DEFAULT '0',
  `is_restricted` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_enabled` tinyint(1) DEFAULT '0',
  `is_verified` tinyint(1) DEFAULT '0',
  `balance` double DEFAULT '100',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1000007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sakura@xxx.jp','$2a$10$UMyOq6XrymYW4RMzgs59TOmNXby9DwC9vtXF4zhvN57BFnZ9ZKk7O','sakura','1791802028707_tropical-plant-transparent-background_1308-75855.avif',NULL,'1791802014326_fuji.jpg','','',NULL,'Female','','','','','','',NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(2,'rani@xxx.jp','$2a$10$5dyIxFwKBaHkSZKUtC974eV5FsQzjg3CC43A19zqFGysFvbYeMURu','rani','1791805358127_IMG_5009.jpeg',NULL,'1793275307423_IMG_3443.jpeg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(3,'minato@xxx.jp','$2a$10$pm6JG/qzyIvco2ePO29/u.1xNVSiXhgQvzoNEa98hfFgF/qUobsNK','minato','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(4,'a@a.a','$2a$10$ElMq2JAI4XA82vOInQXoEebPFs5aTR/tE7shwDqJE9s6CDRBmusGC','higurashi','1776301732288Ayabe.jpg',NULL,'1779236318539_images (3).jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(5,'shoabnewaj81@gmail.com','$2a$10$SFrbazxVlXg/FY8b5l0Qn.C48uifUP3V.ckdi4fzDoNfTMvl6K63q','Newaj','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'60133164-abf6-4225-8b63-dd90dd224aeb',1781091448164,NULL,NULL,'ADMIN',0,0,0,0,100),(6,'shah@xxx.jp','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','shah','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(7,'newaj@xxx.jp','$2a$10$1w/b6QF.xufhbJiJguAqMeCq6/bfcCLY3AOpohhlX1./LuRZfzLK6','newaj','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ADMIN',0,0,0,0,100),(10,'testtest222222@gmail.com','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','testtest2','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(11,'user001@sample.jp','vZN0c+RsJRFhyRrAqO8CbwKZwqSgs9hHKvvsNiiC66g=','ootake','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(12,'aaa5@xxx.jp','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','userA','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(13,'shinjuku@xxx.jp','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','新宿　太郎','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(14,'test1@test.com','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','K.O.','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(15,'aaa@xxx.jp','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','aaaa','1776748273083Ayabe.jpg',NULL,'1779258260386_fuji.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(16,'hara@xxx.jp',NULL,'harada','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(18,'bagha@xxx.jp','$2a$10$BvZPh1HwbNxSliinJWxWoO8BOuWul3FTlJYn4Pm.pMAfMIuKN0YAe','bagha','1776748273083Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(19,'tester@xxx.jp','A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=','Tester User','1776301732288Ayabe.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(20,'behestee@gmail.com','$2a$10$YVc/BE9M5ntJxGZbkn3Ixu/xbOVOf.19Cbx3o3NcDAMXjJvpphDzK','Behestee','default.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(23,'test_unique_1781068308191@test.com','testpass','Test User','default.png',NULL,NULL,NULL,NULL,NULL,'Male','Bangladesh','Dhaka',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(24,'test_flow_1781068385219@test.com','$2a$10$l0zVvJuIjFNGBv2Bmpx/WeB7S/1sLbOT6DMg187ipV2s.yyQkYZsa','Flow Test User','default.png',NULL,NULL,NULL,NULL,NULL,'Male','Bangladesh','Dhaka',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(26,'qqqq@xxx.jp','$2a$10$dPEHZp8s3Re/BiOK9VVJvOmLYEpcLVm7WUbM1bzgFdhoLAbCSlKZ2','qqqq','1781068660676_photo-png.avif',NULL,NULL,NULL,NULL,NULL,'Female','Japan','Tokyo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(999999,'gemini@ai.com','dummy_password','Gemini AI','gemini.png',NULL,NULL,'Google DeepMind\'s Gemini AI Assistant.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(1000000,'afsarazaman8@gmail.com','$2a$10$XmTsvKJefo8lr0VRO4Nm8O52t64K3b9s/Pi21C9EsAAedbx4yGrSi','Billie eilish ','default.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(1000001,'test_unique_1788392329268@test.com','testpass','Test User','default.png',NULL,NULL,NULL,NULL,NULL,'Male','Bangladesh','Dhaka',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(1000002,'test_unique_1788479617132@test.com','testpass','Test User','default.png',NULL,NULL,NULL,NULL,NULL,'Male','Bangladesh','Dhaka',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(1000003,'sanada@xxx.jp','$2a$10$8NJoowp1yh2zwLB.jr5hOemWKlDxbLkli0zCFmKlh7I/p1yzaW53W','sanada','1790220540704_image_280d1e07.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,0,100),(1000005,'admin@gmail.com','$2a$10$HxeyrQIdF6mvDcJDrxjc8.EzKkijKGQ9FjNBnAGyiZjs2bEPmB3yi','Admin','default.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ADMIN',0,0,0,0,100);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `ychatapp`
--

USE `ychatapp`;

--
-- Final view structure for view `user_posts_view`
--

/*!50001 DROP VIEW IF EXISTS `user_posts_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp932 */;
/*!50001 SET character_set_results     = cp932 */;
/*!50001 SET collation_connection      = cp932_japanese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_posts_view` AS select `p`.`id` AS `posts_id`,`u`.`name` AS `name`,`u`.`id` AS `users_id`,`u`.`profile_pic` AS `profile_pic`,`p`.`content` AS `content`,`p`.`file_name` AS `file_name`,`p`.`post_type` AS `post_type`,`p`.`feeling` AS `feeling`,`p`.`created_at` AS `created_at`,`p`.`share_count` AS `share_count` from (`posts` `p` join `users` `u` on((`p`.`user_id` = `u`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-29 12:10:57
