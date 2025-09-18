-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Search the comments by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchComments] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchComments]
(
    @CommentId UNIQUEIDENTIFIER = NULL,
	@CommentedByUserId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@Comment NVARCHAR(800) = NULL,
	@AdminFlag BIT = NULL ,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageNumber INT = 1,
    @PageSize INT = 10
)
AS
BEGIN
        SET NOCOUNT ON
       
       	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF (@CommentId = '00000000-0000-0000-0000-000000000000') SET @CommentId = NULL

			IF (@CommentedByUserId = '00000000-0000-0000-0000-000000000000') SET @CommentedByUserId = NULL

			IF (@ReceiverId = '00000000-0000-0000-0000-000000000000') SET @ReceiverId = NULL

			IF (@Comment = '') SET @Comment = NULL

			SELECT C.Id AS CommentId,
				   C.CommentedByUserId,
				   U.FirstName AS CommentedByUserFirstName,
				   U.SurName AS CommentedByUserSurName,
				   U.FirstName +' '+ ISNULL(U.SurName,'') AS CommentedByUserFullName,
				   U.IsActive AS CommentedByUserIsActive,
				   U.ProfileImage AS CommentedByUserProfileImage,
				   C.ReceiverId,
				   C.Comment,
				   C.CreatedByUserId,
				   C.CreatedDateTime,
				   C.UpdatedByUserId,
				   C.UpdatedDateTime,
				   C.ParentCommentId,
				   C.Adminflag,
				   C.CompanyId
			  FROM [dbo].[Comment] C
				   INNER JOIN [dbo].[User] U ON U.Id = C.CommentedByUserId
			  WHERE C.CompanyId = @CompanyId
			        AND (@CommentId IS NULL OR C.Id = @CommentId)
			        AND (@CommentedByUserId IS NULL OR C.CommentedByUserId = @CommentedByUserId)
			        AND (@ReceiverId IS NULL OR C.ReceiverId = @ReceiverId)
			        AND (@Comment IS NULL OR C.Comment LIKE '%' + @Comment + '%')
					AND (@AdminFlag IS NULL OR C.Adminflag = @AdminFlag)
		      ORDER BY C.CreatedDateTime DESC OFFSET ((@PageNumber - 1) * @PageSize) ROWS

        FETCH NEXT @PageSize ROWS ONLY

       END TRY  
	   BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	  END CATCH
END
GO
