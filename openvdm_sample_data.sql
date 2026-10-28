-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: OpenVDMv2
-- ------------------------------------------------------
-- Server version	8.0.23-0ubuntu0.20.04.1

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
-- Table structure for table `OVDM_CollectionSystemTransfers`
--

DROP TABLE IF EXISTS `OVDM_CollectionSystemTransfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OVDM_CollectionSystemTransfers` (
  `collectionSystemTransferID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` tinytext NOT NULL,
  `longName` text,
  `description` text,
  `cruiseOrLowering` int(1) unsigned NOT NULL DEFAULT '0',
  `sourceDir` tinytext,
  `destDir` tinytext,
  `staleness` int(11) DEFAULT '0',
  `removeSourceFiles` int(1) unsigned NOT NULL DEFAULT '0',
  `useStartDate` tinyint(1) DEFAULT '0',
  `skipEmptyDirs` int(1) unsigned NOT NULL DEFAULT '1',
  `skipEmptyFiles` int(1) unsigned NOT NULL DEFAULT '1',
  `syncFromSource` int(1) unsigned NOT NULL DEFAULT '0',
  `transferType` int(11) unsigned NOT NULL,
  `localDirIsMountPoint` int(1) unsigned NOT NULL DEFAULT '0',
  `rsyncServer` tinytext,
  `rsyncUser` tinytext,
  `rsyncPass` tinytext,
  `smbServer` tinytext,
  `smbUser` tinytext,
  `smbPass` tinytext,
  `smbDomain` tinytext,
  `sshServer` tinytext,
  `sshUser` tinytext,
  `sshUseKey` int(1) unsigned NOT NULL DEFAULT '0',
  `sshPass` tinytext,
  `ftpServer` tinytext,
  `ftpUser` tinytext,
  `ftpPass` tinytext,
  `includeFilter` text,
  `excludeFilter` text,
  `ignoreFilter` text,
  `status` int(11) unsigned NOT NULL DEFAULT '3',
  `enable` tinyint(1) NOT NULL DEFAULT '0',
  `pid` int(11) unsigned DEFAULT '0',
  `bandwidthLimit` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`collectionSystemTransferID`),
  KEY `CollectionSystemTransferStatus` (`status`),
  KEY `CollectionSystemTransferType` (`transferType`),
  CONSTRAINT `CollectionSystemTransferStatus` FOREIGN KEY (`status`) REFERENCES `OVDM_Status` (`statusID`),
  CONSTRAINT `CollectionSystemTransferType` FOREIGN KEY (`transferType`) REFERENCES `OVDM_TransferTypes` (`transferTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OVDM_CollectionSystemTransfers`
--

LOCK TABLES `OVDM_CollectionSystemTransfers` WRITE;
/*!40000 ALTER TABLE `OVDM_CollectionSystemTransfers` DISABLE KEYS */;
INSERT INTO `OVDM_CollectionSystemTransfers` (`collectionSystemTransferID`, `name`, `longName`, `description`, `cruiseOrLowering`, `sourceDir`, `destDir`, `staleness`, `removeSourceFiles`, `useStartDate`, `skipEmptyDirs`, `skipEmptyFiles`, `syncFromSource`, `transferType`, `localDirIsMountPoint`, `rsyncServer`, `rsyncUser`, `rsyncPass`, `smbServer`, `smbUser`, `smbPass`, `smbDomain`, `sshServer`, `sshUser`, `sshUseKey`, `sshPass`, `ftpServer`, `ftpUser`, `ftpPass`, `includeFilter`, `excludeFilter`, `ignoreFilter`, `status`, `enable`, `pid`, `bandwidthLimit`) VALUES (1,'OpenRVDAS','OpenRVDAS (SSH Server)',CONCAT('**Source:** OpenRVDAS Underway data acquisition system', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `raw/*.txt`: timestamped raw data from ship''s navigation, meteorologic and oceanographic sensors', CHAR(10), '- `proc/*.txt`: timestamped data derived from raw sensors data'),0,'/data/sample_data/ssh_source/OpenRVDAS','OpenRVDAS',0,0,0,1,1,0,4,0,'','','','','','','','127.0.0.1','survey',1,NULL,NULL,NULL,NULL,'*','','',2,1,0,0),
(2,'XBT','XBT  (Authenticated SMB Share)',CONCAT('**Source:** Sippican mk21 XBT', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `{cruiseID}_XBT###_mmDD*.[RDF|EDF]`: Raw XBT data'),0,'/XBT','XBT',0,0,0,1,1,0,3,0,'','','','//localhost/SampleAuthSource','survey','sample_smb_passwd','WORKGROUP','','',0,'',NULL,NULL,NULL,'*{cruiseID}_XBT[0-9][0-9][0-9]_{mm}{DD}*','','',2,1,0,0),
(3,'EM302','EM302 Multibeam (Rsync Server)',CONCAT('**Source:** EM302 Mulitbeam Mapping Sonar', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `raw/*.kmall`: Raw multibeam data', CHAR(10), '- `proc/*.tif`: Processed MBES data rastered image in GeoTIFF format'),0,'/EM302','EM302',0,0,0,1,1,0,2,0,'localhost/sample_data','survey','b4dPassword!','','','','','','',0,'',NULL,NULL,NULL,'*','','',2,1,0,0),
(4,'CTD','SBE 911+ CTD (Local Directory)',CONCAT('**Source:** SBE 9/11+ CTD Rosette and instrument package', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `<cruiseID>_CTD###_mmDD.*`:  Raw CTD data and metadata.  File extensions include: `.bl`, `.hdr`, `.hex`, and `.XMLCON`'),0,'/data/sample_data/local_source/CTD','CTD',0,0,0,1,1,0,1,0,'','','','','','','','','',0,'',NULL,NULL,NULL,'*{cruiseID}_CTD[0-9][0-9][0-9]_{mm}{DD}*','','*decktest*',2,1,0,0),
(5,'Sealog','Sealog (Guest SMB Share)',CONCAT('**Source:** Sealog Eventlogging system', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `{cruiseID}_sealogExport.[json|csv]`: Sealog events with ancillary data in csv and json format', CHAR(10), '- `{cruiseID}_cruiseRecord.json`: Sealog cruise record containing cruise metadata.', CHAR(10), '- `{cruiseID}_auxData.json`: Sealog auxData records in json format. Useful when transferring Sealog data between instances.', CHAR(10), '- `{cruiseID}_eventOnlyExport.json`: Sealog event records w/o ancillary data in json format. Useful when transferring Sealog data between instances.', CHAR(10), '- `{cruiseID}_eventTemplates.json`: Sealog event template records in json format. Useful when transferring Sealog event templates between instances.'),0,'/sealog','Sealog',0,0,0,1,1,0,3,0,'','','','//localhost/SampleAnonSource','guest','','WORKGROUP','','',0,'',NULL,NULL,NULL,'*','','',2,1,0,0),
(6,'ROV_OpenRVDAS','OpenRVDAS collecting data for ROV (FTP Server)',CONCAT('**Source:** OpenRVDAS Underway data acquisition system, cropped to match the ROV''s start/stop times', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `raw/*.txt`: timestamped raw data from ship''s navigational, vehicle''s navigational and vehicle''s scientific sensors'),1,'/ftp_source/OpenRVDAS','OpenRVDAS',0,0,0,1,1,0,5,0,'','','','','','','','','',0,'','127.0.0.1:2121','survey','sample_smb_passwd','*','','',2,1,0,0);
/*!40000 ALTER TABLE `OVDM_CollectionSystemTransfers` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `OVDM_CruiseDataTransfers`
--

DROP TABLE IF EXISTS `OVDM_CruiseDataTransfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OVDM_CruiseDataTransfers` (
  `cruiseDataTransferID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` tinytext NOT NULL,
  `longName` text,
  `skipEmptyDirs` int(1) unsigned NOT NULL DEFAULT '1',
  `skipEmptyFiles` int(1) unsigned NOT NULL DEFAULT '1',
  `syncToDest` int(1) unsigned NOT NULL DEFAULT '0',
  `transferType` int(11) unsigned NOT NULL,
  `destDir` tinytext,
  `localDirIsMountPoint` int(1) unsigned NOT NULL DEFAULT '0',
  `rsyncServer` tinytext,
  `rsyncUser` tinytext,
  `rsyncPass` tinytext,
  `smbServer` tinytext,
  `smbUser` tinytext,
  `smbPass` tinytext,
  `smbDomain` tinytext,
  `sshServer` tinytext,
  `sshUser` tinytext,
  `sshUseKey` int(1) unsigned NOT NULL DEFAULT '0',
  `sshPass` tinytext,
  `ftpServer` tinytext,
  `ftpUser` tinytext,
  `ftpPass` tinytext,
  `status` int(11) unsigned NOT NULL DEFAULT '3',
  `enable` tinyint(1) NOT NULL DEFAULT '0',
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `pid` int(11) unsigned DEFAULT '0',
  `bandwidthLimit` int(10) unsigned NOT NULL DEFAULT '0',
  `includeOVDMFiles` int(1) unsigned NOT NULL DEFAULT '0',
  `includePublicDataFiles` int(1) unsigned NOT NULL DEFAULT '0',
  `excludedCollectionSystems` tinytext,
  `excludedExtraDirectories` tinytext,
  PRIMARY KEY (`cruiseDataTransferID`),
  KEY `CruiseDataTransferStatus` (`status`),
  KEY `CruiseDataTransferType` (`transferType`),
  CONSTRAINT `CruiseDataTransferStatus` FOREIGN KEY (`status`) REFERENCES `OVDM_Status` (`statusID`),
  CONSTRAINT `CruiseDataTransferType` FOREIGN KEY (`transferType`) REFERENCES `OVDM_TransferTypes` (`transferTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OVDM_CruiseDataTransfers`
--

LOCK TABLES `OVDM_CruiseDataTransfers` WRITE;
/*!40000 ALTER TABLE `OVDM_CruiseDataTransfers` DISABLE KEYS */;
INSERT INTO `OVDM_CruiseDataTransfers` (`cruiseDataTransferID`, `name`, `longName`, `skipEmptyDirs`, `skipEmptyFiles`, `syncToDest`, `transferType`, `destDir`, `localDirIsMountPoint`, `rsyncServer`, `rsyncUser`, `rsyncPass`, `smbServer`, `smbUser`, `smbPass`, `smbDomain`, `sshServer`, `sshUser`, `sshUseKey`, `sshPass`, `ftpServer`, `ftpUser`, `ftpPass`, `status`, `enable`, `required`, `pid`, `bandwidthLimit`, `includeOVDMFiles`, `includePublicDataFiles`, `excludedCollectionSystems`, `excludedExtraDirectories`) VALUES (1,'SSDW','Shoreside Data Warehouse',1,1,0,4,'/data/sample_data/ssdw',0,'','','','','','','','localhost','survey',1,NULL,NULL,NULL,NULL,2,1,1,0,128,0,0,'0','0'),
(2,'Local_Copy','Cruise copy to local directory',1,1,0,1,'/data/sample_data/local_destination',0,'','','','','','','','','',0,'',NULL,NULL,NULL,2,1,0,0,0,0,0,'0','0'),
(3,'Cruise_Auth_SMB','Cruise copy to authenticated SMB share',1,1,0,3,'/',0,'','','','//localhost/SampleAuthDestination','survey','sample_smb_passwd','WORKGROUP','','',0,'',NULL,NULL,NULL,2,1,0,0,0,0,0,'0','0'),
(4,'Cruise_Anon_SMB','Cruise copy to anonymous SMB share',1,1,0,3,'/',0,'','','','//localhost/SampleAnonDestination','guest','','WORKGROUP','','',0,'',NULL,NULL,NULL,2,1,0,0,0,0,0,'0','0'),
(5,'cruise_rsync','Cruise copy to rsync server',1,1,0,2,'/',0,'localhost/sample_dest','survey','b4dPassword!','','','','','','',0,'',NULL,NULL,NULL,2,1,0,0,0,0,0,'0','0'),
(6,'cruise_ssh','Cruise copy to SSH server',1,1,0,4,'/data/sample_data/ssh_destination',0,'','','','','','','','localhost','survey',1,NULL,NULL,NULL,NULL,2,1,0,0,0,0,0,'0','0'),
(7,'cruise_ftp','Cruise copy to FTP server',1,1,0,5,'/ftp_destination',0,'','','','','','','','','',0,'','127.0.0.1:2121','survey','sample_smb_passwd',2,1,0,0,0,0,0,'0','0');
/*!40000 ALTER TABLE `OVDM_CruiseDataTransfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OVDM_ExtraDirectories`
--

DROP TABLE IF EXISTS `OVDM_ExtraDirectories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OVDM_ExtraDirectories` (
  `extraDirectoryID` int unsigned NOT NULL AUTO_INCREMENT,
  `name` tinytext NOT NULL,
  `longName` tinytext,
  `description` text,
  `cruiseOrLowering` int(1) unsigned NOT NULL DEFAULT '0',
  `destDir` tinytext NOT NULL,
  `enable` tinyint(1) DEFAULT '0',
  `required` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`extraDirectoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OVDM_ExtraDirectories`
--

LOCK TABLES `OVDM_ExtraDirectories` WRITE;
/*!40000 ALTER TABLE `OVDM_ExtraDirectories` DISABLE KEYS */;
INSERT INTO `OVDM_ExtraDirectories` (`extraDirectoryID`, `name`, `longName`, `description`, `cruiseOrLowering`, `destDir`, `enable`, `required`) VALUES (1,'Transfer_Logs','Transfer Logs',NULL,0,'OpenVDM/TransferLogs',1,1),
(2,'Dashboard_Data','Dashboard Data',CONCAT('The files OpenVDM''s Data Dashboard is built from: the data and quality test results its plugins extract from the collection systems'' raw files. Written by OpenVDM.', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- `*.json`: the data and quality test results extracted from one raw file', CHAR(10), '- the manifest (JSON): the list of these files that the Data Dashboard reads', CHAR(10), CHAR(10), '**Sub-directories:**', CHAR(10), '- the same folders as the raw files in the cruise directory, for the files extracted from them', CHAR(10), '- each lowering''s files and manifest are under its lowering''s folder'),0,'OpenVDM/DashboardData',1,1),
(3,'From_PublicData','Files copied from PublicData share',CONCAT('Files from the ship''s PublicData share, where scientists and crew share files during the cruise, copied here when the cruise is finalized.', CHAR(10), CHAR(10), '**Files:**', CHAR(10), '- any type, as saved on the share', CHAR(10), CHAR(10), '**Sub-directories:**', CHAR(10), '- the same folders as on the PublicData share'),0,'From_PublicData',1,1),
(4,'Tracklines','Cruise Tracklines',NULL,0,'Products/Tracklines',1,0),
(5,'NAV_QA','NAV QA Products','',0,'Products/NAV_QA',1,0);
/*!40000 ALTER TABLE `OVDM_ExtraDirectories` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `OVDM_ShipToShoreTransfers`
--

DROP TABLE IF EXISTS `OVDM_ShipToShoreTransfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OVDM_ShipToShoreTransfers` (
  `shipToShoreTransferID` int unsigned NOT NULL AUTO_INCREMENT,
  `name` tinytext,
  `longName` tinytext,
  `priority` int DEFAULT NULL,
  `collectionSystem` int unsigned DEFAULT NULL,
  `extraDirectory` int unsigned DEFAULT NULL,
  `includeFilter` tinytext,
  `enable` tinyint(1) NOT NULL DEFAULT '0',
  `required` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipToShoreTransferID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OVDM_ShipToShoreTransfers`
--

LOCK TABLES `OVDM_ShipToShoreTransfers` WRITE;
/*!40000 ALTER TABLE `OVDM_ShipToShoreTransfers` DISABLE KEYS */;
INSERT INTO `OVDM_ShipToShoreTransfers` (`shipToShoreTransferID`, `name`, `longName`, `priority`, `collectionSystem`, `extraDirectory`, `includeFilter`, `enable`, `required`) VALUES (1,'DashboardData','Dashboard Data',1,0,2,'*',1,1),
(2,'TransferLogs','Transfer Logs',1,0,1,'*',0,1),
(3,'MD5Summary','MD5 Summary',1,0,0,'MD5_Summary.txt,MD5_Summary.md5 ',1,1),
(4,'OVDM_Config','OpenVDM Configuration',1,0,0,'ovdmConfig.json',1,1),
(5,'GGA_FILES','GGA Files',1,1,0,'*_GGA-*.txt',1,0),
(6,'MET','Met raw files',3,1,0,'*MET-*.txt,*TSG_Raw-*.txt',1,0);
/*!40000 ALTER TABLE `OVDM_ShipToShoreTransfers` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Cruise details, as on the demo site
--

UPDATE `OVDM_CoreVars` SET `value` = 'ODT2601' WHERE `name` = 'cruiseID';
UPDATE `OVDM_CoreVars` SET `value` = 'Gulf of Mexico Exploration' WHERE `name` = 'cruiseName';
UPDATE `OVDM_CoreVars` SET `value` = 'The Gulf of Mexico mission operated in the sediments of which are part of the upward-moving Louann Formation.' WHERE `name` = 'cruiseDescription';
UPDATE `OVDM_CoreVars` SET `value` = 'Adam Skarke' WHERE `name` = 'cruisePI';
UPDATE `OVDM_CoreVars` SET `value` = 'Gulf of Mexico' WHERE `name` = 'cruiseLocation';
UPDATE `OVDM_CoreVars` SET `value` = '2012/04/28 00:00' WHERE `name` = 'cruiseStartDate';
UPDATE `OVDM_CoreVars` SET `value` = '2012/04/30 00:00' WHERE `name` = 'cruiseEndDate';
UPDATE `OVDM_CoreVars` SET `value` = 'Pascagoula, MS' WHERE `name` = 'cruiseStartPort';
UPDATE `OVDM_CoreVars` SET `value` = 'Galveston, TX' WHERE `name` = 'cruiseEndPort';

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-05 14:57:23
