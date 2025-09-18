--EXEC [dbo].[USP_IdleTimeHistoricalDataRecurringJob]

CREATE PROCEDURE [dbo].[USP_IdleTimeHistoricalDataRecurringJob]
(
    @Date DATE = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL

)
AS
BEGIN

 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
    
	    --DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
		
		DECLARE @StartDate DATE = NULL
		
		DECLARE Cursor_Script CURSOR
        FOR SELECT Id AS ComapnyId
            FROM Company
			WHERE (@CompanyId IS NULL OR Id = @CompanyId)
         
        OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
             
            WHILE @@FETCH_STATUS = 0
            BEGIN
			
				IF(@Date IS NULL)
					SELECT @StartDate = GETDATE() - 7,@Date = GETDATE() - 7
				ELSE
					SET @StartDate = @Date

				WHILE(@StartDate <= @Date)
				BEGIN

					DELETE FROM [IdleTimeHistoricalData] 
					WHERE CreatedDateTime = @StartDate
					      AND UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

					SELECT UARS.UserId AS UserId,UARS.StartDateTime MinTrackedDateTime,UARS.TrackedDateTime MaxTrackedDateTime,IdleTimeInMin,IsLogged
					INTO #IdleTimeRecords
					FROM [UserActivityTrackerStatus] UARS
						 INNER JOIN [User] U ON U.Id = UARS.UserId AND U.CompanyId = @CompanyId
						  --LEFT JOIN (SELECT MIN(ISNULL(MinimumIdelTime,5)) AS MinimumIdelTime,UR.UserId 
								--			     			FROM ActivityTrackerRolePermission ATR
								--			     			     INNER JOIN UserRole UR ON UR.RoleId = ATR.RoleId
								--			     							AND UR.InactiveDateTime IS NULL
								--			     			                AND ATR.InActiveDateTime IS NULL
								--			     			WHERE ATR.CompanyId = @CompanyId
								--			     			GROUP BY UserId) IdleTime ON IdleTime.UserId = UARS.UserId
					 WHERE UARS.IsIdleRecord = 1 
						 AND UARS.IdleTimeInMin IS NOT NULL
						 --AND UARS.IdleTimeInMin >= ISNULL(MinimumIdelTime,5)
					     AND CONVERT(DATE,TrackedDateTime) = @StartDate

							INSERT INTO [IdleTimeHistoricalData](UserId,[Name],MinTrackedDateTime,MaxTrackedDateTime,CreatedDateTime,CompanyId,IdleTimeInMin,IsLogged,AbsoluteAppName,TrackedUrl)
							SELECT ITR.UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],ITR.MinTrackedDateTime,ITR.MaxTrackedDateTime,@StartDate,@CompanyId AS CompanyId,IdleTimeInMin,IsLogged,UAT.AbsoluteAppName,UAT.OtherApplication
							FROM #IdleTimeRecords ITR
							     INNER JOIN [User] U ON U.Id = ITR.UserId
								 LEFT JOIN UserActivityTime UAT ON UAT.UserId = ITR.UserId 
		                                   AND UAT.ApplicationStartTime = ITR.MinTrackedDateTime 
		                                   AND UAT.ApplicationEndTime = ITR.MaxTrackedDateTime 

							DROP TABLE #IdleTimeRecords

							DELETE FROM TrackerData WHERE CreatedDateTime = @StartDate AND IsIdleTime = 1
										AND UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

							DELETE FROM [UserActivityTrackerStatus] 
					        WHERE CONVERT(DATE,TrackedDateTime) = @StartDate 
					              AND UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
					
						SELECT @StartDate = DATEADD(DAY,1,@StartDate)

					END

				 SET @StartDate = NULL

				 FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
                
            END
             
        CLOSE Cursor_Script
         
        DEALLOCATE Cursor_Script

 END TRY
 BEGIN CATCH
    
    THROW

 END CATCH

END
GO
