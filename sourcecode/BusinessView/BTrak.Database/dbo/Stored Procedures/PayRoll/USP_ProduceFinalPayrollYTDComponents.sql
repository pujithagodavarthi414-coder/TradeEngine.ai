CREATE PROCEDURE [dbo].[USP_ProduceFinalPayrollYTDComponents]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeIds NVARCHAR(MAX),
	@RunStartDate DATE,
	@RunEndDate DATE,
	@NewPayrollRunId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @PayrollRunMonth INT = DATEPART(MONTH,@RunEndDate), @Year INT = DATEPART(YEAR,@RunEndDate)

	CREATE TABLE #EmployeeIds
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER
	)

	INSERT INTO #EmployeeIds(EmployeeId)
	SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM dbo.UfnSplit(@EmployeeIds)
	
	DECLARE @EmployeesCount INT, @EmployeesCounter INT = 1, @EmployeeId UNIQUEIDENTIFIER, @EmployeeBranchId UNIQUEIDENTIFIER, 
	        @EmployeeCountryId UNIQUEIDENTIFIER, @JoiningDate DATE, @FinancialYearFromMonth INT, @FinancialYearToMonth INT,
			@FinancialFromYear INT, @FinancialToYear INT, @FinancialYearFromDate DATE, @FinancialYearToDate DATE

	SELECT @EmployeesCount = COUNT(1) FROM #EmployeeIds

	CREATE TABLE #PayrollRunEmployeeComponent
	(
	    [EmployeeId] [uniqueidentifier] NOT NULL,
		[ComponentId]  [uniqueidentifier] NOT NULL,
		ComponentName NVARCHAR(500),
		PayrollRunStartDate DATE,
		PayrollRunEndDate DATE,
		[ComponentAmount] [decimal](18,4) NULL,
		ActualComponentAmount [decimal](18,4) NULL,
		OriginalComponentAmount [decimal](18,4) NULL,
		OriginalActualComponentAmount [decimal](18,4) NULL,
		[IsDeduction] [bit] NULL
	)

	CREATE TABLE #ComponentIds
	(
		Id INT IDENTITY(1,1),
		[ComponentId]  [uniqueidentifier] NOT NULL,
		ComponentName NVARCHAR(500),
		IsDeuction BIT
	)

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		TRUNCATE TABLE #PayrollRunEmployeeComponent

		SELECT @EmployeeId = EmployeeId FROM #EmployeeIds WHERE Id = @EmployeesCounter

		SELECT @EmployeeBranchId = BranchId
		FROM EmployeeBranch EB
		WHERE EB.EmployeeId = @EmployeeId
		      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
					  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				  ) 
				 
		SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

		SELECT @FinancialYearFromMonth = FromMonth, @FinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
		WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax')
		      AND ( (ActiveTo IS NOT NULL AND @RunStartDate BETWEEN ActiveFrom AND ActiveTo AND @RunEndDate BETWEEN ActiveFrom AND ActiveTo)
			      OR (ActiveTo IS NULL AND @RunEndDate >= ActiveFrom)
				  OR (ActiveTo IS NOT NULL AND @RunStartDate <= ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			   )

		SELECT @FinancialYearFromMonth = ISNULL(@FinancialYearFromMonth,4),
			   @FinancialYearToMonth = ISNULL(@FinancialYearToMonth,3)
		
		SELECT @FinancialFromYear = CASE WHEN @PayrollRunMonth - @FinancialYearFromMonth >= 0 THEN @Year ELSE @Year - 1 END
		SELECT @FinancialToYear = CASE WHEN @PayrollRunMonth - @FinancialYearToMonth > 0 THEN @Year + 1 ELSE @Year END

		SELECT @FinancialYearFromDate = DATEFROMPARTS(@FinancialFromYear,@FinancialYearFromMonth,1), @FinancialYearToDate = EOMONTH(DATEFROMPARTS(@FinancialToYear,@FinancialYearToMonth,1))

		SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId

		DECLARE @FromDate DATE = @FinancialYearFromDate, @PayrollRunId UNIQUEIDENTIFIER

		WHILE(@FromDate <= EOMONTH(@RunEndDate) AND @JoiningDate < EOMONTH(@FromDate))
		BEGIN

			TRUNCATE TABLE #ComponentIds

			SELECT @PayrollRunId = PR.Id
			FROM PayrollRunEmployeeComponent PEC 
				 INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
				 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
				 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
							 FROM PayrollRunEmployee PRE 
							      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
								  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
				                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							 WHERE PR.InactiveDateTime IS NULL
							       AND PR.PayrollStartDate = @FromDate AND PR.PayrollEndDate = EOMONTH(@FromDate)
								   AND PRE.EmployeeId = @EmployeeId
							 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
							AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
				           
			IF(EOMONTH(@FromDate) = EOMONTH(@RunEndDate)) SET @PayrollRunId = @NewPayrollRunId

			IF(@PayrollRunId IS NOT NULL)
			BEGIN

				INSERT INTO #PayrollRunEmployeeComponent
				SELECT EmployeeId,ComponentId,ComponentName,@FromDate,EOMONTH(@FromDate),ComponentAmount,
				       ActualComponentAmount,OriginalComponentAmount,OriginalActualComponentAmount,IsDeduction
				FROM PayrollRunEmployeeComponent
				WHERE PayrollRunId = @PayrollRunId

			END
			ELSE
			BEGIN

				INSERT INTO #PayrollRunEmployeeComponent
				SELECT EmployeeId,PayrollComponentId,PayrollComponentName,@FromDate,EOMONTH(@FromDate),PayrollComponentAmount,
				       ActualPayrollComponentAmount,PayrollComponentAmount,ActualPayrollComponentAmount,IsDeduction
				FROM [dbo].[Ufn_GetEmployeePayrollComponents](@OperationsPerformedBy,@FromDate,EOMONTH(@FromDate),@EmployeeId)

			END

			INSERT INTO #ComponentIds(ComponentId,IsDeuction)
			SELECT DISTINCT ComponentId,IsDeduction
			FROM #PayrollRunEmployeeComponent
			WHERE PayrollRunStartDate < @FromDate

			UPDATE #ComponentIds SET ComponentName = PREC.ComponentName
			FROM PayrollRunEmployeeComponent PREC INNER JOIN #ComponentIds CI ON CI.ComponentId = PREC.ComponentId AND CI.IsDeuction = PREC.IsDeduction
			WHERE PayrollRunId = @PayrollRunId

			DECLARE @ComponentIdsCount INT, @ComponentIdsCounter INT = 1, @ComponentId UNIQUEIDENTIFIER, @IsDeduction BIT, @ComponentName NVARCHAR(500),
			        @PayrollRunEmployeeYTDComponentId UNIQUEIDENTIFIER, @ComponentAmount FLOAT, @ActualComponentAmount FLOAT

			SELECT @ComponentIdsCount = COUNT(1) FROM #ComponentIds

			WHILE(@ComponentIdsCounter <= @ComponentIdsCount)
			BEGIN

				SELECT @ComponentId = ComponentId, @IsDeduction = IsDeuction, @ComponentName = ComponentName FROM #ComponentIds WHERE Id = @ComponentIdsCounter

				SELECT @PayrollRunEmployeeYTDComponentId =Id FROM PayrollRunEmployeeYTDComponent 
				WHERE EmployeeId = @EmployeeId AND PayrollRunStartDate = @FromDate AND PayrollRunEndDate = EOMONTH(@FromDate)
				      AND ComponentId = @CompanyId AND IsDeduction = @IsDeduction

				SELECT @ComponentAmount = SUM(ComponentAmount), @ActualComponentAmount = SUM(ActualComponentAmount) FROM #PayrollRunEmployeeComponent
				WHERE ComponentId = @ComponentId AND IsDeduction = @IsDeduction AND PayrollRunStartDate < @FromDate

				IF(@PayrollRunEmployeeYTDComponentId IS NOT NULL)
				BEGIN

					UPDATE PayrollRunEmployeeYTDComponent SET OriginalComponentAmount = ISNULL(ComponentAmount,@ComponentAmount),
					                                          OriginalActualComponentAmount = ISNULL(ActualComponentAmount,@ActualComponentAmount),
															  UpdatedDateTime = GETDATE(),
															  UpdatedByUserId = @OperationsPerformedBy
					FROM PayrollRunEmployeeYTDComponent 
					WHERE Id = @PayrollRunEmployeeYTDComponentId

				END
				ELSE
				BEGIN

					INSERT INTO PayrollRunEmployeeYTDComponent([Id],
															   [ComponentName],
															   OriginalComponentAmount,
															   OriginalActualComponentAmount,
															   [IsDeduction],
															   [ComponentId],
															   [EmployeeId],
															   FinacialYearFromDate,
															   FinacialYearToDate,
															   PayrollRunStartDate,
															   PayrollRunEndDate,
															   [CreatedDateTime],
															   [CreatedByUserId])
													    SELECT NEWID(),
														       @ComponentName,
															   @ComponentAmount,
															   @ActualComponentAmount,
															   @IsDeduction,
															   @ComponentId,
															   @EmployeeId,
															   @FinancialYearFromDate,
															   @FinancialYearToDate,
															   @FromDate,
															   EOMONTH(@FromDate),
															   GETDATE(),
															   @OperationsPerformedBy

				END

				SET @ComponentIdsCounter = @ComponentIdsCounter + 1

			END

			SET @FromDate = DATEADD(MONTH,1,@FromDate)

		END

		SET @EmployeesCounter = @EmployeesCounter + 1

	END

	--SELECT @EmployeeIds

END
GO
