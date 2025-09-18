CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterPlanByRequest]
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

			 DECLARE @FromDate DATETIME
			 DECLARE @ToDate DATETIME
			 DECLARE @IncludeHoliday  BIT
			 DECLARE @IncludeWeekend  BIT
			 DECLARE @maxworkHours INT
			 SELECT @FromDate = RequiredFromDate, @IncludeHoliday = IncludeHolidays, @ToDate = RequiredToDate, @IncludeWeekend = IncludeWeekends, @maxworkHours = TotalWorkingHours FROM RosterRequest WHERE Id = @RequestId

			 SELECT RAP.Id PlanId,
					RAP.PlanDate,
					RAP.DepartmentId,
					D.DepartmentName,
					RAP.ShiftId,
					ST.ShiftName,
					RAP.SolutionId,
					RAP.RequestId,
					RAP.PlannedEmployeeId,
					U.FirstName + COALESCE(' ' + U.SurName,'') PlannedEmployeeName,
					U.ProfileImage PlannedEmployeeProfileImage,
					RAP.PlannedRate,
					RAP.PlannedFromTime,
					RAP.PlannedToTime,					
					RAP.ActualEmployeeId ActualEmployeeId,
					U1.FirstName + COALESCE(' ' + U1.SurName,'') ActualEmployeeName,
					U1.ProfileImage ActualEmployeeProfileImage,
					COALESCE(RAP.ActualRate, 0) ActualRate,
					ActualFromTime,
					ActualToTime,
					RAP.[TimeStamp],
					C.CurrencyCode,
					CASE WHEN RAP.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			TotalCount = COUNT(1) OVER()
			 FROM RosterRequest RR
			 INNER JOIN RosterActualPlan RAP ON RR.ID = RAP.RequestId AND RR.CompanyId = RAP.CompanyId AND RAP.InActiveDateTime IS NULL
			 LEFT JOIN Department D ON D.Id = RAP.DepartmentId
			 LEFT JOIN ShiftTiming ST ON ST.Id = RAP.ShiftId
			 LEFT JOIN Employee E ON E.Id = RAP.PlannedEmployeeId
			 LEFT JOIN [User] U ON U.ID = E.UserId
			 LEFT JOIN Employee E1 ON E1.Id = RAP.ActualEmployeeId
			 LEFT JOIN [User] U1 ON U1.ID = E1.UserId
			 LEFT JOIN Currency C ON C.Id = RAP.CurrencyCode
			 WHERE RR.ID = @RequestId AND RR.CompanyId = @CompanyId and PlannedFromTime IS NOT NULL
			 ORDER BY PlanDate
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