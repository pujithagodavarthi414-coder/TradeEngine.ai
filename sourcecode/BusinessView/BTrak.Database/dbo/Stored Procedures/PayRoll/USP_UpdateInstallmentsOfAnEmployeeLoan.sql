CREATE PROCEDURE [dbo].[USP_UpdateInstallmentsOfAnEmployeeLoan]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeLoanInstallmentId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @EmployeeLoanId UNIQUEIDENTIFIER, @LoanTypeName NVARCHAR(100), @PrincipalAmount FLOAT, @InterestRatePerMonth FLOAT, @TimeInMonths FLOAT, @InterestRatePerYear FLOAT, @TimeInYears FLOAT, @Amount FLOAT, @Interest FLOAT,
	        @LoanTakenOn DATETIME, @LoanPaymentStartDate DATETIME, @Installments FLOAT, @MonthlyAmount FLOAT, @InterestPerMonth FLOAT, @MaxInstallmentDate DATETIME, @MinInstallmentDate DATETIME,
			@InstallmentDate DATETIME, @CurrentBalanceAmount FLOAT, @CompoundedPeriodName NVARCHAR(100), @CompoundedNumber FLOAT, @Timer INT = 1,
			@ClosingBalance FLOAT, @ClosingBalanceWithInterest FLOAT, @OpeningBalance FLOAT, @OpeningBalanceWithInterest FLOAT, @Part1 FLOAT, @Part2 FLOAT, @MaxClosingBalance FLOAT, @MaxClosingBalanceWithInterest FLOAT, @MinOpeningBalance FLOAT, @MinOpeningBalanceWithInterest FLOAT,
			@IsToBePaid BIT, @OriginalInstallmentAmount FLOAT, @InstallmentAmount FLOAT, @InstallmentAmountDiff FLOAT, @ShouldReCalculate BIT = 0, @PreviousEmployeeLoanInstallmentId UNIQUEIDENTIFIER

	SELECT @EmployeeLoanId = EmployeeLoanId, @IsToBePaid = IsToBePaid, @OriginalInstallmentAmount = OriginalInstallmentAmount, @InstallmentDate = InstalmentDate, @ClosingBalance = ClosingBalance, @ClosingBalanceWithInterest = ClosingBalanceWithInterest,
	       @OpeningBalance = OpeningBalance, @OpeningBalanceWithInterest = OpeningBalanceWithInterest, @InstallmentAmount = InstallmentAmount
	FROM EmployeeLoanInstallment WHERE Id = @EmployeeLoanInstallmentId
	
	SELECT @LoanTypeName = LT.LoanTypeName, @PrincipalAmount = LoanAmount, @InterestRatePerMonth = LoanInterestPercentagePerMonth, @TimeInMonths = TimePeriodInMonths, @LoanTakenOn = LoanTakenOn, 
	       @LoanPaymentStartDate = LoanPaymentStartDate, @CompoundedPeriodName = PT.PeriodTypeName
	FROM EmployeeLoan EL LEFT JOIN LoanType LT ON LT.Id = EL.LoanTypeId
	     LEFT JOIN PeriodType PT ON PT.Id = EL.CompoundedPeriodId AND EL.InActiveDateTime IS NULL
	WHERE EL.Id = @EmployeeLoanId AND EL.IsApproved = 1
	
	CREATE TABLE #OriginalLoanInstallments
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

	--IF(1=1)
	IF(@OriginalInstallmentAmount <> @InstallmentAmount AND @InstallmentDate IS NOT NULL AND @OriginalInstallmentAmount <> 0)
	BEGIN
	
		SELECT @MaxInstallmentDate = MAX(InstalmentDate) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate < @InstallmentDate AND IsArchived = 0

		SELECT @PreviousEmployeeLoanInstallmentId = Id FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate = @MaxInstallmentDate AND IsArchived = 0

		INSERT INTO #OriginalLoanInstallments
		EXEC [USP_GetUpdatedInstallmentsOfAnEmployeeLoan] @OperationsPerformedBy,@PreviousEmployeeLoanInstallmentId,@EmployeeLoanInstallmentId
		
		SELECT @InstallmentAmountDiff = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @InstallmentAmount - @OriginalInstallmentAmount ELSE @OriginalInstallmentAmount - @InstallmentAmount END 

		SELECT @ClosingBalance = ClosingBalance, @ClosingBalanceWithInterest = ClosingBalanceWithInterest,
	           @OpeningBalance = OpeningBalance, @OpeningBalanceWithInterest = OpeningBalanceWithInterest
		FROM #OriginalLoanInstallments WHERE InstallmentDate = @InstallmentDate
		
		SELECT @InterestPerMonth = ROUND(@OpeningBalance * (@InterestRatePerMonth/100.0),0)

		--SELECT @ClosingBalance = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @ClosingBalance - @InstallmentAmountDiff ELSE @ClosingBalance + @InstallmentAmountDiff END,
		--	   @ClosingBalanceWithInterest = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @ClosingBalanceWithInterest - @InstallmentAmountDiff ELSE @ClosingBalanceWithInterest + @InstallmentAmountDiff END
		--	   --@OpeningBalance = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @OpeningBalance - @InstallmentAmountDiff ELSE @OpeningBalance + @InstallmentAmountDiff END,
		--	   --@OpeningBalanceWithInterest = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @OpeningBalanceWithInterest - @InstallmentAmountDiff ELSE @OpeningBalanceWithInterest + @InstallmentAmountDiff END
		
		SELECT @ClosingBalance = @OpeningBalance - (@InstallmentAmount - @InterestPerMonth),
		       @ClosingBalanceWithInterest = @OpeningBalanceWithInterest - @InstallmentAmount
			
		UPDATE EmployeeLoanInstallment SET ClosingBalance = @ClosingBalance,
										   ClosingBalanceWithInterest = @ClosingBalanceWithInterest,
										   OpeningBalance = @OpeningBalance,
										   OpeningBalanceWithInterest = @OpeningBalanceWithInterest,
										   InstallmentAmount = @InstallmentAmount,
										   OriginalInstallmentAmount = @InstallmentAmount,
										   Interest = @InterestPerMonth,
										   PrincipalAmount = @InstallmentAmount - @InterestPerMonth
		WHERE Id = @EmployeeLoanInstallmentId

		SELECT @TimeInMonths = @TimeInMonths - ((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate < @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL)) - 1 -- For present updating record

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate > @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL

		SELECT @InstallmentDate = DATEADD(MONTH,1,@InstallmentDate), @PrincipalAmount = @ClosingBalance
		
		SET @ShouldReCalculate = 1

	END
	IF(@IsToBePaid = 0 AND @OriginalInstallmentAmount IS NOT NULL AND @InstallmentDate IS NOT NULL)
	BEGIN
	
		SELECT @ClosingBalance = ClosingBalance + @InstallmentAmount,
			   @ClosingBalanceWithInterest = ClosingBalanceWithInterest + @InstallmentAmount,
			   @OpeningBalance = OpeningBalance + @InstallmentAmount,
			   @OpeningBalanceWithInterest = OpeningBalanceWithInterest + @InstallmentAmount
		FROM EmployeeLoanInstallment
		WHERE Id = @EmployeeLoanInstallmentId

		--SELECT @TimeInMonths = @TimeInMonths - ((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate < @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL))

		SELECT @InterestPerMonth = ROUND(@OpeningBalance * (@InterestRatePerMonth/100.0),0)
		SELECT @InstallmentAmount = 0

		UPDATE EmployeeLoanInstallment SET ClosingBalance = @ClosingBalance,
										   ClosingBalanceWithInterest = @ClosingBalanceWithInterest,
										   OpeningBalance = @OpeningBalance,
										   OpeningBalanceWithInterest = @OpeningBalanceWithInterest,
										   InstallmentAmount = @InstallmentAmount,
										   OriginalInstallmentAmount = @InstallmentAmount,
										   Interest = @InterestPerMonth,
										   PrincipalAmount = @InstallmentAmount - @InterestPerMonth
		WHERE Id = @EmployeeLoanInstallmentId

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate > @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL

		SELECT @TimeInMonths = @TimeInMonths - ((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate <= @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL))

		SELECT @InstallmentDate = DATEADD(MONTH,1,@InstallmentDate), @PrincipalAmount = @ClosingBalance

		SET @ShouldReCalculate = 1

	END
	IF(@IsToBePaid = 1 AND @OriginalInstallmentAmount = 0)
	BEGIN
	
		SELECT @MaxInstallmentDate = MAX(InstalmentDate) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate < @InstallmentDate AND IsArchived = 0

		SELECT @PreviousEmployeeLoanInstallmentId = Id FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate = @MaxInstallmentDate AND IsArchived = 0

		INSERT INTO #OriginalLoanInstallments
		EXEC [USP_GetUpdatedInstallmentsOfAnEmployeeLoan] @OperationsPerformedBy,@PreviousEmployeeLoanInstallmentId,@EmployeeLoanInstallmentId
		
		SELECT @InstallmentAmountDiff = CASE WHEN @InstallmentAmount > @OriginalInstallmentAmount THEN @InstallmentAmount - @OriginalInstallmentAmount ELSE @OriginalInstallmentAmount - @InstallmentAmount END 

		SELECT @ClosingBalance = ClosingBalance, @ClosingBalanceWithInterest = ClosingBalanceWithInterest,
	           @OpeningBalance = OpeningBalance, @OpeningBalanceWithInterest = OpeningBalanceWithInterest
		FROM #OriginalLoanInstallments WHERE InstallmentDate = @InstallmentDate
		
		SELECT @InterestPerMonth = ROUND(@OpeningBalance * (@InterestRatePerMonth/100.0),0)
		
		SELECT @ClosingBalance = @OpeningBalance - (@InstallmentAmount - @InterestPerMonth),
		       @ClosingBalanceWithInterest = @OpeningBalanceWithInterest - @InstallmentAmount
			
		UPDATE EmployeeLoanInstallment SET ClosingBalance = @ClosingBalance,
										   ClosingBalanceWithInterest = @ClosingBalanceWithInterest,
										   OpeningBalance = @OpeningBalance,
										   OpeningBalanceWithInterest = @OpeningBalanceWithInterest,
										   InstallmentAmount = @InstallmentAmount,
										   OriginalInstallmentAmount = @InstallmentAmount,
										   Interest = @InterestPerMonth,
										   PrincipalAmount = @InstallmentAmount - @InterestPerMonth
		WHERE Id = @EmployeeLoanInstallmentId

		SELECT @TimeInMonths = @TimeInMonths - ((SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate < @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL)) - 1 -- For present updating record

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate > @InstallmentDate AND IsArchived = 0 AND InstalmentDate IS NOT NULL

		SELECT @InstallmentDate = DATEADD(MONTH,1,@InstallmentDate), @PrincipalAmount = @ClosingBalance
		
		SET @ShouldReCalculate = 1

	END
	IF(@InstallmentDate IS NULL AND @OriginalInstallmentAmount IS NULL)
	BEGIN

		SELECT @MinInstallmentDate = MIN(InstalmentDate) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0

		SELECT @MinOpeningBalance = OpeningBalance, @MinOpeningBalanceWithInterest = OpeningBalanceWithInterest, @InterestPerMonth = Interest
		FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate = @MinInstallmentDate AND IsArchived = 0

		SELECT @InterestPerMonth = ROUND(@MinOpeningBalance * (@InterestRatePerMonth/100.0),0)
		
		SELECT @ClosingBalance = @MinOpeningBalance - (@InstallmentAmount - @InterestPerMonth),
		       @ClosingBalanceWithInterest = @MinOpeningBalanceWithInterest - @InstallmentAmount
			
		UPDATE EmployeeLoanInstallment SET ClosingBalance = @ClosingBalance,
										   ClosingBalanceWithInterest = @ClosingBalanceWithInterest,
										   OpeningBalance = @MinOpeningBalance,
										   OpeningBalanceWithInterest = @MinOpeningBalanceWithInterest,
										   InstallmentAmount = @InstallmentAmount,
										   OriginalInstallmentAmount = @InstallmentAmount,
										   Interest = @InterestPerMonth,
										   PrincipalAmount = @InstallmentAmount - @InterestPerMonth
		WHERE Id = @EmployeeLoanInstallmentId

		SELECT @TimeInMonths = @TimeInMonths - (SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid IS NULL AND IsArchived = 0 AND InstalmentDate IS NOT NULL)

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0 AND InstalmentDate IS NOT NULL

		SELECT @InstallmentDate = @MinInstallmentDate, @PrincipalAmount = @ClosingBalance

		SET @ShouldReCalculate = 1

	END
	IF(@OriginalInstallmentAmount <> @InstallmentAmount AND @InstallmentDate IS NULL AND @OriginalInstallmentAmount <> 0)
	BEGIN
	
		SELECT @MinInstallmentDate = MIN(InstalmentDate) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0

		SELECT @MinOpeningBalance = OpeningBalance, @MinOpeningBalanceWithInterest = OpeningBalanceWithInterest, @InterestPerMonth = Interest
		FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND InstalmentDate = @MinInstallmentDate AND IsArchived = 0

		SELECT @InterestPerMonth = ROUND(@MinOpeningBalance * (@InterestRatePerMonth/100.0),0)
		
		SELECT @ClosingBalance = @MinOpeningBalance - (@InstallmentAmount - @InterestPerMonth),
		       @ClosingBalanceWithInterest = @MinOpeningBalanceWithInterest - @InstallmentAmount
			
		UPDATE EmployeeLoanInstallment SET ClosingBalance = @ClosingBalance,
										   ClosingBalanceWithInterest = @ClosingBalanceWithInterest,
										   OpeningBalance = @MinOpeningBalance,
										   OpeningBalanceWithInterest = @MinOpeningBalanceWithInterest,
										   InstallmentAmount = @InstallmentAmount,
										   OriginalInstallmentAmount = @InstallmentAmount,
										   Interest = @InterestPerMonth,
										   PrincipalAmount = @InstallmentAmount - @InterestPerMonth
		WHERE Id = @EmployeeLoanInstallmentId

		SELECT @TimeInMonths = @TimeInMonths - (SELECT COUNT(1) FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid IS NULL AND IsArchived = 0 AND InstalmentDate IS NOT NULL)

		UPDATE EmployeeLoanInstallment SET IsArchived = 1 WHERE EmployeeLoanId = @EmployeeLoanId AND IsToBePaid = 1 AND IsArchived = 0 AND InstalmentDate IS NOT NULL

		SELECT @InstallmentDate = @MinInstallmentDate, @PrincipalAmount = @ClosingBalance

		SET @ShouldReCalculate = 1

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

	IF(@ShouldReCalculate = 1)
	BEGIN

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

		INSERT INTO EmployeeLoanInstallment(Id,EmployeeLoanId,InstalmentDate,InstallmentAmount,OriginalInstallmentAmount,Interest,PrincipalAmount,ClosingBalance,ClosingBalanceWithInterest,OpeningBalance,OpeningBalanceWithInterest,IsToBePaid,IsArchived,CreatedDateTime,CreatedByUserId)
		SELECT NEWID(),@EmployeeLoanId,InstallmentDate,TotalPayment,TotalPayment,Interest,Principal,ClosingBalance,ClosingBalanceWithInterest,OpeningBalance,OpeningBalanceWithInterest,1,0,GETDATE(),@OperationsPerformedBy
		FROM #LoanInstallments

		--SELECT * FROM #LoanInstallments
	 -- SELECT * FROM EmployeeLoanInstallment WHERE EmployeeLoanId = @EmployeeLoanId AND IsArchived = 0 ORDER BY InstalmentDate
	    SELECT @EmployeeLoanInstallmentId

	END
	
END
GO

--EXEC [USP_UpdateInstallmentsOfAnEmployeeLoan] 'A7D24F90-0483-41A1-91CD-8866BF48FE6C','8E1170B2-407D-4EE0-88BC-1FFEE35A7D9B'