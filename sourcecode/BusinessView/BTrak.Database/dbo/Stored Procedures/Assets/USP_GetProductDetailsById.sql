-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Get ProductDetails By ProductDetailsId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get ProductDetails By ProductDetailsId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_GetProductDetailsById  @OperationPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ProductDetailsId = '3E225E79-67EC-4B3D-AE19-2A9EA1DEC83F'

CREATE PROCEDURE [dbo].[USP_GetProductDetailsById]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProductDetailsId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	  
	  IF (@HavePermission = '1')
	  BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT PD.Id AS ProductDetailsId,
			   PD.ProductId,
			   PD.ProductCode,
			   PD.SupplierId,
			   PD.ManufacturerCode,
			   PD.CreatedDateTime AS CreatedDate,
			   P.ProductName,
			   S.SupplierName,
			   PD.CreatedByUserId
        FROM [ProductDetails] AS PD WITH (NOLOCK)
		     INNER JOIN Product P ON PD.ProductId = P.Id
		     INNER JOIN Supplier S ON PD.SupplierId = S.Id
        WHERE (@ProductDetailsId IS NULL OR PD.Id = @ProductDetailsId)
		      AND P.CompanyId = @CompanyId
    
	 END
     ELSE
	 BEGIN
    
	  RAISERROR(@HavePermission,11,1)
     
	 END
    END TRY
    BEGIN CATCH
        
        EXEC [dbo].[USP_GetErrorInformation]

    END CATCH
END
GO