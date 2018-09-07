-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			8th July 2011
--
-- Description :	To create the DBAdmin database for SQL 2016
--
-- ###################################################################################

/********************************************************************************************************************/
-- Disclaimer...
--
-- This script is provided for open use by Haden Kingsland (theflyingDBA) and as such is provided as is, with
-- no warranties or guarantees.
-- The author takes no responsibility for the use of this script within environments that are outside of his direct
-- control and advises that the use of this script be fully tested and ratified within a non-production environment
-- prior to being pushed into production.
-- This script may be freely used and distributed in line with these terms and used for commercial purposes, but
-- not for financial gain by anyone other than the original author.
-- All intellectual property rights remain solely with the original author.
--
/********************************************************************************************************************/


USE [master]
GO

CREATE DATABASE [DBAdmin]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBAdmin', FILENAME = N'F:\SQLDATA\Data\DBAdmin.mdf' , SIZE = 2048MB , MAXSIZE = 4096MB, FILEGROWTH = 64MB ), 
 FILEGROUP [DATA]  DEFAULT
( NAME = N'DBAdmin_Data', FILENAME = N'F:\SQLDATA\Data\DBAdmin_Data.ndf' , SIZE = 4096MB , MAXSIZE = 8192MB , FILEGROWTH = 64MB )
 LOG ON 
( NAME = N'DBAdmin_Log', FILENAME = N'E:\SQLLOGS\Logs\DBAdmin_Log.LDF' , SIZE = 2048MB , MAXSIZE = 4096MB , FILEGROWTH = 64MB )
COLLATE Latin1_General_CI_AS -- to enforce standard LOR collation
GO
ALTER DATABASE [DBAdmin] SET COMPATIBILITY_LEVEL = 130 -- change this to reflect the environment into which it is being deployed.
GO
-- If full text is installed 
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBAdmin].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DBAdmin] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DBAdmin] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DBAdmin] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DBAdmin] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DBAdmin] SET ARITHABORT OFF 
GO

ALTER DATABASE [DBAdmin] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DBAdmin] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DBAdmin] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DBAdmin] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DBAdmin] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DBAdmin] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DBAdmin] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DBAdmin] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DBAdmin] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DBAdmin] SET  ENABLE_BROKER 
GO

ALTER DATABASE [DBAdmin] SET AUTO_UPDATE_STATISTICS_ASYNC ON 
GO

ALTER DATABASE [DBAdmin] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DBAdmin] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DBAdmin] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DBAdmin] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DBAdmin] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DBAdmin] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DBAdmin] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [DBAdmin] SET  MULTI_USER 
GO

ALTER DATABASE [DBAdmin] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DBAdmin] SET DB_CHAINING OFF 
GO

ALTER DATABASE [DBAdmin] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [DBAdmin] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [DBAdmin] SET  READ_WRITE 
GO


