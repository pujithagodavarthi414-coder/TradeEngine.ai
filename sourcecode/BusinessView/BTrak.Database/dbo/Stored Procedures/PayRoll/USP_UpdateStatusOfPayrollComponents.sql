CREATE PROCEDURE [dbo].[USP_UpdateStatusOfPayrollComponents]
(
	@PayrollRunId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @RunStartDate DATE, @RunEndDate DATE

	SELECT @RunStartDate = PayrollStartDate,@RunEndDate = PayrollEndDate
	FROM PayrollRun
	WHERE Id = @PayrollRunId

	UPDATE EmployeeBonus SET IsPaid = 1
	FROM EmployeeBonus EB
	      INNER JOIN PayrollRunEmployee PRE ON EB.EmployeeId = PRE.EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsApproved = 1 AND IsArchived = 0
	WHERE PRE.PayrollRunId = @PayrollRunId
	      AND IsProcessed = 1

	UPDATE EmployeeLoan SET IsPaid = 1
	FROM EmployeeLoan EL 
		 INNER JOIN PayrollRunEmployee PRE ON EL.EmployeeId = PRE.EmployeeId AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL
	WHERE EL.Id IN (SELECT EmployeeLoanId FROM EmployeeLoanInstallment WHERE InstalmentDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0)
	      AND PRE.PayrollRunId = @PayrollRunId
		  AND IsProcessed = 1

END
GO
