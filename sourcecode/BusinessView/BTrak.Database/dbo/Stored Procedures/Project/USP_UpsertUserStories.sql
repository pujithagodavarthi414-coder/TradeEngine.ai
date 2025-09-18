
--EXEC [USP_UpsertUserStories] @GoalId ='ff4047b8-39b1-42d2-8910-4e60ed38aac7',@AmendBy = 2,
--@OperationsPerformedBy = '0b2921a9-e930-4013-9047-670b5352f308',@UserStoryIdsXml='<GenericListOfGuid><ListItems><guid>DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5</guid><guid>C0EEC924-630F-46D8-A5FF-E87015B01A29</guid><guid>9A201000-B260-444E-82BC-1765812598B3</guid></ListItems></GenericListOfGuid>'

CREATE PROCEDURE [dbo].[USP_UpsertUserStories]
(
    @UserStoryIdsXml XML,
    @EstimatedTime DECIMAL(18, 2) = NULL,
    @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
    @OwnerUserId UNIQUEIDENTIFIER = NULL,
    @DependencyUserId UNIQUEIDENTIFIER = NULL,
    @ClearEstimate BIT = NULL,   --(If true, then set estimate = null for the selected UserStories)
    @SetBackStatus BIT = NULL,   --(If true, then get configuration of the userstory and set the first status)
    @ClearOwner BIT = NULL,      --(If true, then set Owner= null for the selected UserStories)
    @ClearDependency BIT = NULL, --(If true, then set Dependecy = null for the selected UserStories)
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @AmendBy INT = NULL,         -- (if not null add amendby days to deadline)
    @GoalId UNIQUEIDENTIFIER = NULL,
	@SprintId UNIQUEIDENTIFIER = NULL,
	@TimeZone NVARCHAR(250) = NULL,
	@IsFromSrint BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

     DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF(@HavePermission = '1')
     BEGIN

        DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
		SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
		
        DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)    
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @TaskStatusOrder INT = (SELECT [Order] FROM TaskStatus TS JOIN UserStoryStatus USS ON USS.TaskStatusId = TS.Id AND USS.Id = @UserStoryStatusId AND USS.CompanyId = @CompanyId)
		
        DECLARE @UserStoryTypeId UNIQUEIDENTIFIER
            =   (
                    SELECT Id FROM UserStoryType WHERE UserStoryTypeName = 'Work item' AND CompanyId = @CompanyId
                )

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
            SET @OperationsPerformedBy = NULL

		IF(@IsFromSrint IS NULL) SET @IsFromSrint = 0

        IF (@EstimatedTime < 0)
        BEGIN

            RAISERROR('EstimateCanNotBeNegativeOrZero', 11, 1)

        END
		ELSE IF(@GoalId IS NULL AND @IsFromSrint = 0)
			 BEGIN

				RAISERROR(50011,11,1,'Goal')

			 END
	    ELSE IF(@SprintId IS NULL AND @IsFromSrint = 1)
		BEGIN
		    RAISERROR(50011,11,1,'Sprint')
		END
			
        ELSE
        BEGIN

            DECLARE @UserName NVARCHAR(500),
                    @WorkflowId UNIQUEIDENTIFIER,
                    @WorkflowEligibleStatusTransitionId UNIQUEIDENTIFIER

            CREATE TABLE #TempUserStoryTable
            (
                RowNumber INT IDENTITY(1, 1),
                UserStoryId UNIQUEIDENTIFIER
            )

            IF (@UserStoryIdsXml IS NOT NULL)
            BEGIN

                INSERT INTO #TempUserStoryTable
                (
                    UserStoryId
                )
                SELECT x.y.value('(text())[1]', 'uniqueidentifier')
                FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS x(y)

            END
            ELSE
            BEGIN
				IF (@IsFromSrint = 0)
				BEGIN 
				           INSERT INTO #TempUserStoryTable(       
						       UserStoryId  
						   )
				    SELECT Id
                    FROM UserStory
                    WHERE GoalId = @GoalId
				END
				ELSE
				BEGIN
				           INSERT INTO #TempUserStoryTable(       
						       UserStoryId  
						   )
				    SELECT Id
                    FROM UserStory
                    WHERE SprintId = @SprintId 
				END
            END

            IF (@AmendBy IS NOT NULL)
            BEGIN

                INSERT INTO [UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    [CreatedDateTime],
					CreatedDateTimeZoneId,
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       TUS.UserStoryId,
                       ISNULL(CONVERT(NVARCHAR, CONVERT(DATETIME,US.DeadLineDate)), 'null'),
                       ISNULL(CONVERT(NVARCHAR,DATEADD(DAY, @AmendBy, CONVERT(DATETIME, US.DeadLineDate))),'null'),
                       'DeadLineDate',
                       'DeadLineDateChanged',
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

                UPDATE [dbo].[UserStory]
                SET [ActualDeadLineDate] = ISNULL(US.ActualDeadLineDate, CAST(DATEADD(DAY, @AmendBy, CONVERT(DATETIME, US.DeadLineDate)) AS DATETIMEOFFSET)),
                    [DeadLineDate] = CAST(DATEADD(DAY, @AmendBy, CONVERT(DATETIME, US.DeadLineDate)) AS DATETIMEOFFSET),
                    [UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedDateTime] = @Currentdate
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

            END

            IF (@EstimatedTime IS NOT NULL AND @EstimatedTime <> 0)
            BEGIN

                INSERT INTO [UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    [CreatedDateTime],
					CreatedDateTimeZoneId,
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       TUS.UserStoryId,
                       ISNULL(CONVERT(NVARCHAR,US.EstimatedTime), 'null'),
                       ISNULL(CONVERT(NVARCHAR,@EstimatedTime), 'null'),
                       'EstimatedTime',
                       'EstimatedTimeChanged',
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

                UPDATE [dbo].[UserStory]
                SET EstimatedTime = @EstimatedTime,
                    [UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedDateTime] = @Currentdate
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

            END

            IF (@OwnerUserId IS NOT NULL)
            BEGIN

                SET @UserName =
                (
                    SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE Id = @OwnerUserId AND CompanyId = @CompanyId
                )

                INSERT INTO [UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    [CreatedDateTime],
					CreatedDateTimeZoneId,
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       TUS.UserStoryId,
                       ISNULL(U.FirstName + ' ' + ISNULL(U.SurName,''), 'null'),
                       ISNULL(@UserName, 'null'),
                       'OwnerUserName',
                       'OwnerUserChanged',
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId
                    LEFT JOIN [User] AS U
                        ON U.Id = US.OwnerUserId

                UPDATE [dbo].[UserStory]
                SET OwnerUserId = @OwnerUserId,
                    [UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedDateTime] = @Currentdate
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

            END

            IF (@DependencyUserId IS NOT NULL)
            BEGIN

                SET @UserName =
                (
                    SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE Id = @DependencyUserId AND CompanyId = @CompanyId
                )

                INSERT INTO [UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    [CreatedDateTime],
					[CreatedDateTimeZoneId],
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       TUS.UserStoryId,
                       ISNULL(U.FirstName + ' ' + ISNULL(U.SurName,''), 'null'),
                       ISNULL(@UserName, 'null'),
                       'DependencyUserName',
                       'DependencyUserChanged',
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId
                    LEFT JOIN [User] AS U
                        ON U.Id = US.DependencyUserId

                UPDATE [dbo].[UserStory]
                SET DependencyUserId = @DependencyUserId,
                    [UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedDateTime] = @Currentdate
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

            END

            IF (@UserStoryStatusId IS NOT NULL)
            BEGIN

                CREATE TABLE #UserStoryStatuses (UserStoryStatusId UNIQUEIDENTIFIER)
				IF(@IsFromSrint = 1)
				BEGIN
				        INSERT INTO #UserStoryStatuses
                (
                    UserStoryStatusId
                )
                SELECT USS.Id
                FROM UserStory US
                    JOIN #TempUserStoryTable T
                        ON T.UserStoryId = US.Id
                    INNER JOIN [UserStoryStatus] AS USS
                        ON USS.Id = US.UserStoryStatusId
						   AND USS.CompanyId = @CompanyId
                    LEFT JOIN Sprints AS S
                        ON US.SprintId = S.Id
                    INNER JOIN BoardTypeWorkFlow AS BWF
                        ON BWF.BoardTypeId = S.BoardTypeId
                    LEFT JOIN WorkflowStatus AS WFS
                        ON WFS.WorkflowId = BWF.WorkflowId
                           AND [OrderId] = 1
						   AND WFS.CompanyId = @CompanyId
                    INNER JOIN UserStoryStatus AS USS1
                        ON USS1.Id = WFS.UserStoryStatusId
						   AND USS1.CompanyId = @CompanyId
                GROUP BY USS.Id

				END
				ELSE
				BEGIN
				              INSERT INTO #UserStoryStatuses
                (
                    UserStoryStatusId
                )
                SELECT USS.Id
                FROM UserStory US
                    JOIN #TempUserStoryTable T
                        ON T.UserStoryId = US.Id
                    INNER JOIN [UserStoryStatus] AS USS
                        ON USS.Id = US.UserStoryStatusId
						   AND USS.CompanyId = @CompanyId
                    LEFT JOIN Goal AS G
                        ON US.GoalId = G.Id
                    INNER JOIN GoalWorkflow AS GWF
                        ON GWF.GoalId = G.Id
                    LEFT JOIN WorkflowStatus AS WFS
                        ON WFS.WorkflowId = GWF.WorkflowId
                           AND [OrderId] = 1
						   AND WFS.CompanyId = @CompanyId
                    INNER JOIN UserStoryStatus AS USS1
                        ON USS1.Id = WFS.UserStoryStatusId
						   AND USS1.CompanyId = @CompanyId
                GROUP BY USS.Id

				END

               
				DECLARE @WithOutOwnerNameCount INT = (SELECT COUNT(1) FROM UserStory US INNER JOIN  #TempUserStoryTable TUS ON TUS.UserStoryId = US.Id AND US.OwnerUserId IS NULL)

                DECLARE @UserStoryStatusCount INT = (
                                                        SELECT COUNT(1) FROM #UserStoryStatuses
                                                    )

                IF (@UserStoryStatusCount > 1)
                BEGIN

                    RAISERROR('PleaseSelectUserStoriesWithSameStatus', 11, 1)

                END
				 
                DECLARE @OldUserStoryStatusId UNIQUEIDENTIFIER = (
                                                                     SELECT UserStoryStatusId
                                                                     FROM #UserStoryStatuses
                                                                     GROUP BY UserStoryStatusId
                                                                 )
				 IF(@IsFromSrint = 1)
				 BEGIN
				     SET @WorkflowId =
                (
                    SELECT BTWF.WorkFlowId
                    from Sprints G
                        JOIN BoardTypeWorkFlow BTWF
                            ON BTWF.BoardTypeId = G.BoardTypeId
                    WHERE G.Id = @SprintId
                )
				 END
				 ELSE
				 BEGIN

                 SET @WorkflowId =
                (
                    SELECT BTWF.WorkFlowId
                    from Goal G
                        JOIN BoardTypeWorkFlow BTWF
                            ON BTWF.BoardTypeId = G.BoardTypeId
                    WHERE G.Id = @GoalId
                )
				END

                IF (@OldUserStoryStatusId <> @UserStoryStatusId)
                BEGIN

                    SET @WorkflowEligibleStatusTransitionId =
                    (
                        SELECT Id
                        FROM WorkflowEligibleStatusTransition
                        WHERE FromWorkflowUserStoryStatusId = @OldUserStoryStatusId
                              AND ToWorkflowUserStoryStatusId = @UserStoryStatusId
                              AND WorkflowId = @WorkflowId
							  AND CompanyId = @CompanyId
							  AND InActiveDateTime IS NULL
                    )
                END
                IF (@WorkflowEligibleStatusTransitionId IS NULL)
                BEGIN

                    RAISERROR('NotAnEligibleTransitionForOneOfTheUserStory', 11, 1)

                END

                DECLARE @UserStoryStatusName NVARCHAR(250)
                    =   (
                            SELECT [Status] FROM [UserStoryStatus] WHERE Id = @UserStoryStatusId AND CompanyId = @CompanyId
                        )

                INSERT INTO [UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    [CreatedDateTime],
					CreatedDateTimeZoneId,
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       TUS.UserStoryId,
                       ISNULL(USS.[Status], 'null'),
                       ISNULL(@UserStoryStatusName, 'null'),
                       'UserStoryStatus',
                       'UserStoryStatusChanged',
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId
                    INNER JOIN [UserStoryStatus] AS USS
                        ON USS.Id = US.UserStoryStatusId
						   AND CompanyId = @CompanyId

                UPDATE [dbo].[UserStory]
                SET UserStoryStatusId = @UserStoryStatusId,
                    [UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedDateTime] = @Currentdate
                FROM #TempUserStoryTable TUS
                    INNER JOIN UserStory US
                        ON US.Id = TUS.UserStoryId

                INSERT INTO [dbo].[UserStoryWorkflowStatusTransition]
                (
                    [Id],
                    [UserStoryId],
                    [WorkflowEligibleStatusTransitionId],
                    [TransitionDateTime],
					[TransitionTimeZone],
                    [CreatedDateTime],
					CreatedDateTimeZoneId,
                    [CreatedByUserId]
                )
                SELECT NEWID(),
                       UserStoryId,
                       @WorkflowEligibleStatusTransitionId,
                       @Currentdate,
					   @TimeZoneId,
                       @Currentdate,
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable

            END

			IF(@IsFromSrint = 1)
			BEGIN
			   SELECT SprintId
            FROM UserStory
            WHERE Id IN (
                            SELECT UserStoryId FROM #TempUserStoryTable
                        )
            GROUP BY SprintId
			END
			ELSE
			BEGIN
            SELECT GoalId
            FROM UserStory
            WHERE Id IN (
                            SELECT UserStoryId FROM #TempUserStoryTable
                        )
            GROUP BY GoalId
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