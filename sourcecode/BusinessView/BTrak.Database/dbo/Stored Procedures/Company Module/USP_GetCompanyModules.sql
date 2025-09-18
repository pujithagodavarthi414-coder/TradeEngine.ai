-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Get the Notifications Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCompanyModules] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCompanyModules]
(
    @CompanyModuleId UNIQUEIDENTIFIER = NULL,
	@ModuleId UNIQUEIDENTIFIER = NULL,
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

 	             IF(@ModuleId = '00000000-0000-0000-0000-000000000000') SET  @ModuleId = NULL
		         
		         IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		         
		         IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		         
		         IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [CompanyModule])
		         
		         IF(@PageNumber IS NULL) SET @PageNumber = 1

			     SELECT CM.Id AS CompanyModuleId,
			            CM.CompanyId,
				        CM.ModuleId,				  
				        CM.CreatedByUserId,
				        CM.CreatedDateTime,
				        CM.InActiveDateTime,
				        M.ModuleName,
						CM.IsEnabled,
						CM.IsActive
			       FROM [CompanyModule] CM WITH (NOLOCK) 
			            INNER JOIN Module M WITH (NOLOCK) ON CM.ModuleId = M.Id
			     WHERE CM.CompanyId = @CompanyId 
			           AND CM.InActiveDateTime IS NULL
                       AND (@ModuleId IS NULL OR CM.ModuleId = @ModuleId)
			    	   AND (@ModuleId IS NULL OR CM.Id = @CompanyModuleId)														
			     ORDER BY 
				      CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CM.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CM.CreatedDateTime,121) AS sql_variant)
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
