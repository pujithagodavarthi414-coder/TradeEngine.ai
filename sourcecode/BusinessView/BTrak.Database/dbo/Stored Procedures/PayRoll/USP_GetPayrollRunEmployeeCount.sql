CREATE PROCEDURE USP_GetPayrollRunEmployeeCount
(
	@PayrollRunId uniqueidentifier,
	@OperationsPerformedBy uniqueidentifier
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT (ProcessedEmployees/ProcessEmployees) * 100 FROM Temp_PayrollRun WHERE Id = @PayrollRunId

END