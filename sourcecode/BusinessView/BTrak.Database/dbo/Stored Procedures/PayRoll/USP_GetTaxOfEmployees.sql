CREATE PROCEDURE [dbo].[USP_GetTaxOfEmployees]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER,
	@ApprovedDate DATE
)
AS
BEGIN

	DECLARE @UserId UNIQUEIDENTIFIER = (SELECT U.Id FROM [User] U INNER JOIN Employee E ON E.UserId = U.Id AND E.Id = @EmployeeId)
	
	DECLARE @DefaultTaxSlabs TABLE 
	(	
	    [Id] [uniqueidentifier],
		[Name] [nvarchar](150) NULL,
		[FromRange] [decimal](18, 4) NULL,
		[ToRange] [decimal](18, 4) NULL,
		[TaxPercentage] [decimal](10, 4) NULL,
		[MinAge] [int] NULL,
		[MaxAge] [int] NULL,
		[ForMale] [bit] NULL,
		[ForFemale] [bit] NULL,
		[Handicapped] [bit] NULL,
		[Order] [int] NULL,
		[IsArchived] [bit] NULL,
		[IsFlatRate] [bit] NULL,
		[ParentId] [uniqueidentifier] NULL,
		[CountryId] [uniqueidentifier] NULL,
		[CreatedDateTime] [datetime] NULL,
		[CreatedByUserId] [uniqueidentifier] NULL,
		[InactiveDateTime] [datetime] NULL,
		IsDefault BIT
	)

	INSERT INTO @DefaultTaxSlabs([Id],[Name],[FromRange],[ToRange],[TaxPercentage],[MinAge],[MaxAge],[ForMale],[ForFemale],[Handicapped],[Order],[IsArchived],[IsFlatRate],
                                 [ParentId],[CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime],IsDefault)
	SELECT '8B6CE278-A98E-46C3-BDA2-954E18E7825B','Upto 60 years',NULL,NULL,NULL,NULL,60,NULL,NULL,NULL,3,0,0,
            NULL,NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '259302C4-699F-4323-9FDA-5A6B5554672D','0-2.5L',0.0000,250000.0000,0.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '8B6CE278-A98E-46C3-BDA2-954E18E7825B',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '8A782E5A-0347-4174-BA7F-5D589A6DBEEB','2.5-5L',250001.0000,500000.0000,5.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '8B6CE278-A98E-46C3-BDA2-954E18E7825B',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '9ABA3726-7D21-4423-8A0B-39AD31076677','5-10L',500001.0000,1000000.0000,20.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '8B6CE278-A98E-46C3-BDA2-954E18E7825B',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT 'D0DD7A6A-9649-4566-A1A5-028C1391D174','Above 10L',1000001.0000,NULL,30.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '8B6CE278-A98E-46C3-BDA2-954E18E7825B',NULL,GETDATE(),@UserId,NULL,0

	UNION

	SELECT '838B3733-291E-4802-B148-80DC7683FECB','Age 60-80',NULL,NULL,NULL,60,80,NULL,NULL,NULL,2,0,0,
            NULL,NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '420E5535-10AB-4DF3-BB37-09BC824BDB53','Upto 3L',0.0000,300000.0000,0.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '838B3733-291E-4802-B148-80DC7683FECB',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '86AC4A6E-F391-4F71-A14B-62E02F07172F','3.0-5.0L',300001.0000,500000.0000,5.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '838B3733-291E-4802-B148-80DC7683FECB',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '1253E6CD-A29D-44C0-BAD5-0B7637C1CF04','5-10L',500001.0000,1000000.0000,20.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '838B3733-291E-4802-B148-80DC7683FECB',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT 'CDB055C9-2843-4ECB-ACF2-C05066D272E7','Above 10L',1000001.0000,NULL,30.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '838B3733-291E-4802-B148-80DC7683FECB',NULL,GETDATE(),@UserId,NULL,0

	UNION

	SELECT '6581D7D8-1EEB-44FA-9D40-B7A7E5AAE7FF','Above 80 years',NULL,NULL,NULL,80,NULL,NULL,NULL,NULL,1,0,0,
            NULL,NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT 'B678C5B2-DC19-4927-968F-6FEB0204EC02','upto 5L',0.0000,500000.0000,0.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '6581D7D8-1EEB-44FA-9D40-B7A7E5AAE7FF',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '787C7232-192D-42CE-AFAF-E83CED5D5D66','B/w 5-10L',500001.0000,1000000.0000,20.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '6581D7D8-1EEB-44FA-9D40-B7A7E5AAE7FF',NULL,GETDATE(),@UserId,NULL,0
	UNION
	SELECT '1512FA9C-90E8-4DF8-A838-5490EC83A67D','Above 10.0 L',1000001.0000,NULL,30.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '6581D7D8-1EEB-44FA-9D40-B7A7E5AAE7FF',NULL,GETDATE(),@UserId,NULL,0
	
	UNION

	SELECT '71AF05C6-8E43-42BB-82C7-197EFC023F1F','Slabs',NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,4,0,0,
            NULL,NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT '37D71AE0-43F7-40BA-AA10-368EC0253F6E','upto 2.5L',0.0000,250000.0000,0.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT 'E3D1389A-0922-45F6-8DAC-2A27D390C014','2.5-5.0 L',250001.0000,500000.0000,5.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT '0B72B8F4-55E1-4401-8901-E97F0D55E196','5-7.5L',500001.0000,750000.0000,10.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT 'BE755059-08E9-4845-96E6-F3C4AE0F9435','7.5-10L',750001.0000,1000000.0000,15.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT '700337C4-D03E-4860-83E0-4B08D56D0AE5','10-12.5L',1000001.0000,1250000.0000,20.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT '894B9912-4DAE-43A0-8136-F7BDB2EDA203','12.5-15L',1250001.0000,1500000.0000,25.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1
	UNION
	SELECT '085F35CC-4D25-414F-9F01-4B2DE00E54C9','above 15L',1500001.0000,NULL,30.0000,NULL,NULL,NULL,NULL,NULL,NULL,0,0,
           '71AF05C6-8E43-42BB-82C7-197EFC023F1F',NULL,GETDATE(),@UserId,NULL,1

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)), 
	        @EmployeeBranchId UNIQUEIDENTIFIER, @TaxableAmount FLOAT, @NetSalary FLOAT, @TotalInvestments FLOAT, @StandardDeduction FLOAT = 50000, @EmployeeJoinedDate DATE, @OneDaySalary FLOAT, @SalariesCount INT,
			@TaxYear INT = DATEPART(YEAR,@ApprovedDate), @TaxFinancialYearFromDate DATE, @TaxFinancialYearToDate DATE, @EmployeesCounter INT = 1, @EmployeesCount INT, @TaxFinancialYearFromMonth INT, @TaxFinancialYearToMonth INT, @TaxFinancialFromYear INT, 
			@TaxFinancialToYear INT, @PayrollRunMonth INT = DATEPART(MONTH,@ApprovedDate), @TaxFinancialYearTypeId UNIQUEIDENTIFIER,
			@EmployeeCountryId UNIQUEIDENTIFIER

	SELECT @TaxFinancialYearTypeId = Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax'

	CREATE TABLE #TaxOfEmployees
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		TaxFinancialYearFromDate DATE,
		TaxFinancialYearToDate DATE,
		WithOutFlatSlabRateTaxableAmount FLOAT,
		WithOutFlatSlabRateTax FLOAT,
		WithFlatSlabRateTaxableAmount FLOAT,
		WithFlatSlabRateTax FLOAT
	)

	INSERT INTO #TaxOfEmployees(EmployeeId)
	SELECT E.Id
	FROM Employee E
	     INNER JOIN [User] U ON U.Id = E.UserId
	WHERE U.CompanyId = @CompanyId
	      AND U.IsActive = 1
		  AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

	SELECT @EmployeesCount = COUNT(1) FROM #TaxOfEmployees

	WHILE(@EmployeesCounter <= @EmployeesCount)
	BEGIN

		DECLARE @Gender NVARCHAR(100), @DateOfBirth DATE, @Age INT, @IsMale BIT, @EductaionCessPercenatge FLOAT = 4  -- Eductaion Cess @ 4%

		DECLARE @TaxSlabs TABLE
		(
			[Order] INT IDENTITY(1,1),
			ParentTaxSlabId UNIQUEIDENTIFIER,
			[OriginalOrder] INT,
			MinAge FLOAT,
			MaxAge FLOAT,
			ForMale BIT,
			ForFemale BIT,
			Handicapped BIT,
			ActiveFrom DATETIME
		)

		DECLARE @TaxSlab TABLE
		(
			FromRange FLOAT,
			ToRange FLOAT,
			TaxPercentage FLOAT,
			DifferenceValue FLOAT,
			RemainingValue FLOAT
		)
		
		SELECT @EmployeeBranchId = BranchId
		FROM EmployeeBranch EB
		WHERE EB.EmployeeId = @EmployeeId
		      AND EB.ActiveFrom IS NOT NULL 
			  AND EB.ActiveFrom <= GETDATE()
			  AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
		    --  AND ( (EB.ActiveTo IS NOT NULL AND @YearStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @YearEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			   --       OR (EB.ActiveTo IS NULL AND @YearEndDate >= EB.ActiveFrom)
					 -- OR (EB.ActiveTo IS NOT NULL AND @YearStartDate <= EB.ActiveTo AND @YearStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				  --) 

		SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

		SELECT @TaxFinancialYearFromMonth = FromMonth, @TaxFinancialYearToMonth = ToMonth FROM [FinancialYearConfigurations] 
		WHERE CountryId = @EmployeeCountryId AND InActiveDateTime IS NULL AND FinancialYearTypeId = @TaxFinancialYearTypeId

		SELECT @TaxFinancialYearFromMonth = ISNULL(@TaxFinancialYearFromMonth,4), @TaxFinancialYearToMonth = ISNULL(@TaxFinancialYearToMonth,3)

		SELECT @TaxFinancialFromYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearFromMonth >= 0 THEN @TaxYear ELSE @TaxYear - 1 END
		SELECT @TaxFinancialToYear = CASE WHEN @PayrollRunMonth - @TaxFinancialYearToMonth > 0 THEN @TaxYear + 1 ELSE @TaxYear END

		SELECT @TaxFinancialYearFromDate = DATEFROMPARTS(@TaxFinancialFromYear,@TaxFinancialYearFromMonth,1), @TaxFinancialYearToDate = EOMONTH(DATEFROMPARTS(@TaxFinancialToYear,@TaxFinancialYearToMonth,1))

		SELECT @EmployeeJoinedDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId

		DECLARE @YearStartDate DATE = @TaxFinancialYearFromDate, @YearEndDate DATE = @TaxFinancialYearToDate
		DECLARE @DaysInYear INT = DATEDIFF(DAY,  @YearStartDate,  @YearEndDate) + 1

		SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

		SELECT @EmployeeId = EmployeeId FROM #TaxOfEmployees WHERE Id = @EmployeesCounter

		UPDATE EmployeeTax SET InActiveDateTime = GETDATE() WHERE EmployeeId = @EmployeeId AND TaxFinancialYearFromDate =  @TaxFinancialYearFromDate AND TaxFinancialYearToDate = @TaxFinancialYearToDate

		UPDATE #TaxOfEmployees SET TaxFinancialYearFromDate = @TaxFinancialYearFromDate, TaxFinancialYearToDate = @TaxFinancialYearToDate WHERE Id = @EmployeesCounter

		----Components Calculation Start
		DECLARE @EmployeeComponents TABLE
		(
			PayrolltemplateId UNIQUEIDENTIFIER,
			NetSalary FLOAT,
		    PayrollComponentId UNIQUEIDENTIFIER,
			PayrollComponentName NVARCHAR(500), 
			PayrollComponentAmount FLOAT,
			ActiveFrom DATE,
			ActiveTo DATE,
			TotalDays INT,
			SalaryId UNIQUEIDENTIFIER,
			OneDaySalary FLOAT
		)

		INSERT INTO @EmployeeComponents
		SELECT PayrolltemplateId,
		       NetSalary,
		       PayrollComponentId,
			   PayrollComponentName,
			   PayrollComponentAmount,
			   ActiveFrom,
			   ActiveTo,
			   TotalDays,
			   SalaryId,
			   OneDaySalary
		FROM (
		SELECT *,
			   CASE WHEN IsCtcDependent = 1 THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN NetSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,NetSalary,@YearStartDate,@YearEndDate,@EmployeeId) ELSE Amount END) ELSE 1 * (CASE WHEN IsPercentage = 1 THEN NetSalary * PercentageValue WHEN IsBands = 1 THEN dbo.Ufn_GetPayrollBandsAmountOfAComponent(PayrollComponentId,NetSalary,@YearStartDate,@YearEndDate,@EmployeeId) ELSE Amount END) END) 
			        WHEN DependentPayrollComponentId IS NOT NULL THEN (CASE WHEN IsDeduction = 1 THEN -1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (NetSalary * PercentageValue * DependentPercentageValue) END) END) 
					                                                                             ELSE 1 * (CASE WHEN IsPercentage = 1 THEN (CASE WHEN DependentAmount IS NOT NULL THEN DependentAmount * PercentageValue ELSE (NetSalary * PercentageValue * DependentPercentageValue) END) END) END) 
			   END PayrollComponentAmount 
		FROM (
		SELECT *,
		       CASE WHEN TotalDays = @DaysInYear THEN ROUND(Salary,0) ELSE ROUND((OneDaySalary * TotalDays),0) END NetSalary
		FROM (
		SELECT *,
		       DATEDIFF(DAY,ActiveFrom,ActiveTo) + 1 TotalDays
		FROM (
		SELECT EPC.PayrolltemplateId,
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
			   CASE WHEN @YearEndDate > (CASE WHEN EPC.ActiveTo IS NULL THEN @YearEndDate ELSE EPC.ActiveTo END) 
			        THEN (CASE WHEN EPC.ActiveTo IS NULL THEN @YearEndDate ELSE EPC.ActiveTo END) 
					ELSE @YearEndDate END ActiveTo,
			   CASE WHEN @EmployeeJoinedDate > (CASE WHEN EPC.ActiveFrom > @YearStartDate THEN EPC.ActiveFrom ELSE @YearStartDate END) 
			        THEN @EmployeeJoinedDate 
					ELSE (CASE WHEN EPC.ActiveFrom > @YearStartDate THEN EPC.ActiveFrom ELSE @YearStartDate END) END ActiveFrom,
			   ROUND(((ES.Amount - ISNULL(NetPayAmount,0))/(@DaysInYear*1.0)),2) OneDaySalary,
			   ES.Amount - ISNULL(NetPayAmount,0) Salary,
			   EPC.SalaryId
		FROM EmployeepayrollConfiguration EPC
		     INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId AND PT.InActiveDateTime IS NULL AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
			 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = PT.Id AND PTC.InActiveDateTime IS NULL
			 INNER JOIN PayrollComponent PC ON PC.Id = PTC.PayrollComponentId AND PC.InActiveDateTime IS NULL AND PC.EmployeeContributionPercentage IS NULL AND PC.CompanyId = @CompanyId
			 LEFT JOIN PayrollTemplateConfiguration DPTC ON PTC.DependentPayrollComponentId = DPTC.PayrollComponentId AND PTC.PayrollTemplateId = DPTC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND DPTC.InActiveDateTime IS NULL
			 LEFT JOIN Component C ON C.Id = PTC.ComponentId
			 INNER JOIN EmployeeSalary ES ON ES.EmployeeId = EPC.EmployeeId AND ES.InActiveDateTime IS NULL AND ES.Id = EPC.SalaryId
			            AND ( (ES.ActiveTo IS NOT NULL AND @YearStartDate BETWEEN ES.ActiveFrom AND ES.ActiveTo AND @YearEndDate BETWEEN ES.ActiveFrom AND ES.ActiveTo)
		  		            OR (ES.ActiveTo IS NULL AND @YearEndDate >= ES.ActiveFrom)
							OR (ES.ActiveTo IS NOT NULL AND @YearStartDate <= ES.ActiveTo)
		  			     )
		WHERE EPC.EmployeeId = @EmployeeId
			  AND PC.IsDeduction = 0
		)T
		)TFinal
		)TOuter
		)TFinalOuter

		DECLARE @EmployeeComponent TABLE
		(
			NetSalary FLOAT,
		    PayrollComponentId UNIQUEIDENTIFIER,
			PayrollComponentName NVARCHAR(500), 
			PayrollComponentAmount FLOAT
		)
		
		INSERT INTO @EmployeeComponent(PayrollComponentId,PayrollComponentName,PayrollComponentAmount)
		SELECT PayrollComponentId,PayrollComponentName,SUM(PayrollComponentAmount)
		FROM @EmployeeComponents
		GROUP BY PayrollComponentId,PayrollComponentName
		
		UPDATE @EmployeeComponent SET NetSalary = (SELECT SUM(NetSalary) 
												   FROM (SELECT ActiveFrom, MAX(NetSalary) NetSalary
												   	     FROM @EmployeeComponents
												   	     GROUP BY ActiveFrom) T)
		----Components Calculation End

		SELECT TOP 1 @NetSalary = NetSalary FROM @EmployeeComponent

		SELECT @NetSalary = @NetSalary - @StandardDeduction

		DECLARE @EmployeeBonus FLOAT
	
		SELECT @EmployeeBonus = SUM(ComponentAmount)
		FROM PayrollRunEmployeeComponent PEC 
	     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
		 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
					 FROM PayrollRunEmployee PRE 
					      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
		                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE PR.InactiveDateTime IS NULL
					 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
					AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
		           AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN @YearStartDate AND @YearEndDate
		WHERE PEC.ComponentName = 'Bonus' AND PEC.EmployeeId = @EmployeeId

		DECLARE @EmployeeLeaveEncashment FLOAT
		
		SELECT @EmployeeLeaveEncashment = SUM(ComponentAmount)
		FROM PayrollRunEmployeeComponent PEC 
	     INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
		 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
					 FROM PayrollRunEmployee PRE 
					      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
		                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE PR.InactiveDateTime IS NULL
					 GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
					AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
		           AND DATEADD(month, DATEDIFF(month, 0, PR.PayrollEndDate), 0) BETWEEN @YearStartDate AND @YearEndDate
		WHERE PEC.ComponentName = 'Leave Encashment' AND PEC.EmployeeId = @EmployeeId

		SELECT @NetSalary = @NetSalary + ISNULL(@EmployeeBonus,0) + ISNULL(@EmployeeLeaveEncashment,0)

		BEGIN

			UPDATE #TaxOfEmployees SET WithFlatSlabRateTaxableAmount = @NetSalary WHERE Id = @EmployeesCounter 

			IF(@NetSalary <= 500000) -- Under Less:Rebate under section 87A
			BEGIN

				SELECT @TaxableAmount = 0

			END
			ELSE
			BEGIN

				SELECT @DateOfBirth = DateOfBirth, @Gender = Gender
				FROM Employee E LEFT JOIN Gender G ON G.Id = E.GenderId
				WHERE E.Id = @EmployeeId
				
				SELECT @Age = ISNULL(DATEDIFF(YEAR,@DateOfBirth,CAST(GETDATE() AS DATE)),0), @IsMale = CASE WHEN @Gender = 'Male' THEN 1 ELSE 0 END
				
				INSERT INTO @TaxSlabs
				SELECT Id,
				       [Order],
					   MinAge,
					   MaxAge,
					   ForMale,
					   ForFemale,
					   Handicapped,
					   ActiveFrom
				FROM TaxSlabs TS
				WHERE ParentId IS NULL
				      AND IsArchived = 0
					  AND ( (ActiveTo IS NOT NULL AND @YearStartDate BETWEEN ActiveFrom AND ActiveTo AND @YearEndDate BETWEEN ActiveFrom AND ActiveTo)
			  		            OR (ActiveTo IS NULL AND @YearEndDate >= ActiveFrom)
								OR (ActiveTo IS NOT NULL AND @YearStartDate <= ActiveTo)
			  			     )
					AND ((@Age BETWEEN TS.MinAge AND TS.MaxAge) 
					OR (@Age >= TS.MinAge AND TS.MaxAge IS NULL) 
					OR (@Age <= TS.MaxAge AND TS.MinAge IS NULL) 
					OR TS.ForMale = @IsMale OR TS.ForFemale = ~@IsMale)
					AND [Order] IS NOT NULL
					AND CountryId = @EmployeeCountryId
				ORDER BY [Order],ActiveFrom

				DECLARE @ParentTaxSlabId UNIQUEIDENTIFIER
				SELECT TOP 1 @ParentTaxSlabId = ParentTaxSlabId FROM @TaxSlabs WHERE [Order] = 1 ORDER BY ActiveFrom DESC

	IF(@ParentTaxSlabId IS NULL)
	BEGIN


		INSERT INTO @TaxSlabs
		SELECT TS.Id,
		       TS.[Order],
			   TS.MinAge,
			   TS.MaxAge,
			   TS.ForMale,
			   TS.ForFemale,
			   TS.Handicapped,
			   NULL
		FROM @DefaultTaxSlabs TS
		WHERE TS.ParentId IS NULL
		      AND TS.IsArchived = 0
			  AND ((@Age BETWEEN TS.MinAge AND TS.MaxAge) OR (@Age >= TS.MinAge AND TS.MaxAge IS NULL) OR (@Age <= TS.MaxAge AND TS.MinAge IS NULL) OR TS.ForMale = @IsMale OR TS.ForFemale = ~@IsMale)
			  AND TS.[Order] IS NOT NULL
		ORDER BY TS.[Order]

		SELECT TOP 1 @ParentTaxSlabId = ParentTaxSlabId FROM @TaxSlabs WHERE [Order] = 1 ORDER BY ActiveFrom DESC	

		IF(@ParentTaxSlabId IS NULL) SELECT @ParentTaxSlabId = Id FROM @DefaultTaxSlabs WHERE ParentId IS NULL AND IsDefault = 1

	END

				INSERT INTO @TaxSlab(FromRange,ToRange,TaxPercentage,DifferenceValue)
				SELECT FromRange,
				       ToRange,
					   TaxPercentage,
					   CASE WHEN @NetSalary >= ToRange THEN ToRange - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) ELSE @NetSalary - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) END
				FROM TaxSlabs TS 
				WHERE (@NetSalary >= TS.ToRange OR @NetSalary BETWEEN TS.FromRange AND TS.ToRange OR (ToRange IS NULL AND @NetSalary >= FromRange))
				      AND ParentId IN (@ParentTaxSlabId)
					  AND TS.CountryId = @EmployeeCountryId
				UNION
		SELECT FromRange,
		       ToRange,
			   TaxPercentage,
			   CASE WHEN @NetSalary >= ToRange THEN ToRange - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) ELSE @NetSalary - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) END
		FROM @DefaultTaxSlabs TS 
		WHERE (@NetSalary >= TS.ToRange OR @NetSalary BETWEEN TS.FromRange AND TS.ToRange OR (ToRange IS NULL AND @NetSalary >= FromRange))
		      AND TS.ParentId = @ParentTaxSlabId

				UPDATE @TaxSlab SET RemainingValue = DifferenceValue * TaxPercentage * 0.01
				
				SELECT @TaxableAmount = SUM(RemainingValue) FROM @TaxSlab

				SELECT @TaxableAmount = @TaxableAmount + (@TaxableAmount * @EductaionCessPercenatge * 0.01)

			END

			UPDATE #TaxOfEmployees SET WithFlatSlabRateTax = ROUND(ISNULL(@TaxableAmount,0),0) WHERE Id = @EmployeesCounter 

		END


		BEGIN

			DELETE FROM @TaxSlabs
			DELETE FROM @TaxSlab

			DECLARE @TaxAllowance TABLE
			(
			    Id UNIQUEIDENTIFIER,
				[Name] NVARCHAR(500), 
				MaxAmount FLOAT,
				ParentId UNIQUEIDENTIFIER,
				InvestedAmount FLOAT,
				TaxAllowanceTypeName NVARCHAR(500),
				LowestAmountOfParentSet BIT,
				PercentageValue FLOAT,
				ComponentId UNIQUEIDENTIFIER,
				PayrollComponentId UNIQUEIDENTIFIER,
				MetroMaxPercentage FLOAT,
				RelatedToMetroCity BIT
			)

			INSERT INTO @TaxAllowance(Id,[Name],MaxAmount,ParentId,InvestedAmount,TaxAllowanceTypeName,LowestAmountOfParentSet,PercentageValue,ComponentId,PayrollComponentId,MetroMaxPercentage,RelatedToMetroCity)
			SELECT TA.Id,TA.[Name],NULL MaxAmount,TA.ParentId,CASE WHEN ETA.IsOnlyEmployee = 1 THEN (CASE WHEN ETA.InvestedAmount > TA.OnlyEmployeeMaxAmount THEN TA.OnlyEmployeeMaxAmount ELSE ETA.InvestedAmount END) 
			                                                     ELSE (CASE WHEN ETA.InvestedAmount > TA.MaxAmount THEN TA.MaxAmount ELSE ETA.InvestedAmount END) END,
					TAT.TaxAllowanceTypeName,TA.LowestAmountOfParentSet,TA.PercentageValue,TA.ComponentId,TA.PayrollComponentId,TA.MetroMaxPercentage,ETA.RelatedToMetroCity
			FROM EmployeeTaxAllowances ETA 
			     INNER JOIN TaxAllowances TA ON TA.Id = ETA.TaxAllowanceId AND TA.InActiveDateTime IS NULL AND ETA.InActiveDateTime IS NULL
				 INNER JOIN TaxAllowanceType TAT ON TAT.Id = TA.TaxAllowanceTypeId AND TAT.CompanyId = @CompanyId
			WHERE ETA.EmployeeId = @EmployeeId
			      AND (DATEPART(YEAR,ETA.ApprovedDateTime) = @TaxYear OR DATEPART(YEAR,ETA.ApprovedDateTime) = @TaxYear + 1)
				  AND TA.ParentId IS NOT NULL
				  AND TA.CountryId = @EmployeeCountryId

			INSERT INTO @TaxAllowance(Id,Name,MaxAmount,ParentId,InvestedAmount,TaxAllowanceTypeName,LowestAmountOfParentSet)
			SELECT TA.Id,TA.Name,TA.MaxAmount,NULL ParentId,NULL InvestedAmount,NULL TaxAllowanceTypeName,LowestAmountOfParentSet
			FROM TaxAllowances TA
			WHERE Id IN (SELECT DISTINCT ParentId FROM @TaxAllowance)
			      AND TA.CountryId = @EmployeeCountryId

			INSERT INTO @TaxAllowance(Id,Name,MaxAmount,ParentId,InvestedAmount,TaxAllowanceTypeName,LowestAmountOfParentSet,PercentageValue,ComponentId,PayrollComponentId,MetroMaxPercentage)
			SELECT TA.Id,TA.Name,NULL MaxAmount,TA.ParentId,NULL,TAT.TaxAllowanceTypeName,TA.LowestAmountOfParentSet,TA.PercentageValue,TA.ComponentId,TA.PayrollComponentId,TA.MetroMaxPercentage
			FROM TaxAllowances TA
			     INNER JOIN TaxAllowanceType TAT ON TAT.Id = TA.TaxAllowanceTypeId AND TAT.CompanyId = @CompanyId
			WHERE TAT.TaxAllowanceTypeName = 'Automatic' 
			      AND TA.ParentId IS NOT NULL
				  AND TA.Id NOT IN (SELECT Id FROM @TaxAllowance)
				  AND LowestAmountOfParentSet IS NOT NULL
				  AND TA.CountryId = @EmployeeCountryId

			INSERT INTO @TaxAllowance(Id,Name,MaxAmount,ParentId,InvestedAmount,TaxAllowanceTypeName,LowestAmountOfParentSet,PercentageValue,ComponentId,PayrollComponentId,MetroMaxPercentage)
			SELECT TA.Id,TA.Name,TA.MaxAmount MaxAmount,TA.ParentId,NULL,TAT.TaxAllowanceTypeName,TA.LowestAmountOfParentSet,TA.PercentageValue,TA.ComponentId,TA.PayrollComponentId,TA.MetroMaxPercentage
			FROM TaxAllowances TA
			     INNER JOIN TaxAllowanceType TAT ON TAT.Id = TA.TaxAllowanceTypeId AND TAT.CompanyId = @CompanyId
			WHERE TA.Id IN (SELECT TA.ParentId FROM TaxAllowances TA
			                            INNER JOIN TaxAllowanceType TAT ON TAT.Id = TA.TaxAllowanceTypeId AND TAT.CompanyId = @CompanyId
			                 WHERE TAT.TaxAllowanceTypeName = 'Automatic')
				  AND TA.Id NOT IN (SELECT Id FROM @TaxAllowance)
				  AND TA.CountryId = @EmployeeCountryId

			UPDATE @TaxAllowance SET LowestAmountOfParentSet = 1 WHERE ParentId IN (SELECT Id FROM @TaxAllowance WHERE LowestAmountOfParentSet = 1)

			UPDATE @TaxAllowance SET RelatedToMetroCity = 1 WHERE ParentId IN (SELECT ParentId FROM @TaxAllowance WHERE RelatedToMetroCity = 1)

			DECLARE @LowestAmountOfParentSetValue FLOAT
			SELECT @LowestAmountOfParentSetValue = SUM(InvestedAmount) FROM @TaxAllowance WHERE LowestAmountOfParentSet = 1

			UPDATE @TaxAllowance SET PercentageValue = CASE WHEN MetroMaxPercentage IS NOT NULL AND RelatedToMetroCity = 1 THEN MetroMaxPercentage ELSE PercentageValue END

			UPDATE @TaxAllowance SET InvestedAmount = CASE WHEN PercentageValue IS NOT NULL THEN (CASE WHEN PayrollComponentId IS NOT NULL THEN ROUND(((SELECT PayrollComponentAmount FROM @EmployeeComponent WHERE PayrollComponentId = TA.PayrollComponentId) * PercentageValue * 0.01),0)
			                                                                                           WHEN ComponentId IS NOT NULL THEN (CASE WHEN C.ComponentName = '##MonthlyCTC##' THEN ROUND((@NetSalary * PercentageValue * 0.01),0) 
																									                                           WHEN C.ComponentName = '#Basic#-#RentalReceiptValue#' THEN [dbo].[Ufn_GetActualRentPaidLessPercentOfBasicSalary]((SELECT PayrollComponentAmount FROM @EmployeeComponent WHERE PayrollComponentName = 'Basic'),PercentageValue,@LowestAmountOfParentSetValue)
																									                                      END)
																								  END)
			                                               ELSE MaxAmount 
													  END
			FROM @TaxAllowance TA LEFT JOIN Component C ON C.Id = TA.ComponentId
			WHERE TaxAllowanceTypeName = 'Automatic' 

			UPDATE @TaxAllowance SET InvestedAmount = ISNULL(InvestedAmount,0)

			DECLARE @EmployeeInvestment TABLE
			(
				Id UNIQUEIDENTIFIER,
				[Name] NVARCHAR(MAX),
				LowestAmountOfParentSet INT,
				MaxAmount FLOAT,
				InvestedAmount FLOAT,
				Investment FLOAT
			)

			INSERT INTO @EmployeeInvestment
			SELECT Id, Name, TA.LowestAmountOfParentSet,
			       CASE WHEN TA.LowestAmountOfParentSet = 1 THEN MaxInvestedAmount ELSE TA.MaxAmount END MaxAmount, 
			       CASE WHEN TA.LowestAmountOfParentSet = 1 THEN TAInner2.MinInvestedAmount ELSE TAInner.InvestedAmount END InvestedAmount, 
			       CASE WHEN TA.LowestAmountOfParentSet = 1 THEN TAInner2.MinInvestedAmount ELSE (CASE WHEN TA.MaxAmount > TAInner.InvestedAmount THEN TAInner.InvestedAmount ELSE TA.MaxAmount END) END Investment
			FROM @TaxAllowance TA 

			     INNER JOIN (SELECT TA.ParentId, SUM(TA.InvestedAmount) InvestedAmount
			                 FROM @TaxAllowance TA
			                 GROUP BY TA.ParentId) TAInner ON TA.Id = TAInner.ParentId

				 LEFT JOIN (SELECT ParentId, LowestAmountOfParentSet, MIN(InvestedAmount) MinInvestedAmount, MAX(InvestedAmount) MaxInvestedAmount
				            FROM @TaxAllowance 
						    WHERE LowestAmountOfParentSet = 1 AND ParentId IS NOT NULL 
						    GROUP BY ParentId, LowestAmountOfParentSet) TAInner2 ON TA.Id = TAInner2.ParentId AND  TA.LowestAmountOfParentSet = TAInner2.LowestAmountOfParentSet

			WHERE TA.ParentId IS NULL

			SELECT @TotalInvestments = SUM(Investment) FROM @EmployeeInvestment

			SELECT @NetSalary = @NetSalary - @TotalInvestments

			UPDATE #TaxOfEmployees SET WithOutFlatSlabRateTaxableAmount = @NetSalary WHERE Id = @EmployeesCounter 

			IF(@NetSalary <= 500000) -- Under Less:Rebate under section 87A
			BEGIN

				SELECT @TaxableAmount = 0

			END
			ELSE
			BEGIN

				SELECT @DateOfBirth = DateOfBirth, @Gender = Gender
				FROM Employee E LEFT JOIN Gender G ON G.Id = E.GenderId
				WHERE E.Id = @EmployeeId
				
				SELECT @Age = ISNULL(DATEDIFF(YEAR,@DateOfBirth,CAST(GETDATE() AS DATE)),0), @IsMale = CASE WHEN @Gender = 'Male' THEN 1 ELSE 0 END
				
				INSERT INTO @TaxSlabs
				SELECT Id,
				       [Order],
					   MinAge,
					   MaxAge,
					   ForMale,
					   ForFemale,
					   Handicapped,
					   ActiveFrom
				FROM TaxSlabs TS
				WHERE ParentId IS NULL
				      AND IsArchived = 0
					  AND ( (ActiveTo IS NOT NULL AND @YearStartDate BETWEEN ActiveFrom AND ActiveTo AND @YearEndDate BETWEEN ActiveFrom AND ActiveTo)
			  		            OR (ActiveTo IS NULL AND @YearEndDate >= ActiveFrom)
								OR (ActiveTo IS NOT NULL AND @YearStartDate <= ActiveTo)
			  			     )
					AND ((@Age BETWEEN TS.MinAge AND TS.MaxAge) OR (@Age >= TS.MinAge AND TS.MaxAge IS NULL) OR (@Age <= TS.MaxAge AND TS.MinAge IS NULL) OR TS.ForMale = @IsMale OR TS.ForFemale = ~@IsMale)
					AND [Order] IS NOT NULL
					AND CountryId = @EmployeeCountryId
				ORDER BY [Order],ActiveFrom

				SELECT TOP 1 @ParentTaxSlabId = ParentTaxSlabId FROM @TaxSlabs WHERE [Order] = 1 ORDER BY ActiveFrom DESC

				IF(@ParentTaxSlabId IS NULL)
	BEGIN


		INSERT INTO @TaxSlabs
		SELECT TS.Id,
		       TS.[Order],
			   TS.MinAge,
			   TS.MaxAge,
			   TS.ForMale,
			   TS.ForFemale,
			   TS.Handicapped,
			   NULL
		FROM @DefaultTaxSlabs TS
		WHERE TS.ParentId IS NULL
		      AND TS.IsArchived = 0
			  AND ((@Age BETWEEN TS.MinAge AND TS.MaxAge) OR (@Age >= TS.MinAge AND TS.MaxAge IS NULL) OR (@Age <= TS.MaxAge AND TS.MinAge IS NULL) OR TS.ForMale = @IsMale OR TS.ForFemale = ~@IsMale)
			  AND TS.[Order] IS NOT NULL
		ORDER BY TS.[Order]

		SELECT TOP 1 @ParentTaxSlabId = ParentTaxSlabId FROM @TaxSlabs WHERE [Order] = 1 ORDER BY ActiveFrom DESC	

		IF(@ParentTaxSlabId IS NULL) SELECT @ParentTaxSlabId = Id FROM @DefaultTaxSlabs WHERE ParentId IS NULL AND IsDefault = 1

	END

				INSERT INTO @TaxSlab(FromRange,ToRange,TaxPercentage,DifferenceValue)
				SELECT FromRange,
				       ToRange,
					   TaxPercentage,
					   CASE WHEN @NetSalary >= ToRange THEN ToRange - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) ELSE @NetSalary - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) END
				FROM TaxSlabs TS 
				WHERE (@NetSalary >= TS.ToRange OR @NetSalary BETWEEN TS.FromRange AND TS.ToRange OR (ToRange IS NULL AND @NetSalary >= FromRange))
				      AND ParentId IN (@ParentTaxSlabId)
					  AND TS.CountryId = @EmployeeCountryId
				UNION
		SELECT FromRange,
		       ToRange,
			   TaxPercentage,
			   CASE WHEN @NetSalary >= ToRange THEN ToRange - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) ELSE @NetSalary - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) END
		FROM @DefaultTaxSlabs TS 
		WHERE (@NetSalary >= TS.ToRange OR @NetSalary BETWEEN TS.FromRange AND TS.ToRange OR (ToRange IS NULL AND @NetSalary >= FromRange))
		      AND TS.ParentId = @ParentTaxSlabId

				UPDATE @TaxSlab SET RemainingValue = DifferenceValue * TaxPercentage * 0.01
				
				SELECT @TaxableAmount = SUM(RemainingValue) FROM @TaxSlab

				SELECT @TaxableAmount = @TaxableAmount + (@TaxableAmount * @EductaionCessPercenatge * 0.01)

			END

			UPDATE #TaxOfEmployees SET WithOutFlatSlabRateTax = ROUND(ISNULL(@TaxableAmount,0),0) WHERE Id = @EmployeesCounter 

			INSERT INTO EmployeeTax([Id],EmployeeId,TaxFinancialYearFromDate,TaxFinancialYearToDate,WithOutFlatSlabRateTaxableAmount,WithOutFlatSlabRateTax,WithFlatSlabRateTaxableAmount,WithFlatSlabRateTax,[CreatedDateTime],[CreatedByUserId])
			SELECT NEWID(),EmployeeId,TaxFinancialYearFromDate,TaxFinancialYearToDate,WithOutFlatSlabRateTaxableAmount,WithOutFlatSlabRateTax,WithFlatSlabRateTaxableAmount,WithFlatSlabRateTax,GETDATE(),@OperationsPerformedBy
			FROM #TaxOfEmployees
			WHERE EmployeeId = @EmployeeId

		END

		SET @EmployeesCounter = @EmployeesCounter + 1

	END


	SELECT * FROM #TaxOfEmployees
	
END
GO


--EXEC [USP_GetTaxOfEmployees] '1558A8BC-D112-4FA6-AF52-BD72BBE90F5B',NULL,'2020-05-15'