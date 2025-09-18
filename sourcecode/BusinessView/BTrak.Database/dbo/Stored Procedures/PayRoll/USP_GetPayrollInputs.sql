CREATE PROCEDURE [dbo].[USP_GetPayrollInputs]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@SelectedMonth DATETIME
	,@SelectedEmployee UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN

				IF(@SelectedEmployee = '00000000-0000-0000-0000-000000000000') SET @SelectedEmployee = NULL

				IF(@SelectedMonth IS NULL) SET @SelectedMonth = GETDATE()

				IF(@SelectedEmployee IS NULL) SET @SelectedEmployee = @OperationsPerformedBy

				DECLARE @RunStartDate DATE = DATEADD(DAY,1,EOMONTH(@SelectedMonth,-1))
				DECLARE @RunEndDate DATE = EOMONTH(@SelectedMonth)
				
				DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Employee WHERE Id = @SelectedEmployee)

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @EmployeeIds NVARCHAR(MAX) = CONVERT(NVARCHAR(100),@SelectedEmployee)

				DECLARE @EmployeeBranchId UNIQUEIDENTIFIER,@TaxYear INT,@Year INT = DATEPART(YEAR,@RunEndDate),@PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate)
				,@TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT, @TaxFinancialFromYear INT, @TaxFinancialToYear INT
				, @TaxFinancialYearFromDate DATE, @TaxFinancialYearToDate DATE,@JoinedMonths INT,@JoiningDate DATE

				SELECT @EmployeeBranchId = BranchId
				FROM EmployeeBranch EB
				WHERE EB.EmployeeId = @SelectedEmployee
				      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
					          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
							  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
						  ) 

				CREATE TABLE #PayrollForNonResignationEmployee  
				(
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(800),
					PayrollTemplateId UNIQUEIDENTIFIER,
					PayrollComponentId UNIQUEIDENTIFIER,
					PayrollComponentName NVARCHAR(800),
					IsDeduction BIT,
					EmployeeSalary FLOAT,
					ActualEmployeeSalary FLOAT,
					OneDaySalary FLOAT,
					IsRelatedToPT BIT,
					PayrollComponentAmount FLOAT,
					ActualPayrollComponentAmount FLOAT,
					Earning FLOAT, 
					Deduction FLOAT,
					ActualEarning FLOAT, 
					ActualDeduction FLOAT,
					TotalDaysInPayroll INT,
					TotalWorkingDays INT,
					LeavesTaken FLOAT,
					UnplannedHolidays FLOAT,
					SickDays FLOAT,
					WorkedDays FLOAT,
					PlannedHolidays FLOAT,
					LossOfPay FLOAT,
					IsInResignation BIT,
					TotalLeaves FLOAT,
					PaidLeaves FLOAT,
					UnPaidLeaves FLOAT,
					AllowedLeaves FLOAT,
					IsLossOfPayMonth BIT,
					EmployeeConfigAndSalaryId INT,
					LastPeriodPayrollComponentAmount FLOAT,
					LastPeriodSalary FLOAT,
					LastPeriodLossOfPay FLOAT,
					ActualLastPeriodPayrollComponentAmount FLOAT,
					ActualLastPeriodSalary FLOAT,
					EncashedLeaves FLOAT,
					TotalAmountPaid FLOAT,
					LoanAmountRemaining FLOAT
				)

				INSERT INTO #PayrollForNonResignationEmployee 

				EXEC USP_ProducePayrollComponents @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,NULL,@EmployeeIds,NULL

				CREATE TABLE #PayrollForMiddleHikeEmployee  
				(
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(800),
					PayrollTemplateId UNIQUEIDENTIFIER,
					PayrollComponentId UNIQUEIDENTIFIER,
					PayrollComponentName NVARCHAR(800),
					IsDeduction BIT,
					EmployeeSalary FLOAT,
					ActualEmployeeSalary FLOAT,
					OneDaySalary FLOAT,
					IsRelatedToPT BIT,
					PayrollComponentAmount FLOAT,
					ActualPayrollComponentAmount FLOAT,
					Earning FLOAT, 
					Deduction FLOAT,
					ActualEarning FLOAT, 
					ActualDeduction FLOAT,
					TotalDaysInPayroll INT,
					TotalWorkingDays INT,
					LeavesTaken FLOAT,
					UnplannedHolidays FLOAT,
					SickDays FLOAT,
					WorkedDays FLOAT,
					PlannedHolidays FLOAT,
					LossOfPay FLOAT,
					IsInResignation BIT,
					TotalLeaves FLOAT,
					PaidLeaves FLOAT,
					UnPaidLeaves FLOAT,
					AllowedLeaves FLOAT,
					IsLossOfPayMonth BIT,
					EmployeeConfigAndSalaryId INT,
					LastPeriodPayrollComponentAmount FLOAT,
					LastPeriodSalary FLOAT,
					LastPeriodLossOfPay FLOAT,
					ActualLastPeriodPayrollComponentAmount FLOAT,
					ActualLastPeriodSalary FLOAT,
					EncashedLeaves FLOAT,
					TotalAmountPaid FLOAT,
					LoanAmountRemaining FLOAT
				)

				INSERT INTO #PayrollForMiddleHikeEmployee 

				EXEC [USP_ProducePayrollComponentsForMiddleHikeEmployees] @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,NULL,@EmployeeIds,NULL

				CREATE TABLE #PayrollForResignationEmployee 
				(
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(800),
					PayrollTemplateId UNIQUEIDENTIFIER,
					PayrollComponentId UNIQUEIDENTIFIER,
					PayrollComponentName NVARCHAR(800),
					IsDeduction BIT,
					EmployeeSalary FLOAT,
					ActualEmployeeSalary FLOAT,
					OneDaySalary FLOAT,
					IsRelatedToPT BIT,
					PayrollComponentAmount FLOAT,
					ActualPayrollComponentAmount FLOAT,
					Earning FLOAT, 
					Deduction FLOAT,
					ActualEarning FLOAT, 
					ActualDeduction FLOAT,
					TotalDaysInPayroll INT,
					TotalWorkingDays INT,
					LeavesTaken FLOAT,
					UnplannedHolidays FLOAT,
					SickDays FLOAT,
					WorkedDays FLOAT,
					PlannedHolidays FLOAT,
					LossOfPay FLOAT,
					IsInResignation BIT,
					TotalLeaves FLOAT,
					PaidLeaves FLOAT,
					UnPaidLeaves FLOAT,
					AllowedLeaves FLOAT,
					IsLossOfPayMonth BIT,
					EmployeeConfigAndSalaryId INT,
					LastPeriodPayrollComponentAmount FLOAT,
					LastPeriodSalary FLOAT,
					LastPeriodLossOfPay FLOAT,
					ActualLastPeriodPayrollComponentAmount FLOAT,
					ActualLastPeriodSalary FLOAT,
					EncashedLeaves FLOAT,
					TotalAmountPaid FLOAT,
					LoanAmountRemaining FLOAT
				)

				INSERT INTO #PayrollForResignationEmployee

				EXEC USP_ProducePayrollComponentsForResignedEmployees @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,NULL,@EmployeeIds,NULL

				CREATE TABLE #PayrollForHourlyRateEmployee
				(
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(800),
					PayrollTemplateId UNIQUEIDENTIFIER,
					PayrollComponentId UNIQUEIDENTIFIER,
					PayrollComponentName NVARCHAR(800),
					IsDeduction BIT,
					EmployeeSalary FLOAT,
					ActualEmployeeSalary FLOAT,
					OneDaySalary FLOAT,
					IsRelatedToPT BIT,
					PayrollComponentAmount FLOAT,
					ActualPayrollComponentAmount FLOAT,
					Earning FLOAT, 
					Deduction FLOAT,
					ActualEarning FLOAT, 
					ActualDeduction FLOAT,
					TotalDaysInPayroll INT,
					TotalWorkingDays INT,
					LeavesTaken FLOAT,
					UnplannedHolidays FLOAT,
					SickDays FLOAT,
					WorkedDays FLOAT,
					PlannedHolidays FLOAT,
					LossOfPay FLOAT,
					IsInResignation BIT,
					TotalLeaves FLOAT,
					PaidLeaves FLOAT,
					UnPaidLeaves FLOAT,
					AllowedLeaves FLOAT,
					IsLossOfPayMonth BIT,
					EmployeeConfigAndSalaryId INT,
					LastPeriodPayrollComponentAmount FLOAT,
					LastPeriodSalary FLOAT,
					LastPeriodLossOfPay FLOAT,
					ActualLastPeriodPayrollComponentAmount FLOAT,
					ActualLastPeriodSalary FLOAT,
					EncashedLeaves FLOAT,
					TotalAmountPaid FLOAT,
					LoanAmountRemaining FLOAT
				)

				INSERT INTO #PayrollForHourlyRateEmployee

				EXEC [USP_ProducePayrollComponentsForHourlyRateEmployees] @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,NULL,@EmployeeIds,NULL

				CREATE TABLE #Payroll 
				(
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(800),
					PayrollTemplateId UNIQUEIDENTIFIER,
					PayrollComponentId UNIQUEIDENTIFIER,
					PayrollComponentName NVARCHAR(800),
					IsDeduction BIT,
					EmployeeSalary FLOAT,
					ActualEmployeeSalary FLOAT,
					OneDaySalary FLOAT,
					IsRelatedToPT BIT,
					PayrollComponentAmount FLOAT,
					ActualPayrollComponentAmount FLOAT,
					Earning FLOAT, 
					Deduction FLOAT,
					ActualEarning FLOAT, 
					ActualDeduction FLOAT,
					TotalDaysInPayroll INT,
					TotalWorkingDays INT,
					LeavesTaken FLOAT,
					UnplannedHolidays FLOAT,
					SickDays FLOAT,
					WorkedDays FLOAT,
					PlannedHolidays FLOAT,
					LossOfPay FLOAT,
					IsInResignation BIT,
					TotalLeaves FLOAT,
					PaidLeaves FLOAT,
					UnPaidLeaves FLOAT,
					AllowedLeaves FLOAT,
					IsLossOfPayMonth BIT,
					EmployeeConfigAndSalaryId INT,
					LastPeriodPayrollComponentAmount FLOAT,
					LastPeriodSalary FLOAT,
					LastPeriodLossOfPay FLOAT,
					ActualLastPeriodPayrollComponentAmount FLOAT,
					ActualLastPeriodSalary FLOAT,
					EncashedLeaves FLOAT,
					TotalAmountPaid FLOAT,
					LoanAmountRemaining FLOAT
				)

				INSERT INTO #Payroll
				SELECT *
				FROM #PayrollForNonResignationEmployee
				WHERE EmployeeId NOT IN (SELECT EmployeeId FROM #PayrollForResignationEmployee GROUP BY EmployeeId)
				      AND EmployeeId NOT IN (SELECT EmployeeId FROM #PayrollForMiddleHikeEmployee GROUP BY EmployeeId)
					  AND EmployeeId NOT IN (SELECT EmployeeId FROM #PayrollForHourlyRateEmployee GROUP BY EmployeeId)

				---- Prof Tax calculation for Middle Hike Employees Start
				UPDATE #PayrollForMiddleHikeEmployee SET PayrollComponentAmount = NULL, ActualPayrollComponentAmount = NULL,Deduction = NULL, ActualDeduction = NULL WHERE IsRelatedToPT = 1 --PayrollComponentName = 'Prof Tax'

				UPDATE #PayrollForMiddleHikeEmployee SET PayrollComponentAmount = ProfTax, ActualPayrollComponentAmount = ActualProfTax,Deduction = ProfTax, ActualDeduction = ActualProfTax
				FROM #PayrollForMiddleHikeEmployee PMH
					INNER JOIN (SELECT T.EmployeeId,
									   TInner.EmployeeConfigAndSalaryId,
									   -(SELECT TOP 1 TaxAmount FROM ProfessionalTaxRange 
										 WHERE ((ToRange IS NOT NULL AND Earning BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND Earning >= FromRange)) AND IsArchived = 0 AND BranchId = T.BranchId
												  AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
													   OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
														  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
													)
										  ) ProfTax,
									   -(SELECT TOP 1 TaxAmount FROM ProfessionalTaxRange 
										 WHERE ((ToRange IS NOT NULL AND ActualEarning BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND ActualEarning >= FromRange)) AND IsArchived = 0 AND BranchId = T.BranchId
												  AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
														   OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
															  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
														)
										  ) ActualProfTax
								FROM (
								SELECT P.EmployeeId, EB.BranchId, SUM(Earning) Earning, SUM(ActualEarning) ActualEarning
								FROM #PayrollForMiddleHikeEmployee P 
									 INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = P.EmployeeId --AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
												AND ((EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
													  OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
													  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
													)
								WHERE PC.EmployerContributionPercentage IS NULL
								GROUP BY P.EmployeeId,EB.BranchId
								) T
								  INNER JOIN (SELECT EmployeeId, MAX(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM #PayrollForMiddleHikeEmployee GROUP BY EmployeeId) TInner ON TInner.EmployeeId = T.EmployeeId
							   ) PInner ON PInner.EmployeeId = PMH.EmployeeId AND PInner.EmployeeConfigAndSalaryId = PMH.EmployeeConfigAndSalaryId
				WHERE IsRelatedToPT = 1 --PayrollComponentName = 'Prof Tax'

				---- Prof Tax calculation for Middle Hike Employees End

				SELECT P.EmployeeId,
					   P.PayrollTemplateId
				INTO #MiddleHikeEmployeeLatestTemplate 
				FROM #PayrollForMiddleHikeEmployee P
					 INNER JOIN (SELECT EmployeeId, MAX(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM #PayrollForMiddleHikeEmployee GROUP BY EmployeeId) PInner ON P.EmployeeId = PInner.EmployeeId AND P.EmployeeConfigAndSalaryId = PInner.EmployeeConfigAndSalaryId
				GROUP BY  P.EmployeeId,P.PayrollTemplateId 

				INSERT INTO #Payroll
				SELECT P.EmployeeId,
					   P.EmployeeName,
					   MET.PayrollTemplateId,
					   P.PayrollComponentId,
					   P.PayrollComponentName,
					   P.IsDeduction,
					   PME.EmployeeSalary,
					   PME.ActualEmployeeSalary,
					   PME.OneDaySalary,
					   P.IsRelatedToPT,
					   SUM(P.PayrollComponentAmount) PayrollComponentAmount,
					   SUM(P.ActualPayrollComponentAmount) ActualPayrollComponentAmount,
					   SUM(P.Earning) Earning,
					   SUM(P.Deduction) Deduction,
					   SUM(P.ActualEarning) ActualEarning,
					   SUM(P.ActualDeduction) ActualDeduction,
					   P.TotalDaysInPayroll,
					   P.TotalWorkingDays,
					   PME.LeavesTaken,
					   PME.UnplannedHolidays,
					   PME.SickDays,
					   PME.WorkedDays,
					   PME.PlannedHolidays,
					   PME.LossOfPay,
					   P.IsInResignation,
					   P.TotalLeaves,
					   PME.PaidLeaves,
					   PME.UnPaidLeaves,
					   PME.AllowedLeaves,
					   P.IsLossOfPayMonth,
					   NULL EmployeeConfigAndSalaryId,
					   NULL LastPeriodPayrollComponentAmount,
					   NULL LastPeriodSalary,
					   NULL LastPeriodLossOfPay,
					   NULL ActualLastPeriodPayrollComponentAmount,
					   NULL ActualLastPeriodSalary,
					   PME.EncashedLeaves,
					   PME.TotalAmountPaid,
					   PME.LoanAmountRemaining
				FROM #PayrollForMiddleHikeEmployee P
					  INNER JOIN ( SELECT EmployeeId,SUM(EmployeeSalary) EmployeeSalary, SUM(ActualEmployeeSalary) ActualEmployeeSalary, SUM(OneDaySalary) OneDaySalary, SUM(WorkedDays) WorkedDays, SUM(LeavesTaken) LeavesTaken, SUM(UnplannedHolidays) UnplannedHolidays, SUM(SickDays) SickDays, 
								  SUM(PlannedHolidays) PlannedHolidays, SUM(AllowedLeaves) AllowedLeaves, SUM(PaidLeaves) PaidLeaves, SUM(UnPaidLeaves) UnPaidLeaves, SUM(LossOfPay) LossOfPay, SUM(EncashedLeaves) EncashedLeaves, SUM(TotalAmountPaid) TotalAmountPaid, SUM(LoanAmountRemaining) LoanAmountRemaining
								  FROM (SELECT DISTINCT EmployeeConfigAndSalaryId, EmployeeId,EmployeeSalary, ActualEmployeeSalary, OneDaySalary, WorkedDays, LeavesTaken, UnplannedHolidays, SickDays, PlannedHolidays, AllowedLeaves, PaidLeaves, UnPaidLeaves, LossOfPay , EncashedLeaves, TotalAmountPaid,LoanAmountRemaining
										FROM #PayrollForMiddleHikeEmployee) T
								  GROUP BY EmployeeId) PME ON PME.EmployeeId = P.EmployeeId
					 INNER JOIN #MiddleHikeEmployeeLatestTemplate MET ON MET.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId NOT IN (SELECT EmployeeId FROM #PayrollForResignationEmployee GROUP BY EmployeeId)
				GROUP BY P.EmployeeId,P.EmployeeName,P.IsLossOfPayMonth,MET.PayrollTemplateId,P.PayrollComponentId,P.PayrollComponentName,P.IsDeduction,PME.EmployeeSalary,PME.ActualEmployeeSalary,PME.OneDaySalary,P.IsRelatedToPT,P.TotalDaysInPayroll,P.TotalWorkingDays,PME.LeavesTaken,PME.UnplannedHolidays,
						 PME.SickDays,PME.WorkedDays,PME.PlannedHolidays,PME.LossOfPay,P.IsInResignation,P.TotalLeaves,PME.PaidLeaves,PME.UnPaidLeaves,PME.AllowedLeaves,PME.EncashedLeaves,
						 PME.TotalAmountPaid,PME.LoanAmountRemaining
				
				INSERT INTO #Payroll
				SELECT *
				FROM #PayrollForResignationEmployee

				INSERT INTO #Payroll
				SELECT *
				FROM #PayrollForHourlyRateEmployee
				
				----Net amount calculation Start
				SELECT ROW_NUMBER() OVER(ORDER BY EmployeeName) Id,
					   P.EmployeeId,
					   P.EmployeeName,
					   P.PayrollTemplateId,
					   P.EmployeeSalary,
					   P.OneDaySalary,
					   ROUND(SUM(P.PayrollComponentAmount),0) NetAmount, --ROUND(P.EmployeeSalary + SUM(Deduction),0) NetAmount,
					   ROUND(SUM(Earning),0) TotalEarningsToDate,
					   ROUND(SUM(Deduction),0) TotalDeductionsToDate,
					   P.ActualEmployeeSalary,
					   ROUND(SUM(P.ActualPayrollComponentAmount),0) ActualNetAmount,
					   ROUND(SUM(ActualEarning),0) ActualTotalEarningsToDate,
					   ROUND(SUM(ActualDeduction),0) ActualTotalDeductionsToDate,
					   DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
					   P.TotalWorkingDays,
					   P.LeavesTaken,
					   P.UnplannedHolidays,
					   P.SickDays,
					   P.WorkedDays,
					   P.PlannedHolidays,
					   P.TotalLeaves,
					   P.AllowedLeaves,
					   P.PaidLeaves,
					   P.UnPaidLeaves,
					   P.LossOfPay,
					   P.IsLossOfPayMonth,
					   P.EncashedLeaves,
					   SUM(P.TotalAmountPaid) TotalAmountPaid,
					   SUM(P.LoanAmountRemaining) LoanAmountRemaining,
					   P.IsInResignation,
					   (SELECT BD.IFSCCode, BD.AccountNumber, BD.AccountName, BD.BuildingSocietyRollNumber, BD.BankName, BD.BranchName
						FROM BankDetail BD
						WHERE BD.EmployeeId = P.EmployeeId AND BD.InActiveDateTime IS NULL
							  AND ( (BD.EffectiveTo IS NOT NULL AND @RunStartDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo AND @RunEndDate BETWEEN BD.EffectiveFrom AND BD.EffectiveTo)
									 OR (BD.EffectiveTo IS NULL AND @RunEndDate >= BD.EffectiveFrom)
								   )
						FOR JSON PATH) BankAccountDetailsJson,
						(SELECT C.CountryName, S.StateName, ECD.Address1, ECD.Address2, ECD.PostalCode, ECD.Mobile
						FROM EmployeeContactDetails ECD
							 LEFT JOIN [State] S ON S.Id = ECD.StateId
							 LEFT JOIN Country C ON C.Id = ECD.CountryId
						WHERE ECD.EmployeeId = P.EmployeeId AND ECD.InActiveDateTime IS NULL
						FOR JSON PATH) [Address]

				INTO #PayrollEmployee
				FROM #Payroll P 
				GROUP BY P.EmployeeId,P.EmployeeName,P.PayrollTemplateId,P.EmployeeSalary,P.OneDaySalary,P.ActualEmployeeSalary,P.TotalWorkingDays,P.LeavesTaken,P.UnplannedHolidays,P.SickDays,P.WorkedDays,P.plannedHolidays,P.TotalLeaves,P.AllowedLeaves,P.PaidLeaves,
						 P.UnPaidLeaves,P.LossOfPay,P.IsInResignation,P.IsLossOfPayMonth,P.EncashedLeaves
				----Net amount calculation End

				UPDATE #PayrollEmployee SET NetAmount = NetAmount - ISNULL(PayrollComponentAmount,0), TotalEarningsToDate = TotalEarningsToDate - ISNULL(PayrollComponentAmount,0), 
										ActualNetAmount = ActualNetAmount - ISNULL(ActualPayrollComponentAmount,0), ActualTotalEarningsToDate = ActualTotalEarningsToDate - ISNULL(ActualPayrollComponentAmount,0)
				FROM #PayrollEmployee PE
					 LEFT JOIN (SELECT EmployeeId, SUM(PayrollComponentAmount) PayrollComponentAmount, SUM(ActualPayrollComponentAmount) ActualPayrollComponentAmount
								FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
								WHERE PC.EmployerContributionPercentage IS NOT NULL AND P.IsDeduction = 0
								GROUP BY EmployeeId) PEInner ON PEInner.EmployeeId = PE.EmployeeId
				
				SELECT * 
					   ,TotalEarnings - ABS(TotalDeductions) AS NetAmount
					   INTO #FullAmounts
				FROM (
					SELECT * 
						   ,SUM(CASE WHEN IsDeduction = 1 THEN ComponentAmount ELSE 0 END) OVER() AS TotalDeductions
						   ,SUM(CASE WHEN IsDeduction = 0 THEN ComponentAmount ELSE 0 END) OVER() AS TotalEarnings
					FROM (
						SELECT PRE.EmployeeName
							   ,PREC.ComponentId
							   ,ISNULL(SUM(PREC.ComponentAmount),0) AS ComponentAmount
							   ,PREC.ComponentName
							   ,PREC.EmployeeId
							   ,E.UserId AS UserId 
							   ,PREC.IsDeduction
						FROM PayrollRunEmployee PRE
							 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
							 INNER JOIN [PayrollRunEmployeeComponent] PREC ON PREC.PayrollRunId = PRE.PayrollRunId
							 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
							 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							 INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
										AND PREC.EmployeeId = @SelectedEmployee
										AND PRE.EmployeeId = @SelectedEmployee
										AND PR.InactiveDateTime IS NULL
										AND PS.InActiveDateTime IS NULL
										AND PRS.InactiveDateTime IS NULL
						GROUP BY PRE.EmployeeName,PREC.ComponentId,PREC.ComponentName,PREC.EmployeeId,E.UserId,PREC.IsDeduction --,PREC.ComponentAmount
					) T
				) TT

				--TODO
				SELECT @TaxFinancialYearFromMonth = FromMonth, @TaxFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
				WHERE CountryId = (SELECT CountryId FROM Branch WHERE Id = @EmployeeBranchId)  AND InActiveDateTime IS NULL 
				      AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax')
				      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
					      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
					   )

				SELECT @TaxFinancialFromYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
				SELECT @TaxFinancialToYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

				SELECT @TaxYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
				
				SELECT @TaxFinancialYearFromDate = DATEFROMPARTS(@TaxFinancialFromYear,@TaxFinancialYearFromMonth,1), @TaxFinancialYearToDate = EOMONTH(DATEFROMPARTS(@TaxFinancialToYear,@TaxFinancialYearToMonth,1))
				
				SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @SelectedEmployee

				SELECT @JoinedMonths = DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1
				
				SELECT * 
				INTO #TaxDetails
				FROM [dbo].[Ufn_GetEmployeeTaxDetails](@SelectedEmployee,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate)

				CREATE TABLE #PayrollInputs
				(
					[Id] UNIQUEIDENTIFIER
					,[InputName] NVARCHAR(250)
					,IsPercentage BIT
				    ,IsEditable BIT
					,InputValue DECIMAL(20,2)
				    ,[ParentInputId] UNIQUEIDENTIFIER
				)

				INSERT INTO #PayrollInputs(Id,InputName,ParentInputId,IsEditable,InputValue)
				SELECT Id,InputName,ParentInputId,IsEditable,NULL
				FROM PayrollInput
				UNION ALL
				SELECT PayrollComponentId,PayrollComponentName,NULL,1,ABS(PayrollComponentAmount)
				FROM #Payroll
				WHERE EmployeeId = @SelectedEmployee

				UPDATE #PayrollInputs SET InputValue = PIC.[PayrollInput]
				FROM #PayrollInputs PIS
				     LEFT JOIN PayrollInputConfiguration PIC ON PIC.ReferenceId = PIS.Id
					           AND PIC.EmployeeId = @SelectedEmployee

				UPDATE #PayrollInputs SET InputValue = (SELECT NetAmount FROM #PayrollEmployee WHERE EmployeeId = @SelectedEmployee)
				WHERE Id = N'0D03BC78-0BC3-48D5-9EB5-974527B2D052' --'Net pay'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT Amount/12 FROM EmployeeSalary 
				                                        WHERE EmployeeId = @SelectedEmployee 
														      AND ES.InActiveDateTime IS NOT NULL
															  AND ActiveFrom IS NOT NULL AND ActiveFrom <= @RunEndDate
															  AND (ActiveTo IS NULL OR ActiveTo >= @RunEndDate))
				WHERE Id = N'B83C6344-6F20-4126-9EE0-B51EB24AA695' --'Gross'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = ABS((SELECT SUM(PayrollComponentAmount) 
				                                            FROM #PayrollEmployee 
															WHERE ISNULL(IsDeduction,0) = 1 AND EmployeeId = @SelectedEmployee
														   ))
				WHERE Id = N'60D30E41-B7EE-4482-926E-6AEB5E3FA7EB' --'Total deductions'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT Amount FROM EmployeeSalary 
				                                        WHERE EmployeeId = @SelectedEmployee 
														      AND ES.InActiveDateTime IS NOT NULL
															  AND ActiveFrom IS NOT NULL AND ActiveFrom <= @RunEndDate
															  AND (ActiveTo IS NULL OR ActiveTo >= @RunEndDate))
				WHERE Id = N'05A95429-C3EF-4963-8450-453A2059A1F5' --'Annual CTC'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT Amount FROM EmployeeSalary 
				                                        WHERE EmployeeId = @SelectedEmployee 
														      AND ES.InActiveDateTime IS NOT NULL
															  AND ActiveFrom IS NOT NULL AND ActiveFrom <= @RunEndDate
															  AND (ActiveTo IS NULL OR ActiveTo >= @RunEndDate))
				WHERE Id = N'05A95429-C3EF-4963-8450-453A2059A1F5' --'Annual CTC'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT EmployeeSalary FROM #Payroll 
				                                        WHERE EmployeeId = @SelectedEmployee 
													   )
				WHERE Id = N'7DA368C9-167C-4BE5-AAB1-346E4B2AB0E0' --'Monthly CTC'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(ComponentAmount) FROM #FullAmounts 
				                                        WHERE EmployeeId = @SelectedEmployee
														      AND ComponentName = 'Employee PF'
													   )
				WHERE Id = N'6CE2CD2D-929E-4334-A0FC-9DCF5E036681' --'Full employee PF'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(ComponentAmount) FROM #FullAmounts 
				                                        WHERE EmployeeId = @SelectedEmployee
														      AND ComponentName = 'Employee ESI'
													   )
				WHERE Id = N'361EEBD9-F799-49D3-99E8-AF1F38B0D310' --'Full employee ESI'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT Amount/12 FROM EmployeeSalary 
				                                        WHERE EmployeeId = @SelectedEmployee 
														      AND ES.InActiveDateTime IS NOT NULL
															  AND ActiveFrom IS NOT NULL 
															  AND ActiveFrom <= @RunEndDate
															  AND (ActiveTo IS NULL OR ActiveTo >= @RunEndDate))
				WHERE Id = N'B38054C3-F57E-4544-9919-A6049D3063BC' --'Monthly fixed gross'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT DATEDIFF(YEAR,DateOfBirth,CAST(GETDATE() AS DATE))
				                                        FROM Employee E
														WHERE E.Id = @SelectedEmployee)
				WHERE Id = N'7DE07743-8251-47C2-9071-33CEB675E7D8' --'Age'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(PayrollComponentAmount)
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														      AND P.PayrollComponentName = 'Employer PF'
														)
				WHERE Id = N'E5FA8F43-B6B3-4A2C-BD1A-1CDA816FD4E6' --'Employers PF'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(PayrollComponentAmount)
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														      AND P.PayrollComponentName = 'Employee PF'
														)
				WHERE Id = N'9DC45BFC-F54D-4C37-B8EE-23CC6167E30B' --'PF basic'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(PayrollComponentAmount)
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														      AND P.PayrollComponentName = 'Employer ESI'
														)
				WHERE Id = N'2A7B45E0-5152-41B5-91C0-9DD6DFFB5FAC' --'Employers ESI'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(PayrollComponentAmount)
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														      AND P.PayrollComponentName = 'Employee ESI'
														)
				WHERE Id = N'D44770A6-278A-4499-9CC4-0B82C4ECD34D' --'ESI basic'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT ABS(PayrollComponentAmount)
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														      AND ISNULL(P.IsRelatedToPT,0) = 1
														)
				WHERE Id = N'837331CB-78F9-4DD9-813B-B9603B16E929' --'PROF tax basic'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT EncashedLeaves
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'B5128145-95D1-48B6-A56B-CBEF4946D7F4' --'Encashment days'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT SUM(ECC.Amount) 
														FROM Expense E
														     INNER JOIN (SELECT SUM(Amount) AS Amount,ExpenseId 
														     			 FROM ExpenseCategoryConfiguration 
														     			 WHERE InactiveDateTime IS NULL
														     			 GROUP BY ExpenseId) ECC ON ECC.ExpenseId = E.Id 
															 WHERE InActiveDateTime IS NULL
															       AND ClaimedByUserId = @UserId
																   AND CompanyId = @CompanyId
																   AND PaymentStatusId = (SELECT Id FROM ExpenseStatus WHERE IsApproved = 1 AND IsApproved IS NOT NULL)
														)
				WHERE Id = N'9192B2BD-1199-4185-8EE3-D9C015C6E614' --'MISC reimbursement'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = DATEPART(MONTH,@SelectedMonth)
				WHERE Id = N'B4430F93-FCE3-4123-B779-9988AC4C27AA' --'Payroll month'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = DATEDIFF(MONTH,@RunEndDate,(SELECT EOMONTH(DATEFROMPARTS(CASE WHEN DATEPART(MONTH,@SelectedMonth) - ToMonth > 0 THEN DATEPART(YEAR,@RunEndDate) + 1 ELSE DATEPART(YEAR,@RunEndDate) END
														                                                        ,ToMonth,1))
														                           FROM [FinancialYearConfigurations] 
														                           WHERE CountryId = (SELECT CountryId FROM Branch WHERE Id = @EmployeeBranchId) 
														                                 AND InActiveDateTime IS NULL AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax')
														                                 AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
														                           	      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
														                           		  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
														                           	   ))
																) 
				WHERE Id = N'E2F7D4C6-5767-4344-B12E-E7E8C4A328A3' --'Remaining month'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT SUM(InputValue) 
				                                        FROM #PayrollInputs 
														WHERE Id IN (N'9192B2BD-1199-4185-8EE3-D9C015C6E614'
														             ,N'5B3500C4-3B18-4CAF-8D95-F712FB2EBBFC'
																	 ,N'C5BE9BFF-24F9-46BF-81B8-E8BC8AD0801E'
																	 ,N'73213762-BC4C-4B26-9287-84D54014938E'
																	 ,N'45052A8B-8EAB-4DF5-AFF1-A6115B8BE595'))
				WHERE Id = N'17960281-B88A-472C-A0FB-4BCE25580F47' --'Total reimbursement'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT EncashedLeaves
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'60F2BC52-9504-4CFB-905D-8B774ACD7B0E' --'Leave encashment days'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT WorkedDays
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'24FA59E5-1E46-4130-BA9F-2BCAC20E3681' --'Employee workdays'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT TotalWorkingDays
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'98B95364-62A9-48DF-83B2-324A9CA61E56' --'Emp effective workdays'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT WorkedDays
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'A2D7E49A-C8A3-45F9-B967-1A4E0FC10B83' --'Emp effective workdays for display'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT WorkedDays
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'A2D7E49A-C8A3-45F9-B967-1A4E0FC10B83' --'Emp effective workdays for display'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1
				WHERE Id = N'4D65D6FC-26A9-4651-8C23-260AF0A13A6C' --'Days in month'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT LossOfPay
				                                        FROM #Payroll P
														WHERE P.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'024170B1-AC93-4B2A-95E4-1E70BD6A03E8' --'LOP'
				      AND InputValue IS NULL
				
				INSERT INTO #PayrollInputs(Id,InputName,ParentInputId,IsEditable,InputValue)
				SELECT ComponentId, 'Full ' + ComponentName,N'444C5676-871D-47FF-8927-CE8E6418758D',0,ComponentAmount
				FROM #FullAmounts

				UPDATE #PayrollInputs SET InputValue = (SELECT NetAmount
				                                        FROM #FullAmounts)
				WHERE Id = N'444C5676-871D-47FF-8927-CE8E6418758D' --'Salary master'
				      AND InputValue IS NULL

				--TODO
				UPDATE #PayrollInputs SET InputValue = (SELECT TaxableAmount
				                                        FROM #TaxDetails T
														WHERE T.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'ED9275FE-01B2-471D-A19C-28C1E49EA9BA' --'Taxable amount'
				      AND InputValue IS NULL

				UPDATE #PayrollInputs SET InputValue = (SELECT CASE WHEN @JoinedMonths > 12 
				                                                     THEN ROUND((Tax/12.0),0) 
																ELSE ROUND(Tax/(@JoinedMonths * 1.0),0) END
				                                        FROM #TaxDetails T
														WHERE T.EmployeeId = @SelectedEmployee
														)
				WHERE Id = N'620DF27D-8E04-417C-831D-E1B4A8F1DCC2' --'TDS raw tax'
				      AND InputValue IS NULL

				--Final result
				SELECT * FROM #PayrollInputs
			
			END
			ELSE
				RAISERROR(@HavePermission,11,1);	
			
	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO