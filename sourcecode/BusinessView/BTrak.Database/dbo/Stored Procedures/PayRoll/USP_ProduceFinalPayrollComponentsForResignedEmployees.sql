CREATE PROCEDURE [dbo].[USP_ProduceFinalPayrollComponentsForResignedEmployees]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER,
	@PayrollTemplateId UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@EmployeeIds NVARCHAR(MAX) = NULL,
	@EmploymentStatusIds NVARCHAR(MAX) = NULL,
	@EmployeeDetails NVARCHAR(MAX) = NULL
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate), @TaxPeriodType NVARCHAR(100)
	DECLARE @LossOfPayStartDate DATE, @LossOfPayEndDate DATE,@LOPEmployeesCount INT, @LOPEmployeesCounter INT = 1, @LOPEmployeeId UNIQUEIDENTIFIER,@LOPEmployeeBranchId UNIQUEIDENTIFIER, @LOPUserId UNIQUEIDENTIFIER,  
	        @LOPFinancialYearFromMonth INT, @LOPFinancialYearToMonth INT, @TaxFinancialYearTypeId UNIQUEIDENTIFIER, @LeavesFinancialYearTypeId UNIQUEIDENTIFIER, @LOPFinancialYearFromDate DATE, @LOPFinancialYearToDate DATE, 
			@LOPFinancialFromYear INT, @LOPFinancialToYear INT, @LopJoiningDate DATETIME, @ResignationDate DATETIME, @LastDate DATETIME, @BeforeLossOfPayStartDate DATE, @BeforeLossOfPayEndDate DATE, @MonthStartDate DATE, 
			@MonthEndDate DATE, @AllowedLeaves FLOAT, @LOPEmployeeCountryId UNIQUEIDENTIFIER

	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'
	SELECT @LeavesFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Leaves'

	
	CREATE TABLE #EmployeeDetails
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		EmployeeNumber NVARCHAR(250),
		EmployeeName NVARCHAR(500),
		LossOfPay FLOAT,
		EncashedLeaves FLOAT
	)

	INSERT INTO #EmployeeDetails(EmployeeNumber,EmployeeName,LossOfPay,EncashedLeaves)
	SELECT *
	FROM OPENJSON(@EmployeeDetails)
	WITH (
			EmployeeNumber NVARCHAR(250) 'strict $.EmployeeNumber',
			EmployeeName NVARCHAR(500) 'strict $.EmployeeName',
			LossOfPay FLOAT 'strict $.LossOfPay',
			EncashedLeaves FLOAT 'strict $.EncashedLeaves'
	     )

	UPDATE #EmployeeDetails SET EmployeeId= E.Id
	FROM Employee E 
	      INNER JOIN [User] U ON U.Id = E.UserId
	      INNER JOIN #EmployeeDetails ED ON ED.EmployeeNumber = E.EmployeeNumber
	WHERE CompanyId = @CompanyId

	--Loss Of Pay Start
	CREATE TABLE #LeaveEmployee 
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		UserId UNIQUEIDENTIFIER,
		BranchId UNIQUEIDENTIFIER,
		LeavesTaken FLOAT,
		UnplannedHolidays FLOAT,
		SickDays FLOAT,
		PlannedHolidays FLOAT,
		TotalLeaves FLOAT,
		AllowedLeaves FLOAT,
		PaidLeaves FLOAT,
		UnPaidLeaves FLOAT,
		IsLossOfPayMonth BIT,
		ResignationDate DATETIME,
		LastDate DATETIME,
		LossOfPay FLOAT,
		LastPeriodLossOfPay FLOAT
	)
	
	INSERT INTO #LeaveEmployee(EmployeeId,UserId,BranchId,ResignationDate,LastDate)
	SELECT E.Id EmployeeId,
	       U.Id UserId,
		   EB.BranchId,
		   ER.ResignationDate,
		   ER.LastDate
	FROM [User] U
	     INNER JOIN Employee E ON E.UserId = U.Id
		 INNER JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime Is NULL
		 INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
		 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
					  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				  ) 

	WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
	      AND DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
		  AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))
		  AND E.Id IN (SELECT EmployeeId FROM #EmployeeDetails)

	SELECT @LOPEmployeesCount = COUNT(1) FROM #LeaveEmployee

	WHILE(@LOPEmployeesCounter <= @LOPEmployeesCount)
	BEGIN

		SELECT @LOPEmployeeId = EmployeeId, @LOPUserId = UserId, @LOPEmployeeBranchId = BranchId FROM #LeaveEmployee WHERE Id = @LOPEmployeesCounter
		SELECT @LossOfPayStartDate = NULL, @LossOfPayEndDate = NULL, @LOPFinancialYearFromMonth = NULL, @LOPFinancialYearToMonth = NULl
		
		SELECT @LOPEmployeeCountryId = CountryId FROM Branch WHERE Id = @LOPEmployeeBranchId

		SELECT @LOPFinancialYearFromMonth = FromMonth, @LOPFinancialYearToMonth = ToMonth 
		FROM [FinancialYearConfigurations] WHERE CountryId = @LOPEmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @LeavesFinancialYearTypeId
		     AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )
		
		SELECT @LOPFinancialYearFromMonth = ISNULL(@LOPFinancialYearFromMonth,1), 
			   @LOPFinancialYearToMonth = ISNULL(@LOPFinancialYearToMonth,12)

		SELECT @LOPFinancialFromYear = CASE WHEN @PayrollRunMonth - @LOPFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @LOPFinancialToYear = CASE WHEN @PayrollRunMonth - @LOPFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT  @LOPFinancialYearFromDate = DATEFROMPARTS(@LOPFinancialFromYear,@LOPFinancialYearFromMonth,1), @LOPFinancialYearToDate = EOMONTH(DATEFROMPARTS(@LOPFinancialToYear,@LOPFinancialYearToMonth,1))
		
		UPDATE #LeaveEmployee SET TotalLeaves = [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](@LOPUserId,@LOPFinancialYearFromDate,@LOPFinancialYearToDate,1) 
		WHERE EmployeeId = @LOPEmployeeId

		SELECT @LopJoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @LopEmployeeId

		SELECT @ResignationDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, ResignationDate) , 0), @LastDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, LastDate) , 0))
		FROM EmployeeResignation ER
	         INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
		WHERE DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
		      AND EmployeeId = @LopEmployeeId

		SELECT @BeforeLossOfPayStartDate = CASE WHEN @LopJoiningDate > @LOPFinancialYearFromDate THEN @LopJoiningDate ELSE @LOPFinancialYearFromDate END, @BeforeLossOfPayEndDate = DATEADD(DAY,-1,@ResignationDate)
		
		SELECT @LossOfPayStartDate = @ResignationDate, @LossOfPayEndDate = @LastDate
		
		DECLARE @Months INT, @MonthsCounter INT = 1

		DECLARE @BeforeMonths TABLE
		(
			Id INT,
			EmployeeId UNIQUEIDENTIFIER,
			MonthStartDate DATE,
			MonthEndDate DATE,
			AllowedLeaves FLOAT,
			PaidLeaves FLOAT,
			UnPaidLeaves FLOAT,
			Leaves FLOAT,
			LossOfPay FLOAT
		)

		DECLARE @LopMonths TABLE
		(
			Id INT,
			EmployeeId UNIQUEIDENTIFIER,
			MonthStartDate DATE,
			MonthEndDate DATE,
			AllowedLeaves FLOAT,
			PaidLeaves FLOAT,
			UnPaidLeaves FLOAT,
			Leaves FLOAT,
			LossOfPay FLOAT
		)

		;WITH BeforeMonths (Date)
		AS
		(
		    SELECT @BeforeLossOfPayStartDate
		    UNION ALL
		    SELECT DATEADD(month, 1, DATE)
		    FROM BeforeMonths
		    WHERE DATEADD(month, 1, DATE) < @BeforeLossOfPayEndDate
		)
		INSERT INTO @BeforeMonths(Id,EmployeeId,MonthStartDate,MonthEndDate,AllowedLeaves)
		SELECT ROW_NUMBER() OVER (ORDER BY [Date]) Id,
		       @LopEmployeeId, 
		       [Date] MonthStartDate, 
			   EOMONTH([Date]) MonthEndDate, 
			   [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,[Date],EOMONTH([Date])) AllowedLeaves
		FROM BeforeMonths

		SELECT @Months = COUNT(1) FROM @BeforeMonths WHERE EmployeeId = @LopEmployeeId

		WHILE(@MonthsCounter <= @Months)
		BEGIN

			UPDATE @BeforeMonths SET AllowedLeaves = ISNULL(AllowedLeaves,0) + ISNULL((SELECT CASE WHEN AllowedLeaves < PaidLeaves THEN 0 ELSE AllowedLeaves - PaidLeaves END 
			                                                                    FROM @BeforeMonths WHERE Id = (@MonthsCounter - 1) AND EmployeeId =  @LOPEmployeeId),0)
		    WHERE Id = @MonthsCounter AND EmployeeId =  @LOPEmployeeId

			SELECT @MonthStartDate = MonthStartDate, @MonthEndDate = MonthEndDate, @AllowedLeaves = AllowedLeaves FROM @BeforeMonths WHERE Id = @MonthsCounter AND EmployeeId = @LopEmployeeId

			UPDATE @BeforeMonths SET Leaves = ROUND(ISNULL(LEP.UnPaidLeaves,0) + ISNULL(LEP.PaidLeaves,0),2), PaidLeaves = ISNULL(LEP.PaidLeaves,0), UnPaidLeaves = ISNULL(LEP.UnPaidLeaves,0),
			                         LossOfPay = ROUND((ISNULL(LEP.UnPaidLeaves,0) + ISNULL((CASE WHEN @AllowedLeaves < LEP.PaidLeaves THEN LEP.PaidLeaves - @AllowedLeaves ELSE 0 END),0)),2)
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@MonthStartDate,@MonthEndDate) LEP INNER JOIN @BeforeMonths LE ON LE.EmployeeId = LEP.EmployeeId
		    WHERE Id = @MonthsCounter AND LE.EmployeeId =  @LOPEmployeeId

			SET @MonthsCounter = @MonthsCounter + 1

		END
		
		;WITH LopMonths (Date)
		AS
		(
		    SELECT @LossOfPayStartDate
		    UNION ALL
		    SELECT DATEADD(month, 1, DATE)
		    FROM LopMonths
		    WHERE DATEADD(month, 1, DATE) < @LossOfPayEndDate
		)
		INSERT INTO @LopMonths(Id,EmployeeId,MonthStartDate,MonthEndDate,AllowedLeaves)
		SELECT ROW_NUMBER() OVER (ORDER BY [Date]) Id, 
		       @LOPEmployeeId,
		       [Date] MonthStartDate, 
			   EOMONTH([Date]) MonthEndDate, 
			   [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,[Date],EOMONTH([Date])) AllowedLeaves
		FROM LopMonths

		SELECT @Months = 0, @MonthsCounter = 1, @MonthStartDate = NULL, @MonthEndDate = NULL
		SELECT @Months = COUNT(1) FROM @LopMonths WHERE EmployeeId = @LopEmployeeId
		
		WHILE(@MonthsCounter <= @Months)
		BEGIN

			UPDATE @LopMonths SET AllowedLeaves = ISNULL(AllowedLeaves,0) + ISNULL((SELECT CASE WHEN AllowedLeaves < PaidLeaves THEN 0 ELSE AllowedLeaves - PaidLeaves END 
			                                                                        FROM @BeforeMonths WHERE Id = (SELECT MAX(Id) FROM @BeforeMonths WHERE EmployeeId =  @LOPEmployeeId) AND EmployeeId =  @LOPEmployeeId),0)
		    WHERE Id = @MonthsCounter AND EmployeeId =  @LOPEmployeeId AND Id = 1

			UPDATE @LopMonths SET AllowedLeaves = ISNULL(AllowedLeaves,0) + ISNULL((SELECT CASE WHEN AllowedLeaves < PaidLeaves THEN 0 ELSE AllowedLeaves - PaidLeaves END 
			                                                                        FROM @LopMonths WHERE Id = (@MonthsCounter - 1) AND EmployeeId =  @LOPEmployeeId),0)
		    WHERE Id = @MonthsCounter AND EmployeeId =  @LOPEmployeeId

			SELECT @MonthStartDate = MonthStartDate, @MonthEndDate = MonthEndDate, @AllowedLeaves = AllowedLeaves FROM @LopMonths WHERE Id = @MonthsCounter AND EmployeeId = @LopEmployeeId

			UPDATE @LopMonths SET Leaves = ROUND(ISNULL(LEP.UnPaidLeaves,0) + ISNULL(LEP.PaidLeaves,0),2), PaidLeaves = ISNULL(LEP.PaidLeaves,0), UnPaidLeaves = ISNULL(LEP.UnPaidLeaves,0),
			                      LossOfPay = ROUND((ISNULL(LEP.UnPaidLeaves,0) + ISNULL((CASE WHEN @AllowedLeaves < LEP.PaidLeaves THEN LEP.PaidLeaves - @AllowedLeaves ELSE 0 END),0)),2)
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@MonthStartDate,@MonthEndDate) LEP INNER JOIN @LopMonths LE ON LE.EmployeeId = LEP.EmployeeId
		    WHERE Id = @MonthsCounter AND LE.EmployeeId =  @LOPEmployeeId

			SET @MonthsCounter = @MonthsCounter + 1

		END
		
		UPDATE #LeaveEmployee SET AllowedLeaves = (SELECT MAX(AllowedLeaves) FROM @LopMonths WHERE EmployeeId = @LOPEmployeeId), 
		                          LossOfPay = (SELECT SUM(LossOfPay) FROM @LopMonths WHERE EmployeeId = @LOPEmployeeId), IsLossOfPayMonth = 1
		WHERE EmployeeId =  @LOPEmployeeId
		
		UPDATE #LeaveEmployee SET LastPeriodLossOfPay = (SELECT LossOfPay FROM @LopMonths WHERE EmployeeId = @LOPEmployeeId AND Id = @Months)

		UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
		FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
		WHERE LE.EmployeeId =  @LOPEmployeeId

		SET @LOPEmployeesCounter = @LOPEmployeesCounter + 1

	END

	UPDATE #LeaveEmployee SET IsLossOfPayMonth = 1

	--Loss Of Pay End
	
	--Components calculation Start
	SELECT EmployeeId,
	       EmployeeName,
		   PayrolltemplateId,
		   PayrollComponentId,
		   PayrollComponentName,
		   IsDeduction,
		   EmployeeSalary,
		   ActualEmployeeSalary,
		   OneDaySalary,
		   IsRelatedToPT,
		   ROUND(PayrollComponentAmount,0) PayrollComponentAmount,
		   ROUND(ActualPayrollComponentAmount,0) ActualPayrollComponentAmount,
	       ROUND((CASE WHEN IsDeduction = 0 THEN PayrollComponentAmount END),0) Earning, 
		   ROUND((CASE WHEN IsDeduction = 1 THEN PayrollComponentAmount END),0) Deduction,
		   ROUND((CASE WHEN IsDeduction = 0 THEN ActualPayrollComponentAmount END),0) ActualEarning, --Actual columns are calculated because of Loss Of Pay
		   ROUND((CASE WHEN IsDeduction = 1 THEN ActualPayrollComponentAmount END),0) ActualDeduction,
		   TotalDaysInPayroll,
		   DaysInResignationPeriod TotalWorkingDays,
		   LeavesTaken,
		   UnplannedHolidays,
		   SickDays,
		   WorkedDays,
		   PlannedHolidays,
		   LossOfPay,
		   0 IsInResignation,
		   TotalLeaves,
		   PaidLeaves,
		   UnPaidLeaves,
		   AllowedLeaves,
		   IsLossOfPayMonth,
		   NULL EmployeeConfigAndSalaryId,
		   LastPeriodPayrollComponentAmount,
		   LastPeriodSalary,
		   LastPeriodLossOfPay,
		   ActualLastPeriodPayrollComponentAmount,
		   ActualLastPeriodSalary,
		   EncashedLeaves,
		   NULL TotalAmountPaid,
		   NULL LoanAmountRemaining
	INTO #Payroll
	FROM (

	SELECT *,
	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END PayrollComponentAmount,

	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay) END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN (((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay)) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN (((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LossOfPay)) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END ActualPayrollComponentAmount,

	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN LastPeriodSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,LastPeriodSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN LastPeriodSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,LastPeriodSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE Amount END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (LastPeriodSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (LastPeriodSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END LastPeriodPayrollComponentAmount,

		   CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN ActualLastPeriodSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualLastPeriodSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LastPeriodLossOfPay) END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN ActualLastPeriodSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualLastPeriodSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LastPeriodLossOfPay) END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN (((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LastPeriodLossOfPay)) * PercentageValue ELSE (ActualLastPeriodSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN (((DependentAmount*1.0)/@TotalWorkingDays) * (@TotalWorkingDays - LastPeriodLossOfPay)) * PercentageValue ELSE (ActualLastPeriodSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END ActualLastPeriodPayrollComponentAmount
	FROM (

	SELECT *,
	       ROUND((DATEDIFF(MONTH,Resignationdate,LastDate) * ROUND((EmployeePackage/12.0),0)) + ((DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary),0) EmployeeSalary,
	       CASE WHEN LossOfPay IS NOT NULL OR LossOfPay > 0 THEN ROUND(((DATEDIFF(MONTH,Resignationdate,LastDate) * ROUND((EmployeePackage/12.0),0)) + ((DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary) - (ROUND((LossOfPay * OneDaySalary),0))),0)
		        ELSE ROUND(((DATEDIFF(MONTH,Resignationdate,LastDate) * ROUND((EmployeePackage/12.0),0)) + ((DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary)),0) END ActualEmployeeSalary,
		   ROUND(((DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary),0) LastPeriodSalary,
		   ROUND(((DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary),0) - ROUND((LastPeriodLossOfPay * OneDaySalary),0) ActualLastPeriodSalary
	FROM (
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
	SELECT TFinalInner.*,
	       U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
		   (ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0 EmployeePackage,
		   ROUND(((((ES.Amount - ISNULL(ES.NetPayAmount,0))*1.0)/12.0)/@TotalWorkingDays),2) OneDaySalary,
		   CASE WHEN IsLossOfPayMonth = 1 THEN DaysInResignationPeriod - ISNULL(LossOfPay,0) ELSE DaysInResignationPeriod END WorkedDays
	FROM (

	SELECT TInner.*,
	       DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
	       @TotalWorkingDays TotalWorkingDays,
		   LeavesTaken,
		   UnplannedHolidays,
		   SickDays,
		   CASE WHEN IsLossOfPayMonth = 1 THEN ED.LossOfPay ELSE NULL END LossOfPay,
		   ED.EncashedLeaves,
		   PlannedHolidays,
		   AllowedLeaves,
		   TotalLeaves,
		   PaidLeaves,
		   UnPaidLeaves,
		   IsLossOfPayMonth,
		   LastPeriodLossOfPay,
		   DATEDIFF(DAY,DATEADD(month, DATEDIFF(month, 0, TInner.ResignationDate), 0),TInner.ResignationDate) + (DATEDIFF(DAY,TInner.ResignationDate,TInner.LastDate) + 1) DaysInResignationPeriod
	FROM (

	SELECT E.Id EmployeeId,
	       EPC.PayrolltemplateId,
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
		   ER.ResignationDate,
		   ER.LastDate,
		   EPC.SalaryId
	FROM EmployeeResignation ER
	     INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
	     INNER JOIN Employee E ON E.Id = ER.EmployeeId AND E.InActiveDateTime IS NULL AND ER.InActiveDateTime IS NULL
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
			            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
				              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
							  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
					        ) 
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND ( (EPC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  		            OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
						OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  			     )
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	UNION

	SELECT E.Id EmployeeId,
	       EPC.PayrolltemplateId,
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
		   ER.ResignationDate,
		   ER.LastDate,
		   EPC.SalaryId
	FROM EmployeeResignation ER
	     INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
	     INNER JOIN Employee E ON E.Id = ER.EmployeeId AND E.InActiveDateTime IS NULL AND ER.InActiveDateTime IS NULL
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
			            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
				              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
							  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
					        ) 
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND ( (EPC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  		            OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
						OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  			     )
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	UNION

	SELECT E.Id EmployeeId,
	       EPC.PayrolltemplateId,
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
		   ER.ResignationDate,
		   ER.LastDate,
		   EPC.SalaryId
	FROM EmployeeResignation ER
	     INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
	     INNER JOIN Employee E ON E.Id = ER.EmployeeId AND E.InActiveDateTime IS NULL AND ER.InActiveDateTime IS NULL
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
			            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
				              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
							  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
					        ) 
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND ( (EPC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  		               OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
						   OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  			     )
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	) TInner

      INNER JOIN #EmployeeDetails ED ON ED.EmployeeId = TInner.EmployeeId
	  LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = TInner.EmployeeId
	  INNER JOIN (SELECT J.EmployeeId, MAX(J.JoinedDate) JoinedDate 
	              FROM Job J 
				       INNER JOIN Employee E ON E.Id = J.EmployeeId
					   INNER JOIN [User] U ON U.Id = E.UserId
				  WHERE U.CompanyId = @CompanyId AND J.InActiveDateTime IS NULL GROUP BY EmployeeId) Job ON Job.EmployeeId = TInner.EmployeeId AND DATEADD(MONTH, DATEDIFF(MONTH, 0, Job.JoinedDate) , 0) <= DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0)
	  INNER JOIN Job J ON J.InActiveDateTime IS NULL AND J.EmployeeId = Job.EmployeeId AND J.JoinedDate = Job.JoinedDate
	                      AND (@EmploymentStatusIds IS NULL OR J.EmploymentStatusId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmploymentStatusIds)))

	) TFinalInner

	  INNER JOIN Employee E ON E.Id = TFinalInner.EmployeeId
	  INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	  INNER JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL AND ES.Id = TFinalInner.SalaryId

	) TOuter

	) TFinalOuter

	)TFinalOuterOuter
	--Components calculation End

	SELECT ROW_NUMBER() OVER (ORDER BY EmployeeId) Id,
	       EmployeeId 
	INTO #Employee
	FROM #Payroll
	GROUP BY EmployeeId

	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @UserId UNIQUEIDENTIFIER, @IsEqual BIT, @Earning FLOAT, @RelatedToPtAmount FLOAT, @RelatedToPTValue FLOAT, @RelatedToPtActualAmount FLOAT, @RelatedToPTActualValue FLOAT, @ActualEarning FLOAT, 
	        @EmployeeBonus FLOAT, @OtherAllowanceId UNIQUEIDENTIFIER, @OtherAllowanceName NVARCHAR(50), @BonusId UNIQUEIDENTIFIER, @BonusName NVARCHAR(50), @EmployerPF FLOAT, @EmployerESI FLOAT, @ActualEmployerPF FLOAT, @ActualEmployerESI FLOAT,
			@LeaveEncashmentId UNIQUEIDENTIFIER, @LeaveEncashmentName NVARCHAR(50), @LeaveEncashmentSetting UNIQUEIDENTIFIER, @RemainingLeaves INT, @RemainingLeavesValue FLOAT, @ActualRemainingLeavesValue FLOAT, 
			@TaxId UNIQUEIDENTIFIER, @TaxName NVARCHAR(50), @TaxAmount FLOAT, @TaxYear INT,@EmployeeBranchId UNIQUEIDENTIFIER, @TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT,@LeaveEncashmentStartDate DATE,@LeaveEncashmentEndDate DATE,
			@OneDaySalary FLOAT, @ActualOneDaySalary FLOAT, @EligibleLeaves FLOAT, @PaidLeaves FLOAT, @EmployeeLastDate DATETIME, @EmployeeResignationStartDate DATETIME,
			@JoiningDate DATE, @JoinedMonths INT, @JoinedQuarters INT, @TaxFinancialFromYear INT, @TaxFinancialToYear INT, @TaxFinancialYearFromDate DATE, @TaxFinancialYearToDate DATE, @EmployerShare FLOAT, @ActualEmployerShare FLOAT,
			@LoanId UNIQUEIDENTIFIER, @LoanName NVARCHAR(50), @LoanAmount FLOAT, @EmployeeCountryId UNIQUEIDENTIFIER, 
			@TaxPaidCount INT, @TaxPayableCount INT

	SELECT @TaxPeriodType = PT.PeriodTypeName
	FROM PayRollCalculationConfigurations PCC 
	     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
		 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
	WHERE PCT.PayRollCalculationTypeName = 'Tax calculation' AND PCC.InActiveDateTime IS NULL
	        AND ( (PCC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN PCC.ActiveFrom AND PCC.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (PCC.ActiveTo IS NULL AND @RunEndDate >= PCC.ActiveFrom)
				  OR (PCC.ActiveTo IS NOT NULL AND @RunStartDate <= PCC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, PCC.ActiveFrom), 0))
			   )

	SELECT @EmployeesCount = COUNT(1) FROM #Employee

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		SELECT @TaxPeriodType = NULL, @TaxFinancialYearFromMonth = NULL, @TaxFinancialYearToMonth = NULL, 
			   @TaxPaidCount = 0, @TaxPayableCount = 0

		SELECT @EmployeeId = EmployeeId FROM #Employee WHERE Id = @EmployeesCounter
		SELECT @EmployerPF = PayrollComponentAmount, @ActualEmployerPF = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentName = 'Employeer PF' AND IsDeduction = 0
		SELECT @EmployerESI = PayrollComponentAmount, @ActualEmployerESI = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentName = 'Employeer ESI' AND IsDeduction = 0

		--SELECT @EmployerShare = SUM(P.PayrollComponentAmount), @ActualEmployerShare = SUM(P.ActualPayrollComponentAmount) 
		--FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
		--WHERE P.EmployeeId = @EmployeeId AND P.IsDeduction = 0 AND PC.EmployerContributionPercentage IS NOT NULL

		SELECT @EmployerShare = SUM(P.LastPeriodPayrollComponentAmount), @ActualEmployerShare = SUM(P.ActualLastPeriodPayrollComponentAmount) 
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

		SELECT @TaxPeriodType = PT.PeriodTypeName
		FROM PayRollCalculationConfigurations PCC 
		     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
			 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
		WHERE PCT.PayRollCalculationTypeName = 'Tax calculation' AND PCC.InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId
		        AND ( (PCC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN PCC.ActiveFrom AND PCC.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (PCC.ActiveTo IS NULL AND @RunEndDate >= PCC.ActiveFrom)
				  OR (PCC.ActiveTo IS NOT NULL AND @RunStartDate <= PCC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, PCC.ActiveFrom), 0))
			   )

		SELECT @TaxFinancialYearFromMonth = FromMonth, @TaxFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
		WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @TaxFinancialYearTypeId
		      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		SELECT @TaxPeriodType = ISNULL(@TaxPeriodType,'Every month'), 
			   @TaxFinancialYearFromMonth = ISNULL(@TaxFinancialYearFromMonth,4), 
			   @TaxFinancialYearToMonth = ISNULL(@TaxFinancialYearToMonth,3)

		SELECT @TaxFinancialFromYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @TaxFinancialToYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT @EmployeeLastDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, LastDate) , 0)), @EmployeeResignationStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, ResignationDate) , 0)
		FROM EmployeeResignation ER
	         INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL
		WHERE DATENAME(MONTH,LastDate) + ' ' + DATENAME(YEAR,LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
		      AND EmployeeId = @EmployeeId

		SELECT @TaxFinancialYearFromDate = DATEFROMPARTS(@TaxFinancialFromYear,@TaxFinancialYearFromMonth,1), @TaxFinancialYearToDate = EOMONTH(DATEFROMPARTS(@TaxFinancialToYear,@TaxFinancialYearToMonth,1))

		SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId

		SELECT @JoinedMonths = DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1, @JoinedQuarters = CEILING((DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1)/3.0)

		SELECT @TaxYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END

		-- Other Allowance calculation Start
		SELECT @IsEqual = CASE WHEN SUM(ActualEarning) = ActualEmployeeSalary OR SUM(ActualEarning) + 5 >=  ActualEmployeeSalary OR SUM(ActualEarning) >= ActualEmployeeSalary + 5 THEN 1 ELSE 0 END, 
		                  @ActualEarning = ActualEmployeeSalary - SUM(ActualEarning), @Earning = EmployeeSalary - SUM(Earning)
		FROM #Payroll WHERE EmployeeId = @EmployeeId GROUP BY EmployeeId,EmployeeSalary,ActualEmployeeSalary

		IF(@IsEqual = 0)
		BEGIN
			
			SELECT @OtherAllowanceId = Id, @OtherAllowanceName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Other Allowance' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,P.EmployeeName,P.PayrolltemplateId,@OtherAllowanceId,@OtherAllowanceName,0,P.EmployeeSalary,P.ActualEmployeeSalary,P.OneDaySalary,0,@Earning,@ActualEarning,@Earning,NULL,@ActualEarning,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 P.TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		-- Other Allowance calculation End

		--Employee Bonus calculation Start
		
		--DATEDIFF(DAY,@RunStartDate,LastDate) + 1) * OneDaySalary
		--SELECT TOP 1 @OneDaySalary = OneDaySalary FROM #Payroll WHERE EmployeeId = @EmployeeId

		SELECT @EmployeeBonus = SUM(ComponentAmount)
		FROM PayrollRunEmployeeComponent PEC 
		     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
			 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PEC.PayrollRunId AND PRE.EmployeeId = PEC.EmployeeId
			 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						  FROM PayrollRunEmployee PRE 
							   INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
							   --INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							   --INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
						 WHERE PR.InactiveDateTime IS NULL
						 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
			INNER JOIN EmployeeResignation ER ON ER.EmployeeId = PEC.EmployeeId AND ER.InactiveDateTime IS NULL 
			           AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(month, DATEDIFF(month, 0, ER.ResignationDate), 0) AND EOMONTH(DATEADD(MONTH,-1,(DATEADD(month, DATEDIFF(month, 0, ER.LastDate), 0))))
		WHERE PEC.ComponentName = 'Bonus' AND PEC.EmployeeId = @EmployeeId

		DROP TABLE IF EXISTS dbo.Bonus

		CREATE TABLE Bonus 
		(
			Bonus FLOAT
		)

		INSERT INTO Bonus
		SELECT CASE WHEN Bonus IS NOT NULL THEN Bonus ELSE (CASE WHEN IsCtcType = 1 THEN ROUND(((SELECT TOP 1 LastPeriodSalary FROM #Payroll WHERE EmployeeId = @EmployeeId) * Percentage * 0.01),0)
		                                                                            ELSE ROUND(((SELECT TOP 1 LastPeriodPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentId = EB.PayrollComponentId) * Percentage * 0.01),0) END)
				END Bonus
		FROM EmployeeBonus EB 
		WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0 AND IsApproved = 1

		SELECT @EmployeeBonus = ISNULL(@EmployeeBonus,0) + ISNULL((SELECT SUM(Bonus) FROM Bonus),0)

		IF(@EmployeeBonus IS NOT NULL AND @EmployeeBonus > 0)
		BEGIN
			
			SELECT @BonusId = Id, @BonusName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Bonus' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@BonusId,@BonusName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@EmployeeBonus,@EmployeeBonus,@EmployeeBonus,NULL,@EmployeeBonus,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		--Employee Bonus calculation End

		--IsRelatedToPt calculation Start
		--SELECT @RelatedToPtAmount = SUM(Earning) - ISNULL(@EmployerShare,0), --ISNULL(@EmployerPF,0) - ISNULL(@EmployerESI,0), --SUM(Earning) + SUM(Deduction), 
		--       @RelatedToPtActualAmount = SUM(ActualEarning) - ISNULL(@ActualEmployerShare,0) --ISNULL(@ActualEmployerPF,0) - ISNULL(@ActualEmployerESI,0) --SUM(ActualEarning) + SUM(ActualDeduction),
		--FROM #Payroll WHERE EmployeeId = @EmployeeId

		SELECT @RelatedToPtAmount = SUM(LastPeriodPayrollComponentAmount) - ISNULL(@EmployerShare,0),
		       @RelatedToPtActualAmount = SUM(ActualLastPeriodPayrollComponentAmount) - ISNULL(@ActualEmployerShare,0)
		FROM #Payroll WHERE EmployeeId = @EmployeeId AND IsDeduction = 0
		
		SELECT @RelatedToPTValue = TaxAmount 
		FROM ProfessionalTaxRange 
		WHERE ((ToRange IS NOT NULL AND @RelatedToPtAmount BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND @RelatedToPtAmount >= FromRange)) AND IsArchived = 0 AND BranchId = @EmployeeBranchId
		         AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )
		SELECT @RelatedToPTActualValue = TaxAmount 
		FROM ProfessionalTaxRange 
		WHERE ((ToRange IS NOT NULL AND @RelatedToPtActualAmount BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND @RelatedToPtActualAmount >= FromRange)) AND IsArchived = 0 AND BranchId = @EmployeeBranchId
		         AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )
		
		UPDATE #Payroll SET PayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTValue ELSE @RelatedToPTValue END, ActualPayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTActualValue ELSE @RelatedToPTActualValue END
		WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1

		UPDATE #Payroll SET LastPeriodPayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTValue ELSE @RelatedToPTValue END, ActualLastPeriodPayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTActualValue ELSE @RelatedToPTActualValue END
		WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1

		UPDATE #Payroll SET PayrollComponentAmount = ISNULL(PRE.PayrollComponentAmount,0) + ISNULL(PREINNER.PayrollComponentAmount,0), 
		                    ActualPayrollComponentAmount = ISNULL(PRE.ActualPayrollComponentAmount,0) + ISNULL(PREINNER.ActualPayrollComponentAmount,0)
		FROM #Payroll PRE
		     LEFT JOIN (SELECT PEC.EmployeeId, SUM(ComponentAmount) PayrollComponentAmount, SUM(ActualComponentAmount) ActualPayrollComponentAmount
			            FROM PayrollRunEmployeeComponent PEC 
						     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
							 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
							 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                 FROM PayrollRunEmployee PRE 
						                	   INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						                	   --INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						                	   --INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
										WHERE PR.InactiveDateTime IS NULL
						                GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                         AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
							INNER JOIN EmployeeResignation ER ON ER.EmployeeId = PEC.EmployeeId AND ER.InactiveDateTime IS NULL 
							           AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(month, DATEDIFF(month, 0, ER.ResignationDate), 0) AND ISNULL(EOMONTH(DATEADD(MONTH,-1,(DATEADD(month, DATEDIFF(month, 0, ER.LastDate), 0)))),EOMONTH(PR.PayrollEndDate))
							INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PRE.PayrollTemplateId AND PTC.PayrollComponentId = PEC.ComponentId
						WHERE PTC.IsRelatedToPT = 1 --PEC.ComponentName = 'Prof Tax'
						GROUP BY PEC.EmployeeId) PREINNER  ON PREINNER.EmployeeId = PRE.EmployeeId
		WHERE PRE.EmployeeId = @EmployeeId AND PRE.IsRelatedToPt = 1 --PRE.PayrollComponentName = 'Prof Tax'

		UPDATE #Payroll SET Earning = ROUND((CASE WHEN IsDeduction = 0 THEN PayrollComponentAmount END),0), Deduction = ROUND((CASE WHEN IsDeduction = 1 THEN PayrollComponentAmount END),0),
		                    ActualEarning = ROUND((CASE WHEN IsDeduction = 0 THEN ActualPayrollComponentAmount END),0), ActualDeduction = ROUND((CASE WHEN IsDeduction = 1 THEN ActualPayrollComponentAmount END),0)
		WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1
		--IsRelatedToPt calculation End
		
		----Tax calculation Start
		SELECT @TaxAmount = NULL

		IF(@TaxPeriodType = 'Every month')
		BEGIN
			
			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
			
			SELECT @TaxPaidCount = COUNT(DISTINCT MONTH(PR.PayrollStartDate))
			FROM PayrollRunEmployeeComponent PEC 
			     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRE.PayrollRunId AND PRE.EmployeeId = PRE.EmployeeId
				 INNER JOIN (SELECT TOP 1 PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
						          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						          INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
							 WHERE PR.PayrollStartDate BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
							       AND PR.PayrollEndDate < @RunStartdate AND EmployeeId = @EmployeeId
							 GROUP BY PR.PayrollStartDate, PR.PayrollEndDate
							 ORDER BY PR.PayrollStartDate DESC) PREInner ON PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate AND PREInner.CreatedDateTime = PRE.CreatedDateTime
			WHERE PEC.ComponentName = @TaxName

			SELECT @TaxPayableCount = CASE WHEN @JoinedMonths > 12 THEN (12 - @TaxPaidCount) ELSE (@JoinedMonths - @TaxPaidCount) END

			SELECT @TaxAmount = CASE WHEN @TaxPayableCount < 0 THEN 0
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@TaxPayableCount * 1.0),0),0) END

		END
		ELSE IF(@TaxPeriodType = 'Every quarter' AND ABS((@TaxFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0)
		BEGIN
			
			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
			
			SELECT @TaxPaidCount = COUNT(DISTINCT DATEPART(QUARTER,PR.PayrollStartDate))
			FROM PayrollRunEmployeeComponent PEC 
			     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRE.PayrollRunId AND PRE.EmployeeId = PRE.EmployeeId
				 INNER JOIN (SELECT TOP 1 PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
						          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						          INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
							 WHERE PR.PayrollStartDate BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
							       AND PR.PayrollEndDate < @RunStartdate AND EmployeeId = @EmployeeId
							 GROUP BY PR.PayrollStartDate, PR.PayrollEndDate
							 ORDER BY PR.PayrollStartDate DESC) PREInner ON PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate AND PREInner.CreatedDateTime = PRE.CreatedDateTime
			WHERE PEC.ComponentName = @TaxName

			SELECT @TaxPayableCount = CASE WHEN @JoinedQuarters > 4 THEN (4 - @TaxPaidCount) ELSE (@JoinedQuarters - @TaxPaidCount) END

			SELECT @TaxAmount = CASE WHEN @TaxPayableCount < 0 THEN 0
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@TaxPayableCount * 1.0),0),0) END

		END
		ELSE IF(@TaxPeriodType = 'Every halfyearly' AND ABS((@TaxFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0)
		BEGIN
			
			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
			
			SELECT @TaxPaidCount = COUNT(DISTINCT MONTH(PR.PayrollStartDate))
			FROM PayrollRunEmployeeComponent PEC 
			     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRE.PayrollRunId AND PRE.EmployeeId = PRE.EmployeeId
				 INNER JOIN (SELECT TOP 1 PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
						          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						          INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
							 WHERE PR.PayrollStartDate BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
							       AND PR.PayrollEndDate < @RunStartdate AND EmployeeId = @EmployeeId
							 GROUP BY PR.PayrollStartDate, PR.PayrollEndDate
							 ORDER BY PR.PayrollStartDate DESC) PREInner ON PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate AND PREInner.CreatedDateTime = PRE.CreatedDateTime
			WHERE PEC.ComponentName = @TaxName

			SELECT @TaxPayableCount = CASE WHEN @JoinedMonths/6 > 0 THEN (2 - @TaxPaidCount) ELSE (1 - @TaxPaidCount) END

			SELECT @TaxAmount = CASE WHEN @TaxPayableCount < 0 THEN 0
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@TaxPayableCount * 1.0),0),0) END

		END
		ELSE IF(@TaxPeriodType = 'Yearly' AND ABS((@TaxFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
		BEGIN
			
			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
			
			SELECT @TaxPaidCount = COUNT(DISTINCT YEAR(PR.PayrollStartDate))
			FROM PayrollRunEmployeeComponent PEC 
			     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRE.PayrollRunId AND PRE.EmployeeId = PRE.EmployeeId
				 INNER JOIN (SELECT TOP 1 PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
						          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						          INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
							 WHERE PR.PayrollStartDate BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
							       AND PR.PayrollEndDate < @RunStartdate AND EmployeeId = @EmployeeId
							 GROUP BY PR.PayrollStartDate, PR.PayrollEndDate
							 ORDER BY PR.PayrollStartDate DESC) PREInner ON PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate AND PREInner.CreatedDateTime = PRE.CreatedDateTime
			WHERE PEC.ComponentName = @TaxName

			SELECT @TaxPayableCount = (1 - @TaxPaidCount)

			SELECT @TaxAmount = CASE WHEN @TaxPayableCount < 0 THEN 0
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@TaxPayableCount * 1.0),0),0) END

		END
		ELSE IF(@TaxPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @TaxFinancialYearFromMonth) % 12) / 3 ) + 1) = 4)
		BEGIN

			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL

			SELECT @TaxPaidCount = COUNT(DISTINCT MONTH(PR.PayrollStartDate))
			FROM PayrollRunEmployeeComponent PEC 
			     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRE.PayrollRunId AND PRE.EmployeeId = PRE.EmployeeId
				 INNER JOIN (SELECT TOP 1 PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
						          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						          INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
						          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
							 WHERE PR.PayrollStartDate BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
							       AND PR.PayrollEndDate < @RunStartdate AND EmployeeId = @EmployeeId
							 GROUP BY PR.PayrollStartDate, PR.PayrollEndDate
							 ORDER BY PR.PayrollStartDate DESC) PREInner ON PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate AND PREInner.CreatedDateTime = PRE.CreatedDateTime
			WHERE PEC.ComponentName = @TaxName

			SELECT @TaxPayableCount = CASE WHEN @JoinedMonths > 3 THEN (3 - @TaxPaidCount) ELSE (@JoinedMonths - @TaxPaidCount) END

			SELECT @TaxAmount = CASE WHEN @TaxPayableCount < 0 THEN 0
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@TaxPayableCount * 1.0),0),0) END

		END

		DECLARE @PaidTax FLOAT = (SELECT SUM(ComponentAmount)
								   FROM PayrollRunEmployeeComponent PEC 
								        INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
										INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
								   	    INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
												    FROM PayrollRunEmployee PRE 
												   	   INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
												   	   --INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
												   	   --INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
												   WHERE PR.InactiveDateTime IS NULL
												   GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                                    AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								   	                        AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN @TaxFinancialYearFromDate AND @TaxFinancialYearToDate
										INNER JOIN EmployeeResignation ER ON ER.EmployeeId = PEC.EmployeeId AND ER.InactiveDateTime IS NULL 
							                       AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(month, DATEDIFF(month, 0, ER.ResignationDate), 0) AND ISNULL(EOMONTH(DATEADD(MONTH,-1,(DATEADD(month, DATEDIFF(month, 0, ER.LastDate), 0)))),EOMONTH(PR.PayrollEndDate))
								   WHERE PEC.ComponentName = 'Tax' AND PEC.EmployeeId = @EmployeeId)
	
		SELECT @TaxAmount = ISNULL(@TaxAmount,0) - ISNULL(@PaidTax,0)
		
		IF(@TaxAmount > 0)
		BEGIN

			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
			             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		----Tax calculation End

		----Loan calculation Start	
		SELECT @LoanAmount = SUM(InstallmentAmount)
		FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
		WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
		      AND ELI.InstalmentDate >= @EmployeeResignationStartDate
			  AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL

		IF(@LoanAmount > 0 AND @LoanAmount IS NOT NULL)
		BEGIN

			SELECT @LoanId = Id, @LoanName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Office Loan EMI' AND InActiveDateTime IS NULL

			UPDATE EmployeeLoanInstallment SET IsTobePaid = NULL
			FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
			WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
			      AND ELI.InstalmentDate >= @EmployeeResignationStartDate
				  AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL
			
			UPDATE EmployeeLoan SET LoanBalanceAmount = ELInner.LoanBalanceAmount
			FROM EmployeeLoan EL 
			     INNER JOIN (SELECT EmployeeLoanId, SUM(InstallmentAmount) LoanBalanceAmount
							 FROM EmployeeLoanInstallment
							 WHERE EmployeeLoanId IN (SELECT EL.Id
							 						  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
							 						  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
							 						        AND ELI.InstalmentDate >= @EmployeeResignationStartDate
															AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
							       AND IsTobePaid = 1 AND IsArchived = 0
							GROUP BY EmployeeLoanId) ELInner ON ELInner.EmployeeLoanId = EL.Id

			UPDATE EmployeeLoan SET LoanTotalPaidAmount = ELInner.LoanTotalPaidAmount
			FROM EmployeeLoan EL 
			     INNER JOIN (SELECT EmployeeLoanId, SUM(InstallmentAmount) LoanTotalPaidAmount
							 FROM EmployeeLoanInstallment
							 WHERE EmployeeLoanId IN (SELECT EL.Id
							 						  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
							 						  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
							 						        AND ELI.InstalmentDate >= @EmployeeResignationStartDate
															AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
							       AND IsTobePaid IS NULL AND IsArchived = 0
							GROUP BY EmployeeLoanId) ELInner ON ELInner.EmployeeLoanId = EL.Id

			DECLARE @LoanBalanceAmount FLOAT = (SELECT SUM(InstallmentAmount)
												FROM EmployeeLoanInstallment ELI INNER JOIN EmployeeLoan EL ON EL.Id = ELI.EmployeeLoanId
												WHERE EmployeeLoanId IN (SELECT EL.Id
																		  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
																		  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
																		        AND ELI.InstalmentDate >= @EmployeeResignationStartDate
																			AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
												      AND IsTobePaid = 1 AND IsArchived = 0
												      AND EL.EmployeeId = @EmployeeId)

		     DECLARE @LoanTotalPaidAmount FLOAT = (SELECT SUM(InstallmentAmount) LoanTotalPaidAmount
												   FROM EmployeeLoanInstallment ELI INNER JOIN EmployeeLoan EL ON EL.Id = ELI.EmployeeLoanId
												   WHERE EmployeeLoanId IN (SELECT EL.Id
												   						  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
												   						  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
												   						        AND ELI.InstalmentDate >= @EmployeeResignationStartDate
												   							AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
												         AND IsTobePaid IS NULL AND IsArchived = 0
												         AND EL.EmployeeId = @EmployeeId)

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LoanId,@LoanName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@LoanAmount,-@LoanAmount,NULL,-@LoanAmount,NULL,-@LoanAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
			             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,@LoanTotalPaidAmount,@LoanBalanceAmount
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		----Loan calculation End

		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	SET @EmployeesCounter = 1

	SELECT * FROM #Payroll 
	ORDER BY EmployeeName,IsDeduction

END
GO

--EXEC [USP_ProduceFinalPayrollComponentsForResignedEmployees] '1558A8BC-D112-4FA6-AF52-BD72BBE90F5B',NULL,NULL,'2020-06-01','2020-06-30',NULL,NULL,'[{"EmployeeNumber":"res1","EmployeeName":"Peter","LossOfPay":2,"EncashedLeaves":0},{"EmployeeNumber":"loan rwes 2","EmployeeName":"Test","LossOfPay":0,"EncashedLeaves":2}]'

