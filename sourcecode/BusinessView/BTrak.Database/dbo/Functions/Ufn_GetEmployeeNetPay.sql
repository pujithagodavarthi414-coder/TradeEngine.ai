CREATE FUNCTION [dbo].[Ufn_GetEmployeeNetPay]
(
	@EmployeeId UNIQUEIDENTIFIER,
	@PayrollRunId UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@IsPrevious BIT
)
RETURNS FLOAT
AS
BEGIN

	DECLARE @NetPay FLOAT

	IF(@IsPrevious = 1)
	BEGIN

		SET @PayrollRunId = NULL

		SELECT TOP 1 @PayrollRunId = PR.Id 
		FROM PayrollRun PR 
		     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
		WHERE PRE.EmployeeId = @EmployeeId
		      AND PR.PayrollStartDate = DATEADD(MONTH,-1,@RunStartDate) AND PR.PayrollEndDate = DATEADD(MONTH,-1,@RunEndDate)
		ORDER BY PR.CreatedDateTime DESC

	END

	SELECT @NetPay = ISNULL((SELECT SUM(ActualComponentAmount) FROM PayrollRunEmployeeComponent P INNER JOIN PayrollComponent PC ON PC.Id = P.ComponentId WHERE PC.EmployerContributionPercentage IS NULL AND P.IsDeduction = 0 AND P.PayrollRunId = @PayrollRunId AND P.EmployeeId = @EmployeeId),0) + ISNULL((SELECT SUM(ActualComponentAmount) FROM PayrollRunEmployeeComponent WHERE IsDeduction = 1 AND PayrollRunId = @PayrollRunId AND EmployeeId = @EmployeeId),0)

	RETURN ROUND(@NetPay,0)

END
