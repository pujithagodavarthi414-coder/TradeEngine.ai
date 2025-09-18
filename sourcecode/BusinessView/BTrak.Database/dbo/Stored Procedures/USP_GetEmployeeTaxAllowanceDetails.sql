-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update TaxAllowance
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeTaxAllowanceDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeTaxAllowanceDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@EmployeeTaxAllowanceId UNIQUEIDENTIFIER = NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL
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

		   IF(@EmployeeTaxAllowanceId = '00000000-0000-0000-0000-000000000000') SET @EmployeeTaxAllowanceId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ETA.Id AS EmployeeTaxAllowanceId,
				  ETA.[EmployeeId],
		   	      ETA.[TaxAllowanceId],
				  ETA.[InvestedAmount],		
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,ETA.InvestedAmount,1) ModifiedInvestedAmount,
		   	      ETA.[ApprovedDateTime],
				  ETA.[ApprovedByEmployeeId], 
				  ETA.[IsAutoApproved],
				  ETA.[IsOnlyEmployee],
		   	      ETA.CreatedDateTime SubmittedDate,
		   	      ETA.CreatedByUserId,
		   	      ETA.[TimeStamp],
				  ETA.[IsRelatedToHRA],
				  ETA.[IsApproved],
				  ETA.OwnerPanNumber,
				  ETA.RelatedToMetroCity,
				  U.FirstName + ' ' + ISNULL(U.SurName,'') ApprovedBy,
				  TA.Name TaxAllowanceName,
				  (CASE WHEN ETA.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
				  ETA.Comments,
		   	      TotalCount = COUNT(1) OVER()
           FROM EmployeeTaxAllowances AS ETA		
		   INNER JOIN TaxAllowances TA ON TA.Id = ETA.TaxAllowanceId
		   INNER JOIN Employee E1 ON E1.Id = ETA.EmployeeId
		   INNER JOIN [User] U1 ON U1.Id = E1.UserId
		   LEFT JOIN Employee E ON E.Id = ETA.ApprovedByEmployeeId
		   LEFT JOIN [User] U ON U.Id = E.UserId
		   LEFT JOIN Currency CU on CU.Id = U1.CurrencyId
           WHERE (@EmployeeId IS NULL OR @EmployeeId = ETA.EmployeeId)
		    AND U1.CompanyId = @CompanyId
		    AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND ETA.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND ETA.InActiveDateTime IS NULL))	   	    
           ORDER BY ETA.CreatedDateTime DESC

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
