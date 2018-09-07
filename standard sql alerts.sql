USE [msdb]
GO
SELECT
[s].[name] ,
[s].[event_source] ,
[s].[event_id] ,
[s].[message_id] ,
[s].[severity] ,
[s].[enabled] ,
[s].[delay_between_responses] ,
[s].[include_event_description] ,
[s].[occurrence_count] ,
[s].[has_notification]
FROM
[dbo].[sysalerts] AS s
WHERE
( message_id IN ( 823, 824, 825 )
AND [s].[delay_between_responses] <> 600
)
OR
( ENABLED = 1
AND [s].[delay_between_responses] = 0
)
ORDER BY
severity ,
message_id

-- ###############################################################################################################
USE [msdb]
GO
/****** Object: Alert [Any Filegroup is full Alert] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Any Filegroup is full Alert',
@message_id=1105,
@severity=0,
@enabled=1,
@delay_between_responses=7200,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [BobMgr Event (significant bottleneck in the disk subsystem of SQL Server)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'BobMgr Event (significant bottleneck in the disk subsystem of SQL Server)',
@message_id=0,
@severity=10,
@enabled=1,
@delay_between_responses=900,
@include_event_description_in=0,
@notification_message=N'For a full description of this event, please see the following link...
http://support.microsoft.com/kb/309392. This event occurs when there is a significant bottleneck
in the disk subsystem of SQL Server.',
@event_description_keyword=N'BobMgr::GetBuf:',
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 823 -- Hard I/O Error has occured after 4 retry attempts] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 823 -- Hard I/O Error has occured after 4 retry attempts',
@message_id=823,
@severity=0,
@enabled=1,
@delay_between_responses=7200,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 824 -- Logical Consistency error -- SQL has detected possible page corruption] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 824 -- Logical Consistency error -- SQL has detected possible page corruption',
@message_id=824,
@severity=0,
@enabled=1,
@delay_between_responses=7200,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 825 -- I/O Error -- Read/Write succeeded after at least 1 failure] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 825 -- I/O Error -- Read/Write succeeded after at least 1 failure',
@message_id=825,
@severity=0,
@enabled=1,
@delay_between_responses=7200,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 9001 (Any Database TX Log Not Available)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 9001 (Any Database TX Log Not Available)',
@message_id=0,
@severity=1,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 9002 (Any Database TX Log Full)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 9002 (Any Database TX Log Full)',
@message_id=9002,
@severity=0,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Error 9100 (Index Corruption)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Error 9100 (Index Corruption)',
@message_id=9100,
@severity=0,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 11 Error (Specified DB Object Not Found)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 11 Error (Specified DB Object Not Found)',
@message_id=0,
@severity=11,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 14 Error (Insufficient Permission)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 14 Error (Insufficient Permission)',
@message_id=0,
@severity=14,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 17 Error (Insufficient Resources Available)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 17 Error (Insufficient Resources Available)',
@message_id=0,
@severity=17,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 19 Error (Fatal Error in Resource)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 19 Error (Fatal Error in Resource)',
@message_id=0,
@severity=19,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 20 Error (Fatal Error in Current Process)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 20 Error (Fatal Error in Current Process)',
@message_id=0,
@severity=20,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 21 Error (Fatal Error in DB Processes)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 21 Error (Fatal Error in DB Processes)',
@message_id=0,
@severity=21,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 22 Error (Suspect Table Integrity)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 22 Error (Suspect Table Integrity)',
@message_id=0,
@severity=22,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 23 Error (Suspect DB Integrity)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 23 Error (Suspect DB Integrity)',
@message_id=0,
@severity=23,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 24 Error (Fatal Hardware Error)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 24 Error (Fatal Hardware Error)',
@message_id=0,
@severity=24,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/****** Object: Alert [Severity 25 Error (Fatal Error)] Script Date: 03/05/2018 09:13:04 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Severity 25 Error (Fatal Error)',
@message_id=0,
@severity=25,
@enabled=1,
@delay_between_responses=7800,
@include_event_description_in=1,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
　
