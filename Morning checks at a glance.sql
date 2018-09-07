use [DBAdmin]
GO
exec [dba].[usp_quick_check_for_failed_agent_jobs]
exec [dba].[usp_quick_check_for_latest_backups]
exec [dba].[usp_quick_check_SQL_services_no_email]
exec [dba].[usp_quick_check_user_info]
exec [dba].[usp_quick_glance_db_health_status]