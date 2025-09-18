-------------------------------------------------------------------------------
--exec USP_UpsertUserStory @UserStoryId='395F5FB6-6D50-49D5-AAE9-1FF1B765C844',@GoalId='FBBEBF7F-7F0A-4DBE-82F7-A7DAFFECD34E',
--@UserStoryName=N'Adjusting the automatic failover time for SQL Server Database Mirroring',
--@EstimatedTime=5,@DeadLineDate='2020-05-10 15:50:45.6766667 +00:00',
--@OwnerUserId='7AAFAA2C-FFC3-46B6-A68C-85FE47FAF4BF',@DependencyUserId=NULL,@Order=NULL,
--@UserStoryStatusId='0A186FB6-A6E0-4C6A-9683-C07ED9A1A0B0',@IsArchived=0,@ArchivedDateTime=NULL,@ParkedDateTime=NULL,
--@BugPriorityId=NULL,@UserStoryTypeId='BAB42471-F451-4AD1-83F3-D4E6E9C0194B',@ProjectFeatureId=NULL,@BugCausedUserId=NULL,
--@UserStoryPriorityId=NULL,@TestSuiteSectionId=NULL,@TestCaseId=NULL,@ReviewerUserId=NULL,@ParentUserStoryId=NULL,@Description=NULL,
--@TimeStamp=0x00000000000046AC,@IsForQa=0,@VersionName=NULL,@Tags=NULL,@TemplateId=NULL,
--@SprintId=NULL,@SprintEstimatedTime=NULL,@RAGStatus=NULL,@OperationsPerformedBy='7AAFAA2C-FFC3-46B6-A68C-85FE47FAF4BF'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertUserStory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @UserStoryName NVARCHAR(800) = NULL, 
  @EstimatedTime DECIMAL(18,2) = NULL,
  @DeadLineDate DATETIMEOFFSET = NULL,
  @OwnerUserId UNIQUEIDENTIFIER = NULL,
  @TestSuiteSectionId UNIQUEIDENTIFIER = NULL,
  @TestCaseId UNIQUEIDENTIFIER = NULL ,
  @DependencyUserId UNIQUEIDENTIFIER = NULL,
  @Order INT = NULL,
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @ArchivedDateTime DATETIME = NULL,
  @BugPriorityId UNIQUEIDENTIFIER = NULL,
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @ParkedDateTime DATETIME = NULL,
  @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
  @BugCausedUserId UNIQUEIDENTIFIER = NULL,
  @UserStoryPriorityId UNIQUEIDENTIFIER = NULL,
  @ReviewerUserId UNIQUEIDENTIFIER = NULL,
  @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @Description NVARCHAR(MAX) = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @CustomApplicationId UNIQUEIDENTIFIER = NULL,
  @IsForQa BIT = NULL,
  @TemplateId UNIQUEIDENTIFIER = NULL,
  @VersionName NVARCHAR(250) = NULL,
  @Tags NVARCHAR(MAX) = NULL,
  @SprintId UNIQUEIDENTIFIER = NULL,
  @SprintEstimatedTime DECIMAL(18,2) = NULL,
  @RAGStatus NVARCHAR(MAX) =NULL,
  @AuditConductQuestionId UNIQUEIDENTIFIER = NULL,
  @AuditProjectId UNIQUEIDENTIFIER = NULL,
  @ActionCategoryId UNIQUEIDENTIFIER = NULL,
  @IsFromBugs BIT = NULL,
  @IsAction BIT = NULL,
  @IsReplan BIT = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @UserStoryUniqueName NVARCHAR(500) = NULL,
  @StartDate DATETIMEOFFSET = NULL,
  @UnLinkActionId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    

			DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
		    DECLARE @ActionGoal UNIQUEIDENTIFIER =  (SELECT G.Id FROM Goal G 
			                                         INNER JOIN Project P ON P.Id = G.ProjectId 
													            AND P.CompanyId = @CompanyId 
																AND P.InActiveDateTime IS NULL
																AND P.Id = @AuditProjectId
								                     WHERE G.GoalName = 'Compliance Action' AND G.InActiveDateTime IS NULL)
            
			DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

			IF((@AuditConductQuestionId IS NOT NULL OR @IsAction = 1))
			BEGIN
				
				IF(@ActionGoal IS NULL)
				BEGIN

					SET @ActionGoal = NEWID()

					 DECLARE @UniqueNumber INT

                        SELECT @UniqueNumber
                            = MAX(CAST(SUBSTRING(
                                                    GoalUniqueName,
                                                    CHARINDEX('-', GoalUniqueName) + 1,
                                                    LEN(GoalUniqueName)
                                                ) AS INT)
                                 )
                        FROM Goal G
                            INNER JOIN Project P
                                ON P.Id = G.ProjectId AND GoalUniqueName <> 'Adhoc' 
                                   AND GoalUniqueName <> 'Induction'
                                   AND GoalUniqueName <> 'Compliance'
								   AND GoalUniqueName <> 'Exit'
                        WHERE P.CompanyId = @CompanyId

					MERGE INTO [dbo].[Goal] AS Target 
					USING (VALUES 
							 (@ActionGoal, @AuditProjectId, (SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'Kanban' AND CompanyId = @CompanyId), N'Compliance Action', N'Compliance Action',NULL, DATEADD(DAY,-3,GetDate()), NULL, NULL, GETDATE(),@TimeZoneId, @OperationsPerformedBy, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL, ('G-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))))
							 --(NEWID(), (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Audit compliance project'),(SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'Kanban' AND CompanyId = @CompanyId), N'Compliance Action Goal',N'Compliance Action Goal', 0,@UserId, GETDATE(),@UserId, NULL,'Compliance Action')
							)
					AS Source ([Id], [ProjectId], [BoardTypeId], [GoalName],[GoalShortName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalResponsibleUserId], [CreatedDateTime],[CreatedDateTimeZoneId], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
								[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsParked], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
								[Version], [ParkedDateTime],[GoalUniqueName])
					ON Target.Id = Source.Id  
					WHEN MATCHED THEN 
					UPDATE SET
						   [ProjectId] = Source.[ProjectId],
						   [BoardTypeId] = Source.[BoardTypeId],
						   [GoalName] = Source.[GoalName],
						   [GoalShortName] = Source.[GoalShortName],
						   [GoalBudget] = Source.[GoalBudget],
						   [OnboardProcessDate] = Source.[OnboardProcessDate],
						   [IsLocked] = Source.[IsLocked],
						   [GoalResponsibleUserId] = Source.[GoalResponsibleUserId],
						   [CreatedDateTime] = Source.[CreatedDateTime],
						   [CreatedByUserId] = Source.[CreatedByUserId],
						   [CreatedDateTimeZoneId] = Source.[CreatedDateTimeZoneId],
						   [GoalStatusId] = Source.[GoalStatusId],
						   [ConfigurationId] = source.[ConfigurationId],
						   [ConsiderEstimatedHoursId] = Source.[ConsiderEstimatedHoursId],
						   [GoalStatusColor] = Source.[GoalStatusColor],
						   [IsProductiveBoard] = Source.[IsProductiveBoard],
						   [IsApproved] = Source.[IsApproved],
						   [ConsiderEstimatedHours] = Source.[ConsiderEstimatedHours],
						   [IsToBeTracked] = Source.[IsToBeTracked],
						   [BoardTypeApiId] = Source.[BoardTypeApiId],
						   GoalUniqueName = Source.GoalUniqueName,
						   [Version] = Source.[Version],
						   [ParkedDateTime] = Source.[ParkedDateTime]
					WHEN NOT MATCHED BY TARGET THEN 
					INSERT ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[CreatedDateTimeZoneId],[GoalStatusId], [ConfigurationId], 
							[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
							[Version], [ParkedDateTime],[GoalUniqueName]) 
					VALUES ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[CreatedDateTimeZoneId],[GoalStatusId], [ConfigurationId], 
							[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
							[Version], [ParkedDateTime],[GoalUniqueName]);

					MERGE INTO [dbo].[GoalWorkFlow] AS Target
					USING ( VALUES
							(NEWID(), @ActionGoal, (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@OperationsPerformedBy)
					)
					AS Source ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) 
					ON Target.Id = Source.Id
					WHEN MATCHED THEN
					UPDATE SET [GoalId] = source.[GoalId],
							   [WorkFlowId] = source.[WorkFlowId],
							   [CreatedDateTime] = Source.[CreatedDateTime],
							   [CreatedByUserId] = Source.[CreatedByUserId]
					WHEN NOT MATCHED BY TARGET THEN
					INSERT ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) 
					VALUES ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]);
				
				END

				IF(@GoalId IS NULL) SET @GoalId = @ActionGoal
				
				SET @ProjectId = @AuditProjectId

			END
            
            DECLARE @IsBug BIT
			DECLARE @OldGoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM [dbo].[UserStory] WHERE Id = @UserStoryId)
			IF(@TemplateId IS NOT NULL AND @ProjectId IS NULL)
			        SET @ProjectId = (SELECT ProjectId FROM Templates WHERE Id = @TemplateId)

			IF(@SprintId IS NOT NULL AND @ProjectId IS NULL)
			        SET @ProjectId = (SELECT ProjectId FROM Sprints WHERE Id = @SprintId)

		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
           	IF(@CustomApplicationId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationId = NULL
		    
            IF(@TemplateId = '00000000-0000-0000-0000-000000000000') SET @TemplateId = NULL

            IF(@BugCausedUserId = '00000000-0000-0000-0000-000000000000') SET @BugCausedUserId = NULL

			IF(@SprintId = '00000000-0000-0000-0000-000000000000') SET @SprintId = NULL

			IF(@VersionName = '') SET @VersionName = NULL

			IF(@RAGStatus = '') SET @RAGStatus = NULL
			
            IF(@HavePermission = '1')
            BEGIN
            DECLARE @UserstoryIdCount INT
			DECLARE @UserstoryNameCount INT
            
			--IF(@UserStoryTypeId IS NULL) SET @UserStoryTypeId = (SELECT Id FROM UserStoryType WHERE UserStoryTypeName = 'Work item' AND CompanyId = @CompanyId)

			IF(@TemplateId IS NULL AND @SprintId IS NULL)
			BEGIN
			IF(@OldGoalId IS NOT NULL AND @GoalId <> @OldGoalId) 
			BEGIN
			 SET @UserstoryIdCount  = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId AND GoalId = @OldGoalId) 
			END
			ELSE
			BEGIN
			 SET @UserstoryIdCount  = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId AND GoalId = @GoalId) 
			END
			  
			  SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName AND GoalId = @GoalId AND ArchivedDateTime IS NULL AND (Id <> @UserStoryId OR @UserStoryId IS NULL))
			
			END
			ELSE IF(@SprintId IS NOT NULL)
			BEGIN
			  SET @UserstoryIdCount  = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId AND SprintId = @SprintId) 
			   
			   SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName 
			                                AND (@GoalId IS NULL OR GoalId = @GoalId) 
			                                AND (@TemplateId IS NULL OR TemplateId = @TemplateId) 
											AND (@SprintId IS NULL OR SprintId = @SprintId) 
											AND ArchivedDateTime IS NULL 
											AND (Id <> @UserStoryId OR @UserStoryId IS NULL))
			END
			ELSE
			BEGIN
			   
			   SET @UserstoryIdCount  = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId AND TemplateId = @TemplateId) 
			   
			   SET @UserstoryNameCount  = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName 
			                                AND (@GoalId IS NULL OR GoalId = @GoalId) 
			                                AND (@TemplateId IS NULL OR TemplateId = @TemplateId) 
											AND ArchivedDateTime IS NULL 
											AND (Id <> @UserStoryId OR @UserStoryId IS NULL))
			END

			DECLARE @OldUserStoryStatusId UNIQUEIDENTIFIER = (SELECT UserStoryStatusId FROM UserStory WHERE Id = @UserStoryId)
			
			DECLARE @TaskStatusOrder INT = (SELECT [Order] FROM TaskStatus TS JOIN UserStoryStatus USS ON USS.TaskStatusId = TS.Id 
			                                AND USS.Id = @UserStoryStatusId AND USS.CompanyId = @CompanyId)

			DECLARE @ActualDeadLineDate DATETIMEOFFSET = NULL ,@ActualDeadLineDateTimeZoneId UNIQUEIDENTIFIER = NULL
			
			SELECT @ActualDeadLineDate = ActualDeadLineDate,@ActualDeadLineDateTimeZoneId = ActualDeadLineDateTimeZone FROM UserStory WHERE Id = @UserStoryId

			 DECLARE @GoalReplanCount INT = (SELECT MAX(GoalReplanCount) FROM GoalReplan WHERE GoalId = @GoalId GROUP BY GoalId)

			 DECLARE @GoalReplanId UNIQUEIDENTIFIER = (SELECT Id FROM GoalReplan WHERE GoalId = @GoalId AND GoalReplanCount = @GoalReplanCount)

             DECLARE @UserStoryReplanTypeId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryReplanType WHERE ReplanTypeName='Work Item Added')
			 DECLARE @IsFromSprint BIT = NULL

            IF(@UserstoryIdCount = 0 AND @UserStoryId IS NOT NULL)

            BEGIN
            
                RAISERROR(50002,16, 1,'UserStory')
            
            END
			ELSE IF (@EstimatedTime < 0)
			BEGIN

				RAISERROR('EstimateCanNotBeNegativeOrZero',11,1)

			END
          
			
            ELSE
            BEGIN
            DECLARE @IsLatest BIT = (CASE WHEN @UserStoryId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM UserStory WHERE Id = @UserStoryId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
              IF(@IsLatest = 1)
              BEGIN
                            
                                  DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
                                       
								  DECLARE @OldTestSuiteSectionId UNIQUEIDENTIFIER
                                 
                                  DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE GoalId = @GoalId)
                            
                                  DECLARE @BugCausedUserDetailId UNIQUEIDENTIFIER = (SELECT Id FROM BugCausedUser WHERE UserStoryId = @UserStoryId AND InActiveDateTime IS NULL)
                                  
								  SELECT @OldTestSuiteSectionId = TestSuiteSectionId FROM [UserStory]US WHERE Id = @UserStoryId
                            
                                  DECLARE @NewUserStoryStatusId UNIQUEIDENTIFIER = @UserStoryStatusId
                            
                                  DECLARE @WorkflowEligibleStatusTransitionId UNIQUEIDENTIFIER = NULL
                            
                                  DECLARE @WorkflowId UNIQUEIDENTIFIER = NULL
                            
                                  SET @WorkflowId = (SELECT BTWF.WorkFlowId from Goal G
                                  JOIN BoardTypeWorkFlow BTWF ON BTWF.BoardTypeId = G.BoardTypeId
                                  WHERE G.Id = @GoalId)

                            IF(@TemplateId IS NOT NULL)
							BEGIN

							      SET @WorkflowId = (SELECT WorkFlowId FROM BoardtypeWorkflow 
													 WHERE BoardTypeId = (SELECT BoardTypeId FROM Templates WHERE Id = @TemplateId))

							END
							ELSE IF(@SprintId IS NOT NULL)
							BEGIN
							     SET @WorkflowId = (SELECT BTWF.WorkFlowId from Sprints S
                                                   JOIN BoardTypeWorkFlow BTWF ON BTWF.BoardTypeId = S.BoardTypeId
                                                   WHERE S.Id = @SprintId)

								SET @GoalReplanCount  = (SELECT MAX(GoalReplanCount) FROM GoalReplan WHERE GoalId = @SprintId GROUP BY GoalId)
					           SET @GoalReplanId = (SELECT Id FROM GoalReplan WHERE GoalId = @SprintId AND GoalReplanCount = @GoalReplanCount)
							   SET @IsFromSprint = 1

								--SET @IsBug  = (SELECT IsBugBoard FROM BoardType BT JOIN Sprints S ON S.BoardTypeId = BT.Id AND BT.InActiveDateTime IS NULL AND S.Id = @SprintId)
								--SET @UserStoryTypeId = (CASE WHEN @IsBug IS NOT NULL AND @IsBug = 1 THEN (SELECT Id FROM UserStoryType WHERE IsBug = 1 AND CompanyId = @CompanyId) 
								--					    ELSE (SELECT Id FROM UserStoryType WHERE IsUserStory = 1 AND CompanyId = @CompanyId) END)

							END

                                  IF(@OldUserStoryStatusId <> @NewUserStoryStatusId)
                            
                                  SET @WorkflowEligibleStatusTransitionId = (SELECT Id FROM WorkflowEligibleStatusTransition 
                                                                              WHERE FromWorkflowUserStoryStatusId = @OldUserStoryStatusId 
                                                                                   AND ToWorkflowUserStoryStatusId = @NewUserStoryStatusId 
																				   AND WorkflowId = @WorkflowId AND CompanyId = @CompanyId
																				   AND InActiveDateTime IS NULL)

																				   --select @WorkflowEligibleStatusTransitionId,@OldUserStoryStatusId,@NewUserStoryStatusId,@WorkflowId,@CompanyId
                            
                                  IF((@WorkflowEligibleStatusTransitionId IS NULL) AND (@NewUserStoryStatusId IS NOT NULL) AND (@OldUserStoryStatusId <> @NewUserStoryStatusId) AND @UserStoryId IS NOT NULL)
                                  BEGIN
                                  
                                       RAISERROR ('NotAnEligibleTransition',11, 1)
                                  
                                  END
                                  ELSE
                                
                                  BEGIN

                                        IF(@UserStoryStatusId IS NULL) 
                                        BEGIN

											IF(@GoalId IS NOT NULL)
											BEGIN
											SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId
											                          WHERE G.Id = @GoalId 
																	        AND WS.CanAdd = 1 
																			AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL)

											END
											ELSE IF(@SprintId IS NOT NULL)
											BEGIN
											SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Sprints S ON S.BoardTypeId = BTW.BoardTypeId
											                          WHERE S.Id = @SprintId AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL)
											END
											ELSE
											BEGIN
												SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId 
																			FROM WorkflowStatus WS 
																				INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL
																				INNER JOIN Templates T ON T.BoardTypeId = BTW.BoardTypeId AND T.Id = @TemplateId)
												
											END

										END

								  IF(@UserStoryId IS NOT NULL)
								  BEGIN
										
										  EXEC [USP_InsertUserStoryAuditHistory] @UserStoryId = @UserStoryId,@UserStoryName = @UserStoryName,@GoalId = @GoalId,@EstimatedTime = @EstimatedTime,
										@DeadLineDate = @DeadLineDate,@OwnerUserId = @OwnerUserId,@DependencyUserId = @DependencyUserId,
										@UserStoryStatusId = @UserStoryStatusId,@BugPriorityId  = @BugPriorityId,@UserStoryTypeId = @UserStoryTypeId,
										@BugCausedUserId = @BugCausedUserId,@UserStoryPriorityId = @UserStoryPriorityId,
										@ParentUserStoryId = @ParentUserStoryId,@Description = @Description,@Order = @Order,@IsForQa = @IsForQa,@TestSuiteSectionId = @TestSuiteSectionId,
										@ReviewerUserId = @ReviewerUserId ,@ProjectFeatureId = @ProjectFeatureId,@OperationsPerformedBy = @OperationsPerformedBy
										,@VersionName = @VersionName, @SprintEstimatedTime = @SprintEstimatedTime,@RAGStatus = @RAGStatus,@ActionCategoryId = @ActionCategoryId,@TimeZoneId = @TimeZoneId,@StartDate = @StartDate
										
										
										IF(@ActionGoal = @GoalId)
								            BEGIN

													DECLARE @OldUserStoryName [nvarchar](800)
													DECLARE	@OldDeadLine DATETIME
													DECLARE	@OldBugPriorityId UNIQUEIDENTIFIER
													DECLARE	@OldUserStoryStatus UNIQUEIDENTIFIER
													DECLARE	@OldUserStoryUser UNIQUEIDENTIFIER
													DECLARE @OldEstimatedTime DECIMAL

													SELECT @OldUserStoryName = UserStoryName,
														   @OldDeadLine = DeadLineDate,
														   @OldBugPriorityId = BugPriorityId,
														   @OldEstimatedTime = EstimatedTime,
														   @OldUserStoryStatus = UserStoryStatusId,
														   @OldUserStoryUser = OwnerUserId
														FROM UserStory WHERE Id = @UserStoryId
												  

												   IF(@OldBugPriorityId IS NOT NULL AND @BugPriorityId IS NOT NULL AND @OldBugPriorityId <> @BugPriorityId)
												   BEGIN
													
														DECLARE @OldBugPriority NVARCHAR(500) = ISNULL((SELECT [Description] FROM BugPriority WHERE Id = @OldBugPriorityId),NULL)
														DECLARE @BugPriority NVARCHAR(500) = (SELECT [Description] FROM BugPriority WHERE Id = @BugPriorityId )
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldBugPriority,
														@NewValue = @BugPriority,@Description = 'ActionBugPriority',@Field='ActionBugPriority',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL
													END

													IF(@OldUserStoryStatus IS NOT NULL AND @OldUserStoryStatus <> @UserStoryStatusId)
												   BEGIN
													
														DECLARE @OldUserStoryStatusName NVARCHAR(500) = ISNULL((SELECT [Status] FROM UserStoryStatus WHERE Id = @OldUserStoryStatus),NULL)
														DECLARE @UserStoryStatusName NVARCHAR(500) = (SELECT [Status] FROM UserStoryStatus WHERE Id = @UserStoryStatusId )
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldUserStoryStatusName,
														@NewValue = @UserStoryStatusName,@Description = 'ActionStatus',@Field= 'ActionStatus',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL
													END
													DECLARE @OldUserStoryUserName NVARCHAR(500)
													DECLARE @UserStoryUserName NVARCHAR(500)
													IF(@OldUserStoryUser IS NOT NULL AND @OwnerUserId IS NOT NULL AND @OldUserStoryUser <> @OwnerUserId)
												   BEGIN
													
														SELECT @OldUserStoryUserName  = (SELECT [FirstName] + ' ' + ISNULL(SurName , '') FROM [User] WHERE Id = @OldUserStoryUser)
														SELECT @UserStoryUserName = (SELECT [FirstName] + ' ' + ISNULL(SurName , '') FROM [User] WHERE Id = @OwnerUserId )
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldUserStoryUserName,
														@NewValue = @UserStoryUserName,@Description = 'ActionUser',@Field ='ActionUser',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL
													END

												  IF(@OldDeadLine <> @DeadLineDate)
												  BEGIN
														SELECT @OldUserStoryUserName = FORMAT(@OldDeadLine,'dd-MMM-yyyy')
														SELECT @UserStoryUserName = FORMAT(@DeadLineDate,'dd-MMM-yyyy')
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldUserStoryUserName,
														@NewValue = @UserStoryUserName,@Description = 'ActionDeadLinePriority',@Field = 'ActionDeadLinePriority',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL
												  END

												  IF(@OldUserStoryName <> @UserStoryName)
												  BEGIN
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldUserStoryName,
														@NewValue = @UserStoryName,@Description = 'ActionName',@Field= 'ActionName',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL 
											     END
													
												  IF(@OldEstimatedTime IS NOT NULL AND @OldEstimatedTime <> @EstimatedTime)
												  BEGIN
														EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldEstimatedTime,
														@NewValue = @EstimatedTime,@Description = 'ActionEstimate',@Field = 'ActionEstimate',@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL	
												 END

								            END
								  
								  END
                                   
								  DECLARE @UserStoryUnique NVARCHAR (100)
								  IF(@UserStoryUniqueName IS NOT NULL)
								  SET @UserStoryUnique = @UserStoryUniqueName
								  ELSE
								   SET @UserStoryUnique = (SELECT UserStoryUniqueName FROM UserStory WHERE Id = @UserStoryId)

								   DECLARE @TempUsertStoryId UNIQUEIDENTIFIER = @UserStoryId

								  IF(@UserStoryId IS NULL)
								  BEGIN

								  SET @UserStoryId = NEWID()

								  SET @Order = @MaxOrderId + 1

								  INSERT INTO [dbo].[UserStory](
                                           [Id],
                                           [GoalId],
                                           [UserStoryName],
                                           [EstimatedTime],
                                           [DeadLineDate],
										   [DeadLineDateTimeZone],
                                           [OwnerUserId],
										   [TestSuiteSectionId],
										   [TestCaseId],
                                           [DependencyUserId],
                                           [Order],
                                           [UserStoryStatusId],
                                           [ActualDeadLineDate],
                                           [ActualDeadLineDateTimeZone],
                                           [ArchivedDateTime],
                                           [BugPriorityId],
                                           [UserStoryTypeId],
                                           [ParkedDateTime],
                                           [ProjectFeatureId],
                                           [UserStoryPriorityId],
                                           [ReviewerUserId],
                                           [ParentUserStoryId],
                                           [CreatedDateTime],
										   [CreatedDateTimeZone],
                                           [CreatedByUserId],
										   UserStoryUniqueName,
										   [InActiveDateTime],
										   [Description],
										   [IsForQa],
										   [VersionName],
                                           [CustomApplicationId],
                                           [TemplateId],
										   [Tag],
										   [SprintId],
										   [SprintEstimatedTime],
										   [ProjectId],
										   [WorkFlowId],
										   [RAGStatus],
										   [ActionCategoryId],
										   [AuditConductQuestionId],
										   [StartDate]
                                           )
                                    SELECT @UserStoryId,
                                           @GoalId,
                                           @UserStoryName,
                                           CASE WHEN @EstimatedTime = 0 THEN NULL ELSE @EstimatedTime END,
                                           @DeadLineDate,
										   CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                                           @OwnerUserId,
										   @TestSuiteSectionId,
										   @TestCaseId,
                                           @DependencyUserId,
                                           @Order,
                                           @UserStoryStatusId,
                                           ISNULL(@ActualDeadLineDate,@DeadLineDate),
										   CASE WHEN ISNULL(@ActualDeadLineDate,@DeadLineDate) IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                                           CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                           @BugPriorityId,
                                           @UserStoryTypeId,
                                           @ParkedDateTime,
                                           @ProjectFeatureId,
                                           @UserStoryPriorityId,
                                           @ReviewerUserId,
                                           @ParentUserStoryId,
                                           @Currentdate,
										   @TimeZoneId,
                                           @OperationsPerformedBy,
										   ISNULL(@UserStoryUnique,([dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId))),
                                           CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
										   @Description,
										   @IsForQa,
										   @VersionName,
                                           @CustomApplicationId,
                                           @TemplateId,
										   @Tags,
										   @SprintId,
										   @SprintEstimatedTime,
										   @ProjectId,
										   @WorkflowId,
										   @RAGStatus,
										   @ActionCategoryId,
										   CONVERT(NVARCHAR(MAX), @AuditConductQuestionId),
										   @StartDate

								    DECLARE @NewLinkUserStoryId UNIQUEIDENTIFIER = NEWID()
									DECLARE @LinkUserStoryTypeId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[LinkUserStoryType] WHERE LinkUserStoryTypeName = 'Relates to' AND CompanyId = @CompanyId)

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
													@UserStoryName,
													@Currentdate,
													@TimeZoneId,
													@OperationsPerformedBy

						                  END
								
										   	IF(@IsFromBugs = 1)
									BEGIN
									   INSERT INTO [dbo].[LinkUserStory](
                                           [Id],
                                           [UserStoryId],
										   [LinkUserStoryTypeId],
										   [LinkUserStoryId],
										   [CreatedDateTime],
										   [CreatedDateTimeZoneId],
										   [CreatedByUserId]
                                           )
                                    SELECT @NewLinkUserStoryId,
									       @UserStoryId,
										   @LinkUserStoryTypeId,
										   @ParentUserStoryId,
										   @Currentdate,
										   @TimeZoneId,
										   @OperationsPerformedBy
									END

									END
									ELSE
									BEGIN

									DECLARE @OldUserStoryTypeId UNIQUEIDENTIFIER = (SELECT UserStoryTypeId FROM UserStory WHERE Id = @UserStoryId)

								   IF(@OldGoalId IS NOT NULL AND @GoalId <> @OldGoalId) 
			                       BEGIN
			                                CREATE TABLE #UserStory 
                                  (
                                         UserStoryId UNIQUEIDENTIFIER
								         ,UserStoryName NVARCHAR(800)
                                 )

				                
					             INSERT INTO #UserStory(UserStoryId)
					              SELECT US1.Id FROM UserStory US INNER JOIN UserStory US1 ON US.Id = US1.ParentUserStoryId 
							                           AND US.InActiveDateTime IS NULL  AND US1.InActiveDateTime IS NULL
							                            WHERE US.Id = @UserStoryId AND US1.GoalId = US.GoalId
                   

				            UPDATE UserStory SET GoalId = @GoalId,
				                                 WorkFlowId = @WorkflowId,
				                                 UpdatedDateTime = @CurrentDate,
				                                 UserStoryStatusId = @UserStoryStatusId,
												 UpdatedDateTimeZoneId = @TimeZoneId,
				                                 UpdatedByUserId = @OperationsPerformedBy
				                               FROM [Userstory] US INNER JOIN #UserStory USS ON (USS.UserStoryId = US.Id OR USS.UserStoryId = US.ParentUserStoryId)
			                  END

							   

									UPDATE [dbo].[UserStory]
                                      SET  [GoalId] = @GoalId,
									       --[AuditConductQuestionId] = @AuditConductQuestionId,
                                           [UserStoryName] = @UserStoryName,
                                           [EstimatedTime] = @EstimatedTime,
                                           [DeadLineDate] = @DeadLineDate,
										   [DeadLineDateTimeZone] = CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END, 
                                           [OwnerUserId] = @OwnerUserId,
										   [TestSuiteSectionId] = @TestSuiteSectionId,
										   [TestCaseId] = @TestCaseId,
                                           [DependencyUserId] = @DependencyUserId,
                                           [UserStoryStatusId] = @UserStoryStatusId,
                                           [ActualDeadLineDate] = @ActualDeadLineDate,
										   [ActualDeadLineDateTimeZone] = @ActualDeadLineDateTimeZoneId,
                                           [ArchivedDateTime] = @ArchivedDateTime,
                                           [BugPriorityId] = @BugPriorityId,
                                           [UserStoryTypeId] = @UserStoryTypeId,
                                           [ParkedDateTime] = @ParkedDateTime,
										   [ParkedDateTimeZoneId] = CASE WHEN @ParkedDateTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                                           [ProjectFeatureId] = @ProjectFeatureId,
                                           [UserStoryPriorityId] = @UserStoryPriorityId,
                                           [ReviewerUserId] = @ReviewerUserId,
                                           [ParentUserStoryId] = @ParentUserStoryId,
                                           [UpdatedDateTime] = @Currentdate,
                                           [UpdatedByUserId] = @OperationsPerformedBy,
										   [UpdatedDateTimeZoneId] = @TimeZoneId,
										   [UserStoryUniqueName] = CASE WHEN @OldUserStoryTypeId = @UserStoryTypeId THEN @UserStoryUnique ELSE ([dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId)) END,
										   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
										   [InActiveDateTimeZoneId] = CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
										   [Description] = @Description,
				                           [CustomApplicationId] = @CustomApplicationId, 
										   [IsForQa]     = @IsForQa,
										   [VersionName] = @VersionName,
                                           [TemplateId] = @TemplateId,
										   [SprintId] = @SprintId,
										   [SprintEstimatedTime] = @SprintEstimatedTime,
										   [ActionCategoryId] = @ActionCategoryId,
										   [RAGStatus] = @RAGStatus,
										   [Tag] = @Tags,
										   [StartDate] = @StartDate
										   WHERE Id = @UserStoryId
			IF(@AuditConductQuestionId IS NOT NULL AND (SELECT AuditConductQuestionId FROM UserStory WHERE Id = @UserStoryId) IS NULL)
			BEGIN
			UPDATE UserStory SET AuditConductQUestionId = CONVERT(NVARCHAR(MAX), @AuditConductQuestionId) WHERE Id = @UserStoryId
			END 
			ELSE IF(@AuditConductQuestionId IS NOT NULL AND @AuditConductQuestionId NOT IN (SELECT [value] FROM [dbo].[Ufn_StringSplit]((SELECT AuditConductQuestionId FROM UserStory WHERE Id = @UserStoryId),',')))
			BEGIN
			DECLARE @Ids NVARCHAR(MAX) = (SELECT AuditConductQuestionId FROM UserStory WHERE Id = @UserStoryId)
			SET @Ids = @Ids + ',' + CONVERT(NVARCHAR(MAX), @AuditConductQuestionId)
			UPDATE UserStory SET AuditConductQUestionId = CONVERT(NVARCHAR(MAX), @Ids) WHERE Id = @UserStoryId
			END
			ELSE IF (@UnLinkActionId IS NOT NULL AND @UnLinkActionId IN (SELECT [value] FROM [dbo].[Ufn_StringSplit]((SELECT AuditConductQuestionId FROM UserStory WHERE Id = @UserStoryId),',')))
			BEGIN 
			CREATE TABLE #UnLinkActionTable ( Id UNIQUEIDENTIFIER )
			INSERT INTO #UnLinkActionTable SELECT [value] FROM (SELECT [value] FROM [dbo].[Ufn_StringSplit]((SELECT AuditConductQuestionId FROM UserStory WHERE Id = @UserStoryId),',')) A
			DELETE FROM #UnLinkActionTable WHERE Id = @UnLinkActionId
			DECLARE @Results NVARCHAR(MAX)
			SELECT @Results = COALESCE(@Results + ',', '') +  CONVERT(NVARCHAR(MAX),Id)
			FROM #UnLinkActionTable
			UPDATE UserStory SET AuditConductQUestionId = @Results WHERE Id = @UserStoryId
			END

			
		

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
													'UserStoryUpdate',
													'',
													@UserStoryName,
													@Currentdate,
													@TimeZoneId,
													@OperationsPerformedBy

						                  END

										  
										   
										
									END
                                    
									SELECT Id FROM [dbo].[UserStory] where Id = @UserStoryId

									IF(@TempUsertStoryId IS NULL)
									BEGIN
                                    
										INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTimeZoneId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @UserStoryId,
											          'UserStoryAdded',
													  'UserStoryAdded',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  GETDATE()
													  
										DECLARE @HistoryDescription NVARCHAR(MAX) = CASE WHEN @IsFromBugs = 1 THEN 'BugAdded'
										                                                ELSE 'UserStorySubTaskAdded' END

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
													  @UserStoryName,
													  @HistoryDescription,
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  @Currentdate
										  END

									END

                                     IF(@WorkflowEligibleStatusTransitionId IS NOT NULL)
                                           BEGIN

												INSERT INTO [dbo].[UserStoryWorkflowStatusTransition](
												         [Id],
												         [UserStoryId],
														 [CompanyId],
												         [WorkflowEligibleStatusTransitionId],
												         [TransitionDateTime],
														 [TransitionTimeZone],
												         [CreatedDateTime],
												         [CreatedByUserId],
														 CreatedDateTimeZoneId,
												         [UpdatedDateTime],
												         [UpdatedByUserId]
												         )
												  SELECT NEWID(),
												         @UserStoryId,
														 @CompanyId,
												         @WorkflowEligibleStatusTransitionId,
												         @Currentdate,
														 @TimeZoneId,
												         @Currentdate,
												         @OperationsPerformedBy,
												       
												         @TimeZoneId,
													   NULL,
												         NULL
                                           END

                                          IF(@BugCausedUserId IS NOT NULL)
                                           BEGIN
								
												    IF(@BugCausedUserDetailId IS NULL)
													BEGIN

													SET @BugCausedUserDetailId = NEWID()

													INSERT INTO [dbo].[BugCausedUser](
												                  [Id],
												                  [UserStoryId],
												                  [UserId],
												                  [CreatedDateTime],
																  [CreatedDateTimeZoneId],
												                  [CreatedByUserId]
												                  )
												           SELECT @BugCausedUserDetailId,
												                  @UserStoryId,
												                  @BugCausedUserId,
												                  @Currentdate,
																  @TimeZoneId,
												                  @OperationsPerformedBy
												                  
												  END
												  ELSE
												  BEGIN

												           UPDATE [dbo].[BugCausedUser]
												            SET   [UserStoryId] = @UserStoryId,
												                  [UserId] = @BugCausedUserId,
												                  [UpdatedDateTime] = @Currentdate,
												                  [UpdatedDateTimeZoneId] = @TimeZoneId ,
												                  [UpdatedByUserId] = @OperationsPerformedBy
																  WHERE Id = @BugCausedUserDetailId

												  END

                                          END
									   
									   IF(@BugCausedUserId IS NULL)
									   BEGIN
										
											UPDATE [dbo].[BugCausedUser] 
											       SET InActiveDateTime = @Currentdate
											           ,UpdatedByUserId = @OperationsPerformedBy
													   ,[UpdatedDateTimeZoneId] = @TimeZoneId 
													   ,[InActiveDateTimeZoneId] = @TimeZoneId 
													   ,UpdatedDateTime = @Currentdate
											WHERE UserStoryId = @UserStoryId AND InActiveDateTime IS NULL

									   END

									   IF(@UserstoryNameCount > 0)
										BEGIN
											
											UPDATE UserStory SET UserStoryName = UserStoryName + '-' + UserStoryUniqueName
											WHERE Id = @UserStoryId

										END

									IF(@OldUserStoryTypeId <> @UserStoryTypeId)
									BEGIN

										IF(EXISTS(SELECT Id FROM Folder WHERE Id = @UserStoryId  AND InActiveDateTime IS NULL))
										BEGIN

											UPDATE [dbo].[Folder]
											  SET  [FolderName] =  [dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId),
												   [UpdatedDateTime] = @Currentdate,
												   [UpdatedByUserId] = @OperationsPerformedBy
											WHERE Id = @UserStoryId
						
										END

									END

                                  IF(@OldTestSuiteSectionId <> @TestSuiteSectionId)
								  BEGIN

										  UPDATE [UserStoryScenario]
										     SET [InActiveDateTime] = @Currentdate,
											     [UpdatedByUserId] = @OperationsPerformedBy,
												 [UpdatedDateTime] = @Currentdate
												 FROM UserStoryScenario USS 
												 WHERE USS.InActiveDateTime IS NULL 
												     AND USS.UserStoryId = USS.UserStoryId 
												     AND USS.UserStoryId = @UserStoryId

								        UPDATE  [dbo].[UserStoryScenarioStep]
                                           SET  [InActiveDateTime] = @Currentdate,
                                                [UpdatedByUserId] = @OperationsPerformedBy,
												[UpdatedDateTime] = @Currentdate
												FROM UserStoryScenarioStep USS
                                                WHERE USS.InActiveDateTime IS NULL 
												     AND USS.UserStoryId = USS.UserStoryId 
												     AND USS.UserStoryId = @UserStoryId

                                  END

                                 END  

								 IF(@ActionGoal IS NOT NULL AND @ActionGoal = @GoalId)
								 BEGIN
								 
								 	 EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = NULL,
					                @NewValue = @UserStoryName,@Description = 'ActionAdded',@Field = 'ActionsAdded',@IsAction = 1,
					                @AuditId = NULL,@UserStoryId = @UserStoryId
								  
								END

						UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 

                        END
                   ELSE

                   BEGIN
                          RAISERROR (50008,11, 1)
                                              
                   END
                          
            END
    
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