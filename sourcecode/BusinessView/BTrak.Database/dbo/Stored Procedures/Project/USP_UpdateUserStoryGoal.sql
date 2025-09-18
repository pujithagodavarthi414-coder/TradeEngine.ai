-------------------------------------------------------------------------------
-- Purpose      To Save or Update the UserStoryGoal
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpdateUserStoryGoal] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @UserStoryId='5DE9E4F6-C7CA-4390-9D68-17DB10155D71',@GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateUserStoryGoal]
(
   @UserStoryId UNIQUEIDENTIFIER = NULL,
   @GoalId NVARCHAR(50) = NULL,
   @IsArchive  BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @TimeZone NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		     DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
		     
	         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
			
			 IF (@HavePermission = '1')
			 BEGIN

				   DECLARE @OldGoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM UserStory WHERE Id = @UserStoryId)
				   DECLARE @NewProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Goal] WHERE Id = @GoalId)
				   DECLARE @NewBoardTypeId UNIQUEIDENTIFIER = (SELECT BoardTypeId FROM Goal WHERE Id = @GoalId)
				   DECLARE @OldBoardTypeId UNIQUEIDENTIFIER = (SELECT BoardTypeId FROM Goal WHERE Id = @OldGoalId)
				   DECLARE @ISBugBoard BIT = (SELECT ISBugBoard From [dbo].[BoardType]BT 
		                           INNER JOIN [dbo].[Goal]G ON G.BoardTypeId = BT.Id WHERE BT.CompanyId = @CompanyId AND G.Id = @OldGoalId
								   )

			 DECLARE @ParentUserStoryId UNIQUEIDENTIFIER = (SELECT ParentUserStoryId FROM UserStory WHERE Id = @UserStoryId AND InActiveDateTime IS NULL AND ParkedDateTime IS NULL)
			 DECLARE @ParentGoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM [dbo].[UserStory] WHERE Id = @ParentUserStoryId)
			 DECLARE @TaskStatusId UNIQUEIDENTIFIER = (SELECT USS.TaskStatusId FROM [dbo].[UserStory]US
			                                           INNER JOIN [dbo].[UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
													   WHERE US.Id = @UserStoryId)
			 IF (@ParentUserStoryId IS NOT NULL AND (@ISBugBoard IS NULL OR @ISBugBoard = 0))
			  BEGIN
			   RAISERROR('PleaseChangeParentUserStoryGoal',11,1) 
			  END
			        
			 IF (@OldGoalId = @GoalId)

			  BEGIN
			    RAISERROR('PleaseSelectNewGoal',11,1)
			  END

			 
			 

			       DECLARE @UserStoryStatusId UNIQUEIDENTIFIER

				   DECLARE @WorkflowId UNIQUEIDENTIFIER = (SELECT GF.WorkflowId FROM GoalWorkFlow GF 
				                                           INNER JOIN Goal G ON G.Id = GF.GoalId
														   WHERE G.Id = @GoalId)

			       SET @UserStoryStatusId = (SELECT TOP(1) WS.UserStoryStatusId 
                                                                  FROM WorkflowStatus WS 
                                                                       INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId 
                                                                       INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId 
																	   INNER JOIN UserStoryStatus USS ON USS.Id = WS.UserStoryStatusId
																	   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
                                                                  WHERE G.Id = @GoalId AND USS.TaskStatusId = @TaskStatusId Order by WS.OrderId ASC)

				    DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                    DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)    

				   DECLARE @NewUserStoryId UNIQUEIDENTIFIER = NEWID()

				   CREATE TABLE #UserStory 
                                (
                                UserStoryId UNIQUEIDENTIFIER
								,UserStoryName NVARCHAR(800)
                                )

				   INSERT INTO #UserStory(UserStoryId)
				   SELECT @UserStoryId
			        
					INSERT INTO #UserStory(UserStoryId)
					SELECT US1.Id FROM UserStory US INNER JOIN UserStory US1 ON US.Id = US1.ParentUserStoryId 
							                           AND US.InActiveDateTime IS NULL  AND US1.InActiveDateTime IS NULL
							                            WHERE US.Id = @UserStoryId AND US1.GoalId = US.GoalId
                   
				   UPDATE #UserStory SET UserStoryName = US.UserStoryName
				   FROM #UserStory USD INNER JOIN UserStory US ON USD.UserStoryId = US.Id
				  
				   UPDATE UserStory SET UserStoryName = UserStoryName  + '-' + UserStoryUniqueName 
				        WHERE UserStoryName IN ( SELECT UserStoryName 
						                         FROM UserStory 
						                         WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName 
												                                                              FROM #Userstory)	
						                               AND GoalId = @GoalId AND InActiveDateTime IS NULL 
						                               AND ArchivedDateTime IS NULL 
						                         	  GROUP BY UserStoryName ) AND GoalId <> @GoalId
                                      AND Id IN (SELECT USerStoryId FROM #UserStory)

				   UPDATE UserStory SET GoalId = @GoalId,
				   WorkFlowId = @WorkflowId,
				   ProjectId = @NewProjectId,
				   UpdatedDateTime = @CurrentDate,
				   UserStoryStatusId = @UserStoryStatusId,
				   [UpdatedDateTimeZoneId] = @TimeZoneId,
				   UpdatedByUserId = @OperationsPerformedBy
				   FROM [Userstory] US INNER JOIN #UserStory USS ON USS.UserStoryId = US.Id 

				   IF(@ParentUserStoryId IS NOT NULL AND @GoalId <> @ParentGoalId AND @GoalId IS NOT NULL AND @ParentGoalId IS NOT NULL)
				   BEGIN
				     UPDATE UserStory SET ParentUserStoryId = NULL WHERE Id = @UserStoryId
				   END
				   
				   IF (@GoalId <> @OldGoalId)
				   BEGIN
					
					   INSERT INTO [UserStoryHistory] ([Id],
													[UserStoryId],
													[FieldName],
													[OldValue],
													[NewValue],
													[Description],
													CreatedByUserId,
													[CreatedDateTimeZoneId],
													CreatedDateTime
												   )
										    SELECT  NEWID(),
											        @UserStoryId,
													'GoalId',
													(SELECT GoalName FROM Goal WHERE Id = @OldGoalId),
													(SELECT GoalName FROM Goal WHERE Id = @GoalId),
													'GoalChanged',
													@OperationsPerformedBy,
													@TimeZoneId,
													@Currentdate
				END

				SELECT Id FROM [Userstory] WHERE Id = @UserStoryId
							
			 END
			 ELSE
			 BEGIN
			 
			 	RAISERROR (@HavePermission,11, 1)
				
			 END
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO