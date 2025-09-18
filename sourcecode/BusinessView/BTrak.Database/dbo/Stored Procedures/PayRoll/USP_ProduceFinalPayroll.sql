CREATE PROCEDURE [dbo].[USP_ProduceFinalPayroll]
( 
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER,
	@PayrollTemplateId UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@NewPayrollRunId UNIQUEIDENTIFIER = NULL,
	@EmployeeIds NVARCHAR(MAX) = NULL,
	@EmploymentStatusIds NVARCHAR(MAX) = NULL,
	@EmployeeDetails NVARCHAR(MAX) = NULL,
	@ChequeDate DATE = NULL,
	@AlphaCode NVARCHAR(MAX) = NULL,
	@Cheque NVARCHAR(MAX) = NULL,
	@ChequeNo NVARCHAR(MAX) = NULL
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

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

    EXEC USP_ProduceFinalPayrollComponents @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@EmployeeIds,@EmploymentStatusIds,@EmployeeDetails

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

    EXEC [USP_ProduceFinalPayrollComponentsForMiddleHikeEmployees] @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@EmployeeIds,@EmploymentStatusIds,@EmployeeDetails

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

    EXEC USP_ProduceFinalPayrollComponentsForResignedEmployees @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@EmployeeIds,@EmploymentStatusIds,@EmployeeDetails

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
						 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = P.EmployeeId AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
						            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
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
		   PME.TotalAmountPaid,
		   PME.LoanAmountRemaining,
		   P.IsLossOfPayMonth,
		   NULL EmployeeConfigAndSalaryId,
		   NULL LastPeriodPayrollComponentAmount,
		   NULL LastPeriodSalary,
		   NULL LastPeriodLossOfPay,
		   NULL ActualLastPeriodPayrollComponentAmount,
		   NULL ActualLastPeriodSalary,
		   PME.EncashedLeaves
	FROM #PayrollForMiddleHikeEmployee P
	      INNER JOIN (SELECT EmployeeId,SUM(EmployeeSalary) EmployeeSalary, SUM(ActualEmployeeSalary) ActualEmployeeSalary, SUM(OneDaySalary) OneDaySalary, SUM(WorkedDays) WorkedDays, SUM(LeavesTaken) LeavesTaken, SUM(UnplannedHolidays) UnplannedHolidays, SUM(SickDays) SickDays, 
		              SUM(PlannedHolidays) PlannedHolidays, SUM(AllowedLeaves) AllowedLeaves, SUM(PaidLeaves) PaidLeaves, SUM(UnPaidLeaves) UnPaidLeaves, SUM(LossOfPay) LossOfPay, SUM(EncashedLeaves) EncashedLeaves,
					  SUM(TotalAmountPaid) TotalAmountPaid, SUM(LoanAmountRemaining) LoanAmountRemaining
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

	---- Employee contribution earning are removed from net amounts
	UPDATE #PayrollEmployee SET NetAmount = NetAmount - ISNULL(PayrollComponentAmount,0), TotalEarningsToDate = TotalEarningsToDate - ISNULL(PayrollComponentAmount,0), 
	                            ActualNetAmount = ActualNetAmount - ISNULL(ActualPayrollComponentAmount,0), ActualTotalEarningsToDate = ActualTotalEarningsToDate - ISNULL(ActualPayrollComponentAmount,0)
	FROM #PayrollEmployee PE
	     LEFT JOIN (SELECT EmployeeId, SUM(PayrollComponentAmount) PayrollComponentAmount, SUM(ActualPayrollComponentAmount) ActualPayrollComponentAmount
		            FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
					WHERE PC.EmployerContributionPercentage IS NOT NULL AND P.IsDeduction = 0
					GROUP BY EmployeeId) PEInner ON PEInner.EmployeeId = PE.EmployeeId

	----Saving of payrollrun data Start
	DECLARE @TempEmployeesCount INT, @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @NewPayrollRunEmployeeId UNIQUEIDENTIFIER

	DECLARE @PayrollStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE CompanyId = @CompanyId AND PayrollStatusName = 'Generated' AND IsArchived = 0)

	SELECT @EmployeesCount = COUNT(1) FROM #PayrollEmployee

	IF(@NewPayrollRunId IS NULL) SELECT @NewPayrollRunId = NEWID()
	
	SELECT @TempEmployeesCount = TotalEmployees FROM Temp_PayrollRun WHERE Id = @NewPayrollRunId

	INSERT INTO PayrollRun(Id,CompanyId,BranchId,PayrollTemplateId,RunDate,PayrollStartDate,PayrollEndDate,TotalEmployees,CreatedDateTime,CreatedByUserId,ChequeDate,AlphaCode,Cheque,ChequeNo)
	VALUES(@NewPayrollRunId,@CompanyId,@BranchId,@PayrollTemplateId,GETDATE(),@RunStartDate,@RunEndDate,ISNULL(@TempEmployeesCount,@EmployeesCount),GETDATE(),@OperationsPerformedBy,@ChequeDate,@AlphaCode,@Cheque,@ChequeNo)

	INSERT INTO PayrollRunStatus(Id,PayrollRunId,PayrollStatusId,StatusChangeDateTime,Comments,CreatedDateTime,CreatedByUserId)
	VALUES(NEWID(),@NewPayrollRunId,@PayrollStatusId,GETDATE(),'Generated the payroll',GETDATE(),@OperationsPerformedBy)

	INSERT INTO PayrollRunFilteredEmployee(Id,PayrollRunId,EmployeeId,CreatedDateTime,CreatedByUserId)
	SELECT NEWID(),@NewPayrollRunId,CAST(Id AS UNIQUEIDENTIFIER),GETDATE(),@OperationsPerformedBy
	FROm UfnSplit(@EmployeeIds)

	INSERT INTO PayrollRunFilteredEmploymentStatus(Id,PayrollRunId,EmploymentStatusId,CreatedDateTime,CreatedByUserId)
	SELECT NEWID(),@NewPayrollRunId,CAST(Id AS UNIQUEIDENTIFIER),GETDATE(),@OperationsPerformedBy
	FROm UfnSplit(@EmploymentStatusIds)

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		SELECT @EmployeeId = EmployeeId FROM #PayrollEmployee WHERE Id = @EmployeesCounter
		SELECT @NewPayrollRunEmployeeId = NEWID()

		INSERT INTO PayrollRunEmployee(Id,EmployeeId,PayrollTemplateId,PayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,Earning, Deduction,ActualEarning,ActualDeduction,
		                               PaidAmount,ActualPaidAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualEarningsToDate,TotalDeductionsToDate,ActualDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
		                               TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,EffectiveWorkingDays,SickDays,PayrollStatusId,IsLossOfPayMonth,IsPayslipReleased,IsManualLeaveManagement,CreatedDateTime,CreatedByUserId,
									   OriginalEarning,OriginalDeduction,OriginalActualEarning,OriginalActualDeduction,OriginalPaidAmount,OriginalActualPaidAmount,OriginalTotalEarningsToDate,OriginalActualEarningsToDate,OriginalTotalDeductionsToDate,OriginalActualDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,OriginalTotalAmountPaid,OriginalLoanAmountRemaining)
		SELECT @NewPayrollRunEmployeeId,EmployeeId,PayrollTemplateId,@NewPayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,TotalEarningsToDate,TotalDeductionsToDate,ActualTotalEarningsToDate,ActualTotalDeductionsToDate,
		       NetAmount,ActualNetAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualTotalEarningsToDate,TotalDeductionsToDate,ActualTotalDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
		       TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,WorkedDays,SickDays,@PayrollStatusId,IsLossOfPayMonth,0,1,GETDATE(),@OperationsPerformedBy,
			   TotalEarningsToDate,TotalDeductionsToDate,ActualTotalEarningsToDate,ActualTotalDeductionsToDate,NetAmount,ActualNetAmount,TotalEarningsToDate,ActualTotalEarningsToDate,TotalDeductionsToDate,ActualTotalDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,TotalAmountPaid,LoanAmountRemaining
		FROM #PayrollEmployee 
		WHERE Id = @EmployeesCounter
		      AND NetAmount IS NOT NULL

		INSERT INTO PayrollRunEmployeeComponent(Id,ComponentName,ComponentAmount,ActualComponentAmount,OriginalComponentAmount,OriginalActualComponentAmount,IsDeduction,ComponentId,PayrollRunId,EmployeeId,CreatedDateTime,CreatedByUserId)
		SELECT NEWID(),PayrollComponentName,PayrollComponentAmount,ActualPayrollComponentAmount,PayrollComponentAmount,ActualPayrollComponentAmount,IsDeduction,PayrollComponentId,@NewPayrollRunId,EmployeeId,GETDATE(),@OperationsPerformedBy
		FROM #Payroll
		WHERE EmployeeId = @EmployeeId
		      AND PayrollComponentId IS NOT NULL

		--UPDATE EmployeeBonus SET PayrollRunEmployeeId = @NewPayrollRunEmployeeId WHERE Id IN (SELECT Id FROM EmployeeBonus WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsApproved = 1 AND IsArchived = 0)

		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	INSERT INTO PayrollRunEmployee(Id,EmployeeId,PayrollTemplateId,PayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,Earning, Deduction,ActualEarning,ActualDeduction,
	                               PaidAmount,ActualPaidAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualEarningsToDate,TotalDeductionsToDate,ActualDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
	                               TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,EffectiveWorkingDays,SickDays,PayrollStatusId,IsLossOfPayMonth,IsPayslipReleased,IsManualLeaveManagement,CreatedDateTime,CreatedByUserId,
								   OriginalEarning,OriginalDeduction,OriginalActualEarning,OriginalActualDeduction,OriginalPaidAmount,OriginalActualPaidAmount,OriginalTotalEarningsToDate,OriginalActualEarningsToDate,OriginalTotalDeductionsToDate,OriginalActualDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,OriginalTotalAmountPaid,OriginalLoanAmountRemaining)
	SELECT Id,EmployeeId,PayrollTemplateId,PayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,Earning, Deduction,ActualEarning,ActualDeduction,
	                               PaidAmount,ActualPaidAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualEarningsToDate,TotalDeductionsToDate,ActualDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
	                               TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,EffectiveWorkingDays,SickDays,PayrollStatusId,IsLossOfPayMonth,IsPayslipReleased,0,CreatedDateTime,CreatedByUserId,
								   OriginalEarning,OriginalDeduction,OriginalActualEarning,OriginalActualDeduction,OriginalPaidAmount,OriginalActualPaidAmount,OriginalTotalEarningsToDate,OriginalActualEarningsToDate,OriginalTotalDeductionsToDate,OriginalActualDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,OriginalTotalAmountPaid,OriginalLoanAmountRemaining
	FROM Temp_PayrollRunEmployee 
	WHERE PayrollRunId = @NewPayrollRunId
	      AND EmployeeId NOT IN (SELECT EmployeeId FROM #Payroll)

	INSERT INTO PayrollRunEmployeeComponent(Id,ComponentName,ComponentAmount,ActualComponentAmount,OriginalComponentAmount,OriginalActualComponentAmount,IsDeduction,ComponentId,PayrollRunId,EmployeeId,CreatedDateTime,CreatedByUserId)
	SELECT Id,ComponentName,ComponentAmount,ActualComponentAmount,OriginalComponentAmount,OriginalActualComponentAmount,IsDeduction,ComponentId,PayrollRunId,EmployeeId,CreatedDateTime,CreatedByUserId
	FROM Temp_PayrollRunEmployeeComponent
	WHERE PayrollRunId = @NewPayrollRunId
	      AND EmployeeId NOT IN (SELECT EmployeeId FROM #Payroll)

	UPDATE EmployeeBonus SET PayrollRunEmployeeId = PRE.Id, IsProcessed = 1
	FROM EmployeeBonus EB
	      INNER JOIN PayrollRunEmployee PRE ON EB.EmployeeId = PRE.EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsApproved = 1 AND IsArchived = 0
	WHERE PRE.PayrollRunId = @NewPayrollRunId

	UPDATE EmployeeLoan SET IsProcessed = 1
	FROM EmployeeLoan EL 
		 INNER JOIN PayrollRunEmployee PRE ON EL.EmployeeId = PRE.EmployeeId AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL
	WHERE EL.Id IN (SELECT EmployeeLoanId FROM EmployeeLoanInstallment WHERE InstalmentDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0)
	      AND PRE.PayrollRunId = @NewPayrollRunId

	--SELECT @EmployeeIds = STUFF((SELECT ','+ CAST(EmployeeId AS NVARCHAR(MAX)) FROM Temp_PayrollRunEmployee WHERE PayrollRunId = @NewPayrollRunId FOR XML PATH('')), 1, 1, '')

	--EXEC USP_ProduceFinalPayrollYTDComponents @OperationsPerformedBy,@EmployeeIds,@RunStartDate,@RunEndDate,@NewPayrollRunId

	--SELECT * FROM #PayrollEmployee
	SELECT @NewPayrollRunId

	----Saving of payrollrun data End

END
GO


--EXEC USP_ProduceFinalPayroll '1558A8BC-D112-4FA6-AF52-BD72BBE90F5B',NULL,NULL,'2020-05-01','2020-05-31',NULL,NULL,NULL,'[{"EmployeeNumber":"test123","EmployeeName":"Peter","LossOfPay":2,"EncashedLeaves":0},{"EmployeeNumber":"branch 123","EmployeeName":"Test","LossOfPay":0,"EncashedLeaves":2}]'