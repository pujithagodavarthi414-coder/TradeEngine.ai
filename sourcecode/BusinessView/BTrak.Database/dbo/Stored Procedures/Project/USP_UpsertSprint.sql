--EXEC [dbo].[USP_UpsertSprint] @sprintId= 'C12800EF-CCEB-4857-B1B2-03BFFCA630F9',@sprintName= 'Sprint - 16',
--@projectId='53c96173-0651-48bd-88a9-7fc79e836cce', @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',
--@Description = 'ffcfd',@timeStamp=  @TimeStamp,@sprintStartDate = '2020-03-10T00:00:00.000Z',@sprintEndDate= '2020-03-11T00:00:00.000Z' 
CREATE PROCEDURE [dbo].[USP_UpsertSprint]
    @SprintId UNIQUEIDENTIFIER = NULL,
    @SprintName NVARCHAR(1000) = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @SprintStartDate DATETIME = NULL,
    @SprintEndDate DATETIME = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@IsReplan BIT = NULL,
	@BoardTypeId UNIQUEIDENTIFIER = NULL,
	@BoardTypeApiId UNIQUEIDENTIFIER = NULL,
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
	@Version NVARCHAR(50) = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @Description NVARCHAR(800) = NULL,
	@SprintResponsiblePersonId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250)
            =   (
                    SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](   @OperationsPerformedBy,
                                                                         @ProjectId,
                           (
                               SELECT OBJECT_NAME(@@PROCID)
                           )
                                                                     )
                )
        IF (@HavePermission = '1')
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER
                =   (
                        SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                    )
            DECLARE @SprintNameCount INT = (
                                               SELECT COUNT(1)
                                               FROM Sprints
                                               WHERE SprintName = @SprintName
                                                     And ProjectId = @ProjectId
                                                     AND (
                                                             Id <> @SprintId
                                                             OR @SprintId IS NULL
                                                         )
                                                     AND InActiveDateTime IS NULL
                                           )
            IF (@SprintNameCount > 0)
            BEGIN
                RAISERROR(50001, 16, 1, 'Sprint')
            END
            ELSE
            BEGIN
                DECLARE @IsLatest BIT
                    = (CASE
                           WHEN @SprintId IS NULL THEN
                               1
                           ELSE
                               CASE
                                   WHEN
                                   (
                                       SELECT [TimeStamp] FROM Sprints WHERE Id = @SprintId
                                   ) = @TimeStamp THEN
                                       1
                                   ELSE
                                       0
                               END
                       END
                      )
                IF (@IsLatest = 1)
                BEGIN
                    
                    IF(@Version = '') SET @Version = NULL

                    IF(@Description = '') SET @Description = NULL

                    IF(@IsReplan IS NULL) SET @IsReplan = 0

                     DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			         SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                     DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

                    IF (@SprintId IS NULL)
                    BEGIN
                        SET @SprintId = NEWID()
                        DECLARE @UniqueNumber INT
                        SELECT @UniqueNumber =
                        (
                            SELECT MAX(CAST(SUBSTRING([SprintName], LEN('Sprint-') + 1, LEN([SprintName])) AS INT))
                            FROM [Sprints]
                            WHERE InActiveDateTime IS NULL
                                  AND (
                                          IsNameEdit = 0
                                          OR IsNameEdit IS NULL
                                      )
                                  AND ProjectId = @ProjectId
                        )

						  DECLARE @MaxNumber INT

                        SELECT @MaxNumber
                            = MAX(CAST(SUBSTRING(
                                                    SprintUniqueName,
                                                    CHARINDEX('-', SprintUniqueName) + 1,
                                                    LEN(SprintUniqueName)
                                                ) AS INT)
                                 )
                        FROM Sprints S
                            INNER JOIN Project P
                                ON P.Id = S.ProjectId 
                        WHERE P.CompanyId = @CompanyId AND S.InActiveDateTime IS NULL 

						SET @BoardTypeId = (SELECT Id FROM [dbo].[BoardType] WHERE BoardTypeName = 'SuperAgile'  AND CompanyId = @CompanyId)
					
                        INSERT INTO [dbo].[Sprints]
                        (
                            [Id],
                            [SprintName],
                            [ProjectId],
                            [Description],
                            [SprintStartDate],
							[SprintStartDateTimeZoneId],
							[BoardTypeId],
							[BoardTypeApiId],
							[Version],
							[TestSuiteId],
							[SprintResponsiblePersonId],
							[SprintUniqueName],
                            [CreatedDateTime],
							[CreatedDateTimeZoneId],
                            [CreatedByUserId]
                        )
                        SELECT @SprintId,
                               ('Sprint-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))),
                               @ProjectId,
                               @Description,
                               @SprintStartDate,
							   @TimeZoneId,
							   @BoardTypeId,
							   @BoardTypeApiId,
							   @Version,
							   @TestSuiteId,
							   @SprintResponsiblePersonId,
							   ('S-' + CAST(ISNULL(@MaxNumber, 0) + 1 AS NVARCHAR(100))),
                               @Currentdate,
							   @TimeZoneId,
                               @OperationsPerformedBy

                        INSERT INTO SprintHistory
                        (
                            Id,
                            SprintId,
                            FieldName,
                            OldValue,
                            NewValue,
                            [Description],
                            CreatedByUserId,
							CreatedDateTimeZoneId,
                            CreatedDateTime
                        )
                        SELECT NEWID(),
                               @SprintId,
                               'SprintAdded',
                               '',
                              ('Sprint-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))),
                               'SprintAdded',
                               @OperationsPerformedBy,
							   @TimeZoneId,
                               GETDATE()
                    END
                    ELSE
                    BEGIN
                        DECLARE @OldSprintName NVARCHAR(50)
                            =   (
                                    SELECT SprintName FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
						DECLARE @IsNameEdit BIT = (SELECT IsNameEdit FROM [dbo].[Sprints] WHERE Id = @SprintId)

                        IF (@OldSprintName <> @SprintName)
                        BEGIN

                            UPDATE Folder
                            SET FolderName = @SprintName,
                                UpdatedDateTime = @Currentdate,
                                UpdatedByUserId = @OperationsPerformedBy
                            WHERE Id = @SprintId
                                  AND InActiveDateTime IS NULL

                        END
                        DECLARE @OldValue NVARCHAR(800)
                        DECLARE @NewValue NVARCHAR(800)
                        DECLARE @FieldName NVARCHAR(500)
                        DECLARE @HistoryDescription NVARCHAR(500)
                        IF (@OldSprintName <> @SprintName)
                        BEGIN
                            SET @OldValue = @OldSprintName
                            SET @NewValue = @SprintName
                            SET @FieldName = 'Sprint Name'
                            SET @HistoryDescription = 'SprintNameChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END
                        DECLARE @OldDescription NVARCHAR(800)
                            =   (
                                    SELECT [Description] FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        
                        IF (
                               (@OldDescription <> @Description)
                               OR (
                                      @OldDescription IS NULL
                                      AND @Description IS NOT NULL
                                  )
                             OR (
                                  @OldDescription IS NOT NULL
                                  AND @Description IS NULL
                              )
                           )
                        BEGIN
                            SET @OldValue = @OldDescription
                            SET @NewValue = @Description
                            SET @FieldName = 'Sprint Description'
                            SET @HistoryDescription = 'SprintDescriptionChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
								CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END
                        --DECLARE @OldSprintStartDate DATETIME
                        --    =   (
                        --            SELECT SprintStartDate FROM [dbo].[Sprints] WHERE Id = @SprintId
                        --        )
                        --IF (
                        --       (@OldSprintStartDate <> @SprintStartDate)
                        --       OR (
                        --              @OldSprintStartDate IS NULL
                        --              AND @SprintStartDate IS NOT NULL
                        --          )
                        --   )
                        --BEGIN
                        --    SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldSprintStartDate, 'dd/MM/yyyy'))
                        --    SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@SprintStartDate, 'dd/MM/yyyy'))
                        --    SET @FieldName = 'Sprint Start Date'
                        --    SET @HistoryDescription = 'SprintStartDateChanged'
                        --    INSERT INTO SprintHistory
                        --    (
                        --        Id,
                        --        SprintId,
                        --        FieldName,
                        --        OldValue,
                        --        NewValue,
                        --        [Description],
                        --        CreatedByUserId,
                        --        CreatedDateTime
                        --    )
                        --    SELECT NEWID(),
                        --           @SprintId,
                        --           @FieldName,
                        --           @OldValue,
                        --           @NewValue,
                        --           @HistoryDescription,
                        --           @OperationsPerformedBy,
                        --           GETDATE()
                        --END
                        --DECLARE @OldSprintEndDate DATETIME
                        --    =   (
                        --            SELECT SprintEndDate FROM [dbo].[Sprints] WHERE Id = @SprintId
                        --        )
                        --IF (
                        --       (@OldSprintEndDate <> @SprintEndDate)
                        --       OR (
                        --              @OldSprintEndDate IS NULL
                        --              AND @SprintEndDate IS NOT NULL
                        --          )
                        --   )
                        --BEGIN
                        --    SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldSprintEndDate, 'dd/MM/yyyy'))
                        --    SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@SprintEndDate, 'dd/MM/yyyy'))
                        --    SET @FieldName = 'Sprint End Date'
                        --    SET @HistoryDescription = 'SprintEndDateChanged'
                        --    INSERT INTO SprintHistory
                        --    (
                        --        Id,
                        --        SprintId,
                        --        FieldName,
                        --        OldValue,
                        --        NewValue,
                        --        [Description],
                        --        CreatedByUserId,
                        --        CreatedDateTime
                        --    )
                        --    SELECT NEWID(),
                        --           @SprintId,
                        --           @FieldName,
                        --           @OldValue,
                        --           @NewValue,
                        --           @HistoryDescription,
                        --           @OperationsPerformedBy,
                        --           GETDATE()
                        --END

						DECLARE @OldSprintStartDate DATETIME =  (SELECT SprintStartDate FROM [dbo].[Sprints] WHERE Id = @SprintId)
						DECLARE @OldSprintEndDate DATETIME =  (SELECT SprintEndDate FROM [dbo].[Sprints] WHERE Id = @SprintId)

                        IF (((@OldSprintStartDate <> @SprintStartDate) OR (@OldSprintStartDate IS NULL AND @SprintStartDate IS NOT NULL))
							AND ((@OldSprintEndDate <> @SprintEndDate) OR (@OldSprintEndDate IS NULL AND @SprintEndDate IS NOT NULL))
						   )
                        BEGIN
                            SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldSprintStartDate, 'dd/MM/yyyy')) + ' - ' + CONVERT(NVARCHAR(500), FORMAT(@OldSprintEndDate, 'dd/MM/yyyy'))
                            SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@SprintStartDate, 'dd/MM/yyyy')) + ' - ' + CONVERT(NVARCHAR(500), FORMAT(@SprintEndDate, 'dd/MM/yyyy'))
                            SET @FieldName = 'Sprint Start And End Date'
                            SET @HistoryDescription = 'SprintStartAndEndDateChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END
						ELSE IF ((@OldSprintStartDate <> @SprintStartDate) OR (@OldSprintStartDate IS NULL AND @SprintStartDate IS NOT NULL))
						BEGIN

							SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldSprintStartDate, 'dd/MM/yyyy'))
                            SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@SprintStartDate, 'dd/MM/yyyy'))
                            SET @FieldName = 'Sprint Start Date'
                            SET @HistoryDescription = 'SprintStartDateChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()

						END
						ELSE IF ((@OldSprintEndDate <> @SprintEndDate) OR (@OldSprintEndDate IS NULL AND @SprintEndDate IS NOT NULL))
						BEGIN

							SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldSprintEndDate, 'dd/MM/yyyy'))
                            SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@SprintEndDate, 'dd/MM/yyyy'))
                            SET @FieldName = 'Sprint End Date'
                            SET @HistoryDescription = 'SprintEndDateChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()

						END

						 DECLARE @OldBoardTypeId UNIQUEIDENTIFIER
                            =   (
                                    SELECT BoardTypeId FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        IF (
                               (@OldBoardTypeId <> @BoardTypeId)
                           )
                        BEGIN
                            SET @OldValue = (SELECT BoardTypeName FROM [dbo].[BoardType] WHERE Id = @OldBoardTypeId)
                            SET @NewValue = (SELECT BoardTypeName FROM [dbo].[BoardType] WHERE Id = @BoardTypeId)
                            SET @FieldName = 'Sprint BoardType'
                            SET @HistoryDescription = 'SprintBoardTypeChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END

						 DECLARE @OldVersion NVARCHAR(50)
                            =   (
                                    SELECT [Version] FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        IF (
                               (@OldVersion <> @Version) OR (
                                      @OldVersion IS NULL
                                      AND @Version IS NOT NULL
                                  )
                                  OR (
                                      @OldVersion IS NOT NULL
                                      AND @Version IS NULL
                                  )
                           )
                        BEGIN
                            SET @OldValue = @OldVersion
                            SET @NewValue = ISNULL(@Version,'null')
                            SET @FieldName = 'Sprint Version'
                            SET @HistoryDescription = 'SprintVersionChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END

						DECLARE @OldSprintResponsiblePersonId NVARCHAR(50)
                            =   (
                                    SELECT [SprintResponsiblePersonId] FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        IF (
                               (@OldSprintResponsiblePersonId IS NULL AND @SprintResponsiblePersonId IS NOT NULL) OR (@OldSprintResponsiblePersonId <> @SprintResponsiblePersonId)
                           )
                        BEGIN
                            SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [dbo].[User] WHERE Id = @OldSprintResponsiblePersonId)
                            SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [dbo].[User] WHERE Id = @SprintResponsiblePersonId)
                            SET @FieldName = 'Sprint responsible person'
                            SET @HistoryDescription = 'SprintResponsiblePersonChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END

						 DECLARE @OldBoardTypeApiId UNIQUEIDENTIFIER
                            =   (
                                    SELECT BoardTypeApiId FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        IF (
                               (@OldBoardTypeApiId <> @BoardTypeApiId)
                           )
                        BEGIN
                            SET @OldValue = (SELECT ApiName FROM [dbo].[BoardTypeApi] WHERE Id = @OldBoardTypeApiId)
                            SET @NewValue = (SELECT ApiName FROM [dbo].[BoardTypeApi] WHERE Id = @BoardTypeApiId)
                            SET @FieldName = 'Sprint BoardTypeApi'
                            SET @HistoryDescription = 'SprintBoardTypeApiChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END

						 DECLARE @OldTestSuiteId UNIQUEIDENTIFIER
                            =   (
                                    SELECT TestSuiteId FROM [dbo].[Sprints] WHERE Id = @SprintId
                                )
                        IF (
                               (@OldTestSuiteId IS NOT NULL AND @TestSuiteId IS NULL) OR (@OldTestSuiteId IS NULL AND @TestSuiteId IS NOT NULL) OR (@OldTestSuiteId <> @TestSuiteId)
                           )
                        BEGIN
                            SET @OldValue = ISNULL((SELECT TestSuiteName FROM [dbo].[TestSuite] WHERE Id = @OldTestSuiteId),'null')
                            SET @NewValue = ISNULL((SELECT TestSuiteName FROM [dbo].[TestSuite] WHERE Id = @TestSuiteId),'null')
                            SET @FieldName = 'Sprint TestSuite'
                            SET @HistoryDescription = 'SprintTestSuiteChanged'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()
                        END
						
                        
						 DECLARE @OldIsReplan BIT
                            =   (
                                   ISNULL((SELECT IsReplan FROM [dbo].[Sprints] WHERE Id = @SprintId),0)
                                )
                        IF (
                               (@OldIsReplan <> @IsReplan)
                           )
                        BEGIN

			            	 SET @OldValue = IIF(@OldIsReplan = 0,'Active','Replan')
                            SET @NewValue = IIF(@IsReplan = 0,'Active','Replan')
                            SET @FieldName = 'SprintStatus'
                            SET @HistoryDescription = 'SprintStatusChanged'

                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
                                CreatedByUserId,
								CreatedDateTimeZoneId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   GETDATE()

			            END

						 UPDATE [dbo].[Sprints]
                    SET SprintName = @SprintName,
                        ProjectId = @ProjectId,
                        SprintStartDate = @SprintStartDate,
						SprintStartDateTimeZoneId = CASE WHEN @SprintStartDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                        SprintEndDate = @SprintEndDate,
						
                        [Description] = @Description,
                        UpdatedDateTime = @Currentdate,
					    [UpdatedDateTimeZoneId] = @TimeZoneId,
						BoardTypeId = @BoardTypeId,
                        UpdatedByUserId = @OperationsPerformedBy,
						IsReplan = @IsReplan,
						BoardTypeApiId = @BoardTypeApiId,
						[Version] = @Version,
						TestSuiteId = @TestSuiteId,
						SprintResponsiblePersonId = @SprintResponsiblePersonId,
						ActualSprintEndDate = CASE WHEN (SELECT ActualSprintEndDate FROM Sprints WHERE Id =@SprintId) IS NULL THEN @SprintEndDate ELSE (SELECT ActualSprintEndDate FROM Sprints WHERE Id =@SprintId) END,
                        IsNameEdit = CASE WHEN @IsNameEdit = 1 THEN @IsNameEdit
                                          WHEN @OldSprintName <> @SprintName THEN
                                             1
                                         ELSE
                                             0
                                     END
                    WHERE Id = @SprintId

					IF (@OldBoardTypeId <> @BoardTypeId)
					BEGIN
					    DECLARE @UserStoryTypeId UNIQUEIDENTIFIER  = (CASE WHEN (SELECT IsBugBoard FROM BoardType WHERE Id = @BoardTypeId AND InActiveDateTime IS NULL) = 1 THEN (SELECT Id FROM UserStoryType UST WHERE IsBug = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
			                                                    ELSE (SELECT Id FROM UserStoryType UST WHERE IsUserStory = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) END)
            
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
			                        JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.SprintId = @SprintId 
			                                                AND USS.InActiveDateTime IS NULL
									DECLARE @WorkflowId UNIQUEIDENTIFIER = (
                                                       SELECT WorkflowId
                                                       FROM [dbo].[BoardTypeWorkFlow]
                                                       where BoardTypeId = @BoardTypeId
                                                   )

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
													  ,WorkFlowId = @WorkflowId
													  ,UpdatedDateTime = @Currentdate
													  ,UpdatedByUserId = @OperationsPerformedBy
													  FROM UserStory US
													  JOIN @Temp T ON T.UserStoryId = US.Id
					END

                    END
                    SELECT Id
                    FROM [dbo].[Sprints]
                    WHERE Id = @SprintId

                END
                ELSE
                    RAISERROR(50008, 11, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR(@HavePermission, 11, 1)
        END
    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO