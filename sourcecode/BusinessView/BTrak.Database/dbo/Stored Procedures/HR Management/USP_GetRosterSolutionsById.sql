CREATE PROCEDURE [dbo].[USP_GetRosterSolutionsById]
(
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
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			 
			SELECT RosterName [RostName],
				   RequiredFromDate [RostStartDate],
				   RequiredToDate [RostEndDate],
				   RequiredEmployee [RostEmployeeRequired],
				   RequiredBudget [RostBudget],
				   IncludeHolidays,
				   IncludeWeekends,
				   TotalWorkingDays [RostMaxWorkDays],
				   TotalWorkingHours [RostMaxWorkHours],
				   RosterShiftDetails,
				   RosterDepartmentDetails,
				   RosterAdhocRequirement
				   FROM RosterRequest WHERE ID=@RequestId

			select Id [SolutionId],
				   SolutionName,
				   BudgetAllocated [Budget]
				   FROM RosterSolution WHERE RequestId = @RequestId

			SELECT R.Id [PlanId],
				   SolutionId,
				   PlanDate,
				   DepartmentId,
				   ShiftId,
				   EmployeeId, 
				   TotalRate, 
				   C.CurrencyCode,
				   FromTime,
				   ToTime 
				   FROM RosterSuggestedPlans R
				   INNER JOIN Currency C ON C.ID = R.CurrencyCode
					WHERE RequestId = @RequestId
		

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
