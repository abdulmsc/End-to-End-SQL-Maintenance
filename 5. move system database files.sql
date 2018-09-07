-- MODEL
-- alter database file locations

alter database model MODIFY FILE (name= modeldev, filename = 'F:\SQLDATA\Data\model.mdf')

alter database model modify file (name=modellog, filename='E:\SQLLOGS\Logs\modellog.ldf')

-- shutdown instance and move files and then re-start the instance.

/************************************************************************************************/
-- MSDB
-- alter database file locations

alter database msdb MODIFY FILE (name= msdbdata, filename = 'F:\SQLDATA\Data\msdbdata.mdf')

alter database msdb modify file (name=msdblog, filename='E:\SQLLOGS\Logs\msdblog.ldf')

-- shutdown instance and move files and then re-start the instance.

SELECT is_broker_enabled 
FROM sys.databases
WHERE name = N'msdb';
