-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Get Product By ProductId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get Product By ProductId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC USP_GetProductsById @OperationPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ProductId = '5387F753-38B6-46F8-A9B7-C21A36FAD6BD'

CREATE PROCEDURE [dbo].[USP_GetProductsById]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProductId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
     BEGIN TRY
	  
	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	  
	  IF (@HavePermission = '1')
	  BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT P.Id AS ProductId,
			   P.CompanyId,
			   P.ProductName,
			   P.CreatedDateTime AS CreatedDate,
			   P.CreatedByUserId
        FROM [Product] AS P WITH (NOLOCK)
        WHERE (@ProductId IS NULL OR P.Id = @ProductId)
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