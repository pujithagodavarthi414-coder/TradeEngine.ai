-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-06-15 00:00:00.000'
-- Purpose      To Get the Adhoc User Stories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

-- EXEC [dbo].[USP_SearchAdhocUserStories] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@PageSize = 100
-- EXEC [dbo].[USP_SearchAdhocUserStories] @OperationsPerformedBy = '7eaa4593-746c-4d6e-a5c7-b2c6454ebe23',@PageSize = 100 ,@UserStoryId = '4FC9F5D1-5574-4D21-8160-24A32F815D31' 

CREATE PROCEDURE [dbo].[USP_SearchAdhocUserStories]
(
  @TeamMemberIdsXML XML = NULL,
  @PageSize INT = 10,
  @PageNumber INT = 1,
  @IsIncludeCompletedUserStories BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @UserStoryId UNIQUEIDENTIFIER =NULL,
  @SearchUserstoryTag NVARCHAR(250) = NULL,
  @IsParked BIT = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
          DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          IF (@HavePermission = '1')
          BEGIN
                IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
                IF(@IsIncludeCompletedUserStories IS NULL) SET @IsIncludeCompletedUserStories = 0
                IF(@UserStoryId IS NOT NULL) SET @IsIncludeCompletedUserStories = 1
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                IF(@SearchUserstoryTag = '') SET @SearchUserstoryTag = NULL
                IF(@SearchUserstoryTag IS NOT NULL) SET @SearchUserstoryTag = ('%' + @SearchUserstoryTag + '%') 
                CREATE TABLE #TeamMembers 
                (
                    UserId UNIQUEIDENTIFIER
                )
                DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT G.Id 
                                                    FROM Goal G
                                                         INNER JOIN Project P ON P.Id = G.ProjectId 
                                                                    AND P.ProjectName = 'Adhoc Project' AND P.CompanyId = @CompanyId
                                                     WHERE GoalName = 'Adhoc Goal')
                
				  DECLARE @InductionGoalId UNIQUEIDENTIFIER = (SELECT G.Id 
                                                    FROM Goal G
                                                         INNER JOIN Project P ON P.Id = G.ProjectId 
                                                                    AND P.ProjectName = 'Induction project' AND P.CompanyId = @CompanyId
                                                     WHERE GoalName = 'Induction Goal')

				   DECLARE @ExitGoalId UNIQUEIDENTIFIER = (SELECT G.Id 
                                                    FROM Goal G
                                                         INNER JOIN Project P ON P.Id = G.ProjectId 
                                                                    AND P.ProjectName = 'Exit project' AND P.CompanyId = @CompanyId
                                                     WHERE GoalName = 'Exit Goal')


                DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                       FROM CompanyModule CM 
                                                            INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId
                                                            INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '02CCA450-E08F-4871-9DA0-E6DA4285C382' --'View all adhoc works'
                                                                       AND CM.CompanyId = @CompanyId
                                                                       AND FM.InActiveDateTime IS NULL
                                                                       AND CM.InActiveDateTime IS NULL
                                                       GROUP BY FeatureId
                                                      ) --View all adhoc works

               DECLARE @HaveAdhocPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
               DECLARE @WorkFlowId UNIQUEIDENTIFIER = (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Adhoc Workflow' AND CompanyId = @CompanyId) 
               DECLARE @MaxOrder INT = (SELECT MAX([OrderId]) FROM [dbo].[WorkflowStatus] WHERE WorkflowId = @WorkFlowId AND InActiveDateTime IS NULL)
               DECLARE @UserStoryStatusId UNIQUEIDENTIFIER = (SELECT UserStoryStatusId FROM [dbo].[WorkflowStatus] WHERE OrderId = @MaxOrder AND WorkflowId = @WorkFlowId AND InActiveDateTime IS NULL)
               DECLARE @EnableStartStop BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%')
 
                IF(@HaveAdhocPermission = 0)
                BEGIN
                    
                    IF(@TeamMemberIdsXML IS NOT NULL)
                    BEGIN
                        INSERT INTO #TeamMembers(UserId)
                        SELECT TM.ChildId  
                        FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) TM
                             INNER JOIN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') AS Id
                                         FROM @TeamMemberIdsXML.nodes('/GenericListOfGuid/ListItems/guid') X(Y)) Temp ON TM.ChildId = Temp.Id
                    END
                    ELSE
                    BEGIN
                        
                        INSERT INTO #TeamMembers(UserId)
                        SELECT TM.ChildId  
                        FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) TM
                    END
                END
                ELSE
                BEGIN
                    
                    IF(@TeamMemberIdsXML IS NOT NULL)
                    BEGIN
                         INSERT INTO #TeamMembers(UserId)
                         SELECT U.Id FROM [dbo].[User] U
                         INNER JOIN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') AS Id
                                     FROM @TeamMemberIdsXML.nodes('/GenericListOfGuid/ListItems/guid') X(Y)) TM  
                                     ON TM.Id = U.Id
                         WHERE U.InActiveDateTime IS NULL AND U.IsActive = 1
                    END
                    ELSE
                    BEGIN
                        INSERT INTO #TeamMembers(UserId)
                        SELECT Id FROM [dbo].[User] U
                        WHERE U.InActiveDateTime IS NULL AND U.IsActive = 1
                    END
                END
                SELECT US.Id UserStoryId,
                     US.UserStoryName,
                     US.EstimatedTime,
                     US.DeadLineDate,
                     US.OwnerUserId,
                     US.ArchivedDateTime AS UserStoryArchivedDateTime,
                     US.ParkedDateTime AS UserStoryParkedDateTime,
                     US.DependencyUserId,
                     OU.FirstName +' '+ ISNULL(OU.SurName,'') AS OwnerName,
                     OU.ProfileImage AS DependencyProfileImage,
                     US.[Order],
                     US.UserStoryStatusId,
                     US.ActualDeadLineDate,
                     US.ArchivedDateTime,
                     US.BugPriorityId,
                     US.ParentUserStoryId,
                     US.UserStoryTypeId,
                     US.UserStoryPriorityId,
                     US.ProjectFeatureId,
                     US.ParkedDateTime,
                     US.UserStoryUniqueName,
                     US.CreatedDateTime,
                     US.[TimeStamp],
                     US.[Description],
                     US.WorkFlowId,
                     US.Tag,
                     USS.[Status] AS UserStoryStatusName,
                     USS.StatusHexValue As UserStoryStatusColor,
                     G.GoalUniqueName,
                     USS.TaskStatusId,
                     UST.IsFillForm,
                     US.CustomApplicationId,
					 US.FormId,
                     US.GenericFormSubmittedId,
                     US.WorkFlowTaskId,
                     UST.IsQaRequired,
                     UST.IsLogTimeRequired,
                     UST.UserStoryTypeName,
					 @EnableStartStop AS IsEnableStartStop,
                     UST.Color AS UserStoryTypeColor,
					 (select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) AutoLog,
					 (SELECT BreakType From UserStorySpentTime USPt  where USPt.UserStoryId = US.Id AND  USPt.UserId = @OperationsPerformedBy
								  AND TimeStamp = (SELECT Max(TimeStamp) From UserStorySpentTime where UserStoryId = US.Id AND UserId = @OperationsPerformedBy )
								  ) BreakType,
								    (select top(1)  CAST(USPt.StartTime AS DATETIME) StartTime from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy) StartTime,
									   (select top(1) CAST(USPt.EndTime AS datetime) EndTime  from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) EndTime,
					 1 AS IsAdhocUserStory
					 ,US.ReferenceId
					,US.ReferenceTypeId,
                     CASE WHEN US.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                     TotalCount = COUNT(1) OVER()
                FROM UserStory AS US
                     INNER JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
                     INNER JOIN Goal G ON US.GoalId = G.Id
                     LEFT JOIN [dbo].[User] OU  WITH (NOLOCK) ON OU.Id = US.OwnerUserId 
                               AND OU.InActiveDateTime IS NULL AND OU.CompanyId = @CompanyId
                     LEFT JOIN [dbo].[UserStoryType] UST WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
                WHERE US.GoalId in (@GoalId , @InductionGoalId , @ExitGoalId)
                      AND (US.OwnerUserId IS NULL OR (US.OwnerUserId IN (SELECT UserId FROM #TeamMembers)))
                      AND (US.Id = @UserStoryId OR (@UserStoryId IS NULL))
                      AND ((@IsIncludeCompletedUserStories = 0 AND US.UserStoryStatusId <> @UserStoryStatusId) OR (@IsIncludeCompletedUserStories = 1))
                      AND (@IsParked IS NULL OR (@IsParked = 0 AND US.ParkedDateTime IS NULL) OR (@IsParked = 1 AND US.ParkedDateTime IS NOT NULL))
                      AND (@IsArchived IS NULL OR (@IsArchived = 0 AND US.ArchivedDateTime IS NULL) OR (@IsArchived = 1 AND US.ArchivedDateTime IS NOT NULL))
                      AND (@SearchUserstoryTag IS NULL OR US.Tag LIKE @SearchUserstoryTag)
                ORDER BY US.UserStoryName ASC
                
                OFFSET ((@Pagenumber - 1) * @Pagesize) ROWS
                FETCH NEXT @Pagesize ROWS ONLY
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