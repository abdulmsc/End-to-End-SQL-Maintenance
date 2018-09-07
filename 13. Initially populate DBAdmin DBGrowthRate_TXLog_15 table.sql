--Create Table dbadmin.dbo.DBGrowthRate_TXLog_15
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
into #TempDBSizeTXLOG
from sys.databases sd
join sys.master_files mf
on sd.database_ID = mf.database_ID
where type_desc = 'LOG'
Order by mf.database_id, sd.name

Insert into dbadmin.dbo.DBGrowthRate_TXLog_15
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
(Select Distinct DBID from dbadmin.dbo.DBGrowthRate_TXLog_15
where db_id(DBName) = tds.database_ID)
group by tds.database_ID, tds.DBName)

Drop table #TempDBSizeTXLOG

--truncate table DBAdmin.[dbo].[DBGrowthRate_Data]
--truncate table DBAdmin.[dbo].[DBGrowthRate_TXLog_15]

Use [DBAdmin];

Select * from DBAdmin.[dbo].[DBGrowthRate_TXLog_15]
order by DBName, MetricDate desc;
