
-- #######################################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			07/09/2018
--
-- Description :	The below needs to be run for each non sysadmin user that is required to create or
--					delete a database from an instance. This allows the "ddl_trig_database" or
--					"ddl_trig_database_drop" to send an email out via database mail under this user upon 
--					creation or deletion.
--
--					Also add the required user to MSDB
--
-- ########################################################################################################

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
-- The below are just examples of users being added

-- adding the user to MSDB

USE [msdb]
GO
CREATE USER [OROURKE\MOSS_DM_SVC] FOR LOGIN [OROURKE\MOSS_DM_SVC]
GO
USE [msdb]
GO
EXEC sp_addrolemember N'DatabaseMailUserRole', N'DATAEX\eu-it-dataex_spfarm'
GO

-- Grants permission for a database user or role to use a Database Mail profile

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'EU-IT-SQL_Alerts',
    @principal_name = 'OROURKE\EU-IT-DCRPRD_SVC',
    @is_default = 1;

--
-- Allow a user with the db_creator role to delete a database
--
grant execute on msdb..sp_delete_database_backuphistory to [OROURKE\MOSS_DM_SVC]
GO
