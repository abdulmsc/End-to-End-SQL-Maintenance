-- script to move current TEMPDB files and add new files (will need to extend this to match number of cores/CPU on a case by case basis).

USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', filename = 'E:\TEMPDB\tempdb.mdf',
SIZE = 2048MB , MAXSIZE = 4096MB , FILEGROWTH = 64MB )
GO

ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'E:\TEMPDB\tempdev2.ndf' , 
SIZE = 2048MB , MAXSIZE = 4096MB , FILEGROWTH = 64MB )
GO

ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', FILENAME = N'E:\TEMPDB\templog.ldf' , 
SIZE = 2048MB , MAXSIZE = 4096MB , FILEGROWTH = 64MB )
GO