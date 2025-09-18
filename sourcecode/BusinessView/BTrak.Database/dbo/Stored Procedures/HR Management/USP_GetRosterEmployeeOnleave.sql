CREATE PROCEDURE [dbo].[USP_GetRosterEmployeeOnleave]
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

			CREATE TABLE #EmployeeOnLeave 
			(RateSheetEmployeeId UNIQUEIDENTIFIER)

			INSERT INTO #EmployeeOnLeave
			SELECT value
			FROM OPENJSON(@EmployeeJson);

			SELECT E.Id EmployeeId, U.Id UserId, LA.LeaveDateFrom, LA.LeaveDateTo FROM LeaveApplication LA
			INNER JOIN [User] U on U.Id = LA.UserId
			INNER JOIN LeaveStatus LS on LS.Id = LA.OverallLeaveStatusId and LS.LeaveStatusName='Approved' and U.CompanyId = ls.CompanyId
			INNER JOIN Employee E ON E.UserId = U.Id
			INNER JOIN #EmployeeOnLeave EON ON EON.RateSheetEmployeeId = E.Id
			WHERE U.CompanyId=@CompanyId
				AND (LeaveDateFrom BETWEEN @FromDate AND @ToDate OR LeaveDateTo BETWEEN @FromDate AND @ToDate OR
						@FromDate BETWEEN LeaveDateFrom AND LeaveDateTo OR @ToDate BETWEEN LeaveDateFrom AND LeaveDateTo )
			
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
