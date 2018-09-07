--
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
--

DECLARE @SQL VARCHAR(1000), @DB SYSNAME, @database_name VARCHAR(30)= NULL;
SET @database_name = NULL; -- NULL -- or a valid database name to explicitly run on single database, in the format of 'Ola'

IF @database_name IS NULL
    BEGIN
        DECLARE database_cursor CURSOR FORWARD_ONLY STATIC
        FOR SELECT [name]
            FROM master.sys.databases
            WHERE database_id NOT IN(1, 2, 3, 4) -- ignore system databases as they are so small, not really worth doing
            AND ([name] NOT LIKE '%ReportS%' -- ignore reportserver databases
                 AND name NOT LIKE '%DBAdmin%' -- ignore the DBA specific databases
                 AND name NOT LIKE '%distribution%') -- ignore the distribution database, as this is handled by itself
            AND is_read_only != 1 -- database is NOT READ ONLY
            AND state = 0 -- online databases only!
            ORDER BY [name];
        OPEN database_cursor;
        FETCH NEXT FROM database_cursor INTO @DB;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                SELECT @SQL = 'USE ['+@DB+']'+CHAR(13)+'EXEC sp_updatestats'+CHAR(13);
                PRINT @SQL;
                EXEC (@sql);
                FETCH NEXT FROM database_cursor INTO @DB;
            END;
        CLOSE database_cursor;
        DEALLOCATE database_cursor;
    END;
    ELSE
IF @database_name IS NOT NULL
    BEGIN
        SET @SQL = 'USE ['+@database_name+']'+CHAR(13)+'EXEC sp_updatestats'+CHAR(13);
        PRINT @SQL;
        EXEC (@sql);
    END;

