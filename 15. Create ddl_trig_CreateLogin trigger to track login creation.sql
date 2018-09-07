-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			8th July 2011
--
-- Description :	Create ddl_trig_CreateLogin trigger to track login creation
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


IF  EXISTS (SELECT * FROM master.sys.server_triggers WHERE parent_class_desc = 'SERVER' AND name = N'ddl_trig_CreateLogin')
DROP TRIGGER [ddl_trig_CreateLogin] ON ALL SERVER
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create TRIGGER ddl_trig_CreateLogin
ON ALL SERVER
FOR CREATE_LOGIN, DROP_LOGIN
AS
   -- Declare variables
   DECLARE @mailSubject Nvarchar(100);
   DECLARE @mailBody Nvarchar(MAX);
   DECLARE @data XML;
   DECLARE @text Nvarchar(max);
   DECLARE @user Nvarchar(max);
   DECLARE @newuser NVARCHAR(MAX);
   SET @data = EVENTDATA();
   SET @newuser = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(max)');
   SET @user = @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(max)');
   SET @text = @data.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(max)')
   
   ---- Set the email data
   SET @mailSubject = 'Warning!! -- DDL Login activity has been detected on: ' + @@SERVERNAME;
   SET @mailBody = 'The following DDL login activity has occured on the SQL Server: <b>'  + @@SERVERNAME 
			   + '</b>' 
			   + '<p>' 
			   + 'Activity was for login: <b> ' + ISNULL(@newuser, 'Null User Name')
			   + '</b>'
			   + '</p>' 
			   + '<p>' 
			   + 'The script run against the instance was <b>' + ISNULL(@text, 'Null SQL') 
			   + '</b>' 
			   + '</p>' 
			   + ' ... which was actioned by user: <b>' + ISNULL(@user, 'Null')
			   + '</b>' 
			   + '<p>' 
			   + ' ... at: <b>' + CONVERT(nvarchar, getdate(), 13) + '
               ' + '</p>' 
			   + 'Please contact the user ' + @user + ' to find out why this was created!' 
			   + ' </b>' ;

EXEC msdb.dbo.sp_send_dbmail
 @profile_name = 'EU-IT-SQL_Alerts',
 @recipients = 'hkingsland@laingorourke.com;lwalker@laingorourke.com',
 @body = @mailBody,
 @subject = @mailSubject,
 @exclude_query_output = 1, --Suppress 'Mail Queued' message
 @body_format = HTML;
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--drop trigger [ddl_trig_CreateLogin] on all server

--ENABLE TRIGGER [ddl_trig_database] ON ALL SERVER
--GO
