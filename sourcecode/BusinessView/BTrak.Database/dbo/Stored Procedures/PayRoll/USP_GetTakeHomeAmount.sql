CREATE PROCEDURE [dbo].[USP_GetTakeHomeAmount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeSalaryId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @RunStartDate DATE, @RunEndDate DATETIME, @EmployeeId UNIQUEIDENTIFIER, @PayrollTemplateId UNIQUEIDENTIFIER

	SELECT @RunStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, ISNULL(ES.ActiveTo,CAST(GETDATE() AS DATE))) , 0), 
	       @RunEndDate = CONVERT(DATETIME, CONVERT(CHAR(8), EOMONTH(ISNULL(ES.ActiveTo,GETDATE())), 112) + ' ' + CONVERT(CHAR(8), '23:59:59', 108)),
	       @EmployeeId = ES.EmployeeId, @PayrollTemplateId = EPC.PayrollTemplateId
	FROM EmployeeSalary ES INNER JOIN EmployeepayrollConfiguration EPC ON EPC.SalaryId = ES.Id
	WHERE ES.Id = @EmployeeSalaryId

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate), @TaxFinancialYearTypeId UNIQUEIDENTIFIER
	
	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'

	--Components calculation Start
	SELECT EmployeeId,
		   PayrollTemplateId,
		   PayrollComponentId,
		   PayrollComponentName,
		   IsDeduction,
		   EmployeeSalary,
		   OneDaySalary,
		   IsRelatedToPT,
		   ROUND(PayrollComponentAmount,0) PayrollComponentAmount,
	       ROUND((CASE WHEN IsDeduction = 0 THEN PayrollComponentAmount END),0) Earning, 
		   ROUND((CASE WHEN IsDeduction = 1 THEN PayrollComponentAmount END),0) Deduction
	INTO #Payroll
	FROM (

	SELECT *,
	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,@EmployeeId) ELSE Amount END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,@EmployeeId) ELSE Amount END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END PayrollComponentAmount
	FROM (

	SELECT *,
	       ROUND((EmployeePackage/12.0),0) EmployeeSalary
	FROM (

	SELECT TFinalInner.*,
		   (ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0 EmployeePackage,
		   ROUND(((((ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0)/12.0)/@TotalWorkingDays),2) OneDaySalary
	FROM (

	SELECT TInner.*,
	       DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
	       CASE WHEN Job.JoinedDate >= @RunStartDate THEN DATEDIFF(DAY,Job.JoinedDate,@RunEndDate) + 1 ELSE @TotalWorkingDays END TotalWorkingDays,
		   CASE WHEN ER.Id IS NULL THEN 0 ELSE 1 END IsInResignation,
		   ER1.LastDate ResignationLastDate,
		   Job.JoinedDate
	FROM (

	SELECT E.Id EmployeeId,
	       EPC.PayrollTemplateId,
		   PC.Id PayrollComponentId,
		   PC.ComponentName PayrollComponentName,
		   PC.IsDeduction,
		   CASE WHEN C.ComponentName = '##MonthlyCTC##' THEN 1 ELSE PTC.IsCtcDependent END IsCtcDependent, -- Depend on component name type
		   PTC.IsRelatedToPT,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN (SELECT Id FROM PayrollComponent WHERE ComponentName = 'Basic' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId) 
		        ELSE PTC.DependentPayrollComponentId END DependentPayrollComponentId, -- Depend on component name type
		   PTC.IsPercentage,
		   PTC.IsBands,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN 0 ELSE PTC.PercentageValue*0.01 END PercentageValue,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN PTC.PercentageValue*0.01 ELSE DPTC.PercentageValue*0.01 END DependentPercentageValue, -- Depend on component name type
		   PTC.Amount Amount,
		   DPTC.Amount DependentAmount,
		   EPC.SalaryId
	FROM Employee E 
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        )   
		 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND EPC.PayrollTemplateId = @PayrollTemplateId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL

	UNION

	SELECT E.Id EmployeeId,
	       EPC.PayrollTemplateId,
		   PC.Id PayrollComponentId,
		   'Employee ' + PC.ComponentName PayrollComponentName,
		   PC.IsDeduction,
		   CASE WHEN C.ComponentName = '##MonthlyCTC##' THEN 1 ELSE PTC.IsCtcDependent END IsCtcDependent, -- Depend on component name type
		   PTC.IsRelatedToPT,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN (SELECT Id FROM PayrollComponent WHERE ComponentName = 'Basic' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId) 
		        ELSE PTC.DependentPayrollComponentId END DependentPayrollComponentId, -- Depend on component name type
		   PTC.IsPercentage,
		   PTC.IsBands,
		   PC.EmployeeContributionPercentage*0.01 PercentageValue,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN PTC.PercentageValue*0.01 ELSE DPTC.PercentageValue*0.01 END DependentPercentageValue, -- Depend on component name type
		   PTC.Amount Amount,
		   DPTC.Amount DependentAmount,
		   EPC.SalaryId
	FROM Employee E 
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        ) 
		 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND EPC.PayrollTemplateId = @PayrollTemplateId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL

	UNION

	SELECT E.Id EmployeeId,
	       EPC.PayrollTemplateId,
		   PC.Id PayrollComponentId,
		   'Employeer ' + PC.ComponentName PayrollComponentName,
		   0 IsDeduction,
		   CASE WHEN C.ComponentName = '##MonthlyCTC##' THEN 1 ELSE PTC.IsCtcDependent END IsCtcDependent, -- Depend on component name type
		   PTC.IsRelatedToPT,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN (SELECT Id FROM PayrollComponent WHERE ComponentName = 'Basic' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId) 
		        ELSE PTC.DependentPayrollComponentId END DependentPayrollComponentId, -- Depend on component name type
		   PTC.IsPercentage,
		   PTC.IsBands,
		   PC.EmployerContributionPercentage*0.01 PercentageValue,
		   CASE WHEN C.ComponentName = '##MonthlyBasic##' THEN PTC.PercentageValue*0.01 ELSE DPTC.PercentageValue*0.01 END DependentPercentageValue, -- Depend on component name type
		   PTC.Amount Amount,
		   DPTC.Amount DependentAmount,
		   EPC.SalaryId
	FROM Employee E 
	     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        ) 
		 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND EPC.PayrollTemplateId = @PayrollTemplateId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL

	) TInner

	  LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = TInner.EmployeeId AND ER.InActiveDateTime IS NULL 
	            AND ((ER.LastDate IS NULL AND ER.ResignationDate <= @RunEndDate) OR (ER.ResignationDate <= @RunEndDate AND ER.LastDate >= @RunEndDate))
				AND ER.ResignationStastusId NOT IN (SELECT Id FROM ResignationStatus WHERE StatusName = 'Rejected' AND InactiveDateTime IS NULL)
	  LEFT JOIN EmployeeResignation ER1 ON ER1.EmployeeId = TInner.EmployeeId AND ER1.InActiveDateTime IS NULL 
	           AND DATENAME(MONTH,ER1.LastDate) + ' ' + DATENAME(YEAR,ER1.LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
			   AND ER1.ResignationStastusId NOT IN (SELECT Id FROM ResignationStatus WHERE StatusName = 'Rejected' AND InactiveDateTime IS NULL)

	  INNER JOIN (SELECT J.EmployeeId, MAX(J.JoinedDate) JoinedDate 
	              FROM Job J 
				       INNER JOIN Employee E ON E.Id = J.EmployeeId
					   INNER JOIN [User] U ON U.Id = E.UserId
				  WHERE U.CompanyId = @CompanyId AND J.InActiveDateTime IS NULL GROUP BY EmployeeId) Job ON Job.EmployeeId = TInner.EmployeeId AND DATEADD(MONTH, DATEDIFF(MONTH, 0, Job.JoinedDate) , 0) <= DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0)
	  INNER JOIN Job J ON J.InActiveDateTime IS NULL AND J.EmployeeId = Job.EmployeeId AND J.JoinedDate = Job.JoinedDate

	) TFinalInner

	  INNER JOIN Employee E ON E.Id = TFinalInner.EmployeeId
	  INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	  INNER JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL AND ES.Id = TFinalInner.SalaryId AND ES.Id = @EmployeeSalaryId

	) TOuter

	) TFinalOuter

	)TFinalOuterOuter

	WHERE EmployeeId NOT IN (SELECT EmployeeId FROM EmployeeResignation ER INNER JOIN ResignationStatus RS ON RS.Id = ER.ResignationStastusId 
	                         WHERE ER.InActiveDateTime IS NULL AND ER.LastDate < @RunStartDate AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL)
		  AND EmployeeId = @EmployeeId
						
	--Components calculation End
	
	DECLARE @RelatedToPtAmount FLOAT, @RelatedToPTValue FLOAT, @OtherAllowanceId UNIQUEIDENTIFIER, @OtherAllowanceName NVARCHAR(50), @IsEqual BIT, @Earning FLOAT,
			@TaxId UNIQUEIDENTIFIER, @TaxName NVARCHAR(50), @TaxAmount FLOAT, @TaxYear INT,@EmployeeBranchId UNIQUEIDENTIFIER, @TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT,@LeaveEncashmentStartDate DATE,@LeaveEncashmentEndDate DATE,
			@OneDaySalary FLOAT, @JoiningDate DATE, @JoinedMonths INT, @JoinedQuarters INT, @TaxFinancialFromYear INT, @TaxFinancialToYear INT, @TaxFinancialYearFromDate DATE, @TaxFinancialYearToDate DATE, @EmployerShare FLOAT,
			@EmployeeCountryId UNIQUEIDENTIFIER

	SELECT @EmployerShare = SUM(P.PayrollComponentAmount)
	FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
	WHERE P.EmployeeId = @EmployeeId AND P.IsDeduction = 0 AND PC.EmployerContributionPercentage IS NOT NULL

	SELECT @EmployeeBranchId = BranchId
	FROM EmployeeBranch EB
	WHERE EB.EmployeeId = @EmployeeId
	      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
		          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
				  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
			  ) 
			 
	SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

	SELECT @TaxFinancialYearFromMonth = FromMonth, @TaxFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
	WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @TaxFinancialYearTypeId
	     -- AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			   --   OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  --OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
			   --)

	SELECT @TaxFinancialYearFromMonth = ISNULL(@TaxFinancialYearFromMonth,4), @TaxFinancialYearToMonth = ISNULL(@TaxFinancialYearToMonth,3)

	SELECT @TaxFinancialFromYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
	SELECT @TaxFinancialToYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

	SELECT @TaxFinancialYearFromDate = DATEFROMPARTS(@TaxFinancialFromYear,@TaxFinancialYearFromMonth,1), @TaxFinancialYearToDate = EOMONTH(DATEFROMPARTS(@TaxFinancialToYear,@TaxFinancialYearToMonth,1))
	
	SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId
	
	SELECT @JoinedMonths = DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1, @JoinedQuarters = CEILING((DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1)/3.0)
	
	SELECT @TaxYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END

	-- Other Allowance calculation Start
	SELECT @IsEqual = CASE WHEN SUM(Earning) = EmployeeSalary OR SUM(Earning) + 5 >=  EmployeeSalary OR SUM(Earning) >= EmployeeSalary + 5 THEN 1 ELSE 0 END, 
	       @Earning = EmployeeSalary - SUM(Earning)
	FROM #Payroll WHERE EmployeeId = @EmployeeId GROUP BY EmployeeId,EmployeeSalary

	IF(@IsEqual = 0)
	BEGIN
		
		SELECT @OtherAllowanceId = Id, @OtherAllowanceName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Other Allowance' AND InActiveDateTime IS NULL

		INSERT INTO #Payroll
		SELECT TOP 1 P.EmployeeId,P.PayrollTemplateId,@OtherAllowanceId,@OtherAllowanceName,0,EmployeeSalary,OneDaySalary,0,@Earning,@Earning,NULL
		FROM #Payroll P

	END
	-- Other Allowance calculation End

	--IsRelatedToPt calculation Start
	SELECT @RelatedToPtAmount = SUM(Earning) - ISNULL(@EmployerShare,0)
	FROM #Payroll WHERE EmployeeId = @EmployeeId
	
	SELECT @RelatedToPTValue = TaxAmount 
	FROM ProfessionalTaxRange 
	WHERE ((ToRange IS NOT NULL AND @RelatedToPtAmount BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND @RelatedToPtAmount >= FromRange)) AND IsArchived = 0 AND BranchId = @EmployeeBranchId
	     -- AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			   --   OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  --OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   --)
	    
	UPDATE #Payroll SET PayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTValue ELSE @RelatedToPTValue END
	WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1

	UPDATE #Payroll SET Earning = ROUND((CASE WHEN IsDeduction = 0 THEN PayrollComponentAmount END),0), Deduction = ROUND((CASE WHEN IsDeduction = 1 THEN PayrollComponentAmount END),0)
	WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1
	--IsRelatedToPt calculation End
	
	----Tax calculation Start
	SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
	
	SELECT @TaxAmount = ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmountBasedOnSalaryAndTemplate](@EmployeeId,@EmployeeSalaryId,@PayrollTemplateId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate))/12.0,0),0) 
			
	IF(@TaxAmount > 0)
	BEGIN

		INSERT INTO #Payroll
		SELECT TOP 1 P.EmployeeId,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,OneDaySalary,0,-@TaxAmount,NULL,-@TaxAmount
		FROM #Payroll P

	END
	
	DECLARE @EmployerContibution FLOAT = (SELECT SUM(PayrollComponentAmount)
										  FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
										  WHERE PC.EmployerContributionPercentage IS NOT NULL AND P.IsDeduction = 0
										        AND EmployeeId = @EmployeeId)

	DECLARE @CurrencyCode NVARCHAR(50) = (SELECT SC.CurrencyCode FROM SYS_Currency SC INNER JOIN PayrollTemplate PT ON PT.CurrencyId = SC.Id WHERE PT.Id = @PayrollTemplateId)
	
	SELECT dbo.Ufn_GetCurrency(@CurrencyCode,(SELECT SUM(PayrollComponentAmount) - ISNULL(@EmployerContibution,0) FROM #Payroll),1) TakeHomeAmount

END
GO


--EXEC USP_GetTakeHomeAmount 'E6B221D1-99F3-4CDA-BED6-3EECFB75CA4F','29D3AA0C-2E74-4CF9-B03B-E8173DF2E319'
--EXEC USP_GetTakeHomeAmount 'E6B221D1-99F3-4CDA-BED6-3EECFB75CA4F','98A07FE5-4BFD-4E83-BD4D-F98BF13B31DA'