-- always set this up and ask for a dedicated DBA email distribution group to be set up, to contain all DBA's in a company

USE [msdb]
GO

/****** Object:  Operator [DBA-Alerts]    Script Date: 06/09/2018 12:35:07 ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBA-Alerts', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'SQL-DBA-Alerts@cii.co.uk', 
		@category_name=N'[Uncategorized]'
GO


