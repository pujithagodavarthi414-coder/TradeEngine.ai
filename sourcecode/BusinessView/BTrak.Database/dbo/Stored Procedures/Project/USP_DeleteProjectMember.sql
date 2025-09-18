-----------------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-18 00:00:00.000'
-- Purpose      To Delete Project Member
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_DeleteProjectMember] @UserId ='127133F1-4427-4149-9DD6-B02E0E036971'
--,@ProjectId = '53C96173-0651-48BD-88A9-7FC79E836CCE'
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteProjectMember]
(
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @TimeZone NVARCHAR(250) = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM UserProject WHERE [InActiveDateTime] IS NULL AND Id = @ProjectMemberId)

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

             DECLARE @CurrentDate DATETIME = GETDATE()
             
			   UPDATE UserProject SET InactiveDateTime = @CurrentDate WHERE ProjectId = @ProjectId AND UserId = @UserId
              
			   DECLARE @NewValue NVARCHAR(500) = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @UserId AND IsActive = 1)

			   EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @NewValue, @FieldName = 'ProjectMemberDeleted',
		                                     @Description = 'ProjectMemberDeleted', @OperationsPerformedBy = @OperationsPerformedBy

			    DECLARE @ValidationText NVARCHAR(500) = NULL

				IF (EXISTS(SELECT 1 FROM Goal WHERE [GoalResponsibleUserId] = @UserId AND ProjectId = @ProjectId))
				BEGIN
						
					SET @ValidationText = 'ThisPersonIsAlreadyInUse'

				END
				ELSE IF (EXISTS(SELECT 1 FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId WHERE US.[OwnerUserId] = @UserId AND G.ProjectId = @ProjectId))
				BEGIN

					SET @ValidationText = 'ThisPersonIsAlreadyInUse'
						
				END
				ELSE IF (EXISTS (SELECT 1 FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId WHERE US.DependencyUserId = @UserId AND G.ProjectId = @ProjectId))
				BEGIN

					SET @ValidationText = 'ThisPersonIsAlreadyInUse'
						
				END
				ELSE IF (EXISTS(SELECT 1 FROM Project WHERE ProjectResponsiblePersonId = @UserId AND Id = @ProjectId))
				BEGIN

					SET @ValidationText = 'ThisPersonIsAlreadyInUse'
						
				END
				ELSE IF (EXISTS(SELECT 1 FROM Bugcauseduser B INNER JOIN UserStory US ON US.Id = B.UserStoryId INNER JOIN Goal G ON G.Id = US.GoalId WHERE UserId = @UserId AND G.ProjectId = @ProjectId))
				BEGIN

					SET @ValidationText = 'ThisPersonIsAlreadyInUse'
						
				END

			   SELECT @UserId,@ValidationText AS TextMessage
              
        END
        ELSE
           RAISERROR (@HavePermission,11, 1)
   END TRY
   BEGIN CATCH
       THROW
   END CATCH
END
GO