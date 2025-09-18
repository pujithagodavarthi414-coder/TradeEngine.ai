CREATE PROCEDURE [dbo].[USP_UpdateMultipleUserStoriesGoal]
(
   @UserStoryIdsXml XML = NULL,
   @GoalId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
		
		Declare @TempUserStoryTable table
        (
          UserStoryId UNIQUEIDENTIFIER
		 ,UserStoryName NVARCHAR(800)
        )

	    INSERT INTO @TempUserStoryTable
		(
		  UserStoryId
		)
		SELECT x.y.value('(text())[1]', 'uniqueidentifier')
		FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS x(y)

		DECLARE @UserstoryIdsCount INT = (SELECT COUNT(1) FROM @TempUserStoryTable)

	    IF(@UserstoryIdsCount = 0)
        BEGIN
            RAISERROR(50011,16, 1,'UserStory')
        END
        ELSE
		BEGIN
       
		     DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))
		     
	         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
			
			 IF (@HavePermission = '1')
			 BEGIN

			      DECLARE @UserStoryStatusId UNIQUEIDENTIFIER

			      SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
                                                                  FROM WorkflowStatus WS 
                                                                       INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId 
                                                                       INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId 
                                                                  WHERE G.Id = @GoalId AND WS.CanAdd = 1)

				  DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

				  UPDATE @TempUserStoryTable SET UserStoryName = US.UserStoryName
				   FROM @TempUserStoryTable USD INNER JOIN UserStory US ON USD.UserStoryId = US.Id
				  
				   UPDATE UserStory SET UserStoryName = UserStoryName  + '-' + UserStoryUniqueName 
				        WHERE UserStoryName IN ( SELECT UserStoryName 
						                         FROM UserStory 
						                         WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName 
												                                                              FROM @TempUserStoryTable)	
						                               AND GoalId = @GoalId AND InActiveDateTime IS NULL 
						                               AND ArchivedDateTime IS NULL 
						                         	  GROUP BY UserStoryName ) AND GoalId <> @GoalId
                                      AND Id IN (SELECT USerStoryId FROM @TempUserStoryTable)

				  UPDATE UserStory SET GoalId = @GoalId,
				  UpdatedDateTime = @Currentdate,
				  UpdatedByUserId = @OperationsPerformedBy
				  FROM UserStory US
				  JOIN @TempUserStoryTable TUST ON TUST.UserStoryId = US.Id 

				  UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 

				  SELECT @GoalId
							
			 END
			 ELSE
			 BEGIN
			 
			 	RAISERROR (@HavePermission,11, 1)
				
			 END
        END

    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
