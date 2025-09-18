CREATE PROCEDURE [dbo].[USP_UpsertMissingFeature]
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@UserStoryName NVARCHAR(800) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@UserStoryTypeId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	   DECLARE @CompanyId UNIQUEIDENTIFIER
                =   (
                         SELECT Id FROM [dbo].[Company] WHERE CompanyName = 'nxusworld'
                    )
	     IF (@HavePermission = '1')
        BEGIN
		   DECLARE @Currentdate DATETIME = GETDATE()
		   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Project] WHERE ProjectName ='Live Feedbacks' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
		   DECLARE @UserEmail NVARCHAR(250) = (SELECT WorkEmail from Company WHERE Id = @CompanyId)
		   DECLARE @BoardTypeId UNIQUEIDENTIFIER = (SELECT Top(1) Id From BoardType WHERE IsDefault=1 AND CompanyId=@CompanyId AND IsBugBoard=0 AND IsSuperAgileBoard=0 AND BoardTypeName='Kanban')
			  DECLARE @UserId UNIQUEIDENTIFIER = (SELECT Id FROM [User] WHERE UserName=@UserEmail AND CompanyId=@CompanyId)
			 IF(@ProjectId IS NULL)
			 BEGIN
			 SET @ProjectId = NEWID()
			  DECLARE @ProjectUniqueNumber INT
			  SELECT @ProjectUniqueNumber = MAX(CAST(SUBSTRING(ProjectUniqueName,CHARINDEX('-',ProjectUniqueName) + 1 ,LEN(ProjectUniqueName)) AS INT)) FROM Project WHERE CompanyId = @CompanyId
                       
			 INSERT INTO [dbo].[Project](
                                            [Id],
                                            [ProjectName],
                                            [CompanyId],
                                            [CreatedDateTime],
                                            [CreatedByUserId],
											[ProjectResponsiblePersonId],
                                            ProjectUniqueName
                                            )
                                    SELECT @ProjectId,
                                           'Live Feedbacks',
                                           @CompanyId,
                                           @Currentdate,
                                           @UserId,
										   @UserId,
                                           'P - ' + CAST(@ProjectUniqueNumber + 1 AS NVARCHAR(100))

										   INSERT INTO [dbo].[UserProject](
                                             [Id],
                                             [ProjectId],
                                             [EntityRoleId],
                                             [UserId],
                                             [CreatedDateTime],
                                             [CreatedByUserId]
                                             )
                                      SELECT NEWID(),
                                             @ProjectId,
                                             (SELECT Id FROM [dbo].[EntityRole] WHERE EntityRoleName = 'Project manager' AND CompanyId = @CompanyId),
                                             @UserId,
                                             @Currentdate,
                                             @UserId

											 EXEC [dbo].[USP_UpsertGoal]@GoalName = 'Backlog',@GoalShortName = 'Backlog',
						                              @ProjectId = @ProjectId,@BoardTypeId = @BoardTypeId,
													  @OperationsPerformedBy = @OperationsPerformedBy


			 END
		   DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Goal] WHERE Id = '7813E1DB-4610-4567-B2B6-D12E67FE274E')
		   DECLARE @WorkflowId UNIQUEIDENTIFIER = (
                                                       SELECT WorkflowId
                                                       FROM [dbo].[BoardTypeWorkFlow]
                                                       where BoardTypeId = @BoardTypeId
													   AND InActiveDateTime IS NULL
                                                   )

		   DECLARE @NewGoalId UNIQUEIDENTIFIER = '7813E1DB-4610-4567-B2B6-D12E67FE274E'
		   DECLARE @NewUserStoryId UNIQUEIDENTIFIER = (SELECT NEWID())
		   DECLARE @UserStoryStatusId UNIQUEIDENTIFIER = (SELECT WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId
											                          WHERE G.Id = @GoalId AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId)
		  
		   DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE GoalId = @GoalId)
		   SET @UserStoryTypeId = (SELECT Id FROM [dbo].[UserStoryType] WHERE IsUserStory = 1 AND CompanyId = @CompanyId)
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
                                ON P.Id = G.ProjectId
                        WHERE P.CompanyId = @CompanyId AND GoalUniqueName <> 'Adhoc' AND GoalUniqueName <> 'Exit' AND GoalUniqueName <> 'Induction' AND GoalUniqueName <> 'Compliance'

			IF(@GoalId IS NOT NULL)
             BEGIN
			    DECLARE @UserstoryNameCount INT = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName AND GoalId = @GoalId)
				IF (@UserstoryNameCount >0)
				 BEGIN
                   RAISERROR(50001,16,1,'UserStory')
                 END
			 END


		   IF(@GoalId IS NULL)
		    BEGIN
			      INSERT INTO [dbo].[Goal]
                        (
                            [Id],
                            [GoalName],
                            [GoalShortName],
                            [ProjectId],
                            [BoardTypeId],
							[IsApproved],
							[GoalStatusId],
                            [GoalResponsibleUserId],
                            [CreatedDateTime],
                            [CreatedByUserId],
                            [GoalUniqueName],
							[OnboardProcessDate]
                        )
                        SELECT @NewGoalId,
                              'BTrak Missing Features',
                              'BTrak Missing Features',
                               @ProjectId,
                               @BoardTypeId,
							   1,
							   '7A79AB9F-D6F0-40A0-A191-CED6C06656DE',
							   '0B2921A9-E930-4013-9047-670B5352F308',
                               @Currentdate,
                               '0B2921A9-E930-4013-9047-670B5352F308',
                               ('G - ' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))),
							   GETDATE()
                             
						INSERT INTO [dbo].[GoalWorkFlow](
                                                      [Id],
                                                      [GoalId],
                                                      [WorkflowId],
                                                      [CreatedDateTime],
                                                      [CreatedByUserId]
													  )
                                               SELECT NEWID(),
                                                      @NewGoalId,
                                                      @WorkFlowId,
                                                      @Currentdate,
                                                      '0B2921A9-E930-4013-9047-670B5352F308'

						 INSERT INTO GoalHistory
                        (
                            Id,
                            GoalId,
                            FieldName,
                            OldValue,
                            NewValue,
                            [Description],
                            CreatedByUserId,
                            CreatedDateTime
                        )
                        SELECT NEWID(),
                               @NewGoalId,
                               'GoalAdded',
                               '',
                               'BTrak Missing Features',
                               'GoalAdded',
                               @OperationsPerformedBy,
                               GETDATE()
					DECLARE @UserstoryFeatureNameCount INT = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName AND GoalId = @NewGoalId)
				        IF (@UserstoryFeatureNameCount >0)
				         BEGIN
                          RAISERROR(50001,16,1,'UserStory')
                         END
					DECLARE @NewUserStoryStatusId UNIQUEIDENTIFIER = (SELECT WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId
											                          WHERE G.Id = @NewGoalId AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId)
						INSERT INTO [dbo].[UserStory](
						                              [Id],
													  [UserStoryName],
													  [GoalId],
													  [Description],
													  [UserStoryStatusId],
													  [UserStoryUniqueName],
													  [UserStoryTypeId],
													  [Order],
													  [ProjectId],
													  [WorkFlowId],
													  [CreatedDateTime],
													  [CreatedByUserId]
						                             )
								            SELECT   @NewUserStoryId,
											         @UserStoryName,
													 @NewGoalId,
													 @Description,
													 @NewUserStoryStatusId,
													 ([dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId)),
													 @UserStoryTypeId,
													 @MaxOrderId + 1,
													 @ProjectId,
													 @WorkflowId,
													 GETDATE(),
													 @OperationsPerformedBy

							INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @NewUserStoryId,
											          'UserStoryAdded',
													  'UserStoryAdded',
													  @OperationsPerformedBy,
													  GETDATE()	

			END
			ELSE
			 BEGIN

			 DECLARE @UserStoryUnique NVARCHAR (10) = (SELECT UserStoryUniqueName FROM UserStory WHERE Id = @UserStoryId) 

			         	INSERT INTO [dbo].[UserStory](
						                              [Id],
													  [UserStoryName],
													  [GoalId],
													  [Description],
													  [UserStoryStatusId],
													  [UserStoryUniqueName],
													  [UserStoryTypeId],
													  [Order],
													  [ProjectId],
													  [WorkFlowId],
													  [CreatedDateTime],
													  [CreatedByUserId]
						                             )
								            SELECT   @NewUserStoryId,
											         @UserStoryName,
													 @GoalId,
													 @Description,
													 @UserStoryStatusId,
													 ISNULL(@UserStoryUnique,([dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId))),
													 @UserStoryTypeId,
													 @MaxOrderId + 1,
													 @ProjectId,
													 @WorkflowId,
													 GETDATE(),
													 @OperationsPerformedBy

							INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @NewUserStoryId,
											          'UserStoryAdded',
													  'UserStoryAdded',
													  @OperationsPerformedBy,
													  GETDATE()	
			 END
			 SELECT @NewUserStoryId
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