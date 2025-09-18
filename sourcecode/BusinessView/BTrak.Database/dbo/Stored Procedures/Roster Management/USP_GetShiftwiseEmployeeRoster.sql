CREATE PROCEDURE [dbo].[USP_GetShiftwiseEmployeeRoster]
(
	@StartDate Datetime,
	@EndDate datetime,
	@IncludeHolidays bit,
	@IncludeWeekends bit,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ShiftIds varchar(max),
	@Branchid UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @Holidays as Table
			(
				HolidayDate datetime
			)

			DECLARE @Shifts as Table
			(
				ShiftId UNIQUEIDENTIFIER
			);
			
			INSERT INTO  @Shifts
			SELECT value from openjson(@ShiftIds)

			IF EXISTS (SELECT * FROM ShiftTiming st
				INNER JOIN @Shifts s on st.id = s.ShiftId
				INNER JOIN ShiftWeek sw on sw.ShiftTimingId = st.id 
				WHERE sw.EndTime IS NULL)
			BEGIN
				RAISERROR(50027,16, 1,'ShiftTimingShouldNotBeNull')
			END
			ELSE 
			BEGIN

				DECLARE @Dates as Table
				(
					Id int identity(1,1) PRIMARY KEY,
					RefDate Datetime,
					IsHoliday bit
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
				
				CREATE table #EmployeeRates 
				(
					Id INT IDENTITY(1,1) PRIMARY KEY,
					RefId INT,
					CreatedDate Datetime,
					EmployeeId UNIQUEIDENTIFIER,
					Rate FLOAT null,
					IsPermanent bit
				)

				INSERT INTO  @Shifts
				SELECT value from openjson(@ShiftIds)

				INSERT INTO @Holidays
				SELECT DISTINCT H.Date FROM [User] U
				INNER JOIN Employee E ON E.UserId = U.Id
				INNER JOIN EmployeeEntityBranch EB on EB.EmployeeId = E.Id AND EB.InactiveDateTime IS NULL
				INNER JOIN Branch B ON B.Id = EB.BranchId
				--INNER JOIN Region r on r.id = b.RegionId
				INNER JOIN Country C ON C.ID = B.CountryId
				INNER JOIN Holiday H ON H.BranchId = C.Id
				WHERE U.CompanyId = @CompanyId AND U.ID = @OperationsPerformedBy AND U.InActiveDateTime IS NULL 
				AND CONVERT(DATE, h.Date) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
		
				;WITH DateGenerator as(
					select @StartDate ReqDate
					union all
					select dateadd(dd, 1, ReqDate) from DateGenerator where ReqDate < @EndDate
				)

				INSERT INTO @Dates
				SELECT reqdate,
					case when (@IncludeHolidays = 1 AND ReqDate in (select HolidayDate from @Holidays))
					OR (@IncludeWeekends = 1 AND LOWER(DATENAME(WEEKDAY, ReqDate)) IN  (SELECT LOWER(WeekDayName) FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1))
					then 1  else 0 end
				FROM DateGenerator
				WHERE (@IncludeHolidays = 1 or (@IncludeHolidays = 0 and ReqDate NOT in (select HolidayDate from @Holidays)))
				AND (@IncludeWeekends = 1 OR (@IncludeWeekends = 0 AND LOWER(DATENAME(WEEKDAY, ReqDate)) NOT IN  (SELECT LOWER(WeekDayName) FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1)))

				;with cte
				as
				(
					SELECT distinct dt.RefDate StartDate, SW.StartTime, SW.EndTime, E.Id EmployeeId
					FROM Employee E
					inner join @Dates dt on 1=1 
					INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
					INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
					INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.Id IN (select ShiftId from @Shifts)
					INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND LOWER(SW.DayOfWeek) = LOWER(DATENAME(WEEKDAY, dt.RefDate))
					INNER JOIN EmployeeBranch EB ON E.Id= EB.EmployeeId AND EB.BranchId = @Branchid
					WHERE U.COMPANYID = @CompanyId
					
					AND ( (ES.ActiveTo IS NOT NULL AND (@StartDate BETWEEN ES.ActiveFrom AND ES.ActiveTo OR @EndDate BETWEEN ES.ActiveFrom AND ES.ActiveTo OR ES.ActiveFrom BETWEEN @StartDate AND @EndDate OR ES.ActiveTo BETWEEN @StartDate AND @EndDate))
	  		         OR (ES.ActiveTo IS NULL AND @EndDate >= ES.ActiveFrom)
	  			   )
				)

				INSERT INTO #EmployeeList
				select StartDate, StartTime, EndTime, '[' +
				STUFF((
						SELECT '","' + CAST(T1.employeeid AS varchar(38))
							FROM cte t1
						WHERE t1.StartTime = t0.StartTime and t1.EndTime = t0.EndTime and t1.StartDate = t0.StartDate
						ORDER BY t1.employeeid
							FOR XML PATH('')), 1, LEN(',"'), '') + '"]', @OperationsPerformedBy
				FROM cte t0
				GROUP BY StartDate, StartTime, EndTime

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

				DECLARE @SolId UNIQUEIDENTIFIER = NEWID()
				DECLARE @CurrencyId VARCHAR(50);
				SELECT @CurrencyId = S.CurrencyCode FROM Company C
				INNER JOIN SYS_Currency S ON S.Id = C.CurrencyId
				WHERE C.Id = @CompanyId

				DECLARE @NewRequestId UNIQUEIDENTIFIER
				SELECT @NewRequestId = NEWID()
				SELECT NEWID() PlanId,* FROM (
				SELECT DISTINCT 
				CONVERT(DATE, dt.RefDate) PlanDate,
				J.DepartmentId,
				D.DepartmentName,
				ST.Id ShiftId,
				ST.ShiftName,
				@SolId SolutionId,
				E.Id EmployeeId,
				U.FirstName + COALESCE(' ' + U.SurName,'') EmployeeName,
				U.ProfileImage EmployeeProfileImage,
				EmployeeRate.Rate TotalRate,
				sw.StartTime FromTime,
				sw.EndTime ToTime,					
				@CurrencyId CurrencyCode,
				@NewRequestId RequestId,
				COALESCE(SW.AllowedBreakTime, 0) BreakMins,
				EmployeeRate.IsPermanent
				FROM Employee E
				INNER JOIN @Dates dt on 1=1 
				INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
				INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
				INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.Id IN (SELECT ShiftId FROM @Shifts)
				INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND LOWER(SW.DayOfWeek) = LOWER(DATENAME(WEEKDAY, dt.RefDate))
				LEFT JOIN Job J ON J.EmployeeId = E.Id
				LEFT JOIN Department D ON D.Id = J.DepartmentId
				OUTER APPLY (
					SELECT COUNT(DISTINCT RAP1.PlannedEmployeeId) EmployeeCount FROM RosterRequest RR1
					INNER JOIN RosterActualPlan RAP1 ON RR1.ID = RAP1.RequestId AND RR1.CompanyId = RAP1.CompanyId AND RAP1.InActiveDateTime IS NULL --and rap1.RequestId <> '83159B39-0D1B-0F1A-E5C7-09337E031CC3'
					INNER JOIN RosterPlanStatus RAS ON RAS.ID = RAP1.PlanStatusId AND RAS.STATUSNAME != 'Draft'
					WHERE RAP1.PlannedEmployeeId = E.Id and CONVERT(DATE, RAP1.PlanDate) =  CONVERT(DATE, dt.RefDate) AND RR1.InActiveDateTime IS NULL
				) AS notAvailable
				OUTER APPLY (
					SELECT COUNT(DISTINCT USERID) EmployeeLeaveCount FROM LeaveApplication LA
					INNER JOIN LeaveStatus S ON S.Id = LA.OverallLeaveStatusId AND S.LeaveStatusName='Approved' AND S.CompanyId = @CompanyId
					WHERE LA.UserId = U.Id AND dt.RefDate BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo
				) AS Onleave
				OUTER APPLY(
						SELECT * FROM #EmployeeRates ER WHERE ER.EmployeeId = E.Id AND CONVERT(DATE, ER.CreatedDate) = CONVERT(DATE, dt.RefDate)
				) EmployeeRate
				WHERE notAvailable.EmployeeCount <= 0 AND Onleave.EmployeeLeaveCount <=0
				AND E.Id IN (
					SELECT EEB2.EmployeeId FROM [User] U1
					INNER JOIN [Employee] E1 ON E1.UserId = U1.Id
					INNER JOIN EmployeeBranch EEB2 ON EEB2.EmployeeId = E1.Id  
					WHERE EEB2.BranchId = @Branchid
				)
				AND SW.EndTime IS NOT NULL
				AND ( (ES.ActiveTo IS NOT NULL AND DT.RefDate BETWEEN ES.ActiveFrom AND ES.ActiveTo)
	  		         OR (ES.ActiveTo IS NULL AND DT.RefDate >= ES.ActiveFrom)
	  			   )
				) AS TEMP
				order by PlanDate
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