CREATE PROCEDURE [dbo].[USP_GetPermanentEmployeePayments]
( 
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@DateFrom DATE,
	@DateTo DATE,
	@IsTimesheetApproved BIT = NULL,
	@EmployeeIds NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)),
	        @RunStartDate DATE = DATEADD(mm, DATEDIFF(mm, 0, @DateTo), 0),
			@RunEndDate DATE = EOMONTH(@DateTo),
			@TotalDays INT = DAY(EOMONTH(@DateTo)),
			@SalaryDays INT = DATEDIFF(DAY,@DateFrom,@DateTo) + 1

	DECLARE @PermanentEmployeeId NVARCHAR(MAX) 

	 SELECT @PermanentEmployeeId = coalesce(@PermanentEmployeeId +',', '')+ CONVERT(varchar(38), E.Id)   From [User] u
	 INNER JOIN Employee e on e.UserId= u.Id
	 INNER JOIN Job j on e.id = j.EmployeeId
	 INNER JOIN EmploymentStatus es on es.id  = j.EmploymentStatusId AND ES.InActiveDateTime IS NULL
	 WHERE es.IsPermanent = 1 and u.CompanyId= @CompanyId
	 AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))


	DECLARE  @PayrollForNonResignationEmployee  TABLE
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

	INSERT INTO @PayrollForNonResignationEmployee 

    EXEC USP_ProducePayrollComponents @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,@PermanentEmployeeId,NULL

	DECLARE @PayrollForMiddleHikeEmployee TABLE
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

	INSERT INTO @PayrollForMiddleHikeEmployee 

    EXEC [USP_ProducePayrollComponentsForMiddleHikeEmployees] @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,@PermanentEmployeeId,NULL

	DECLARE @PayrollForResignationEmployee TABLE
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

	INSERT INTO @PayrollForResignationEmployee

    EXEC USP_ProducePayrollComponentsForResignedEmployees @OperationsPerformedBy,NULL,NULL,@RunStartDate,@RunEndDate,@PermanentEmployeeId,NULL

	DECLARE @Payroll TABLE  
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

	INSERT INTO @Payroll
	SELECT *
	FROM @PayrollForNonResignationEmployee
	WHERE EmployeeId NOT IN (SELECT EmployeeId FROM @PayrollForResignationEmployee GROUP BY EmployeeId)
	      AND EmployeeId NOT IN (SELECT EmployeeId FROM @PayrollForMiddleHikeEmployee GROUP BY EmployeeId)

	---- Prof Tax calculation for Middle Hike Employees Start
	UPDATE @PayrollForMiddleHikeEmployee SET PayrollComponentAmount = NULL, ActualPayrollComponentAmount = NULL,Deduction = NULL, ActualDeduction = NULL WHERE IsRelatedToPT = 1 --PayrollComponentName = 'Prof Tax'

	UPDATE @PayrollForMiddleHikeEmployee SET PayrollComponentAmount = ProfTax, ActualPayrollComponentAmount = ActualProfTax,Deduction = ProfTax, ActualDeduction = ActualProfTax
	FROM @PayrollForMiddleHikeEmployee PMH
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
					FROM @PayrollForMiddleHikeEmployee P 
					     INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
						 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = P.EmployeeId
						            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
							              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
										  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
								        )
					WHERE PC.EmployerContributionPercentage IS NULL
					GROUP BY P.EmployeeId,EB.BranchId
					) T
					  INNER JOIN (SELECT EmployeeId, MAX(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM @PayrollForMiddleHikeEmployee GROUP BY EmployeeId) TInner ON TInner.EmployeeId = T.EmployeeId
				   ) PInner ON PInner.EmployeeId = PMH.EmployeeId AND PInner.EmployeeConfigAndSalaryId = PMH.EmployeeConfigAndSalaryId
	WHERE IsRelatedToPT = 1 

	---- Prof Tax calculation for Middle Hike Employees End

	SELECT P.EmployeeId,
	       P.PayrollTemplateId
	INTO #MiddleHikeEmployeeLatestTemplate 
	FROM @PayrollForMiddleHikeEmployee P
	     INNER JOIN (SELECT EmployeeId, MAX(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM @PayrollForMiddleHikeEmployee GROUP BY EmployeeId) PInner ON P.EmployeeId = PInner.EmployeeId AND P.EmployeeConfigAndSalaryId = PInner.EmployeeConfigAndSalaryId
	GROUP BY  P.EmployeeId,P.PayrollTemplateId 

	INSERT INTO @Payroll
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
	FROM @PayrollForMiddleHikeEmployee P
	      INNER JOIN ( SELECT EmployeeId,SUM(EmployeeSalary) EmployeeSalary, SUM(ActualEmployeeSalary) ActualEmployeeSalary, SUM(OneDaySalary) OneDaySalary, SUM(WorkedDays) WorkedDays, SUM(LeavesTaken) LeavesTaken, SUM(UnplannedHolidays) UnplannedHolidays, SUM(SickDays) SickDays, 
		              SUM(PlannedHolidays) PlannedHolidays, SUM(AllowedLeaves) AllowedLeaves, SUM(PaidLeaves) PaidLeaves, SUM(UnPaidLeaves) UnPaidLeaves, SUM(LossOfPay) LossOfPay, SUM(EncashedLeaves) EncashedLeaves, SUM(TotalAmountPaid) TotalAmountPaid, SUM(LoanAmountRemaining) LoanAmountRemaining
		              FROM (SELECT DISTINCT EmployeeConfigAndSalaryId, EmployeeId,EmployeeSalary, ActualEmployeeSalary, OneDaySalary, WorkedDays, LeavesTaken, UnplannedHolidays, SickDays, PlannedHolidays, AllowedLeaves, PaidLeaves, UnPaidLeaves, LossOfPay , EncashedLeaves, TotalAmountPaid,LoanAmountRemaining
					        FROM @PayrollForMiddleHikeEmployee) T
					  GROUP BY EmployeeId) PME ON PME.EmployeeId = P.EmployeeId
		 INNER JOIN #MiddleHikeEmployeeLatestTemplate MET ON MET.EmployeeId = P.EmployeeId
	WHERE P.EmployeeId NOT IN (SELECT EmployeeId FROM @PayrollForResignationEmployee GROUP BY EmployeeId)
	GROUP BY P.EmployeeId,P.EmployeeName,P.IsLossOfPayMonth,MET.PayrollTemplateId,P.PayrollComponentId,P.PayrollComponentName,P.IsDeduction,PME.EmployeeSalary,PME.ActualEmployeeSalary,PME.OneDaySalary,P.IsRelatedToPT,P.TotalDaysInPayroll,P.TotalWorkingDays,PME.LeavesTaken,PME.UnplannedHolidays,
             PME.SickDays,PME.WorkedDays,PME.PlannedHolidays,PME.LossOfPay,P.IsInResignation,P.TotalLeaves,PME.PaidLeaves,PME.UnPaidLeaves,PME.AllowedLeaves,PME.EncashedLeaves,
			 PME.TotalAmountPaid,PME.LoanAmountRemaining
	
	INSERT INTO @Payroll
	SELECT *
	FROM @PayrollForResignationEmployee
	
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
	FROM @Payroll P 
	GROUP BY P.EmployeeId,P.EmployeeName,P.PayrollTemplateId,P.EmployeeSalary,P.OneDaySalary,P.ActualEmployeeSalary,P.TotalWorkingDays,P.LeavesTaken,P.UnplannedHolidays,P.SickDays,P.WorkedDays,P.plannedHolidays,P.TotalLeaves,P.AllowedLeaves,P.PaidLeaves,
	         P.UnPaidLeaves,P.LossOfPay,P.IsInResignation,P.IsLossOfPayMonth,P.EncashedLeaves
	----Net amount calculation End

	---- Employee contribution earning are removed from net amounts


	UPDATE #PayrollEmployee SET NetAmount = NetAmount - ISNULL(PayrollComponentAmount,0), TotalEarningsToDate = TotalEarningsToDate - ISNULL(PayrollComponentAmount,0), 
	                            ActualNetAmount = ActualNetAmount - ISNULL(ActualPayrollComponentAmount,0), ActualTotalEarningsToDate = ActualTotalEarningsToDate - ISNULL(ActualPayrollComponentAmount,0)
	FROM #PayrollEmployee PE
	     LEFT JOIN (SELECT EmployeeId, SUM(PayrollComponentAmount) PayrollComponentAmount, SUM(ActualPayrollComponentAmount) ActualPayrollComponentAmount
		            FROM @Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
					WHERE PC.EmployerContributionPercentage IS NOT NULL AND P.IsDeduction = 0
					GROUP BY EmployeeId) PEInner ON PEInner.EmployeeId = PE.EmployeeId

	
	UPDATE RAP SET RAP.ActualFromTime = p.InTime, rap.ActualToTime = p.OutTime, rap.ActualRate = p.ActualSalary 
	FROM RosterActualPlan RAP
	inner join  (
		SELECT EmployeeId,EmployeeName,ActualNetAmount,(ActualNetAmount/(@TotalDays*1.0)) OneDaySalary,ROUND(((ActualNetAmount/(@TotalDays*1.0)) * @SalaryDays),0) ActualSalary,
		IIF(@IsTimesheetApproved = 0,  TS.InTime, TP.StartTime) InTime, IIF(@IsTimesheetApproved = 0,  TS.OutTime, TP.EndTime) OutTime,
		IIF(@IsTimesheetApproved = 0, ts.Date, tp.Date) [DateLogged]
		FROM #PayrollEmployee P
		INNER JOIN Employee E ON P.EmployeeId = E.Id
		INNER JOIN [User] U ON E.UserId = U.Id
		LEFT JOIN TimeSheet TS ON TS.UserId = U.Id AND TS.Date BETWEEN @DateFrom AND @DateTo AND @IsTimesheetApproved = 0
		LEFT JOIN TimeSheetPunchCard TP ON TP.UserId = U.Id AND TP.Date BETWEEN @DateFrom AND @DateTo AND @IsTimesheetApproved = 1
	) p on p.EmployeeId = rap.ActualEmployeeId AND p.DateLogged = rap.PlanDate
	WHERE @PermanentEmployeeId IS NOT NULL AND rap.ActualEmployeeId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds))

END