-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2025-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeCreditorDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeCreditorDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeCreditorDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@UseForPerformaInvoice BIT= NULL,
	@EmployeeCreditorDetailsId UNIQUEIDENTIFIER = NULL
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

		   IF(@EmployeeCreditorDetailsId = '00000000-0000-0000-0000-000000000000') SET @EmployeeCreditorDetailsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ECD.Id AS EmployeeCreditorDetailsId,
				  ECD.[BranchId],
				  BL.BankName,
				  ECD.[BankId],
				  ECD.AccountNumber,
				  ECD.AccountName, 
				  ECD.IfScCode, 
				  B.[BranchName],	
		   	      ECD.InActiveDateTime,
		   	      ECD.CreatedDateTime ,
		   	      ECD.CreatedByUserId,
		   	      ECD.[TimeStamp],
				  ECD.Email,
				  ECD.MobileNo,
				  (CASE WHEN ECD.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				  ECD.UseForPerformaInvoice,
				  ECD.PanNumber,
		   	      TotalCount = COUNT(1) OVER()
           FROM EmployeeCreditorDetails AS ECD	
		   INNER JOIN Branch B ON B.Id = ECD.BranchId	
		   LEFT JOIN Bank BL ON BL.Id = ECD.BankId
           WHERE B.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR (B.[BranchName] LIKE  @SearchText))
		   	    AND (@EmployeeCreditorDetailsId IS NULL OR ECD.Id = @EmployeeCreditorDetailsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND ECD.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND ECD.InActiveDateTime IS NULL))
				AND (@UseForPerformaInvoice IS NULL OR(@UseForPerformaInvoice = 1 AND ECD.UseForPerformaInvoice = 1))
           ORDER BY ECD.CreatedDateTime DESC

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
