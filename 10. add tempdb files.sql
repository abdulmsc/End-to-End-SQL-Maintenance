-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			07/09/2018
--
-- Description :	Example modifying TEMPDB locatio and adding new files
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
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', FILENAME = N'T:\TEMPDB\Data\tempdev.mdf' , SIZE = 4096MB , MAXSIZE = 8192MB , FILEGROWTH = 64MB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', FILENAME = N'T:\TEMPDB\Logs\templog.ldf' , SIZE = 4096MB , MAXSIZE = 8192MB , FILEGROWTH = 64MB )
GO
-- uncomment if additional files are needed up to a maximum of 8... so tempdev2, tempdev3 and so on.

/*
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'T:\TEMPDB\Data\tempdev2.ndf' ,  SIZE = 4096MB , MAXSIZE = 8192MB , FILEGROWTH = 64MB )
GO
/*

USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp2', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp3', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp4', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp5', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp6', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp7', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'temp8', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 4194304KB , MAXSIZE = 16777216KB )
GO
