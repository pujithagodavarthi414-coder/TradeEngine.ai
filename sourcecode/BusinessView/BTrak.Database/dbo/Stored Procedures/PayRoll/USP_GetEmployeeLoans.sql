-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update TaxAllowance
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeLoans] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeLoans]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@EmployeeLoanId UNIQUEIDENTIFIER = NULL,
	@IsApproved BIT = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT EL.Id AS EmployeeLoanId,
				  EL.[EmployeeId],
				  EL.[LoanAmount],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,LoanAmount,1) ModifiedLoanAmount, 
				  EL.[LoanTakenOn],
				  EL.[LoanTypeId],
				  EL.[CompoundedPeriodId],
				  EL.[LoanPaymentStartDate],
				  EL.[LoanBalanceAmount],
				  EL.[LoanTotalPaidAmount],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,LoanBalanceAmount,1) ModifiedLoanBalanceAmount, 
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,LoanTotalPaidAmount,1) ModifiedTotalPaidAmount, 
				  EL.[LoanInterestPercentagePerMonth],
				  EL.[TimePeriodInMonths],
				  EL.[LoanClearedDate],
				  EL.[IsApproved],
				  U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
				  U.ProfileImage,
				  U.Id AS UserId,
				  LT.LoanTypeName,
				  PT.PeriodTypeName,			
				  (CASE WHEN EL.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
				  EL.[TimeStamp],
				  EL.[Name],
				  EL.[Description],
				  EL.IsPaid,
		   	      TotalCount = COUNT(1) OVER()
           FROM EmployeeLoan AS EL		
		   LEFT JOIN LoanType LT ON LT.Id = EL.LoanTypeId
		   INNER JOIN Employee E ON E.Id = EL.[EmployeeId]
		   INNER JOIN [User] U ON U.Id = E.UserId
		   LEFT JOIN Currency CU on CU.Id = U.CurrencyId
		   LEFT JOIN PeriodType PT ON PT.Id = EL.CompoundedPeriodId
           WHERE (@EmployeeLoanId IS NULL OR @EmployeeLoanId = EL.Id)
		    AND (@EmployeeId IS NULL OR @EmployeeId = EL.EmployeeId)
		    AND U.CompanyId = @CompanyId
		    AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND EL.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND EL.InActiveDateTime IS NULL))	
		    AND (@IsApproved IS NULL OR @IsApproved = EL.IsApproved)
           ORDER BY EL.CreatedDateTime DESC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO