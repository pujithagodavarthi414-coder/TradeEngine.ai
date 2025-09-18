CREATE PROCEDURE [dbo].[USP_UpsertActualBudgetForEmployee]
(
	@UserId UNIQUEIDENTIFIER,
	@TimesheetDate DATETIME,
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
       		   			   
				DECLARE @StatusId  UNIQUEIDENTIFIER = (SELECT Id FROM RosterPlanStatus WHERE StatusOrder = 3)

				DECLARE	@RequestId UNIQUEIDENTIFIER
				DECLARE @FromDate DATETIME
				DECLARE @ToDate DATETIME
				DECLARE @IncludeHoliday  BIT
				DECLARE @IncludeWeekend  BIT
				DECLARE @IsHoliday Bit = 0
				IF EXISTS (
					SELECT DISTINCT H.Date FROM [User] U
					INNER JOIN Employee E ON E.UserId = U.Id
					INNER JOIN EmployeeEntityBranch EB on EB.EmployeeId = E.Id AND EB.InactiveDateTime IS NULL
					INNER JOIN Branch B ON B.Id = EB.BranchId
					INNER JOIN Country C ON C.ID = B.CountryId
					INNER JOIN Holiday H ON H.BranchId = C.Id
					WHERE U.CompanyId = @CompanyId AND U.ID = @OperationsPerformedBy AND U.InActiveDateTime IS NULL 
					AND CONVERT(DATE, h.Date) = CONVERT(DATE, @TimesheetDate))
				BEGIN
					SET @IsHoliday = 1;
				END

				IF EXISTS(SELECT * FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1 AND LOWER(WeekDayName) = LOWER(DATENAME(WEEKDAY, @TimesheetDate)))
				BEGIN
					SET @IsHoliday = 1;
				END

				DECLARE cursor_product CURSOR
				FOR 
					SELECT DISTINCT RR.Id, RequiredFromDate, RequiredToDate, IncludeHolidays, IncludeWeekends FROM RosterRequest RR
					INNER JOIN RosterActualPlan RAP ON RAP.RequestId = RR.Id
					INNER JOIN Employee E ON E.ID = RAP.ActualEmployeeId
					INNER JOIN [User] U ON U.Id = E.UserId
					WHERE U.ID = @UserId AND CONVERT(DATE, @TimesheetDate) BETWEEN CONVERT(DATE, RequiredFromDate) AND CONVERT(DATE, RequiredToDate) AND StatusId = @StatusId
 
				OPEN cursor_product;
 
				FETCH NEXT FROM cursor_product INTO 
					@RequestId, @FromDate, @ToDate, @IncludeHoliday, @IncludeWeekend;
 
				WHILE @@FETCH_STATUS = 0
					BEGIN
		
						DECLARE @TimeSpent AS TABLE
						(
							UserId UNIQUEIDENTIFIER,
							EmployeeId UNIQUEIDENTIFIER,
							RequestDate DATETIME,
							TimeSpent INT,
							RatePerHour decimal(14,2),
							FromTime Time,
							ToTime Time
						)
						INSERT INTO @TimeSpent(UserId,EmployeeId,RequestDate,TimeSpent, FromTime, ToTime)
							SELECT [UserId], EmployeeId, [Date], TimeSpent, FromTime, ToTime
							FROM [dbo].[Ufn_GetTimeSpentForAllEmployee](@UserId, @FromDate, @ToDate, @CompanyId)
		
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
							INNER JOIN @TimeSpent T on T.EmployeeId = E.RateSheetEmployeeId
							WHERE 
							(
								(@IsHoliday = 0 AND E.RateSheetForId IN (select Id from RateSheetFor WHERE CompanyId = @CompanyId AND RateSheetForName like '%Regular%'))
								OR (@IsHoliday = 1 AND E.RateSheetForId IN (select Id from RateSheetFor WHERE CompanyId = @CompanyId AND RateSheetForName not like '%Regular%'))
							)
							AND E.CompanyId = @CompanyId
							AND InActiveDateTime is null
							AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE, RateSheetEndDate)
							AND @TimesheetDate BETWEEN RateSheetStartDate AND RateSheetEndDate
	
						UPDATE R SET R.ActualFromTime = T.FromTime,
									 R.ActualToTime = T.ToTime,
									 R.ActualRate = CONVERT(DECIMAL(14,2),T.RatePerHour * (T.TimeSpent)/ 60) 
						FROM RosterActualPlan R
						INNER JOIN @TimeSpent T ON R.ActualEmployeeId = T.EmployeeId and convert(date, t.RequestDate) = convert(date, r.PlanDate)
						WHERE R.RequestId = @RequestId

						FETCH NEXT FROM cursor_product INTO 
						@RequestId, @FromDate, @ToDate, @IncludeHoliday, @IncludeWeekend;
					END;
 
				CLOSE cursor_product;
 
				DEALLOCATE cursor_product;

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