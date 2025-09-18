-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-10-30 00:00:00.000'
-- Purpose      To Get the Screenshot which were captured by Activity Tracker By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetUserActivityScreenShots] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@DateFrom='2019-10-01',@DateTo='2019-10-30'
CREATE PROCEDURE [dbo].[USP_GetUserActivityScreenShots](
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@UserIdXml XML = NULL,
@PageNo INT = 1,
@PageSize INT = 100,
@IsFullDay BIT = NULL,
@TimeZone NVARCHAR(250) = NULL,
@IsTrailExpired BIT = NULL,
@IsForLatestScreenshots BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = (@OperationsPerformedBy))

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

			IF(@IsForLatestScreenshots = 1)
			BEGIN
				SET @PageSize = 5
			END

			IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE()));

			ELSE
			BEGIN
			  	
				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
						 
				 IF (@HavePermission = '1')
				 BEGIN
				 
					CREATE TABLE #UserIdList 
					(
						UserId UNIQUEIDENTIFIER NULL
					)

					CREATE TABLE #RoleId  
					(
						RoleId UNIQUEIDENTIFIER NULL
					)
					INSERT INTO #RoleId (RoleId)
					SELECT UR.RoleId FROM UserRole AS UR
						   INNER JOIN [User] AS U ON U.Id = UR.UserId WHERE U.Id = @OperationsPerformedBy AND UR.InactiveDateTime IS NULL

					DECLARE @IsDelete BIT --= (SELECT IsDeleteScreenShots FROM ActivityTrackerRolePermission WHERE RoleId IN ( SELECT RoleId FROM #RoleId ) AND CompanyId = @CompanyId)

					SELECT IsDeleteScreenShots INTO #DeletePermission FROM ActivityTrackerRolePermission WHERE IsDeleteScreenShots = 1 AND RoleId IN ( SELECT RoleId FROM #RoleId ) AND CompanyId = @CompanyId
					 
					--SET @IsDelete = (SELECT IsDeleteScreenShots FROM ActivityTrackerRolePermission WHERE IsDeleteScreenShots = 1 AND RoleId IN ( SELECT RoleId FROM #RoleId ) AND CompanyId = @CompanyId)

					SET @IsDelete = (SELECT TOP(1) * FROM #DeletePermission ORDER BY IsDeleteScreenShots DESC)
					
					--IF(DATEDIFF(DAY,@DateFrom,@DateTo) > 7) SET @DateFrom = DATEADD(DAY,-7,@DateTo) --TODO

					IF(@IsDelete  = '')
					BEGIN
						SET @IsDelete = 0
					END

					IF(@UserIdXml IS NOT NULL)
					BEGIN
						INSERT INTO #UserIdList (UserId)
						SELECT TOP 1 Id FROM (
						SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER') AS Id
						FROM  @UserIdXml.nodes('/ListItems/ListRecords/ListItem') XmlData(x) ) T
					END

					--IF(ISNULL((SELECT COUNT(1) FROM #UserIdList GROUP BY UserId),0) = 1)
					IF(@UserIdXml IS NULL)
					BEGIN
						
						INSERT INTO #UserIdList (UserId)
						SELECT @OperationsPerformedBy

					END

					DECLARE @UserId UNIQUEIDENTIFIER = (SELECT TOP(1) UserId FROM #UserIdList)
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

					--SELECT DISTINCT CreatedDateTime AS [Date],@IsDelete AS IsDelete,(
					SELECT DISTINCT A.Id AS ScreenShotId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],A.UserId,U.ProfileImage,
							STUFF((SELECT ', ' + RoleName
								  FROM UserRole UR
									   INNER JOIN [Role] R ON R.Id = UR.RoleId
												  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
								  WHERE UR.UserId = U.Id
								FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,							
							A.IsArchived,A.ScreenShotUrl AS ScreenShotUrl,A.ScreenShotName AS ScreenShotName,
							A.KeyStroke,A.MouseMovement,A.Reason,A.ApplicationName AS ApplicationName,ATT.ApplicationTypeName AS ApplicationTypeName
							,A.ScreenShotDateTime AS ScreenShotDateTime,@IsDelete AS IsDelete,
							(SELECT CONCAT(FirstName,' ',SurName) FROM [user] WHERE id= A.UpdatedByUserId) AS DeletedByUser,
							--(SELECT TOP(1) IsRecordActivity FROM ActivityTrackerRolePermission AS ATR 
							--								JOIN [UserRole] AS UR ON UR.RoleId = ATR.RoleId WHERE CompanyId = @CompanyId AND UR.UserId = A.UserId
							--								ORDER BY IsRecordActivity DESC) AS RecordActivity,
							@RecordActivity AS RecordActivity, @MouseTracking AS MouseTracking,
															A.CreatedDateTime,
							TZ.TimeZoneAbbreviation, TZ.TimeZoneName
							INTO #Screenshots
							FROM ActivityScreenShot AS A
							INNER JOIN [User] AS U ON U.Id = A.UserId 
							INNER JOIN #UserIdList UL ON UL.UserId = U.Id
							--INNER JOIN TimeSheet AS TS ON U.Id = TS.UserId 
							INNER JOIN ApplicationType AS ATT ON ATT.Id = A.ApplicationTypeId
							--AND A.CreatedDateTime = TS.[Date]
							INNER JOIN Employee AS E ON U.Id = E.UserId 
							LEFT JOIN TimeZone TZ ON TZ.Id = A.ScreenShotTimeZoneId
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							--INNER JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId) ret
							--			ON ret.ChildId = U.Id AND U.InactiveDateTime IS NULL
							WHERE (((@IsFullDay IS NULL OR @IsFullDay = 1) AND CONVERT(DATE, A.ScreenShotDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo)) OR
								   (@IsFullDay = 0 AND A.ScreenShotDateTime BETWEEN @DateFrom AND @DateTo))
									AND A.CreatedDateTime IS NOT NULL
							AND EB.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId)
							ORDER BY A.ScreenShotDateTime DESC

							DECLARE @TotalCount INT= (SELECT COUNT(1) FROM #Screenshots)

							SELECT T.[Date] AS [Date],@IsDelete AS IsDelete,@TotalCount AS TotalCount,(
							SELECT * FROM #Screenshots ST
							WHERE ST.CreatedDateTime = T.[Date]
							ORDER BY ScreenShotDateTime DESC
							OFFSET ((@PageNo - 1) * @PageSize) ROWS 
							FETCH NEXT @PageSize ROWS ONLY
							FOR JSON PATH) AS ScreenshotDetails 
							
							,( SELECT KeyStrokes AS KeyStroke,MouseMovements AS MouseMovement
							          ,CONVERT(VARCHAR(5),DATEADD(MINUTE,@OffsetMinutes,StartTime),108) AS StartTime
							          ,CONVERT(VARCHAR(5),DATEADD(MINUTE,@OffsetMinutes,EndTime),108) AS EndTime
									  ,@TimeZoneAbbreviation AS TimeZoneAbbreviation
									  ,@TimeZoneId AS TimeZoneId
							   FROM @ChartData WHERE TrackedDate = T.[Date] FOR JSON PATH) AS TrackerChartDetails
							FROM (
							       SELECT DISTINCT CreatedDateTime AS [Date], UserId
							       FROM #Screenshots AA
							       WHERE CONVERT(DATE, AA.ScreenShotDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo) AND AA.CreatedDateTime IS NOT NULL
								) T
							ORDER BY T.[Date] DESC

							--SELECT DISTINCT CreatedDateTime AS [Date],@IsDelete AS IsDelete,@TotalCount AS TotalCount,(
							--SELECT * FROM #Screenshots
							--ORDER BY ScreenShotDateTime DESC
							--OFFSET ((@PageNo - 1) * @PageSize) ROWS 
							--FETCH NEXT @PageSize ROWS ONLY
							--FOR JSON PATH) AS ScreenshotDetails FROM #Screenshots AS AA
							--WHERE AA.CreatedDateTime BETWEEN @DateFrom AND @DateTo AND AA.CreatedDateTime IS NOT NULL
							--	--AND AA.CreatedDateTime = ScreenShotDateTime
							--ORDER BY CreatedDateTime DESC
					
					DROP TABLE #DeletePermission

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
