CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterFinalReport]
(
	@RequestId UNIQUEIDENTIFIER,	
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS 
BEGIN
	--DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	--IF (@HavePermission = '1')
	--BEGIN
		SELECT	RosterName,
			CONVERT(DATE, RequiredFromDate) RequiredFromDate,
			CONVERT(DATE, RequiredToDate) RequiredToDate,
			E.Id EmployeeId,
			U.FirstName + COALESCE( ' ' + U.Surname, '') EmployeeName,
			U.UserName,
			SUM(coalesce(ActualRate,0)) ActualRate,
			SUM(PlannedRate) PlannedRate,
			U.Id
		FROM RosterActualPlan RAP
		INNER JOIN RosterRequest RR ON RR.Id = RAP.RequestId
		INNER JOIN Employee E ON E.Id = RAP.ActualEmployeeId
		INNER JOIN [User] U ON E.UserId = U.Id
		INNER JOIN RosterPlanStatus RAS ON RAS.Id = rr.StatusId and StatusName = 'Approved'
		WHERE RequestId = @RequestId --AND  CONVERT(DATE, RequiredToDate) <= CONVERT(DATE, GETDATE()) 
		group by RosterName, RequiredFromDate, RequiredToDate, E.Id, U.FirstName,  U.Surname, U.UserName, U.Id
	--END
	--ELSE
	--BEGIN
	--	RAISERROR (@HavePermission,11, 1)
	--END
END