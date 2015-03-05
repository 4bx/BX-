CREATE DATABASE  IF NOT EXISTS `tecnoparque` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tecnoparque`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: tecnoparque
-- ------------------------------------------------------
-- Server version	5.5.33

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
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `nombre` varchar(45) NOT NULL,
  `c_empresa` smallint(6) NOT NULL,
  PRIMARY KEY (`c_empresa`,`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT  IGNORE INTO `usuarios` VALUES ('Unassigned',0),('Agustin Gutierrez',1),('Alejandra Ivonne González Venancio',1),('Ana hernandez',1),('Ana Mayte Topete',1),('Antonio Laija Olmedo',1),('Azucena Gudiño',1),('Beatriz Pérez',1),('Cesar Guzmán',1),('Christian González Flores',1),('Christian Ramirez',1),('Cinthya Martinez',1),('Edgar Rangel',1),('Erick Vázquez',1),('Francisco Morales López',1),('Gaby Ledesma',1),('Giordy Palacios',1),('Irma Aguilar',1),('Isela Martínez',1),('Isis Murguia',1),('Janet Dominguez',1),('Jaqueline Morales',1),('Jesús Villaseñor',1),('Jocelyn Vazquez',1),('Jose Daniel Garces Quiroz',1),('Juan Carlos Fernández',1),('Juan Martinez',1),('Juan Vargas',1),('Leonado Hernández',1),('Margarita Arellano',1),('Maricarmen Mendez Álvarez',1),('Martin Cruz',1),('Mary Carmen Bonilla Limón',1),('Patricio Ovejas',1),('Rafael Cedillo',1),('Roberto de la Rosa',1),('Tere Díaz',1),('Veronica Angeles',1),('Victor Arellanes',1),('Ximena Roldan',1),('Arturo Saldivar',2),('Benito Gutierrez',2),('Carmen Méndez',2),('Cintia Ochoa',2),('DesarrolloTAS',2),('Edgar Richter',2),('Ever Hernandez',2),('Gabriela Cedillo',2),('Gerardo Gomez',2),('Gerardo Tenopala',2),('German Gomez',2),('Ivan Torres',2),('Jacqueline Barradas',2),('Salvador García',2),('Sergio Rangel',2);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-03-04 17:49:29
