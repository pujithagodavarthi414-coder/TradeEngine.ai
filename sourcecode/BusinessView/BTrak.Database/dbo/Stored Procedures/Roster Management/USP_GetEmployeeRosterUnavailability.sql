CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterUnavailability]
(
	@FromDate DATETIME,
	@ToDate DATETIME,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeJson NVARCHAR(MAX)
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

			CREATE TABLE #EmployeeRequired 
			(RosterEmployeeId UNIQUEIDENTIFIER)

			INSERT INTO #EmployeeRequired
			SELECT value
			FROM OPENJSON(@EmployeeJson);

			SELECT DISTINCT E.Id EmployeeId, U.Id UserId, RAP.PlanDate FROM RosterActualPlan RAP
			INNER JOIN RosterPlanStatus RAS ON RAS.Id = RAP.PlanStatusId AND RAS.StatusName = 'Approved' 
			INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId
			INNER JOIN [User] U on U.Id = E.UserId
			INNER JOIN #EmployeeRequired EON ON EON.RosterEmployeeId = E.Id
			WHERE U.CompanyId=@CompanyId
				AND (RAP.PlanDate BETWEEN @FromDate AND @ToDate)
			
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