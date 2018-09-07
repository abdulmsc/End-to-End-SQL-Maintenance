-- ###########################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			07/09/2018
--
-- Description :	Configuring Database Mail
--
--                  ##########################################################################
--					IMPORTANT -- You MUST change the email addresses required and SMTP server
--					to match your current Company!
--                  ##########################################################################
--
-- ############################################################################################

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

-- #####################################################################
-- Create the fail safe operator ... LOR_SQL_Admin_Alerts
-- #####################################################################

USE [msdb]
GO
EXEC msdb.dbo.sp_add_operator @name=N'DBA-Alerts', 
		@enabled=1, 
		@pager_days=0, 
		@email_address=N'SQL-DBA-Alerts@cii.co.uk'

-- #####################################################################
-- Turn on database mail
-- #####################################################################

exec sp_configure 'show advanced options', 1
reconfigure
exec sp_configure 'Database Mail XPs', 1
reconfigure 

-- #####################################################################
-- Create default DBA database mail account and profile
-- #####################################################################

-- ########################### ADD Database Mail #######################

		DECLARE	@profile_id				sysname,
				@principal_id			INT,
				@principal_sid			INT,
				@role_principal_id		INT,
				@account_id				INT,
				@user_name				VARCHAR(255)


	/**************************************************/
	/*		            Add new profile               */
	/**************************************************/

		SELECT @profile_id = profile_id 
		  FROM msdb.dbo.sysmail_profile WITH (NOLOCK)
		 WHERE name = 'DBA-Alerts'

		IF @profile_id IS NULL
		   BEGIN
			   EXEC msdb.dbo.sysmail_add_profile_sp 
					@profile_name	= 'DBA-Alerts',
					@description	= 'DBA-Alerts',
					@profile_id		= @profile_id OUTPUT
		   END

	/**************************************************/
	/*		            Add new account               */
	/**************************************************/

		SELECT @account_id = account_id
		  FROM msdb.dbo.sysmail_account WITH (NOLOCK)
		 WHERE name	= 'SQL-DBA-Alerts'

		IF @account_id IS NULL
		   BEGIN
			   EXEC msdb.dbo.sysmail_add_account_sp  
					@account_name		= 'DBA-Alerts',
					@email_address		= 'SQL-DBA-Alerts@cii.co.uk',
					@display_name		= 'DBA-Alerts',
				    @description		= 'DBA-Alerts',
					@mailserver_name	= 'mailrelay@cii.co.uk', -- change this match your current Company!!!!!
					@mailserver_type	= 'SMTP',
					@port				= 25,
					@account_id			= @account_id OUTPUT
		   END


	/**************************************************/
	/*		   Add profile / account association      */
	/**************************************************/

		IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysmail_profileaccount WITH (NOLOCK)
						WHERE profile_id = @profile_id
						  AND account_id = @account_id)
		   BEGIN
			   EXEC msdb.dbo.sysmail_add_profileaccount_sp
					@profile_name		= 'DBA-Alerts',
					@account_name		= 'DBA-Alerts',
					@sequence_number	= 1
		   END


-- #################################

-- For each user that is required to send email, other than any sysadmin users, 
-- you will need to assign the following role ....

--USE [msdb]
--GO
--EXEC sp_addrolemember N'DatabaseMailUserRole', N'your user'
--GO

-- ####################

-- ###############################################################################
-- Add the fail safe operator to an instance and set use job tokens for WMI to on
-- ###############################################################################

USE [msdb]
GO
EXEC master.dbo.sp_MSsetalertinfo @failsafeoperator = N'DBA-Alerts',
    @notificationmethod = 1
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder = 1,
    @alert_replace_runtime_tokens = 1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE',
    N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail',
    N'REG_DWORD', 1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE',
    N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile',
    N'REG_SZ', N'DBA-Alerts'
GO
