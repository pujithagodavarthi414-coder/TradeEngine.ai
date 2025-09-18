-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Get the Modules By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetUserStoryReviewComments] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetUserStoryReviewComments]
(
	@UserStoryReviewCommentId UNIQUEIDENTIFIER = NULL,
    @UserStoryId UNIQUEIDENTIFIER = NULL,
	@Comment NVARCHAR(250) = NULL,
	@UserStoryReviewStatusId UNIQUEIDENTIFIER = NULL,
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
	
	       --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))

        --   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	       --IF(@HavePermission = '1')
        --   BEGIN
			
		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		       
		       IF(@PageSize IS NULL)
		       SET @PageSize  = (SELECT COUNT(1) FROM UserStoryReviewComment)

	           IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryId = NULL
		       
			   IF(@UserStoryReviewCommentId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryReviewCommentId = NULL
		       
	           IF(@SearchText = '') SET  @SearchText = NULL
		       
		       IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		       
		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		       
		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Notification])
		       
		       IF(@PageNumber IS NULL) SET @PageNumber = 1
		       
		       SET @SearchText = '%' + @SearchText + '%'
		       
			    SELECT USRC.Id AS UserStoryReviewCommentId,
			    	   USRC.UserStoryId,
					   USRC.Comment,
					   USRC.UserStoryReviewStatusId,			  
			    	   USRC.CreatedByUserId,
			    	   USRC.CreatedDateTime,
			    	   USRC.InActiveDateTime,
					   USRC.[TimeStamp],
			    	   USRC.Id,
					   USRC.[TimeStamp],	
					   CASE WHEN USRC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					   TotalCount = COUNT(1) OVER()
			      FROM [dbo].[UserStoryReviewComment] USRC WITH (NOLOCK) 
				        INNER JOIN [UserStoryReview] USR WITH (NOLOCK)  ON USR.Id = USRC.UserStoryReviewStatusId AND USRC.InActiveDateTime IS NULL AND USR.InActiveDateTime IS NULL
						INNER JOIN [UserStoryReviewTemplate] USRT WITH (NOLOCK)  ON USRT.Id = USR.UserStoryReviewTemplateId AND USR.InActiveDateTime IS NULL AND USRT.InActiveDateTime IS NULL
						INNER JOIN [ReviewTemplate] RT WITH (NOLOCK)  ON RT.Id = USRT.ReviewTemplateId AND RT.InActiveDateTime IS NULL AND USRT.InActiveDateTime IS NULL
			      WHERE  RT.CompanyId = @CompanyId 					        
				        AND (@UserStoryId IS NULL OR USRC.UserStoryId = @UserStoryId )		
			    		AND (@UserStoryReviewCommentId IS NULL OR USRC.Id = @UserStoryReviewCommentId)
						AND (@UserStoryReviewStatusId IS NULL OR USRC.UserStoryReviewStatusId = @UserStoryReviewStatusId)								
			    		AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),USRC.CreatedDateTime) LIKE @SearchText)
						                         OR (CONVERT(NVARCHAR(250),USRC.Comment) LIKE @SearchText)
												     )											
			      ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
			    				CASE WHEN @SortBy = 'Comment' THEN USRC.Comment						  
			    				     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,USRC.CreatedDateTime,121) AS sql_variant)
			    				END
			    		  END ASC,
			    		  CASE WHEN @SortDirection = 'DESC' THEN
			    				CASE WHEN @SortBy = 'Comment' THEN USRC.Comment						  
			    				     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,USRC.CreatedDateTime,121) AS sql_variant)
			    				END
			    		  END DESC
		       
		       OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		       FETCH NEXT @PageSize Rows ONLY
   --   END
	  --ELSE
	  --BEGIN
	  
	  --     RAISERROR (@HavePermission,11, 1)
	  
	  --END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
