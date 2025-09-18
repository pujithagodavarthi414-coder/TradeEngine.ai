-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Get the  Feature Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetFeatureModules] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy='ModuleName',@SortDirection='ASC'

CREATE PROCEDURE [dbo].[USP_GetFeatureModules]
(   
    @FeatureModuleId UNIQUEIDENTIFIER = NULL,
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
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

		   IF(@PageSize IS NULL)
		   SET @PageSize  = (SELECT COUNT(1) FROM FeatureModule)

	       IF(@ModuleId = '00000000-0000-0000-0000-000000000000') SET  @ModuleId = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   SET @SearchText = '%' + @SearchText + '%'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Notification])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

			SELECT FM.Id AS FeatureModuleId,
				   FM.ModuleId,
				   FM.FeatureId,				  
				   FM.CreatedByUserId,
				   FM.CreatedDateTime,
				   FM.InActiveDateTime,
				   TotalCount = COUNT(1) OVER()
			 FROM [dbo].[FeatureModule] FM WITH (NOLOCK)
			      INNER JOIN [Module] M WITH (NOLOCK) ON M.Id=FM.ModuleId AND M.InActiveDateTime IS NULL AND (FM.InActiveDateTime IS NULL)
				  INNER JOIN [CompanyModule] CM WITH (NOLOCK) ON CM.ModuleId = M.Id AND (CM.InActiveDateTime IS NULL)		                             
			  WHERE CM.CompanyId = @CompanyId
			        AND (@FeatureModuleId IS NULL OR FM.Id = @FeatureModuleId)
					AND (@FeatureId IS NULL OR FM.FeatureId = @FeatureId)
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),FM.CreatedDateTime) LIKE @SearchText))
					AND (@ModuleId IS NULL OR FM.ModuleId = @ModuleId)
				    									
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE				  
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,FM.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE  						  
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,FM.CreatedDateTime,121) AS sql_variant)
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

		EXEC USP_GetErrorInformation

	END CATCH
END
