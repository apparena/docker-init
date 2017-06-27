/*
SQLyog Ultimate v12.4.2 (64 bit)
MySQL - 5.7.16-log : Database - contest_v34_stage
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`contest` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `contest`;

/*Table structure for table `app_config` */

DROP TABLE IF EXISTS `app_config`;

CREATE TABLE `app_config` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL,
  `config_key` varchar(50) DEFAULT NULL,
  `config_value` varchar(500) NOT NULL DEFAULT '',
  `config_meta` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `cache` */

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appId` int(10) NOT NULL,
  `name` char(30) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `error` */

DROP TABLE IF EXISTS `error`;

CREATE TABLE `error` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `content` text,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `item_aggregations` */

DROP TABLE IF EXISTS `item_aggregations`;

CREATE TABLE `item_aggregations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `item_id` int(10) NOT NULL COMMENT 'The voted item',
  `type` varchar(16) NOT NULL COMMENT 'Aggregation type',
  `title` varchar(32) NOT NULL COMMENT 'title of the attribute',
  `value` double NOT NULL DEFAULT '0' COMMENT 'Aggregated value of the attribute',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `item_aggregations_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Table structure for table `item_types` */

DROP TABLE IF EXISTS `item_types`;

CREATE TABLE `item_types` (
  `item_type_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the item type',
  `item_type` varchar(32) NOT NULL COMMENT 'Available item types for the contest',
  `og_object` varchar(32) DEFAULT NULL COMMENT 'Facebook Open Graph object type',
  `og_action_upload` varchar(32) DEFAULT 'upload' COMMENT 'Facebook Open Graph action when uploading/creating this item',
  `og_action_vote` varchar(32) DEFAULT 'vote' COMMENT 'Facebook Open Graph action when voting for this item',
  PRIMARY KEY (`item_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `items` */

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Item ID',
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `uid` int(11) NOT NULL COMMENT 'User ID',
  `title` text NOT NULL COMMENT 'Item title',
  `description` text COMMENT 'Item description',
  `item_type_id` int(11) NOT NULL COMMENT 'Item type ID',
  `vote_value` float DEFAULT NULL COMMENT 'Vote value',
  `view_count` int(10) NOT NULL DEFAULT '0',
  `meta_data` text NOT NULL COMMENT 'JSON array for item attributes',
  `task_id` int(10) NOT NULL DEFAULT '0',
  `ip` char(30) NOT NULL COMMENT 'IP address of the user who created that item',
  `ip_hash` char(32) DEFAULT NULL COMMENT 'MD5 hashed IP Address of the user who created that item',
  `fingerprint` char(32) DEFAULT NULL COMMENT 'Fingerprint2js result of the user who created that item',
  `activated` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Is the photo reviewed and activated?',
  `available` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Item creation time',
  `fraud_score` float NOT NULL DEFAULT '0' COMMENT 'Fraud score',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Longitude of GEO location',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Latitude of Geolocation',
  `location` varchar(255) DEFAULT NULL COMMENT 'Text representation of the geolocation',
  PRIMARY KEY (`id`),
  KEY `instid` (`appId`),
  KEY `item_user_rel` (`uid`),
  KEY `item_type_rel` (`item_type_id`),
  CONSTRAINT `item_type_rel` FOREIGN KEY (`item_type_id`) REFERENCES `item_types` (`item_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `item_user_rel` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23321 DEFAULT CHARSET=utf8;

/*Table structure for table `mod_log_action` */

DROP TABLE IF EXISTS `mod_log_action`;

CREATE TABLE `mod_log_action` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `element_id` int(11) DEFAULT NULL COMMENT 'User ID, Item ID, ... if available',
  `scope` varchar(50) NOT NULL COMMENT 'Log scope/action',
  `data` varchar(20) DEFAULT NULL COMMENT 'Indexable data, max 20 char',
  `meta_data` text COMMENT 'Meta data as json',
  `ip` char(30) NOT NULL COMMENT 'IP address',
  `ip_hash` char(32) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp',
  PRIMARY KEY (`id`),
  KEY `instance_scope` (`appId`,`scope`),
  KEY `data_index` (`data`)
) ENGINE=InnoDB AUTO_INCREMENT=1164 DEFAULT CHARSET=utf8;

/*Table structure for table `mod_log_counter` */

DROP TABLE IF EXISTS `mod_log_counter`;

CREATE TABLE `mod_log_counter` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `element_id` int(11) DEFAULT NULL COMMENT 'User ID, Item ID, ... if available',
  `scope` varchar(50) NOT NULL COMMENT 'Log scope',
  `date` date NOT NULL COMMENT 'Log date',
  `date_scope` varchar(5) NOT NULL DEFAULT 'day' COMMENT 'day, month, year, all',
  `counter1` int(11) DEFAULT NULL COMMENT 'Counter 1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_log_counter` (`appId`,`element_id`,`scope`,`date`)
) ENGINE=InnoDB AUTO_INCREMENT=1033 DEFAULT CHARSET=utf8;

/*Table structure for table `mod_log_error` */

DROP TABLE IF EXISTS `mod_log_error`;

CREATE TABLE `mod_log_error` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `element_id` int(11) DEFAULT NULL COMMENT 'User ID, Item ID, ... if available',
  `scope` varchar(50) NOT NULL COMMENT 'Log scope/action',
  `data` varchar(20) DEFAULT NULL COMMENT 'Indexable data, max 20 char',
  `meta_data` text COMMENT 'Meta data as json',
  `ip` char(30) NOT NULL COMMENT 'IP address',
  `ip_hash` char(32) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp',
  PRIMARY KEY (`id`),
  KEY `instance_scope` (`appId`,`scope`),
  KEY `data_index` (`data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `schools` */

DROP TABLE IF EXISTS `schools`;

CREATE TABLE `schools` (
  `category` text,
  `city` text,
  `name` text,
  `address` text,
  `county` text,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `service` */

DROP TABLE IF EXISTS `service`;

CREATE TABLE `service` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` char(30) NOT NULL,
  `version` int(10) DEFAULT '0',
  `pid` int(10) NOT NULL,
  `status` char(10) NOT NULL DEFAULT '',
  `start_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `session` */

DROP TABLE IF EXISTS `session`;

CREATE TABLE `session` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `session_id` char(100) COLLATE utf8_bin NOT NULL,
  `data` text COLLATE utf8_bin,
  `timestamp` int(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when session created',
  `uid` int(11) DEFAULT NULL COMMENT 'User ID, if available',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tag` */

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `tag` char(100) NOT NULL DEFAULT '',
  `tag_type` char(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_tag_type_index` (`item_id`,`tag`,`tag_type`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

/*Table structure for table `task` */

DROP TABLE IF EXISTS `task`;

CREATE TABLE `task` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` char(20) NOT NULL,
  `version` int(10) NOT NULL DEFAULT '0',
  `params` text NOT NULL,
  `step` char(30) NOT NULL DEFAULT '',
  `error_count` int(4) NOT NULL DEFAULT '0',
  `errors` varchar(500) NOT NULL DEFAULT '',
  `pause` tinyint(1) NOT NULL DEFAULT '0',
  `finished` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'User ID',
  `appId` int(11) NOT NULL,
  `fb_user_id` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Facebook User ID',
  `fb_access_token` char(200) NOT NULL DEFAULT '',
  `instagram_access_token` char(200) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `gender` varchar(6) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `first_name` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `last_name` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `email` varchar(255) CHARACTER SET latin1 NOT NULL,
  `password` char(100) NOT NULL DEFAULT '',
  `locale` varchar(5) NOT NULL DEFAULT 'de_DE' COMMENT 'Localization settings of the user',
  `meta_data` text COMMENT 'JSON Meta data for the user',
  `activate_code` char(200) NOT NULL DEFAULT '' COMMENT 'User Account Activation code',
  `activate` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'User account is activated',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of the user creation',
  `newsletter_registration` tinyint(1) DEFAULT NULL COMMENT 'User registered for the newsletter',
  `newsletter_doi` tinyint(1) DEFAULT NULL COMMENT 'User confirmed registration Double Opt In',
  `newsletter_doi_ip` char(30) DEFAULT NULL COMMENT 'IP Address when user confirmed registration',
  `newsletter_doi_ip_hash` char(32) DEFAULT NULL,
  `newsletter_doi_timestamp` timestamp NULL DEFAULT NULL COMMENT 'Timestamp of the newsletter confirmation',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `reset_password_code` char(200) NOT NULL DEFAULT '',
  `reset_password_code_expired` int(10) NOT NULL DEFAULT '0',
  `is_register` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uid`),
  KEY `fb_user_id` (`fb_user_id`),
  KEY `appId` (`appId`)
) ENGINE=InnoDB AUTO_INCREMENT=1117168 DEFAULT CHARSET=utf8;

/*Table structure for table `vote` */

DROP TABLE IF EXISTS `vote`;

CREATE TABLE `vote` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `appId` int(11) NOT NULL COMMENT 'Instance ID',
  `item_id` int(10) NOT NULL COMMENT 'Item ID',
  `uid` int(10) NOT NULL COMMENT 'User ID',
  `type` varchar(16) NOT NULL COMMENT 'Voting type (e.g. stars, count)',
  `value` double NOT NULL DEFAULT '0' COMMENT 'Vote value',
  `meta_data` text,
  `ip` char(30) NOT NULL COMMENT 'IP Address of the user who voted',
  `ip_hash` char(32) DEFAULT NULL COMMENT 'MD5 hashed IP Address of the user who voted',
  `fingerprint` char(32) DEFAULT NULL COMMENT 'Fingerprint2js result of the user who voted',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of the vote',
  `confirmed` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Is this vote from a confirmed user?',
  PRIMARY KEY (`id`),
  KEY `vote_user_rel` (`uid`),
  KEY `vote_item_rel` (`item_id`),
  KEY `appId` (`appId`),
  CONSTRAINT `vote_item_rel` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vote_user_rel` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

/* Trigger structure for table `mod_log_action` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `log_create` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'%' */ /*!50003 TRIGGER `log_create` AFTER INSERT ON `mod_log_action` FOR EACH ROW BEGIN
	CALL log_counter_increase(NEW.appId, NEW.element_id, NEW.scope);
    END */$$


DELIMITER ;

/* Procedure structure for procedure `log_counter_increase` */

/*!50003 DROP PROCEDURE IF EXISTS  `log_counter_increase` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `log_counter_increase`(
  IN appId INT,
  IN element_id INT,
  IN scope CHAR(100)
)
BEGIN
  DECLARE DAY CHAR(20) ;
    
  SET @day = DATE_FORMAT(NOW(), '%Y-%m-%d');
  SET @month = CONCAT(DATE_FORMAT(NOW(), '%Y-%m'), '-00');
  SET @year = CONCAT(DATE_FORMAT(NOW(), '%Y'), '-00-00');
  SET @all = '0000-00-00';
    
  INSERT INTO mod_log_counter (`appId`,`element_id`,`scope`,`date`,`date_scope`,`counter1`) 
  VALUES (appId, element_id, scope, @day, 'day', 1)
  ON DUPLICATE KEY UPDATE counter1=counter1+1;
  
  INSERT INTO mod_log_counter (`appId`,`element_id`,`scope`,`date`,`date_scope`,`counter1`) 
  VALUES (appId, element_id, scope, @month, 'month', 1)
  ON DUPLICATE KEY UPDATE counter1=counter1+1;
  
  INSERT INTO mod_log_counter (`appId`,`element_id`,`scope`,`date`,`date_scope`,`counter1`) 
  VALUES (appId, element_id, scope, @year, 'year', 1)
  ON DUPLICATE KEY UPDATE counter1=counter1+1;
  
  INSERT INTO mod_log_counter (`appId`,`element_id`,`scope`,`date`,`date_scope`,`counter1`) 
  VALUES (appId, element_id, scope, @all, 'all', 1)
  ON DUPLICATE KEY UPDATE counter1=counter1+1;
    
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
