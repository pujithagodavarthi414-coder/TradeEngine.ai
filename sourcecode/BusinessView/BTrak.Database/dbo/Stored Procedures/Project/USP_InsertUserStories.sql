-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Save the UserStories
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertUserStories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId='C9C0B67F-3A5E-41DF-B3AE-01CC7F629EE4',
--@UserStoriesXml='<GenericListOfGuid><ListItems><guid>73095AE4-F3B1-450D-BFA2-9BCBDEC37DB6</guid><guid>73095AE4-F3B1-450D-BFA2-9BCBDEC37DB6</guid><guid>73095AE4-F3B1-450D-BFA2-9BCBDEC37DB6</guid></ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertUserStories]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @UserStoriesXml XML,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

          --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))
          DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          IF (@HavePermission = '1')
          BEGIN
             DECLARE @Currentdate DATETIMEOFFSET = SYSDATETIMEOFFSET()
             IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             DECLARE @UserStoryTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryType WHERE ShortName = 'Bug' AND InActiveDateTime IS NULL)
             DECLARE @Unique NVARCHAR(20) = (SELECT [dbo].[Ufn_GetUserStoryUniqueName]('16E881A4-9C6D-4021-AA2A-E84C05FB608A','4AFEB444-E826-4F95-AC41-2175E36A0C16'))
              
             DECLARE @Name Nvarchar(20) = (SELECT ShortName from UserStoryType where Id = @UserStoryTypeId AND CompanyId = @CompanyId)
              
             DECLARE @Number INT = (SELECT CAST((SUBSTRING(@Unique,LEN(@Name) + 2,len(@Unique))) AS INT) - 1)
             
             IF(@UserStoriesXml IS NOT NULL)
             BEGIN
                   CREATE TABLE #TempUserStoryTable 
                   (
                    RowNumber INT IDENTITY(1,1),
                    UserStoryId UNIQUEIDENTIFIER,
                    UserStoryName NVARCHAR(4000),
                    [Order] INT,
                    UniqueName INT,
                    EstimatedTime DECIMAL(10,2),
                    DeadLineDate DATETIMEOFFSET,
                    OwnerUserId  NVARCHAR(200),
                    DependencyUserId  NVARCHAR(200),
                    ProjectFeatureName  NVARCHAR(200),
                    ProjectFeatureId UNIQUEIDENTIFIER,
                    BugPriorityId  NVARCHAR(200),
                    BugPriorityName NVARCHAR(200),
                    BugCausedByUserId  NVARCHAR(200)
                   )
                    INSERT INTO #TempUserStoryTable(
                                [UserStoryId],
                                [UserStoryName],
                                [EstimatedTime],
                                [DeadLineDate],
                                [OwnerUserId],
                                [DependencyUserId],
                                [BugPriorityName],
                                [ProjectFeatureName],
                                [BugCausedByUserId])
                         SELECT NEWID(),
                                [TABLE].RECORD.value('(UserStoryName)[1]', 'nvarchar(4000)'),
                                Cast( [TABLE].RECORD.value('(ETime)[1]', 'Float')AS Float),
                                CASE WHEN  [TABLE].RECORD.value('(DeadLine)[1]','nvarchar(100)') = ' ' THEN NULL ELSE
                                CONVERT(datetimeoffset, [TABLE].RECORD.value('(DeadLine)[1]','nvarchar(100)'),105) END,
                                CASE WHEN [TABLE].RECORD.value('(OwnerUserId)[1]', 'nvarchar(200)') = ' ' THEN NULL ELSE 
                                [TABLE].RECORD.value('(OwnerUserId)[1]', 'nvarchar(200)') END,
                                CASE WHEN [TABLE].RECORD.value('(DependencyUserId)[1]', 'nvarchar(200)') = ' ' THEN NULL ELSE 
                                [TABLE].RECORD.value('(DependencyUserId)[1]', 'nvarchar(200)') END,
                                CASE WHEN [TABLE].RECORD.value('(BugPriority)[1]', 'nvarchar(200)') = ' ' THEN NULL ELSE 
                                [TABLE].RECORD.value('(BugPriority)[1]', 'nvarchar(200)') END,
                                CASE WHEN [TABLE].RECORD.value('(ProjectFeatureName)[1]', 'nvarchar(200)') = ' ' THEN NULL ELSE 
                                [TABLE].RECORD.value('(ProjectFeatureName)[1]', 'nvarchar(200)') END,
                                CASE WHEN [TABLE].RECORD.value('(BugCausedByUserId)[1]', 'nvarchar(200)') = ' ' THEN NULL ELSE 
                                [TABLE].RECORD.value('(BugCausedByUserId)[1]', 'nvarchar(200)') END
                                FROM @UserStoriesXml.nodes('GenericListOfUserStoryCsvInputModel/ListItems/UserStoryCsvInputModel') AS [TABLE](RECORD)
                    UPDATE #TempUserStoryTable SET ProjectFeatureId = PF.Id FROM ProjectFeature PF
                                                                                    JOIN #TempUserStoryTable TMP ON TMP.ProjectFeatureName = PF.ProjectFeatureName 
                                                                                    JOIN Project P ON P.Id = PF.ProjectId AND P.InActiveDateTime IS NULL
                                                                                    JOIN Goal G ON G.ProjectId = P.Id AND G.InActiveDateTime IS NULL
                                                                                    WHERE PF.InActiveDateTime IS NULL
                    DECLARE @MaxOrder INT = (SELECT ISNULL(MAX([Order]),0) FROM UserStory WHERE GoalId = @GoalId GROUP BY GoalId)
                    UPDATE #TempUserStoryTable SET UniqueName = @Number + RowNumber
                    UPDATE #TempUserStoryTable SET [Order] = @MaxOrder,@MaxOrder = @MaxOrder + 1
                    UPDATE #TempUserStoryTable SET [BugPriorityId] = BP.Id FROM BugPriority BP
                                                                                   JOIN #TempUserStoryTable TMP ON TMP.BugPriorityName = BP.PriorityName
                                                                                   WHERE BP.InActiveDateTime IS NULL

                    DECLARE @UserStoryIdsCount INT =  (SELECT COUNT (1) FROM #TempUserStoryTable)
                    DECLARE @UserStoryId UNIQUEIDENTIFIER 
                    DECLARE @UserStoryName NVARCHAR(800) = NULL
                    DECLARE @IsEligibleToUpdate BIT = 0 
                    WHILE(@UserStoryIdsCount >= 1)
                    BEGIN
                    SELECT @UserStoryId = UserStoryId ,@UserStoryName = UserStoryName
                    FROM #TempUserStoryTable WHERE RowNumber = @UserStoryIdsCount
                    DECLARE @UserstoryNameCount INT = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName AND GoalId = @GoalId AND ArchivedDateTime IS NULL AND (Id <> @UserStoryId OR @UserStoryId IS NULL))
                    IF(@UserstoryNameCount > 0)
                    BEGIN
                    
                        SET @IsEligibleToUpdate = 0
                        RAISERROR(50001,16,1,'UserStory')
                        BREAK
                    
                    END
                    ELSE
                    BEGIN
                    
                        SET @IsEligibleToUpdate = 1
                    
                    END
                    SET @UserStoryIdsCount = @UserStoryIdsCount - 1
                    END
                    IF(@IsEligibleToUpdate = 1)
                    BEGIN
                    DECLARE @Workflow  NVARCHAR(150)
                    SELECT @Workflow = Workflow from WorkFlow where Id = (SELECT WorkflowId from GoalWorkFlow where GoalId = @GoalId)
                    DECLARE @UserStoryStatusId UNIQUEIDENTIFIER = (SELECT WS.UserStoryStatusId 
                                                                   FROM WorkflowStatus WS 
                                                                        INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId 
                                                                        INNER JOIN Goal G ON G.BoardTypeId = BTW.BoardTypeId 
                                                                   WHERE G.Id = @GoalId AND WS.CanAdd = 1) -- AND WS.IsArchived =0
                    INSERT INTO [dbo].[UserStory](
                                [Id],
                                [GoalId],
                                [UserStoryName],
                                [EstimatedTime],
                                [DeadLineDate],
                                [OwnerUserId],
                                [DependencyUserId],
                                [Order],
                                [UserStoryStatusId],
                                [ActualDeadLineDate],
                                [BugPriorityId],
                                [UserStoryTypeId],
                                [ProjectFeatureId],
                                [CreatedDateTime],
                                [CreatedByUserId],
                                [UserStoryUniqueName])
                         SELECT TUST.UserStoryId,
                                @GoalId,
                                TUST.UserStoryName,
                                TUST.EstimatedTime,
                                TUST.DeadLineDate,
                                CONVERT(UNIQUEIDENTIFIER, TUST.OwnerUserId),
                                CONVERT(UNIQUEIDENTIFIER, TUST.DependencyUserId),
                                TUST.[Order],
                                @UserStoryStatusId,
                                TUST.DeadLineDate,
                                CONVERT(UNIQUEIDENTIFIER, TUST.BugPriorityId),
                                @UserStoryTypeId,
                                CONVERT(UNIQUEIDENTIFIER, TUST.ProjectFeatureId),
                                @Currentdate,
                                @OperationsPerformedBy,
                                @Name + '-' + CAST(UniqueName AS NVARCHAR(20))
                                FROM #TempUserStoryTable AS TUST
                    
					INSERT INTO [dbo].[BugCausedUser](
                                [Id],
                                [UserStoryId],
                                [UserId],
                                [CreatedDateTime],
                                [CreatedByUserId])
                         SELECT NEWID(),
                                TUST.UserStoryId,
                                TUST.BugCausedByUserId,
                                @Currentdate,
                                @OperationsPerformedBy
                                FROM #TempUserStoryTable AS TUST WHERE (TUST.BugCausedByUserId IS NOT NULL)

					INSERT INTO [dbo].[UserStoryHistory](
					                                     [Id],
												         [UserStoryId],
														 [FieldName],
												         [Description],
												         [CreatedDateTime],
												         [CreatedByUserId]
														)
										          SELECT NEWID(),
												         TUST.UserStoryId,
														 'UserStoryAdded',
														 'UserStoryAdded',
														 GETDATE(),
														 @OperationsPerformedBy
												         FROM #TempUserStoryTable TUST

                             SELECT @GoalId AS GoalId
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