-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-03 00:00:00.000'
-- Purpose      To Save or Update the UserStory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryList]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7',
--@ReviewerUserId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7',
--@UserStoryName= N'<?xml version="1.0" encoding="utf-16"?>
--<ArrayOfString xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--<string>12</string>
--<string>23</string>
--<string>33</string>
--</ArrayOfString>'
--,@userStoryTypeId = '6C32EE90-F5C4-4081-94B3-8143A4C4847D'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryList]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @UserStoryName XML = NULL, 
  @EstimatedTime DECIMAL(18,2) = NULL,
  @DeadLineDate DATETIMEOFFSET = NULL,
  @OwnerUserId UNIQUEIDENTIFIER = NULL ,
  @DependencyUserId UNIQUEIDENTIFIER = NULL,
  @Order INT = NULL,
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @ActualDeadLineDate DATETIMEOFFSET = NULL,
  @IsArchived BIT = NULL,
  @IsReplan BIT = NULL,
  @ArchivedDateTime DATETIME = NULL,
  @BugPriorityId UNIQUEIDENTIFIER = NULL,
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @ParkedDateTime DATETIME = NULL,
  @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
  @GoalReplanTypeId UNIQUEIDENTIFIER = NULL,
  @BugCausedUserId UNIQUEIDENTIFIER = NULL,
  @ReviewerUserId UNIQUEIDENTIFIER = NULL,
  @UserStoryPriorityId UNIQUEIDENTIFIER = NULL, 
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Description NVARCHAR(MAX) = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
  @TemplateId UNIQUEIDENTIFIER = NULL,
  @SprintId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM Goal WHERE Id = @GoalId)
	      
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
			IF(@HavePermission = '1')
            BEGIN

			IF (@EstimatedTime < 0)
			BEGIN

				RAISERROR('EstimateCanNotBeNegativeOrZero',11,1)

			END
			ELSE
			BEGIN

              DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
			  SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			  
			  DECLARE @Currentdate DATETIME =  dbo.Ufn_GetCurrentTime(@Offset) 
              
			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    

			  DECLARE @IsBug BIT = (SELECT IsBugBoard FROM BoardType BT JOIN Goal G ON G.BoardTypeId = BT.Id AND BT.InActiveDateTime IS NULL AND G.Id = @GoalId)

			  IF(@UserStoryTypeId IS NULL) SET @UserStoryTypeId = (CASE WHEN @IsBug IS NOT NULL AND @IsBug = 1 THEN (SELECT Id FROM UserStoryType WHERE IsBug = 1 AND CompanyId = @CompanyId) 
																        ELSE (SELECT Id FROM UserStoryType WHERE IsUserStory = 1 AND CompanyId = @CompanyId) END)
			  
			  DECLARE @UserStoryReplanTypeId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryReplanType WHERE ReplanTypeName='Work Item Added')

			  DECLARE @GoalReplanCount INT = (SELECT MAX(GoalReplanCount) FROM GoalReplan WHERE GoalId = @GoalId GROUP BY GoalId)

			  DECLARE @GoalReplanId UNIQUEIDENTIFIER = (SELECT Id FROM GoalReplan WHERE GoalId = @GoalId AND GoalReplanCount = @GoalReplanCount)

			  DECLARE @NewId UNIQUEIDENTIFIER = (SELECT NEWID())

			  DECLARE @IsFromSprint BIT = 0
                      
              DECLARE @MaxOrderId INT = 0
              SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM UserStory WHERE GoalId = @GoalId 

              DECLARE @WorkflowId UNIQUEIDENTIFIER = NULL
                            
              SET @WorkflowId = (SELECT BTWF.WorkFlowId from Goal G
                                 JOIN BoardTypeWorkFlow BTWF ON BTWF.BoardTypeId = G.BoardTypeId
                                 WHERE G.Id = @GoalId)
                
              IF(@UserStoryStatusId IS NULL)
			  IF @GoalId IS NOT NULL
			  BEGIN
              SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
                                        FROM WorkflowStatus WS 
                                             INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId AND WS.CompanyId = @CompanyId
                                             INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId AND BTW.InActiveDateTime IS NULL AND WS.InActiveDateTime IS NULL
                                        WHERE G.Id = @GoalId AND WS.CanAdd = 1)
			  END
			  ELSE IF @TemplateId IS NOT NULL
			  BEGIN
			    SET @WorkflowId = (SELECT WorkFlowId FROM BoardtypeWorkflow 
								   WHERE BoardTypeId = (SELECT BoardTypeId FROM Templates WHERE Id = @TemplateId))

			    	SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
											  FROM WorkflowStatus WS 
											  	INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId 
												      AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId 
													  AND WS.InActiveDateTime IS NULL
											  	INNER JOIN Templates T ON T.BoardTypeId = BTW.BoardTypeId AND T.Id = @TemplateId)
			  END
			  ELSE
			  BEGIN
			        SET @WorkflowId = (SELECT BTWF.WorkFlowId from Sprints S
                                       JOIN BoardTypeWorkFlow BTWF ON BTWF.BoardTypeId = S.BoardTypeId
                                       WHERE S.Id = @SprintId)
			        SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
                                        FROM WorkflowStatus WS 
                                             INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId AND WS.CompanyId = @CompanyId
                                             INNER JOIN Sprints S ON S.BoardTypeId = BTW.BoardTypeId AND BTW.InActiveDateTime IS NULL AND WS.InActiveDateTime IS NULL
                                        WHERE S.Id = @SprintId AND WS.CanAdd = 1)

					SET	@MaxOrderId = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE SprintId = @SprintId)
					SET @IsBug  = (SELECT IsBugBoard FROM BoardType BT JOIN Sprints S ON S.BoardTypeId = BT.Id AND BT.InActiveDateTime IS NULL AND S.Id = @SprintId)
					SET @UserStoryTypeId = (CASE WHEN @IsBug IS NOT NULL AND @IsBug = 1 THEN (SELECT Id FROM UserStoryType WHERE IsBug = 1 AND CompanyId = @CompanyId) 
										    ELSE (SELECT Id FROM UserStoryType WHERE IsUserStory = 1 AND CompanyId = @CompanyId) END)
					SET @IsFromSprint = 1
					SET @GoalReplanCount  = (SELECT MAX(GoalReplanCount) FROM GoalReplan WHERE GoalId = @SprintId GROUP BY GoalId)
					SET @GoalReplanId = (SELECT Id FROM GoalReplan WHERE GoalId = @SprintId AND GoalReplanCount = @GoalReplanCount)
			  END
              
              DECLARE @Unique NVARCHAR(20) = (SELECT [dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId))
              
              DECLARE @Name Nvarchar(20) = (SELECT ShortName from UserStoryType where Id = @UserStoryTypeId AND CompanyId = @CompanyId)
              
              DECLARE @Number INT = (SELECt CAST((SUBSTRING(@Unique,LEN(@name) + 2,len(@Unique))) AS INT))

              DECLARE @UserstoryNameCount INT
              DECLARE  @Userstory TABLE
                  (  
                    RowNumber INT IDENTITY(1,1),
                    OrderValue INT,
                    UserStoryId UNIQUEIDENTIFIER,
                    UserStoryName NVARCHAR(800),
                    UserStoryUniqueName NVARCHAR(800),
					UniqueName INT			
                  )
                   INSERT INTO @Userstory(UserStoryId,UserStoryName)
                   SELECT NEWID(),LTRIM([Table].[Column].value('(text())[1]', 'Nvarchar(800)'))                     
                   FROM @UserstoryName.nodes('ArrayOfString/string') AS [Table]([Column])

				   UPDATE @Userstory SET UniqueName = @Number - 1 + RowNumber
                   
					UPDATE @Userstory SET OrderValue = @MaxOrderId + 0, @MaxOrderId = @MaxOrderId + 1

					UPDATE @Userstory SET UserStoryUniqueName =  @Name + '-' + CAST(UniqueName AS NVARCHAR(20))
					FROM @Userstory

					DECLARE @UserStoryIdsCount INT = (SELECT COUNT (1) FROM @Userstory),@UserStoryNameNew NVARCHAR(800),@UserStoryId UNIQUEIDENTIFIER

					IF(@GoalId IS NOT NULL)
       				BEGIN
						
						SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory 
						                            WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN 
													(SELECT UserStoryName FROM @Userstory)	
													 AND GoalId = @GoalId AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL)
					END
					ELSE IF(@SprintId IS NOT NULL)
					BEGIN
					   SET @ProjectId = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @SprintId)
					   SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory
					                               WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN 
												   (SELECT UserStoryName FROM @Userstory)	
												   AND SprintId = @SprintId AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL)
					END
					ELSE
					BEGIN
					 SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName FROM @Userstory)	AND TemplateId = @TemplateId AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL)
					END

					IF(EXISTS(SELECT UserStoryName FROM @Userstory GROUP BY UserStoryName 
							  HAVING COUNT(UserStoryName) > 1 ))
					BEGIN
					   	
					  RAISERROR(50024,16,1)
							
					END
					ELSE
					BEGIN
					IF(@GoalId IS NOT NULL)
					BEGIN
					UPDATE @Userstory SET UserStoryName = UserStoryName  + '-' + UserStoryUniqueName 
						WHERE UserStoryName IN (SELECT UserStoryName 
						                        FROM UserStory 
						                        WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName 
												                                                             FROM @Userstory)	
						                              AND GoalId = @GoalId AND InActiveDateTime IS NULL 
						                              AND ArchivedDateTime IS NULL 
						                        	  GROUP BY UserStoryName)
					END
					ELSE IF(@SprintId IS NOT NULL)
					BEGIN
					  UPDATE @Userstory SET UserStoryName = UserStoryName  + '-' + UserStoryUniqueName 
						WHERE UserStoryName IN (SELECT UserStoryName 
						                        FROM UserStory 
						                        WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName 
												                                                             FROM @Userstory)	
						                              AND SprintId = @SprintId AND InActiveDateTime IS NULL 
						                              AND ArchivedDateTime IS NULL 
						                        	  GROUP BY UserStoryName)
					END
					ELSE
					BEGIN
					   UPDATE @Userstory SET UserStoryName = UserStoryName  + '-' + UserStoryUniqueName 
						WHERE UserStoryName IN (SELECT UserStoryName 
						                        FROM UserStory 
						                        WHERE UserStoryName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT UserStoryName 
												                                                             FROM @Userstory)	
						                              AND TemplateId = @TemplateId 
						                               AND GoalId = @GoalId
						                        	  GROUP BY UserStoryName)
					END

                   INSERT INTO [dbo].[UserStory](
                               [Id],
                               [GoalId],
                               [UserStoryName],
                               [EstimatedTime],
                               [DeadLineDate],
							   [DeadLineDateTimeZone],
                               [OwnerUserId],
                               [DependencyUserId],
                               [UserStoryStatusId],
                               [ActualDeadLineDate],
							   [ActualDeadLineDateTimeZone],
                               [ArchivedDateTime],
                               [BugPriorityId],
                               [UserStoryTypeId],
                               [ParkedDateTime],
							   [ParkedDateTimeZoneId],
                               [ProjectFeatureId],
                               [UserStoryPriorityId],
                               [UserStoryUniqueName],
                               [Order],
                               [ReviewerUserId],
                               [CreatedDateTime],
                               [CreatedByUserId],
							   [CreatedDateTimeZone],
							   [Description],
							   [ParentUserStoryId],
							   [TemplateId],
							   [SprintId],
							   [ProjectId],
							   [WorkFlowId]
							   )
                        SELECT UserStoryId,
                               @GoalId,
                               UserStoryName, 
                               @EstimatedTime,
                               @DeadLineDate,
							   CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                               @OwnerUserId,
                               @DependencyUserId,
                               @UserStoryStatusId,
                               @ActualDeadLineDate,
							   CASE WHEN @ActualDeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END, 
                               CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                               @BugPriorityId,
                               @UserStoryTypeId,
                               @ParkedDateTime,
							   CASE WHEN @ParkedDateTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                               @ProjectFeatureId,
                               @UserStoryPriorityId,
                               UserStoryUniqueName,
                               OrderValue,
                               @ReviewerUserId,
                               @Currentdate,
                               @OperationsPerformedBy,
							   @TimeZoneId,
							   @Description,
							   @ParentUserStoryId,
							   @TemplateId,
							   @SprintId,
							   @ProjectId,
							   @WorkFlowId
                          FROM @Userstory                                                                   
                               
					WHILE(@UserStoryIdsCount > = 1)
					BEGIN

						SELECT @UserStoryId = UserStoryId,@UserStoryNameNew = UserStoryName
						FROM @Userstory WHERE RowNumber = @UserStoryIdsCount

						     EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId,@OperationsPerformedBy=@OperationsPerformedBy
							 , @FieldName ='UserStory',@Description = 'UserStoryAdded',@TimeZoneId = @TimeZoneId

						SET @UserStoryIdsCount = @UserStoryIdsCount - 1

						IF(@IsReplan = 1)
						BEGIN
									INSERT INTO [dbo].[UserStoryReplan](
			 				                        [Id],
							                        [GoalId],
			 				                        [GoalReplanId],
							                        [GoalReplanCount],
			 				                        [UserStoryId],
			 				                        [UserStoryReplanTypeId],
													[UserStoryReplanJson],
							                        [OldValue],
							                        [NewValue],
			 				                        [CreatedDateTime],
													[CreatedDateTimeZoneId],
			 				                        [CreatedByUserId])
											SELECT  NEWID(),
													CASE WHEN @IsFromSprint = 1 THEN @SprintId ELSE @GoalId END,
													@GoalReplanId,
													@GoalReplanCount,
													@UserStoryId,
													@UserStoryReplanTypeId,
													'UserStoryAdd',
													'',
													@UserStoryNameNew,
													@Currentdate,
													@TimeZoneId,
													@OperationsPerformedBy

						END

					 END

					 IF @ParentUserStoryId IS NOT NULL
										  BEGIN
										      INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  NewValue,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTimeZoneId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @ParentUserStoryId,
											          'UserStorySubTask',
													  UserStoryName,
													  'UserStorySubTaskAdded',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  @Currentdate
												FROM @Userstory U
										  END
                    SELECT UserStoryId FROM @Userstory
                END

				UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 
		 END
	 END
      ELSE
          BEGIN
               RAISERROR (@HavePermission,10, 1)
          END
	
       END TRY  
       BEGIN CATCH 
        
           THROW
      END CATCH
END
GO