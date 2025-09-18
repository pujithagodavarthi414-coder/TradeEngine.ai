CREATE PROCEDURE [dbo].[USP_ProducePayroll]
( 
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER,
	@PayrollTemplateId UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@NewPayrollRunId UNIQUEIDENTIFIER = NULL,
	@EmployeeIds NVARCHAR(MAX) = NULL,
	@EmploymentStatusIds NVARCHAR(MAX) = NULL,
	@ChequeDate DATE = NULL,
	@AlphaCode NVARCHAR(MAX) = NULL,
	@Cheque NVARCHAR(MAX) = NULL,
	@ChequeNo NVARCHAR(MAX) = NULL

)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	DECLARE @ProcessEmployees INT

	CREATE TABLE #FilterCounts
	(
		Id INT IDENTITY(1,1),
		FilterCount INT,
		FilterType NVARCHAR(100)
	)

	IF(@BranchId IS NOT NULL OR @PayrollTemplateId IS NOT NULL OR @EmployeeIds IS NOT NULL OR @EmploymentStatusIds IS NOT NULL)
	BEGIN

		IF(@BranchId IS NOT NULL)
		BEGIN

			INSERT INTO #FilterCounts
			SELECT COUNT(1),'Branch' FROM EmployeeBranch EB
			       INNER JOIN Employee E ON E.Id = EB.EmployeeId
				   INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
			WHERE EB.BranchId = @BranchId
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		END
		IF(@PayrollTemplateId IS NOT NULL)
		BEGIN

			INSERT INTO #FilterCounts
			SELECT COUNT(1),'PayrollTemplate' FROM EmployeepayrollConfiguration EPC 
		           INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL
				   INNER JOIN Employee E ON E.Id = EPC.EmployeeId
				   INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
		    WHERE ( (EPC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  	   	            OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
		   				OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  	   		     )
		   			AND EPC.InActiveDateTime IS NULL
					AND PT.Id = @PayrolltemplateId

		END
		IF(@EmployeeIds IS NOT NULL)
		BEGIN

			INSERT INTO #FilterCounts
			SELECT COUNT(1),'Employee' FROM UfnSplit(@EmployeeIds) EPC 
				   INNER JOIN Employee E ON E.Id = EPC.Id
				   INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId

		END
		IF(@EmploymentStatusIds IS NOT NULL)
		BEGIN

			INSERT INTO #FilterCounts
			SELECT COUNT(1),'EmploymentStatus' FROM Employee E
				   INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
		END

		SET @ProcessEmployees = ISNULL((SELECT MIN(FilterCount) FROM #FilterCounts),0)

	END
	ELSE
	BEGIN

		SELECT @ProcessEmployees = COUNT(1) FROM [User] U
		           INNER JOIN Employee E ON E.UserId = U.Id
				   INNER JOIN (SELECT J.EmployeeId, MAX(J.JoinedDate) JoinedDate 
								FROM Job J 
								     INNER JOIN Employee E ON E.Id = J.EmployeeId
									 INNER JOIN [User] U ON U.Id = E.UserId
								WHERE U.CompanyId = @CompanyId AND J.InActiveDateTime IS NULL GROUP BY J.EmployeeId) Job ON Job.EmployeeId = E.Id AND DATEADD(MONTH, DATEDIFF(MONTH, 0, Job.JoinedDate) , 0) <= DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0)
	               INNER JOIN Job J ON J.InActiveDateTime IS NULL AND J.EmployeeId = Job.EmployeeId AND J.JoinedDate = Job.JoinedDate
		WHERE IsActive = 1 AND CompanyId = @CompanyId

	END
	
	IF(@NewPayrollRunId IS NULL) SELECT @NewPayrollRunId = NEWID()
	
	INSERT INTO Temp_PayrollRun(Id,CompanyId,BranchId,PayrollTemplateId,RunDate,PayrollStartDate,PayrollEndDate,CreatedDateTime,CreatedByUserId,ProcessEmployees,ChequeDate,AlphaCode,Cheque,ChequeNo)
	VALUES(@NewPayrollRunId,@CompanyId,@BranchId,@PayrollTemplateId,GETDATE(),@RunStartDate,@RunEndDate,GETDATE(),@OperationsPerformedBy,@ProcessEmployees,@ChequeDate,@AlphaCode,@Cheque,@ChequeNo)

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

    EXEC USP_ProducePayrollComponents @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@NewPayrollRunId,@EmployeeIds,@EmploymentStatusIds

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

    EXEC [USP_ProducePayrollComponentsForMiddleHikeEmployees] @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@NewPayrollRunId,@EmployeeIds,@EmploymentStatusIds

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

    EXEC USP_ProducePayrollComponentsForResignedEmployees @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@NewPayrollRunId,@EmployeeIds,@EmploymentStatusIds

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

    EXEC [USP_ProducePayrollComponentsForHourlyRateEmployees] @OperationsPerformedBy,@BranchId,@PayrollTemplateId,@RunStartDate,@RunEndDate,@NewPayrollRunId,@EmployeeIds,@EmploymentStatusIds

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
	
	UPDATE Temp_PayrollRun SET ProcessedEmployees = CASE WHEN ProcessedEmployees > ROUND(ProcessEmployees*(90.0/100.0),2) THEN ProcessedEmployees ELSE ROUND(ProcessEmployees*(90.0/100.0),2) END WHERE Id = @NewPayrollRunId

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

	UPDATE Temp_PayrollRun SET ProcessedEmployees = CASE WHEN ProcessedEmployees > ROUND(ProcessEmployees*(90.0/100.0),2) THEN ProcessedEmployees ELSE ROUND(ProcessEmployees*(95.0/100.0),2) END WHERE Id = @NewPayrollRunId

	----Saving of payrollrun data Start
	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @NewPayrollRunEmployeeId UNIQUEIDENTIFIER

	DECLARE @PayrollStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE CompanyId = @CompanyId AND PayrollStatusName = 'Generated' AND IsArchived = 0)

	SELECT @EmployeesCount = COUNT(1) FROM #PayrollEmployee

	UPDATE Temp_PayrollRun SET TotalEmployees = @EmployeesCount WHERE Id = @NewPayrollRunId

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		SELECT @EmployeeId = EmployeeId FROM #PayrollEmployee WHERE Id = @EmployeesCounter
		SELECT @NewPayrollRunEmployeeId = NEWID()

		INSERT INTO Temp_PayrollRunEmployee(Id,EmployeeId,PayrollTemplateId,PayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,Earning,Deduction,ActualEarning,ActualDeduction,
		                               PaidAmount,ActualPaidAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualEarningsToDate,TotalDeductionsToDate,ActualDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
		                               TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,EffectiveWorkingDays,SickDays,PayrollStatusId,IsLossOfPayMonth,IsPayslipReleased,CreatedDateTime,CreatedByUserId,
									   OriginalEarning,OriginalDeduction,OriginalActualEarning,OriginalActualDeduction,OriginalPaidAmount,OriginalActualPaidAmount,OriginalTotalEarningsToDate,OriginalActualEarningsToDate,OriginalTotalDeductionsToDate,OriginalActualDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,OriginalTotalAmountPaid,OriginalLoanAmountRemaining)
		SELECT @NewPayrollRunEmployeeId,EmployeeId,PayrollTemplateId,@NewPayrollRunId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,TotalEarningsToDate,TotalDeductionsToDate,ActualTotalEarningsToDate,ActualTotalDeductionsToDate,
		       NetAmount,ActualNetAmount,EmployeeName,BankAccountDetailsJson,[Address],TotalEarningsToDate,ActualTotalEarningsToDate,TotalDeductionsToDate,ActualTotalDeductionsToDate,TotalDaysInPayroll,TotalWorkingDays,PlannedHolidays,UnplannedHolidays,
		       TotalLeaves,AllowedLeaves,PaidLeaves,UnPaidLeaves,LeavesTaken,LossOfPay,EncashedLeaves,IsInResignation,WorkedDays,SickDays,@PayrollStatusId,IsLossOfPayMonth,0,GETDATE(),@OperationsPerformedBy,
			   TotalEarningsToDate,TotalDeductionsToDate,ActualTotalEarningsToDate,ActualTotalDeductionsToDate,NetAmount,ActualNetAmount,TotalEarningsToDate,ActualTotalEarningsToDate,TotalDeductionsToDate,ActualTotalDeductionsToDate,TotalAmountPaid,LoanAmountRemaining,TotalAmountPaid,LoanAmountRemaining
		FROM #PayrollEmployee 
		WHERE Id = @EmployeesCounter
		      AND NetAmount IS NOT NULL

		INSERT INTO Temp_PayrollRunEmployeeComponent(Id,ComponentName,ComponentAmount,ActualComponentAmount,OriginalComponentAmount,OriginalActualComponentAmount,IsDeduction,ComponentId,PayrollRunId,EmployeeId,CreatedDateTime,CreatedByUserId)
		SELECT NEWID(),PayrollComponentName,PayrollComponentAmount,ActualPayrollComponentAmount,PayrollComponentAmount,ActualPayrollComponentAmount,IsDeduction,PayrollComponentId,@NewPayrollRunId,EmployeeId,GETDATE(),@OperationsPerformedBy
		FROM #Payroll
		WHERE EmployeeId = @EmployeeId
		      AND PayrollComponentId IS NOT NULL

		--UPDATE EmployeeBonus SET PayrollRunEmployeeId = @NewPayrollRunEmployeeId WHERE Id IN (SELECT Id FROM EmployeeBonus WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsApproved = 1 AND IsArchived = 0)

		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	UPDATE Temp_PayrollRun SET ProcessedEmployees = ProcessEmployees WHERE Id = @NewPayrollRunId

	--SELECT * FROM #PayrollEmployee

	SELECT PE.EmployeeId, PE.EmployeeName, E.EmployeeNumber, dbo.Ufn_GetCurrency(CU.CurrencyCode,PRE.ActualPaidAmount,1) NetPay, PRE.TotalWorkingDays, PRE.EffectiveWorkingDays, PRE.LossOfPay, PRE.EncashedLeaves
	FROM Temp_PayrollRunEmployee PRE 
	INNER JOIN Employee E ON E.Id = PRE.EmployeeId 
	INNER JOIN #PayrollEmployee PE ON PE.EmployeeId = PRE.EmployeeId
    LEFT JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
    LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
	WHERE PayrollRunId = @NewPayrollRunId
	      AND PE.EmployeeId NOT IN (SELECT EmployeeId FROM #PayrollForHourlyRateEmployee)
		  AND PRE.IsInResignation = 0

	-- SELECT @NewPayrollRunId

	----Saving of payrollrun data End

END
GO

--EXEC USP_ProducePayroll '1CDB3294-9B0F-479A-A6CD-CD61A7240FAB',NULL,NULL,'2020-08-01','2020-08-31'

--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-01-01','2020-01-31'






--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-01-01','2020-01-31'

--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-02-01','2020-02-29'
--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-03-01','2020-03-31'
--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-04-01','2020-04-30'
--EXEC USP_ProducePayroll '1558A8BC-D112-4FA6-AF52-BD72BBE90F5B',NULL,NULL,'2020-05-01','2020-05-31'
--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-06-01','2020-06-30'
--EXEC USP_ProducePayroll '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-07-01','2020-07-31'