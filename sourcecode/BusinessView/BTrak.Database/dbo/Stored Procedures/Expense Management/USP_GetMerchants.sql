-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the Merchants By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetMerchants] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetMerchants]
(
  @MerchantId UNIQUEIDENTIFIER = NULL,
  @MerchantName NVARCHAR(250) = NULL,
  @Description NVARCHAR(500) = NULL,
  @SearchText NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(50) = NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		   IF(@HavePermission = '1')			 
		   BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))		   
		     
	           IF(@MerchantId = '00000000-0000-0000-0000-000000000000') SET @MerchantId = NULL
		       
	           IF(@MerchantName = '') SET  @MerchantName = NULL
		     
	           IF(@Description = '') SET  @Description = NULL
		     
		       IF(@SearchText = '') SET  @SearchText = NULL
		     
		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Merchant])

			   IF(@PageSize = 0) SET @PageSize = 10
		     
		       IF(@PageNumber IS NULL) SET @PageNumber = 1
		     
	           SELECT M.Id AS MerchantId,
		              M.MerchantName,
		  	  	      M.[Description],
		              M.CompanyId,
		  	  	      M.CreatedByUserId,
		  	  	      M.CreatedDateTime,
					  M.[TimeStamp],
		              TotalCount = COUNT(1) OVER()
		       FROM  [dbo].[Merchant] M WITH (NOLOCK)
		       WHERE M.CompanyId = @CompanyId
					 AND (@IsArchived IS NULL 
					      OR (@IsArchived = 1 AND M.InActiveDateTime IS NOT NULL)
						  OR (@IsArchived = 0 AND M.InActiveDateTime IS NULL))
		             AND (@MerchantId IS NULL OR M.Id = @MerchantId)
		             AND (@MerchantName IS NULL OR M.MerchantName = @MerchantName)
		             AND (@Description IS NULL OR M.[Description] = @Description)
		             AND (@SearchText IS NULL 
					       OR (M.MerchantName LIKE @SearchText)
		  	  			   OR (M.[Description] LIKE @SearchText))
		       ORDER BY CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
		  	  			CASE WHEN @SortBy IS NULL OR @SortBy = 'MerchantName' THEN CAST(M.MerchantName AS varchar(250))
		  	  			     WHEN @SortBy = '[Description]' THEN M.[Description]
		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,M.CreatedDateTime,121) AS sql_variant)
		  	  			END
		  	  	  END ASC,
		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
		  	  			CASE WHEN @SortBy IS NULL OR @SortBy = 'MerchantName' THEN CAST(M.MerchantName AS varchar(250))
		  	  			     WHEN @SortBy = '[Description]' THEN M.[Description]
		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,M.CreatedDateTime,121) AS sql_variant)
		  	  			END
		  	  	  END DESC
		     OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		     FETCH NEXT @PageSize Rows ONLY 	
			   END
		   ELSE
		   BEGIN
		   
		   	RAISERROR (@HavePermission,11, 1)
		   		
		   END
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO