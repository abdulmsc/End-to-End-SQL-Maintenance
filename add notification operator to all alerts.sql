DECLARE @operator SYSNAME;    
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Any Filegroup is full Alert', 
     @operator_name = @operator, 
     @notification_method = 1;  

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'BobMgr Event (significant bottleneck in the disk subsystem of SQL Server)', 
     @operator_name = @operator, 
     @notification_method = 1; 

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 823 -- Hard I/O Error has occured after 4 retry attempts', 
     @operator_name = @operator, 
     @notification_method = 1; 

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 824 -- Logical Consistency error -- SQL has detected possible page corruption', 
     @operator_name = @operator, 
     @notification_method = 1; 

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 825 -- I/O Error -- Read/Write succeeded after at least 1 failure', 
     @operator_name = @operator, 
     @notification_method = 1; 

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 9001 (Any Database TX Log Not Available)', 
     @operator_name = @operator, 
     @notification_method = 1; 

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 9002 (Any Database TX Log Full)', 
     @operator_name = @operator, 
     @notification_method = 1;  

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Error 9100 (Index Corruption)', 
     @operator_name = @operator, 
     @notification_method = 1;  

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 11 Error (Specified DB Object Not Found)', 
     @operator_name = @operator, 
     @notification_method = 1;  

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 14 Error (Insufficient Permission)', 
     @operator_name = @operator, 
     @notification_method = 1;  

--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 17 Error (Insufficient Resources Available)', 
     @operator_name = @operator, 
     @notification_method = 1;  GO
--DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 19 Error (Fatal Error in Resource)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 20 Error (Fatal Error in Current Process)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 21 Error (Fatal Error in DB Processes)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 22 Error (Suspect Table Integrity)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 23 Error (Suspect DB Integrity)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 24 Error (Fatal Hardware Error)', 
     @operator_name = @operator, 
     @notification_method = 1;  

DECLARE @operator SYSNAME;
SELECT @operator = 'DBA-Alerts';
EXEC msdb.dbo.sp_add_notification 
     @alert_name = N'Severity 25 Error (Fatal Error)', 
     @operator_name = @operator, 
     @notification_method = 1;  
