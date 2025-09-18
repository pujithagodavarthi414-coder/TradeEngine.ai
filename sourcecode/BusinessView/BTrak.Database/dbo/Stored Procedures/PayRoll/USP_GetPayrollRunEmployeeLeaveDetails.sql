CREATE PROCEDURE [dbo].[USP_GetPayrollRunEmployeeLeaveDetails]
(
	@PayrollRunId UNIQUEIDENTIFIER,
	@OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN

    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  
    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT PRE.EmployeeId, 
	       U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
		   U.ProfileImage,
		   U.Id UserId,
	       E.EmployeeNumber, 
		   dbo.Ufn_GetCurrency(CU.CurrencyCode,PRE.ActualPaidAmount,1) NetPay, 
		   PRE.ActualPaidAmount,
		   PRE.TotalWorkingDays,
	       PRE.EffectiveWorkingDays, 
		   ISNULL(PRE.LossOfPay,0) LossOfPay, 
		   ISNULL(PRE.EncashedLeaves,0) EncashedLeaves, 
		   PRE.IsManualLeaveManagement,
		   ISNULL(TPRE.LossOfPay,0) OriginalLossOfPay, 
		   ISNULL(TPRE.EncashedLeaves,0) OriginalEncashedLeaves
	FROM PayrollRunEmployee PRE 
	     INNER JOIN Employee E ON E.Id = PRE.EmployeeId
		 INNER JOIN [User] U ON U.Id = E.UserId
		 INNER JOIN Temp_PayrollRunEmployee TPRE ON TPRE.PayrollRunId = PRE.PayrollRunId AND TPRE.EmployeeId = PRE.EmployeeId
		 LEFT JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
         LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
	WHERE PRE.PayrollRunId = @PayrollRunId AND U.CompanyId = @CompanyId

END
