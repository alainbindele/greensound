# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.6.38)
# Database: greensound_repository
# Generation Time: 2019-03-24 15:55:43 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table binaryData
# ------------------------------------------------------------

DROP TABLE IF EXISTS `binaryData`;

CREATE TABLE `binaryData` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `description` char(50) DEFAULT NULL,
  `plantId` int(4) DEFAULT NULL,
  `binData` longblob,
  `filename` char(50) DEFAULT NULL,
  `filesize` char(50) DEFAULT NULL,
  `filetype` char(50) DEFAULT NULL,
  `startDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `config`;

CREATE TABLE `config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `photosFolder` text,
  `soundsFolder` text,
  `ecFolder` text,
  `resistivityFolder` text,
  `zipFolder` text,
  `samplesBeforeZip` int(11) DEFAULT NULL,
  `name` varchar(48) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;

INSERT INTO `config` (`id`, `photosFolder`, `soundsFolder`, `ecFolder`, `resistivityFolder`, `zipFolder`, `samplesBeforeZip`, `name`)
VALUES
	(1,'~/greensound_photos/photos','~/greensound_photos/sounds','~/greensound_photos/ec','~/greensound_photos/resistivity','~/greensound_photos/compressed',50,'default');

/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table plainTextData_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `plainTextData_copy`;

CREATE TABLE `plainTextData_copy` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `description` char(50) DEFAULT NULL,
  `plantId` int(4) DEFAULT NULL,
  `rawData` longtext,
  `filename` char(50) DEFAULT NULL,
  `filesize` char(50) DEFAULT NULL,
  `filetype` char(50) DEFAULT NULL,
  `startDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table plantsCatalogue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `plantsCatalogue`;

CREATE TABLE `plantsCatalogue` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL DEFAULT '',
  `description` text,
  `origin` varchar(256) DEFAULT NULL,
  `link` varchar(1024) DEFAULT NULL,
  `metadata` text,
  `other` varchar(11) DEFAULT NULL,
  `acquired` tinyint(1) DEFAULT NULL,
  `photo` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
