CREATE PROCEDURE [dbo].[USP_GetFinalSettlement]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@UserId UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
		
		--IF(@SelectedEmployee = '00000000-0000-0000-0000-000000000000') SET @SelectedEmployee = NULL
		DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN
				
				IF(@UserId IS NULL) SET @UserId = @OperationsPerformedBy

				DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @UserId)
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

				SELECT E.EmployeeNumber
				       ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
					   ,J.JoinedDate
					   ,B.BranchName AS [Location]
					   ,ER.LastDate AS DateOfResignation
					   ,DATENAME(MONTH,PayrollEndDate) + ' ' + DATENAME(YEAR,PayrollEndDate) AS LastSalaryPaid
					   ,TT.* 
				       ,TotalEarnings - ABS(TotalDeductions) AS NetAmount
					   ,D.DesignationName
					   ,DT.DepartmentName
				FROM (
					SELECT * 
					       ,SUM(CASE WHEN IsDeduction = 1 THEN ComponentAmount ELSE 0 END) OVER() AS TotalDeductions
						   ,SUM(CASE WHEN IsDeduction = 0 THEN ComponentAmount ELSE 0 END) OVER() AS TotalEarnings
					FROM (
						SELECT PRE.EmployeeName
						       ,PREC.ComponentId
							   ,ISNULL(SUM(PREC.ComponentAmount),0) AS ComponentAmount
							   ,PREC.ComponentName
							   ,PREC.EmployeeId
							   ,E.UserId AS UserId 
							   ,PREC.IsDeduction
							   ,SUM(EffectiveWorkingDays) AS EffectiveWorkingDays
							   ,SUM(TotalWorkingDays) AS TotalWorkingDays
							   --,SUM(TotalDaysInPayroll) AS TotalDaysInPayroll
							   ,SUM(LossOfPay) AS LossOfPay
							   ,MAX(PR.PayrollEndDate) AS PayrollEndDate
						FROM PayrollRunEmployee PRE
						     INNER JOIN Employee E ON E.Id = PRE.EmployeeId
							 INNER JOIN [PayrollRunEmployeeComponent] PREC ON PREC.PayrollRunId = PRE.PayrollRunId
							 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
							 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							 INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							            AND PREC.EmployeeId = @EmployeeId
										AND PRE.EmployeeId = @EmployeeId
										AND PR.InactiveDateTime IS NULL
										AND PS.InActiveDateTime IS NULL
										AND PRS.InactiveDateTime IS NULL
						GROUP BY PRE.EmployeeName,PREC.ComponentId,PREC.ComponentName,PREC.EmployeeId,E.UserId,PREC.IsDeduction --,PREC.ComponentAmount
					) T
				) TT 
				INNER JOIN [User] U ON U.Id = TT.UserId
				LEFT JOIN Employee E ON E.UserId = U.Id
				LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				LEFT JOIN Branch B ON B.Id = EB.BranchId
				LEFT JOIN Job J ON J.EmployeeId = E.Id
				LEFT JOIN Designation D ON D.Id = J.DesignationId
				LEFT JOIN Department DT ON DT.Id = J.DepartmentId
				LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id
				
			END
			ELSE
				RAISERROR(@HavePermission,11,1);

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO