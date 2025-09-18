CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterTemplatePlanByRequest]
(
	@StartDate Datetime,
	@RequestId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			DECLARE @TotalDays INT, @count int, @max int
			DECLARE @IncludeHolidays INT = 1, @IncludeWeekends INT =1, @TotalWorkingHours INT

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @Holidays as Table
			(
				HolidayDate datetime
			)

			DECLARE @TemplateData as Table
			(
				PlanId UNIQUEIDENTIFIER,
				PlanDate Datetime,
				DepartmentId UNIQUEIDENTIFIER,
				DepartmentName NVARCHAR(250),
				ShiftId UNIQUEIDENTIFIER,
				ShiftName NVARCHAR(250),
				SolutionId UNIQUEIDENTIFIER,
				EmployeeId UNIQUEIDENTIFIER,
				EmployeeName NVARCHAR(250),
				EmployeeProfileImage NVARCHAR(max),
				TotalRate money,
				FromTime TIME,
				ToTime TIME,
				CurrencyCode varchar(50),
				IsArchived bit,
				AvailableStatus NVARCHAR(150),
				RequestId UNIQUEIDENTIFIER,
				BreakMins int
			)

			DECLARE @DATES AS TABLE
			(
				Id int Identity(1,1),
				RefDate datetime,
				ActualDate datetime,
				IsHoliday bit
			)

			INSERT INTO @Holidays
			SELECT DISTINCT H.Date FROM [User] U
			INNER JOIN Employee E ON E.UserId = U.Id
			INNER JOIN EmployeeEntityBranch EB on EB.EmployeeId = E.Id AND EB.InactiveDateTime IS NULL
			INNER JOIN Branch B ON B.Id = EB.BranchId
			INNER JOIN Country C ON C.ID = B.CountryId
			INNER JOIN Holiday H ON H.BranchId = C.Id
			WHERE U.CompanyId = @CompanyId AND U.ID = @OperationsPerformedBy AND U.InActiveDateTime IS NULL 
			AND CONVERT(DATE, h.Date) >= CONVERT(DATE, @StartDate)

			INSERT INTO @DATES( RefDate, IsHoliday)
			SELECT DISTINCT CONVERT(DATE, PlanDate),
			CASE WHEN (@IncludeHolidays = 1 AND PlanDate in (select HolidayDate from @Holidays))
				OR (@IncludeWeekends = 1 AND LOWER(DATENAME(WEEKDAY, PlanDate)) IN  (SELECT LOWER(WeekDayName) FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1))
				THEN 1  ELSE 0 END
			FROM RosterActualPlan WHERE RequestId = @RequestId ORDER BY CONVERT(DATE, PlanDate)
			SET @TotalDays = @@ROWCOUNT

			SET @count = 1;
			SET @max = @TotalDays;
			DECLARE @NewRequestId UNIQUEIDENTIFIER
			SELECT @NewRequestId = NEWID()
			declare @dateChecker datetime = @StartDate

			WHILE(@count <= @max)
			BEGIN
				if ((@IncludeHolidays = 0 AND @dateChecker in (select HolidayDate from @Holidays))
					OR (@IncludeWeekends = 0 AND LOWER(DATENAME(WEEKDAY, @dateChecker)) IN  (SELECT LOWER(WeekDayName) FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1))
				)
				begin
					set @dateChecker = DATEADD(day, 1, @dateChecker)
				end
				else
				begin
					UPDATE @DATES set ActualDate = @dateChecker where id = @count
					set @dateChecker = DATEADD(day, 1, @dateChecker)
					set @count = @count + 1
				end
			END

			CREATE table #EmployeeRates 
			(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RefId INT,
				CreatedDate Datetime,
				EmployeeId UNIQUEIDENTIFIER,
				Rate FLOAT null,
				IsPermanent bit
			)

			CREATE table #EmployeeList 
			(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				CreatedDate Datetime,
				StartTime TIME,
				EndTime TIME,
				EmployeeIds NVARCHAR(MAX),
				OperationsPerformedBy UNIQUEIDENTIFIER
			)
			INSERT INTO #EmployeeList
			SELECT D.ActualDate, PlannedFromTime, PlannedToTime, PlannedEmployeeId, @OperationsPerformedBy
			FROM RosterRequest RR
			INNER JOIN RosterActualPlan RAP ON RR.ID = RAP.RequestId AND RR.CompanyId = RAP.CompanyId AND RAP.InActiveDateTime IS NULL
			INNER JOIN @DATES D ON D.RefDate = CONVERT(DATE, PlanDate)
			INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
			WHERE RR.ID = @RequestId

			DECLARE @EMPCOUNTER INT  = 1, @EMPCOUNT INT
			SELECT @EMPCOUNT = MAX(ID) FROM #EmployeeList
			WHILE(@EMPCOUNTER <= @EMPCOUNT)
			BEGIN
				DECLARE @CreationDate DateTime,
						@StartTime TIME,
						@EndTime TIME,
						@EmployeeIds NVARCHAR(MAX)

				SELECT @CreationDate = CreatedDate,  @StartTime = StartTime, @EndTime = EndTime, @EmployeeIds = EmployeeIds from #EmployeeList WHERE Id = @EMPCOUNTER

				INSERT INTO #EmployeeRates
				EXEC [dbo].[USP_GetEmployeeRosterRates] @CreationDate, @StartTime, @EndTime, @EmployeeIds, @OperationsPerformedBy

				SET @EMPCOUNTER  = @EMPCOUNTER  + 1
			END
			
			
			SELECT DISTINCT NEWID() PlanId,
				dt.ActualDate PlanDate,
				RAP.DepartmentId,
				D.DepartmentName,
				RAP.ShiftId,
				'' ShiftName,
				RAP.SolutionId,
				RAP.PlannedEmployeeId EmployeeId,
				U.FirstName + COALESCE(' ' + U.SurName,'') EmployeeName,
				U.ProfileImage EmployeeProfileImage,
				EmployeeRate.Rate [TotalRate],
				RAP.PlannedFromTime FromTime,
				RAP.PlannedToTime ToTime,					
				C.CurrencyCode,
				CASE WHEN RAP.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				CASE WHEN notAvailable.EmployeeCount > 0 THEN 'Not Available'
						WHEN Onleave.EmployeeLeaveCount > 0 THEN 'On Leave' ELSE NULL END AvailableStatus,
				@NewRequestId RequestId,
				COALESCE(ShiftWeek.AllowedBreakTime, rr.RequiredBreakMins, 0) BreakMins,
				TotalCount = COUNT(1) OVER()
			FROM RosterRequest RR
			INNER JOIN RosterActualPlan RAP ON RR.ID = RAP.RequestId AND RR.CompanyId = RAP.CompanyId AND RAP.InActiveDateTime IS NULL
			INNER JOIN EmployeeBranch EB ON EB.EmployeeId = rap.PlannedEmployeeId and EB.BranchId = RR.BranchId
			inner join @DATES Dt on dt.RefDate = CONVERT(DATE, PlanDate)
			INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
			INNER JOIN [User] U ON U.ID = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
			LEFT JOIN Currency C ON C.Id = rap.CurrencyCode
			LEFT JOIN Department D ON D.Id = RAP.DepartmentId
			LEFT JOIN ShiftTiming ST ON ST.Id = RAP.ShiftId
			OUTER APPLY (
				SELECT AllowedBreakTime FROM ShiftWeek SW WHERE SW.ShiftTimingId = ST.Id AND LOWER(SW.[DayOfWeek]) = DATENAME(WEEKDAY, Dt.ActualDate)
			) AS ShiftWeek
			OUTER APPLY (
				SELECT COUNT(DISTINCT RAP1.PlannedEmployeeId) EmployeeCount FROM RosterRequest RR1
				INNER JOIN RosterActualPlan RAP1 ON RR1.ID = RAP1.RequestId AND RR1.CompanyId = RAP1.CompanyId AND RAP1.InActiveDateTime IS NULL --and rap1.RequestId <> '83159B39-0D1B-0F1A-E5C7-09337E031CC3'
				INNER JOIN RosterPlanStatus RAS ON RAS.ID = RAP1.PlanStatusId AND RAS.STATUSNAME != 'Draft'
				WHERE RAP1.PlannedEmployeeId = rap.PlannedEmployeeId and CONVERT(DATE, RAP1.PlanDate) =  CONVERT(DATE, Dt.ActualDate) AND RR1.InActiveDateTime IS NULL
			) AS notAvailable
			OUTER APPLY (
			SELECT COUNT(DISTINCT USERID) EmployeeLeaveCount FROM LeaveApplication LA
			INNER JOIN LeaveStatus S ON S.Id = LA.OverallLeaveStatusId AND S.LeaveStatusName='Approved' AND S.CompanyId = @CompanyId
			WHERE LA.UserId = U.Id AND Dt.ActualDate BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo
			) AS Onleave
			OUTER APPLY(
				SELECT * FROM #EmployeeRates ER WHERE ER.EmployeeId = E.Id AND CONVERT(DATE, ER.CreatedDate) = CONVERT(DATE, Dt.ActualDate)
			) EmployeeRate
			WHERE RR.ID = @RequestId  AND PlannedFromTime IS NOT NULL
			order by PlanDate

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