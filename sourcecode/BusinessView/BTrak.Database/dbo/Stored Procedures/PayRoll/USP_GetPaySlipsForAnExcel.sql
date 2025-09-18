CREATE PROCEDURE [dbo].[USP_GetPaySlipsForAnExcel]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PayrollRunId NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT PRE.Id PayrollRunEmployeeId,
	       ECD.AccountNumber TraceAccountNumber,
	       GETDATE() DateOfTransaction,
		   'ADHOC' FileReference,
		   ECBNK.BankName,
	       CASE WHEN ECBNK.BankName = EBNK.BankName THEN 'WIB' ELSE 'NEFT' END TransactionType,
	       ECD.AccountNumber DebitAccountNumber,
		   BD.IFSCCode DebitAccountIfsc,
		   BD.AccountNumber BeneficiaryAccountNumber,
		   PRE.EmployeeName BeneficiaryName,
	       PRE.ActualPaidAmount Amount,
		   'Salary' RemarksForClient,
		   'Salary' RemarksForBeneficiary,
		   PR.RunDate,
		   PR.ChequeDate,
		   PR.AlphaCode,
		   PR.Cheque,
		   PR.ChequeNo,
		   CASE WHEN ECD.AccountNumber IS NOT NULL
					 AND ((BD.IFSCCode IS NOT NULL AND BD.IFSCCode <> '') OR ECBNK.BankName = EBNK.BankName)
					 AND BD.AccountNumber IS NOT NULL
					 AND PRE.EmployeeName IS NOT NULL
					 AND PRE.ActualPaidAmount IS NOT NULL
					 AND PRE.IsInResignation = 0
					 AND (PRE.IsHold IS NULL OR PRE.IsHold = 0) THEN 1 ELSE 0 END  IsProcessedToPay1,
			C.CurrencyName,
			C.CurrencyCode,
			C.Symbol,
			 CASE WHEN (PRE.IsHold IS NULL OR PRE.IsHold = 0) THEN 1 ELSE 0 END  IsProcessedToPay,
			PRE.Id AS PayrollRunEmployeeId
	FROM PayrollRunEmployee PRE
	     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
		 LEFT JOIN BankDetail BD ON BD.EmployeeId = PRE.EmployeeId AND BD.InActiveDateTime IS NULL
		           AND ( (BD.EffectiveTo IS NOT NULL AND PR.PayrollStartDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo AND PR.PayrollEndDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo)
	  		            OR (BD.EffectiveTo IS NULL AND PR.PayrollEndDate >= BD.EffectiveFrom)
						OR (BD.EffectiveTo IS NOT NULL AND PR.PayrollStartDate <= BD.EffectiveTo AND PR.PayrollStartDate  >= DATEADD(MONTH, DATEDIFF(MONTH, 0, BD.EffectiveFrom), 0))
	  			     )
	     LEFT JOIN Bank EBNK ON EBNK.Id = BD.BankId
		 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
		 INNER JOIN [User] U ON U.Id = E.UserId
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = PRE.EmployeeId
		            AND ( (EB.ActiveTo IS NOT NULL AND PR.PayrollStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND PR.PayrollEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
	  		            OR (EB.ActiveTo IS NULL AND PR.PayrollEndDate >= EB.ActiveFrom)
						OR (EB.ActiveTo IS NOT NULL AND PR.PayrollStartDate <= EB.ActiveTo AND PR.PayrollStartDate  >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
	  			     )
		 LEFT JOIN EmployeeCreditorDetails ECD ON ECD.BranchId = EB.BranchId AND ECD.InactiveDateTime IS NULL
		 LEFT JOIN Bank ECBNK ON ECBNK.Id = ECD.BankId
		 INNER JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
		 INNER JOIN SYS_Currency C on C.Id = PT.CurrencyId
	WHERE PRE.PayrollRunId IN (SELECT Id FROM UfnSplit(@PayrollRunId)) 
	ORDER BY BeneficiaryName

END
GO