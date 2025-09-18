-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2020-03-11 00:00:00.000'
-- Purpose      To Get the Tracked information of a user with respect to the userstory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetTrackedInformationOfUserStory] @OperationsPerformedBy = 'A20EBB86-B3E4-490A-AA5B-2E1D8B02B0B6', @userId = 'A20EBB86-B3E4-490A-AA5B-2E1D8B02B0B6', @DateFrom = '2020-03-09', @DateTo = '2020-03-11'
CREATE PROCEDURE [dbo].[USP_GetTrackedInformationOfUserStory](
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@DateFrom DATE,
@DateTo DATE,
@UserId UNIQUEIDENTIFIER
)
AS
BEGIN
	 SET NOCOUNT ON
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END

			IF(@DateFrom IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'DateFrom')
			END

			IF(@DateTo IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'DateTo')
			END

			ELSE
			BEGIN
				
				DECLARE @CTE TABLE 
						(
						Id Int Identity (1,1),
						UserId UNIQUEIDENTIFIER NULL,
						[Name] NVARCHAR(100) NULL,
						Productive TIME NULL,
						UnProductive TIME NULL,
						Neutral TIME NULL,
						BreakType NVARCHAR(50) NULL,
						StartTime DATETIME NULL,
						EndTime DATETIME NULL,
						DayEndTime DATETIME NULL,
						OperationDate DATE NULL,
						UserStory NVARCHAR(800) NULL			
						)

				SELECT UserId,'Lunch' AS BreakType,LunchBreakStartTime AS StartTime, LunchBreakEndTime AS EndTime, Date AS [Date] INTO #Dummy FROM TimeSheet WHERE UserId = @UserId AND LunchBreakStartTime IS NOT NULL AND Date BETWEEN @DateFrom AND @DateTo


				INSERT INTO #Dummy (UserId, BreakType, StartTime,EndTime,Date) 

				SELECT UserId, 'Break' AS BreakType,BreakIn AS StartTime,BreakOut AS EndTime,Date AS [Date] FROM UserBreak WHERE UserId = @UserId AND [Date] BETWEEN @DateFrom AND @DateTo

			
				SELECT *, DENSE_RANK() OVER(ORDER BY Date) AS [RankDate] INTO #Dum FROM #Dummy Order BY StartTime ASC


				SELECT *, RANK() OVER(PARTITION BY [RankDate] ORDER BY StartTime) AS [RankTime] INTO #Du FROM #Dum
			
				DECLARE @MaxCount INT, @Counter INT = 1

				SET @MaxCount = (SELECT MAX(RankDate) FROM #Dum)
			
				WHILE(@Counter <= @MaxCount)
				BEGIN
				
					SELECT * INTO #Temp FROM #Du WHERE RankDate = @Counter

					DECLARE @InnerCount INT, @Count INT = 0
				
					SELECT @InnerCount = MAX(RankTime) FROM #Temp	
				
					DECLARE @StartTime DATETIME,@EndTime DATETIME

					SET @StartTime = (SELECT TOP(1) ActivityTrackerStartTime FROM ActivityTrackerStatus WHERE [Date] = (SELECT TOP(1) [Date] FROM #Du WHERE RankDate = @Counter) AND UserId = @UserId)

					SET @EndTime = (SELECT TOP(1) OutTime FROM TimeSheet WHERE [Date] = (SELECT TOP(1) [Date] FROM #Du WHERE RankDate = @Counter) AND UserId = @UserId)
							
					WHILE(@Count <= @InnerCount)
					BEGIN
					
						INSERT INTO @CTE (UserId, [Name], OperationDate, Neutral, Productive, UnProductive, StartTime, DayEndTime)

						SELECT PVT.UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],OperationDate,[Neutral],[Productive],[UnProductive], [StartTime], [DayEndTime]
								FROM(

									SELECT UM.Id AS UserId,UA.CreatedDateTime AS OperationDate,T.ApplicationTypeName,
											CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, UA.SpentTime) * 3600000 ) + 
											( DATEPART(MI, UA.SpentTime) * 60000 ) + DATEPART(SS, UA.SpentTime)*1000  +DATEPART(MS, UA.SpentTime)), 0)) AS total_time  ,
											IIF(@Count = 0, @StartTime, NULL) AS StartTime, @EndTime AS DayEndTime
										FROM [User] AS UM WITH (NOLOCK)
										LEFT JOIN TimeSheet AS TS WITH (NOLOCK) ON UM.Id = TS.UserId AND (TS.Date BETWEEN @DateFrom AND @DateTo  )
										LEFT JOIN UserActivityTime AS UA WITH (NOLOCK) ON ( UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.Date ) AND 
													(( UA.ApplicationStartTime >= TS.InTime  AND ( UA.ApplicationEndTime <= TS.OutTime OR TS.OutTime IS NULL)) )
													AND ( (UA.ApplicationEndTime < TS.LunchBreakStartTime OR TS.LunchBreakStartTime IS NULL) 
													OR( UA.ApplicationStartTime >= TS.LunchBreakEndTime OR TS.LunchBreakEndTime IS NULL) AND 
													( UA.ApplicationStartTime > TS.LunchBreakStartTime AND TS.LunchBreakEndTime IS NOT NULL) )
													AND ( UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo )
										LEFT JOIN ActivityTrackerApplicationUrlRole AS A WITH (NOLOCK) ON (UA.ApplicationId = A.Id OR UA.ApplicationId = A.Id) AND A.InActiveDateTime IS NULL
										JOIN ApplicationType AS T WITH (NOLOCK) ON UA.ApplicationTypeId = T.Id
										JOIN #Temp AS Te WITH (NOLOCK) ON Te.UserId = UM.Id AND Te.Date = TS.Date
										WHERE UA.CreatedDateTime BETWEEN @DateFrom and @DateTo
										AND UA.Id NOT IN
												(SELECT UAT.Id
												FROM UserActivityTime UAT WITH (NOLOCK)
												JOIN [User] U WITH (NOLOCK) ON U.Id = UAT.UserId
												JOIN [UserBreak] UB WITH (NOLOCK) ON U.Id = UB.UserId AND
												((ApplicationStartTime BETWEEN BreakIn AND BreakOut OR ApplicationEndTime BETWEEN BreakIn AND BreakOut) OR (ApplicationEndTime > BreakIn and Breakout IS NULL))
												WHERE UA.UserId = U.Id AND UB.Date = CONVERT(DATE, UA.CreatedDateTime))  
												AND (( @Count = 0 AND UA.ApplicationEndTime < Te.StartTime AND Te.RankTime = 1 AND UA.ApplicationStartTime >= TS.InTime) OR 
													(@Count = @InnerCount AND UA.ApplicationStartTime > Te.EndTime AND Te.RankTime = @Count AND (UA.ApplicationEndTime < TS.OutTime OR TS.OutTime IS NULL))
													OR ((@Count > 0 AND @Count < @InnerCount) AND UA.ApplicationStartTime > (SELECT EndTime FROM #Temp WHERE RankTime = @Count) AND UA.ApplicationEndTime < (SELECT StartTime FROM #Temp WHERE RankTime = (@Count + 1)) )) 
											
												
										GROUP BY UM.Id,UA.CreatedDateTime,T.ApplicationTypeName

								)AS Final
							PIVOT (MAX(total_time)
							FOR ApplicationTypeName IN ([Neutral],[Productive],[UnProductive]))
							PVT JOIN [User] AS U ON PVT.UserId = U.Id
						
							IF(@Count != @InnerCount)
							BEGIN
								INSERT INTO @CTE (UserId, BreakType, StartTime, EndTime, OperationDate)

								SELECT UserId, BreakType, StartTime, EndTime, [Date] FROM #Temp WHERE RankTime = (@Count + 1)

							END

						SET	@Count = @Count + 1
					END
				
					DROP TABLE #Temp
					SET @Counter = @Counter + 1
				END
				DECLARE @ActivityInformation NVARCHAR(MAX)

				;WITH CTE AS (
					SELECT COALESCE(StartTime,DATEADD(MINUTE,1,( Lag(EndTime, 1) OVER(ORDER BY Id)))) T1,
					 COALESCE(EndTime, IIF(CONVERT(DATE, Lead(StartTime, 1) OVER(ORDER BY Id)) = CONVERT(DATE, DayEndTime), DATEADD(MINUTE,-1,(Lead(StartTime, 1) OVER(ORDER BY Id))), DayEndTime)) T2, * FROM @CTE
				)

				--SELECT UserId, [Name], Productive, UnProductive, Neutral, BreakType, T1 AS StartTime, T2 AS EndTime, OperationDate INTO #Track FROM CTE

					
				 select @ActivityInformation = (SELECT DISTINCT CTEA.OperationDate AS [Date],(SELECT  UserId, [Name], Productive, UnProductive, Neutral, BreakType, T1 AS StartTime, T2 AS EndTime, OperationDate FROM CTE AS CTEI
																												WHERE CTEI.OperationDate = CTEA.OperationDate
																												ORDER BY CTEI.OperationDate ASC
																												FOR JSON PATH) AS TrackedInfo FROM CTE AS CTEA ORDER BY OperationDate ASC
																												FOR JSON PATH)

				SELECT U.UserStoryName,CONVERT(DATE,US.StartTime) AS [Date], US.StartTime, US.EndTime INTO #UserStoryTemp
						FROM UserStory AS U 
						JOIN UserStorySpentTime AS US ON US.UserStoryId = U.Id AND US.StartTime IS NOT NULL AND US.UserId = @UserId AND CONVERT(DATE,US.StartTime) BETWEEN @DateFrom AND @DateTo
			
			
				DECLARE @UserStoryInformation NVARCHAR(MAX) = (SELECT DISTINCT UA.[Date] ,(SELECT * FROM #UserStoryTemp AS UB
																				   WHERE UB.[Date] = UA.[Date]
																				   ORDER BY StartTime ASC
																				   FOR JSON PATH) AS UserStory FROM #UserStoryTemp AS UA ORDER BY [Date]  ASC
																				   FOR JSON PATH)

				SELECT @ActivityInformation AS ActivityInformation, @UserStoryInformation AS UserStoryInfo

			END
		END TRY

		BEGIN CATCH        
            THROW
        END CATCH
END