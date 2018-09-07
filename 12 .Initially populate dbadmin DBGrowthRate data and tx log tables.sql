-- ###################################################################################
--
-- Author:			Haden Kingsland
--
-- Date:			8th July 2011
--
-- Description :	Initially populate dbadmin DBGrowthRate data and tx log tables
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


--Create Table dbadmin.dbo.DBGrowthRate_Data
--(DBGrowthID int identity(1,1), 
--DBName varchar(100), 
--DBID int,
--NumPages int, 
--OrigSize decimal(10,2), 
--CurSize decimal(10,2), 
--GrowthAmt varchar(100), 
--MetricDate datetime)

--Create Table dbadmin.dbo.DBGrowthRate_TXLog
--(DBGrowthID int identity(1,1), 
--DBName varchar(100), DBID int,
--NumPages int, 
--OrigSize decimal(10,2), 
--CurSize decimal(10,2), 
--GrowthAmt varchar(100), 
--MetricDate datetime)

Select sd.name as DBName, 
mf.name as FileName, 
mf.database_id, 
file_id, 
size
into #TempDBSizeDATA
from sys.databases sd
join sys.master_files mf
on sd.database_ID = mf.database_ID
where type_desc != 'LOG'
Order by mf.database_id, sd.name

select * from #TempDBSizeDATA

Insert into dbadmin.dbo.DBGrowthRate_Data
( DBName,DBID,
NumPages, 
OrigSize, 
CurSize, 
GrowthAmt, 
MetricDate)
(Select  
tds.DBName,tds.database_ID, 
Sum(tds.Size) as NumPages, 
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as OrigSize,
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as CurSize,
'0.00 MB' as GrowthAmt, GetDate() as MetricDate
from #TempDBSizeDATA tds
where tds.database_ID not in 
(Select Distinct DBID from dbadmin.dbo.DBGrowthRate_Data
where db_id(DBName) = tds.database_ID)
group by tds.database_ID, tds.DBName)

Select sd.name as DBName, 
mf.name as FileName, 
mf.database_id, 
file_id, 
size
into #TempDBSizeTXLOG
from sys.databases sd
join sys.master_files mf
on sd.database_ID = mf.database_ID
where type_desc = 'LOG'
Order by mf.database_id, sd.name

Insert into dbadmin.dbo.DBGrowthRate_TXLog
( DBName,DBID,
NumPages, 
OrigSize, 
CurSize, 
GrowthAmt, 
MetricDate)
(Select  
 tds.DBName,tds.database_ID,
Sum(tds.Size) as NumPages, 
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as OrigSize,
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as CurSize,
'0.00 MB' as GrowthAmt, GetDate() as MetricDate
from #TempDBSizeTXLOG tds
where tds.database_ID not in 
(Select Distinct DBID from dbadmin.dbo.DBGrowthRate_TXLog
where db_id(DBName) = tds.database_ID)
group by tds.database_ID, tds.DBName)

Drop table #TempDBSizeDATA
Drop table #TempDBSizeTXLOG

--truncate table DBAdmin.[dbo].[DBGrowthRate_Data]
--truncate table DBAdmin.[dbo].[DBGrowthRate_TXLog]

Use [DBAdmin];

Select * from DBAdmin.[dbo].[DBGrowthRate_Data]
order by DBName, MetricDate desc

Select * from DBAdmin.[dbo].[DBGrowthRate_TXLog]
order by DBName, MetricDate desc;
