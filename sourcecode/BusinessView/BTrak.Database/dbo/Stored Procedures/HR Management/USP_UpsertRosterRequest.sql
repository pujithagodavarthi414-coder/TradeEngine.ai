CREATE PROCEDURE [dbo].[USP_UpsertRosterRequest]
(
 @RosterRequest nvarchar(max),
 @RosterSolutions nvarchar(max),
 @RosterPlans nvarchar(max),
 @RosterShift nvarchar(max),
 @RosterDepartment nvarchar(max),
 @RosterAdHoc nvarchar(max),
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION;
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@RosterRequest IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'Employee')

			END
			ELSE IF (@RosterSolutions IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'StartDate')

			END
			ELSE IF (@RosterPlans IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'EndDate')

			END
			ELSE
			BEGIN
			
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


				CREATE TABLE #BasicDetails 
				(
					[RosterName] NVARCHAR(250),
					[RequiredFromDate] DATETIME,
					[RequiredToDate] DATETIME,
					[RequiredBudget] INT,
					[RequiredEmployee] INT,
					[IncludeHolidays] BIT,
					[IncludeWeekends] BIT,
					[TotalWorkingDays] INT,
					[TotalWorkingHours] INT,
					[BranchId] UNIQUEIDENTIFIER
				)

				INSERT INTO #BasicDetails
				SELECT *
				FROM OPENJSON(@RosterRequest)
				WITH (RostName NVARCHAR(250),
					RostStartDate DATETIME,
					RostEndDate DATETIME,
					RostBudget INT,
					RostEmployeeRequired INT,
					IncludeHolidays BIT,
					IncludeWeekends BIT,
					RostMaxWorkDays INT,
					RostMaxWorkHours INT,
					BranchId UNIQUEIDENTIFIER)

				CREATE TABLE #Solutions 
				(
					SolutionId UNIQUEIDENTIFIER,
					SolutionName NVARCHAR(150),
					Budget DECIMAL(14,2)
				)

				INSERT INTO #Solutions
				SELECT *
				FROM OPENJSON(@RosterSolutions)
				WITH (SolutionId UNIQUEIDENTIFIER,
					SolutionName NVARCHAR(150),
					Budget DECIMAL(14,2))


				CREATE TABLE #Plans 
				(
					PlanId UNIQUEIDENTIFIER,
					SolutionId UNIQUEIDENTIFIER,
					PlanDate DATETIME,
					DepartmentId UNIQUEIDENTIFIER,
					DepartmentName NVARCHAR(250),
					ShiftId UNIQUEIDENTIFIER,
					ShiftName NVARCHAR(250),
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(250),
					TotalRate DECIMAL(14,2),
					CurrencyCode NVARCHAR(50),
					FromTime TIME,
					ToTime TIME,
					IsNew BIT
				)

				INSERT INTO #Plans
				SELECT *
				FROM OPENJSON(@RosterPlans)
				WITH (PlanId UNIQUEIDENTIFIER,
					SolutionId UNIQUEIDENTIFIER,
					PlanDate DATETIME,
					DepartmentId UNIQUEIDENTIFIER,
					DepartmentName NVARCHAR(250),
					ShiftId UNIQUEIDENTIFIER,
					ShiftName NVARCHAR(250),
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(250),
					TotalRate DECIMAL(14,2),
					CurrencyCode NVARCHAR(50),
					FromTime TIME,
					ToTime TIME,
					IsNew BIT)

				DECLARE @ReqId UNIQUEIDENTIFIER = NEWID();
				DECLARE @CurrentDate datetime = GETDATE();
				DECLARE @StatusId UNIQUEIDENTIFIER
				select @StatusId = Id from RosterPlanStatus where StatusName = 'Draft'

				INSERT INTO RosterRequest(Id, RosterName, RequiredFromDate, RequiredToDate, RequiredEmployee, RequiredBudget, IncludeHolidays, IncludeWeekends, TotalWorkingDays, TotalWorkingHours, StatusId, RosterShiftDetails, RosterDepartmentDetails, RosterAdhocRequirement, CreatedByUserId, CreatedDateTime, CompanyId, BranchId )
				SELECT @ReqId, RosterName, RequiredFromDate, RequiredToDate, RequiredEmployee, RequiredBudget, IncludeHolidays, IncludeWeekends, TotalWorkingDays, TotalWorkingHours, @StatusId, @RosterShift, @RosterDepartment, @RosterAdHoc, @OperationsPerformedBy,@CurrentDate, @CompanyId, BranchId FROM #BasicDetails B

				INSERT INTO RosterSolution(Id, RequestId, SolutionName, BudgetAllocated, CompanyId, CreatedByUserId, CreatedDateTime)
				SELECT SolutionId, @ReqId, SolutionName, Budget, @CompanyId, @OperationsPerformedBy, @CurrentDate FROM #Solutions

				INSERT INTO RosterSuggestedPlans( Id, RequestId, SolutionId, PlanDate,  CurrencyCode, DepartmentId, ShiftId, EmployeeId, FromTime, ToTime, TotalRate, CreatedByUserId, CreatedDateTime, CompanyId)
				select PlanId, @ReqId, SolutionId, PlanDate, C.Id, DepartmentId, ShiftId, EmployeeId, FromTime, ToTime, TotalRate, @OperationsPerformedBy, @CurrentDate, @CompanyId from #Plans P
				LEFT JOIN Currency C ON C.CurrencyCode = P.CurrencyCode AND CompanyId = @CompanyId

				SELECT Id FROM RosterRequest WHERE Id = @ReqId

			END
		END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		THROW
	END CATCH
END