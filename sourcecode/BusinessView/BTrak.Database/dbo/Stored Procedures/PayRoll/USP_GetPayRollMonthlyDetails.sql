CREATE PROCEDURE [dbo].[USP_GetPayRollMonthlyDetails]
(
   @DateOfMonth DateTime, 
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT
    COUNT(1) Employees, 
    dbo.Ufn_GetCurrency(Max(CU.CurrencyCode),ISNULL(SUM(ActualPaidAmount),0),1) NetPay,
    --dbo.Ufn_GetCurrency(Max(CU.CurrencyCode),ISNULL(SUM(ActualEmployeeSalary),0),0) GrossPay,
	dbo.Ufn_GetCurrency(Max(CU.CurrencyCode),ISNULL(SUM(ActualEarning),0),1) GrossPay,
    dbo.Ufn_GetCurrency(Max(CU.CurrencyCode),ISNULL(SUM(ActualEarning),0),1) Earnings,
    dbo.Ufn_GetCurrency(Max(CU.CurrencyCode),ISNULL(ABS(SUM(ActualDeduction)),0),1) Deductions,
    MAX(TotalDaysInPayroll) WorkDays,
    ISNULL(SUM(CAST(IsHold AS INT)),0) + ISNULL(SUM(CAST(IsInResignation AS INT)),0) HoldEmployees,
    MAX(CU.CurrencyCode) CurrencyCode
    FROM PayrollRunEmployee PE
         INNER JOIN PayrollRun PR ON PR.Id = PE.PayrollRunId
	     INNER JOIN (SELECT PE.EmployeeId, FORMAT(PR.PayrollEndDate,'MMMM yyyy') PayrollMonth, MAX(PE.CreatedDateTime) CreatedDateTime
					 FROM PayrollRunEmployee PE
					      INNER JOIN PayrollRun PR ON PR.Id = PE.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
		                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE FORMAT(PR.PayrollEndDate,'MMMM yyyy') =  FORMAT(@DateOfMonth,'MMMM yyyy')
					       AND PR.CompanyId = @CompanyId AND PR.InactiveDateTime IS NULL
					 GROUP BY PE.EmployeeId, FORMAT(PR.PayrollEndDate,'MMMM yyyy')) PEInner ON PEInner.EmployeeId = PE.EmployeeId AND PEInner.CreatedDateTime = PE.CreatedDateTime 
				                             AND PEInner.PayrollMonth = FORMAT(PR.PayrollEndDate,'MMMM yyyy')
		INNER JOIN Employee E ON E.Id = PE.EmployeeId
		INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1
		LEFT JOIN PayrollTemplate PT ON PT.Id = PE.PayrollTemplateId
        LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
    WHERE FORMAT(PR.PayrollEndDate,'MMMM yyyy') =  FORMAT(@DateOfMonth,'MMMM yyyy') 
	      AND PR.CompanyId = @CompanyId
   
    END TRY  
    BEGIN CATCH 
                                                             
         THROW

    END CATCH
END
GO