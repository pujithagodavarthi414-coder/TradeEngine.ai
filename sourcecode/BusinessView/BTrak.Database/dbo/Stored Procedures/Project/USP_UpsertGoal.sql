---------------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-14 00:00:00.000' select * from Goal where originalId = '87ADF55E-C647-4C98-85BB-2C366A2584E3'
-- Purpose      To Get the Employee Presence By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertGoal]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalName = 'Test',
-- @ProjectId = '53c96173-0651-48bd-88a9-7fc79e836cce' ,@BoardTypeId = '28009E1D-EB84-41F0-9541-E10F054FE6C1'
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGoal]
(
    @GoalId UNIQUEIDENTIFIER = NULL,
    @GoalName NVARCHAR(500) = NULL,
    @GoalShortName NVARCHAR(500) = NULL,
    @IsArchived BIT = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @BoardTypeId UNIQUEIDENTIFIER = NULL,
    @BoardTypeApiId UNIQUEIDENTIFIER = NULL,
    @OnboardDate DATETIMEOFFSET = NULL,
    @GoalResponsiblePersonId UNIQUEIDENTIFIER = NULL,
    @ConfigurationId UNIQUEIDENTIFIER = NULL,
    @TobeTracked BIT = NULL,
    @IsProductiveBoard BIT = NULL,
    @ConsideredHoursId UNIQUEIDENTIFIER = NULL,
    @IsParked BIT = NULL,
    @IsApproved BIT = NULL,
    @IsLocked BIT = NULL,
    @IsCompleted BIT = NULL,
    @GoalBudget MONEY = NULL,
    @Version NVARCHAR(50) = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(MAX)= NULL,
	@TimeZone NVARCHAR(250)= NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@EndDate DATETIMEOFFSET = NULL,
	@EstimatedTime DECIMAL (18, 2) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250) =   (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER
                =   (
                        SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                    )

            DECLARE @GoalIdCount INT = (
                                           SELECT COUNT(1) FROM Goal WHERE Id = @GoalId
                                       )

            DECLARE @IsBugBoard INT = (
                                          SELECT IsBugBoard
                                          FROM BoardType
                                          WHERE Id = @BoardTypeId
                                                AND InActiveDateTime IS NULL
                                      )

             DECLARE @WorkflowId UNIQUEIDENTIFIER = (
                                                       SELECT BTW.WorkflowId
                                                       FROM [dbo].[BoardTypeWorkFlow] BTW
                                                       where BTW.BoardTypeId = @BoardTypeId 
                                                   )
			DECLARE @OldProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Goal] WHERE Id = @GoalId)

            DECLARE @GoalNameCount INT = (
                                             SELECT COUNT(1)
                                             FROM Goal
                                             WHERE GoalName = @GoalName
                                                   And ProjectId = @ProjectId
                                                   AND (
                                                           Id <> @GoalId
                                                           OR @GoalId IS NULL
                                                       )
                                                   AND InActiveDateTime IS NULL

                                         )
			
			DECLARE @OldBoardTypeId UNIQUEIDENTIFIER,
                                @OldTestSuiteId UNIQUEIDENTIFIER,
                                @OldIsApproved BIT,
                                @OldIsLocked BIT,
								@Tag NVARCHAR(MAX)

                        SELECT @OldBoardTypeId = BoardTypeId,
                               @OldIsApproved = IsApproved,
                               @OldIsLocked = IsLocked,
                               @OldTestSuiteId = TestSuiteId,
							   @Tag = Tag
                        FROM [dbo].[Goal]
                        WHERE Id = @GoalId

		    DECLARE @NotmatchedCount INT = (SELECT COUNT(1) FROM UserStory US JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.GoalId = @GoalId 
			                                                 AND USS.TaskStatusId NOT IN 
															     (SELECT USS.TaskStatusId FROM UserStoryStatus USS
																			   JOIN WorkflowStatus WFS ON WFS.UserStoryStatusId = USS.Id 
																			   JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WFS.WorkflowId 
																			   AND BTW.BoardTypeId = @BoardTypeId))

            IF (@GoalIdCount = 0 AND @GoalId IS NOT NULL)
            BEGIN
                RAISERROR(50002, 16, 1, 'Goal')
            END
            ELSE IF(@GoalName = 'Adhoc Goal' OR @GoalShortName = 'Adhoc Goal')
			BEGIN
					
					RAISERROR('CreatingAdhocGoalIsNotPermitted',11,1)

            END
           ELSE IF (@IsBugBoard = 1 AND @TestSuiteId IS NOT NULL)
            BEGIN

                RAISERROR('UnableToAddTestsuiteToTheBugBoard', 11, 1)

            END
			ELSE IF (@OldBoardTypeId IS NOT NULL AND @OldBoardTypeId <> @BoardTypeId AND @NotmatchedCount > 0)
			BEGIN

				RAISERROR('TaskStatusesDoesntMatch',11,1)

			END
            ELSE
            BEGIN

                DECLARE @IsLatest BIT
                    = (CASE
                           WHEN @GoalId IS NULL THEN
                               1
                           ELSE
                               CASE
                                   WHEN
                                   (
                                       SELECT [TimeStamp] FROM [Goal] WHERE Id = @GoalId
                                   ) = @TimeStamp THEN
                                       1
                                   ELSE
                                       0
                               END
                       END
                      )

                IF (@IsLatest = 1)
                BEGIN
                    
					  DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					  SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone

					  DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset) 

                    DECLARE @GoalStatusId UNIQUEIDENTIFIER
                        = CASE
                              WHEN @IsCompleted = 1 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Completed'
                              )
                              WHEN @IsParked = 1 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Parked'
                              )
                              WHEN @IsParked = 0 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Active'
                              )
                              WHEN @IsLocked = 0 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Replan'
                              )
                              WHEN @IsLocked = 1 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Active'
                              )
                              WHEN @IsApproved IS NULL THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Backlog'
                              )
                              WHEN @IsApproved = 1 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Active'
                              )
                              WHEN @IsArchived = 1 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Archived'
                              )
                              WHEN @IsArchived = 0 THEN
                              (
                                  SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Active'
                              )
                              ELSE
                                  NULL
                          END
                   
				
				    IF (@GoalId IS NULL)
                    BEGIN

                        SET @GoalId = NEWID()

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

                        INSERT INTO [dbo].[Goal]
                        (
                            [Id],
                            [GoalName],
                            [GoalShortName],
                            [ProjectId],
                            [BoardTypeId],
                            [TestSuiteId],
                            [OnboardProcessDate],
							[OnboardProcessDateTimeZoneId],
                            [GoalResponsibleUserId],
                            [ConfigurationId],
                            [IsToBeTracked],
                            [IsProductiveBoard],
                            [ConsiderEstimatedHoursId],
                            [ParkedDateTime],
                            [IsApproved],
                            [IsLocked],
                            [IsCompleted],
                            [GoalStatusId],
                            [GoalStatusColor],
                            [GoalBudget],
                            [BoardTypeApiId],
                            [CreatedDateTime],
							[CreatedDateTimeZoneId],
                            [CreatedByUserId],
                            [GoalUniqueName],
							[Description],
                            [InActiveDateTime],
							[Version],
							[EndDate],
							[GoalEstimatedTime]
                        )
                        SELECT @GoalId,
                               @GoalName,
                               @GoalShortName,
                               @ProjectId,
                               @BoardTypeId,
                               @TestSuiteId,
                               @OnboardDate,
							   CASE WHEN @OnboardDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                               @GoalResponsiblePersonId,
                               @ConfigurationId,
                               @TobeTracked,
                               @IsProductiveBoard,
                               @ConsideredHoursId,
                               CASE
                                   WHEN @IsParked = 1 THEN
                                       @Currentdate
                                   ELSE
                                       NULL
                               END,
                               @IsApproved,
                               @IsLocked,
                               @IsCompleted,
                               @GoalStatusId,
                               NULL,
                               @GoalBudget,
                               @BoardTypeApiId,
                               @Currentdate,
							   @TimeZoneId,
                               @OperationsPerformedBy,
                               ('G-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))),
							   @Description,
                               CASE
                                   WHEN @IsArchived = 1 THEN
                                       @Currentdate
                                   ELSE
                                       NULL
                               END,
							   @Version,
							   @EndDate,
							   @EstimatedTime
                        
						INSERT INTO [dbo].[GoalWorkFlow](
                                                      [Id],
                                                      [GoalId],
                                                      [WorkflowId],
                                                      [CreatedDateTime],
													  [CreatedDateTimeZoneId],
                                                      [CreatedByUserId]
													  )
                                               SELECT NEWID(),
                                                      @GoalId,
                                                      @WorkFlowId,
                                                      @Currentdate,
													  @TimeZoneId,
                                                      @OperationsPerformedBy
									

                        INSERT INTO GoalHistory
                        (
                            Id,
                            GoalId,
                            FieldName,
                            OldValue,
                            NewValue,
                            [Description],
                            CreatedByUserId,
							CreatedDateTimeZoneId,
                            CreatedDateTime
                        )
                        SELECT NEWID(),
                               @GoalId,
                               CASE WHEN @IsApproved = 1 THEN 'GoalAddedInActive'
							        ELSE 'GoalAdded' END,
                               '',
                               @GoalName,
                               CASE WHEN @IsApproved = 1 THEN 'GoalAddedInActive'
							        ELSE 'GoalAdded' END,
                               @OperationsPerformedBy,
							   @TimeZoneId,
                               @Currentdate

                    END
                    ELSE
                    BEGIN

                        EXEC [USP_InsertGoalAuditHistory] @GoalId = @GoalId,
                                                          @GoalName = @GoalName,
                                                          @GoalShortName = @GoalShortName,
                                                          @BoardTypeId = @BoardTypeId,
                                                          @BoardTypeApiId = @BoardTypeApiId,
                                                          @OnboardDate = @OnboardDate,
                                                          @GoalResponsiblePersonId = @GoalResponsiblePersonId,
                                                          @TobeTracked = @TobeTracked,
                                                          @IsProductiveBoard = @IsProductiveBoard,
                                                          @ProjectId = @ProjectId,
                                                          @ConsideredHoursId = @ConsideredHoursId,
                                                          @GoalBudget = @GoalBudget,
                                                          @Version = @Version,
                                                          @TestSuiteId = @TestSuiteId,
                                                          @GoalStatusId = @GoalStatusId,
														  @Description = @Description,
														  @TimeZoneId = @TimeZoneId,
                                                   
                                                          @OperationsPerformedBy = @OperationsPerformedBy,
                                                          @EndDate = @EndDate,
                                                          @EstimatedTime = @EstimatedTime

                        UPDATE [dbo].[Goal]
                        SET [GoalName] = @GoalName,
                            [GoalShortName] = @GoalShortName,
                            [ProjectId] = @ProjectId,
                            [BoardTypeId] = @BoardTypeId,
                            [TestSuiteId] = @TestSuiteId,
                            [OnboardProcessDate] = @OnboardDate,
							[OnboardProcessDateTimeZoneId] = CASE WHEN @OnboardDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                            [GoalResponsibleUserId] = @GoalResponsiblePersonId,
                            [ConfigurationId] = @ConfigurationId,
                            [IsToBeTracked] = @TobeTracked,
                            [IsProductiveBoard] = @IsProductiveBoard,
                            [ConsiderEstimatedHoursId] = @ConsideredHoursId,
                            [ParkedDateTime] = CASE
                                                   WHEN @IsParked = 1 THEN
                                                       @Currentdate
                                                   ELSE
                                                       NULL
                                               END,
                            [ParkedDateTimeZoneId] = CASE WHEN @IsParked = 1 THEN @TimeZoneId ELSE  NULL END,
                            [IsApproved] = @IsApproved,
                            [IsLocked] = @IsLocked,
                            [IsCompleted] = @IsCompleted,
							[Version] = @Version,
                            [GoalStatusId] = @GoalStatusId,
                            [GoalStatusColor] = dbo.[Ufn_GoalColour](@GoalId),
                            [GoalBudget] = @GoalBudget,
                            [BoardTypeApiId] = @BoardTypeApiId,
							[Tag] = @Tag,
                            [UpdatedDateTime] = @Currentdate,
                            [UpdatedByUserId] = @OperationsPerformedBy,
							[UpdatedDateTimeZoneId] = @TimeZoneId,
							[InActiveDateTimeZoneId] = CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
							[EndDate] = @EndDate,
							[GoalEstimatedTime] = @EstimatedTime,
							[Description] = ISNULL(@Description,[Description]),
                            [InActiveDateTime] = CASE
                                                     WHEN @IsArchived = 1 THEN
                                                         @Currentdate
                                                     ELSE
                                                         NULL
                                                 END
                        WHERE Id = @GoalId

						IF (@OldProjectId <> @ProjectId)
						BEGIN
						   UPDATE [dbo].[UserStory]
                            SET [GoalId] = @GoalId,
                                [ProjectId] = @ProjectId,
                                [UpdatedDateTime] = @Currentdate,
								[UpdatedDateTimeZoneId] = @TimeZoneId,
                                [UpdatedByUserId] = @OperationsPerformedBy
                            FROM UserStory
                            WHERE GoalId = @GoalId

						   UPDATE [dbo].[Goal]
						    SET [TestSuiteId] = NULL FROM [dbo].[Goal] WHERE Id = @GoalId
						END

						 IF (@BoardTypeApiId IS NULL)
                        BEGIN
							 IF(@OldBoardTypeId <> @BoardTypeId)
                                 BEGIN    
                                   
                                    UPDATE [GoalWorkFlow] SET WorkflowId = @WorkflowId
									                         ,UpdatedDateTime = @Currentdate
															 ,UpdatedByUserId = @OperationsPerformedBy
															 ,UpdatedDateTimeZoneId = @TimeZoneId
									 WHERE GoalId = @GoalId

									 UPDATE [UserStory] SET WorkFlowId = @WorkflowId
									                         ,UpdatedDateTime = @Currentdate
															 ,UpdatedDateTimeZoneId = @TimeZoneId
															 ,UpdatedByUserId = @OperationsPerformedBy
									 WHERE GoalId = @GoalId

									DECLARE @UserStoryTypeId UNIQUEIDENTIFIER  = (CASE WHEN (SELECT IsBugBoard FROM BoardType WHERE Id = @BoardTypeId AND InActiveDateTime IS NULL) = 1 THEN CASE WHEN EXISTS(SELECT Id FROM UserStoryType UST WHERE IsBug = 1 AND ShortName = 'BUG' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) THEN (SELECT TOP 1 Id FROM UserStoryType UST WHERE IsBug = 1 AND ShortName = 'BUG' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) ELSE (SELECT  TOP 1 Id FROM UserStoryType UST WHERE IsBug = 1 AND  CompanyId = @CompanyId AND InActiveDateTime IS NULL) END
			                                                                         ELSE CASE WHEN EXISTS(SELECT  Id FROM UserStoryType UST WHERE IsUserStory = 1 AND ShortName = 'WI' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) THEN (SELECT TOP 1 Id FROM UserStoryType UST WHERE IsUserStory = 1 AND ShortName = 'WI' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) ELSE (SELECT TOP 1 Id FROM UserStoryType UST WHERE IsUserStory = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) END END)
            
			                        DECLARE @UniqueShortName NVARCHAR(20) = (SELECT ShortName FROM UserStoryType WHERE CompanyId = @CompanyId AND Id = @UserStoryTypeId)
			 
			                        DECLARE @UniqueName NVARCHAR(250) = (SELECT [dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId))

			                        DECLARE @MaxUniqueNumber INT = (SELECT CAST(SUBSTRING(@UniqueName,LEN(@UniqueShortName) + 2,LEN(@UniqueName)) AS INT))

					                DECLARE @Temp TABLE(
									    Id INT IDENTITY(1,1),
                                        UserStoryId UNIQUEIDENTIFIER,
                                        TaskStatusId UNIQUEIDENTIFIER,
										NewUserStoryStatusId UNIQUEIDENTIFIER
									  )

                                    INSERT INTO @Temp (UserStoryId,TaskStatusId)
                                    SELECT US.Id,USS.TaskStatusId 
                                    FROM UserStory US
			                        JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.GoalId = @GoalId 
			                                                AND USS.InActiveDateTime IS NULL

                                    UPDATE @Temp SET NewUserStoryStatusId = New.UserStoryStatusId
                                           FROM @Temp Tem
						                   JOIN (SELECT S.TaskStatusId,
                                                        WFS.UserStoryStatusId 
			                                            FROM UserStoryStatus USS
			                                            JOIN WorkflowStatus WFS ON WFS.UserStoryStatusId = USS.Id
												                                             AND WFS.WorkflowId = @WorkflowId
                                                        JOIN (SELECT TaskStatusId,
			                                                         MIN(OrderId) AS OrderId
									                                 FROM WorkflowStatus WFS JOIN UserStoryStatus USS ON WFS.UserStoryStatusId = USS.Id 
														AND WorkFlowId = @WorkflowId GROUP BY TaskStatusId) S ON S.TaskStatusId = USS.TaskStatusId 
														AND WFS.OrderId = S.OrderId) New ON Tem.TaskStatusId = New.TaskStatusId

									
								 
                                  UPDATE UserStory SET UserStoryStatusId = T.NewUserStoryStatusId
													  ,UpdatedDateTime = @Currentdate
													  ,UpdatedByUserId = @OperationsPerformedBy
													  ,UpdatedDateTimeZoneId = @TimeZoneId
													  FROM UserStory US
													  JOIN @Temp T ON T.UserStoryId = US.Id
                                END
                        END

                        IF (@OldTestSuiteId <> @TestSuiteId)
                        BEGIN

                            UPDATE [dbo].[UserStory]
                            SET [GoalId] = @GoalId,
                                [TestSuiteSectionId] = NULL,
                                [UpdatedDateTime] = @Currentdate,
								[UpdatedDateTimeZoneId] = @TimeZoneId,
                                [UpdatedByUserId] = @OperationsPerformedBy
                            FROM UserStory US
                                INNER JOIN TestSuiteSection TSS
                                    ON TSS.Id = US.TestSuiteSectionId
                                       AND TSS.InActiveDateTime IS NULL
                            WHERE GoalId = @GoalId
                                  AND TSS.TestSuiteId = @OldTestSuiteId

                        UPDATE [dbo].[UserStoryScenario]
                        SET [InActiveDateTime] = @Currentdate,
                            [UpdatedDateTime] = @Currentdate,
                            [UpdatedByUserId] = @OperationsPerformedBy
                        FROM UserStoryScenario USS
                            INNER JOIN UserStory US
                                ON US.Id = USS.UserStoryId
                                   AND USS.InActiveDateTime IS NULL
                        WHERE US.GoalId = @GoalId

                        UPDATE [dbo].[UserStoryScenarioStep]
                        SET [InActiveDateTime] = @Currentdate,
                            [UpdatedDateTime] = @Currentdate,
                            [UpdatedByUserId] = @OperationsPerformedBy
                        FROM UserStoryScenarioStep USSS
                            INNER JOIN UserStory US
                                ON US.Id = USSS.UserStoryId
                                   AND USSS.InActiveDateTime IS NULL
                        WHERE US.GoalId = @GoalId

                        UPDATE [dbo].[GoalWorkFlow]
                        SET [WorkflowId] = @WorkflowId,
                            [UpdatedDateTime] = @Currentdate,
                            [UpdatedDateTimeZoneId] = @TimeZoneId,
                            [UpdatedByUserId] = @OperationsPerformedBy
						WHERE GoalId = @GoalId

						END
                    END

                    UPDATE [Goal]
                    SET GoalStatusColor =
                        (
                            SELECT [dbo].[Ufn_GoalColour](@GoalId)
                        )
                    WHERE Id = @GoalId
					 
					 IF(@GoalNameCount > 0)
					 BEGIN
					 	
					 	UPDATE Goal SET GoalName = GoalName + '-' + GoalUniqueName
					 	WHERE Id = @GoalId
					 
					 END
				IF (@GoalName <> 'Backlog' AND @GoalShortName <> 'Backlog')
				BEGIN
                    SELECT Id
                    FROM [dbo].[Goal]
                    where Id = @GoalId
				END

                END
                ELSE
                    RAISERROR(50008, 11, 1)
            END
        END
        ELSE
            RAISERROR(@HavePermission, 11, 1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO