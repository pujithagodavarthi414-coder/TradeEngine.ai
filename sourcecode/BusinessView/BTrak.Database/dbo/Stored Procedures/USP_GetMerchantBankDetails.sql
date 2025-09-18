----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-11-08 00:00:00.000'
-- Purpose      To Get Merchant Bank Details by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetMerchantBankDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @MerchantBankDetailsId = '5FB4F5AA-1D22-40A2-A0E5-3546E0DA2941'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetMerchantBankDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @MerchantBankDetailsId UNIQUEIDENTIFIER = NULL, 
	@ExpenseMerchantId UNIQUEIDENTIFIER = NULL, 
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN           

           IF(@ExpenseMerchantId = '00000000-0000-0000-0000-000000000000') SET @ExpenseMerchantId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT MBD.OriginalId AS MerchantBankDetailsId,
				  MBD.ExpenseMerchantId,
				  MBD.PayeeName,
				  MBD.BankName,
				  MBD.BranchName,
				  MBD.AccountNumber,
				  MBD.IFSCCode,
				  MBD.SortCode,
				  MBD.CreatedDateTime,
                  MBD.CreatedByUserId,
				  MBD.OriginalCreatedDateTime,
				  MBD.OriginalCreatedByUserId,
				  MBD.InActiveDateTime,
				  MBD.VersionNumber,
                  MBD.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM MerchantBankDetails AS MBD
		   LEFT JOIN ExpenseMerchant EM ON EM.OriginalId = MBD.ExpenseMerchantId
           WHERE (MBD.AsAtInactiveDateTime IS NULL)
				AND (EM.AsAtInactiveDateTime IS NULL)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND MBD.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND MBD.InactiveDateTime IS NULL))
                AND (@MerchantBankDetailsId IS NULL OR MBD.OriginalId = @MerchantBankDetailsId)
				AND (@ExpenseMerchantId IS NULL OR MBD.ExpenseMerchantId = @ExpenseMerchantId)
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
