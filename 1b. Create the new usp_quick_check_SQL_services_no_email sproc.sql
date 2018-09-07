USE [DBAdmin]
GO
/****** Object:  StoredProcedure [dba].[usp_quick_check_SQL_services]    Script Date: 07/09/2018 14:20:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			8th July 2011
--
-- Description :	To show sql and physical server details upon instance restart
--					so that we have visibility of unexpected issues with servers and
--					services.
--					The Windows uptime.exe executable MUST be installed in the 
--					Windows\System32 area of the O/S for this to work, and 
--					xp_cmdshell must be configured for this to be run!
--
--					The calling SQL Agent job Schedule Type must be set to ...
--					"Start automatically when SQL Server Agent starts" so that 
--					the job runs upon instance startup.
--
--					This script is invoked by the following named SQL Agent job 
--					in all instances ...
--					"Report Server/Service Status upon system restart"
--
--					This procedure uses the following extended stored procedures ...
--
--					xp_servicecontrol (undocumented procedure -- Use with care!!)
--					xp_regread
--					xp_cmdshell
--
--					The uptime.exe executable MUST be copied into the C:\Windows\System32 and C:\Windows\SysWOW64
--					areas on the servers this runs against.
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
--exec [dba].[usp_quick_check_SQL_services_no_email]

alter procedure [dba].[usp_quick_check_SQL_services_no_email]

AS

BEGIN

DECLARE		@MailProfileName VARCHAR(50),		
			@ERR_MESSAGE varchar(200),
			@ERR_NUM int,
			@MESSAGE_BODY varchar(2000),
			@MESSAGE_BODY2 varchar(1000),
			@p_error_description varchar(300),
			@job_name varchar(80),
			@NewLine CHAR(2),
			@Q CHAR(1),
			@recipient_list	varchar(1000),
			@email varchar(100),
			@value varchar(30),
			@mailsubject varchar(200),
			@propertyid int,
			@userid bigint, 
			@property_value varchar(1000),
			@output VARCHAR(1000),
			@ChkInstanceName nvarchar(128), /*Stores SQL Instance Name*/
			@ChkSrvName nvarchar(128), /*Stores Server Name*/
			@TrueSrvName nvarchar(128), /*Stores instance name of MSSQLSERVER for default instances*/
			@SQLSrv NVARCHAR(128), /*Stores server name*/
			@PhysicalSrvName NVARCHAR(128), /*Stores physical name*/
			@FTS nvarchar(128), /*Stores Full Text Search Service name*/
			@RS nvarchar(128), /*Stores Reporting Service name*/
			@SQLAgent NVARCHAR(128), /*Stores SQL Agent Service name*/
			@OLAP nvarchar(128), /*Stores Analysis Service name*/
			@REGKEY NVARCHAR(128), /*Stores Registry Key information*/
			@PhysicalSrverName VARCHAR(128),
			@ServerName VARCHAR(128),
			@ServiceName VARCHAR(128),
			@ServiceStatus VARCHAR(128),
			@StatusDateTime DATETIME,
			@XPCMDSH_ORIG_ON varchar(1),
			@failsafe VARCHAR(100);

SET @NewLine = CHAR(13) + CHAR(10) 
SET @Q = CHAR(39) 

-- initialize variables (otherwise concat fails because the variable value is NULL)

SET @output = ''
set @XPCMDSH_ORIG_ON = ''

--------------------------------------------------------------------------------------------------------------------
-- Check whether xp_cmdshell is turned off via Surface Area Configuration (2005) / Instance Facets (2008)
-- This is best practice !!!!! If it is already turned on, LEAVE it on !!

-- turn on advanced options
	EXEC sp_configure 'show advanced options', 1 reconfigure 
	RECONFIGURE  

	CREATE TABLE #advance_opt (name VARCHAR(20),min int, max int, conf int, run int)
			INSERT #advance_opt
		EXEC sp_configure 'xp_cmdshell' -- this will show whether it is turned on or not
				
	IF (select conf from #advance_opt) = 0 -- check if xp_cmdshell is turned on or off, if off, then turn it on
		BEGIN

			set @XPCMDSH_ORIG_ON = 'N' -- make a note that it is NOT supposed to be on all the time
			
			--turn on xp_cmdshell to allow operating system commands to be run
			EXEC sp_configure 'xp_cmdshell', 1 reconfigure
			RECONFIGURE
		END
	ELSE
		BEGIN
		 -- make a note that xp_cmdshell was already turned on, so not to turn it off later by mistake
			set @XPCMDSH_ORIG_ON = 'Y'
		END

-- drop the temporary table to tidy up after ourselves.

	IF EXISTS (
	select * from tempdb.sys.objects
	where name like '%advance_opt%'
	)
		BEGIN
			drop table #advance_opt
		END
		
--------------------------------------------------------------------------------------------------------------------

--	CREATE TABLE #ServicesServiceStatus /*Create temp tables*/
--(
--RowID INT IDENTITY(1,1)
--,ServerName VARCHAR(60)
--,ServiceName VARCHAR(60)
--,ServiceStatus varchar(60)
--,StatusDateTime DATETIME DEFAULT (GETDATE())
--,PhysicalSrverName VARCHAR(60)
--)

	IF SERVERPROPERTY('ISCLUSTERED') = 1
	BEGIN
	
		select 'SQL Server is currently running on the following Cluster node ...'
					  + CONVERT(VARCHAR(30), SERVERPROPERTY('ComputerNamePhysicalNetBIOS'))       
	END
	

					--SELECT SERVERPROPERTY('ComputerNamePhysicalNetBIOS')
					--SELECT SERVERPROPERTY('SERVERNAME')
					--SELECT SERVERPROPERTY('MACHINENAME')
					--SELECT SERVERPROPERTY('ISCLUSTERED')
	BEGIN TRY

-- get all installed features, status and time checked here ...
-- Derived from here ... 
-- http://pawansingh1431.blogspot.com/2011/02/check-what-are-sql-components-installed.html

CREATE TABLE #RegResult
(
ResultValue NVARCHAR(4)
)
CREATE TABLE #ServicesServiceStatus /*Create temp tables*/
(
RowID INT IDENTITY(1,1)
,ServerName VARCHAR(60)
,ServiceName VARCHAR(60)
,ServiceStatus varchar(60)
,StatusDateTime DATETIME DEFAULT (GETDATE())
,PhysicalSrverName VARCHAR(60)
)

IF SERVERPROPERTY('IsClustered') = 1
BEGIN
	SET @PhysicalSrvName = CAST(SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS VARCHAR(128))
END
ELSE
BEGIN
	SET @PhysicalSrvName = CAST(SERVERPROPERTY('MachineName') AS VARCHAR(128))
END

-- Show instance UPTIME by querying TEMPDB for creation date
--	select create_Date from sys.databases where name = 'tempdb'
--
 INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'UPTIME' )
	    UPDATE  #ServicesServiceStatus
        SET     ServiceName = @@SERVICENAME
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @@SERVERNAME
        WHERE   RowID = @@identity
		UPDATE #ServicesServiceStatus
		set StatusDateTime = (select create_Date from sys.databases where name = 'tempdb')
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity


SET @ChkSrvName =  CAST(SERVERPROPERTY('INSTANCENAME') AS VARCHAR(128))
SET @ChkInstanceName = @@serverName
IF @ChkSrvName IS NULL /*Detect default or named instance*/ 
    BEGIN
        SET @TrueSrvName = 'MSSQLSERVER (DEFAULT)'
        SELECT  @OLAP = 'MSSQLServerOLAPService' /*Setting up proper service name*/
        SELECT  @FTS = 'MSFTESQL'
        SELECT  @RS = 'ReportServer'
        SELECT  @SQLAgent = 'SQLSERVERAGENT'
        SELECT  @SQLSrv = 'MSSQLSERVER'
    END
ELSE 
    BEGIN
        SET @TrueSrvName = CAST(SERVERPROPERTY('INSTANCENAME') AS VARCHAR(128))
        SET @SQLSrv = '$' + @ChkSrvName
        SELECT  @OLAP = 'MSOLAP' + @SQLSrv /*Setting up proper service name*/
        SELECT  @FTS = 'MSFTESQL' + @SQLSrv
        SELECT  @RS = 'ReportServer' + @SQLSrv
        SELECT  @SQLAgent = 'SQLAgent' + @SQLSrv
        SELECT  @SQLSrv = 'MSSQL' + @SQLSrv
    END
/* ---------------------------------- SQL Server Service Section ----------------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\' + @SQLSrv
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of SQL Sever service*/
                EXEC xp_servicecontrol N'QUERYSTATE', @SQLSrv
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'MS SQL Server Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'MS SQL Server Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- SQL Server Agent Service Section -----------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\' + @SQLAgent
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of SQL Agent service*/
                EXEC xp_servicecontrol N'QUERYSTATE', @SQLAgent
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'SQL Server Agent Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @SQLAgent
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'SQL Server Agent Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @SQLAgent
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- SQL Browser Service Section ----------------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\SQLBrowser'
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of SQL Browser Service*/
                EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', N'sqlbrowser'
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'SQL Browser Service - Instance Independent'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'SQL Browser Service - Instance Independent'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- Integration Service Section ----------------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\MsDtsServer'
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of Intergration Service*/
                EXEC master.dbo.xp_servicecontrol N'QUERYSTATE',
                    N'MsDtsServer'
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Intergration Service - Instance Independent'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Intergration Service - Instance Independent'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- Reporting Service Section ------------------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\' + @RS
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of Reporting service*/
                EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', @RS
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Reporting Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Reporting Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- Analysis Service Section -------------------------------------------------*/
IF @ChkSrvName IS NULL /*Detect default or named instance*/ 
    BEGIN
        SET @OLAP = 'MSSQLServerOLAPService'
    END
ELSE 
    BEGIN
        SET @OLAP = 'MSOLAP' + '$' + @ChkSrvName
        SET @REGKEY = 'System\CurrentControlSet\Services\' + @OLAP
    END
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of Analysis service*/
                EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', @OLAP
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Analysis Services'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Analysis Services'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
/* ---------------------------------- Full Text Search Service Section -----------------------------------------*/
SET @REGKEY = 'System\CurrentControlSet\Services\' + @FTS
INSERT  #RegResult
        ( ResultValue 
        )
        EXEC master.sys.xp_regread @rootkey = 'HKEY_LOCAL_MACHINE',
            @key = @REGKEY
IF ( SELECT ResultValue
     FROM   #RegResult
   ) = 1 
    BEGIN
        INSERT  #ServicesServiceStatus
                ( ServiceStatus
                ) /*Detecting status of Full Text Search service*/
                EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', @FTS
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Full Text Search Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
ELSE 
    BEGIN
        INSERT  INTO #ServicesServiceStatus
                ( ServiceStatus )
        VALUES  ( 'NOT INSTALLED' )
        UPDATE  #ServicesServiceStatus
        SET     ServiceName = 'Full Text Search Service'
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     ServerName = @TrueSrvName
        WHERE   RowID = @@identity
        UPDATE  #ServicesServiceStatus
        SET     PhysicalSrverName = @PhysicalSrvName
        WHERE   RowID = @@identity
        TRUNCATE TABLE #RegResult
    END
    
/* ---------------------------------- End of Server Component Checks -----------------------------------------*/
--
-- Uncomment this section to use for debug purposes if you are getting no date
--
	   --SELECT   PhysicalSrverName ,
				--ServerName ,
				--ServiceName ,
				--ServiceStatus ,
				--StatusDateTime
	   --FROM     #ServicesServiceStatus

--
-- Declare the cursor to read the results from the above Server Component Checks and format
-- them for HTML.
--

			SELECT  PhysicalSrverName ,
					ServerName ,
					ServiceName ,
					ServiceStatus ,
					StatusDateTime
			FROM     #ServicesServiceStatus


	END TRY

	BEGIN CATCH
	
	--		SELECT @ERR_MESSAGE = ERROR_MESSAGE(), @ERR_NUM = ERROR_NUMBER();
	--		SET @MESSAGE_BODY='Error running the ''Server & Service Status upon system restart'' script ' 
	--		+  '. Error Code is ... ' + RTRIM(CONVERT(CHAR(10),@ERR_NUM)) + ' Error Message is ... ' + @ERR_MESSAGE
	--		SET @MESSAGE_BODY2='Failure of Report Server & Service Status upon system restart Check script within the ' 
	--		+ LTRIM(RTRIM(cast(@@SERVERNAME as VARCHAR(30)))) + ' instance'
	--		SET @MESSAGE_BODY = @MESSAGE_BODY -- + @MESSAGE_BODY3

	--		EXEC msdb.dbo.sp_notify_operator 
	--			@profile_name = @MailProfileName, 
	--			@name=N'DBA-Alerts',
	--			@subject = @MESSAGE_BODY2, 
	--			@body= @MESSAGE_BODY
	
	-- If for some reason this script fails, check for any temporary
	-- tables created during the run and drop them for next time.
	
       IF EXISTS ( SELECT   *
                   FROM     tempdb.sys.objects
                   WHERE    name = '#ServicesServiceStatus' ) 
        BEGIN
            DROP TABLE #ServicesServiceStatus
        END
        
       IF EXISTS ( SELECT   *
                   FROM     tempdb.sys.objects
                   WHERE    name = '#RegResult' ) 
        BEGIN
            DROP TABLE #RegResult
        END
	
	
	END CATCH

-----------------------------------------------------------------------------------------------------------------------		
-- turn off advanced options

	IF @XPCMDSH_ORIG_ON = 'N'  -- if xp_cmdshell was NOT originally turned on, then turn it off 
	BEGIN

		--  turn off xp_cmdshell to dis-allow operating system commands to be run
		EXEC sp_configure 'xp_cmdshell', 0  reconfigure
		RECONFIGURE

		EXEC sp_configure 'show advanced options', 0 reconfigure
		RECONFIGURE
		
		 
	END
-----------------------------------------------------------------------------------------------------------------------
--
-- Cleanup after ourselves!!
--
	DROP TABLE #ServicesServiceStatus 
	DROP TABLE #RegResult 

END;