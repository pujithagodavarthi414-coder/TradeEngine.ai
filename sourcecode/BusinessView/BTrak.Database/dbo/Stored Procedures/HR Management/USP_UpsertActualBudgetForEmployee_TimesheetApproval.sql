CREATE PROCEDURE [dbo].[USP_UpsertActualBudgetForEmployee_TimesheetApproval]
(	@FromDate DATETIME ,
    @ToDate DATETIME ,
	@UserId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
        IF (@HavePermission = '1')
        BEGIN

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       		   
			   DECLARE @Currentdate DATETIME = GETDATE()
			   
				DECLARE @StatusId  UNIQUEIDENTIFIER = (SELECT Id FROM RosterPlanStatus WHERE StatusOrder = 3)

				DECLARE	@RequestId UNIQUEIDENTIFIER
				DECLARE @IncludeHoliday  BIT
				DECLARE @IncludeWeekend  BIT
		
				DECLARE @TimeSpent AS TABLE
				(
					UserId UNIQUEIDENTIFIER,
					EmployeeId UNIQUEIDENTIFIER,
					RequestDate DATETIME,
					TimeSpent INT,
					RatePerHour decimal(14,2),
					FromTime Time,
					ToTime Time,
					IncludeHoliday BIT,
					IncludeWeekend BIT,
					IsHoliday BIT
				)

				DECLARE @Holidays as Table
				(
					HolidayDate datetime
				)

				DECLARE @DATES AS TABLE
				(
					Id int Identity(1,1),
					RefDate datetime,
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
				AND CONVERT(DATE, h.Date) BETWEEN CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate)

				INSERT INTO @TimeSpent(UserId,EmployeeId,RequestDate,TimeSpent, FromTime, ToTime, IncludeHoliday, IncludeWeekend, IsHoliday)
				SELECT U.Id, RAP.ActualEmployeeId, CONVERT(DATE, TSP.Date), DATEDIFF(MINUTE,TSP.StartTime, TSP.EndTime),
					CONVERT(TIME, TSP.StartTime), CONVERT(TIME, TSP.EndTime), RR.IncludeHolidays, RR.IncludeWeekends,
				case when (IncludeHolidays = 1 AND PlanDate in (select HolidayDate from @Holidays))
					OR (IncludeWeekends = 1 AND LOWER(DATENAME(WEEKDAY, PlanDate)) IN  (SELECT LOWER(WeekDayName) FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1))
				then 1  else 0 end
				FROM RosterActualPlan RAP
				INNER JOIN RosterRequest RR ON RAP.RequestId = RR.Id
				INNER JOIN Employee E on E.Id = RAP.ActualEmployeeId
				INNER JOIN [User] U ON U.Id = E.UserId
				INNER JOIN TimeSheetPunchCard TSP ON TSP.UserId = U.Id
				WHERE TSP.UserId = ISNULL(@UserId , @OperationsPerformedBy) AND TSP.CompanyId = @CompanyId
													AND [Date] BETWEEN @FromDate AND @ToDate

				insert into @DATES
				select distinct RequestDate, IsHoliday from @TimeSpent
				
				DECLARE @max int = @@ROWCOUNT
				DECLARE @count int = 1;
				DECLARE @date datetime
				DECLARE @IsHoliday BIT
				WHILE(@count <= @max)
				BEGIN
					SELECT @date = RefDate,  @IsHoliday = IsHoliday FROM @DATES WHERE ID = @count

					UPDATE T SET t.RatePerHour = 
					CASE datepart(DW, RequestDate) WHEN 1 THEN COALESCE(E.RatePerHourSun, E.RatePerHour)
							WHEN 2 THEN COALESCE(E.RatePerHourMon, E.RatePerHour)
							WHEN 3 THEN COALESCE(E.RatePerHourTue, E.RatePerHour)
							WHEN 4 THEN COALESCE(E.RatePerHourWed, E.RatePerHour)
							WHEN 5 THEN COALESCE(E.RatePerHourThu, E.RatePerHour)
							WHEN 6 THEN COALESCE(E.RatePerHourFri, E.RatePerHour)
							WHEN 7 THEN COALESCE(E.RatePerHourSat, E.RatePerHour)
						END
					from EmployeeRateSheet e
					INNER JOIN @TimeSpent T on T.EmployeeId = E.RateSheetEmployeeId AND T.RequestDate = @date
					WHERE @date BETWEEN E.RateSheetStartDate AND E.RateSheetEndDate AND
					(
						( @IsHoliday = 0 AND E.RateSheetForId IN (select Id from RateSheetFor WHERE CompanyId = @CompanyId AND RateSheetForName like '%Regular%'))
						OR ( @IsHoliday = 1 AND E.RateSheetForId IN (select Id from RateSheetFor WHERE CompanyId = @CompanyId AND RateSheetForName not like '%Regular%'))
					)
					AND E.CompanyId = @CompanyId
					AND InActiveDateTime is null
					AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE, RateSheetEndDate)
					AND @date BETWEEN RateSheetStartDate AND RateSheetEndDate
					SET @count = @count + 1;
				END
	
				UPDATE R SET R.ActualFromTime = T.FromTime,
								R.ActualToTime = T.ToTime,
								R.ActualRate = CONVERT(DECIMAL(14,2),T.RatePerHour * (T.TimeSpent)/ 60) 
				FROM RosterActualPlan R
				INNER JOIN @TimeSpent T ON R.ActualEmployeeId = T.EmployeeId AND CONVERT(DATE, R.PlanDate) = CONVERT(DATE, T.RequestDate)
						
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