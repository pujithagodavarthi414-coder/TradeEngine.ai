--EXEC [dbo].[USP_GetAvailabilityCalendar]'EBBAF194-5893-430C-B648-4E4C9E8AC2B7','2020-12-01','2020-12-31'
CREATE PROCEDURE [dbo].[USP_GetAvailabilityCalendar]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
		
		IF(@HavePermission = '1')
		BEGIN
			
			DECLARE @ApprovedStatus UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus 
												WHERE CompanyId = @CompanyId AND IsApproved = 1 
												      AND IsApproved IS NOT NULL AND InActiveDateTime IS NULL)
				
				IF(@DateFrom IS NULL) SET @DateFrom = GETDATE()
				
				IF(@DateTo IS NULL) SET @DateTo = GETDATE()

				SELECT @DateFrom = CONVERT(DATE,@DateFrom),@DateTo = CONVERT(DATE,@DateTo)

				DECLARE @FeatureIdCount INT = (SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			                               AND UR.InactiveDateTime IS NULL
			                               AND RF.InactiveDateTime IS NULL
			                               WHERE UR.UserId = @OperationsPerformedBy AND RF.FeatureId = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5')

				CREATE TABLE #CalenderData 
				(
					Id INT IDENTITY(1,1)
					,[Date] DATETIME
					,UserId UNIQUEIDENTIFIER
					,IsAllDay BIT DEFAULT 0
					,IsBlock BIT DEFAULT 1
					,StartTime DATETIME
					,EndTime DATETIME
					,Color NVARCHAR(50)
					,[Subject] NVARCHAR(250)
					,IsOnLeave BIT
					,IsHoliday BIT
					,IsNoShift BIT
					,LeaveCount FLOAT
				)

			   INSERT INTO #CalenderData([Date],UserId)
			   SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date],U.Id AS UserId
			   FROM MASTER..SPT_VALUES MSPT
			   INNER JOIN [User] U ON 1 = 1 AND U.CompanyId = @CompanyId
			   WHERE MSPT.NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo) AND [Type] = 'P'
					 AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
					 AND (@UserId IS NULL OR @UserId = U.Id)
					 AND (@FeatureIdCount > 0 OR U.Id IN (SELECT ChildId FROM dbo.Ufn_ReportedMembersByUserId(@OperationsPerformedBy,@CompanyId)))

			   UPDATE #CalenderData SET StartTime = [Date] + CAST (ISNULL(SE.StartTime,SW.StartTime) AS DATETIME)
								,EndTime = [Date] + CAST(ISNULL(SE.EndTime,SW.EndTime) AS DATETIME)
			   --SELECT ISNULL(SE.StartTime,SW.StartTime),ISNULL(SE.EndTime,SW.EndTime),U.*
			   FROM #CalenderData U
				JOIN Employee E WITH (NOLOCK) ON E.UserId = U.UserId --AND (U.CompanyId = @CompanyId)
					 --INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					 --           AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
								--AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
								--AND EB.EmployeeId IN (SELECT EmployeeId FROM #Employees)
								--AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			   LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  
			AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,[Date]) 
			AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,[Date])))) AND ES.InActiveDateTime IS NULL
						LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
			LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,[Date])
			LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = [Date]
						--LEFT JOIN Branch HMB ON HMB.Id = EB.BranchId  
	
			UPDATE #CalenderData SET IsHoliday = 1,[Subject] = 'Holiday',Color = 'Yellow'
			FROM #CalenderData D
				 LEFT JOIN Holiday H ON H.[Date] = D.[Date] AND H.CompanyId = @CompanyId
			WHERE H.Id IS NOT NULL

			--ref : Ufn_GetLeaveDatesOfAnUser
			 UPDATE #CalenderData SET StartTime = T.StartTime , EndTime = T.EndTime,[Subject] = T.LeaveReason,IsOnLeave = IIF(T.[Date] IS NOT NULL,1,0),Color = 'Red'
			 FROM #CalenderData D
				  LEFT JOIN (
					SELECT T.[Date],D.UserId,
									  LAP.[LeaveReason],
									  CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN NULL
									  ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) 
												THEN   DATEADD(MINUTE,DATEDIFF(MINUTE,T.[Date] + CAST(SW.StartTime AS DATETIME),T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59')) / 2  
																	  ,T.[Date] + CAST(SW.StartTime AS DATETIME))
											ELSE T.[Date] + CAST(SW.StartTime AS DATETIME) END 
									  END AS StartTime,
									  CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN NULL
									  ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) 
												THEN DATEADD(MINUTE,DATEDIFF(MINUTE,T.[Date] + CAST(SW.StartTime AS DATETIME),T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59')) / 2  
																	  ,T.[Date] + CAST(SW.StartTime AS DATETIME))
									  ELSE T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59') END END AS EndTime 
									  ,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN 0
											ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
											ELSE 1 END END AS Cnt
									  FROM
						(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
								FROM MASTER..SPT_VALUES MSPT
								JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
													   AND (LA.OverAllLeaveStatusId = @ApprovedStatus)
													   AND (LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo OR LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)) T
								JOIN LeaveApplication LAP ON LAP.Id = T.Id 
								INNER JOIN #CalenderData D ON D.UserId = LAP.UserId
								JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
								JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
								JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
								JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
								LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
								JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId
								JOIN Branch B ON B.Id = ST.BranchId
								JOIN TimeZone TZ ON TZ.Id = B.TimeZoneId
								LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
								LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
					  WHERE T.[Date] BETWEEN @DateFrom AND @DateTo
					  ) T ON T.[Date] = D.[Date] AND T.UserId = D.UserId
			   WHERE T.[Date] IS NOT NULL

			   UPDATE #CalenderData SET IsNoShift = 1,[Subject] = 'No Shift',Color = 'Gray',StartTime = [Date],EndTime = [Date] + CAST('23:59:59' AS DATETIME)
			   WHERE StartTime IS NULL AND EndTime IS NULL
	   
			   UPDATE #CalenderData SET [Subject] = 'Available',Color = 'Green' WHERE IsNoShift IS NULL AND IsHoliday IS NULL AND IsOnLeave IS NULL

			   INSERT INTO #CalenderData([Date],UserId,IsAllDay,IsBlock,StartTime,EndTime,Color,[Subject])
			   SELECT U.[Date],U.UserId,U.IsAllDay,U.IsBlock
					 ,([Date] + CAST (ISNULL(SE.StartTime,SW.StartTime) AS DATETIME))
					 ,DATEADD(MINUTE,-1,U.StartTime),'Green','Available'
			   --,([Date] + CAST (ISNULL(SE.StartTime,SW.StartTime) AS DATETIME)),([Date] + CAST (ISNULL(SE.EndTime,SW.EndTime) AS DATETIME))
			   FROM #CalenderData U
				 LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.UserId --AND (U.CompanyId = @CompanyId)
				 LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  
							AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,[Date]) 
							AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,[Date])))) AND ES.InActiveDateTime IS NULL
				 LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
				 LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,[Date])
				 LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = [Date]
			   WHERE IsOnLeave IS NOT NULL 
					 AND IsOnLeave = 1
					 AND (U.StartTime > ([Date] + CAST (ISNULL(SE.StartTime,SW.StartTime) AS DATETIME)))

			   INSERT INTO #CalenderData([Date],UserId,IsAllDay,IsBlock,StartTime,EndTime,Color,[Subject])
			   SELECT U.[Date],U.UserId,U.IsAllDay,U.IsBlock
					 ,DATEADD(MINUTE,1,U.EndTime)
					 ,([Date] + CAST (ISNULL(SE.EndTime,SW.EndTime) AS DATETIME)),'Green','Available'
			   FROM #CalenderData U
				 LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.UserId --AND (U.CompanyId = @CompanyId)
				 LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  
							AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,[Date]) 
							AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,[Date])))) AND ES.InActiveDateTime IS NULL
				 LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
				 LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,[Date])
				 LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = [Date]
			   WHERE IsOnLeave IS NOT NULL 
					 AND IsOnLeave = 1
					 AND (U.EndTime < ([Date] + CAST (ISNULL(SE.EndTime,SW.EndTime) AS DATETIME)))

			   SELECT Id,UserId,StartTime,EndTime,IsAllDay,IsBlock,Color,[Subject]
			   FROM #CalenderData

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO
