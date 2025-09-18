-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-23 00:00:00.000'
-- Purpose      To Archive UserStory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE @TimeStamp timestamp = (select [timestamp] from UserStory where Id ='21163870-1915-42EB-89A0-98100371A187')
--EXEC [dbo].[USP_ArchiveUserStory_New] @TimeStamp = @TimeStamp,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId='21163870-1915-42EB-89A0-98100371A187',@IsArchive = 1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ArchiveUserStory_New]
(
    @UserStoryId UNIQUEIDENTIFIER = NULL,
	@UserStoryStatusId UNIQUEIDENTIFIER = NULL,
    @IsArchive BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @TimeZone VARCHAR(250) = NULL,
    @GoalId UNIQUEIDENTIFIER = NULL,
	@SprintId UNIQUEIDENTIFIER = NULL,
	@IsFromSprint BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
            SET @OperationsPerformedBy = NULL

            DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
            DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

        DECLARE @FieldName NVARCHAR(200),
                @HistoryDescription NVARCHAR(800)

        SET @FieldName = 'ArchivedDateTime'

        DECLARE @ProjectId UNIQUEIDENTIFIER

        IF (@UserStoryId IS NOT NULL)
        BEGIN
		    IF (@IsFromSprint = 1)
			BEGIN
			  SET @ProjectId =
              (
                SELECT [dbo].[Ufn_GetProjectIdBySprintUserStoryId](@UserStoryId)
              )
			END
			ELSE
			BEGIN
              SET @ProjectId =
              (
                SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId)
              )
			END
        END
        ELSE
        BEGIN
            SET @ProjectId =
            (
                SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId)
            )
        END

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN


            IF (@UserStoryId IS NOT NULL)
            BEGIN

                DECLARE @ArchivedDateTime DATETIME
                    =   (
                            SELECT InActiveDateTime FROM UserStory WHERE Id = @UserStoryId
                        )

                DECLARE @CompanyId UNIQUEIDENTIFIER
                    =   (
                            SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                        )

                IF (@UserStoryId = '00000000-0000-0000-0000-000000000000')
                    SET @UserStoryId = NULL

                IF (@UserStoryId IS NULL)
                BEGIN

                    RAISERROR(50011, 16, 2, 'UserStory')

                END
                ELSE
                BEGIN
                    DECLARE @IsLatest BIT
                        = (CASE
                               WHEN
                               (
                                   SELECT [TimeStamp] FROM UserStory WHERE Id = @UserStoryId
                               ) = @TimeStamp THEN
                                   1
                               ELSE
                                   0
                           END
                          )

                    IF (@IsLatest = 1)
                    BEGIN

						CREATE TABLE #UserStory 
						 (
						    UserStoryId UNIQUEIDENTIFIER,
							ArchivedDateTime DATETIME
						 )
						 INSERT INTO #UserStory(UserStoryId,ArchivedDateTime)
						 SELECT Id,InActiveDateTime
						 FROM UserStory US
						 WHERE (Id = @UserStoryId OR ParentUserStoryId = @UserStoryId)

                        IF (
                               (
                                   @IsArchive = 1
                                   AND @ArchivedDateTime IS NULL
                               )
                               OR (
                                      @IsArchive = 0
                                      AND @ArchivedDateTime IS NOT NULL
                                  )
                           )
                        BEGIN

                            DECLARE @OldArchivedDateTime NVARCHAR(250) = CASE
                                                                             WHEN @IsArchive = 1 THEN
                                                                                 NULL
                                                                             WHEN @IsArchive = 0 THEN
                                                                                 @ArchivedDateTime
                                                                         END
                            DECLARE @NewArchivedDateTime NVARCHAR(250) = CASE
                                                                             WHEN @IsArchive = 1 THEN
                                                                                 ISNULL(@Currentdate,GETDATE())
                                                                             WHEN @IsArchive = 0 THEN
                                                                                 NULL
                                                                         END

                            SET @HistoryDescription = CASE
                                                          WHEN @IsArchive = 1 THEN
                                                              'UserstoryArchived'
                                                          WHEN @IsArchive = 0 THEN
                                                              'UserstoryUnArchived'
                                                      END

                                    INSERT INTO [dbo].[UserStoryHistory](
                                                            [Id],
                                                            [UserStoryId],
                                                            [OldValue],
                                                            [NewValue],
                                                            [FieldName],
                                                            [Description],
                                                            CreatedDateTime,
															CreatedDateTimeZoneId,
                                                            CreatedByUserId)
                                                     SELECT NEWID(),
                                                            TUST.UserStoryId,
                                                            TUST.ArchivedDateTime,
                                                            (CASE
															     WHEN @IsArchive = 1 THEN
															         @Currentdate
															     ELSE
															        Null
															 END
															),
                                                            'ArchivedDateTime',
                                                            @HistoryDescription,
                                                            @Currentdate,
															@TimeZoneId,
                                                            @OperationsPerformedBy
                                                       FROM #UserStory TUST  

                        END

                        UPDATE UserStory
                        SET InactiveDateTime = (CASE
                                                    WHEN @IsArchive = 1 THEN
                                                        @Currentdate
                                                    ELSE
                                                        NULL
                                                END
                                               ),
                            [UpdatedByUserId] = @OperationsPerformedBy,
							[UpdatedDateTimeZoneId] = @TimeZoneId,
							[InActiveDateTimeZoneId] = CASE WHEN @IsArchive = 1 THEN @TimeZoneId ELSE NULL END,
                            [UpdatedDateTime] = @Currentdate
						FROM UserStory US INNER JOIN #UserStory TUS ON TUS.UserStoryId = US.Id                    
                        SELECT Id
                        FROM [dbo].[UserStory]
                        where Id = @UserStoryId

							EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = NULL,
														@NewValue = NULL,@Description = @HistoryDescription,@Field= @HistoryDescription,@IsAction = 1,@UserStoryId = @UserStoryId,
														@AuditId = NULL 

						   UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 

                    END
                    ELSE
                        RAISERROR(50015, 11, 1)
                END
            END
            ELSE
            BEGIN

                CREATE TABLE #TempUserStoryTable
                (
                    UserStoryId UNIQUEIDENTIFIER
                )
				IF(@IsFromSprint = 1)
				BEGIN
				  INSERT INTO #TempUserStoryTable
                (
                    UserStoryId
                )
				
                SELECT US.Id
                FROM UserStory US
                    JOIN Sprints S
                        ON S.Id = US.SprintId
                    JOIN BoardType BT
                        ON BT.Id = S.BoardTypeId
                    JOIN UserStoryStatus USS
                        ON USS.Id = US.UserStoryStatusId
                WHERE SprintId = @SprintId
                      AND US.InactiveDateTime IS NULL
                      AND US.ArchivedDateTime IS NULL
                      AND US.UserStoryStatusId = @UserStoryStatusId

				END
				ELSE
				BEGIN
				    INSERT INTO #TempUserStoryTable
                (
                    UserStoryId
                )
				
                SELECT US.Id
                FROM UserStory US
                    JOIN Goal G
                        ON G.Id = US.GoalId
                    JOIN BoardType BT
                        ON BT.Id = G.BoardTypeId
                    JOIN UserStoryStatus USS
                        ON USS.Id = US.UserStoryStatusId
                WHERE GoalId = @GoalId
                      AND US.InactiveDateTime IS NULL
                      AND US.ArchivedDateTime IS NULL
                      AND US.UserStoryStatusId = @UserStoryStatusId

				END
                
                UPDATE UserStory
                SET InactiveDateTime = @CurrentDate,
				  InActiveDateTimeZoneId = @TimeZoneId
                FROM UserStory US
                    JOIN #TempUserStoryTable TUST
                        ON TUST.UserStoryId = US.Id

			

			   UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 

                INSERT INTO [dbo].[UserStoryHistory]
                (
                    [Id],
                    [UserStoryId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    CreatedDateTime,
					CreatedDateTimeZoneId,
                    CreatedByUserId
                )
                SELECT NEWID(),
                       TUST.UserStoryId,
                       'NULL',
                       GETDATE(),
                       @FieldName,
                       'UserstoryArchived',
                       SYSDATETIMEOFFSET(),
					   @TimeZoneId,
                       @OperationsPerformedBy
                FROM #TempUserStoryTable TUST

				IF(@IsFromSprint = 1)
				BEGIN
				   SELECT @SprintId
				END
				ELSE
				BEGIN
				   SELECT @GoalId
				END
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