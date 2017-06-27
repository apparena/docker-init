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

/*Data for the table `item_types` */

insert  into `item_types`(`item_type_id`,`item_type`,`og_object`,`og_action_upload`,`og_action_vote`) values 
(1,'association','association','create','vote'),
(2,'photo','photo','upload','vote'),
(3,'video','video','upload','vote'),
(4,'project','project','create','vote'),
(5,'school','school','upload','vote');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
