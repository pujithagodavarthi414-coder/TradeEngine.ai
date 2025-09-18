CREATE FUNCTION [dbo].[Ufn_GetPayrollBandsAmountOfAComponent]
(
	@PayrollComponentId UNIQUEIDENTIFIER,
	@Amount FLOAT,
	@RunStartDate DATE,
	@RunEndDate DATE,
	@EmployeeId UNIQUEIDENTIFIER
)
RETURNS FLOAT
AS
BEGIN
	
	DECLARE @BandsAmount FLOAT

	DECLARE @Gender NVARCHAR(100), @DateOfBirth DATE, @Age INT, @IsMale BIT, @IsMarried BIT, @MaritalStatus NVARCHAR(100),
	        @EmployeeBranchId UNIQUEIDENTIFIER, @EmployeeCountryId UNIQUEIDENTIFIER

	SELECT @DateOfBirth = DateOfBirth, @Gender = Gender, @MaritalStatus = MS.MaritalStatus 
	FROM Employee E LEFT JOIN Gender G ON G.Id = E.GenderId LEFT JOIN MaritalStatus MS ON MS.Id = E.MaritalStatusId
	WHERE E.Id = @EmployeeId
	
	SELECT @EmployeeBranchId = BranchId
		FROM EmployeeBranch EB
		WHERE EB.EmployeeId = @EmployeeId
		      AND ( (EB.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN EB.ActiveFrom AND EB.ActiveTo AND @RunEndDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			          OR (EB.ActiveTo IS NULL AND @RunEndDate >= EB.ActiveFrom)
					  OR (EB.ActiveTo IS NOT NULL AND @RunStartDate <= EB.ActiveTo AND @RunStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				  ) 
				 
		SELECT @EmployeeCountryId = CountryId FROM Branch WHERE Id = @EmployeeBranchId

	SELECT @Age = ISNULL(DATEDIFF(YEAR,@DateOfBirth,CAST(GETDATE() AS DATE)),0), 
	       @IsMale = CASE WHEN @Gender = 'Male' THEN 1 ELSE 0 END,
		   @IsMarried = CASE WHEN @MaritalStatus = 'Married' THEN 1 ELSE 0 END

	DECLARE @PayrollBands TABLE
	(
		[Order] INT IDENTITY(1,1),
		ParentId UNIQUEIDENTIFIER,
		[OriginalOrder] INT,
		MinAge FLOAT,
		MaxAge FLOAT,
		ForMale BIT,
		ForFemale BIT,
		Handicapped BIT,
		ActiveFrom DATETIME,
		IsMarried BIT
	)
	
	INSERT INTO @PayrollBands
	SELECT TS.Id,
	       TS.[Order],
		   TS.MinAge,
		   TS.MaxAge,
		   TS.ForMale,
		   TS.ForFemale,
		   TS.Handicapped,
		   TS.ActiveFrom,
		   TS.IsMarried
	FROM PayrollBands TS
	WHERE TS.ParentId IS NULL
	      AND TS.InactiveDateTime IS NULl
		  AND ( (TS.ActiveTo IS NOT NULL AND @RunStartDate BETWEEN TS.ActiveFrom AND TS.ActiveTo AND @RunEndDate BETWEEN TS.ActiveFrom AND TS.ActiveTo)
		            OR (TS.ActiveTo IS NULL AND @RunEndDate >= TS.ActiveFrom)
					OR (TS.ActiveTo IS NOT NULL AND @RunStartDate <= TS.ActiveTo)
			     )
		AND ((@Age BETWEEN TS.MinAge AND TS.MaxAge) OR @Age >= TS.MinAge OR @Age <= TS.MaxAge OR TS.ForMale = @IsMale OR TS.ForFemale = ~@IsMale)
		AND TS.[Order] IS NOT NULL
		AND TS.CountryId = @EmployeeCountryId
	ORDER BY TS.[Order],TS.ActiveFrom

	DECLARE @ParentId UNIQUEIDENTIFIER

	SELECT TOP 1 @ParentId = ParentId FROM @PayrollBands WHERE [Order] = 1 ORDER BY ActiveFrom DESC

	DECLARE @PayrollBand TABLE
	(
		FromRange FLOAT,
		ToRange FLOAT,
		TaxPercentage FLOAT,
		DifferenceValue FLOAT,
		RemainingValue FLOAT
	)

	INSERT INTO @PayrollBand(FromRange,ToRange,TaxPercentage,DifferenceValue)
	SELECT FromRange,
	       ToRange,
		   [Percentage],
		   CASE WHEN @Amount >= ToRange THEN ToRange - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) ELSE @Amount - (CASE WHEN FromRange <= 0 THEN FromRange ELSE FromRange - 1 END) END
	FROM PayRollBands TS 
	WHERE (@Amount >= TS.ToRange OR @Amount BETWEEN TS.FromRange AND TS.ToRange OR (ToRange IS NULL AND @Amount >= FromRange))
	      AND TS.ParentId = @ParentId
		  AND TS.CountryId = @EmployeeCountryId

	UPDATE @PayrollBand SET RemainingValue = DifferenceValue * TaxPercentage * 0.01
	
	SELECT @BandsAmount = SUM(RemainingValue) FROM @PayrollBand

	RETURN @BandsAmount

END
