
exec dbadmin.dba.usp_create_DBA_operator 'yourname@youremail.com'

--USE [msdb]
--GO

--/****** Object:  Operator [Haden Kingsland]    Script Date: 03/20/2014 11:17:15 ******/
--EXEC msdb.dbo.sp_add_operator @name=N'Haden Kingsland', 
--		@enabled=1, 
--		@weekday_pager_start_time=90000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=90000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=90000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=0, 
--		@email_address=N'hkingsland@laingorourke.com;rfinney@laingorourke.com', 
--		@category_name=N'[Uncategorized]'
--GO

--/****** Object:  Operator [LOR_SQL_Admin_Alerts]    Script Date: 03/20/2014 11:17:15 ******/
--EXEC msdb.dbo.sp_add_operator @name=N'LOR_SQL_Admin_Alerts', 
--		@enabled=1, 
--		@weekday_pager_start_time=80000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=80000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=80000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=127, 
--		@email_address=N'eu-it-sql_alerts@laingorourke.com', 
--		@category_name=N'[Uncategorized]'
--GO

--/****** Object:  Operator [Rob Finney]    Script Date: 03/20/2014 11:17:15 ******/
--EXEC msdb.dbo.sp_add_operator @name=N'Rob Finney', 
--		@enabled=1, 
--		@weekday_pager_start_time=90000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=90000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=90000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=0, 
--		@email_address=N'rfinney@laingorourke.com', 
--		@category_name=N'[Uncategorized]'
--GO


