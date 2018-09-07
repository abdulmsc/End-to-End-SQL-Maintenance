declare			@RC int
declare	 		@job_name varchar(128)
declare			@iscloud varchar(1)
declare			@BACKUP_LOCATION varchar(200)
declare			@backup_type VARCHAR(1)
declare			@dbname nvarchar(2000)
declare			@copy varchar(1)
declare			@freq varchar(10)
declare  			@production varchar(1)
declare 			@INCSIMPLE	varchar(1) 
declare 			@ignoredb varchar(1)
declare 			@checksum varchar(1)
declare 			@isSP varchar(1)
declare			@recipient_list	varchar(2000)
declare			@format	varchar(8) = 'FORMAT' -- noformat or format
declare			@init varchar(6) = 'INIT' -- noinit or init
declare			@operator varchar(30) -- for LOR this should be... LOR_SQL_Admin_Alerts
declare			@cred varchar(30) = NULL
declare			@mailprof varchar(30) -- for LOR this should be... EU-IT-SQL_Alerts
declare			@encrypted	bit = 0 -- (0,1) default of 0 for no encryption required 
declare			@algorithm	varchar(20) = NULL -- defaults to NULL / Valid options are... AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY
declare			@servercert	varchar(30) = NULL -- defaults to NULL
declare			@buffercount int = 30 -- can be set to any number within reason
 
select 			@job_name = 'Database Backups'
select 			@backup_location = 'E:\SQL 2008R2\SQLBACK\' --'\\darfas01\cifs_sqlbak_sata11$\DAREPMSQL01\EPM_LIVE\SQLTRN\' --
select 			@backup_type = 'F' -- 'F', 'S', 'D', 'T'
select 			@dbname ='' --  a valid database name or spaces
select			@iscloud = 'N' -- if yes, then you MUST uncommment the @cred variable and pass in a valid Azure credential
select 			@copy = 1 -- 1 or 0 -- copy only backup or not
select 			@checksum = 1 -- 1 or 0 -- create a checksum for backup integrity validation
select 			@freq = 'Daily' -- 'Weekly', 'Daily'
select 			@production = 'Y' -- 'Y', 'N' -- only use 'N' for non production instances
select 			@INCSIMPLE = 'Y' -- 'Y', 'N' -- include SIMPLE recovery model databases
select 			@ignoredb = 'N' -- 'Y' or 'N' -- if "Y" then it will ignore the databases in the @dbname parameter
select			@isSP = 'N' -- 'Y' or 'N' -- set to Y if the instance is used for SharePoint. Implemented due to extra long SP database names!
select			@recipient_list = 'haden.kingsland@cii.co.uk;'
select			@operator = 'LOR_SQL_Admin_Alerts'
-- uncommment the @cred variable and pass in a valid Azure credential if you required BLOB storage Azure backups
--select			@cred = '<your credential here>' -- uncomment this line if you need to use the iscloud option and enter your Azure BLOB storage credential
select			@mailprof = 'DBA-Alerts'
select			@encrypted = 0 -- default is 0 for not required
-- uncomment and set the below only if you require encrypted backups
--select			@algorithm = NULL -- defaults to NULL / Valid options are... AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY
--select			@servercert	= NULL -- a valid server certificate from sys.certificates for the backups
--select			@buffercount = 50

 EXECUTE @RC = [dbadmin].[dba].[generic_backup_all_databases_new] 
 @backup_location,
 @iscloud,
 @job_name,
 @backup_type,
 @dbname,
 @copy,
 @freq,
 @production,
 @INCSIMPLE,
 @ignoredb,
 @checksum,
 @isSP,
 @recipient_list,
 @format,
 @init,
 @operator,
 @cred,
 @mailprof,
 @encrypted,
 @algorithm,
 @servercert,
 @buffercount

 