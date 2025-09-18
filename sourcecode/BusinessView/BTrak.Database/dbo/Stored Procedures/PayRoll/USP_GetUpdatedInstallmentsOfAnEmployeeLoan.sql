CREATE PROCEDURE [dbo].[USP_GetUpdatedInstallmentsOfAnEmployeeLoan]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PreviousEmployeeLoanInstallmentId UNIQUEIDENTIFIER,
	@PresentEmployeeLoanInstallmentId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @EmployeeLoanInstallmentId UNIQUEIDENTIFIER, @EmployeeLoanId UNIQUEIDENTIFIER, @LoanTypeName NVARCHAR(100), @PrincipalAmount FLOAT, @InterestRatePerMonth FLOAT, @TimeInMonths FLOAT, @InterestRatePerYear FLOAT, @TimeInYears FLOAT, @Amount FLOAT, @Interest FLOAT,
	        @LoanTakenOn DATETIME, @LoanPaymentStartDate DATETIME, @Installments FLOAT, @MonthlyAmount FLOAT, @InterestPerMonth FLOAT, @MaxInstallmentDate DATETIME,
			@InstallmentDate DATETIME, @CurrentBalanceAmount FLOAT, @CompoundedPeriodName NVARCHAR(100), @CompoundedNumber FLOAT, @Timer INT = 1,
			@ClosingBalance FLOAT, @ClosingBalanceWithInterest FLOAT, @OpeningBalance FLOAT, @OpeningBalanceWithInterest FLOAT, @Part1 FLOAT, @Part2 FLOAT, @MaxClosingBalance FLOAT, @MaxClosingBalanceWithInterest FLOAT,
			@IsToBePaid BIT, @OriginalInstallmentAmount FLOAT, @InstallmentAmount FLOAT, @InstallmentAmountDiff FLOAT, @ShouldReCalculate BIT = 0

	IF(@PreviousEmployeeLoanInstallmentId IS NULL) SELECT @EmployeeLoanInstallmentId = @PresentEmployeeLoanInstallmentId
	ELSE  SELECT @EmployeeLoanInstallmentId = @PreviousEmployeeLoanInstallmentId
	
	SELECT @EmployeeLoanId = EmployeeLoanId
	FROM EmployeeLoanInstallment WHERE Id = @EmployeeLoanInstallmentId

	SELECT @LoanTypeName = LT.LoanTypeName, @PrincipalAmount = LoanAmount, @InterestRatePerMonth = LoanInterestPercentagePerMonth, @TimeInMonths = TimePeriodInMonths,       
	       @LoanTakenOn = LoanTakenOn, @LoanPaymentStartDate = LoanPaymentStartDate, @CompoundedPeriodName = PT.PeriodTypeName
	FROM EmployeeLoan EL LEFT JOIN LoanType LT ON LT.Id = EL.LoanTypeId
	     LEFT JOIN PeriodType PT ON PT.Id = EL.CompoundedPeriodId AND EL.InActiveDateTime IS NULL
	WHERE EL.Id = @EmployeeLoanId AND EL.IsApproved = 1
	
	IF(@PreviousEmployeeLoanInstallmentId IS NOT NULL)
	BEGIN

		SELECT @EmployeeLoanId = EmployeeLoanId, @IsToBePaid = IsToBePaid, @OriginalInstallmentAmount = OriginalInstallmentAmount, @InstallmentDate = InstalmentDate, @ClosingBalance = ClosingBalance, @ClosingBalanceWithInterest = ClosingBalanceWithInterest,
	           @OpeningBalance = OpeningBalance, @OpeningBalanceWithInterest = OpeningBalanceWithInterest, @InstallmentAmount = InstallmentAmount
	    FROM EmployeeLoanInstallment WHERE Id = @EmployeeLoanInstallmentId

		SELECT @TimeInMonths = @TimeInMonths - (SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate <= @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL)
		
		SELECT @InstallmentDate = DATEADD(MONTH,1,@InstallmentDate), @PrincipalAmount = @ClosingBalance

	END
	
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
	
	SELECT @InstallmentDate = CASE WHEN @InstallmentDate IS NULL THEN @LoanPaymentStartDate ELSE @InstallmentDate END
	SELECT @InterestRatePerYear = ROUND(@InterestRatePerMonth * 12,0), @TimeInYears = ROUND(@TimeInMonths/12,2)

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

	SELECT * FROM #LoanInstallments
	
END
GO

--EXEC [USP_GetUpdatedInstallmentsOfAnEmployeeLoan] '8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2',NULL,'BA29B92C-85C5-419C-8239-128180EBBD05'



