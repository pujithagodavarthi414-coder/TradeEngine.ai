CREATE PROCEDURE [dbo].[USP_GetSalaryCertificateOfAnEmployee]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
    DECLARE @PayrollRunId UNIQUEIDENTIFIER = (SELECT TOP (1) PRE.PayRollRunId FROM PayRollRunEmployee PRE
                                              JOIN PayRollRun PRR ON PRR.Id = PRE.PayRollRunId
										      JOIN PayRollRunStatus PRRS ON PRRS.PayRollRunId = PRE.PayRollRunId
										      JOIN PayRollStatus PRS ON PRS.Id = PRRS.PayRollStatusId
										      WHERE PRE.EmployeeId = @EmployeeId AND PRS.PayRollStatusName = 'Paid'
										            AND PRS.CompanyId = @CompanyId AND PRR.InactiveDateTime IS NULL
											  ORDER BY PRR.CreatedDateTime DESC)
    SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
		   J.JoinedDate DateOfJoining,
		   C.CompanyName,
		   JSON_VALUE(BInner.HeadOfficeAddress,'$.Street') + ', ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.City') + ', ' +
		   JSON_VALUE(BInner.HeadOfficeAddress,'$.State') + ' - ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.PostalCode') HeadOfficeAddress,
		   C.SiteAddress CompanySiteAddress,
		   C.WorkEmail CompanyEmail,
		   CU.Symbol CurrencySymbol,
		   (SELECT TOP(1) Amount FROM employeesalary WHERE EmployeeId = E.Id order by CreatedDateTime) AS StartingSalary,
		   (SELECT TOP(1) PaidAmount from PayrollRunEmployee PRE1 where PRE1.EmployeeId = E.Id AND PRE1.PayrollRunId = @PayrollRunId) AS NetPayAmount,
		   (SELECT TOP(1) CreatedDateTime from PayrollRunEmployee PRE1 where PRE1.EmployeeId = E.Id AND PRE1.PayrollRunId = @PayrollRunId) AS SalaryBreakDownDate,
		   (SELECT PREC.ComponentName,PREC.ComponentId,
           CASE WHEN PREC.ComponentAmount < 0 THEN -(PREC.ComponentAmount) ELSE PREC.ComponentAmount END [Full],
           PREC.IsDeduction
           FROM PayrollRunEmployeeComponent PREC
           INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PREC.PayrollRunId AND PREC.EmployeeId = PRE.EmployeeId
           LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PREC.ComponentId AND PTC.InActiveDateTime IS NULL
		   WHERE PREC.EmployeeId = @EmployeeId AND PRE.PayrollRunId = @PayrollRunId
                 AND PREC.ComponentName NOT IN (SELECT DISTINCT PREC.ComponentName FROM PayrollRunEmployeeComponent PREC
                                      INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId WHERE PC.EmployerContributionPercentage IS NOT NULL
									  AND PREC.IsDeduction = 0)
                 ORDER BY ISNULL(PTC.[Order],50),PREC.IsDeduction,PREC.ComponentName
                 FOR JSON AUTO) AS SalaryBreakDownRecords,
          (SELECT Amount RevisedSalary,ActiveFrom AS SalaryHikeDate FROM employeesalary
           WHERE EmployeeId = @EmployeeId AND Id
		   NOT IN (SELECT TOP(1) Id FROM employeesalary WHERE EmployeeId = @EmployeeId order by CreatedDateTime)
           FOR JSON AUTO) AS SalaryHikes
	FROM Employee E
		 INNER JOIN [User] U ON U.Id = E.UserId
		 INNER JOIN Company C ON C.Id = U.CompanyId
		 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = @EmployeeId AND PRE.PayrollRunId = @PayrollRunId
         INNER JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
		 INNER JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
		 INNER JOIN (SELECT TOP 1 CompanyId, [Address] HeadOfficeAddress FROM Branch WHERE IsHeadOffice = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId
		             ORDER BY CreatedDateTime DESC) BInner
		             ON BInner.CompanyId = C.Id
		 LEFT JOIN Job J ON J.EmployeeId = E.Id
		 LEFT JOIN Designation D ON D.Id = J.DesignationId
		 LEFT JOIN Department DR ON DR.Id = J.DepartmentId
		 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
		 LEFT JOIN Branch B ON B.Id = EB.BranchId
	WHERE E.Id = @EmployeeId AND U.CompanyId = @CompanyId
END
GO