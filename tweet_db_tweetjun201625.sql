-- MySQL dump 10.13  Distrib 5.7.9, for Win32 (AMD64)
--
-- Host: localhost    Database: tweet_db
-- ------------------------------------------------------
-- Server version	5.5.48

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tweetjun201625`
--

DROP TABLE IF EXISTS `tweetjun201625`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tweetjun201625` (
  `row_names` text,
  `text` text,
  `favorited` tinyint(4) DEFAULT NULL,
  `favoriteCount` double DEFAULT NULL,
  `replyToSN` tinyint(4) DEFAULT NULL,
  `created` text,
  `truncated` tinyint(4) DEFAULT NULL,
  `replyToSID` tinyint(4) DEFAULT NULL,
  `id` text,
  `replyToUID` tinyint(4) DEFAULT NULL,
  `statusSource` text,
  `screenName` text,
  `retweetCount` double DEFAULT NULL,
  `isRetweet` tinyint(4) DEFAULT NULL,
  `retweeted` tinyint(4) DEFAULT NULL,
  `longitude` tinyint(4) DEFAULT NULL,
  `latitude` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tweetjun201625`
--

LOCK TABLES `tweetjun201625` WRITE;
/*!40000 ALTER TABLE `tweetjun201625` DISABLE KEYS */;
INSERT INTO `tweetjun201625` VALUES ('1','I can\'t stress this enough to people investing in metals. Hold the physical and make sure it\'s authentic #GoldPrice https://t.co/YX8fB4slPt',0,1,NULL,'2016-06-25 12:37:40',0,NULL,'746683780606328832',NULL,'<a href=\"https://mobile.twitter.com\" rel=\"nofollow\">Mobile Web (M5)</a>','Corpusmentis0',0,0,0,NULL,NULL),('2','How Far Can #GoldPrice Go? #GoldPrice #GoldPrice... https://t.co/pcLYrVihpG',0,0,NULL,'2016-06-25 12:15:13',0,NULL,'746678128706129922',NULL,'<a href=\"http://dlvr.it\" rel=\"nofollow\">dlvr.it</a>','uknewse',0,0,0,NULL,NULL);
/*!40000 ALTER TABLE `tweetjun201625` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-07-07 21:33:33
