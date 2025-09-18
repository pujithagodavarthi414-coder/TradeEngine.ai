----------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeShiftWeek]  @OperationsPerformedBy='2675B10F-E97B-4AF2-B6DA-DE9C07FCF802',@DateFrom='2020-03-05'
----------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeShiftWeek]
(
     @EmployeeId UNIQUEIDENTIFIER = NULL,    
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @DateFrom DATE = NULL,
	 @DateTo DATE = NULL,
	 @StatusId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@DateFrom IS NULL) SET @DateFrom = (SELECT ISNULL(J.JoinedDate,U.RegisteredDateTime) FROM [User] U
						            JOIN Employee E ON E.UserId = U.Id AND U.Id = @OperationsPerformedBy
									LEFT JOIN Job J ON J.EmployeeId = E.Id )

         IF (@HavePermission = '1')
         BEGIN

		CREATE TABLE #TEMP([DATE] DATETIME , [DayofWeek] NVARCHAR(20), UserId UNIQUEIDENTIFIER)
				INSERT INTO #TEMP 
				 SELECT ShiftDates.[DAY],
	    	   ShiftDates.[DayOfWeek],
	           ShiftDates.UserId
	           FROM (
		SELECT T.[DAY],
			  DATENAME(WEEKDAY,T.[DAY]) AS [DayOfWeek],
			  U.Id UserId
		  FROM [User] U
				JOIN (SELECT @OperationsPerformedBy AS UserId,DATEADD(DAY,NUMBER,@DateFrom) AS [DAY] from Master..SPT_Values WHERE [Type]='p' AND Number <= DATEDIFF(DAY,@DateFrom,GETDATE())) T ON T.UserId = U.Id
				JOIN Employee E ON E.UserId = U.Id AND U.Id = @OperationsPerformedBy) ShiftDates 
				INSERT INTO #TEMP 
				
				SELECT CONVERT(DATE,PlanDate),DATENAME(WEEKDAY,PlanDate) , E.UserId FROM RosterActualPlan RAP 
									JOIN Employee E ON E.Id = RAP.ActualEmployeeId AND E.UserId = @OperationsPerformedBy
									JOIN RosterPlanStatus RPS ON RPS.Id = RAP.PlanStatusId AND RPS.StatusOrder = 3
									 WHERE CONVERT(DATE,PlanDate) NOT IN (SELECT [Date] FROM #TEMP) GROUP BY CONVERT(DATE,PlanDate),DATENAME(WEEKDAY,PlanDate), RAP.PlanDate , E.UserId

      	    DECLARE @MaxDate DATETIME = (SELECT MAX([DATE]) FROM #TEMP)

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @LeaveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)

			SELECT U.FirstName+''+ISNULL(U.SurName,'') UserName,
				 DATENAME(WEEKDAY,T.[DATE]) [DayOfWeek],
				 T.[DATE] [Day],
				 IIF(TSPC.EndTime IS NULL,
					IIF(TS.OutTime IS NULL, NULL , DATEDIFF(MINUTE,TS.InTime,TS.OutTime)),DATEDIFF(MINUTE,TSPC.StartTime,TSPC.EndTime)) -
				       IIF(TSPC.Breakmins IS NULL, SUM(ISNULL(DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime),0) + ISNULL(UserBreak.UserBreak,0))
					   ,TSPC.Breakmins) SpentTime,
				 ISNULL(TSPC.StartTime,TS.InTime) InTime,
				 ISNULL(TSPC.EndTime,TS.OutTime) OutTime,
				 IIF(S.Id IS NULL,'Pending for submission', S.StatusName) StatusName,
				 IIF(S.Id IS NULL , (SELECT StatusColour FROM [Status] WHERE CompanyId = @CompanyId AND StatusName = 'Pending for submission'),S.StatusColour) StatusColour,
				 TSPC.RejectedReason,
				 TSPC.IsOnLeave,
				 TSPC.IsRejected,
				 SRT.SortOrder,
				 IIF(TSPC.[Date] IS NULL, SUM(ISNULL(DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime),0) + ISNULL(UserBreak.UserBreak,0))
					   ,TSPC.Breakmins) Breakmins,				 
				 ISNULL(TSPC.StartTime,CONVERT(datetime2, TS.InTime, 1)) InTime,
				 ISNULL(TSPC.EndTime,CONVERT(datetime2, TS.OutTime, 1)) OutTime,
				 SW.StartTime ShiftInTime,
				 SW.EndTime ShiftOutTime,
				 RAP.PlannedFromTime RosterInTime,
				 ST.ShiftName,
				 RR.RosterName,
				 RAP.PlannedToTime RosterOutTime,
				 TSPC.Summary,
				 LA.LeaveReason,
				 H.Reason HolidayReason
			FROM [User] U
						JOIN #TEMP T ON T.UserId = U.Id 
						JOIN Employee E ON E.UserId = U.Id AND U.Id = @OperationsPerformedBy 
						LEFT JOIN EmployeeShift ES ON E.Id = ES.EmployeeId AND ((ES.ActiveFrom <= T.[DATE] AND ES.ActiveTo IS NULL) OR (T.[DATE] BETWEEN ES.ActiveFrom AND ES.ActiveTo AND ES.ActiveTo IS NOT NULL)) AND ES.InActiveDateTime IS NULL
						LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND SW.[DayOfWeek] = DATENAME(WEEKDAY,T.[DATE])
						LEFT JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.CompanyId = @CompanyId
						JOIN StatusReportingOption_New SRT ON SRT.OptionName = DATENAME(WEEKDAY,T.[DATE]) AND SRT.CompanyId = @CompanyId
						LEFT JOIN TimeSheetPunchCard TSPC ON TSPC.[Date] = T.[DATE] AND TSPC.UserId = U.Id  
						LEFT JOIN Holiday H ON H.[Date] = T.[DATE] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId
				        LEFT JOIN TimeSheet TS ON TS.[Date] = T.[DATE] AND TS.UserId = U.Id
						LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetLeaveDatesOfAnUser](@OperationsPerformedBy,NULL,NULL,@DateFrom,@MaxDate,@LeaveStatusId)) LA ON CONVERT(DATE,LA.[Date]) = CONVERT(DATE,T.[Date]) AND LA.[Count] <> 0.5
						LEFT JOIN RosterActualPlan RAP ON E.Id = RAP.ActualEmployeeId AND E.UserId = @OperationsPerformedBy AND CONVERT(DATE,RAP.PlanDate) = T.[DATE] 
						LEFT JOIN RosterPlanStatus RPS ON RPS.Id = RAP.PlanStatusId AND RPS.StatusOrder = 3
						LEFT JOIN RosterRequest RR ON RR.Id = RAP.RequestId 
						LEFT JOIN  (SELECT UserId,[Date],SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)) AS UserBreak
									 FROM UserBreak
									 WHERE UserId = @OperationsPerformedBy
									 GROUP BY UserId,[Date]) UserBreak ON UserBreak.UserId = TS.UserId AND TS.[Date] = UserBreak.[Date]
				        LEFT JOIN [Status] S ON S.Id = TSPC.StatusId AND S.CompanyId = @CompanyId
					WHERE  (@DateFrom IS NULL OR  T.[DATE] >= @DateFrom )AND 
						   (@DateTo IS NULL OR T.[DATE] <= @Dateto)
						   AND (@StatusId IS NULL OR @StatusId = S.Id)
					GROUP BY U.FirstName,SW.[DayOfWeek],U.SurName,T.[DATE],TSPC.StartTime,TSPC.EndTime,S.StatusName,S.Id,TSPC.[Date],RPS.StatusColor
								,SRT.SortOrder,TSPC.Breakmins,RejectedReason,TSPC.IsRejected,TSPC.Summary,S.StatusColour,H.Reason,
								 TS.InTime,TS.OutTime,SW.StartTime,SW.EndTime,RAP.PlannedFromTime,RAP.PlannedToTime,LA.LeaveReason,IsOnLeave,ST.ShiftName,RR.RosterName
			ORDER BY T.[DATE]
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