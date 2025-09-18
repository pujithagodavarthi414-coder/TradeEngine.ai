---------------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2019-02-14 00:00:00.000' select * from Goal where originalId = '87ADF55E-C647-4C98-85BB-2C366A2584E3'
-- Purpose      To Get the Employee Presence By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_InsertGoalByTemplateId]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TemplateId = '28009E1D-EB84-41F0-9541-E10F054FE6C1'
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertGoalByTemplateId]
(
    @TemplateId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsFromTemplate BIT = NULL,
	@UserStorytags NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @ProjectId UNIQUEIDENTIFIER,@BoardTypeId UNIQUEIDENTIFIER,@GoalName NVARCHAR(800),@GoalShortName NVARCHAR(800) 
		
		SELECT @ProjectId = ProjectId,@BoardTypeId = BoardTypeId,@GoalName = TemplateName,@GoalShortName = TemplateName 
		FROM Templates WHERE Id = @TemplateId

        DECLARE @HavePermission NVARCHAR(250)
            =   (
                    SELECT [dbo].[Ufn_UserCanHaveAccess](   @OperationsPerformedBy,
                           (
                               SELECT OBJECT_NAME(@@PROCID)
                           )
                                                                     )
                )
				set @HavePermission = '1'
        IF (@HavePermission = '1')
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER
                =   (
                        SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                    )

			DECLARE @GoalId UNIQUEIDENTIFIER = NEWID()

            DECLARE @IsBugBoard INT = (
                                          SELECT IsBugBoard
                                          FROM BoardType
                                          WHERE Id = @BoardTypeId
                                                AND InActiveDateTime IS NULL
                                      )

             DECLARE @WorkflowId UNIQUEIDENTIFIER = (
                                                       SELECT WorkflowId
                                                       FROM [dbo].[BoardTypeWorkFlow]
                                                       where BoardTypeId = @BoardTypeId
                                                   )

            DECLARE @GoalNameCount INT = (
                                             SELECT COUNT(1)
                                             FROM Goal
                                             WHERE GoalName = @GoalName
                                                   And ProjectId = @ProjectId
                                                   AND InActiveDateTime IS NULL
                                         )
			
            IF(@GoalName = 'Adhoc Goal' OR @GoalShortName = 'Adhoc Goal')
			BEGIN
					
					RAISERROR('CreatingAdhocGoalIsNotPermitted',11,1)

            END
            ELSE
            BEGIN

                    DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

                    DECLARE @GoalStatusId UNIQUEIDENTIFIER
                        = (SELECT Id FROM GoalStatus WHERE GoalStatusName = 'Active')
                   
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
                                ON P.Id = G.ProjectId AND GoalUniqueName NOT IN ('Induction','Adhoc','Compliance','Exit')
                        WHERE P.CompanyId = @CompanyId

                        INSERT INTO [dbo].[Goal]
                        (
                            [Id],
                            [GoalName],
                            [GoalShortName],
                            [ProjectId],
                            [BoardTypeId],
                            [OnboardProcessDate],
                            [GoalResponsibleUserId],
                            [IsToBeTracked],
                            [IsProductiveBoard],
                            [GoalStatusId],
                            [CreatedDateTime],
                            [CreatedByUserId],
                            [GoalUniqueName],
							[IsApproved]
                        )
                        SELECT @GoalId,
                               @GoalName,
                               @GoalShortName,
                               @ProjectId,
                               @BoardTypeId,
                               @Currentdate,
                               @OperationsPerformedBy,
                               1,
                               0,
                               @GoalStatusId,
                               @Currentdate,
                               @OperationsPerformedBy,
                               ('G - ' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(100))),
							   1
                        
					IF(@GoalNameCount > 0)
					 BEGIN
					 	
					 	UPDATE Goal SET GoalName = GoalName + '-' + GoalUniqueName
					 	WHERE Id = @GoalId
					 
					 END

						INSERT INTO [dbo].[GoalWorkFlow](
                                                      [Id],
                                                      [GoalId],
                                                      [WorkflowId],
                                                      [CreatedDateTime],
                                                      [CreatedByUserId]
													  )
                                               SELECT NEWID(),
                                                      @GoalId,
                                                      @WorkFlowId,
                                                      @Currentdate,
                                                      @OperationsPerformedBy
						
						 UPDATE [Goal]
                    SET GoalStatusColor =
                        (
                            SELECT [dbo].[Ufn_GoalColour](@GoalId)
                        )
                    WHERE Id = @GoalId

                    DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE GoalId = @GoalId)
					DECLARE @UserId UNIQUEIDENTIFIER = NULL
					IF(@IsFromTemplate = 1)
					BEGIN
					   SET @UserId = NULL
					END
					ELSE
					BEGIN
					   SET @UserId = @OperationsPerformedBy
					END

					DECLARE @UserStoryStatusId UNIQUEIDENTIFIER = (SELECT WS.UserStoryStatusId 
																			FROM WorkflowStatus WS 
																				INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId AND WS.CanAdd = 1 AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL
																				INNER JOIN Templates T ON T.BoardTypeId = BTW.BoardTypeId AND T.Id = @TemplateId)
                    
                    DECLARE @UserStoryUniqueName TABLE
                    (
                      RowNumber INT
                      ,UserStoryId UNIQUEIDENTIFIER
                      ,UserStoryTypeId UNIQUEIDENTIFIER
                      ,ShortName NVARCHAR(250)
                    )
                    INSERT INTO @UserStoryUniqueName(RowNumber,UserStoryId,UserStoryTypeId,ShortName)
                    SELECT ROW_NUMBER() OVER(PARTITION BY UserStoryTypeId ORDER BY US.Id) ,US.Id,US.UserStoryTypeId,UST.ShortName
                    FROM UserStory US 
                    INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
                    WHERE TemplateId = @TemplateId AND UST.CompanyId = @CompanyId
                   
				   UPDATE @UserStoryUniqueName SET RowNumber = RowNumber + T.MaxNumber
				   FROM @UserStoryUniqueName UST
                        LEFT JOIN (SELECT MAX(CAST(SUBSTRING(UserStoryUniqueName,LEN(ShortName) + 2,LEN(UserStoryUniqueName)) AS INT)) MaxNumber ,UserStoryTypeId 
                                   FROM UserStory US
                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
                                   WHERE UserStoryUniqueName IS NOT NULL AND UserStoryTypeId = UserStoryTypeId
					               GROUP BY UserStoryTypeId) T ON T.UserStoryTypeId = UST.UserStoryTypeId

					INSERT INTO [dbo].[UserStory](
                                           [Id],
                                           [GoalId],
                                           [UserStoryName],
                                           [EstimatedTime],
                                           [DeadLineDate],
                                           [OwnerUserId],
										   [TestSuiteSectionId],
										   [TestCaseId],
                                           [DependencyUserId],
                                           [Order],
                                           [UserStoryStatusId],
                                           [ActualDeadLineDate],
                                           [ArchivedDateTime],
                                           [BugPriorityId],
                                           [UserStoryTypeId],
                                           [ParkedDateTime],
                                           [ProjectFeatureId],
                                           [UserStoryPriorityId],
                                           [ReviewerUserId],
                                           [ParentUserStoryId],
                                           [CreatedDateTime],
                                           [CreatedByUserId],
										   UserStoryUniqueName,
										   [InActiveDateTime],
										   [Description],
										   [IsForQa],
										   [VersionName],
                                           [CustomApplicationId],
                                           [TemplateId],
										   [Tag],
										   [ProjectId],
										   [WorkflowId]
                                           )
                                    SELECT NEWID(),
                                           @GoalId,
                                           UserStoryName,
                                           EstimatedTime,
                                           DeadLineDate,
                                           @UserId,
										   TestSuiteSectionId,
										   TestCaseId,
                                           DependencyUserId,
                                           [Order],
                                           @UserStoryStatusId,
                                           ISNULL(ActualDeadLineDate,DeadLineDate),
                                           ArchivedDateTime,
                                           BugPriorityId,
                                           US.UserStoryTypeId,
                                           ParkedDateTime,
                                           ProjectFeatureId,
                                           UserStoryPriorityId,
                                           ReviewerUserId,
                                           ParentUserStoryId,
                                           @Currentdate,
                                           @OperationsPerformedBy,
										   USUN.ShortName + '-' + CONVERT(NVARCHAR(15),USUN.RowNumber),
                                           InactiveDateTime,
										   [Description],
										   IsForQa,
										   VersionName,
                                           CustomApplicationId,
                                           NULL,
										   @UserStorytags,
										   @ProjectId,
										   @WorkFlowId
						        FROM UserStory US 
                                     INNER JOIN @UserStoryUniqueName USUN ON USUN.UserStoryId = US.Id
                                WHERE TemplateId = @TemplateId

                    SELECT Id
                    FROM [dbo].[Goal]
                    where Id = @GoalId
                    			
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
                               @GoalId,
                               'GeneratedAGoalFromTemplate',
                               '',
                               @GoalName,
                               'GeneratedAGoalFromTemplate',
                               @OperationsPerformedBy,
                               GETDATE()

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
