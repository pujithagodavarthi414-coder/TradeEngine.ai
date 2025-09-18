CREATE FUNCTION [dbo].[Ufn_GetLogTimeReport_New]
(
   @SelectedDate DATETIME,
   @BranchId UNIQUEIDENTIFIER,
   @LineManagerId UNIQUEIDENTIFIER,
   @CompanyId UNIQUEIDENTIFIER,
   @EntityId UNIQUEIDENTIFIER = NULL
   ,@CompliantHours NUMERIC(10,3) = NULL
)
RETURNS TABLE
AS
	  RETURN 
	  SELECT U.Id UserId
			,U.ProfileImage UserProfileImage
	        ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName
			,@SelectedDate AS [Date]
	        ,CASE WHEN LA.Id IS NOT NULL THEN 0 ELSE ROUND(ISNULL(((TSInner.SpentTimeWithOutBreaks - ISNULL(UBInner.BreakTime,0))*1.00)/60,0),2) END AS SpentTime
	        ,CAST(ISNULL(LTRInner.SpentTime,0) AS DECIMAL)  AS LogTime,
			  CASE WHEN ((LA.Id IS NOT NULL AND(LT.IsIncludeHolidays IS NULL OR LT.IsIncludeHolidays = 0)) OR LA.Id IS NULL) AND TSInner.SpentTimeWithOutBreaks IS NULL AND (DATENAME(DW,@SelectedDate) NOT IN (SELECT [DayOfWeek] FROM ShiftWeek WHERE ShiftTimingId = ES.ShiftTimingId)) THEN 'rgb(136,170,255)'
			       WHEN ((LA.Id IS NOT NULL AND(LT.IsIncludeHolidays IS NULL OR LT.IsIncludeHolidays = 0)) OR LA.Id IS NULL) AND TSInner.SpentTimeWithOutBreaks IS NULL AND H.[Date] IS NOT NULL THEN 'rgb(0,255,255)'
				   --WHEN LA.UserId IS NOT NULL THEN 'rgb(30,144,255)'
				   WHEN ((IsSecondHalf = 1 AND LA.LeaveDateFrom = @SelectedDate) OR (LA.ToLeaveSessionId = (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId) AND LA.LeaveDateTo = @SelectedDate)) THEN 'rgb(255,51,153)'
				   WHEN LA.UserId IS NOT NULL AND IsSickLeave = 1 THEN 'rgb(252, 198, 226)'
				   WHEN LA.UserId IS NOT NULL AND IsCasualLeave = 1 THEN 'rgb(252, 198, 226)' 
				   WHEN LA.UserId IS NOT NULL AND IsWorkFromHome = 1 THEN 'rgb(214, 172, 118)' 
				   WHEN LA.UserId IS NOT NULL AND IsOnSite = 1 THEN 'rgb(214, 172, 118)' 
				   WHEN LA.UserId IS NOT NULL AND IsWithoutIntimation = 1 THEN 'rgb(255,102,0)' 
				   WHEN @SelectedDate > GETDATE() THEN 	'rgb(200,200,200)'
				   WHEN ISNULL(@CompliantHours,0) <> 0 
				        THEN CASE WHEN ((TSInner.SpentTimeWithOutBreaks - ISNULL(UBInner.BreakTime,0))/60 * 1.0) >= ISNULL(@CompliantHours,0) 
				                        AND ROUND(ISNULL(LTRInner.SpentTime,0),2) >= ISNULL(@CompliantHours,0) THEN 'rgb(4,254,2)'
							      WHEN ((ISNULL(TSInner.SpentTimeWithOutBreaks,0) - ISNULL(UBInner.BreakTime,0))/60.0) < ISNULL(@CompliantHours,0) 
				                        AND CAST(ROUND(ISNULL(LTRInner.SpentTime,0),2) AS DECIMAL(10,2)) >= CAST(ISNULL((((TSInner.SpentTimeWithOutBreaks - ISNULL(UBInner.BreakTime,0))/60.0) * 0.9),0) AS DECIMAL(10,2))
										THEN 'rgb(4,254,2)'
								  ELSE 'rgb(255,0,0)' 
							 END
				   WHEN ROUND(ISNULL(LTRInner.SpentTime,0),2) >= (((TSInner.SpentTimeWithOutBreaks - ISNULL(UBInner.BreakTime,0))/60 * 1.0) * 0.9)
										THEN 'rgb(4,254,2)'
				   ELSE 'rgb(255,0,0)' END AS [Status]
	  FROM [User] U WITH(NOLOCK)
	  JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@LineManagerId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
	  AND U.IsActive = 1 AND U.InACtiveDateTime IS NULL
	  INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
	  INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	             AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
				 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
      JOIN Job J ON J.EmployeeId = E.Id AND CONVERT(DATE,J.JoinedDate) <= CONVERT(DATE,@SelectedDate) AND J.InACtiveDateTime IS NULL
      --JOIN UserActiveDetails UAD ON UAD.UserId = U.OriginalId AND UAD.AsAtInActiveDateTime IS NULL AND ISNULL(UAD.ActiveTo,@SelectedDate) >= @SelectedDate
	  LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((@SelectedDate BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (@SelectedDate > ES.ActiveFrom AND ES.ActiveTo IS NULL))
	  LEFT JOIN Holiday H ON H.[Date] = @SelectedDate AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId
	  LEFT JOIN [dbo].[LeaveApplication] LA WITH (NOLOCK) ON LA.UserId = E.UserId 
	                        AND (LA.IsDeleted IS NULL OR LA.IsDeleted = 0)
							AND LA.InActiveDateTime IS NULL
							AND @SelectedDate BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo AND LA.OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE CompanyId = @CompanyId AND IsApproved = 1)
	  LEFT JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId AND LT.InActiveDateTime IS NULL
	  LEFT JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId 
	  LEFT JOIN LeaveSession LS ON LS.Id = LA.FromLeaveSessionId AND LS.InActiveDateTime IS NULL
	  LEFT JOIN (SELECT TS.UserId, TS.[Date],
	                    ((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, '+00:00'), (CASE WHEN @SelectedDate = CAST(GETDATE() AS DATE) 
	                    AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETUTCDATE() WHEN @SelectedDate <> CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN DATEADD(HH,CAST((SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MaximumWorkingHours') AS INT),SWITCHOFFSET(TS.InTime, '+00:00'))
						ELSE SWITCHOFFSET(TS.OutTime, '+00:00') END)),0) - 
	                    ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))) AS SpentTimeWithOutBreaks
	             FROM TimeSheet TS
	             WHERE [Date] = @SelectedDate
				       AND TS.InActiveDateTime IS NULL
	             GROUP BY TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.InTime,TS.OutTime) TSInner ON TSInner.UserId = U.Id AND TSInner.[Date] = @SelectedDate
	  LEFT JOIN (SELECT SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))) BreakTime,UB.UserId,UB.[Date]
	                    FROM UserBreak UB
	                    WHERE [Date] = @SelectedDate
						      AND UB.InActiveDateTime IS NULL
	                    GROUP BY UB.UserId,UB.[Date]) UBInner ON UBInner.UserId = U.Id AND UBInner.[Date] = @SelectedDate
	  LEFT JOIN (SELECT UST.UserId,CONVERT(DATE,ISNULL(UST.DateTo,ISNULL(UST.EndTime,GETDATE()))) [Date],SUM(UST.SpentTimeInMin * 1.0/60.00) + ISNULL(SUM(DATEDIFF(MINUTE, UST.StartTime, ISNULL(UST.EndTime,GETDATE()))),0) * 1.0/60.00 AS SpentTime
	                    FROM UserStory US WITH(NOLOCK)
						INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
	                    WHERE (@SelectedDate BETWEEN CONVERT(DATE,UST.DateFrom) AND CONVERT(DATE,UST.DateTo) OR @SelectedDate BETWEEN CONVERT(DATE,UST.StartTime) AND CONVERT(DATE,ISNULL(UST.EndTime, GETDATE())))
	                    GROUP BY UST.UserId,CONVERT(DATE,ISNULL(UST.DateTo,ISNULL(UST.EndTime,GETDATE())))) LTRInner ON LTRInner.UserId = U.Id AND LTRInner.[Date] = @SelectedDate
	  GROUP BY U.Id,U.FirstName,U.SurName,BreakTime,SpentTimeWithOutBreaks,U.ProfileImage,LTRInner.SpentTime,LA.UserId,H.[Date],IsFirstHalf,IsSecondHalf
	  ,IsSickLeave,IsCasualLeave,IsWorkFromHome,IsOnSite,IsWithoutIntimation,LA.Id,ES.ShiftTimingId,LA.LeaveDateFrom,LA.LeaveDateTo,LA.ToLeaveSessionId,LT.IsIncludeHolidays
GO