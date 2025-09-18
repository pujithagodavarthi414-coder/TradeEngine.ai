CREATE PROCEDURE [dbo].[USP_GetEmployeeLoanInstallment]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT ELI.Id, 
		ELI.EmployeeLoanId, 
		dbo.Ufn_GetCurrency(CU.CurrencyCode,PrincipalAmount,1) ModifiedPrincipalAmount, 
		PaidAmount, 
		PrincipalAmount, 
		InstallmentAmount, 
		dbo.Ufn_GetCurrency(CU.CurrencyCode,InstallmentAmount,1) ModifiedInstallmentAmount, 
		InstalmentDate AS InstallmentDate, 
		IsTobePaid , 
		ELI.TimeStamp ,
		EL.LoanTakenOn,EL.LoanInterestPercentagePerMonth,EL.LoanPaymentStartDate,EL.[Name] LoanName,EL.TimePeriodInMonths
				FROM EmployeeLoanInstallment AS ELI
				JOIN EmployeeLoan AS EL ON EL.Id = ELI.EmployeeLoanId AND EL.InactiveDateTime IS NULL 
				JOIN Employee AS E ON E.Id = EL.EmployeeId AND E.InActiveDateTime IS NULL
				JOIN [User] AS U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
				LEFT JOIN Currency CU on CU.Id = U.CurrencyId
				WHERE U.CompanyId = @CompanyId 
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				AND U.CompanyId  = @CompanyId 
				AND (((@IsArchived = 0 OR @IsArchived IS NULL) AND (ELI.IsArchived = 0 OR ELI.IsArchived IS NULL)AND ELI.InactiveDateTime IS NULL) OR 
						(@IsArchived = 1 AND ELI.IsArchived = 1 AND ELI.InactiveDateTime IS NOT NULL))
				AND EL.IsApproved = 1
		ORDER BY InstallmentDate

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
