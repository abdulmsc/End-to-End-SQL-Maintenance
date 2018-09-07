-- Run in SQLCMD mode
-- Update to the correct SVC Account for your environment :setvar SVC "OROURKE\EU-IT-???_SVC"

USE [master]
GO

if not exists (select principal_id from sys.server_principals where name = '$(SVC)' and type = 'U')
	CREATE LOGIN [$(SVC)] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english] GO

use master
grant view server state to [$(SVC)]
GRANT VIEW ANY DEFINITION TO[$(SVC)]
