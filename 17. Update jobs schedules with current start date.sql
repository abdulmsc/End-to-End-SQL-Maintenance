declare @scheduleid int,
		@today date

		select @today = getdate()
		print @today

DECLARE My_Cursor CURSOR

FOR
select js.schedule_id from
msdb.dbo.sysjobschedules js
inner join msdb.dbo.sysjobs s
on js.job_id = s.job_id 

OPEN My_Cursor

FETCH NEXT FROM My_Cursor INTO @scheduleid

WHILE (@@FETCH_STATUS <> -1)

BEGIN

EXEC msdb.dbo.sp_update_schedule @schedule_id=@scheduleid, 
		@active_start_date= 20180906

FETCH NEXT FROM My_Cursor INTO @scheduleid
END 

CLOSE My_Cursor

DEALLOCATE My_Cursor