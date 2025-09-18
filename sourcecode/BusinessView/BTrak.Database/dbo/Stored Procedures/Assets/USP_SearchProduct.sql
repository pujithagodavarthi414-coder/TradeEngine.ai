-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Search Product
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search Product
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_SearchProduct @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchProduct]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProductName NVARCHAR(250) = NULL,
	@Pagesize INT = NULL,
    @Pagenumber INT = NULL,
	@ProductId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN

		  IF(@Pagesize IS NULL) SET @Pagesize = (SELECT COUNT(1) FROM Product)
		  
		  IF(@Pagesize = 0) SET @Pagesize = 10
		  
		  IF(@Pagenumber IS NULL) SET @Pagenumber = 1
		  
		  IF(@ProductName = '') SET @ProductName = NULL
		  
		  IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL
		  
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		  
          SELECT P.Id AS ProductId,
		  	   P.ProductName,
		  	   P.CreatedDateTime AS CreatedDate,
		  	   P.CreatedByUserId,
		  	   P.[TimeStamp],
		  	   TotalCount = COUNT(*) OVER()

          FROM Product AS P 
          WHERE (@ProductName IS NULL OR (P.ProductName LIKE '%'+ LOWER(@ProductName) +'%'))
		  	  AND (@ProductId IS NULL OR P.Id = @ProductId)
		  	  AND P.CompanyId = @CompanyId
          ORDER BY P.ProductName ASC OFFSET ((@Pagenumber - 1) * @Pagesize) ROWS
		  
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