USE MASTER
GO
EXEC msdb..sp_get_sqlagent_properties
GO


USE MASTER
GO
EXEC msdb.dbo.sp_set_sqlagent_properties 
@errorlog_file=N'E:\SQLErrorLogs\SQLAGENT.OUT'
GO
