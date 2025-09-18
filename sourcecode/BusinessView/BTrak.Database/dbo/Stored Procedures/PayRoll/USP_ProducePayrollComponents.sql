CREATE PROCEDURE [dbo].[USP_ProducePayrollComponents]
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
	DECLARE @TotalWorkingDays INT = DAY(EOMONTH(@RunEndDate)), @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate) ,@TaxPeriodType NVARCHAR(100), @LossOfPayPeriodType NVARCHAR(100), @LeaveEncashmentPeriodType NVARCHAR(100)
	DECLARE @LossOfPayStartDate DATE, @LossOfPayEndDate DATE,@LOPEmployeesCount INT, @LOPEmployeesCounter INT = 1, @LOPEmployeeId UNIQUEIDENTIFIER,@LOPEmployeeBranchId UNIQUEIDENTIFIER, @LOPUserId UNIQUEIDENTIFIER,  
	        @LOPFinancialYearFromMonth INT, @LOPFinancialYearToMonth INT, @TaxFinancialYearTypeId UNIQUEIDENTIFIER, @LeavesFinancialYearTypeId UNIQUEIDENTIFIER, @LOPFinancialYearFromDate DATE, @LOPFinancialYearToDate DATE, 
			@LOPFinancialFromYear INT, @LOPFinancialToYear INT, @LeaveEncashmentPeriodTypeForLop NVARCHAR(100),
			@ProcessedEmployeesWeightage FLOAT, @LOPEmployeeCountryId UNIQUEIDENTIFIER,@IsEncashCtcType BIT 

	SELECT @ProcessedEmployeesWeightage = IIF(ProcessEmployees = 0, 0, ROUND((80.0/(ProcessEmployees*1.0))/100.0,1)) FROM Temp_PayrollRun WHERE Id = @NewPayrollRunId
	
	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'
	SELECT @LeavesFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Leaves'

	--Loss Of Pay Start
	DECLARE @LeaveEmployee TABLE  
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
	
	INSERT INTO @LeaveEmployee(EmployeeId,UserId,BranchId)
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
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	SELECT @LOPEmployeesCount = COUNT(1) FROM @LeaveEmployee

	WHILE(@LOPEmployeesCounter <= @LOPEmployeesCount)
	BEGIN

		SELECT @LOPEmployeeId = EmployeeId, @LOPUserId = UserId, @LOPEmployeeBranchId = BranchId FROM @LeaveEmployee WHERE Id = @LOPEmployeesCounter
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
	
		UPDATE @LeaveEmployee SET TotalLeaves = [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](@LOPUserId,@LOPFinancialYearFromDate,@LOPFinancialYearToDate,1) 
		WHERE EmployeeId = @LOPEmployeeId

		IF(@LossOfPayPeriodType = 'Every month')
		BEGIN
			
			SELECT @LossOfPayStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0)
			       ,@LossOfPayEndDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunEndDate) , 0) ) )
			--SELECT @LossOfPayStartDate = @RunStartDate, @LossOfPayEndDate = @RunEndDate

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId
			
			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every month' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Every halfyearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Yearly' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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

			UPDATE @LeaveEmployee SET AllowedLeaves = [dbo].Ufn_GetEligibleLeavesOfAnEmployee(@LOPUserId,@LossOfPayStartDate,@LossOfPayEndDate), IsLossOfPayMonth = 1
			WHERE EmployeeId =  @LOPEmployeeId

			UPDATE @LeaveEmployee SET LeavesTaken = LEP.LeavesTaken, UnplannedHolidays = LEP.UnplannedHolidays, SickDays = LEP.SickDays, PlannedHolidays = LEP.PlannedHolidays, PaidLeaves = LEP.PaidLeaves, UnPaidLeaves = LEP.UnPaidLeaves
			FROM dbo.Ufn_GetLeavesOfAnEmployeeBasedOnPeriod(@OperationsPerformedBy,@LOPEmployeeId,@LossOfPayStartDate,@LossOfPayEndDate) LEP INNER JOIN @LeaveEmployee LE ON LE.EmployeeId = LEP.EmployeeId
			WHERE LE.EmployeeId =  @LOPEmployeeId

			IF(@LeaveEncashmentPeriodTypeForLop <> 'Last quarter' OR @LeaveEncashmentPeriodTypeForLop IS NULL)
			BEGIN

				UPDATE @LeaveEmployee SET AllowedLeaves = LE.AllowedLeaves + ISNULL(LEInner.AllowedLeaves,0)
				FROM @LeaveEmployee LE 
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
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

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
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

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
	     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
		            AND ( (EB.ActiveTo IS NOT NULL AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			              OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
						  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				        ) 
		 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
		            AND ( (EPC.ActiveTo IS NOT NULL AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND @RunEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
	  		            OR (EPC.ActiveTo IS NULL AND @RunEndDate >= EPC.ActiveFrom)
						OR (EPC.ActiveTo IS NOT NULL AND @RunStartDate <= EPC.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
	  			     )
		 INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND (PT.Id = @PayrolltemplateId OR @PayrolltemplateId IS NULL)
		 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
		 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NOT NULL AND PC.CompanyId = @CompanyId
		 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
		 LEFT JOIN Component C ON C.Id = PTC.ComponentId
	WHERE E.InActiveDateTime IS NULL
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

	) TInner

	  LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = TInner.EmployeeId
	  LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = TInner.EmployeeId AND ER.InActiveDateTime IS NULL 
	            AND ((ER.LastDate IS NULL AND ER.ResignationDate <= @RunEndDate) OR (ER.ResignationDate <= @RunEndDate AND ER.LastDate >= @RunEndDate))
				AND ER.ResignationStastusId NOT IN (SELECT Id FROM ResignationStatus WHERE StatusName IN ('Rejected','Waiting for approval') AND InactiveDateTime IS NULL)
	  LEFT JOIN EmployeeResignation ER1 ON ER1.EmployeeId = TInner.EmployeeId AND ER1.InActiveDateTime IS NULL 
	           AND DATENAME(MONTH,ER1.LastDate) + ' ' + DATENAME(YEAR,ER1.LastDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
			   AND ER1.ResignationStastusId NOT IN (SELECT Id FROM ResignationStatus WHERE StatusName IN ('Rejected','Waiting for approval') AND InactiveDateTime IS NULL)

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

	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @UserId UNIQUEIDENTIFIER, @IsEqual BIT, @Earning FLOAT, @RelatedToPtAmount FLOAT, @RelatedToPTValue FLOAT, @RelatedToPtActualAmount FLOAT, @RelatedToPTActualValue FLOAT, @ActualEarning FLOAT, 
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
			
			SELECT @MaxEncashedLeaves = ISNULL((SELECT SUM(MaxEncashedLeavesCount) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,NULL,@LeaveEncashmentFinancialYearFromDate,@LeaveEncashmentFinancialYearToDate)),0)

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
			FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		-- Other Allowance calculation End

		--Employee Bonus calculation Start
		
		DROP TABLE IF EXISTS dbo.Bonus

		DECLARE @Bonus TABLE  
		(
			Bonus FLOAT
		)

		INSERT INTO @Bonus
		SELECT CASE WHEN Bonus IS NOT NULL THEN Bonus ELSE (CASE WHEN IsCtcType = 1 THEN ROUND(((SELECT TOP 1 EmployeeSalary FROM #Payroll WHERE EmployeeId = @EmployeeId) * Percentage * 0.01),0)
		                                                                            ELSE ROUND(((SELECT TOP 1 PayrollComponentAmount FROM #Payroll WHERE EmployeeId = @EmployeeId AND PayrollComponentId = EB.PayrollComponentId) * Percentage * 0.01),0) END)
				END Bonus
		FROM EmployeeBonus EB 
		WHERE EmployeeId = @EmployeeId AND GeneratedDate BETWEEN @RunStartDate AND @RunEndDate AND IsArchived = 0 AND IsApproved = 1

		SELECT @EmployeeBonus = SUM(Bonus) FROM @Bonus

		IF(@EmployeeBonus IS NOT NULL AND @EmployeeBonus > 0)
		BEGIN
			
			SELECT @BonusId = Id, @BonusName = ComponentName FROM PayrollComponent WHERE CompanyId = @CompanyId AND ComponentName = 'Bonus' AND InActiveDateTime IS NULL

			INSERT INTO #Payroll
			SELECT TOP 1 P.EmployeeId,EmployeeName,P.PayrollTemplateId,@BonusId,@BonusName,0,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,0,@EmployeeBonus,@EmployeeBonus,@EmployeeBonus,NULL,@EmployeeBonus,NULL,DATEDIFF(DAY,@RunStartDate,@RunEndDate) + 1 TotalDaysInPayroll,
		                 TotalWorkingDays TotalWorkingDays,LE.LeavesTaken,LE.UnplannedHolidays,LE.SickDays,P.WorkedDays WorkedDays,LE.PlannedHolidays,P.LossOfPay,P.IsInResignation,P.TotalLeaves,P.PaidLeaves,P.UnPaidLeaves,P.AllowedLeaves,
						 P.IsLossOfPayMonth,NULL EmployeeConfigAndSalaryId,P.LastPeriodPayrollComponentAmount,P.LastPeriodSalary,P.LastPeriodLossOfPay,P.ActualLastPeriodPayrollComponentAmount,P.ActualLastPeriodSalary,P.EncashedLeaves,P.TotalAmountPaid,P.LoanAmountRemaining
			FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END
		ELSE IF(@LeaveEncashmentPeriodType = 'Yearly' AND ABS((@LeaveEncashmentFinancialYearFromMonth - @PayrollRunMonth)-1)%12 = 0)
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
				WHERE P.EmployeeId = @EmployeeId

				UPDATE #Payroll SET EncashedLeaves = @RemainingLeaves WHERE EmployeeId = @EmployeeId

			END

		END

		----Leave encashment calculations End

		--IsRelatedToPt calculation Start
		SELECT @RelatedToPtAmount = SUM(Earning) - ISNULL(@EmployerShare,0), --ISNULL(@EmployerPF,0) - ISNULL(@EmployerESI,0), --SUM(Earning) + SUM(Deduction), 
		       @RelatedToPtActualAmount = SUM(ActualEarning) - ISNULL(@ActualEmployerShare,0) --ISNULL(@ActualEmployerPF,0) - ISNULL(@ActualEmployerESI,0) --SUM(ActualEarning) + SUM(ActualDeduction),
		FROM #Payroll WHERE EmployeeId = @EmployeeId
		
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.Employeeid = P.EmployeeId
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
				FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
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
			FROM #Payroll P LEFT JOIN @LeaveEmployee LE ON LE.EmployeeId = P.EmployeeId
			WHERE P.EmployeeId = @EmployeeId

		END
		----Loan calculation End

		UPDATE Temp_PayrollRun SET ProcessedEmployees = ISNULL(ProcessedEmployees,0) + ISNULL(@ProcessedEmployeesWeightage,0) WHERE Id = @NewPayrollRunId
		
		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	SET @EmployeesCounter = 1

	-- Resignation Cancelled employees payroll calculation Start
	DECLARE @ResignationDate DATE, @BeforeRejectedDate DATE

	SELECT ROW_NUMBER() OVER (ORDER BY ER.EmployeeId) Id, ER.EmployeeId, ER.Resignationdate, ER.RejectedDate, DATEADD(MONTH,-1,RejectedDate) BeforeRejectedDate, 

	       STUFF((SELECT  ',' + CAST(EE.EmployeeId AS NVARCHAR(100))
            FROM EmployeeResignation EE
            WHERE  EE.Id = ER.Id
        FOR XML PATH('')), 1, 1, '') AS EmployeeIds
	INTO #ResignationCancelledEmployees
	FROM EmployeeResignation ER
	     INNER JOIN ResignationStatus RS ON ER.ResignationStastusId = RS.Id AND RS.StatusName = 'Rejected' AND RS.InactiveDateTime IS NULL
		 INNER JOIN Employee E ON E.Id = ER.EmployeeId
		 INNER JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	WHERE DATENAME(MONTH,RejectedDate) + ' ' + DATENAME(YEAR,RejectedDate) = DATENAME(MONTH,@RunEndDate) + ' ' + DATENAME(YEAR,@RunEndDate)
	      AND ER.InActiveDateTime IS NULL
		  AND DATEDIFF(MONTH,ER.Resignationdate,ER.RejectedDate) > 0
		  AND (@EmployeeIds IS NULL OR ER.EmployeeId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))

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

	SELECT @EmployeesCount = COUNT(1) FROM #ResignationCancelledEmployees
	
	WHILE(@Employeescounter <= @EmployeesCount)
	BEGIN

		SELECT @EmployeeId = EmployeeId, @ResignationDate = ResignationDate, @BeforeRejectedDate = BeforeRejectedDate FROM #ResignationCancelledEmployees WHERE Id = @Employeescounter

		INSERT INTO @PayrollForResignationEmployee(EmployeeId,EmployeeName,PayrollComponentId,PayrollComponentName,IsDeduction,IsRelatedToPT,PayrollComponentAmount,ActualPayrollComponentAmount,
                                                   Earning,Deduction,
												   ActualEarning,ActualDeduction)
		SELECT PEC.EmployeeId,PRE.EmployeeName,PEC.ComponentId,ComponentName,IsDeduction,NULl IsRelatedToPT,SUM(ComponentAmount),SUM(ActualComponentAmount),
                                                   IIF(SUM(ComponentAmount) > 0, SUM(ComponentAmount), NULL),IIF(SUM(ComponentAmount) < 0, SUM(ComponentAmount), NULL),
												   IIF(SUM(ActualComponentAmount) > 0, SUM(ActualComponentAmount), NULL),IIF(SUM(ActualComponentAmount) < 0, SUM(ActualComponentAmount), NULL)
		FROM PayrollRunEmployeeComponent PEC 
		     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
			 INNER JOIN PayrollRunEmployee PRE ON PEC.PayrollRunId = PRE.PayrollRunId AND PEC.EmployeeId = PRE.EmployeeId
			 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
						 FROM PayrollRunEmployee PRE 
							  INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
							  --INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							  --INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
						 WHERE PR.InactiveDateTime IS NULL
						 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
						           AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
		WHERE PEC.EmployeeId = @EmployeeId
		      AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(month, DATEDIFF(month, 0, @ResignationDate), 0) AND DATEADD(month, DATEDIFF(month, 0, @BeforeRejectedDate), 0)
		GROUP BY PEC.EmployeeId,PRE.EmployeeName,PEC.ComponentId,ComponentName,IsDeduction--,PTC.IsRelatedToPT
		
		UPDATE @PayrollForResignationEmployee SET EmployeeSalary = LEInner.EmployeeSalary,ActualEmployeeSalary = LEInner.ActualEmployeeSalary,OneDaySalary = LEInner.OneDaySalary,[TotalDaysInPayroll] = LEInner.[TotalDaysInPayroll],
		                                          [TotalWorkingDays] = LEInner.[TotalWorkingDays],LeavesTaken = LEInner.LeavesTaken,[UnplannedHolidays] = LEInner.[UnplannedHolidays],[SickDays] = LEInner.[SickDays],
												  WorkedDays = LEInner.WorkedDays,[PlannedHolidays] = LEInner.[PlannedHolidays],LossOfPay = LEInner.LossOfPay,IsInResignation = LEInner.IsInResignation,
												  TotalLeaves = LEInner.TotalLeaves,PaidLeaves = LEInner.PaidLeaves,UnPaidLeaves = LEInner.UnPaidLeaves,AllowedLeaves = LEInner.AllowedLeaves,IsLossOfPayMonth = LEInner.IsLossOfPayMonth,EncashedLeaves = LEInner.EncashedLeaves,
												  TotalAmountPaid = LEInner.TotalAmountPaid, LoanAmountRemaining = LEInner.LoanAmountRemaining
		FROM @PayrollForResignationEmployee LE 
			 LEFT JOIN (SELECT PRE.EmployeeId,SUM(PRE.EmployeeSalary) EmployeeSalary,SUM(PRE.ActualEmployeeSalary) ActualEmployeeSalary,SUM(PRE.OneDaySalary) OneDaySalary,SUM(PRE.[TotalDaysInPayroll]) [TotalDaysInPayroll],
			                   SUM(PRE.[TotalWorkingDays]) [TotalWorkingDays],SUM(PRE.LeavesTaken) LeavesTaken,SUM(PRE.[UnplannedHolidays]) [UnplannedHolidays],SUM(PRE.[SickDays]) [SickDays],
							   SUM(PRE.EffectiveWorkingDays) WorkedDays,SUM(PRE.[PlannedHolidays]) [PlannedHolidays],SUM(PRE.LossOfPay) LossOfPay,PRE.IsInResignation IsInResignation,
							   PRE.TotalLeaves TotalLeaves,SUM(PRE.PaidLeaves) PaidLeaves,SUM(PRE.UnPaidLeaves) UnPaidLeaves,SUM(PRE.AllowedLeaves) AllowedLeaves,NULL IsLossOfPayMonth,SUM(EncashedLeaves) EncashedLeaves,
							   SUM(TotalAmountPaid) TotalAmountPaid, SUM(LoanAmountRemaining) LoanAmountRemaining
						FROM PayrollRunEmployee PRE
							 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
		                     INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
				                         FROM PayrollRunEmployee PRE 
				                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
											  --INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                  --INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
										 WHERE PR.InactiveDateTime IS NULL
										       AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(month, DATEDIFF(month, 0, @ResignationDate), 0) AND DATEADD(month, DATEDIFF(month, 0, @BeforeRejectedDate), 0)
				                         GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
				                        AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
						GROUP BY PRE.EmployeeId,PRE.IsInResignation,PRE.TotalLeaves) LEInner ON LEInner.EmployeeId = LE.EmployeeId
		WHERE LE.EmployeeId =  @EmployeeId

		UPDATE Temp_PayrollRun SET ProcessedEmployees = ISNULL(ProcessedEmployees,0) + ISNULL(@ProcessedEmployeesWeightage,0) WHERE Id = @NewPayrollRunId
		
		SET @Employeescounter = @Employeescounter + 1

	END

	SELECT *
	INTO #PayrollEmployee
	FROM (

	SELECT DISTINCT EmployeeId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,TotalDaysInPayroll,TotalWorkingDays,LeavesTaken,UnplannedHolidays,SickDays,
                     WorkedDays,PlannedHolidays,LossOfPay,IsInResignation,TotalLeaves,PaidLeaves,UnPaidLeaves,AllowedLeaves,EncashedLeaves,TotalAmountPaid,LoanAmountRemaining
	FROM @PayrollForResignationEmployee
	UNION ALL
	SELECT DISTINCT EmployeeId,EmployeeSalary,ActualEmployeeSalary,OneDaySalary,TotalDaysInPayroll,TotalWorkingDays,LeavesTaken,UnplannedHolidays,SickDays,
                     WorkedDays,PlannedHolidays,LossOfPay,IsInResignation,TotalLeaves,PaidLeaves,UnPaidLeaves,AllowedLeaves,EncashedLeaves,TotalAmountPaid,LoanAmountRemaining
	FROM #Payroll
	WHERE EmployeeId IN (SELECT EmployeeId FROM #ResignationCancelledEmployees)

	) T

	SELECT *
	INTO #PayrollForNonResignationEmployee
	FROM (

	SELECT * FROM @PayrollForResignationEmployee
	UNION ALL
	SELECT * FROM #Payroll WHERE EmployeeId IN (SELECT EmployeeId FROM #ResignationCancelledEmployees)

	) T

	DECLARE @ResignedPayroll TABLE  
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

	INSERT INTO @ResignedPayroll(EmployeeId,EmployeeName,PayrollComponentId,PayrollComponentName,IsDeduction,IsRelatedToPT,PayrollComponentAmount,ActualPayrollComponentAmount,
                                 Earning,Deduction,ActualEarning,ActualDeduction)
	SELECT EmployeeId,EmployeeName,PayrollComponentId,PayrollComponentName,IsDeduction,NULL IsRelatedToPT,SUM(PayrollComponentAmount) PayrollComponentAmount,SUM(ActualPayrollComponentAmount) ActualPayrollComponentAmount,
	       SUM(Earning) Earning,SUM(Deduction) Deduction,SUM(ActualEarning) ActualEarning,SUM(ActualDeduction) ActualDeduction
	FROM #PayrollForNonResignationEmployee
	GROUP BY EmployeeId,EmployeeName,PayrollComponentId,PayrollComponentName,IsDeduction
	
	UPDATE @ResignedPayroll SET EmployeeSalary = LEInner.EmployeeSalary,ActualEmployeeSalary = LEInner.ActualEmployeeSalary,OneDaySalary = LEInner.OneDaySalary,[TotalDaysInPayroll] = LEInner.[TotalDaysInPayroll],
	                    [TotalWorkingDays] = LEInner.[TotalWorkingDays],LeavesTaken = LEInner.LeavesTaken,[UnplannedHolidays] = LEInner.[UnplannedHolidays],[SickDays] = LEInner.[SickDays],
						WorkedDays = LEInner.WorkedDays,[PlannedHolidays] = LEInner.[PlannedHolidays],LossOfPay = LEInner.LossOfPay,IsInResignation = LEInner.IsInResignation,
						TotalLeaves = LEInner.TotalLeaves,PaidLeaves = LEInner.PaidLeaves,UnPaidLeaves = LEInner.UnPaidLeaves,AllowedLeaves = LEInner.AllowedLeaves,IsLossOfPayMonth = LEInner.IsLossOfPayMonth,EncashedLeaves = LEInner.EncashedLeaves,
						TotalAmountPaid = LEInner.TotalAmountPaid, LoanAmountRemaining = LEInner.LoanAmountRemaining
	FROM @ResignedPayroll LE 
		 LEFT JOIN (SELECT PRE.EmployeeId,SUM(PRE.EmployeeSalary) EmployeeSalary,SUM(PRE.ActualEmployeeSalary) ActualEmployeeSalary,SUM(PRE.OneDaySalary) OneDaySalary,SUM(PRE.[TotalDaysInPayroll]) [TotalDaysInPayroll],
		                   SUM(PRE.[TotalWorkingDays]) [TotalWorkingDays],SUM(PRE.LeavesTaken) LeavesTaken,SUM(PRE.[UnplannedHolidays]) [UnplannedHolidays],SUM(PRE.[SickDays]) [SickDays],
						   SUM(PRE.WorkedDays) WorkedDays,SUM(PRE.[PlannedHolidays]) [PlannedHolidays],SUM(PRE.LossOfPay) LossOfPay,NULL IsInResignation,
						   PRE.TotalLeaves TotalLeaves,SUM(PRE.PaidLeaves) PaidLeaves,SUM(PRE.UnPaidLeaves) UnPaidLeaves,SUM(PRE.AllowedLeaves) AllowedLeaves,NULL IsLossOfPayMonth,SUM(EncashedLeaves) EncashedLeaves,
						   SUM(TotalAmountPaid) TotalAmountPaid, SUM(LoanAmountRemaining) LoanAmountRemaining
					FROM #PayrollEmployee PRE
					GROUP BY PRE.EmployeeId,PRE.TotalLeaves) LEInner ON LEInner.EmployeeId = LE.EmployeeId

	UPDATE @ResignedPayroll SET PayrollTemplateId = PRE.PayrollTemplateId, IsLossOfPayMonth = PRE.IsLossOfPayMonth, IsInResignation = PRE.IsInResignation
	FROM #PayrollForNonResignationEmployee PRE INNER JOIN @ResignedPayroll P ON P.EmployeeId = PRE.EmployeeId
	WHERE PRE.PayrollTemplateId IS NOT NULL
	
	UPDATE @ResignedPayroll SET IsRelatedToPT = ISNULL(PRE.IsRelatedToPT,0)
	FROM #PayrollForNonResignationEmployee PRE LEFT JOIN @ResignedPayroll P ON P.PayrollComponentId = PRE.PayrollComponentId AND P.EmployeeId = PRE.EmployeeId
	WHERE PRE.PayrollTemplateId IS NOT NULL AND PRE.IsRelatedToPT IS NOT NULL

	UPDATE @ResignedPayroll SET OneDaySalary = ROUND(OneDaySalary,0), IsRelatedToPT = ISNULL(IsRelatedToPT,0)

	DELETE FROM #Payroll WHERE EmployeeId IN (SELECT EmployeeId FROM #ResignationCancelledEmployees)
	
	INSERT INTO #Payroll
	SELECT * FROM @ResignedPayroll

	-- Resignation Cancelled employees payroll calculation End
	
	SELECT * FROM #Payroll
	ORDER BY EmployeeName,IsDeduction

END
GO

--EXEC USP_ProducePayrollComponents '1CDB3294-9B0F-479A-A6CD-CD61A7240FAB',NULL,NULL,'2020-08-01','2020-08-31','A31F7984-55D5-4C5C-8C75-594090706CB8'

--EXEC USP_ProducePayrollComponents '8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2',NULL,NULL,'2020-05-01','2020-05-31'

--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2019-11-03','2019-11-05'


--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-01-01','2020-01-31'



--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-01-01','2020-01-31'

--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-02-01','2020-02-29'
--EXEC USP_ProducePayrollComponents '2C037AEE-4397-4F45-A261-A794A802B2D1',NULL,NULL,'2020-03-01','2020-03-31'
--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-04-01','2020-04-30'
--EXEC USP_ProducePayrollComponents '2C037AEE-4397-4F45-A261-A794A802B2D1',NULL,NULL,'2020-04-01','2020-04-30'
--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-06-01','2020-06-30'
--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-07-01','2020-07-31'
--EXEC USP_ProducePayrollComponents '127133F1-4427-4149-9DD6-B02E0E036971',NULL,NULL,'2020-10-01','2020-10-31'