
DECLARE @CoreCount INT;
DECLARE @NumaNodes INT;
DECLARE @MaxDOP INT;
SET @CoreCount =
(
    SELECT i.cpu_count
    FROM sys.dm_os_sys_info i
);
SET @NumaNodes =
(
    SELECT MAX(c.memory_node_id) + 1
    FROM sys.dm_os_memory_clerks c
    WHERE memory_node_id < 64
);
IF @CoreCount > 4

/* If less than 5 cores, don't bother. */

    BEGIN

        /* 3/4 of Total Cores in Machine */

        SET @MaxDOP = @CoreCount * 0.75;

/* if @MaxDOP is greater than the per NUMA node
       Core Count, set @MaxDOP = per NUMA node core count
    */

        IF @MaxDOP > (@CoreCount / @NumaNodes)
            SET @MaxDOP = (@CoreCount / @NumaNodes) * 0.75;

/*
        Reduce @MaxDOP to an even number 
    */

        SET @MaxDOP = @MaxDOP - (@MaxDOP % 2);
        --PRINT @maxdop;

        /* Cap MAXDOP at 8, according to Microsoft */

        IF @MaxDOP > 8
            SET @MaxDOP = 8;
        --PRINT @@servername  
		select 'maxdop should be set to...' + convert(varchar(2),@maxdop);
        --exec sp_configure 'max degree of parallelism',@maxdop;
        --RECONFIGURE WITH OVERRIDE;

    END;
    ELSE
    BEGIN
        SET @maxdop = 0;
        --PRINT @@servername
		select  @maxdop;
        --exec sp_configure 'max degree of parallelism',@maxdop;
        --RECONFIGURE WITH OVERRIDE;

    END;