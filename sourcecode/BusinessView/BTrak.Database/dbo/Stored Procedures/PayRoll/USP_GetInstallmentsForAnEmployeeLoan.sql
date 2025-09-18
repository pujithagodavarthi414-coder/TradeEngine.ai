CREATE PROCEDURE [dbo].[USP_GetInstallmentsForAnEmployeeLoan]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeLoanId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @LoanTypeName NVARCHAR(100), @PrincipalAmount FLOAT, @InterestRatePerMonth FLOAT, @TimeInMonths FLOAT, @InterestRatePerYear FLOAT, @TimeInYears FLOAT, @Amount FLOAT, @Interest FLOAT,
	        @LoanTakenOn DATETIME,@LoanEndDate DATETIME, @LoanPaymentStartDate DATETIME, @Installments FLOAT, @MonthlyAmount FLOAT, @InterestPerMonth FLOAT, @MaxInstallmentDate DATETIME,
			@InstallmentDate DATETIME, @CurrentBalanceAmount FLOAT, @CompoundedPeriodName NVARCHAR(100), @CompoundedNumber FLOAT, @Timer INT = 1,
			@ClosingBalance FLOAT, @ClosingBalanceWithInterest FLOAT, @OpeningBalance FLOAT, @OpeningBalanceWithInterest FLOAT, @Part1 FLOAT, @Part2 FLOAT, @MaxClosingBalance FLOAT, @MaxClosingBalanceWithInterest FLOAT,
			@DailyInterest FLOAT = 1

	SELECT @LoanTypeName = LT.LoanTypeName, @PrincipalAmount = LoanAmount, @InterestRatePerMonth = LoanInterestPercentagePerMonth, @TimeInMonths = TimePeriodInMonths, @LoanTakenOn = LoanTakenOn, 
	       @LoanPaymentStartDate = LoanPaymentStartDate, @CompoundedPeriodName = PT.PeriodTypeName
	FROM EmployeeLoan EL LEFT JOIN LoanType LT ON LT.Id = EL.LoanTypeId
	     LEFT JOIN PeriodType PT ON PT.Id = EL.CompoundedPeriodId
	WHERE EL.Id = @EmployeeLoanId AND EL.IsApproved = 1 AND EL.InActiveDateTime IS NULL
	
	CREATE TABLE #LoanInstallments
	(
	    Id INT,
		InstallmentDate DATE,
		Principal FLOAT,
		Interest FLOAT,
		TotalPayment FLOAT,	
		ClosingBalance FLOAT,
		ClosingBalanceWithInterest FLOAT,
		OpeningBalance FLOAT,
		OpeningBalanceWithInterest FLOAT
	)
	
	IF((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid IS NULL AND IsArchived = 0) > 0 AND
	   (SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0) > 0)
	BEGIN
		
		SELECT @MaxInstallmentDate = MAX(InstalmentDate) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid IS NULL AND IsArchived = 0
		
		SELECT @MaxClosingBalance = ClosingBalance, @MaxClosingBalanceWithInterest = ClosingBalanceWithInterest
		FROM EmployeeLoanInstallment 
		WHERE EmployeeLoanId = @EmployeeLoanId
		      AND InstalmentDate = @MaxInstallmentDate AND IsArchived = 0
		
		SELECT @PrincipalAmount = @MaxClosingBalance

		SELECT @TimeInMonths = @TimeInMonths - (SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid IS NULL AND IsArchived = 0)

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate > @MaxInstallmentDate AND IsArchived = 0

		SELECT @InstallmentDate = DATEADD(MONTH,1,@MaxInstallmentDate)

		SELECT @DailyInterest = 0
	  
	END
	ELSE IF((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0) > 0)
	BEGIN
		
		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0

		SELECT @InstallmentDate = @LoanPaymentStartDate
	  
		SELECT @DailyInterest = 1

	END

	SELECT @InstallmentDate = CASE WHEN @InstallmentDate IS NULL THEN @LoanPaymentStartDate ELSE @InstallmentDate END
	--SELECT @InterestRatePerMonth = @InterestRatePerMonth/100.0
	SELECT @InterestRatePerYear = ROUND(@InterestRatePerMonth * 12,0), @TimeInYears = ROUND(@TimeInMonths/12,2)--, @LoanEndDate = DATEADD(MONTH,@TimeInMonths,@LoanTakenOn)
	--SELECT @Installments = DATEDIFF(MONTH,@LoanPaymentStartDate,@LoanEndDate)

	IF(@LoanTypeName = 'Simple')
	BEGIN

		SELECT @Interest = ROUND((@PrincipalAmount * @TimeInYears * @InterestRatePerYear)/100.0,0)

		SELECT @Amount = @PrincipalAmount + ISNULL(@Interest,0)
		
		SELECT @InterestPerMonth = ROUND(@Interest/@TimeInMonths,0)

		SELECT @MonthlyAmount = ROUND(@Amount/(@TimeInMonths*1.0),0)
		
	END
	ELSE IF(@LoanTypeName = 'Compound')
	BEGIN

		IF(@CompoundedPeriodName = 'Every month')
		BEGIN

			SELECT @CompoundedNumber = 12

		END
		ELSE IF(@CompoundedPeriodName = 'Every quarter')
		BEGIN

			SELECT @CompoundedNumber = 4

		END
		ELSE IF(@CompoundedPeriodName = 'Every halfyearly')
		BEGIN

			SELECT @CompoundedNumber = 2

		END
		ELSE IF(@CompoundedPeriodName = 'Yearly')
		BEGIN

			SELECT @CompoundedNumber = 1

		END

		SELECT @Part1 = ROUND(1 + (@InterestRatePerYear/100) / @CompoundedNumber,5),
		       @Part2 = (@CompoundedNumber*@TimeInMonths)/12.0
		
		SELECT @Amount = ROUND(@PrincipalAmount * POWER(@Part1,@Part2),0)

		SELECT @Interest = @Amount - @PrincipalAmount

		SELECT @InterestPerMonth = ROUND(@Interest/@TimeInMonths,0)

		SELECT @MonthlyAmount = ROUND(@Amount/(@TimeInMonths*1.0),0)

	END
	ELSE -- EMI calculation
	BEGIN
	
		SELECT @Part1 = POWER(1+(@InterestRatePerMonth/100.0),@TimeInMonths),
		       @Part2 = POWER(1+(@InterestRatePerMonth/100.0),@TimeInMonths) - 1
			   
		IF(@DailyInterest = 1)
		BEGIN

			SELECT @MonthlyAmount = ROUND(((@PrincipalAmount * (@InterestRatePerMonth/100.0) * @Part1)/@Part2),0)

			SELECT @DailyInterest = ((@MonthlyAmount * @TimeInMonths) - @PrincipalAmount) / (DATEDIFF(DAY,@LoanPaymentStartDate,DATEADD(MONTH,6,@LoanPaymentStartDate)))

			SELECT @PrincipalAmount = @PrincipalAmount + ISNULL(DATEDIFF(DAY,@LoanTakenOn,@LoanPaymentStartDate) * @DailyInterest,0)

		END

		SELECT @MonthlyAmount = ROUND(((@PrincipalAmount * (@InterestRatePerMonth/100.0) * @Part1)/@Part2),0)

	END
	
	--SELECT @Amount,  @Interest, @MonthlyAmount, @InterestPerMonth
	
	WHILE(@Timer <= @TimeInMonths)
	BEGIN

		SELECT @ClosingBalance = ClosingBalance, @ClosingBalanceWithInterest = ClosingBalanceWithInterest 
		FROM #LoanInstallments WHERE Id = @Timer - 1

		SELECT @ClosingBalance = CASE WHEN @ClosingBalance IS NULL THEN @PrincipalAmount ELSE @ClosingBalance END,
		       @ClosingBalanceWithInterest = CASE WHEN @ClosingBalanceWithInterest IS NULL THEN @MonthlyAmount * @TimeInMonths ELSE @ClosingBalanceWithInterest END

		SELECT @OpeningBalance = @ClosingBalance, @OpeningBalanceWithInterest = @ClosingBalanceWithInterest

		SELECT @InterestPerMonth = CASE WHEN @LoanTypeName IN ('Simple','Compound') THEN @InterestPerMonth ELSE ROUND(@ClosingBalance * (@InterestRatePerMonth/100.0),0) END

		INSERT INTO #LoanInstallments(Id,InstallmentDate,PrinciPal,Interest,TotalPayment,ClosingBalance,ClosingBalanceWithInterest,OpeningBalance,OpeningBalanceWithInterest)
		SELECT @Timer,@InstallmentDate,@MonthlyAmount - @InterestPerMonth,@InterestPerMonth,@MonthlyAmount,@ClosingBalance - (@MonthlyAmount - ISNULL(@InterestPerMonth,0)),@ClosingBalanceWithInterest - @MonthlyAmount,@OpeningBalance,@OpeningBalanceWithInterest

		SET @InstallmentDate = DATEADD(MONTH,1,@InstallmentDate)

		SET @Timer = @Timer + 1
		
	END

	INSERT INTO EmployeeLoanInstallment(Id,EmployeeLoanId,InstalmentDate,InstallmentAmount,OriginalInstallmentAmount,Interest,PrincipalAmount,ClosingBalance,ClosingBalanceWithInterest,OpeningBalance,OpeningBalanceWithInterest,IsToBePaid,IsArchived,CreatedDateTime,CreatedByUserId)
	SELECT NEWID(),@EmployeeLoanId,InstallmentDate,TotalPayment,TotalPayment,Interest,Principal,ClosingBalance,ClosingBalanceWithInterest,OpeningBalance,OpeningBalanceWithInterest,1,0,GETDATE(),@OperationsPerformedBy
	FROM #LoanInstallments

	--SELECT * FROM #LoanInstallments
	--SELECT * FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsArchived = 0 ORDER BY InstalmentDate
	SELECT @EmployeeLoanId
	
END
GO

--EXEC [USP_GetInstallmentsForAnEmployeeLoan] '8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2','9F02111E-A640-43A3-BF2A-C68E99B835B9'