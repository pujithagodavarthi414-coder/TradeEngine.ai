--EXEC [dbo].[USP_GetUserActivityScreenShotsBasedOnId] @OperationsPerformedBy='34c8eae7-e3a2-4c8b-81c0-13a94f7782f4',@DateFrom='2020-10-29 12:30:46.407',@DateTo='2020-11-01 12:32:35.090'
CREATE PROCEDURE [dbo].[USP_GetUserActivityScreenShotsBasedOnId](
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@UserIdXml XML = NULL,
	@PageNo INT = 1,
	@PageSize INT = 100,
	@IsFullDay BIT = NULL,
    @TimeZone NVARCHAR(250) = NULL,
	@UserStoryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY

		IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		If(@DateTo IS NOT NULL) SET @DateTo = @DateTo + 1

		If(@UserId IS NULL) SET @UserId = @OperationsPerformedBy

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @UserId)

			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = (@UserId))

			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END

			ELSE
			BEGIN
			  	
				DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				 BEGIN

				CREATE TABLE #RoleId  
					(
						RoleId UNIQUEIDENTIFIER NULL
					)
					INSERT INTO #RoleId (RoleId)
					SELECT UR.RoleId FROM UserRole AS UR
						   INNER JOIN [User] AS U ON U.Id = UR.UserId WHERE U.Id = @UserId AND UR.InactiveDateTime IS NULL
						 
				DECLARE @IsDelete BIT

				SELECT IsDeleteScreenShots INTO #DeletePermission FROM ActivityTrackerRolePermission WHERE IsDeleteScreenShots = 1 AND RoleId IN ( SELECT RoleId FROM #RoleId ) AND CompanyId = @CompanyId

				SET @IsDelete = (SELECT TOP(1) * FROM #DeletePermission ORDER BY IsDeleteScreenShots DESC)

				IF(@IsDelete  = '')
					BEGIN
						SET @IsDelete = 0
					END

				DECLARE @RecordActivity BIT = NULL, @MouseTracking BIT = NULL

					IF((SELECT TrackEmployee FROM Employee WHERE UserId = @UserId) IS NOT NULL AND (SELECT TrackEmployee FROM Employee WHERE UserId = @UserId) = 1)
					BEGIN
						SET @RecordActivity = ISNULL((SELECT TOP(1) IsKeyboardTracking FROM ActivityTrackerUserConfiguration WHERE UserId = @UserId), 0)
						SET @MouseTracking = ISNULL((SELECT TOP(1) IsMouseTracking FROM ActivityTrackerUserConfiguration WHERE UserId = @UserId), 0)
					END
					ELSE
					BEGIN
						DECLARE @RECORD BIT = ISNULL((SELECT TOP(1) IsRecord FROM ActivityTrackerConfigurationState WHERE CompanyId = @CompanyId), 0)
						DECLARE @Mouse BIT = ISNULL((SELECT TOP(1) IsMouse FROM ActivityTrackerConfigurationState WHERE CompanyId = @CompanyId), 0)

						SET @RecordActivity = IIF(@RECORD = 1,
													ISNULL((SELECT TOP(1) IsRecordActivity FROM ActivityTrackerRolePermission AS ATR 
															JOIN [UserRole] AS UR ON UR.RoleId = ATR.RoleId WHERE CompanyId = @CompanyId AND UR.UserId = @UserId
															ORDER BY IsRecordActivity DESC), 0), 0)
						SET @MouseTracking = IIF(@Mouse = 1,
													ISNULL((SELECT TOP(1) IsMouseTracking FROM ActivityTrackerRolePermission AS ATR 
															JOIN [UserRole] AS UR ON UR.RoleId = ATR.RoleId WHERE CompanyId = @CompanyId AND UR.UserId = @UserId
															ORDER BY IsRecordActivity DESC), 0), 0)
					END


				 

					CREATE TABLE #WorkItem 
					(
						Id INT IDENTITY(1,1),
						WorkItemId UNIQUEIDENTIFIER,
						StartTime DATETIME,
						EndTime DATETIME
					)

					INSERT INTO #WorkItem (
										   WorkItemId, 
					                       StartTime, 
										   EndTime
										  ) 
					                SELECT UserStoryId,
									       IIF(StartTime < @DateFrom, @DateFrom, StartTime),
										   --IIF(EndTime > @DateTo, @DateTo, EndTime)
										   IIF(EndTime IS NOT NULL,IIF(EndTime > @DateTo, @DateTo, EndTime),GETUTCDATE())
										   FROM UserStorySpentTime 
										   WHERE (@UserStoryId IS NULL OR UserStoryId = @UserStoryId)
										     AND SpentTimeInMin IS NULL AND UserId = @UserId
											 AND ((StartTime BETWEEN @DateFrom AND @DateTo) OR ((EndTime BETWEEN @DateFrom AND @DateTo) OR (EndTime IS NULL)))
					

					DECLARE @Count INT = 1

					CREATE TABLE #Screenshots
						(
						ScreenShotId UNIQUEIDENTIFIER,
						[Name] NVARCHAR(MAX),
						UserId UNIQUEIDENTIFIER,
						ProfileImage NVARCHAR(MAX),
						RoleName NVARCHAR(MAX),
						IsArchived BIT,
						ScreenShotUrl NVARCHAR(MAX),
						ScreenShotName NVARCHAR(MAX),
						KeyStroke INT,
						MouseMovement INT,
						Reason NVARCHAR(MAX),
						ApplicationName NVARCHAR(MAX),
						ApplicationTypeName NVARCHAR(MAX),
						ScreenShotDateTime DATETIME,
						IsDelete BIT,
						DeletedByUser NVARCHAR(MAX),
						RecordActivity BIT,
						MouseTracking BIT,
						CreatedDateTime DATETIME,
						TimeZoneAbbreviation NVARCHAR(MAX),
						TimeZoneName NVARCHAR(MAX)
						)

					WHILE(@Count <= (SELECT COUNT(1) FROM #WorkItem))
					BEGIN

					SELECT @DateFrom = StartTime,@DateTo = EndTime FROM #WorkItem WHERE Id = @Count

					--SELECT @DateFrom,@DateTo,@Count

					INSERT INTO #Screenshots
							 SELECT DISTINCT A.Id AS ScreenShotId
					               ,CONCAT(U.FirstName,' ',U.SurName) AS [Name]
								   ,A.UserId
								   ,U.ProfileImage,
							        STUFF((SELECT ', ' + RoleName
								                  FROM UserRole UR
									              INNER JOIN [Role] R ON R.Id = UR.RoleId
												         AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
								                  WHERE UR.UserId = U.Id
								                  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,							
							                      A.IsArchived
												  ,A.ScreenShotUrl AS ScreenShotUrl
												  ,A.ScreenShotName AS ScreenShotName
							                      ,A.KeyStroke
												  ,A.MouseMovement
												  ,A.Reason
												  ,A.ApplicationName AS ApplicationName
												  ,ATT.ApplicationTypeName AS ApplicationTypeName
												  ,A.ScreenShotDateTime AS ScreenShotDateTime
												  ,@IsDelete AS IsDelete
							                      ,(SELECT CONCAT(FirstName,' ',SurName) FROM [user] WHERE id= A.UpdatedByUserId) AS DeletedByUser
							                      ,@RecordActivity AS RecordActivity
												  ,@MouseTracking AS MouseTracking
												  ,A.CreatedDateTime
							                      ,TZ.TimeZoneAbbreviation
												  ,TZ.TimeZoneName
							                       FROM ActivityScreenShot AS A
							                       INNER JOIN [User] AS U ON U.Id = A.UserId AND U.Id = @UserId
							                       INNER JOIN ApplicationType AS ATT ON ATT.Id = A.ApplicationTypeId
							                       INNER JOIN Employee AS E ON U.Id = E.UserId 
							                       LEFT JOIN TimeZone TZ ON TZ.Id = A.ScreenShotTimeZoneId
							                       INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							WHERE  CONVERT(DATETIME2,A.ScreenShotDateTime,1) BETWEEN @DateFrom AND @DateTo
									AND A.CreatedDateTime IS NOT NULL 
									AND A.Id NOT IN (SELECT ScreenShotId FROM #Screenshots)
							--AND EB.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId)
							ORDER BY A.ScreenShotDateTime DESC
							SET @Count = @Count + 1
					END

					DECLARE @ChartData TABLE (
                    TrackedDate DateTime,
                    StartTime DateTime,
                    EndTime DateTime
                    ,KeyStrokes INT DEFAULT 0
                    ,MouseMovements INT DEFAULT 0
                    )

					DECLARE @StartDate DATE = @DateFrom,@EndDate DATE = @DateTo,@StartTime DATETIME,@TimeZoneId UNIQUEIDENTIFIER
					        ,@EndTime DATETIME,@OffsetMinutes INT,@TimeZoneAbbreviation NVARCHAR(50)

					SELECT TOP (1) @OffsetMinutes = OffsetMinutes,@TimeZoneAbbreviation = TimeZoneAbbreviation,@TimeZoneId = Id
					FROM TimeZone WHERE TimeZone = @TimeZone 
					
					WHILE(@StartDate <= @EndDate)
					BEGIN
						
						SELECT @StartTime = MIN(TrackedDateTime),@EndTime = MAX(TrackedDateTime)
						FROM UserActivityTrackerStatus UTS
						WHERE CONVERT(DATE,TrackedDateTime) = @StartDate
									AND UTS.UserId = @UserId
									AND ISNULL(UTS.[IsIdleRecord],0) = 0

						INSERT INTO @ChartData(StartTime,EndTime,TrackedDate)
						SELECT StartTime,EndTime,@StartDate FROM (
						SELECT StartTime,LEAD(StartTime) OVER(ORDER BY StartTime) AS EndTime FROM (
						SELECT DATEADD(MINUTE,number * 10,@StartTime) AS StartTime
						FROM master..spt_values
						WHERE Type = 'p'
						AND DATEADD(MINUTE,number * 10,@StartTime) <= @EndTime
						AND DATEADD(MINUTE,number * 10,@StartTime) >= @StartTime
						AND number <= 144 ) T
						GROUP BY StartTime ) T WHERE StartTime IS NOT NULL AND EndTime IS NOT NULL

						SET @StartDate = DATEADD(DAY,1,@StartDate)

					END

                    UPDATE @ChartData SET KeyStrokes = CDInner.KeyStroke,MouseMovements = CDInner.MouseMovement
					FROM @ChartData CD
					INNER JOIN (
						SELECT CD.StartTime,CD.EndTime
						       ,SUM(UTS.KeyStroke) AS KeyStroke
						       ,SUM(UTS.MouseMovement) AS MouseMovement
						FROM @ChartData CD
						     INNER JOIN UserActivityTrackerStatus UTS ON UTS.TrackedDateTime >= CD.StartTime 
							            AND UTS.TrackedDateTime <= CD.EndTime
										AND UTS.UserId = @UserId
							 GROUP BY CD.StartTime,CD.EndTime
					) CDInner ON CD.StartTime = CDInner.StartTime AND CD.EndTime = CDInner.EndTime

					DECLARE @TotalCount INT= (SELECT COUNT(1) FROM #Screenshots)

							SELECT T.[Date] AS [Date],@IsDelete AS IsDelete,@TotalCount AS TotalCount,(
							SELECT * FROM #Screenshots ST
							WHERE ST.CreatedDateTime = T.[Date]
							ORDER BY ScreenShotDateTime DESC
							OFFSET ((@PageNo - 1) * @PageSize) ROWS 
							FETCH NEXT @PageSize ROWS ONLY
							FOR JSON PATH) AS ScreenshotDetails 

							,(  SELECT KeyStrokes AS KeyStroke,MouseMovements AS MouseMovement
							          ,CONVERT(VARCHAR(5),DATEADD(MINUTE,@OffsetMinutes,StartTime),108) AS StartTime
							          ,CONVERT(VARCHAR(5),DATEADD(MINUTE,@OffsetMinutes,EndTime),108) AS EndTime
									  ,@TimeZoneAbbreviation AS TimeZoneAbbreviation
									  ,@TimeZoneId AS TimeZoneId
							   FROM @ChartData WHERE TrackedDate = T.[Date] FOR JSON PATH) AS TrackerChartDetails
							FROM (
							       SELECT DISTINCT CreatedDateTime AS [Date]
							       FROM #Screenshots AA
							      -- WHERE CONVERT(DATE, AA.CreatedDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo) AND AA.CreatedDateTime IS NOT NULL
								) T
							ORDER BY T.[Date] DESC
				 END

				 ELSE
				 BEGIN
				   
				   		RAISERROR (@HavePermission,11, 1)
				 END
		    END
		END TRY
		
		BEGIN CATCH        
            THROW
        END CATCH
END
GO
