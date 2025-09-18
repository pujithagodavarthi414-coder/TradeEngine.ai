CREATE PROCEDURE [dbo].[USP_ProducePayrollComponentsForMiddleHikeEmployees]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER,
	@PayrollTemplateId UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@NewPayrollRunId UNIQUEIDENTIFIER = NULL,
	@EmployeeIds NVARCHAR(MAX) = NULL,
	@EmploymentStatusIds NVARCHAR(MAX) = NULL
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate), @TaxPeriodType NVARCHAR(100), @LossOfPayPeriodType NVARCHAR(100), @LeaveEncashmentPeriodType NVARCHAR(100)
	DECLARE @LossOfPayStartDate DATE, @LossOfPayEndDate DATE,@LOPEmployeesCount INT, @LOPEmployeesCounter INT = 1, @LOPEmployeeId UNIQUEIDENTIFIER,@LOPEmployeeBranchId UNIQUEIDENTIFIER, @LOPUserId UNIQUEIDENTIFIER,  
	        @LOPFinancialYearFromMonth INT, @LOPFinancialYearToMonth INT, @TaxFinancialYearTypeId UNIQUEIDENTIFIER, @LeavesFinancialYearTypeId UNIQUEIDENTIFIER, @LOPFinancialYearFromDate DATE, @LOPFinancialYearToDate DATE, 
			@LOPFinancialFromYear INT, @LOPFinancialToYear INT, @LeaveEncashmentPeriodTypeForLop NVARCHAR(100),
			@ProcessedEmployeesWeightage FLOAT, @LOPEmployeeCountryId UNIQUEIDENTIFIER,@IsEncashCtcType BIT 

	SELECT @ProcessedEmployeesWeightage = IIF(ProcessEmployees = 0, 0, ROUND((80.0/(ProcessEmployees*1.0))/100.0,1)) FROM Temp_PayrollRun WHERE Id = @NewPayrollRunId
	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'
	SELECT @LeavesFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Leaves'

	SELECT EPC.Id OldConfigId, EPCInner.Id NewConfigId
	INTO #EmployeepayrollConfigurationHistory
	FROM EmployeepayrollConfiguration EPC
		 INNER JOIN (SELECT Id, EmployeeId FROM EmployeepayrollConfiguration WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0) = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunStartDate), 0) 
		                                                                           AND (@EmployeeIds IS NULL OR EmployeeId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))
																				   AND InActiveDateTime IS NULL /*AND IsApproved = 1*/) EPCInner ON EPCInner.EmployeeId = EPC.Employeeid
		 INNER JOIN Employee E ON E.Id = EPC.EmployeeId
		 INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	WHERE EPC.InActiveDateTime IS NULL
	      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveTo), 0) = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunStartDate), 0) 
		  AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))
		  --AND EPC.IsApproved = 1

	SELECT ROW_NUMBER() OVER(Partition by EmployeeId ORDER BY ActiveFrom) [Order],*
	INTO #EmployeepayrollConfiguration
	FROM (

	SELECT *
	FROM EmployeepayrollConfiguration
	WHERE Id IN (SELECT OldConfigId FROM #EmployeepayrollConfigurationHistory)

	UNION

	SELECT *
	FROM EmployeepayrollConfiguration
	WHERE Id IN (SELECT NewConfigId FROM #EmployeepayrollConfigurationHistory)

	) TInner

	SELECT ES.Id OldSalId, ESInner.Id NewSalId
	INTO #EmployeeSalaryHistory
	FROM EmployeeSalary ES
		 INNER JOIN (SELECT Id, EmployeeId FROM EmployeeSalary WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0) = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunStartDate), 0) AND InActiveDateTime IS NULL) ESInner ON ESInner.EmployeeId = ES.EmployeeId
		 INNER JOIN Employee E ON E.Id = ES.EmployeeId
		 INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	WHERE ES.InActiveDateTime IS NULL
	      AND DATEADD(MONTH, DATEDIFF(MONTH, 0, ES.ActiveTo), 0) = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunStartDate), 0) 
		  AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	SELECT ROW_NUMBER() OVER(Partition BY EmployeeId ORDER BY ActiveFrom) [Order],*
	INTO #EmployeeSalary
	FROM (

	SELECT *
	FROM EmployeeSalary
	WHERE Id IN (SELECT OldSalId FROM #EmployeeSalaryHistory)

	UNION

	SELECT *
	FROM EmployeeSalary
	WHERE Id IN (SELECT NewSalId FROM #EmployeeSalaryHistory)

	) TInner

	--SELECT * FROM #EmployeepayrollConfiguration
	--SELECT * FROM #EmployeeSalary

	SELECT ROW_NUMBER() OVER(ORDER BY EmployeeId,EmployeepayrollConfigurationActiveFrom) Id, *
	INTO #EmployeeConfigAndSalary
	FROM (

	SELECT EPC.EmployeeId, EPC.PayrollTemplateId, EPC.ActiveFrom EmployeepayrollConfigurationActiveFrom, EPC.ActiveTo EmployeepayrollConfigurationActiveTo, ES.Amount, ES.NetPayAmount, ES.ActiveFrom EmployeeSalaryActiveFrom, ES.ActiveTo EmployeeSalaryActiveTo, 1 IsConfigDates
	FROM #EmployeepayrollConfiguration EPC
	     INNER JOIN #EmployeeSalary ES ON ES.EmployeeId = EPC.EmployeeId AND ES.[Order] = EPC.[Order]

	UNION

	SELECT EPC.EmployeeId, EPC.PayrollTemplateId, EPC.ActiveFrom EmployeepayrollConfigurationActiveFrom, EPC.ActiveTo EmployeepayrollConfigurationActiveTo, ES.Amount, ES.NetPayAmount, ES.ActiveFrom EmployeeSalaryActiveFrom, ES.ActiveTo EmployeeSalaryActiveTo, 1 IsConfigDates
	FROM #EmployeepayrollConfiguration EPC
	     INNER JOIN EmployeeSalary ES ON ES.EmployeeId = EPC.EmployeeId AND ES.InActiveDateTime IS NULL 
		AND EPC.SalaryId = ES.Id
	WHERE EPC.EmployeeId NOT IN (SELECT DISTINCT EmployeeId FROM #EmployeeSalary)

	UNION

	SELECT ES.EmployeeId, EPC.PayrollTemplateId, EPC.ActiveFrom EmployeepayrollConfigurationActiveFrom, EPC.ActiveTo EmployeepayrollConfigurationActiveTo, ES.Amount, ES.NetPayAmount, ES.ActiveFrom EmployeeSalaryActiveFrom, ES.ActiveTo EmployeeSalaryActiveTo, 0 IsConfigDates
	FROM #EmployeeSalary ES
	     INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = ES.EmployeeId AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		AND EPC.SalaryId = ES.Id
	WHERE ES.EmployeeId NOT IN (SELECT DISTINCT EmployeeId FROM #EmployeepayrollConfiguration)

	) TInner

	--SELECT * FROM #EmployeeConfigAndSalary

	--Loss Of Pay Start
	DECLARE @LOPEmployee TABLE
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		UserId UNIQUEIDENTIFIER,
		BranchId UNIQUEIDENTIFIER,
		TotalLeaves FLOAT
	)

	INSERT INTO @LOPEmployee(EmployeeId,UserId,BranchId)
	SELECT E.Id EmployeeId,
	       U.Id UserId,
		   EB.BranchId
	FROM [User] U
	     INNER JOIN Employee E ON E.UserId = U.Id
		 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
					  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				  ) 

	WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	DECLARE @Leaves TABLE  
	(
		UserId UNIQUEIDENTIFIER,
		EmployeeId UNIQUEIDENTIFIER,
		IsPaid BIT,
		[Count] FLOAT,
		MasterLeaveTypeId UNIQUEIDENTIFIER,
		[Date] DATE,
		TotalLeaves FLOAT
	)

	DECLARE @EmployeeConfigAndSalaryWithLOP TABLE 
	(
		EmployeeConfigAndSalaryId INT,
		EmployeeId UNIQUEIDENTIFIER,
		PayrollTemplateId UNIQUEIDENTIFIER,
		EmployeepayrollConfigurationActiveFrom DATE,
		EmployeepayrollConfigurationActiveTo DATE,
		Amount FLOAT,
		NetPayAmount FLOAT,
		EmployeeSalaryActiveFrom DATE,
		EmployeeSalaryActiveTo DATE,
		IsConfigDates BIT,
		TotalLeaves FLOAT,
		AllowedLeaves FLOAT,
		PaidLeaves FLOAT,
		UnPaidLeaves FLOAT,
		LeavesTaken FLOAT,
		UnplannedHolidays FLOAT,
		SickDays FLOAT,
		PlannedHolidays FLOAT,
		MinPaidLeaves FLOAT,
		MinUnPaidLeaves FLOAT,
		IsLossOfPayMonth BIT
	)

	SELECT @LOPEmployeesCount = COUNT(1) FROM @LOPEmployee

	WHILE(@LOPEmployeesCounter <= @LOPEmployeesCount)
	BEGIN

		SELECT @LOPEmployeeId = EmployeeId, @LOPUserId = UserId, @LOPEmployeeBranchId = BranchId FROM @LOPEmployee WHERE Id = @LOPEmployeesCounter
		SELECT @LossOfPayStartDate = NULL, @LossOfPayEndDate = NULL, @LossOfPayPeriodType = NULL, 
		       @LeaveEncashmentPeriodTypeForLop = NULL, @LOPFinancialYearFromMonth = NULL, @LOPFinancialYearToMonth = NULL

		SELECT @LOPEmployeeCountryId = CountryId FROM Branch WHERE Id = @LOPEmployeeBranchId

		SELECT @LossOfPayPeriodType = PT.PeriodTypeName
		FROM PayRollCalculationConfigurations PCC 
		     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
			 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
		WHERE PCT.PayRollCalculationTypeName = 'Loss of pay' AND PCC.InActiveDateTime IS NULL AND BranchId = @LOPEmployeeBranchId
		        AND ( (PCC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN PCC.ActiveFrom AND PCC.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (PCC.ActiveTo IS NULL AND @RunEndDate >= PCC.ActiveFrom)
				  OR (PCC.ActiveTo IS NOT NULL AND @RunStartDate <= PCC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, PCC.ActiveFrom), 0))
			   )

		SELECT @LeaveEncashmentPeriodTypeForLop = PT.PeriodTypeName
		FROM PayRollCalculationConfigurations PCC 
		     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
			 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
		WHERE PCT.PayRollCalculationTypeName = 'Leave encashment' AND PCC.InActiveDateTime IS NULL AND BranchId = @LOPEmployeeBranchId
		        AND ( (PCC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN PCC.ActiveFrom AND PCC.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (PCC.ActiveTo IS NULL AND @RunEndDate >= PCC.ActiveFrom)
				  OR (PCC.ActiveTo IS NOT NULL AND @RunStartDate <= PCC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, PCC.ActiveFrom), 0))
			   )

		SELECT @LOPFinancialYearFromMonth = FromMonth, @LOPFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
		WHERE CountryId = @LOPEmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @LeavesFinancialYearTypeId
		      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		SELECT @LossOfPayPeriodType = ISNULL(@LossOfPayPeriodType,'Every month'), 
		       @LeaveEncashmentPeriodTypeForLop = ISNULL(@LeaveEncashmentPeriodTypeForLop,'Yearly'),
		       @LOPFinancialYearFromMonth = ISNULL(@LOPFinancialYearFromMonth,1), 
			   @LOPFinancialYearToMonth = ISNULL(@LOPFinancialYearToMonth,12)

		SELECT @LOPFinancialFromYear = CASE WHEN @PayrollRunMonth - @LOPFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @LOPFinancialToYear = CASE WHEN @PayrollRunMonth - @LOPFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT  @LOPFinancialYearFromDate = DATEFROMPARTS(@LOPFinancialFromYear,@LOPFinancialYearFromMonth,1), @LOPFinancialYearToDate = EOMONTH(DATEFROMPARTS(@LOPFinancialToYear,@LOPFinancialYearToMonth,1))

		UPDATE @LOPEmployee SET TotalLeaves = [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](@LOPUserId,@LOPFinancialYearFromDate,@LOPFinancialYearToDate,1) 
		WHERE EmployeeId = @LOPEmployeeId

		IF(@LossOfPayPeriodType = 'Every month')
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LossOfPayEndDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0) ) )
			--SELECT @LossOfPayStartDate = @RunStartDate, @LossOfPayEndDate = @RunEndDate

		END
		ELSE IF(@LossOfPayPeriodType = 'Every quarter' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-2,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-2,@RunStartDate), @LossOfPayEndDate = @RunEndDate
			
		END
		ELSE IF(@LossOfPayPeriodType = 'Every halfyearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-5,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-5,@RunStartDate), @LossOfPayEndDate = @RunEndDate

		END
		ELSE IF(@LossOfPayPeriodType = 'Yearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-11,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-11,@RunStartDate), @LossOfPayEndDate = @RunEndDate

		END
		ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 10) -- Last quarter first month
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-9,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = @LOPFinancialYearFromMonth, @LossOfPayEndDate = @RunEndDate

		END
		ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND ((FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 11 OR (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 12)) -- Last quarter second and third months
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = @RunStartDate, @LossOfPayEndDate = @RunEndDate

		END
		
		IF(@LossOfPayStartDate IS NOT NULL AND @LossOfPayEndDate IS NOT NULL)
		BEGIN

			INSERT INTO @Leaves
			SELECT U.Id UserId, E.Id EmployeeId,
			       T.IsPaid,
				   T.[Count],
				   T.MasterLeaveTypeId,
				   T.[Date],
				   [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](U.Id,@LOPFinancialYearFromDate,@LOPFinancialYearToDate,1) TotalLeaves
			FROM [User] U
			     INNER JOIN Employee E ON E.UserId = U.Id
				 LEFT JOIN 
							(SELECT LAP.UserId,
							       LF.IsPaid,
								   CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
									    ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
									              ELSE 1 END END AS [Count],
								   LT.MasterLeaveTypeId,
								   T.[Date],
								   0 AllowedLeaves
							FROM
							(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],
							        LA.Id 
							 FROM MASTER..SPT_VALUES MSPT
							 	  INNER JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL) T
							 	  INNER JOIN LeaveApplication LAP ON LAP.Id = T.Id AND T.[Date] BETWEEN @LossOfPayStartDate AND @LossOfPayEndDate
								  INNER JOIN [User] U ON U.Id = LAP.UserId
								  INNER JOIN Employee E ON E.UserId = U.Id
							 	  INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1
							 	  INNER JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.InActiveDateTime IS NULL
							 	  INNER JOIN LeaveFrequency LF ON LF.LeaveTypeId = LT.Id AND T.[Date] BETWEEN LF.DateFrom AND LF.DateTo AND LF.InActiveDateTime IS NULL
							 	  INNER JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
							 	  INNER JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
							 	  LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL))
							 	  LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
							 	  LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL AND H.[Date] BETWEEN @LossOfPayStartDate AND @LossOfPayEndDate
							)T ON T.UserId = U.Id
			WHERE E.Id = @LOPEmployeeId
			
			INSERT INTO @EmployeeConfigAndSalaryWithLOP(EmployeeConfigAndSalaryId,EmployeeId,PayrollTemplateId,EmployeepayrollConfigurationActiveFrom,EmployeepayrollConfigurationActiveTo,Amount,NetPayAmount,EmployeeSalaryActiveFrom,EmployeeSalaryActiveTo,IsConfigDates)
			SELECT * FROM #EmployeeConfigAndSalary WHERE EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET EmployeePayrollConfigurationActiveFrom = CASE WHEN EmployeePayrollConfigurationActiveTo IS NOT NULL THEN @LossOfPayStartDate ELSE EmployeePayrollConfigurationActiveFrom END,
			                                           EmployeeSalaryActiveFrom = CASE WHEN EmployeeSalaryActiveTo IS NOT NULL THEN @LossOfPayStartDate ELSE EmployeeSalaryActiveFrom END,
													   EmployeePayrollConfigurationActiveTo = CASE WHEN EmployeePayrollConfigurationActiveTo IS NOT NULL THEN EmployeePayrollConfigurationActiveTo ELSE @LossOfPayEndDate END,
													   EmployeeSalaryActiveTo = CASE WHEN EmployeeSalaryActiveTo IS NOT NULL THEN EmployeeSalaryActiveTo ELSE @LossOfPayEndDate END
			 WHERE EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET TotalLeaves = L.TotalLeaves, IsLossOfPayMonth = 1 
			FROM @Leaves L INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.EmployeeId WHERE ECS.EmployeeId = @LOPEmployeeId 

			UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(E.UserId,@LossOfPayStartDate,@LossOfPayEndDate)
			FROM @EmployeeConfigAndSalaryWithLOP LE INNER JOIN Employee E ON E.Id = LE.EmployeeId
			WHERE EmployeeId = @LOPEmployeeId

			IF(@LossOfPayPeriodType = 'Every month' AND (@LeaveEncashmentPeriodTypeForLop <> 'Every month' OR @LeaveEncashmentPeriodTypeForLop IS NULL))
			BEGIN
			
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(month, DATEDIFF(month, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId

			END
			ELSE IF(@LossOfPayPeriodType = 'Every quarter' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0 AND (@LeaveEncashmentPeriodTypeForLop <> 'Every quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL))
			BEGIN
				
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-3,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId
				
			END
			ELSE IF(@LossOfPayPeriodType = 'Every halfyearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0) AND (@LeaveEncashmentPeriodTypeForLop <> 'Every halfyearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN
				
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-5,DATEADD(month, DATEDIFF(month, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId

			END
			ELSE IF(@LossOfPayPeriodType = 'Yearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0 AND (@LeaveEncashmentPeriodTypeForLop <> 'Yearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL))
			BEGIN
				
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-11,DATEADD(month, DATEDIFF(month, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId

			END
			ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 10 AND (@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)) -- Last quarter first month
			BEGIN
				
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(month, DATEDIFF(month, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId

			END
			ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND ((FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 11 OR (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 12) AND (@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)) -- Last quarter second and third months
			BEGIN
				
				UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @EmployeeConfigAndSalaryWithLOP LE 
				     LEFT JOIN (SELECT EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
								     INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
									 INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							         INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									 INNER JOIN (SELECT PayrollStartDate, PayrollEndDate, MAX(PR.CreatedDateTime) CreatedDateTime 
									             FROM PayrollRun PR
												      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
									 AND PR.InactiveDateTime IS NULL
									             WHERE DATEADD(month, DATEDIFF(month, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(month, DATEDIFF(month, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
												 GROUP BY PayrollStartDate, PayrollEndDate) PRInner ON PRInner.PayrollStartDate = PR.PayrollStartDate AND PRInner.PayrollEndDate = PR.PayrollEndDate AND PRInner.CreatedDateTime = PR.CreatedDateTime
								WHERE EmployeeId = @LOPEmployeeId) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId = @LOPEmployeeId

			END

			UPDATE @EmployeeConfigAndSalaryWithLOP SET LeavesTaken = ISNULL(ECSInner.LeavesTaken,0)
			FROM @EmployeeConfigAndSalaryWithLOP ECS
			     LEFT JOIN (SELECT L.EmployeeId, ECS.EmployeeConfigAndSalaryId, SUM([Count]) LeavesTaken
				            FROM @Leaves L
							     INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.employeeId
							WHERE L.[Date] BETWEEN (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveFrom ELSE EmployeeSalaryActiveFrom END)
											   AND (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveTo ELSE EmployeeSalaryActiveTo END)
								  AND L.EmployeeId = @LOPEmployeeId
							GROUP BY L.EmployeeId, ECS.EmployeeConfigAndSalaryId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId
			WHERE ECS.EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET UnplannedHolidays = ISNULL(ECSInner.UnplannedHolidays,0)
			FROM @EmployeeConfigAndSalaryWithLOP ECS
			     LEFT JOIN (SELECT L.EmployeeId, ECS.EmployeeConfigAndSalaryId, SUM([Count]) UnplannedHolidays
				            FROM @Leaves L
							     INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.employeeId
								 INNER JOIN MasterLeaveType MLT ON (MLT.IsWithoutIntimation = 1 OR MLT.IsSickLeave = 1) AND L.MasterLeaveTypeId = MLT.Id
							WHERE L.[Date] BETWEEN (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveFrom ELSE EmployeeSalaryActiveFrom END)
											   AND (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveTo ELSE EmployeeSalaryActiveTo END)
								  AND L.EmployeeId = @LOPEmployeeId
							GROUP BY L.EmployeeId, ECS.EmployeeConfigAndSalaryId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId
			WHERE ECS.EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET SickDays = ISNULL(ECSInner.SickDays,0)
			FROM @EmployeeConfigAndSalaryWithLOP ECS
			     LEFT JOIN (SELECT L.EmployeeId, ECS.EmployeeConfigAndSalaryId, SUM([Count]) SickDays
				            FROM @Leaves L
							     INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.employeeId
								 INNER JOIN MasterLeaveType MLT ON MLT.IsSickLeave = 1 AND L.MasterLeaveTypeId = MLT.Id
							WHERE L.[Date] BETWEEN (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveFrom ELSE EmployeeSalaryActiveFrom END)
											   AND (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveTo ELSE EmployeeSalaryActiveTo END)
								  AND L.EmployeeId = @LOPEmployeeId
							GROUP BY L.EmployeeId, ECS.EmployeeConfigAndSalaryId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId
			WHERE ECS.EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET PlannedHolidays = LeavesTaken - ISNULL(UnplannedHolidays,0) WHERE EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET PaidLeaves = ISNULL(ECSInner.PaidLeaves,0)
			FROM @EmployeeConfigAndSalaryWithLOP ECS
			     LEFT JOIN (SELECT L.EmployeeId, ECS.EmployeeConfigAndSalaryId, SUM([Count]) PaidLeaves
				            FROM @Leaves L
							     INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.employeeId
							WHERE IsPaid = 1
							      AND L.[Date] BETWEEN (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveFrom ELSE EmployeeSalaryActiveFrom END)
											   AND (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveTo ELSE EmployeeSalaryActiveTo END)
								  AND L.EmployeeId = @LOPEmployeeId
							GROUP BY L.EmployeeId, ECS.EmployeeConfigAndSalaryId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId
			WHERE ECS.EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET UnPaidLeaves = ISNULL(ECSInner.UnPaidLeaves,0)
			FROM @EmployeeConfigAndSalaryWithLOP ECS
			     LEFT JOIN (SELECT L.EmployeeId, ECS.EmployeeConfigAndSalaryId, SUM([Count]) UnPaidLeaves
				            FROM @Leaves L
							     INNER JOIN @EmployeeConfigAndSalaryWithLOP ECS ON ECS.EmployeeId = L.employeeId
							WHERE IsPaid = 0
							      AND L.[Date] BETWEEN (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveFrom ELSE EmployeeSalaryActiveFrom END)
											   AND (CASE WHEN ECS.IsConfigDates = 1 THEN EmployeePayrollConfigurationActiveTo ELSE EmployeeSalaryActiveTo END)
								  AND L.EmployeeId = @LOPEmployeeId
							GROUP BY L.EmployeeId, ECS.EmployeeConfigAndSalaryId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId
			WHERE ECS.EmployeeId = @LOPEmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET MinPaidLeaves = ECSInner.PaidLeaves, MinUnPaidLeaves = ECSInner.UnPaidLeaves
			FROM @EmployeeConfigAndSalaryWithLOP ECS 
			     INNER JOIN (SELECT ESC.EmployeeId, ESC.PaidLeaves, ESC.UnPaidLeaves 
				             FROM @EmployeeConfigAndSalaryWithLOP ESC
							      INNER JOIN (SELECT EmployeeId, MIN(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM @EmployeeConfigAndSalaryWithLOP WHERE EmployeeId = @LOPEmployeeId GROUP BY EmployeeId) ESCInInner 
								                     ON ESCInInner.EmployeeId = ESC.EmployeeId AND ESCInInner.EmployeeConfigAndSalaryId = ESC.EmployeeConfigAndSalaryId
				                 ) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN PaidLeaves ELSE AllowedLeaves END
			FROM @EmployeeConfigAndSalaryWithLOP ECS 
			     INNER JOIN (SELECT EmployeeId, MIN(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM @EmployeeConfigAndSalaryWithLOP WHERE EmployeeId = @LOPEmployeeId GROUP BY EmployeeId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId

			UPDATE @EmployeeConfigAndSalaryWithLOP SET AllowedLeaves = CASE WHEN AllowedLeaves - ISNULL(MinPaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(MinPaidLeaves,0) ELSE 0 END
			FROM @EmployeeConfigAndSalaryWithLOP ECS 
			     INNER JOIN (SELECT EmployeeId, MAX(EmployeeConfigAndSalaryId) EmployeeConfigAndSalaryId FROM @EmployeeConfigAndSalaryWithLOP WHERE EmployeeId = @LOPEmployeeId GROUP BY EmployeeId) ECSInner ON ECSInner.EmployeeId = ECS.EmployeeId AND ECSInner.EmployeeConfigAndSalaryId = ECS.EmployeeConfigAndSalaryId

		END

		SET @LOPEmployeesCounter = @LOPEmployeesCounter + 1

	END
	--Loss Of Pay End
	
	--Components calculation Start
	SELECT EmployeeId,
	       EmployeeName,
		   PayrollTemplateId,
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
		   TotalWorkingDays,
		   LeavesTaken,
		   UnplannedHolidays,
		   SickDays,
		   WorkedDays,
		   PlannedHolidays,
		   LossOfPay,
		   IsInResignation,
		   TotalLeaves,
		   PaidLeaves,
		   UnPaidLeaves,
		   AllowedLeaves,
		   IsLossOfPayMonth,
		   EmployeeConfigAndSalaryId,
		   NULL LastPeriodPayrollComponentAmount,
		   NULL LastPeriodSalary,
		   NULL LastPeriodLossOfPay,
		   NULL ActualLastPeriodPayrollComponentAmount,
		   NULL ActualLastPeriodSalary,
		   CAST(0.00 AS FLOAT) EncashedLeaves,
		   NULL TotalAmountPaid,
		   NULL LoanAmountRemaining
	INTO #Payroll
	FROM (

	SELECT *,
	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (WorkedDays) END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN EmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,EmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (WorkedDays) END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (WorkedDays) * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (WorkedDays) * PercentageValue ELSE (EmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END PayrollComponentAmount,

	       CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (WorkedDays - LossOfPay) END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN ActualEmployeeSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,ActualEmployeeSalary,@RunStartDate,@RunEndDate,EmployeeId) ELSE ((Amount*1.0)/@TotalWorkingDays) * (WorkedDays - LossOfPay) END) END) 
		        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (WorkedDays - LossOfPay) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) 
				                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN ((DependentAmount*1.0)/@TotalWorkingDays) * (WorkedDays - LossOfPay) * PercentageValue ELSE (ActualEmployeeSalary * PercentageValue * DependentPercentageValue) END) END) END) 
		   END ActualPayrollComponentAmount
	FROM (

	SELECT *,
	       CASE WHEN ResignationLastDate IS NOT NULL THEN ROUND((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) * OneDaySalary ),0)
		        WHEN JoinedDate > @RunStartDate THEN ROUND(((DATEDIFF(DAY,JoinedDate,@RunEndDate) + 1) * OneDaySalary ),0)
		        ELSE ROUND((OneDaySalary * SalaryDays),0) END EmployeeSalary,

	       CASE WHEN LossOfPay > 0 THEN (CASE WHEN ResignationLastDate IS NOT NULL THEN ROUND(((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) - LossOfPay) * OneDaySalary),0) 
		                                      WHEN JoinedDate >= @RunStartDate THEN ROUND(((DATEDIFF(DAY,JoinedDate,@RunEndDate) - LossOfPay) * OneDaySalary),0) 
		                                      ELSE ROUND(((SalaryDays - LossOfPay) * OneDaySalary),0) END)
		        WHEN ResignationLastDate IS NOT NULL THEN ROUND((DATEDIFF(DAY,@RunStartDate,ResignationLastDate) * OneDaySalary ),0) -- Only for correct PF calculation for resignated employee
				WHEN JoinedDate > @RunStartDate THEN ROUND((DATEDIFF(DAY,JoinedDate,@RunEndDate) * OneDaySalary ),0)
				ELSE ROUND((OneDaySalary * SalaryDays),0)
		   END ActualEmployeeSalary
	FROM (

	SELECT TFinalInner.*,
	       U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
		   (ECS.Amount - ISNULL(ECS.NetPayAmount,0))*1.0 EmployeePackage,
		   ROUND(((((ECS.Amount - ISNULL(ECS.NetPayAmount,0))*1.0)/12.0)/@TotalWorkingDays),2) OneDaySalary,
		   CASE WHEN IsLossOfPayMonth = 1 THEN Salarydays - ISNULL(LossOfPay,0) ELSE Salarydays END WorkedDays
	FROM (

	SELECT TInner.*,
	       DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
	       CASE WHEN Job.JoinedDate >= @RunStartDate THEN DATEDIFF(DAY,Job.JoinedDate,@RunEndDate) + 1 ELSE @TotalWorkingDays END TotalWorkingDays,
		   LeavesTaken,
		   UnplannedHolidays,
		   SickDays,
		   CASE WHEN IsLossOfPayMonth = 1 THEN ROUND(ISNULL(UnPaidLeaves,0),2) ELSE 0 END LossOfPay,
		   --ROUND((ISNULL(UnPaidLeaves,0) + ISNULL((CASE WHEN IsLossOfPayMonth = 1 AND AllowedLeaves < PaidLeaves THEN PaidLeaves - AllowedLeaves ELSE 0 END),0)),2) LossOfPay,
		   PlannedHolidays,
		   AllowedLeaves,
		   TotalLeaves,
		   PaidLeaves,
		   UnPaidLeaves,
		   IsLossOfPayMonth,
		   CASE WHEN ER.Id IS NULL THEN 0 ELSE 1 END IsInResignation,
		   ER1.LastDate ResignationLastDate,
		   Job.JoinedDate
	FROM (

	SELECT E.Id EmployeeId,
	       ECS.PayrollTemplateId,
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
		   ECS.Id EmployeeConfigAndSalaryId,
		   CASE WHEN ECS.IsConfigDates = 1 THEN (CASE WHEN EmployeepayrollConfigurationActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeepayrollConfigurationActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeepayrollConfigurationActiveFrom,@RunEndDate) + 1 END)
		                                   ELSE (CASE WHEN EmployeeSalaryActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeeSalaryActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeeSalaryActiveFrom,@RunEndDate) + 1 END)
		   END Salarydays
	FROM Employee E 
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        )   
		 INNER JOIN #EmployeeConfigAndSalary ECS ON ECS.EmployeeId = E.Id
		 INNER JOIN PayrollTemplate PT ON PT.Id = ECS.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	UNION ALL

	SELECT E.Id EmployeeId,
	       ECS.PayrollTemplateId,
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
		   ECS.Id EmployeeConfigAndSalaryId,
		   CASE WHEN ECS.IsConfigDates = 1 THEN (CASE WHEN EmployeepayrollConfigurationActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeepayrollConfigurationActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeepayrollConfigurationActiveFrom,@RunEndDate) + 1 END)
		                                   ELSE (CASE WHEN EmployeeSalaryActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeeSalaryActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeeSalaryActiveFrom,@RunEndDate) + 1 END)
		   END Salarydays
	FROM Employee E 
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        ) 
		 INNER JOIN #EmployeeConfigAndSalary ECS ON ECS.EmployeeId = E.Id
		 INNER JOIN PayrollTemplate PT ON PT.Id = ECS.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	UNION ALL

	SELECT E.Id EmployeeId,
	       ECS.PayrollTemplateId,
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
		   ECS.Id EmployeeConfigAndSalaryId,
		   CASE WHEN ECS.IsConfigDates = 1 THEN (CASE WHEN EmployeepayrollConfigurationActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeepayrollConfigurationActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeepayrollConfigurationActiveFrom,@RunEndDate) + 1 END)
		                                   ELSE (CASE WHEN EmployeeSalaryActiveTo IS NOT NULL THEN DATEDIFF(DAY,@RunStartDate,EmployeeSalaryActiveTo) + 1 ELSE DATEDIFF(DAY,EmployeeSalaryActiveFrom,@RunEndDate) + 1 END)
		   END Salarydays
	FROM Employee E 
	     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        ) 
		 INNER JOIN #EmployeeConfigAndSalary ECS ON ECS.EmployeeId = E.Id
		 INNER JOIN PayrollTemplate PT ON PT.Id = ECS.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	) TInner

	  LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = TInner.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = TInner.EmployeeConfigAndSalaryId
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
	                      AND (@EmploymentStatusIds IS NULL OR J.EmploymentStatusId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmploymentStatusIds)))

	) TFinalInner

	  INNER JOIN Employee E ON E.Id = TFinalInner.EmployeeId
	  INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	  INNER JOIN #EmployeeConfigAndSalary ECS ON ECS.EmployeeId = E.Id AND ECS.Id = EmployeeConfigAndSalaryId

	) TOuter

	) TFinalOuter

	)TFinalOuterOuter

	WHERE EmployeeId NOT IN (SELECT EmployeeId FROM EmployeeResignation ER INNER JOIN ResignationStatus RS ON RS.Id = ER.ResignationStastusId 
	                         WHERE ER.InActiveDateTime IS NULL AND ER.LastDate < @RunStartDate AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL)
							
	--UPDATE #Payroll SET PayrollComponentAmount = 0, ActualpayrollComponentAmount = 0, Earning = 0, Deduction = 0, ActualEarning = 0, ActualDeduction = 0 
	--WHERE PayrollComponentName IN ('Employee ESI','Employeer ESI') AND WorkedDays < 15 -- ESI condition check for middle joiners

	--Components calculation End

	SELECT ROW_NUMBER() OVER (ORDER BY EmployeeId) Id,
	       EmployeeId,
		   EmployeeConfigAndSalaryId
	INTO #Employee
	FROM #Payroll
	GROUP BY EmployeeId,EmployeeConfigAndSalaryId

	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @UserId UNIQUEIDENTIFIER, @EmployeeConfigAndSalaryId INT, @IsEqual BIT, @Earning FLOAT, @RelatedToPtAmount FLOAT, @RelatedToPTValue FLOAT, @RelatedToPtActualAmount FLOAT, @RelatedToPTActualValue FLOAT, @ActualEarning FLOAT, 
	        @EmployeeBonus FLOAT, @OtherAllowanceId UNIQUEIDENTIFIER, @OtherAllowanceName NVARCHAR(50), @BonusId UNIQUEIDENTIFIER, @BonusName NVARCHAR(50), @EmployerPF FLOAT, @EmployerESI FLOAT, @ActualEmployerPF FLOAT, 
			@ActualEmployerESI FLOAT,@LeaveEncashmentId UNIQUEIDENTIFIER, @LeaveEncashmentName NVARCHAR(50), @LeaveEncashmentSetting UNIQUEIDENTIFIER, @RemainingLeaves FLOAT, @RemainingLeavesValue FLOAT, @ActualRemainingLeavesValue FLOAT,
			@TaxId UNIQUEIDENTIFIER, @TaxName NVARCHAR(50), @TaxAmount FLOAT, @TaxYear INT, @EmployeeBranchId UNIQUEIDENTIFIER, @TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT,@LeaveEncashmentStartDate DATE,@LeaveEncashmentEndDate DATE,
			@OneDaySalary FLOAT, @ActualOneDaySalary FLOAT, @EligibleLeaves FLOAT, @PaidLeaves FLOAT, @LeaveEncashmentFinancialYearFromMonth INT, @LeaveEncashmentFinancialYearToMonth INT, @LeaveEncashmentSettingPercentage FLOAT,
			@JoiningDate DATE, @JoinedMonths INT, @JoinedQuarters INT, @TaxFinancialFromYear INT, @TaxFinancialToYear INT, @TaxFinancialYearFromDate DATE, @TaxFinancialYearToDate DATE, @EmployerShare FLOAT, @ActualEmployerShare FLOAT,
			@LoanId UNIQUEIDENTIFIER, @LoanName NVARCHAR(50), @LoanAmount FLOAT, @EmployeeCountryId UNIQUEIDENTIFIER,
			@TaxPaidCount INT, @TaxPayableCount INT, @LeaveEncashmentFinancialFromYear INT, @LeaveEncashmentFinancialToYear INT, @LeaveEncashmentFinancialYearFromDate DATE, @LeaveEncashmentFinancialYearToDate DATE, @MaxEncashedLeaves FLOAT

	SELECT @EmployeesCount = COUNT(1) FROM #Employee

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		SELECT @EmployeeBranchId = NULL, @RelatedToPTValue = NULL, @RelatedToPTActualValue = NULL, @RemainingLeaves = NULL,
		       @TaxPeriodType = NULL, @LeaveEncashmentPeriodType = NULL, @TaxFinancialYearFromMonth = NULL, @TaxFinancialYearToMonth = NULL,
			   @LeaveEncashmentFinancialYearFromMonth = NULL, @LeaveEncashmentFinancialYearToMonth =  NULL,
			   @TaxPaidCount = 0, @TaxPayableCount = 0

		SELECT @EmployeeId = EmployeeId, @EmployeeConfigAndSalaryId = EmployeeConfigAndSalaryId FROM #Employee WHERE Id = @EmployeesCounter
		SELECT @UserId = UserId FROM @LOPEmployee WHERE EmployeeId = @EmployeeId
		SELECT @EmployerPF = PayrollComponentAmount, @ActualEmployerPF = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND PayrollComponentName = 'Employeer PF' AND IsDeduction = 0
		SELECT @EmployerESI = PayrollComponentAmount, @ActualEmployerESI = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND PayrollComponentName = 'Employeer ESI' AND IsDeduction = 0

		SELECT @EmployerShare = SUM(P.PayrollComponentAmount), @ActualEmployerShare = SUM(P.ActualPayrollComponentAmount) 
		FROM #Payroll P INNER JOIN PayrollComponent PC ON PC.Id = P.PayrollComponentId
		WHERE P.EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND P.IsDeduction = 0 AND PC.EmployerContributionPercentage IS NOT NULL

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

		SELECT @LeaveEncashmentPeriodType = PT.PeriodTypeName
		FROM PayRollCalculationConfigurations PCC 
		     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
			 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
		WHERE PCT.PayRollCalculationTypeName = 'Leave encashment' AND PCC.InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId
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

		SELECT @LeaveEncashmentFinancialYearFromMonth = FromMonth, @LeaveEncashmentFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
		WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @LeavesFinancialYearTypeId
		      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		SELECT @TaxPeriodType = ISNULL(@TaxPeriodType,'Every month'), 
		       @LeaveEncashmentPeriodType = ISNULL(@LeaveEncashmentPeriodType,'Yearly'), 
			   @TaxFinancialYearFromMonth = ISNULL(@TaxFinancialYearFromMonth,4), 
			   @TaxFinancialYearToMonth = ISNULL(@TaxFinancialYearToMonth,3),
			   @LeaveEncashmentFinancialYearFromMonth = ISNULL(@LeaveEncashmentFinancialYearFromMonth,1), 
			   @LeaveEncashmentFinancialYearToMonth =  ISNULL(@LeaveEncashmentFinancialYearToMonth,12)

		SELECT @TaxFinancialFromYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @TaxFinancialToYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT @TaxFinancialYearFromDate = DATEFROMPARTS(@TaxFinancialFromYear,@TaxFinancialYearFromMonth,1), @TaxFinancialYearToDate = EOMONTH(DATEFROMPARTS(@TaxFinancialToYear,@TaxFinancialYearToMonth,1))

		SELECT @LeaveEncashmentFinancialFromYear = CASE WHEN @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @LeaveEncashmentFinancialToYear = CASE WHEN @PayrollRunMonth - @LeaveEncashmentFinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT @LeaveEncashmentFinancialYearFromDate = DATEFROMPARTS(@LeaveEncashmentFinancialFromYear,@LeaveEncashmentFinancialYearFromMonth,1), 
		        @LeaveEncashmentFinancialYearToDate = EOMONTH(DATEFROMPARTS(@LeaveEncashmentFinancialToYear,@LeaveEncashmentFinancialYearToMonth,1))

		IF(@LeaveEncashmentFinancialYearToDate = EOMONTH(@RunEndDate))
		BEGIN
			
			SELECT @MaxEncashedLeaves = ISNULL((SELECT SUM(MaxEncashedLeavesCount) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,NULL,@LeaveEncashmentFinancialYearFromDate,@LeaveEncashmentFinancialYearToDate)),0)

		END

		SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId

		SELECT @JoinedMonths = DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1, @JoinedQuarters = CEILING((DATEDIFF(MONTH,@JoiningDate,@TaxFinancialYearToDate) + 1)/3.0)

		SELECT @TaxYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END

		-- Other Allowance calculation Start
		SELECT @IsEqual = CASE WHEN SUM(ActualEarning) = ActualEmployeeSalary OR SUM(ActualEarning) + 5 >=  ActualEmployeeSalary OR SUM(ActualEarning) >= ActualEmployeeSalary + 5 THEN 1 ELSE 0 END, 
		                  @ActualEarning = ActualEmployeeSalary - SUM(ActualEarning), @Earning = EmployeeSalary - SUM(Earning)
		FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId GROUP BY EmployeeId,EmployeeSalary,ActualEmployeeSalary

		IF(@IsEqual = 0)
		BEGIN
			
			SELECT @OtherAllowanceId = Id, @OtherAllowanceName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Other Allowance' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,P.EmployeeName,P.PayrollTemplateId,@OtherAllowanceId,@OtherAllowanceName,0,P.EmployeeSalary,P.ActualEmployeeSalary,P.OneDaySalary,0,@Earning,@ActualEarning,@Earning,NULL,@ActualEarning,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
			WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

		END
		-- Other Allowance calculation End

		--Employee Bonus calculation Start
		DROP TABLE IF EXISTS dbo.Bonus

		DECLARE @Bonus TABLE  
		(
			Bonus FLOAT
		)

		INSERT INTO @Bonus
		SELECT CASE WHEN Bonus IS NOT NULL THEN NULL ELSE (CASE WHEN IsCtcType = 1 THEN ROUND(((SELECT TOP 1 EmployeeSalary FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId) * Percentage * 0.01),0)
		                                                                            ELSE ROUND(((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND PayrollComponentId = EB.PayrollComponentId) * Percentage * 0.01),0) END)
				END Bonus
		FROM EmployeeBonus EB
		WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0 AND IsApproved = 1

		DECLARE @EmployeeManualBonus FLOAT, @MaxEmployeeConfigAndSalaryId INT 

		SELECT @EmployeeManualBonus = SUM(CASE WHEN Bonus IS NOT NULL THEN Bonus END)
		FROM EmployeeBonus 
		WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0 AND IsApproved = 1

		SELECT @MaxEmployeeConfigAndSalaryId = MAX(EmployeeConfigAndSalaryId) FROM #Payroll WHERE EmployeeId = @EmployeeId

		SELECT @EmployeeBonus = SUM(Bonus) FROM @Bonus

		IF((@EmployeeBonus IS NOT NULL AND @EmployeeBonus > 0) OR (@EmployeeManualBonus IS NOT NULL AND @EmployeeManualBonus > 0))
		BEGIN
			
			SELECT @BonusId = Id, @BonusName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Bonus' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@BonusId,@BonusName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@EmployeeBonus,@EmployeeBonus,@EmployeeBonus,NULL,@EmployeeBonus,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
			WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId
			
			IF(@EmployeeConfigAndSalaryId = @MaxEmployeeConfigAndSalaryId)
			BEGIN
			
				UPDATE #Payroll SET PayrollComponentAmount = ISNULL(PayrollComponentAmount,0) + ISNULL(@EmployeeManualBonus,0), ActualPayrollComponentAmount = ISNULL(ActualPayrollComponentAmount,0) + ISNULL(@EmployeeManualBonus,0), 
				                    Earning = ISNULL(Earning,0) + ISNULL(@EmployeeManualBonus,0), ActualEarning = ISNULL(ActualEarning,0) + ISNULL(@EmployeeManualBonus,0)
				WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @MaxEmployeeConfigAndSalaryId AND PayrollComponentId = @BonusId

			END

		END
		--Employee Bonus calculation End
		
		----Leave encashment calculations Start
		IF(@LeaveEncashmentPeriodType = 'Every month')
		BEGIN

			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LeaveEncashmentEndDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0) ) )
			--SELECT @LeaveEncashmentStartDate = @RunStartDate, @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)
			
			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)
			
			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Every quarter' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-2,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-2,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Every halfyearly' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-5,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-5,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Yearly' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-11,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-11,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 10) -- Last quarter first month
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-9,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-11,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND ((FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 11 OR (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 12)) -- Last quarter second and third months
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = @RunStartDate, @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01,
			@IsEncashCtcType = CASE WHEN IsCTCType = 1 THEN 1 WHEN PayrollComponentId IS NOT NULL THEN  0 ELSE NULL END FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			IF(@IsEncashCtcType IS NULL)
			BEGIN
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId))
			END
			SELECT @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END

		----Leave encashment calculations End

		--IsRelatedToPt calculation Start
		SELECT @RelatedToPtAmount = SUM(Earning) - ISNULL(@EmployerShare,0), --ISNULL(@EmployerPF,0) - ISNULL(@EmployerESI,0), --SUM(Earning) + SUM(Deduction), 
		       @RelatedToPtActualAmount = SUM(ActualEarning) - ISNULL(@ActualEmployerShare,0) --ISNULL(@ActualEmployerPF,0) - ISNULL(@ActualEmployerESI,0) --SUM(ActualEarning) + SUM(ActualDeduction),
		FROM #Payroll WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId
		
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
		WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND IsRelatedToPt = 1

		UPDATE #Payroll SET Earning = ROUND((CASE WHEN IsDeduction = 0 THEN PayrollComponentAmount END),0), Deduction = ROUND((CASE WHEN IsDeduction = 1 THEN PayrollComponentAmount END),0),
		                    ActualEarning = ROUND((CASE WHEN IsDeduction = 0 THEN ActualPayrollComponentAmount END),0), ActualDeduction = ROUND((CASE WHEN IsDeduction = 1 THEN ActualPayrollComponentAmount END),0)
		WHERE EmployeeId = @EmployeeId AND EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId AND IsRelatedToPt = 1
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

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

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

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

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

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

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

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		ELSE IF(@TaxPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @TaxFinancialYearFromMonth) % 12) / 3 ) + 1) = 4)
		BEGIN
			
			SELECT @TaxId = Id, @TaxName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Tax' AND InActiveDateTime IS NULL
			
			SELECT @TaxAmount = CASE WHEN @JoinedMonths > 3 THEN ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/3.0,0),0) 
			                         ELSE ROUND(ISNULL(([dbo].[Ufn_GetEmployeeTaxableAmount](@EmployeeId,@TaxYear,@TaxFinancialYearFromDate,@TaxFinancialYearToDate,@RunStartDate,@RunEndDate,@EmployeeBonus,@RemainingLeavesValue))/(@JoinedMonths * 1.0),0),0) END

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
				WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

			END

		END
		----Tax calculation End

		----Loan calculation Start	
		SELECT @LoanAmount = SUM(InstallmentAmount)
		FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
		WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
		      AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
			  AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL

		IF(@LoanAmount > 0 AND @LoanAmount IS NOT NULL AND (SELECT TOP 1 IsInResignation FROM #Payroll WHERE EmployeeId = @EmployeeId) <> 1)
		BEGIN

			SELECT @LoanId = Id, @LoanName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Office Loan EMI' AND InActiveDateTime IS NULL

			UPDATE EmployeeLoanInstallment SET IsTobePaid = NULL
			FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
			WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
			      AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
				  AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL
			
			UPDATE EmployeeLoan SET LoanBalanceAmount = ELInner.LoanBalanceAmount
			FROM EmployeeLoan EL 
			     INNER JOIN (SELECT EmployeeLoanId, SUM(InstallmentAmount) LoanBalanceAmount
							 FROM EmployeeLoanInstallment
							 WHERE EmployeeLoanId IN (SELECT EL.Id
							 						  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
							 						  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
							 						        AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
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
							 						        AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
															AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
							       AND IsTobePaid IS NULL AND IsArchived = 0
							GROUP BY EmployeeLoanId) ELInner ON ELInner.EmployeeLoanId = EL.Id

			DECLARE @LoanBalanceAmount FLOAT = (SELECT SUM(InstallmentAmount)
												FROM EmployeeLoanInstallment ELI INNER JOIN EmployeeLoan EL ON EL.Id = ELI.EmployeeLoanId
												WHERE EmployeeLoanId IN (SELECT EL.Id
																		  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
																		  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
																		        AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
																			AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
												      AND IsTobePaid = 1 AND IsArchived = 0
												      AND EL.EmployeeId = @EmployeeId)

		     DECLARE @LoanTotalPaidAmount FLOAT = (SELECT SUM(InstallmentAmount) LoanTotalPaidAmount
												   FROM EmployeeLoanInstallment ELI INNER JOIN EmployeeLoan EL ON EL.Id = ELI.EmployeeLoanId
												   WHERE EmployeeLoanId IN (SELECT EL.Id
												   						  FROM EmployeeLoan EL INNER JOIN EmployeeLoanInstallment ELI ON ELI.EmployeeLoanId = EL.Id
												   						  WHERE EL.EmployeeId = @EmployeeId AND ELI.IsArchived = 0
												   						        AND ELI.InstalmentDate BETWEEN @RunStartDate AND @RunEndDate
												   							AND EL.IsApproved = 1 AND EL.InactiveDateTime IS NULL)
												         AND IsTobePaid IS NULL AND IsArchived = 0
												         AND EL.EmployeeId = @EmployeeId)

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LoanId,@LoanName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@LoanAmount,-@LoanAmount,NULL,-@LoanAmount,NULL,-@LoanAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
			             @TotalWorkingDays TotalWorkingDays,ECSL.LeavesTaken,ECSL.UnplannedHolidays,ECSL.SickDays,P.WorkedDays WorkedDays,ECSL.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,P.EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,@LoanTotalPaidAmount,@LoanBalanceAmount
			FROM #Payroll P LEFT JOIN @EmployeeConfigAndSalaryWithLOP ECSL ON ECSL.EmployeeId = P.EmployeeId AND ECSL.EmployeeConfigAndSalaryId = P.EmployeeConfigAndSalaryId
			WHERE P.EmployeeId = @EmployeeId AND P.EmployeeConfigAndSalaryId = @EmployeeConfigAndSalaryId

		END
		----Loan calculation End

		IF(@EmployeeConfigAndSalaryId = @MaxEmployeeConfigAndSalaryId)
		BEGIN
		
			UPDATE Temp_PayrollRun SET ProcessedEmployees = ISNULL(ProcessedEmployees,0) + ISNULL(@ProcessedEmployeesWeightage,0) WHERE Id = @NewPayrollRunId

		END

		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	SET @EmployeesCounter = 1

	UPDATE #Payroll SET PayrollComponentAmount = 0, ActualPayrollComponentAmount = 0, Deduction = 0, ActualDeduction = 0
	WHERE EmployeeConfigAndSalaryId NOT IN (SELECT MAX(EmployeeConfigAndSalaryId) FROM #Payroll WHERE PayrollComponentId = @TaxId)
	      AND PayrollComponentId = @TaxId -- Duplicate tax is removed from payroll amounts

	UPDATE #Payroll SET TotalAmountPaid = 0, LoanAmountRemaining = 0
	WHERE EmployeeConfigAndSalaryId NOT IN (SELECT MAX(EmployeeConfigAndSalaryId) FROM @EmployeeConfigAndSalaryWithLOP WHERE EmployeeId = @EmployeeId)
	      AND EmployeeId = @EmployeeId AND PayrollComponentId = @LoanId -- Duplicate loan details is removed from payroll amounts

	--UPDATE #Payroll SET PayrollComponentAmount = 0, ActualPayrollComponentAmount = 0, Deduction = 0, ActualDeduction = 0
	--FROM #Payroll P INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollComponentId = P.PayrollComponentId AND PTC.PayrollTemplateId = P.PayrollTemplateId
	--WHERE EmployeeConfigAndSalaryId NOT IN (SELECT MAX(EmployeeConfigAndSalaryId) FROM #Payroll P INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollComponentId = P.PayrollComponentId AND PTC.PayrollTemplateId = P.PayrollTemplateId WHERE PTC.Amount IS NOT NULL)
	--      AND PTC.Amount IS NOT NULL -- Duplicate amount is removed from payroll amounts

	SELECT * FROM #Payroll 
	ORDER BY EmployeeName,EmployeeSalary,IsDeduction
	

END
GO


--EXEC [USP_ProducePayrollComponentsForMiddleHikeEmployees] '2C037AEE-4397-4F45-A261-A794A802B2D1',NULL,NULL,'2020-03-01','2020-03-31'
--EXEC [USP_ProducePayrollComponentsForMiddleHikeEmployees] '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-06-01','2020-06-30'