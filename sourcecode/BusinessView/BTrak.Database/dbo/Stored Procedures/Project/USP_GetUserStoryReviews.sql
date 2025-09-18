-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryReviews] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy='CreatedDateTime',@SortDirection='ASC'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryReviews]
(
    @UserStoryReviewId UNIQUEIDENTIFIER = NULL,
    @UserStoryReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@SubmittedDateTime DATETIME = NULL,
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

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [UserStoryReview])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT USR.Id AS UserStoryReviewId,
				   USR.UserStoryReviewTemplateId,
				   USR.AnswerJson,
				   USR.SubmittedDateTime,
				   USR.CreatedDateTime,
				   USR.CreatedByUserId,
				   USR.UpdatedDateTime,
				   USR.UpdatedByUserId,
				   USR.InActiveDateTime,
				   USR.[TimeStamp],	
				  CASE WHEN USR.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
			  FROM [dbo].[UserStoryReview] USR
			       INNER JOIN [UserStoryReviewTemplate]URT WITH (NOLOCK) ON USR.UserStoryReviewTemplateId = URT.Id
				    AND URT.InActiveDateTime IS NULL AND USR.InActiveDateTime IS NULL
				   INNER JOIN [ReviewTemplate] RT WITH (NOLOCK) ON RT.Id = URT.ReviewTemplateId AND RT.InActiveDateTime IS NULL
			  WHERE RT.CompanyId = @CompanyId
			        AND ((@UserStoryReviewId IS NULL OR USR.Id = @UserStoryReviewId))
					AND (@UserStoryReviewTemplateId IS NULL OR USR.UserStoryReviewTemplateId = @UserStoryReviewTemplateId)					
					AND (@SubmittedDateTime IS NULL OR USR.SubmittedDateTime = @SubmittedDateTime)			
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),USR.CreatedDateTime) LIKE @SearchText)
					                         OR (CONVERT(NVARCHAR(250),USR.SubmittedDateTime) LIKE @SearchText))											
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'SubmittedDateTime' THEN USR.SubmittedDateTime					  
							     WHEN @SortBy = 'CreatedDateTime' THEN USR.CreatedDateTime
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'SubmittedDateTime' THEN USR.SubmittedDateTime	 							  
							     WHEN @SortBy = 'CreatedDateTime' THEN USR.CreatedDateTime
							END
					  END DESC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize Rows ONLY

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END