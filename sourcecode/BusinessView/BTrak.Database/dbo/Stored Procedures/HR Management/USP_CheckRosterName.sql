CREATE PROCEDURE [dbo].[USP_CheckRosterName]
(
	@RequestId UNIQUEIDENTIFIER = NULL,
	@RosterName NVARCHAR(250) = NULL,
	@RostEmployeeId UNIQUEIDENTIFIER = NULL,
	@RostFromDate DATETIME = NULL,
	@RostToDate DATETIME = NULL,
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
       	   IF(@RosterName IS NOT NULL)
		   BEGIN
			   IF EXISTS(SELECT Id
				   FROM [dbo].[RosterRequest] AS RR 
				   WHERE RR.CompanyId = @CompanyId AND RR.RosterName = @RosterName AND RR.Id <> @RequestId)
					BEGIN
						RAISERROR(50001,16,1,'Roster')
					END
			END
			IF(@RostEmployeeId IS NOT NULL)
			BEGIN
				IF EXISTS(
					SELECT * FROM [dbo].[RosterRequest] AS RR 
					INNER JOIN RosterActualPlan RAP ON RAP.RequestId = RR.Id
					WHERE RR.CompanyId = @CompanyId 
						AND CONVERT(DATE, RAP.PlanDate) BETWEEN CONVERT(DATE, @RostFromDate) AND CONVERT(DATE, @RostToDate)
						AND RAP.PlannedEmployeeId = @RostEmployeeId
						AND RR.InActiveDateTime IS NULL AND StatusId IN (SELECT Id fROM RosterPlanStatus WHERE StatusName NOT IN ('Draft'))
						AND (@RequestId IS NULL OR RR.ID<>@RequestId)
				 )
				 BEGIN
					RAISERROR(50001,16,1,'RosterEmployee')
				 END

				 DECLARE @LeaveCount int

				 SELECT @LeaveCount = COUNT(LA.USERID) FROM LeaveApplication LA
				 INNER JOIN [User] U ON  LA.UserId = U.Id AND U.CompanyId = @CompanyId
				 INNER JOIN Employee E ON E.UserId = U.Id AND E.Id = @RostEmployeeId
				 INNER JOIN LeaveStatus S ON S.Id = LA.OverallLeaveStatusId AND S.LeaveStatusName='Approved' AND S.CompanyId = @CompanyId
				 WHERE CONVERT(DATE, @RostFromDate) BETWEEN CONVERT(DATE, LA.LeaveDateFrom) AND CONVERT(DATE, LA.LeaveDateTo)

				 IF(@LeaveCount > 0)
				 BEGIN
					RAISERROR(50027,16,1,'RosterEmployeeIsOnLeave')
				 END
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