-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Get the Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetModules] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy='ModuleName',@SortDirection='ASC',@AsAtDateTime='2019-03-20'

CREATE PROCEDURE [dbo].[USP_GetModules]
(
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@ModuleName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
	@IsArchived BIT = NULL,
	@IsForCustomApp BIT = NULL,
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
		   SET @PageSize  = (SELECT COUNT(1) FROM Module)

	       IF(@ModuleId = '00000000-0000-0000-0000-000000000000') SET  @ModuleId = NULL

	       IF(@ModuleName = '') SET  @ModuleName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Notification])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   IF(@IsForCustomApp IS NULL)SET @IsForCustomApp = 0

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT M.Id AS ModuleId,
				   M.ModuleName,				  
				   M.CreatedByUserId,
				   M.CreatedDateTime,
				   M.InActiveDateTime,
				   M.[TimeStamp],
				   CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				   TotalCount = COUNT(1) OVER()
			  FROM [dbo].[Module]M WITH (NOLOCK)
			  
			  WHERE M.IsSystemModule = 0 AND
					(@ModuleName IS NULL OR M.ModuleName = @ModuleName)			
					AND (@ModuleId IS NULL OR M.Id = @ModuleId)					
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),M.CreatedDateTime) LIKE @SearchText))	
					AND (@IsArchived IS NULL OR (@IsArchived = 1 AND M.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND M.InActiveDateTime IS NULL))
															
					AND (@IsForCustomApp = 0 OR (@IsForCustomApp = 1 AND M.Id IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND IsActive = 1)))										
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'ModuleName' THEN M.ModuleName							  
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,M.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE  WHEN @SortBy = 'ModuleName' THEN M.ModuleName							  
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

		THROW

	END CATCH
END
