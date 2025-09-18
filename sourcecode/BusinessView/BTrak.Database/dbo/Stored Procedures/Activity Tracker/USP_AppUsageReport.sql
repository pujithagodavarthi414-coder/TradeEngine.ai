--EXEC [dbo].[USP_AppUsageReport] '2020-08-05','0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_AppUsageReport] --BakEnd Job
(
	@Date DATE = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER -- = '0B2921A9-E930-4013-9047-670B5352F308' -- Live Site Id
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	   BEGIN TRY
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			ELSE IF(@OperationsPerformedBy IS NOT NULL)
			BEGIN
			   
			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 

			   DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = (@OperationsPerformedBy))
			
			   DECLARE @NutralApplicationType UNIQUEIDENTIFIER = 'A5149B84-7074-4098-A1E4-6C218CA4DE5D' -- Neutral

			   IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETDATE()-1)

			   DECLARE @DateFrom DATETIME,@DateTo DATETIME

			   --DELETE FROM 

			   SET @DateFrom = @Date
			   SET @DateTo = @Date
			 
			   DELETE UT FROM UserTimelineData UT INNER JOIN [User] U ON U.Id = UT.UserId AND U.CompanyId = @CompanyId AND UT.CreatedDate = @Date
				
				CREATE TABLE #UserIdList
					(
						Id INT IDENTITY(1,1) PRIMARY KEY,
						UserId UNIQUEIDENTIFIER NULL
					)
				
				INSERT INTO #UserIdList (UserId)
					SELECT Id
					FROM  [User]
					WHERE InActiveDateTime IS NULL AND IsActive = 1
					      AND CompanyId = @CompanyId

				CREATE TABLE #templateData
					(
						Id INT IDENTITY(1,1) PRIMARY KEY,
						ApplicationTypeName VARCHAR(50),
						ApplicationStartTime DATETIME,
						ApplicationEndTime DATETIME,
						NextTypeName VARCHAR(50),
						CreatedDate DATETIME,
						UserId UNIQUEIDENTIFIER,
						UserName VARCHAR(250),
						[Counter] INT,
						UserOrder INT
					)

				CREATE TABLE #TimelineData
					(
						Id INT IDENTITY(1,1) PRIMARY KEY,
						UserId UNIQUEIDENTIFIER,
						UserName VARCHAR(250),
						CreatedDate DATETIME,
						ApplicationTypeName VARCHAR(50),
						StartTime DATETIME,
						EndTime DATETIME,
						SpentTime INT
					)

				CREATE TABLE #IdleTimeRecords
					(
						UserId UNIQUEIDENTIFIER
						,MinTrackedDateTime DATETIME
						,MaxTrackedDateTime DATETIME
						,Dates DATETIME
					)

				DECLARE @Iden INT = 1, @maxUser INT = (SELECT COUNT(1) FROM #UserIdList)
				DECLARE @counter INT = 1
				WHILE(@Iden <= @maxUser)
				BEGIN
					
						DECLARE @UserIdLocal UNIQUEIDENTIFIER = (SELECT UserId FROM #UserIdList WHERE Id = @Iden)

						INSERT INTO #IdleTimeRecords(UserId,MinTrackedDateTime,MaxTrackedDateTime,Dates)
						SELECT UserId,StartDateTime,TrackedDateTime,CONVERT(DATE,TrackedDateTime)
						FROM [UserActivityTrackerStatus]
						WHERE CONVERT(DATE,TrackedDateTime) BETWEEN CONVERT(DATE,@DateFrom) AND  CONVERT(DATE,@DateTo)
							  AND IdleTimeInMin IS NOT NULL
							  AND IsIdleRecord = 1
							  AND UserId = @UserIdLocal

						/* No need to set inactive for idle time records*/
						
						--DECLARE @User UNIQUEIDENTIFIER,@Start DATETIME,@End DATETIME

						--DECLARE Cursor_idleTime CURSOR
						--FOR SELECT UserId,MinTrackedDateTime,MaxTrackedDateTime
						--    FROM #IdleTimeRecords
						 
						--OPEN Cursor_idleTime
						 
						--    FETCH NEXT FROM Cursor_idleTime INTO 
						--        @User,@Start,@End
						     
						--    WHILE @@FETCH_STATUS = 0
						--    BEGIN
						      
						--        UPDATE UserActivityTime SET InActiveDateTime = GETDATE()
						--		WHERE UserId = @User AND
						--			  ((ApplicationStartTime >= @Start AND ApplicationStartTime <= @End)
						--			  OR (ApplicationEndTime >= @Start AND ApplicationEndTime <= @End)) --AND OtherApplication <> 'Idle Time'

						--        FETCH NEXT FROM Cursor_idleTime INTO 
						--        @User,@Start,@End
						        
						--    END
						     
						--CLOSE Cursor_idleTime
						 
						--DEALLOCATE Cursor_idleTime

						;WITH CTE AS (
							SELECT *, ROW_NUMBER() OVER(PARTITION BY ApplicationStartTime, ApplicationEndTime, [CreatedDate], [UserId], [Name], [COUNTER] ORDER BY 
							ApplicationStartTime, ApplicationEndTime, [CreatedDate], [UserId], [Name], [COUNTER], SORTORDER) RN FROM 
							(SELECT DISTINCT
									CASE WHEN OtherApplication ='idle time' THEN 'IdleTime' ELSE APT.ApplicationTypeName END ApplicationTypeName,
									ApplicationStartTime, ApplicationEndTime,
									ua.CreatedDateTime [CreatedDate],
									U.Id [UserId], U.FirstName + COALESCE(' ' + U.SURNAME,'')  [Name], 0 [Counter],
									CASE WHEN OtherApplication = 'idle time' THEN 1
										WHEN OtherApplication  <> 'idle time' AND APT.ApplicationTypeName = 'UnProductive' THEN 2
										WHEN OtherApplication  <> 'idle time' AND APT.ApplicationTypeName = 'Productive' THEN 3
										WHEN OtherApplication  <> 'idle time' AND APT.ApplicationTypeName = 'Neutral' THEN 4
									END SORTORDER
								FROM [User] AS U 	
								--INNER JOIN Employee AS E ON U.Id = E.UserId -- not used
								--INNER JOIN TimeSheet AS TS ON U.Id = TS.UserId AND ( TS.Date BETWEEN @DateFrom AND @DateTo )
								INNER JOIN (SELECT MACAddress,ApplicationId,OtherApplication,CommonUrl,ApplicationTypeId --,SpentTime
							                       ,UserId,CreatedDateTime,TrackedUrl,0 AS IsIdleRecord,IsApp,ApplicationStartTime,ApplicationEndTime
							                FROM UserActivityTime
									        WHERE InActiveDateTime IS NULL
										    UNION ALL
										    SELECT '',NULL,'Idle Time',NULL,@NutralApplicationType --,CONVERT(VARCHAR, DATEADD(S,TotalIdleTime * 60, 0), 108)
										         ,UserId,Dates,NULL,1 AS IsIdleRecord,1,MinTrackedDateTime,MaxTrackedDateTime
										    FROM #IdleTimeRecords
									   ) AS UA ON ( U.Id = UA.UserId 
									   --AND (IsIdleRecord = 1 OR CONVERT(DATE, UA.CreatedDateTime) = TS.Date )
									   )
									   AND ( UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo)
								--INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id  -- NOT USED
								INNER JOIN ApplicationType AS APT ON UA.ApplicationTypeId = APT.Id
								LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id) AND A.InActiveDateTime IS NULL
								WHERE APT.Id IS NOT NULL AND DATEDIFF(SECOND, applicationstarttime, applicationendtime) >= 1 
									--AND EB.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId )  --  may not be useful
									AND U.CompanyId = @CompanyId
									AND U.Id = @UserIdLocal
							) AS T
						)
						INSERT INTO #templateData
						SELECT ApplicationTypeName, ApplicationStartTime, ApplicationEndTime,
						       LEAD(ApplicationTypeName) OVER (ORDER BY ApplicationStartTime) LEAD,  [CreatedDate], [UserId], [Name], [Counter],
						       ROW_NUMBER() OVER(PARTITION BY UserId ORDER BY UserId, CreatedDate, ApplicationStartTime) [UserOrder] FROM CTE
						WHERE RN = 1
						ORDER BY UserId, [Name], CreatedDate, ApplicationStartTime

						DELETE FROM #IdleTimeRecords

						DECLARE @cnt INT = 1, @max INT
						SELECT @max = COUNT(*) FROM #templateData WHERE UserId = @UserIdLocal

						WHILE(@cnt <= @max)
						BEGIN
							UPDATE #templateData SET [Counter] = @counter WHERE UserOrder = @cnt AND UserId = @UserIdLocal
							IF EXISTS(SELECT * FROM #templateData WHERE UserOrder = @cnt and ApplicationTypeName <> NextTypeName AND UserId = @UserIdLocal)
							BEGIN
								SET @counter = @counter + 1;
							END
							SET @cnt = @cnt + 1
						END
						SET @Iden = @Iden + 1 

						INSERT INTO #TimelineData
						SELECT t.UserId, t.UserName, CreatedDate, ApplicationTypeName, StartTime, EndTime
						        ,SpentTime = DATEDIFF(MINUTE, StartTime, EndTime) 
						FROM(
							SELECT DISTINCT UserId, UserName, CreatedDate,ApplicationTypeName, 
							FIRST_VALUE(ApplicationStartTime) OVER (PARTITION BY [Counter] ORDER BY UserId,ApplicationStartTime )  AS StartTime,
							LAST_VALUE(ApplicationEndTime) OVER (PARTITION BY [Counter] ORDER BY UserId,ApplicationEndTime RANGE BETWEEN 
									UNBOUNDED PRECEDING AND 
									UNBOUNDED FOLLOWING )  AS EndTime
							 FROM #templateData T
							 WHERE T.UserId = @UserIdLocal
						) AS T
						WHERE DATEDIFF(MINUTE,StartTime,EndTime) >= 0 AND CONVERT(DATE,StartTime) = CONVERT(DATE,EndTime)
						ORDER BY StartTime
		
					END

					INSERT INTO UserTimelineData(UserId,UserName,CreatedDate,ApplicationTypeName,StartTime,EndTime,SpentTime)
					SELECT UserId,UserName,CreatedDate,ApplicationTypeName,StartTime,EndTime,SpentTime
					FROM #TimelineData 
					ORDER BY UserId, StartTime

				 END
		END TRY
		BEGIN CATCH
        
			THROW

	    END CATCH
END
GO