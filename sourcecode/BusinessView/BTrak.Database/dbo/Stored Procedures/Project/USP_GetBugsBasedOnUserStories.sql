-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get the Bugds based on userstories or goals by applying the different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBugsBasedOnUserStories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBugsBasedOnUserStories]
(
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @GoalId UNIQUEIDENTIFIER = NULL,
	@SprintId UNIQUEIDENTIFIER = NULL,
    @ScenarioId UNIQUEIDENTIFIER = NULL,
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
	@SectionId  UNIQUEIDENTIFIER = NULL,
    @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT = NULL,
	@IsSprintUserStories BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')
            BEGIN
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryId = NULL

		  
               IF(@ParentUserStoryId = '00000000-0000-0000-0000-000000000000') SET  @ParentUserStoryId = NULL
               
			   IF(@IsArchived IS NULL) SET @IsArchived = 0
               
			    SELECT US.Id AS UserStoryId,
                       US.UserStoryName,
                       US.GoalId,
					   US.SprintId,
					   US.UserStoryStatusId,
					   US.WorkflowId,
					   USSS.[Status],
					   USSS.StatusHexValue,
                       US.CreatedByUserId,
                       US.CreatedDateTime,
                       US.[TimeStamp],
                       US.ParentUserStoryId,
                       BP.PriorityName BugPriorityName,
                       BP.Color BugPriorityColor,
                       BP.[Description] BugPriorityDescription,
                       BP.Icon BugPriorityIcon,
					   US.TestCaseId,
					   US.OwnerUserId,
					   G.GoalStatusId,
					   S.SprintStartDate,
					   US.WorkflowId AS WorkFlowId,
					   S.IsReplan,
                       TotalCount = COUNT(1) OVER()
                  FROM [UserStory]US WITH (NOLOCK)  
				       INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND (@UserStoryId IS NULL OR US.ParentUserStoryId = @UserStoryId)  AND (@ScenarioId IS NULL OR US.TestCaseId = @ScenarioId)  AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL
					   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL AND USSS.TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
					   LEFT JOIN [Goal]G WITH(NOLOCK) ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					   LEFT JOIN [Sprints]S WITH(NOLOCK) ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
					   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL AND (@ScenarioId IS NULL OR TC.Id = @ScenarioId)
					   LEFT JOIN  TestSuiteSection TSS ON TSS.Id = Tc.SectionId AND TSS.InActiveDateTime IS NULL
					   LEFT JOIN  TestSuite TS1 ON TS1.Id = TSS.TestSuiteId AND TS1.InActiveDateTime IS NULL
					   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US.BugPriorityId AND BP.InactiveDateTime IS NULL
				       LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
				       LEFT JOIN [Goal]G1 WITH(NOLOCK) ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL 
					   LEFT JOIN [Sprints]S1 WITH(NOLOCK) ON S1.Id = US.SprintId AND S1.InActiveDateTime IS NULL
                       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US.TestCaseId AND USS.InActiveDateTime IS NULL
                  WHERE UST.CompanyId = @CompanyId  
                        AND (@UserStoryId IS NULL OR ((US.GoalId <> US1.GoalId AND US.GoalId IS NOT NULL AND @UserStoryId IS NOT NULL) OR (US.SprintId <> US1.SprintId AND US.SprintId IS NOT NULL AND @UserStoryId IS NOT NULL)))               
                        AND (@UserStoryId IS NULL OR US1.Id = @UserStoryId)
                        AND (@ParentUserStoryId IS NULL OR (US.ParentUserStoryId = @ParentUserStoryId))
						AND (@TestSuiteId IS NULL OR G1.TestSuiteId = @TestSuiteId)
						AND (@SectionId IS NULL OR US1.TestSuiteSectionId = @SectionId)
                        AND (@ScenarioId IS NULL OR US.TestCaseId = @ScenarioId)
                        --AND UST.IsBug = 1 
						--AND (USSS.IsVerified <> 1 OR  USSS.IsVerified IS NULL)
                        AND ((@IsArchived = 0 AND US.InActiveDateTime IS NULL)
                          OR  (@IsArchived = 1 AND US.InActiveDateTime IS NOT NULL))
                        AND (@IsSprintUserStories IS NULL OR (@IsSprintUserStories = 0 AND (G.Id <> G1.Id OR US.ParentUserStoryId IS NULL) AND @GoalId IS NULL OR US1.GoalId = @GoalId) OR (@IsSprintUserStories = 1 AND (S1.Id <> S.Id) AND @SprintId IS NULL OR US1.SprintId = @SprintId))  
						AND ((US.TestCaseId IS NULL OR (USS.TestCaseId IS NOT NULL AND TS1.Id IS NOT NULL)) OR @ScenarioId IS NOT NULL )      
                GROUP BY US.Id,US.UserStoryName,US.GoalId,US.SprintId,US.CreatedByUserId,US.CreatedDateTime,US.[TimeStamp],US.ParentUserStoryId,US.UserStoryTypeId,BP.PriorityName,BP.Color,
			          	BP.[Description],BP.Icon,US.UserStoryStatusId,USSS.[Status],USSS.StatusHexValue,US.TestCaseId,G.GoalStatusId,S.SprintStartDate,S.IsReplan,US.WorkflowId,US.OwnerUserId
				
				ORDER BY US.CreatedDateTime

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