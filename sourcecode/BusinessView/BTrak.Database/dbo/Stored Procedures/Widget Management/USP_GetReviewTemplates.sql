-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-26 00:00:00.000'
-- Purpose      To Get the Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetReviewTemplates] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy='CreatedDateTime',@SortDirection='ASC'

CREATE PROCEDURE [dbo].[USP_GetReviewTemplates]
(
	@ReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@UserStorySubTypeId UNIQUEIDENTIFIER = NULL,
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

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [ReviewTemplate])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT RT.Id AS ReviewTemplateId,
				   RT.TemplateJson,
				   RT.UserStorySubTypeId,
				   RT.CompanyId,
				   RT.CreatedDateTime,
				   RT.CreatedByUserId,
				   RT.InActiveDateTime
			  FROM [dbo].[ReviewTemplate]RT WITH (NOLOCK)
			  WHERE RT.CompanyId = @CompanyId 			        
					AND RT.InActiveDateTime IS NULL
					AND (@ReviewTemplateId IS NULL OR RT.Id = @ReviewTemplateId)
					AND (@UserStorySubTypeId IS NULL OR RT.UserStorySubTypeId = @UserStorySubTypeId)				
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),RT.CreatedDateTime) LIKE @SearchText))											
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE 						  
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,RT.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE  							  
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,RT.CreatedDateTime,121) AS sql_variant)
							END
					  END DESC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize Rows ONLY

	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
