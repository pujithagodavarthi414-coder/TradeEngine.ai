--Date : 2020-12-11
--For UserActivity time historical job--
DECLARE @CompanyId UNIQUEIDENTIFIER,@RunDate DATETIME

SELECT * 
INTO #Historicaldata
FROM (
SELECT CreatedDateTime,CompanyId 
FROM UserActivityHistoricalData 
GROUP BY CreatedDateTime,CompanyId
) T

    DECLARE Cursor_Script CURSOR
        FOR SELECT * FROM (
			SELECT U.CompanyId,UA.CreatedDateTime
			FROM UserActivityTime UA
			INNER JOIN [User] U ON U.Id = UA.UserId
			WHERE UA.CreatedDateTime <= CONVERT(DATE,GETDATE() - 7)
			GROUP BY U.CompanyId,UA.CreatedDateTime
			) T
         
        OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId,@RunDate
             
            WHILE @@FETCH_STATUS = 0
            BEGIN
               
			   IF(NOT EXISTS(SELECT 1 FROM #Historicaldata WHERE CompanyId = @CompanyId AND CreatedDateTime = @RunDate))
			   BEGIN
						--SELECT @CompanyId CompanyId,@RunDate RunDate
						EXEC [USP_UserActivityHistoricalDataRecurringJob] @CompanyId,@RunDate,@RunDate
			   END

			   FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId,@RunDate
                
            END
             
        CLOSE Cursor_Script
         
        DEALLOCATE Cursor_Script

		DROP TABLE #Historicaldata

--For Idle time historical job--

DECLARE @CompanyId UNIQUEIDENTIFIER,@RunDate DATETIME

SELECT * 
INTO #Historicaldata
FROM (
SELECT CreatedDateTime,CompanyId 
FROM IdleTimeHistoricalData 
GROUP BY CreatedDateTime,CompanyId
) T

    DECLARE Cursor_Script CURSOR
        FOR SELECT * FROM (
			SELECT U.CompanyId,UA.CreatedDateTime
			FROM UserActivityTrackerStatus UA
			INNER JOIN [User] U ON U.Id = UA.UserId
			WHERE CONVERT(DATE,UA.TrackedDateTime) <= CONVERT(DATE,GETDATE() - 7)
			GROUP BY U.CompanyId,UA.CreatedDateTime
			) T
         
        OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId,@RunDate
             
            WHILE @@FETCH_STATUS = 0
            BEGIN
               
			   IF(NOT EXISTS(SELECT 1 FROM #Historicaldata WHERE CompanyId = @CompanyId AND CreatedDateTime = @RunDate))
			   BEGIN
						--SELECT @CompanyId CompanyId,@RunDate RunDate
						EXEC [USP_IdleTimeHistoricalDataRecurringJob] @RunDate,@CompanyId
			   END

			   FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId,@RunDate
                
            END
             
        CLOSE Cursor_Script
         
        DEALLOCATE Cursor_Script

		DROP TABLE #Historicaldata