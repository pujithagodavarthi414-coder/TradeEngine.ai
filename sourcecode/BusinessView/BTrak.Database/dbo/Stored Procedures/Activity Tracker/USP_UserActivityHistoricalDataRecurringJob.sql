--EXEC [dbo].[USP_UserActivityHistoricalDataRecurringJob] '412BC999-70F2-425C-9AF4-BAFC1539B2B8','2020-08-14','2020-08-14'
CREATE PROCEDURE [dbo].[USP_UserActivityHistoricalDataRecurringJob]
(
	@CompanyId UNIQUEIDENTIFIER = NULL
	,@DateFrom DATE = NULL
	,@DateTo DATE = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
    SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN TRY
		
		--DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
		
        DECLARE Cursor_Script CURSOR
        FOR SELECT Id AS ComapnyId
            FROM Company
			WHERE (@CompanyId IS NULL OR Id = @CompanyId)
         
        OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
             
            WHILE @@FETCH_STATUS = 0
            BEGIN

				IF(@DateFrom IS NULL OR @DateTo IS NULL) SELECT @DateFrom = CONVERT(DATE,GETDATE() - 7),@DateTo = CONVERT(DATE,GETDATE() - 7)

				INSERT INTO [TrackerDetailedData](UserId,[Name],AppUrlImage,ApplicationId,ApplicationName,[ApplicationTypeName],[AbsoluteAppName],[SpentTime],IsApp,CreatedDateTime,CompanyId)
				SELECT *,@CompanyId AS CompanyId
				FROM (
					   SELECT UserId, [Name], AppUrlImage,ApplicationId, ApplicationName, ApplicationTypeName,
								AbsoluteAppName,CONVERT(TIME, DATEADD(MS, SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)), 0)) AS SpentTime,
					   		  IsApp,CreatedDateTime
					   	FROM(
						   			SELECT DISTINCT U.Id AS UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name], A.AppUrlImage,UA.ApplicationId,UA.IsApp,
					   			                UA.OtherApplication AS ApplicationName
												,T.ApplicationTypeName
												,UA.AbsoluteAppName
					   					        ,CONVERT(TIME, DATEADD(MS, SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)), 0)) AS SpentTime,
					   					        UA.CreatedDateTime
					   			FROM [User] AS U
					   				 --INNER JOIN TimeSheet AS TS ON U.Id = TS.UserId AND (TS.Date BETWEEN CONVERT(DATE,@DateFrom) AND CONVERT(DATE,@DateTo))
					   				 INNER JOIN (SELECT ApplicationId,LTRIM(RTRIM(OtherApplication)) AS OtherApplication
					   				                    ,ApplicationTypeId,SpentTime
					   				                       ,UserId,CreatedDateTime,IsApp
														   ,AbsoluteAppName
					   				             FROM UserActivityTime
					   				 	         WHERE InActiveDateTime IS NULL) AS UA ON (U.Id = UA.UserId)
					   				 	              AND (UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo)
					   				 LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
					   				 LEFT JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id 
					   		    WHERE U.CompanyId = @CompanyId
					   		    GROUP BY U.Id,UA.ApplicationId,UA.OtherApplication,T.ApplicationTypeName,U.FirstName
										         ,U.SurName,UA.AbsoluteAppName,A.AppUrlImage,UA.IsApp,UA.CreatedDateTime
					   	) T WHERE ApplicationName <> '' AND ApplicationName IS NOT NULL
					   	GROUP BY UserId, [Name], AppUrlImage,ApplicationId, ApplicationName, ApplicationTypeName,IsApp,CreatedDateTime,AbsoluteAppName
					 ) TT
				
				/*
				 Removed Summary data related code from weekly job
				*/

				--DELETE FROM UserActivityHistoricalData 
				--WHERE CreatedDateTime BETWEEN @DateFrom AND @DateTo
				--      AND UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
				
				----Inserting summary table with absolute names
				--INSERT INTO UserActivityHistoricalData(UserId,[Name],AppUrlImage,ApplicationId,ApplicationName,[ApplicationTypeName],[SpentTime],IsApp,CreatedDateTime,CompanyId)
				--SELECT U.Id AS UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name]
				--                ,A.AppUrlImage
				--				,UA.ApplicationId
				--				,UA.AbsoluteAppName AS ApplicationName
				--				,T.ApplicationTypeName
				--		        ,UA.SpentTime
				--				,UA.IsApp
				--				,UA.CreatedDateTime
				--				,@CompanyId
				--FROM [User] AS U
				--	 INNER JOIN (SELECT ApplicationId,ApplicationTypeId
				--	                    ,CONVERT(TIME, DATEADD(MS, SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)), 0)) AS SpentTime
				--	                    ,UA.UserId,UA.CreatedDateTime,UA.IsApp,UA.AbsoluteAppName
				--	             FROM UserActivityTime AS UA
				--					  INNER JOIN [User] AS U ON U.Id = UA.UserId 
				--	 	         WHERE UA.InActiveDateTime IS NULL
				--					  AND U.CompanyId = @CompanyId
				--				 AND (UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo)
				--				 GROUP BY ApplicationId,ApplicationTypeId,UA.UserId,UA.CreatedDateTime,UA.IsApp,UA.AbsoluteAppName								 
				--				 ) AS UA ON U.Id = UA.UserId 
				--	 LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
				--	 LEFT JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id 
				--WHERE U.CompanyId = @CompanyId
				----GROUP BY U.Id,UA.ApplicationId,UA.OtherApplication,T.ApplicationTypeName
				----,U.FirstName,U.SurName,UA.AbsoluteAppName,A.AppUrlImage,UA.IsApp,UA.CreatedDateTime

				DELETE FROM UserActivityTime 
				WHERE CreatedDateTime BETWEEN @DateFrom AND @DateTo 
				      AND UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

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