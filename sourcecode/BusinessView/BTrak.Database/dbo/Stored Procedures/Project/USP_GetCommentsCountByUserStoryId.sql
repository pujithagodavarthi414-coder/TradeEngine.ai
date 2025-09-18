-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the User Stories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCommentsCountByUserStoryId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCommentsCountByUserStoryId]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
	    DECLARE @GoalId UNIQUEIDENTIFIER  =  (SELECT GoalId FROM UserStory WHERE Id = @UserStoryId)
	     DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	       
		   DECLARE @UserName NVARCHAR(800) = (SELECT FirstName + ' ' + SurName FROM [User] WHERE Id = @OperationsPerformedBy)

		   DECLARE @HistoryDescription NVARCHAR(800)

		   SET @HistoryDescription = 'UserStoryViewed'

		   DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	       SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
		   
		   IF(EXISTS(SELECT Id FROM UserStory WHERE Id = @UserStoryId))
		   BEGIN

			EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = NULL,@NewValue = NULL,@FieldName = NULL,
			@Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		   
		   END
			DECLARE @CommentsCount INT = (SELECT COUNT(1) AS CommentsCount
		    FROM  [dbo].[Comment] C
		          INNER JOIN [dbo].[UserStory] US WITH (NOLOCK) ON C.ReceiverId = US.Id AND US.Id = @UserStoryId 
				  LEFT JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId 
			      LEFT JOIN [Project] P WITH (NOLOCK) ON P.Id = G.ProjectId
			WHERE C.CompanyId = @CompanyId)

			IF(@CommentsCount IS NULL AND NOT EXISTS(SELECT Id FROM UserStory WHERE Id = @UserStoryId) AND EXISTS(SELECT Id FROM LeaveApplication WHERE Id = @UserStoryId))
			BEGIN
				
				SET @CommentsCount = (SELECT COUNT(1) FROM LeaveApplication LA JOIN Comment C ON C.ReceiverId = LA.Id AND LA.Id = @UserStoryId)
				
			END
			SELECT @CommentsCount AS CommentsCount

	END
	ELSE
	BEGIN

		RAISERROR(50008,11,1)

	END
	 END TRY  
	 BEGIN CATCH 
		
		     EXEC [dbo].[USP_GetErrorInformation]

	 END CATCH

END
GO