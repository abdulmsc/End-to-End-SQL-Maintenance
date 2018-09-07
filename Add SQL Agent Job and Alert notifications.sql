--------------------------------------------------------
-- Add alert notification to all operators if required
--------------------------------------------------------

select 'declare	@operator sysname

select	@operator = ''DBA-Alerts''

EXEC msdb.dbo.sp_add_notification @alert_name=N''' + name + ''', @operator_name=@operator, @notification_method = 1
GO

',
       *
from   msdb.dbo.sysalerts
where  enabled = 1
       and has_notification = 0;

select *
from   msdb.dbo.sysalerts
where  enabled = 1
       and has_notification = 0;

--DECLARE @operator SYSNAME;
--SELECT @operator = 'DBA-Alerts';
--EXEC msdb.dbo.sp_add_notification 
--     @alert_name = N'Error 14420 (Log shipping Primary Server Alert)', 
--     @operator_name = @operator, 
--     @notification_method = 1;  GO   

----------------------------------------------------------------
-- Change the SQL Operator for all SQL Agent jobs if required
----------------------------------------------------------------

--Check to see if operator exists currently:
 SELECT [name], [id], [enabled] FROM msdb.dbo.sysoperators
 ORDER BY [name];

--Declare variables and set values:
 DECLARE @operator_id int

SELECT @operator_id = [id] FROM msdb.dbo.sysoperators
 WHERE name = 'DBA_Group'

--Update the affected rows with new operator_id:
 UPDATE msdb.dbo.sysjobs
 SET notify_email_operator_id = @operatorid
 FROM msdb.dbo.sysjobs
 LEFT JOIN msdb.dbo.sysoperators O
 ON msdb.dbo.sysjobs.notify_email_operator_id = O.[id] WHERE O.[id] <> @operator_id;
 
----------------- 
-- Add operator
-----------------
 
 USE [msdb]
GO
EXEC msdb.dbo.sp_add_operator @name=N'SQLAlert', 
		@enabled=1, 
		@pager_days=0, 
		@email_address=N'SQLAlert@yourcompany.com'
GO


--------------------------------------------------------
-- Update all SQL Agent Jobs with a new notification
--------------------------------------------------------

USE MSDB;
GO

DECLARE @Operator varchar(50),
	@AlertText varchar(max)

SET @Operator = 'LOR_SQL_Admin_Alerts' 
SET @AlertText = ''

SELECT  @AlertText =
	   ' EXEC msdb.dbo.sp_update_job 
		 --@job_ID = ''' + convert(varchar(50),job_id) + ''' ,
		 @job_name = [' + sj.name + '],
		 @notify_level_email = 2,
		 @notify_level_page=2, 
		@notify_email_operator_name = ''' + @operator + '''; '
		+ char(10) + @AlertText

FROM dbo.sysjobs sj where name NOT Like '%CDW%' 
--and name NOT Like '%Output%' 
--and name NOT Like '%sp_delete_back%' 
--and name NOT Like '%sp_purge_job%' 
and name NOT Like '%syspolicy%'

--Print the alert text and confirm it is valid before exec
PRINT @AlertText

--Uncomment below and comment the PRINT to exec alerts
--EXEC (@AlertText)

--USE [msdb]
--GO
--EXEC msdb.dbo.sp_update_job @job_id=N'5c57130a-eb46-459d-8a45-22c263a04994', 
--		@notify_level_email=2, 
--		@notify_level_netsend=2, 
--		@notify_level_page=2, 
--		@notify_email_operator_name=N'LOR_SQL_Admin_Alerts'
--GO
