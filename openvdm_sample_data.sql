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
INSERT INTO `OVDM_CollectionSystemTransfers` (`collectionSystemTransferID`, `name`, `longName`, `description`, `cruiseOrLowering`, `sourceDir`, `destDir`, `staleness`, `removeSourceFiles`, `useStartDate`, `skipEmptyDirs`, `skipEmptyFiles`, `syncFromSource`, `transferType`, `localDirIsMountPoint`, `rsyncServer`, `rsyncUser`, `rsyncPass`, `smbServer`, `smbUser`, `smbPass`, `smbDomain`, `sshServer`, `sshUser`, `sshUseKey`, `sshPass`, `ftpServer`, `ftpUser`, `ftpPass`, `includeFilter`, `excludeFilter`, `ignoreFilter`, `status`, `enable`, `pid`, `bandwidthLimit`) VALUES (1,'OpenRVDAS','OpenRVDAS (SSH Server)',CONCAT('##### Source: OpenRVDAS underway data logging system', CHAR(10), '##### Files:', CHAR(10), ' - **`raw/MET-<YYYYmmDD>-<HHMMSS>.txt`**: Meteorological data', CHAR(10), ' - **`raw/POSMV_GGA-<YYYYmmDD>-<HHMMSS>.txt`**: GGA NMEA-formatted position data', CHAR(10), ' - **`raw/SVP-<YYYYmmDD>-<HHMMSS>.txt`**: SVP70 Surface SV probe data', CHAR(10), ' - **`raw/TSG_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: SBE45 TSG data'),0,'/data/sample_data/ssh_source/OpenRVDAS','OpenRVDAS',0,0,0,1,1,0,4,0,'','','','','','','','127.0.0.1','survey',1,NULL,NULL,NULL,NULL,'*','','',2,1,0,0),
(2,'XBT','XBT  (Authenticated SMB Share)',CONCAT('##### Source: Sippican Mk21 XBT Processing System', CHAR(10), '##### Files:', CHAR(10), ' - **`{cruiseID}_XBT[0-9][0-9][0-9]_<mmDD>.edf`**: Raw XBT data'),0,'/XBT','XBT',0,0,0,1,1,0,3,0,'','','','//localhost/SampleAuthSource','survey','sample_smb_passwd','WORKGROUP','','',0,'',NULL,NULL,NULL,'*{cruiseID}_XBT[0-9][0-9][0-9]_{mm}{DD}*','','',2,1,0,0),
(3,'EM302','EM302 Multibeam (Rsync Server)',CONCAT('##### Source: Kongsberg EM302 MBES Mapping sonar', CHAR(10), '##### Files:', CHAR(10), ' - **`*.kmwall`**: raw seafloor mapping data.', CHAR(10), ' - **`*.kmwcd`**: raw water column mapping data.', CHAR(10), ' - **`*.tiff`**: GeoTIFF rastered data product created from raw data.'),0,'/EM302','EM302',0,0,0,1,1,0,2,0,'localhost/sample_data','survey','b4dPassword!','','','','','','',0,'',NULL,NULL,NULL,'*','','',2,1,0,0),
(4,'CTD','SBE 911+ CTD (Local Directory)',CONCAT('##### Source: SBE 911+ CTD', CHAR(10), '##### Files:', CHAR(10), ' - **`{cruiseID}_CTD###_<mmDD>.XMLCON`**: Cast configuration data', CHAR(10), ' - **`{cruiseID}_CTD###_<mmDD>.bl`**: Cast bottle data', CHAR(10), ' - **`{cruiseID}_CTD###_<mmDD>.hdr`**: Cast header data', CHAR(10), ' - **`{cruiseID}_CTD###_<mmDD>.hex`**: Cast raw data'),0,'/data/sample_data/local_source/CTD','CTD',0,0,0,1,1,0,1,0,'','','','','','','','','',0,'',NULL,NULL,NULL,'*/{cruiseID}_CTD[0-9][0-9][0-9]_{mm}{DD}*','','*decktest*',2,1,0,0),
(5,'Sealog','Sealog (Guest SMB Share)','##### Source: Sealog Event logging system',0,'/sealog','Sealog',0,0,0,1,1,0,3,0,'','','','//localhost/SampleAnonSource','guest','','WORKGROUP','','',0,'',NULL,NULL,NULL,'*','','',2,1,0,0),
(6,'ROV_OpenRVDAS','OpenRVDAS collecting data for ROV (FTP Server)',CONCAT('#### Source: Cropped versions of the raw OpenRVDAS data files. Created as part of the Sealog data export process.', CHAR(10), '##### Files:', CHAR(10), ' - **`CTD_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: FastCAT45 CTD data', CHAR(10), ' - **`Mech_Comps_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: Hydraulic compensator pressure data', CHAR(10), ' - **`O2_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: Dissolved oxygen data', CHAR(10), ' - **`Paro_Depth_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: Paro depth data', CHAR(10), ' - **`Sprint_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: SPRINT navigation data', CHAR(10), ' - **`USBL_Pri_GGA_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: Primary USBL position data', CHAR(10), ' - **`USBL_Sec_GGA_Raw-<YYYYmmDD>-<HHMMSS>.txt`**: Secondary USBL position data'),1,'/ftp_source/OpenRVDAS','OpenRVDAS',0,0,0,1,1,0,5,0,'','','','','','','','','',0,'','127.0.0.1:2121','survey','sample_smb_passwd','*','','',2,1,0,0);
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
(2,'Dashboard_Data','Dashboard Data',CONCAT('Contents: the files OpenVDM''s Data Dashboard is built from: the data and quality test results its plugins extract from the collection systems'' raw files, and the manifest that lists them. Written by OpenVDM.', CHAR(10), 'Files: JSON (.json): one for each processed raw file, and the manifest.', CHAR(10), 'Sub-directories: the same folders as the raw files in the cruise directory. Each lowering''s files and manifest are under its lowering''s folder.'),0,'OpenVDM/DashboardData',1,1),
(3,'From_PublicData','Files copied from PublicData share',CONCAT('Contents: files from the ship''s PublicData share, where scientists and crew share files during the cruise, copied here when the cruise is finalized.', CHAR(10), 'Files: any type, as saved on the share.', CHAR(10), 'Sub-directories: as on the PublicData share.'),0,'From_PublicData',1,1),
(4,'Tracklines','Cruise Tracklines','Contains geoJSON and KML versions of the cruise''s trackline from each of the available position sources.',0,'Products/Tracklines',1,0),
(5,'CTD_Plots','CTD Plots','Contains png images of the CTD casts. The names of the files correlate to the .hex raw file names.',0,'CTD/Plots',1,0);
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


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-05 14:57:23
