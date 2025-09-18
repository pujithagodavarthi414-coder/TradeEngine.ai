-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-27 00:00:00.000'
-- Purpose      To Get the Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryReviewTemplates] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy='CreatedDateTime',@SortDirection='ASC'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryReviewTemplates]
(
    @UserStoryReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@ReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(100) = NULL,
	@ReviewerId UNIQUEIDENTIFIER = NULL,
	@ReviewComments NVARCHAR(250) = NULL,
	@IsAccepted BIT = NULL,
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

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [UserStoryReviewTemplate])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT URT.Id AS UserStoryReviewTemplateId,
				   URT.ReviewTemplateId,
				   URT.UserStoryId,
				   URT.ReviewerId,
				   URT.ReviewComments,
				   URT.IsAccepted,
				   URT.CreatedDateTime,
				   URT.CreatedByUserId,
				   URT.InActiveDateTime,
				   URT.[TimeStamp],	
				   CASE WHEN URT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	       TotalCount = COUNT(1) OVER()
			  FROM [dbo].[UserStoryReviewTemplate]URT WITH (NOLOCK)
			       INNER JOIN [ReviewTemplate]RT WITH (NOLOCK) ON RT.Id = URT.ReviewTemplateId AND RT.InActiveDateTime IS NULL AND URT.InActiveDateTime IS NULL
			  WHERE RT.CompanyId = @CompanyId
			        AND ((@UserStoryReviewTemplateId IS NULL OR URT.Id = @UserStoryReviewTemplateId))
					AND (@UserStoryId IS NULL OR URT.UserStoryId = @UserStoryId)
					AND (@ReviewerId IS NULL OR URT.ReviewerId = @ReviewerId)
					AND (@IsAccepted IS NULL OR URT.IsAccepted = @IsAccepted) 	
					AND (@ReviewComments IS NULL OR URT.ReviewComments = @ReviewComments)		        
					AND (@ReviewTemplateId IS NULL OR URT.Id = @ReviewTemplateId)				
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),URT.CreatedDateTime) LIKE @SearchText)
					                         OR (CONVERT(NVARCHAR(250),URT.ReviewComments) LIKE @SearchText)
											 OR (CONVERT(NVARCHAR(250),URT.IsAccepted) LIKE @SearchText)
					    )											
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'ReviewComments' THEN URT.ReviewComments	 					  
							     WHEN @SortBy = 'CreatedDateTime' THEN URT.CreatedDateTime
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'ReviewComments' THEN URT.ReviewComments	 							  
							     WHEN @SortBy = 'CreatedDateTime' THEN URT.CreatedDateTime
							END
					  END DESC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize Rows ONLY

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
