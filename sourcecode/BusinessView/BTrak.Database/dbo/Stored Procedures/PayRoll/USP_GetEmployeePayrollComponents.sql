CREATE PROCEDURE [dbo].[USP_GetEmployeePayrollComponents]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@EmployeeId UNIQUEIDENTIFIER NULL
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate) ,@TaxPeriodType NVARCHAR(100), @LossOfPayPeriodType NVARCHAR(100), @LeaveEncashmentPeriodType NVARCHAR(100)
	DECLARE @LossOfPayStartDate DATE, @LossOfPayEndDate DATE,@LOPEmployeesCount INT, @LOPEmployeesCounter INT = 1, @LOPEmployeeId UNIQUEIDENTIFIER,@LOPEmployeeBranchId UNIQUEIDENTIFIER, @LOPUserId UNIQUEIDENTIFIER,  
	        @LOPFinancialYearFromMonth INT, @LOPFinancialYearToMonth INT, @TaxFinancialYearTypeId UNIQUEIDENTIFIER, @LeavesFinancialYearTypeId UNIQUEIDENTIFIER, @LOPFinancialYearFromDate DATE, @LOPFinancialYearToDate DATE, 
			@LOPFinancialFromYear INT, @LOPFinancialToYear INT, @LeaveEncashmentPeriodTypeForLop NVARCHAR(100),
			@ProcessedEmployeesWeightage FLOAT, @LOPEmployeeCountryId UNIQUEIDENTIFIER

	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'
	SELECT @LeavesFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Leaves'

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
		IsLossOfPayMonth BIT
	)
	
	INSERT INTO #LeaveEmployee(EmployeeId,UserId,BranchId)
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
	WHERE U.CompanyId = @CompanyId AND U.IsActive = 1
	      AND E.Id = @EmployeeId

	SELECT @LOPEmployeesCount = COUNT(1) FROM #LeaveEmployee

	WHILE(@LOPEmployeesCounter <= @LOPEmployeesCount)
	BEGIN

		SELECT @LOPEmployeeId = EmployeeId, @LOPUserId = UserId, @LOPEmployeeBranchId = BranchId FROM #LeaveEmployee WHERE Id = @LOPEmployeesCounter
		SELECT @LossOfPayStartDate = NULL, @LossOfPayEndDate = NULL, @LossOfPayPeriodType = NULL, 
		       @LeaveEncashmentPeriodTypeForLop = NULL, @LOPFinancialYearFromMonth = NULL, @LOPFinancialYearToMonth = NULL

		SELECT @LOPEmployeeCountryId = CountryId FROM Branch WHERE Id = @LOPEmployeeBranchId

		SELECT @LossOfPayPeriodType = PT.PeriodTypeName
		FROM PayRollCalculationConfigurations PCC 
		     INNER JOIN [PayRollCalculationType] PCT ON PCT.Id = PCC.PayRollCalculationTypeId
			 INNER JOIN [PeriodType] PT ON PT.Id = PCC.PeriodTypeId
		WHERE PCT.PayRollCalculationTypeName = 'Loss of pay' AND PCC.InActiveDateTime IS NULL AND BranchId = @LOPEmployeeBranchId
		        AND ((PCC.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN PCC.ActiveFrom AND PCC.ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
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
	
		UPDATE #LeaveEmployee SET TotalLeaves = [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](@LOPUserId,@LOPFinancialYearFromDate,@LOPFinancialYearToDate,1) 
		WHERE EmployeeId = @LOPEmployeeId

		IF(@LossOfPayPeriodType = 'Every month')
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0)
			       ,@LossOfPayEndDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0) ) )
			--SELECT @LossOfPayStartDate = @RunStartDate, @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId
			
			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every month' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END
		ELSE IF(@LossOfPayPeriodType = 'Every quarter' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-2,@RunEndDate)) , 0)
			, @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-2,@RunStartDate), @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-3,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId 
												           AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END
		ELSE IF(@LossOfPayPeriodType = 'Every halfyearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-5,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-5,@RunStartDate), @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every halfyearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-5,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END
		ELSE IF(@LossOfPayPeriodType = 'Yearly' AND ABS((@LOPFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-11,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = DATEADD(MONTH,-11,@RunStartDate), @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Yearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-11,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END
		ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) ) + 1) = 10) -- Last quarter first month
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-9,@RunEndDate)) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = @LOPFinancialYearFromMonth, @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END
		ELSE IF(@LossOfPayPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LOPFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND ((FLOOR(((12 + 12 - 3) % 12) ) + 1) = 11 OR (FLOOR(((12 + 12 - 3) % 12) ) + 1) = 12)) -- Last quarter second and third months
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LossOfPayEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LossOfPayStartDate = @RunStartDate, @LossOfPayEndDate = @RunEndDate

			UPDATE #LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE #LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN #LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE #LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM #LeaveEmployee LE 
					 LEFT JOIN (SELECT PRE.EmployeeId, CASE WHEN AllowedLeaves - ISNULL(PaidLeaves,0) > 0 THEN AllowedLeaves - ISNULL(PaidLeaves,0) ELSE 0 END AllowedLeaves
								FROM PayrollRunEmployee PRE
									 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
				                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						                         FROM PayrollRunEmployee PRE 
						                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
													  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId --AND PS.PayrollStatusName = 'Paid' 
													  AND PR.InactiveDateTime IS NULL
												 WHERE DATEADD(MONTH, DATEDIFF(MONTH, 0, PayrollEndDate), 0) = DATEADD(MONTH,-1,DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate), 0))
												       AND PayrollEndDate BETWEEN @LOPFinancialYearFromDate AND @LOPFinancialYearToDate
						                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
								) LEInner ON LEInner.EmployeeId = LE.EmployeeId
				WHERE LE.EmployeeId =  @LOPEmployeeId

			END

		END

		SET @LOPEmployeesCounter = @LOPEmployeesCounter + 1

	END
	--Loss Of Pay End
	
	DECLARE @SalaryId UNIQUEIDENTIFIER = (SELECT Id FROM EmployeeSalary EB 
	                                      WHERE EB.EmployeeId = @EmployeeId 
												 AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
												       OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
														  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
												     ))

	IF(@SalaryId IS NULL) 
		SELECT TOP 1 @SalaryId = Id FROM EmployeeSalary WHERE EmployeeId = @EmployeeId AND ActiveFrom < @RunStartDate ORDER BY CreatedDateTime DESC

	IF(@SalaryId IS NULL) 
		SELECT TOP 1 @SalaryId = Id FROM EmployeeSalary WHERE EmployeeId = @EmployeeId AND ActiveFrom > @RunStartDate ORDER BY CreatedDateTime

	CREATE TABLE #ProfessionalTaxRange
	(
	    [FromRange] Decimal(18,4), 
	    [ToRange] Decimal(18,4), 
	    [TaxAmount] Decimal(18,4)
	)

	INSERT INTO #ProfessionalTaxRange VALUES(0.0000,15000.0000,0.0000)
	INSERT INTO #ProfessionalTaxRange VALUES(15001.0000,20000.0000,150.0000)
	INSERT INTO #ProfessionalTaxRange VALUES(20001.0000,NULL,200.0000)

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
		   NULL EmployeeConfigAndSalaryId,
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
	       PT.Id PayrollTemplateId,
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
		   NULL SalaryId
	FROM Employee E 
		 INNER JOIN PayrollTemplate PT ON PT.PayrollName = 'Template For India' AND CompanyId = @CompanyId AND PT.InactiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND E.Id = @EmployeeId

	UNION

	SELECT E.Id EmployeeId,
	       PT.Id PayrollTemplateId,
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
		   NULL SalaryId
	FROM Employee E 
		 INNER JOIN PayrollTemplate PT ON PT.PayrollName = 'Template For India' AND CompanyId = @CompanyId AND PT.InactiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND E.Id = @EmployeeId

	UNION

	SELECT E.Id EmployeeId,
	       PT.Id PayrollTemplateId,
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
		   NULL SalaryId
	FROM Employee E 
		 INNER JOIN PayrollTemplate PT ON PT.PayrollName = 'Template For India' AND CompanyId = @CompanyId AND PT.InactiveDateTime IS NULL
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND E.Id = @EmployeeId

	) TInner

	  LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = TInner.EmployeeId
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
	  INNER JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL AND ES.Id = @SalaryId

	) TOuter

	) TFinalOuter

	)TFinalOuterOuter

	WHERE EmployeeId NOT IN (SELECT EmployeeId FROM EmployeeResignation ER INNER JOIN ResignationStatus RS ON RS.Id = ER.ResignationStastusId 
	                         WHERE ER.InActiveDateTime IS NULL AND ER.LastDate < @RunStartDate AND RS.StatusName = 'Approved' AND RS.InactiveDateTime IS NULL)
							
	--UPDATE #Payroll SET PayrollComponentAmount = 0, ActualpayrollComponentAmount = 0, Earning = 0, Deduction = 0, ActualEarning = 0, ActualDeduction = 0 
	--WHERE PayrollComponentName IN ('Employee ESI','Employeer ESI') AND WorkedDays < 15 -- ESI condition check for middle joiners

	--Components calculation End

	SELECT ROW_NUMBER() OVER (ORDER BY EmployeeId) Id,
	       EmployeeId ,
		   E.UserId
	INTO #Employee 
	FROM #Payroll P
	     INNER JOIN Employee E ON E.Id = P.EmployeeId
	GROUP BY EmployeeId,E.UserId

	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @UserId UNIQUEIDENTIFIER, @IsEqual BIT, @Earning FLOAT, @RelatedToPtAmount FLOAT, @RelatedToPTValue FLOAT, @RelatedToPtActualAmount FLOAT, @RelatedToPTActualValue FLOAT, @ActualEarning FLOAT, 
	        @EmployeeBonus FLOAT, @OtherAllowanceId UNIQUEIDENTIFIER, @OtherAllowanceName NVARCHAR(50), @BonusId UNIQUEIDENTIFIER, @BonusName NVARCHAR(50), @EmployerPF FLOAT, @EmployerESI FLOAT, @ActualEmployerPF FLOAT, @ActualEmployerESI FLOAT,
			@LeaveEncashmentId UNIQUEIDENTIFIER, @LeaveEncashmentName NVARCHAR(50), @LeaveEncashmentSetting UNIQUEIDENTIFIER, @RemainingLeaves FLOAT, @RemainingLeavesValue FLOAT, @ActualRemainingLeavesValue FLOAT, 
			@TaxId UNIQUEIDENTIFIER, @TaxName NVARCHAR(50), @TaxAmount FLOAT, @TaxYear INT,@EmployeeBranchId UNIQUEIDENTIFIER, @TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT,@LeaveEncashmentStartDate DATE,@LeaveEncashmentEndDate DATE,
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

		SELECT @EmployeeId = EmployeeId, @UserId = UserId FROM #Employee WHERE Id = @EmployeesCounter
		SELECT @EmployerPF = PayrollComponentAmount, @ActualEmployerPF = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentName = 'Employeer PF' AND IsDeduction = 0
		SELECT @EmployerESI = PayrollComponentAmount, @ActualEmployerESI = ActualPayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentName = 'Employeer ESI' AND IsDeduction = 0

		SELECT @EmployerShare = SUM(P.PayrollComponentAmount), @ActualEmployerShare = SUM(P.ActualPayrollComponentAmount) 
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
			
			SELECT @MaxEncashedLeaves = ISNULL((SELECT SUM(MaxEncashedLeavesCount) FROM [dbo].[Ufn_GetCarryForwardAndEncashedLeavesOfAnEmployee](@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentFinancialYearFromDate,@LeaveEncashmentFinancialYearToDate,NULL,0)),0)

		END

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
			SELECT TOP 1 P.EmployeeId,P.EmployeeName,P.PayrollTemplateId,@OtherAllowanceId,@OtherAllowanceName,0,P.EmployeeSalary,P.ActualEmployeeSalary,P.OneDaySalary,0,@Earning,@ActualEarning,@Earning,NULL,@ActualEarning,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		-- Other Allowance calculation End

		--Employee Bonus calculation Start
		
		DROP TABLE IF EXISTS dbo.Bonus

		CREATE TABLE Bonus 
		(
			Bonus FLOAT
		)

		INSERT INTO Bonus
		SELECT CASE WHEN Bonus IS NOT NULL THEN Bonus ELSE (CASE WHEN IsCtcType = 1 THEN ROUND(((SELECT TOP 1 EmployeeSalary FROM #Payroll WHERE EmployeeId = @EmployeeId) * Percentage * 0.01),0)
		                                                                            ELSE ROUND(((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentId = EB.PayrollComponentId) * Percentage * 0.01),0) END)
				END Bonus
		FROM EmployeeBonus EB 
		WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0 AND IsApproved = 1

		SELECT @EmployeeBonus = SUM(Bonus) FROM Bonus

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
		
		----Leave encashment calculations Start
		IF(@LeaveEncashmentPeriodType = 'Every month')
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LeaveEncashmentEndDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0) ) )
			--SELECT @LeaveEncashmentStartDate = @RunStartDate, @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC  

			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)
			
			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Every quarter' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%3 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-2,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-2,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC
			
			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP
			
			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)
			
			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Every halfyearly' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%6 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-5,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-5,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Yearly' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-9,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-11,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 10) -- Last quarter first month
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-9,@RunEndDate)) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = DATEADD(MONTH,-11,@RunStartDate), @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Last quarter' AND (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) / 3 ) + 1) = 4 AND ((FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 11 OR (FLOOR(((12 + @PayrollRunMonth - @LeaveEncashmentFinancialYearFromMonth) % 12) ) + 1) = 12)) -- Last quarter second and third months
		BEGIN
			
			SELECT @LeaveEncashmentStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0), @LeaveEncashmentEndDate = EOMONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0))
			--SELECT @LeaveEncashmentStartDate = @RunStartDate, @LeaveEncashmentEndDate = @RunEndDate

			SELECT @LeaveEncashmentId = Id, @LeaveEncashmentName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Leave Encashment' AND InActiveDateTime IS NULL
			SELECT TOP 1 @LeaveEncashmentSetting = CASE WHEN IsCTCType = 1 THEN NULL ELSE PayrollComponentId END, @LeaveEncashmentSettingPercentage = [Percentage] * 0.01 FROM LeaveEncashmentSettings 
			WHERE InActiveDateTime IS NULL AND BranchId = @EmployeeBranchId 
			      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
						 OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
						 OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			          )
			ORDER BY CreatedDateTime DESC

			SELECT @LeaveEncashmentSetting = ISNULL(@LeaveEncashmentSetting,(SELECT PayrollComponentId FROM #Payroll WHERE PayrollComponentName = 'Basic' AND EmployeeId = @EmployeeId)),
			       @LeaveEncashmentSettingPercentage = ISNULL(@LeaveEncashmentSettingPercentage,1)

			SELECT @EligibleLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@UserId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate)

			SELECT @PaidLeaves = LEP.PaidLeaves
			FROM Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@EmployeeId,@LeaveEncashmentStartDate,@LeaveEncashmentEndDate) LEP

			SELECT @RemainingLeaves = CASE WHEN @EligibleLeaves - ISNULL(@PaidLeaves,0) <= 0 THEN 0 ELSE @EligibleLeaves - ISNULL(@PaidLeaves,0) END, 
			       @OneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((EmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END,
				   @ActualOneDaySalary = CASE WHEN @LeaveEncashmentSetting IS NULL THEN ((ActualEmployeeSalary*1.0)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage ELSE ((SELECT TOP 1 ActualPayrollComponentAmount FROM #Payroll WHERE PayrollComponentId = @LeaveEncashmentSetting AND EmployeeId = @EmployeeId)/TotalWorkingDays)*@LeaveEncashmentSettingPercentage END
		    FROM #Payroll WHERE EmployeeId = @EmployeeId
			
			--SELECT @RemainingLeaves = CASE WHEN ROUND(@RemainingLeaves,2) > ISNULL(@MaxEncashedLeaves,0) THEN ISNULL(@MaxEncashedLeaves,0) ELSE ROUND(@RemainingLeaves,2) END
		    SELECT @RemainingLeaves = @MaxEncashedLeaves

			SELECT @RemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @OneDaySalary,0)),0), @ActualRemainingLeavesValue = ROUND((ISNULL(@RemainingLeaves * @ActualOneDaySalary,0)),0)

			IF(@RemainingLeavesValue IS NOT NULL AND @RemainingLeavesValue > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@LeaveEncashmentId,@LeaveEncashmentName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@RemainingLeavesValue,@RemainingLeavesValue,@RemainingLeavesValue,NULL,@RemainingLeavesValue,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END

		----Leave encashment calculations End

		--IsRelatedToPt calculation Start
		SELECT @RelatedToPtAmount = SUM(Earning) - ISNULL(@EmployerShare,0), --ISNULL(@EmployerPF,0) - ISNULL(@EmployerESI,0), --SUM(Earning) + SUM(Deduction), 
		       @RelatedToPtActualAmount = SUM(ActualEarning) - ISNULL(@ActualEmployerShare,0) --ISNULL(@ActualEmployerPF,0) - ISNULL(@ActualEmployerESI,0) --SUM(ActualEarning) + SUM(ActualDeduction),
		FROM #Payroll WHERE EmployeeId = @EmployeeId
		
		DECLARE @ProfessionalTaxRangeId UNIQUEIDENTIFIER = NULL

		SELECT @ProfessionalTaxRangeId = Id
		FROM ProfessionalTaxRange 
		WHERE IsArchived = 0 AND BranchId = @EmployeeBranchId
		      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		IF(@ProfessionalTaxRangeId IS NOT NULL)
		BEGIN

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

		END
		ELSE
		BEGIN

			SELECT @RelatedToPTValue = TaxAmount 
			FROM #ProfessionalTaxRange 
			WHERE ((ToRange IS NOT NULL AND @RelatedToPtAmount BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND @RelatedToPtAmount >= FromRange))
		
			SELECT @RelatedToPTActualValue = TaxAmount 
			FROM #ProfessionalTaxRange 
			WHERE ((ToRange IS NOT NULL AND @RelatedToPtAmount BETWEEN FromRange AND ToRange) OR (ToRange IS NULL AND @RelatedToPtAmount >= FromRange))

		END
		
		UPDATE #Payroll SET PayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTValue ELSE @RelatedToPTValue END, ActualPayrollComponentAmount = CASE WHEN IsDeduction = 1 THEN -1 * @RelatedToPTActualValue ELSE @RelatedToPTActualValue END
		WHERE EmployeeId = @EmployeeId AND IsRelatedToPt = 1

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
			
			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

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
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

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
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

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
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

			END

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

			IF(@TaxAmount > 0)
			BEGIN

				INSERT INTO #Payroll
				SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@TaxId,@TaxName,1,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,-@TaxAmount,-@TaxAmount,NULL,-@TaxAmount,NULL,-@TaxAmount,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
				             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
							  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
				FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

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
			             TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						  P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,@LoanTotalPaidAmount,@LoanBalanceAmount
			FROM #Payroll P LEFT JOIN #LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		----Loan calculation End

		SET @EmployeesCounter = @EmployeesCounter + 1

	END
	
	SELECT * FROM #Payroll
	ORDER BY EmployeeName,IsDeduction

END
GO