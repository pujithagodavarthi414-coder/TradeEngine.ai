-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Search ProductDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search ProductDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_SearchProductDetails @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@SortBy = 'SupplierName',@SortDirection = 'DESC'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchProductDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProductDetailsId UNIQUEIDENTIFIER = NULL,
	@ProductName NVARCHAR(250) = NULL,
	@ProductId UNIQUEIDENTIFIER = NULL,
	@SupplierId UNIQUEIDENTIFIER = NULL,
	@SearchProductCode NVARCHAR(250) = NULL,
	@SearchManufacturerCode NVARCHAR(250) = NULL,
	@Pagesize INT = NULL,
    @Pagenumber INT = NULL,  
	@IsArchived BIT = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@SortDirection NVARCHAR(50) = NULL,
    @SortBy NVARCHAR(100) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		    IF(@ProductName = '') SET @ProductName = NULL
		    
		    IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL
		    
		    IF(@Pagesize IS NULL) SET @Pagesize = (SELECT COUNT(1) FROM ProductDetails)
		    
		    IF(@Pagesize = 0) SET @Pagesize = 10
		    
		    IF(@Pagenumber IS NULL) SET @Pagenumber = 1

			IF(@SortBy IS NULL) SET @SortBy = 'ProductName'

        	IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'		

			IF(@ProductDetailsId = '00000000-0000-0000-0000-000000000000') SET @ProductDetailsId = NULL

			IF(@SupplierId = '00000000-0000-0000-0000-000000000000') SET @SupplierId = NULL

			SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

			SET @SearchProductCode = '%' + RTRIM(LTRIM(@SearchProductCode)) + '%'

			SET @SearchManufacturerCode = '%' + RTRIM(LTRIM(@SearchManufacturerCode)) + '%'
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PD.Id AS ProductDetailsId,
		   	      PD.ProductId,
		   	      P.ProductName,
		   	      PD.ProductCode,
		   	      PD.ManufacturerCode,
		   	      PD.SupplierId,
			      S.SupplierName,
		   	      PD.CreatedDateTime AS CreatedDate,
		   	      PD.CreatedByUserId,
				  PD.[TimeStamp],
				  CASE WHEN PD.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM ProductDetails AS PD
		        INNER JOIN Product AS P ON P.Id = PD.ProductId 
				           AND P.InactiveDateTime IS NULL
				INNER JOIN Supplier AS S ON PD.SupplierId = S.Id AND S.InactiveDateTime IS NULL
           WHERE P.CompanyId = @CompanyId
		        AND (@ProductDetailsId IS NULL OR (PD.Id = @ProductDetailsId))
		   	    AND (@ProductId IS NULL OR P.Id = @ProductId)
				AND (@SupplierId IS NULL OR PD.SupplierId = @SupplierId)
 				AND (@SearchProductCode IS NULL OR (PD.ProductCode LIKE @SearchProductCode))
			  	AND (@SearchManufacturerCode IS NULL OR (PD.ManufacturerCode LIKE @SearchManufacturerCode))
			  	AND (@SearchText IS NULL OR (PD.ProductCode LIKE @SearchText)
										 OR (PD.ManufacturerCode LIKE @SearchText))
		   	    AND (@ProductName IS NULL OR (P.ProductName LIKE '%'+ LOWER(@ProductName)+'%'))
				AND (@IsArchived IS NULL OR (@IsArchived =1 AND PD.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PD.InactiveDateTime IS NULL))
           ORDER BY 
		       CASE WHEN (@SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'ProductName') THEN   P.ProductName
                              WHEN(@SortBy = 'ProductCode') THEN CONVERT(NVARCHAR(250),PD.ProductCode)
                              WHEN(@SortBy = 'ManufacturerCode') THEN CONVERT(NVARCHAR(250),PD.ManufacturerCode)
							  WHEN(@SortBy = 'SupplierName') THEN S.SupplierName
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'ProductName') THEN   P.ProductName
                              WHEN(@SortBy = 'ProductCode') THEN CONVERT(NVARCHAR(250),PD.ProductCode)
                              WHEN(@SortBy = 'ManufacturerCode') THEN CONVERT(NVARCHAR(250),PD.ManufacturerCode)
							  WHEN(@SortBy = 'SupplierName') THEN S.SupplierName
                          END
                      END DESC
		
		OFFSET ((@Pagenumber - 1) * @Pagesize) ROWS
		   
           FETCH NEXT @Pagesize ROWS ONLY
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