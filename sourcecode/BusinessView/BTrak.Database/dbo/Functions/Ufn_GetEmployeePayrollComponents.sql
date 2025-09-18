CREATE FUNCTION [dbo].[Ufn_GetEmployeePayrollComponents]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@EmployeeId UNIQUEIDENTIFIER
)
RETURNS @PayrollComponents TABLE
(
	EmployeeId UNIQUEIDENTIFIER,
	PayrollComponentId UNIQUEIDENTIFIER,
	PayrollComponentName NVARCHAR(500),
	IsDeduction BIT,
	PayrollComponentAmount FLOAT,
	ActualPayrollComponentAmount FLOAT
)
AS
BEGIN
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate) ,@TaxPeriodType NVARCHAR(100), @LossOfPayPeriodType NVARCHAR(100), @LeaveEncashmentPeriodType NVARCHAR(100),
	        @SalaryId UNIQUEIDENTIFIER
	
	SELECT @SalaryId = SalaryId
	FROM EmployeepayrollConfiguration EPC 
	WHERE EPC.EmployeeId = @EmployeeId AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND ( (EPC.ActiveTo IS NOT NULL AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  		            OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
						OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  			     )

	IF(@SalaryId IS NULl)
	BEGIN

		SELECT TOP 1 @SalaryId = SalaryId
		FROM EmployeepayrollConfiguration
		WHERE EmployeeId = @EmployeeId
		      AND ActiveFrom <= @RunEndDate
		ORDER BY ActiveFrom DESC

		IF(@SalaryId IS NULL)
		BEGIN

			SELECT TOP 1 @SalaryId = SalaryId
			FROM EmployeepayrollConfiguration
			WHERE EmployeeId = @EmployeeId
			      AND ActiveFrom > @RunEndDate
			ORDER BY ActiveFrom 

			IF(@SalaryId IS NULL)
			BEGIN

				SELECT TOP 1 @SalaryId = SalaryId
				FROM EmployeepayrollConfiguration
				WHERE EmployeeId = @EmployeeId
				ORDER BY ActiveFrom DESC

			END

		END

	END

	--Components calculation Start
	INSERT INTO @PayrollComponents
	SELECT EmployeeId,
		   PayrollComponentId,
		   PayrollComponentName,
		   IsDeduction,
		   ROUND(PayrollComponentAmount,0) PayrollComponentAmount,
		   ROUND(ActualPayrollComponentAmount,0) ActualPayrollComponentAmount
	FROM (

	SELECT *,
	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END PayrollComponentAmount,

	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END ActualPayrollComponentAmount
	FROM (

	SELECT *,
	       CASE WHEN ResignationLastDate IS NOT NULL THEN ROUND((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) * OneDaySalary ),0)
		        WHEN JoinedDate >= @RunStartDate THEN ROUND(((DATEDIFF(DAY,JoinedDate,@RunEndDate) + 1) * OneDaySalary ),0)
				WHEN TotalDaysInPayroll <> DAY(EOMONTH(@RunStartDate)) OR TotalDaysInPayroll <> @TotalWorkingDays THEN ROUND((TotalDaysInPayroll * OneDaySalary),0)
				ELSE ROUND((EmployeePackage/12.0),0)  
			END EmployeeSalary,

	       CASE WHEN LossOfPay > 0 THEN (CASE WHEN ResignationLastDate IS NOT NULL THEN ROUND(((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) - LossOfPay) * OneDaySalary),0) 
		                                      WHEN JoinedDate >= @RunStartDate THEN ROUND((((DATEDIFF(DAY,JoinedDate,@RunEndDate) + 1) - LossOfPay) * OneDaySalary),0) 
		                                      ELSE ROUND(((@TotalWorkingDays - LossOfPay) * OneDaySalary),0) END)
		        WHEN ResignationLastDate IS NOT NULL THEN ROUND((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) * OneDaySalary ),0) -- Only for correct PF calculation for resignated employee
				WHEN JoinedDate >= @RunStartDate THEN ROUND(((DATEDIFF(DAY,JoinedDate,@RunEndDate) + 1) * OneDaySalary ),0)
				WHEN TotalDaysInPayroll <> DAY(EOMONTH(@RunStartDate)) OR TotalDaysInPayroll <> @TotalWorkingDays THEN ROUND((TotalDaysInPayroll * OneDaySalary),0)
				ELSE ROUND((EmployeePackage/12.0),0) 
		   END ActualEmployeeSalary
	FROM (

	SELECT TFinalInner.*,
	       U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
		   (ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0 EmployeePackage,
		   ROUND(((((ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0)/12.0)/@TotalWorkingDays),2) OneDaySalary,
		   CASE WHEN IsLossOfPayMonth = 1 THEN TotalWorkingDays - ISNULL(LossOfPay,0)
		        WHEN TotalDaysInPayroll <> DAY(EOMONTH(@RunStartDate)) OR TotalDaysInPayroll <> @TotalWorkingDays THEN TotalDaysInPayroll
		        ELSE TotalWorkingDays 
		   END WorkedDays
	FROM (

	SELECT TInner.*,
	       DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
	       CASE WHEN Job.JoinedDate >= @RunStartDate THEN DATEDIFF(DAY,Job.JoinedDate,@RunEndDate) + 1 ELSE @TotalWorkingDays END TotalWorkingDays,
		   0 LossOfPay,
		   0 IsLossOfPayMonth,
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
		 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL AND EPC.SalaryId = @SalaryId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL 
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

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
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL AND EPC.SalaryId = @SalaryId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL 
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

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
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL AND EPC.SalaryId = @SalaryId
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL 
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

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
	  INNER JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL AND ES.Id = TFinalInner.SalaryId

	) TOuter

	) TFinalOuter

	)TFinalOuterOuter

	WHERE EmployeeId NOT IN (SELECT EmployeeId FROM EmployeeResignation ER INNER JOIN ResignationStatus RS ON RS.Id = ER.ResignationStastusId 
	                         WHERE ER.InActiveDateTime IS NULL AND ER.LastDate < @RunStartDate AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL)

	--Components calculation End
	
	RETURN
END
