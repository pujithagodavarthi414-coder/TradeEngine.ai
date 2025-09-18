CREATE PROCEDURE [dbo].[USP_GetPayrollRunemployeeList]
(
	@PayrollrunId uniqueidentifier,
	@OperationsPerformedBy uniqueidentifier
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	
	DECLARE @currentDate DATETIME = GETDATE()
	SELECT @currentDate = CONVERT(DATE, PayrollStartDate) FROM PayrollRun WHERE  Id = @PayrollrunId AND CompanyId = @CompanyId
	
	CREATE TABLE #RateTag
	(
		Id INT IDENTITY(1,1),
		RateTagEmployeeId UNIQUEIDENTIFIER,
		CurrencyCode NVARCHAR(100)
	)

	INSERT INTO #RateTag(RateTagEmployeeId,CurrencyCode)
	SELECT EB.RateTagEmployeeId, SC.CurrencyCode
					FROM EmployeeRateTag EB
					     INNER JOIN Sys_Currency SC ON SC.Id = EB.RateTagCurrencyId
						 INNER JOIN PayrollRun PR ON PR.Id = @PayrollrunId
						 INNER JOIN (SELECT EB.RateTagEmployeeId,MAX(ISNULL(EB.UpdatedDateTime,EB.CreatedDateTime)) RateTagStartDate
													FROM EmployeeRateTag EB
													     INNER JOIN PayrollRun PR ON PR.Id = @PayrollrunId
													WHERE ( (EB.RateTagEndDate IS NOT NULL AND PayrollStartDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate AND PayrollEndDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate)
															      OR (EB.RateTagEndDate IS NULL AND PayrollEndDate >= EB.RateTagStartDate)
																  OR (EB.RateTagEndDate IS NOT NULL AND PayrollStartDate <= EB.RateTagEndDate AND PayrollStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.RateTagStartDate), 0))
															   ) 
														AND EB.InActiveDateTime IS NULL
										GROUP BY EB.RateTagEmployeeId) ERTInner ON ERTInner.RateTagEmployeeId = EB.RateTagEmployeeId AND ERTInner.RateTagStartDate = ISNULL(EB.UpdatedDateTime,EB.CreatedDateTime)
					WHERE ( (EB.RateTagEndDate IS NOT NULL AND PayrollStartDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate AND PayrollEndDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate)
							      OR (EB.RateTagEndDate IS NULL AND PayrollEndDate >= EB.RateTagStartDate)
								  OR (EB.RateTagEndDate IS NOT NULL AND PayrollStartDate <= EB.RateTagEndDate AND PayrollStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.RateTagStartDate), 0))
							   )
						 AND EB.InActiveDateTime IS NULL

	SELECT dbo.Ufn_GetCurrency(ISNULL(CU.CurrencyCode,ERT.CurrencyCode),(SELECT [dbo].[Ufn_GetEmployeeNetPay](EmployeeId,PayrollRunId,PayrollStartDate,PayrollEndDate,1)),1) ModifiedPreviousMonthPaidAmount,
	       (SELECT [dbo].[Ufn_GetEmployeeNetPay](EmployeeId,PayrollRunId,PayrollStartDate,PayrollEndDate,1)) AS PreviousMonthPaidAmount,
		   CASE WHEN (SELECT [dbo].[Ufn_GetEmployeeNetPay](EmployeeId,PayrollRunId,PayrollStartDate,PayrollEndDate,1)) != (SELECT [dbo].[Ufn_GetEmployeeNetPay](EmployeeId,PayrollRunId,PayrollStartDate,PayrollEndDate,0)) THEN 1 ELSE 0 END AS IsPaidAmountDifferent,
	       PS.PayrollStatusName,   
	       JSON_VALUE(PRE.[Address],'$[0].Address1') + ', ' + JSON_VALUE(PRE.[Address],'$[0].Address2') + ', ' + JSON_VALUE(PRE.[Address],'$[0].StateName') + ', ' + JSON_VALUE(PRE.[Address],
	       '$[0].CountryName') + ' - ' + JSON_VALUE(PRE.[Address],'$[0].PostalCode') AS Address1,
	       PR.PayrollStartDate,
		   PR.PayrollEndDate,
	       PR.BankSubmittedFilePointer,
	       dbo.Ufn_GetCurrency(ISNULL(CU.CurrencyCode,ERT.CurrencyCode),(SELECT [dbo].[Ufn_GetEmployeeNetPay](EmployeeId,PayrollRunId,PayrollStartDate,PayrollEndDate,0)),1) ModifiedActualPaidAmount,
	       dbo.Ufn_GetCurrency(ISNULL(CU.CurrencyCode,ERT.CurrencyCode),pre.LoanAmountRemaining,1) ModifiedLoanAmountRemaining,
		   U.FirstName + ' '+ ISNULL(U.SurName,'') UserName,
		   U.ProfileImage,
		   U.Id UserId,
	       PRE. * 
	FROM PayrollRunEmployee PRE 
		 INNER JOIN PayrollRun as PR on PR.Id = PRE.PayrollrunId AND PR.Id = @PayrollrunId
		 INNER JOIN PayrollStatus as PS on PS.Id = pre.PayrollStatusId 
		 INNER JOIN Employee as E on E.Id = pre.EmployeeId
		 INNER JOIN [User] as U on U.Id = E.UserId
		 LEFT JOIN PayrollTemplate PT ON PT.Id = pre.PayrollTemplateId
		 LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
		 LEFT JOIN (SELECT ERT1.RateTagEmployeeId,ERT1.CurrencyCode 
		            FROM #RateTag ERT1
					     INNER JOIN (SELECT RateTagEmployeeId, MAX(Id) Id FROM #RateTag GROUP BY RateTagEmployeeId) ERTInner ON ERTInner.Id = ERT1.Id AND ERTInner.RateTagEmployeeId = ERT1.RateTagEmployeeId) ERT ON ERT.RateTagEmployeeId = PRE.EmployeeId
						
	WHERE PRE.IsInResignation = 0 AND PR.CompanyId = @CompanyId
	ORDER BY U.FirstName + ' '+ ISNULL(U.SurName,'') ASC

END