-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			07/09/2018
--
-- Description :	To create ta tigger to show when a databas is deleted
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
/****** Object:  DdlTrigger [ddl_trig_database_drop]    Script Date: 08/13/2013 09:00:30 ******/
IF  EXISTS (SELECT * FROM master.sys.server_triggers WHERE parent_class_desc = 'SERVER' AND name = N'ddl_trig_database_drop')
DROP TRIGGER [ddl_trig_database_drop] ON ALL SERVER
GO

/****** Object:  DdlTrigger [ddl_trig_database_drop]    Script Date: 08/13/2013 09:00:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create TRIGGER [ddl_trig_database_drop] 
ON ALL SERVER 
FOR DROP_DATABASE 
AS 
declare @results varchar(max)
declare @subjectText varchar(max)
declare @databaseName VARCHAR(255)
SET @subjectText = 'DATABASE deleted on ' + @@SERVERNAME + ' by ' + SUSER_SNAME() 
SET @results = 
  (SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)'))
SET @databaseName = (SELECT EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'VARCHAR(255)'))

--Uncomment the below line if you want to not be alerted on certain DB names
--IF @databaseName NOT LIKE '%Snapshot%'
EXEC msdb.dbo.sp_send_dbmail
 @profile_name = 'EU-IT-SQL_Alerts',
 @recipients = 'hkingsland@laingorourke.com',
 @body = @results,
 @subject = @subjectText,
 @exclude_query_output = 1 --Suppress 'Mail Queued' message

	--DECLARE @MESSAGE varchar(255)
	--SELECT @MESSAGE = 'DATABASE DROP ' + EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
 --EXEC xp_logevent 60000, @MESSAGE, informational
 --EXEC xp_logevent 60000, 'TEST', informational
 --rollback
 --print @message

GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ENABLE TRIGGER [ddl_trig_database_drop] ON ALL SERVER
GO


