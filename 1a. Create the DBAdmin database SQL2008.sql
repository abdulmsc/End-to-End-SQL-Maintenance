-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			8th July 2011
--
-- Description :	To create the DBAdmin database for SQL 2008 and SQL 2008 R2
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

/****** Object:  Database [DBAdmin]    Script Date: 07/09/2018 12:03:09 ******/
CREATE DATABASE [DBAdmin] ON  PRIMARY 
( NAME = N'DBAdmin', FILENAME = N'E:\SQL 2008R2\Data\DBAdmin.mdf' , SIZE = 2097152KB , MAXSIZE = 4194304KB , FILEGROWTH = 65536KB ), 
 FILEGROUP [DATA]  DEFAULT
( NAME = N'DBAdmin_Data', FILENAME = N'E:\SQL 2008R2\Data\DBAdmin_Data.ndf' , SIZE = 4194304KB , MAXSIZE = 8388608KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBAdmin_Log', FILENAME = N'E:\SQL 2008R2\Logs\DBAdmin_Log.LDF' , SIZE = 2097152KB , MAXSIZE = 4194304KB , FILEGROWTH = 65536KB )
GO

ALTER DATABASE [DBAdmin] SET COMPATIBILITY_LEVEL = 100
GO

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

ALTER DATABASE [DBAdmin] SET  READ_WRITE 
GO


