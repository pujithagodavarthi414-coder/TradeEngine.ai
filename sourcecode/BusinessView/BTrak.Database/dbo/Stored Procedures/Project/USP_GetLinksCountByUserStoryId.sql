-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the User Stories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCommentsCountByUserStoryId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLinksCountByUserStoryId]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsSprintUserStories BIT = NULL
)
AS
BEGIN
    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = 1)
		BEGIN
		IF (@IsSprintUserStories IS NULL) SET @IsSprintUserStories = 0
		
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	    
							select count(1)  FROM [dbo].[LinkUserStory]LU
							INNER JOIN [dbo].[UserStory]US ON LU.LinkUserStoryId = US.Id
							WHERE (LU.UserStoryId = @UserStoryId) 
							AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							AND LU.InActiveDateTime IS NULL
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