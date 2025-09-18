CREATE PROCEDURE [dbo].[USP_GetPaySlipOfAnEmployee]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER,
	@PayrollRunId NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)),
	        @PayrollRunMonth INT, @Year INT, @RunStartDate DATE, @RunEndDate DATE, @EmployeeBranchId UNIQUEIDENTIFIER, @ComponentName NVARCHAR(500),
	        @FinancialYearTypeId UNIQUEIDENTIFIER, @FinancialYearFromMonth INT, @FinancialYearToMonth INT, 
	        @FinancialFromYear INT, @FinancialToYear INT, @FinancialYearFromDate DATE, @FinancialYearToDate DATE, @Counter INT = 1, @Count INT,
			@CurrencyCode NVARCHAR(100), @EmployeeCountryId UNIQUEIDENTIFIER

	SELECT @RunStartDate = PayrollStartDate, @RunEndDate = PayrollEndDate FROM PayrollRun WHERE Id  = @PayrollRunId

	DECLARE @IncludeYtd BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IncludeYTD%')

	DECLARE @MainLogo NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MainLogo')

	DECLARE @PaySlipLogo NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'PayslipLogo')

	IF(@MainLogo = NULL)
	BEGIN

	SET @MainLogo = 'http://todaywalkins.com/Comp_images/Snovasys.png';

	END	

	IF(@PaySlipLogo = NULL)
	BEGIN

	SET @PaySlipLogo = 'http://todaywalkins.com/Comp_images/Snovasys.png';

	END

	SELECT @Year = DATEPART(YEAR,@RunEndDate), @PayrollRunMonth = DATEPART(MONTH,@RunEndDate)

	SELECT @EmployeeBranchId = BranchId
	FROM EmployeeBranch EB
	WHERE EB.EmployeeId = @EmployeeId
		  AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			      OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
				  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
			   ) 

	SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

	SELECT @FinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'

	SELECT @FinancialYearFromMonth = FromMonth, @FinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
	WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @FinancialYearTypeId
	     -- AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			   --   OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  --OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
			   --)


	SELECT @FinancialYearFromMonth = ISNULL(@FinancialYearFromMonth,4), @FinancialYearToMonth = ISNULL(@FinancialYearToMonth,3)
	SELECT @FinancialFromYear = CASE WHEN @PayrollRunMonth - @FinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
	SELECT @FinancialToYear = CASE WHEN @PayrollRunMonth - @FinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

	SELECT @FinancialYearFromDate = DATEFROMPARTS(@FinancialFromYear,@FinancialYearFromMonth,1), 
	       @FinancialYearToDate = DATEFROMPARTS(@FinancialToYear,@FinancialYearToMonth,31)

	--SELECT @FinancialYearFromDate = CASE WHEN @FinancialYearFromDate IS NULL THEN DATEFROMPARTS(@Year,01,01) ELSE @FinancialYearFromDate END,
	--       @FinancialYearToDate = CASE WHEN @FinancialYearToDate IS NULL THEN DATEFROMPARTS(@Year,12,31) ELSE @FinancialYearToDate END
	
	--DROP TABLE IF EXISTS #PayslipDetails1
	--DROP TABLE IF EXISTS #PayslipDetails2
	--DROP TABLE IF EXISTS #PayslipDetails3
	--DROP TABLE IF EXISTS #PayslipDetails

	SELECT ROW_NUMBER() OVER(ORDER BY PREC.ComponentId) IId,
	       PRE.Id PayrollRunEmployeeId,
		   PRE.EmployeeId,
	       PRE.EmployeeName,
	       E.EmployeeNumber,
		   J.JoinedDate DateOfJoining,
		   D.DesignationName Designation,
		   DR.DepartmentName Department,
		   B.BranchName Location,
	       PRE.TotalWorkingDays DaysInMonth,
		   PRE.EffectiveWorkingDays EffectiveWorkingDays,
		   BNK.BankName,
		   BD.AccountNumber BankAccountNumber,
		   EAD.PFNumber PfNumber,
		   EAD.UANNumber Uan,
		   EAD.ESINumber EsiNumber,
		   EAD.PANNumber PanNumber,
		   PRE.LossOfPay Lop,
		   PREC.Id PayRollRunEmployeeComponentId,
		   PREC.PayRollRunId,
		   PREC.ComponentId,
	       PREC.ComponentName,
		   CASE WHEN ISNULL(PREC.IsDeduction,0) = 1 THEN -1 * PREC.ActualComponentAmount ELSE PREC.ActualComponentAmount END ActualComponentAmount,
		   CASE WHEN ISNULL(PREC.IsDeduction,0) = 1 THEN -1 * PREC.OriginalActualComponentAmount ELSE PREC.OriginalActualComponentAmount END OriginalActualComponentAmount,
		   CAST('' AS NVARCHAR(100)) ModifiedOriginalActualComponentAmount,		   
		   PREC.[TimeStamp],
		   PREC.Comments,
		   CAST(NULL AS NVARCHAR(MAX)) YTDComments,
		   0 IsNotEditable,
		   CASE WHEN PREC.ActualComponentAmount = PREC.OriginalActualComponentAmount THEN 0 ELSE 1 END IsComponentUpdated,
		   CAST(0.0 AS FLOAT) ComponentAmount,
		   0 IsYTDComponentUpdated,
		   CAST(NULL AS FLOAT) OldYTDComponentAmount,
		   CAST('' AS NVARCHAR(100)) OldYTDComponentAmountFormat,
	       CAST('' AS NVARCHAR(100)) Actual,
		   CAST('' AS NVARCHAR(100)) [Full],
		   ISNULL(PREC.IsDeduction,0) IsDeduction,
		   CAST('' AS NVARCHAR(100)) ActualNetPayAmount,
		   CAST('' AS NVARCHAR(100)) NetPayAmount,
		   CAST('' AS NVARCHAR(100)) TotalDeductionsToDate,
		   CAST('' AS NVARCHAR(100)) ActualDeductionsToDate,
		   CAST('' AS NVARCHAR(100)) TotalEarningsToDate,
		   CAST('' AS NVARCHAR(100)) ActualEarningsToDate,
		   C.CompanyName,
		   JSON_VALUE(BInner.HeadOfficeAddress,'$.Street') + ', ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.City') + ', ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.State') + ' - ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.PostalCode') HeadOfficeAddress,
		   BInner1.CompanyBranches,
		   C.SiteAddress CompanySiteAddress,
		   C.WorkEmail CompanyEmail,
		   PRS.PayrollStatusId,
		   DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) PayrollMonth,
		   CU.CurrencyName,
		   CU.CurrencyCode,
		   CU.Symbol,
		   PR.PayrollStartDate,
		   PR.PayrollEndDate,
		   CAST('' AS NVARCHAR(500)) ActualNetPayAmountInWords,
		   PTC.[Order],
		   @MainLogo AS CompanyLogo,
		   @PaySlipLogo AS PayslipLogo,
		   ISNULL(PTC.[Order],50) NewOrder,
		   @IncludeYtd AS IncludeYtd
	INTO #PayslipDetails1
	FROM PayrollRunEmployee PRE
	     INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PRE.PayrollRunId
		 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
		 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
		 INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId
		 LEFT JOIN Job J ON J.EmployeeId = PRE.EmployeeId
		 LEFT JOIN Designation D ON D.Id = J.DesignationId
		 LEFT JOIN Department DR ON DR.Id = J.DepartmentId
		 LEFT JOIN Branch B ON B.Id = J.BranchId
		 LEFT JOIN BankDetail BD ON BD.EmployeeId = PRE.EmployeeId AND BD.InActiveDateTime IS NULL
		           AND ( (BD.EffectiveTo IS NOT NULL AND PR.PayrollStartDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo AND PR.PayrollEndDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo)
	  		            OR (BD.EffectiveTo IS NULL AND PR.PayrollEndDate >= BD.EffectiveFrom)
						OR (BD.EffectiveTo IS NOT NULL AND PR.PayrollStartDate <= BD.EffectiveTo AND PR.PayrollStartDate  >= DATEADD(MONTH, DATEDIFF(MONTH, 0, BD.EffectiveFrom), 0))
	  			     )
         LEFT JOIN Bank BNK ON BNK.Id = BD.BankId
		 INNER JOIN [User] U ON U.Id = E.UserId
		 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PRE.PayrollRunId
		 INNER JOIN (SELECT PayrollRunId, MAX(CreatedDateTime) CreatedDateTime FROM PayrollRunStatus GROUP BY PayrollRunId) PRSInner ON PRSInner.PayrollRunId = PRS.PayrollRunId AND PRSInner.CreatedDateTime = PRS.CreatedDateTime
		 INNER JOIN Company C ON C.Id = U.CompanyId
		 LEFT JOIN (SELECT TOP 1 CompanyId, [Address] HeadOfficeAddress FROM Branch WHERE IsHeadOffice = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId ORDER BY CreatedDateTime DESC) BInner 
		             ON BInner.CompanyId = C.Id
		 LEFT JOIN (SELECT TOP 1 STUFF((SELECT ', '+ BranchName FROM Branch WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId AND (IsHeadOffice <> 1 OR IsHeadOffice IS NULL) FOR XML PATH('')), 1, 1, '') CompanyBranches FROM Branch) BInner1 ON 1 = 1
		 LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = PRE.EmployeeId AND EAD.InActiveDateTime IS NULL
		 LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PREC.ComponentId AND PTC.InActiveDateTime IS NULL
		 LEFT JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
		 LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
	WHERE PRE.EmployeeId = @EmployeeId
	      AND PRE.PayrollRunId IN (SELECT Id FROM UfnSplit(@PayrollRunId)) 
		  AND PRE.IsInResignation = 0
		  AND PREC.ComponentName NOT IN (SELECT DISTINCT PREC.ComponentName FROM PayrollRunEmployeeComponent PREC INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId WHERE PC.EmployerContributionPercentage IS NOT NULL AND ISNULL(PREC.IsDeduction,0) = 0)

	SELECT DISTINCT 1 IId,
	                P.PayrollRunEmployeeId,
					P.EmployeeId,
					P.EmployeeName,
					P.EmployeeNumber,
					P.DateOfJoining,
					P.Designation,
					P.Department,
					P.Location,
					P.DaysInMonth,
					P.EffectiveWorkingDays,
					P.BankName,
					P.BankAccountNumber,
					P.PfNumber,
					P.Uan,
					P.EsiNumber,
					P.PanNumber,
					P.Lop,
					'00000000-0000-0000-0000-000000000000' PayRollRunEmployeeComponentId,
					P.PayRollRunId,
					PEC.ComponentId, 
					PEC.ComponentName,
					0 ActualComponentAmount,
					0 OriginalActualComponentAmount,
					'0' ModifiedOriginalActualComponentAmount,
					P.[TimeStamp],
					P.Comments,
					P.YTDComments,
					1 IsNotEditable,
					0 IsComponentUpdated,
					0 ComponentAmount,
					0 IsYTDComponentUpdated,
		            CAST(NULL AS FLOAT) OldYTDComponentAmount,
		            CAST('' AS NVARCHAR(100)) OldYTDComponentAmountFormat,
					'0' Actual,
					P.[Full],
					ISNULL(PEC.IsDeduction,0) IsDeduction,
					P.ActualNetPayAmount,
					P.NetPayAmount,
					P.TotalDeductionsToDate,
					P.ActualDeductionsToDate,
					P.TotalEarningsToDate,
					P.ActualEarningsToDate,
					P.CompanyName,
					P.HeadOfficeAddress,
					P.CompanyBranches,
					P.CompanySiteAddress,
					P.CompanyEmail,
					P.PayrollStatusId,
					P.PayrollMonth,
					P.CurrencyName,
					P.CurrencyCode,
					P.Symbol,
					P.PayrollStartDate,
					P.PayrollEndDate,
					P.ActualNetPayAmountInWords,
					PTC.[Order],
					@MainLogo CompanyLogo,
					@PaySlipLogo AS PayslipLogo,
					ISNULL(PTC.[Order],50) NewOrder,
					@IncludeYtd AS IncludeYtd
	INTO #PayslipDetails2
	FROM PayrollRunEmployeeComponent PEC 
	     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
	     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN (SELECT PEC.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PEC.CreatedDateTime) CreatedDateTime
					 FROM PayrollRunEmployee PEC 
					      INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE PEC.EmployeeId = @EmployeeId AND PEC.IsInResignation = 0 AND PR.InactiveDateTime IS NULL
							AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
							AND PR.PayrollEndDate <= @RunEndDate
							AND (PEC.IsHold IS NULL OR PEC.IsHold = 0)
					 GROUP BY PEC.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PECInner ON PECInner.EmployeeId = PRE.EmployeeId AND PECInner.CreatedDateTime = PRE.CreatedDateTime 
					           AND PECInner.PayrollStartDate = PR.PayrollStartDate AND PECInner.PayrollEndDate = PR.PayrollEndDate
		 INNER JOIN #PayslipDetails1 P ON 1 = 1 AND P.IId = 1
		 LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PEC.ComponentId AND PTC.InActiveDateTime IS NULL
	WHERE PEC.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0
	      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
		  AND PR.PayrollEndDate <= @RunEndDate
		  AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
		  AND PEC.ComponentName NOT IN (SELECT DISTINCT PREC.ComponentName FROM PayrollRunEmployeeComponent PREC INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId WHERE PC.EmployerContributionPercentage IS NOT NULL AND ISNULL(PREC.IsDeduction,0) = 0)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails1)

	SELECT DISTINCT 1 IId,
	                P.PayrollRunEmployeeId,
					P.EmployeeId,
					P.EmployeeName,
					P.EmployeeNumber,
					P.DateOfJoining,
					P.Designation,
					P.Department,
					P.Location,
					P.DaysInMonth,
					P.EffectiveWorkingDays,
					P.BankName,
					P.BankAccountNumber,
					P.PfNumber,
					P.Uan,
					P.EsiNumber,
					P.PanNumber,
					P.Lop,
					'00000000-0000-0000-0000-000000000000' PayRollRunEmployeeComponentId,
					P.PayRollRunId,
					PEC.ComponentId, 
					PEC.ComponentName,
					0 ActualComponentAmount,
					0 OriginalActualComponentAmount,
					'0' ModifiedOriginalActualComponentAmount,
					P.[TimeStamp],
					CAST(NULL AS NVARCHAR(MAX)) Comments,
					P.YTDComments,
					1 IsNotEditable,
					0 IsComponentUpdated,
					0 ComponentAmount,
					0 IsYTDComponentUpdated,
		            CAST(NULL AS FLOAT) OldYTDComponentAmount,
		            CAST('' AS NVARCHAR(100)) OldYTDComponentAmountFormat,
					'0' Actual,
					P.[Full],
					ISNULL(PEC.IsDeduction,0) IsDeduction,
					P.ActualNetPayAmount,
					P.NetPayAmount,
					P.TotalDeductionsToDate,
					P.ActualDeductionsToDate,
					P.TotalEarningsToDate,
					P.ActualEarningsToDate,
					P.CompanyName,
					P.HeadOfficeAddress,
					P.CompanyBranches,
					P.CompanySiteAddress,
					P.CompanyEmail,
					P.PayrollStatusId,
					P.PayrollMonth,
					P.CurrencyName,
					P.CurrencyCode,
					P.Symbol,
					P.PayrollStartDate,
					P.PayrollEndDate,
					P.ActualNetPayAmountInWords,
					PTC.[Order],
					@MainLogo CompanyLogo,
					@PaySlipLogo AS PayslipLogo,
					ISNULL(PTC.[Order],50) NewOrder,
					@IncludeYtd AS IncludeYtd
	INTO #PayslipDetails3
	FROM PayrollRunEmployeeComponentYTD PEC 
	     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
	     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN #PayslipDetails1 P ON 1 = 1 AND P.IId = 1
		 LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PEC.ComponentId AND PTC.InActiveDateTime IS NULL
	WHERE PRE.EmployeeId = @EmployeeId
	      AND PRE.PayrollRunId IN (SELECT Id FROM UfnSplit(@PayrollRunId)) 
		  AND PRE.IsInResignation = 0
		  AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
		  AND PEC.ComponentName NOT IN (SELECT DISTINCT PREC.ComponentName FROM PayrollRunEmployeeComponent PREC INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId WHERE PC.EmployerContributionPercentage IS NOT NULL AND ISNULL(PREC.IsDeduction,0) = 0)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails1)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails2)

	SELECT DISTINCT 1 IId,
	                P.PayrollRunEmployeeId,
					P.EmployeeId,
					P.EmployeeName,
					P.EmployeeNumber,
					P.DateOfJoining,
					P.Designation,
					P.Department,
					P.Location,
					P.DaysInMonth,
					P.EffectiveWorkingDays,
					P.BankName,
					P.BankAccountNumber,
					P.PfNumber,
					P.Uan,
					P.EsiNumber,
					P.PanNumber,
					P.Lop,
					'00000000-0000-0000-0000-000000000000' PayRollRunEmployeeComponentId,
					P.PayRollRunId,
					PEC.ComponentId, 
					PEC.ComponentName,
					0 ActualComponentAmount,
					0 OriginalActualComponentAmount,
					'0' ModifiedOriginalActualComponentAmount,
					P.[TimeStamp],
					CAST(NULL AS NVARCHAR(MAX)) Comments,
					P.YTDComments,
					1 IsNotEditable,
					0 IsComponentUpdated,
					0 ComponentAmount,
					0 IsYTDComponentUpdated,
		            CAST(NULL AS FLOAT) OldYTDComponentAmount,
		            CAST('' AS NVARCHAR(100)) OldYTDComponentAmountFormat,
					'0' Actual,
					P.[Full],
					ISNULL(PEC.IsDeduction,0) IsDeduction,
					P.ActualNetPayAmount,
					P.NetPayAmount,
					P.TotalDeductionsToDate,
					P.ActualDeductionsToDate,
					P.TotalEarningsToDate,
					P.ActualEarningsToDate,
					P.CompanyName,
					P.HeadOfficeAddress,
					P.CompanyBranches,
					P.CompanySiteAddress,
					P.CompanyEmail,
					P.PayrollStatusId,
					P.PayrollMonth,
					P.CurrencyName,
					P.CurrencyCode,
					P.Symbol,
					P.PayrollStartDate,
					P.PayrollEndDate,
					P.ActualNetPayAmountInWords,
					PTC.[Order],
					@MainLogo CompanyLogo,
					@PaySlipLogo AS PayslipLogo,
					ISNULL(PTC.[Order],50) NewOrder,
					@IncludeYtd AS IncludeYtd
	INTO #PayslipDetails4
	FROM PayrollRunEmployeeComponentYTD PEC 
	     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
	     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN (SELECT PEC.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PEC.CreatedDateTime) CreatedDateTime
					 FROM PayrollRunEmployee PEC 
					      INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE PEC.EmployeeId = @EmployeeId AND PEC.IsInResignation = 0 AND PR.InactiveDateTime IS NULL
							AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
							AND PR.PayrollEndDate <= @RunEndDate
							AND (PEC.IsHold IS NULL OR PEC.IsHold = 0)
					 GROUP BY PEC.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PECInner ON PECInner.EmployeeId = PRE.EmployeeId AND PECInner.CreatedDateTime = PRE.CreatedDateTime 
					           AND PECInner.PayrollStartDate = PR.PayrollStartDate AND PECInner.PayrollEndDate = PR.PayrollEndDate
		 INNER JOIN #PayslipDetails1 P ON 1 = 1 AND P.IId = 1
		 LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PEC.ComponentId AND PTC.InActiveDateTime IS NULL
	WHERE PEC.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0
	      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
		  AND PR.PayrollEndDate <= @RunEndDate
		  AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
		  AND PEC.ComponentName NOT IN (SELECT DISTINCT PREC.ComponentName FROM PayrollRunEmployeeComponent PREC INNER JOIN PayrollComponent PC ON PC.Id = PREC.ComponentId WHERE PC.EmployerContributionPercentage IS NOT NULL AND ISNULL(PREC.IsDeduction,0) = 0)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails1)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails2)
		  AND PEC.ComponentName NOT IN (SELECT ComponentName FROM #PayslipDetails3)

	SELECT ROW_NUMBER() OVER(ORDER BY ComponentId) Id,
	       * 
	INTO #PayslipDetails
	FROM
	(
	    SELECT *
		FROM #PayslipDetails1
		UNION
		SELECT *
		FROM #PayslipDetails2
		UNION
		SELECT *
		FROM #PayslipDetails3
		UNION
		SELECT *
		FROM #PayslipDetails4
	) T
	
	SELECT @Count = COUNT(1) FROM #PayslipDetails

	DECLARE @ComponentAmount FLOAT, @PayrollRunEmployeeComponentYTDId UNIQUEIDENTIFIER

	--CREATE TABLE #PayrollComponents 
	--(
	--	EmployeeId UNIQUEIDENTIFIER,
	--	EmployeeName NVARCHAR(800),
	--	PayrollTemplateId UNIQUEIDENTIFIER,
	--	PayrollComponentId UNIQUEIDENTIFIER,
	--	PayrollComponentName NVARCHAR(800),
	--	IsDeduction BIT,
	--	EmployeeSalary FLOAT,
	--	ActualEmployeeSalary FLOAT,
	--	OneDaySalary FLOAT,
	--	IsRelatedToPT BIT,
	--	PayrollComponentAmount FLOAT,
	--	ActualPayrollComponentAmount FLOAT,
	--	Earning FLOAT, 
	--	Deduction FLOAT,
	--	ActualEarning FLOAT, 
	--	ActualDeduction FLOAT,
	--	TotalDaysInPayroll INT,
	--	TotalWorkingDays INT,
	--	LeavesTaken FLOAT,
	--	UnplannedHolidays FLOAT,
	--	SickDays FLOAT,
	--	WorkedDays FLOAT,
	--	PlannedHolidays FLOAT,
	--	LossOfPay FLOAT,
	--	IsInResignation BIT,
	--	TotalLeaves FLOAT,
	--	PaidLeaves FLOAT,
	--	UnPaidLeaves FLOAT,
	--	AllowedLeaves FLOAT,
	--	IsLossOfPayMonth BIT,
	--	EmployeeConfigAndSalaryId INT,
	--	LastPeriodPayrollComponentAmount FLOAT,
	--	LastPeriodSalary FLOAT,
	--	LastPeriodLossOfPay FLOAT,
	--	ActualLastPeriodPayrollComponentAmount FLOAT,
	--	ActualLastPeriodSalary FLOAT,
	--	EncashedLeaves FLOAT,
	--	TotalAmountPaid FLOAT,
	--	LoanAmountRemaining FLOAT
	--)

	WHILE(@Counter <= @Count)
	BEGIN

		SELECT @PayrollRunEmployeeComponentYTDId = NULL

		SELECT @ComponentName = ComponentName FROM #PayslipDetails WHERE Id = @Counter
		
		SELECT @PayrollRunEmployeeComponentYTDId = Id
		FROM PayrollRunEmployeeComponentYTD WHERE PayrollRunId = @PayrollRunId AND EmployeeId = @EmployeeId AND ComponentName = @ComponentName
		
		IF(@PayrollRunEmployeeComponentYTDId IS NOT NULL)
		BEGIN

			UPDATE #PayslipDetails SET ComponentAmount = PRECY.ComponentAmount, OldYTDComponentAmount = PRECY.OriginalComponentAmount,YTDComments = PRECY.Comments 
			FROM PayrollRunEmployeeComponentYTD PRECY WHERE PRECY.Id = @PayrollRunEmployeeComponentYTDId
			     AND #PayslipDetails.ComponentName = @ComponentName

		END
		ELSE
		BEGIN

			DECLARE @FromDate DATE = @FinancialYearFromDate

			WHILE(@FromDate <= @RunEndDate)
			BEGIN

				SELECT @ComponentAmount = NULL

				--TRUNCATE TABLE #PayrollComponents

				 SELECT @ComponentAmount = 
						(SELECT ABS(ComponentAmount)
						 FROM PayrollRunEmployeeComponentYTD PEC 
						      INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
							  INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
							  INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
										 FROM PayrollRunEmployee PRE 
										      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
											  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
								              INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
										 WHERE PRE.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0
											   AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
											   AND PR.PayrollStartDate = @FromDate AND PR.PayrollEndDate = EOMONTH(@FromDate)
											   AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
											   AND PR.InactiveDateTime IS NULL
										 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PECInner ON PECInner.EmployeeId = PEC.EmployeeId AND PECInner.CreatedDateTime = PRE.CreatedDateTime 
										           AND PECInner.PayrollStartDate = PR.PayrollStartDate AND PECInner.PayrollEndDate = PR.PayrollEndDate
						WHERE PEC.EmployeeId = @EmployeeId AND ComponentName = @ComponentName AND PRE.IsInResignation = 0
						      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
							  AND PR.PayrollStartDate = @FromDate AND PR.PayrollEndDate = EOMONTH(@FromDate)
							  AND (PRE.IsHold IS NULL OR PRE.IsHold = 0))

				IF(@ComponentAmount IS NULL)
				BEGIN

					SELECT @ComponentAmount = 
						(SELECT ABS(SUM(ActualComponentAmount))
						 FROM PayrollRunEmployeeComponent PEC 
						      INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
							  INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
							  INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
										 FROM PayrollRunEmployee PRE 
										      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
											  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
								              INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
										 WHERE PRE.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0
											   AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
											   AND PR.PayrollStartDate = @FromDate AND PR.PayrollEndDate = EOMONTH(@FromDate)
											   AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
											   AND PR.InactiveDateTime IS NULL
										 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PECInner ON PECInner.EmployeeId = PEC.EmployeeId AND PECInner.CreatedDateTime = PRE.CreatedDateTime 
										           AND PECInner.PayrollStartDate = PR.PayrollStartDate AND PECInner.PayrollEndDate = PR.PayrollEndDate
						WHERE PEC.EmployeeId = @EmployeeId AND ComponentName = @ComponentName AND PRE.IsInResignation = 0
						      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN @FinancialYearFromDate AND @FinancialYearToDate
							  AND PR.PayrollStartDate = @FromDate AND PR.PayrollEndDate = EOMONTH(@FromDate)
							  AND (PRE.IsHold IS NULL OR PRE.IsHold = 0))

					--IF(@ComponentAmount IS NULL)
					--BEGIN

					--	IF((SELECT COUNT(1) FROM #PayrollComponents) = 0)
					--	BEGIN

					--		DECLARE @ToDate DATE = EOMONTH(@FromDate)

					--		INSERT INTO #PayrollComponents
					--		EXEC [dbo].[USP_GetEmployeePayrollComponents] @OperationsPerformedBy,@FromDate,@ToDate,@EmployeeId

					--	END

					--	SELECT @ComponentAmount = ABS(ActualPayrollComponentAmount)
					--	FROM #PayrollComponents
					--	WHERE IsInResignation = 0 AND PayrollComponentName = @ComponentName

					--END

					UPDATE #PayslipDetails SET ComponentAmount = ISNULL(ComponentAmount,0) + ISNULL(@ComponentAmount,0) WHERE ComponentName = @ComponentName

				END
				ELSE UPDATE #PayslipDetails SET ComponentAmount = @ComponentAmount WHERE ComponentName = @ComponentName 

				SET @FromDate = DATEADD(MONTH,1,@FromDate)

			END

		END

		SET @Counter = @Counter + 1

	END
	
	SELECT TOP 1 @CurrencyCode = CurrencyCode FROM #PayslipDetails

	IF(@CurrencyCode IS NULL)
	BEGIN
		
		SELECT TOP 1 @CurrencyCode = SC.CurrencyCode
		FROM EmployeeRateTag EB
		     INNER JOIN Sys_Currency SC ON SC.Id = EB.RateTagCurrencyId
		WHERE EB.RateTagEmployeeId = @EmployeeId
			  AND ( (EB.RateTagEndDate IS NOT NULL AND @RunStartDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate AND @RunEndDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate)
				      OR (EB.RateTagEndDate IS NULL AND @RunEndDate >= EB.RateTagStartDate)
					  OR (EB.RateTagEndDate IS NOT NULL AND @RunStartDate <= EB.RateTagEndDate AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.RateTagStartDate), 0))
				   )
			 AND EB.InActiveDateTime IS NULL
			 AND EB.CreatedDateTime = (SELECT MAX(EB.CreatedDateTime)
										FROM EmployeeRateTag EB
										WHERE EB.RateTagEmployeeId = @EmployeeId
											  AND ( (EB.RateTagEndDate IS NOT NULL AND @RunStartDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate AND @RunEndDate BETWEEN EB.RateTagStartDate AND EB.RateTagEndDate)
												      OR (EB.RateTagEndDate IS NULL AND @RunEndDate >= EB.RateTagStartDate)
													  OR (EB.RateTagEndDate IS NOT NULL AND @RunStartDate <= EB.RateTagEndDate AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.RateTagStartDate), 0))
												   ) 
											AND EB.InActiveDateTime IS NULL)
											  

		UPDATE #PayslipDetails SET CurrencyCode = SC.CurrencyCode, CurrencyName = SC.CurrencyName, Symbol = SC.Symbol
		FROM Sys_Currency SC WHERE SC.CurrencyCode = @CurrencyCode
												   
	END

	UPDATE #PayslipDetails SET Actual = dbo.Ufn_GetCurrency(@CurrencyCode,ActualComponentAmount,0),
	                           ActualEarningsToDate = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 0),0),0),
	                           ActualDeductionsToDate = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 1),0),0),
							   ActualNetPayAmount = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails P INNER JOIN PayrollComponent PC ON PC.Id = P.ComponentId WHERE PC.EmployerContributionPercentage IS NULL AND P.IsDeduction = 0),0) - ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 1),0),0),
							   [Full] = dbo.Ufn_GetCurrency(@CurrencyCode,ComponentAmount,0),
							   TotalEarningsToDate = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 0),0),0),
	                           TotalDeductionsToDate = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 1),0),0),
							   NetPayAmount = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL((SELECT SUM(ComponentAmount) FROM #PayslipDetails P INNER JOIN PayrollComponent PC ON PC.Id = P.ComponentId WHERE PC.EmployerContributionPercentage IS NULL AND P.IsDeduction = 0),0) - ISNULL((SELECT SUM(ComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 1),0),0),
							   ActualNetPayAmountInWords = dbo.Ufn_GetCurrencyNaming(@CurrencyCode,ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails P INNER JOIN PayrollComponent PC ON PC.Id = P.ComponentId WHERE PC.EmployerContributionPercentage IS NULL AND P.IsDeduction = 0),0) - ISNULL((SELECT SUM(ActualComponentAmount) FROM #PayslipDetails WHERE IsDeduction = 1),0),1),
							   ModifiedOriginalActualComponentAmount = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL(OriginalActualComponentAmount,0),0),
							   IsYTDComponentUpdated = CASE WHEN ComponentAmount = ISNULL(OldYTDComponentAmount,ComponentAmount) THEN 0 ELSE 1 END,
							   OldYTDComponentAmountFormat = dbo.Ufn_GetCurrency(@CurrencyCode,ISNULL(OldYTDComponentAmount,0),0)

	SELECT * FROM #PayslipDetails ORDER BY NewOrder,IsDeduction,ComponentName

END
GO

--EXEC [USP_GetPaySlipOfAnEmployee] '3A265708-A7BF-4174-88BA-4DA3B59AC6BC','12d50670-6e94-4df3-bf0b-4e5c938ae3e6','d1842258-c920-4811-b1be-eada7af77ab6'