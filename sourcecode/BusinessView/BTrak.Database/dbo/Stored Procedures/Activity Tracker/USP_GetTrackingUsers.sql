CREATE PROCEDURE [dbo].[USP_GetTrackingUsers](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Status NVARCHAR(500) = NULL,
@Date DATETIME = NULL
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  BEGIN TRY

	IF @Date IS NULL SET @Date = GETDATE()
  
	IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	
    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
	
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN			 
		
		DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy)

     
	 IF(@Status = 'minworkinghours')
	 BEGIN
	    
		--DECLARE @CurrentUTCDateTime DATETIME = '2020-12-22 12:31:00' -- '12:31:00' '14:31:00' '16:31:00'
		DECLARE @CurrentUTCDateTime DATETIME = @Date	
		DECLARE @CurrentUTCDate DATE = @CurrentUTCDateTime
		DECLARE @CurrentUTCTime TIME = @CurrentUTCDateTime
						
		--DECLARE @OfficeWorkingHours VARCHAR(50) = '8h'   		
		DECLARE @OfficeWorkingHours VARCHAR(50) = (SELECT [Value] FROM CompanySettings WHERE [Key] = 'SpentTime' AND CompanyId = @CompanyId)		
		DECLARE @OfficeWorkingHoursInMs FLOAT = (CONVERT(FLOAT,(REPLACE(ISNULL(@OfficeWorkingHours,8), 'h', '') * 3600000.00)))
			
	    --SELECT @CompanyId CompanyId, @CanAccessAllEmployee CanAccessAllEmployee, @OfficeWorkingHours OfficeWorkingHours, @OfficeWorkingHoursInMs OfficeWorkingHoursInMs, @CurrentUTCDateTime CurrentUTCDateTime, @CurrentUTCTime CurrentUTCTime

	-- people who did not finish tracker time		
	SELECT 
	      U.Id AS UserId, 
          CONCAT(U.FirstName,' ',U.SurName) AS FullName,
          U.ProfileImage,
		  IIF((ISNULL(T.TotalTimeInMS, 0) / 60000) < 60, CAST((ISNULL(T.TotalTimeInMS, 0) / 60000) AS NVARCHAR(50)) + 'm', CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) / 60) + 'h ' + ISNULL(CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) % 60),'00') + 'm') AS SpentTime
	FROM TimeSheet TS			
        INNER JOIN [User] U ON U.Id = TS.UserId	AND U.Id <> @OperationsPerformedBy
        INNER JOIN Employee E ON E.UserId = TS.UserId		
        INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
        LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
        LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
        LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
        LEFT JOIN ( SELECT UA.UserId,
							 SUM(UA.Neutral + UA.Productive + UA.UnProductive) TotalTimeInMS
					  FROM UserActivityTimeSummary UA
					  WHERE UA.CreatedDateTime = @CurrentUTCDate AND UA.CompanyId = @CompanyId
					  GROUP BY UA.UserId
					) T ON T.UserId = TS.UserId
        WHERE U.InActiveDateTime IS NULL AND TS.[Date] = @CurrentUTCDate AND U.CompanyId = @CompanyId
        AND (TS.OutTime IS NOT NULL OR ISNULL(SE.EndTime,SW.EndTime) < @CurrentUTCTime) 
		AND (ISNULL(T.TotalTimeInMS, 0) < @OfficeWorkingHoursInMs)
        AND (@CanAccessAllEmployee > 0 OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) 
		     WHERE ChildId <> @OperationsPerformedBy))
		ORDER BY T.TotalTimeInMS

	 END
     IF(@Status = 'idle')
	 BEGIN
	   
	       DECLARE @CurrentDate DATE = CONVERT(DATE,@Date)

           SELECT UserId, 
           	   FullName,		  
           	   ProfileImage,
                  IIF(SpentTime < 60,
           	        CAST(SpentTime AS NVARCHAR(50)) + 'm', 
           			CAST(CAST(ISNULL(SpentTime,0)/60.0 AS INT) AS varchar(100)) + 'h' + ' ' + IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0,'',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+'m')) [SpentTime] 
           FROM
           	(SELECT 
           	       U.Id AS UserId, 
           		   CONCAT(U.FirstName,' ',U.SurName) AS FullName,
           		   U.ProfileImage,
           	       T.IdleInMinutes AS SpentTime
                FROM [User] U
           	         INNER JOIN UserActivityTimeSummary T ON T.[UserId] = U.Id AND T.CreatedDateTime = @CurrentDate
                WHERE U.CompanyId = @CompanyId AND U.InActiveDateTime IS NULL 
				      AND U.UserName <> 'Snovasys.Support@Support'
					  AND U.Id <> @OperationsPerformedBy
					  AND U.IsActive = 1
           		   AND (@CanAccessAllEmployee > 0
           		        OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) WHERE (ChildId <> @OperationsPerformedBy))
           			   )
                --GROUP BY U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage
               ) Main
           	ORDER BY FullName

	 END
	 ELSE
	 BEGIN

	     DECLARE @DateFrom DATETIME = NULL, @DateTo DATETIME = NULL,@IsAllEmployee BIT = NULL,
	        @EntityId UNIQUEIDENTIFIER = NULL, @IsActive BIT = NULL, @IsTrailExpired BIT = NULL

	    DECLARE @Time DATETIME = @Date
	    IF(@DateFrom IS NULL) SET @DateFrom = @Date
	    IF(@DateTo IS NULL) SET @DateTo = @DateFrom

		IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,@Date));
	
		CREATE TABLE #TrackStatusId
		(
		 Id UNIQUEIDENTIFIER,
		 UserId UNIQUEIDENTIFIER,
		 UserName NVARCHAR(100),
		 ProfileImage NVARCHAR(MAX),
		 RoleName NVARCHAR(1000),
		 IsOff BIT
		)

        -- STEP 1: INSERT INTO #TrackStatusId
		INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage, IsOff)
		SELECT DISTINCT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage, 
					    (CASE WHEN ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off') THEN 0 ELSE 1 END)
		FROM ActivityTrackerUserConfiguration AS A -- ActivityTrackerUserConfiguration AS A
		JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= @Date AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= @Date))
					 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
					 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL AND E.UserId = U.Id
				AND (@IsAllEmployee = 1 OR @CanAccessAllEmployee > 0 OR (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId))))
				AND E.TrackEmployee = 1 
				AND U.Id <> @OperationsPerformedBy

        -- STEP 2: INSERT INTO #TrackStatusId
		INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage, IsOff)
		SELECT DISTINCT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage,
						(CASE WHEN ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off') THEN 0 ELSE 1 END)
		FROM ActivityTrackerRoleConfiguration AS A -- ActivityTrackerRoleConfiguration AS A
		JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= @Date AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= @Date))
					 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
					 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
				AND (@IsAllEmployee = 1 OR @CanAccessAllEmployee > 0 OR (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId))))
				AND A.ComapnyId = @CompanyId 
				AND U.Id <> @OperationsPerformedBy
				AND U.Id NOT IN (SELECT UserId FROM #TrackStatusId)
		
        -- STEP 3: INSERT INTO #Track		--TODO : Getting latest active detailes irrespective of date
		SELECT  T.UserId, T.UserName, T.ProfileImage, A.LastActiveDateTime AS ActiveTime
				,(CASE WHEN DATEDIFF(MINUTE,A.LastActiveDateTime,GETUTCDATE()) < 11 THEN 1 ELSE 0 END) AS [Status]
				,(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.LunchBreakStartTime AND (TT.LunchBreakEndTime IS NULL OR @Time <= TT.LunchBreakEndTime) 
					    AND TT.UserId = T.UserId AND TT.Date = @Date) = @Time OR
					   (SELECT @Time FROM UserBreak AS U WHERE ((@Time BETWEEN U.BreakIn AND U.BreakOut) OR (@Time>=U.BreakIn AND U.BreakOut IS NULL))
					    AND  U.UserId = T.UserId AND CONVERT(DATE,U.Date) = @Date) = @Time
					THEN 1
					ELSE 0 
					END) AS IsBreak,
			(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.InTime AND TT.OutTime IS NULL AND TT.Date = CONVERT(date, @Date) AND TT.UserId = T.UserId) = @Time
				THEN 1
				ELSE 0
				END) AS IsOnline,
			ISNULL(L.IsApproved, 0) AS IsLeave
			INTO #Track
			FROM #TrackStatusId AS T
			LEFT JOIN (SELECT UserId, MAX(LastActiveDateTime) AS LastActiveDateTime 
			           FROM [User] U INNER JOIN ActivityTrackerStatus UTS ON UTS.UserId = U.Id AND U.CompanyId = @CompanyId
	                   GROUP BY UserId) A ON A.UserId = T.UserId
            LEFT JOIN (SELECT UserId, LS.IsApproved
				   FROM LeaveApplication LA
				   INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
				   WHERE CONVERT(DATE,@Date) BETWEEN LeaveDateFrom AND LeaveDateTo AND LS.CompanyId = @CompanyId
				  ) AS L ON L.UserId  = T.UserId
		    ORDER BY T.UserName ASC

	    -- STEP 4: INSERT INTO #ScreenshotCount
		--SELECT DISTINCT COUNT(*) AS ScreenshotCount, U.Id AS UserId 
		--    INTO #ScreenshotCount
		--	FROM ActivityScreenShot AS A
		--	LEFT JOIN [User] AS U ON U.Id = A.UserId 
		--	WHERE (CONVERT(DATE,A.CreatedDateTime) BETWEEN CONVERT(DATE,@DateFrom) AND CONVERT(DATE,@DateTo)) AND A.CreatedDateTime IS NOT NULL
		--		AND U.CompanyId = @CompanyId
		--	GROUP BY U.Id
		
		-- STEP 5: INSERT INTO RESULT(#Tra) FROM #Track AND #ScreenshotCount
		--SELECT 
		--    DISTINCT T.UserId, T.UserName, T.ProfileImage, T.ActiveTime,T.IsTracking AS [Status],
		--	(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.LunchBreakStartTime AND (TT.LunchBreakEndTime IS NULL OR @Time <= TT.LunchBreakEndTime) 
		--			    AND TT.UserId = T.UserId AND TT.Date = @Date) = @Time OR
		--			   (SELECT @Time FROM UserBreak AS U WHERE ((@Time BETWEEN U.BreakIn AND U.BreakOut) OR (@Time>=U.BreakIn AND U.BreakOut IS NULL))
		--			    AND  U.UserId = T.UserId AND CONVERT(DATE,U.Date) = @Date) = @Time
		--			THEN 1
		--			ELSE 0 
		--			END) AS IsBreak,
		--	(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.InTime AND TT.OutTime IS NULL AND TT.Date = CONVERT(date, @Date) AND TT.UserId = T.UserId) = @Time
		--		THEN 1
		--		ELSE 0
		--		END) AS IsOnline,
		--	ISNULL(L.IsApproved, 0) AS IsLeave
		--INTO #Tra
		--FROM #Track AS T
		----LEFT JOIN #ScreenshotCount AS S ON S.UserId = T.UserId
		--LEFT JOIN (SELECT UserId, LS.IsApproved
		--		   FROM LeaveApplication LA
		--		   INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
		--		   WHERE CONVERT(DATE,@Date) BETWEEN LeaveDateFrom AND LeaveDateTo AND LS.CompanyId = @CompanyId
		--		  ) AS L ON L.UserId  = T.UserId
		--ORDER BY T.UserName ASC

        -- STEP 6: RETURN RESULT(#Track)
        IF (@Status = 'online')
		    SELECT UserId, UserName AS FullName, ProfileImage, ActiveTime, [Status], IsOnline, IsBreak, IsLeave FROM #Track
			WHERE [Status] = 1 AND [IsLeave] = 0
				 AND UserId <> @OperationsPerformedBy
			ORDER BY UserName ASC

        IF (@Status = 'offline')
		BEGIN
			SELECT UserId, UserName AS FullName, ProfileImage, ActiveTime,
			       (CASE WHEN [IsLeave] = 1 THEN 'Leave' 
				         WHEN [IsBreak] = 1 THEN 'Break'
						 ELSE 'Offline' END) [Status], 
				   IsOnline, IsBreak, IsLeave FROM #Track
			WHERE [Status] = 0 -- AND [IsLeave] = 0 AND [IsBreak] = 0
				 AND UserId <> @OperationsPerformedBy
			ORDER BY UserName ASC
        END

     END

	END
	ELSE
    BEGIN
         RAISERROR (@HavePermission,11, 1)
    END
  END TRY
  BEGIN CATCH        
        THROW  
  END CATCH 

END
GO
