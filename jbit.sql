-- MySQL dump 10.13  Distrib 5.7.18, for Win64 (x86_64)
--
-- Host: localhost    Database: jbit
-- ------------------------------------------------------
-- Server version	5.7.18-enterprise-commercial-advanced-log

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

DROP DATABASE IF EXISTS `jbit`;
CREATE DATABASE `jbit`;
USE `jbit`;

CREATE USER IF NOT EXISTS 'jbit'@'%' IDENTIFIED BY 'jbit';
GRANT DELETE,EXECUTE,INSERT,SELECT,TRIGGER,UPDATE ON `jbit`.* TO 'jbit'@'%' IDENTIFIED BY 'jbit';
FLUSH PRIVILEGES;


--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `account` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `login` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`),
  UNIQUE KEY `account_UNIQUE` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room` (
  `p1` varchar(15) NOT NULL,
  `p2` varchar(15) DEFAULT NULL,
  `p3` varchar(15) DEFAULT NULL,
  `p4` varchar(15) DEFAULT NULL,
  `music` varchar(100) DEFAULT NULL,
  `mucicID` varchar(20) DEFAULT NULL,
  `play` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`p1`),
  UNIQUE KEY `p1_UNIQUE` (`p1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'jbit'
--
/*!50003 DROP FUNCTION IF EXISTS `JoinRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`jbit`@`%` FUNCTION `JoinRoom`( leader varchar(15) , player varchar(15) ) RETURNS varchar(30) CHARSET utf8
BEGIN
	DECLARE player1 varchar(15);
	DECLARE player2 varchar(15);
	DECLARE player3 varchar(15);
	DECLARE player4 varchar(15);    
	DECLARE p int;
    select p1,p2,p3,p4,play into player1,player2,player3,player4,p from room where p1=leader;
    if( player1 is null ) then
		return '房間不存在';        
    elseif( p = 1 ) then
		return '此房間已開始遊戲';
	elseif( player2 is null ) then
		update room set p2=player where p1=leader;
    elseif( player3 is null ) then
		update room set p3=player where p1=leader;
    elseif( player4 is null ) then
		update room set p4=player where p1=leader;
	else
		return '房間人數已滿';
	end if;
	return 'Success';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `LeaveRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`jbit`@`%` FUNCTION `LeaveRoom`( leader varchar(15) , player varchar(15) ) RETURNS varchar(30) CHARSET utf8
BEGIN
	DECLARE player1 varchar(15);
	DECLARE player2 varchar(15);
	DECLARE player3 varchar(15);
	DECLARE player4 varchar(15);
    select p1,p2,p3,p4 into player1,player2,player3,player4 from room where p1=leader;
    if( player1 is null ) then
		return 'Success';
	elseif( player1 = player and player2 is null ) then
		delete from room where p1=leader;        
	elseif( player1 = player and player2 is not null ) then
		update room set p1=player2 , p2=player3 , p3 = player4 , p4 = null where p1=leader;
	elseif( player2 = player ) then
		update room set p2=player3 , p3 = player4 , p4 = null where p1=leader;
	elseif( player3 = player ) then
		update room set p3 = player4 , p4 = null where p1=leader;
	elseif( player4 = player ) then
		update room set p4 = null where p1=leader;
	else
		return '找不到玩家';
	end if;
	return 'Success';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-19 14:26:22
