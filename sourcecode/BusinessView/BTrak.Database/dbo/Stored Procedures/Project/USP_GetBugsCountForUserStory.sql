-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-10-03 00:00:00.000'
-- Purpose      To Get the Count of Bugs for a userstory or goal
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCommentsCountByUserStoryId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBugsCountForUserStory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @SprintId UNIQUEIDENTIFIER = NULL,
  @TestCaseId  UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsSprintUserStories BIT = NULL
)
AS
BEGIN
    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   
	       
			SELECT COUNT(1) AS BugsCount
		    FROM  [dbo].[UserStory] US
		          INNER JOIN [dbo].[UserStory] US1 WITH (NOLOCK) ON US.Id = US1.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US1.[ParkedDateTime] IS NULL AND US1.[ArchivedDateTime] IS NULL
				  INNER JOIN [UserStoryType]UST WITH(NOLOCK) ON UST.Id = US1.UserStoryTypeId
				  INNER JOIN UserStoryStatus USS ON USS.Id = US1.UserStoryStatusId
				  INNER JOIN [TaskStatus] TST ON TST.Id = USS.TaskStatusId
				  LEFT JOIN [Goal]G WITH(NOLOCK) ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL 
				  LEFT JOIN [Goal]G1 ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL
				  LEFT JOIN [Sprints]S WITH(NOLOCK) ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
				  LEFT JOIN [Sprints]S1 WITH(NOLOCK) ON S1.Id = US.SprintId AND S1.InActiveDateTime IS NULL 
				  LEFT JOIN [UserStoryScenario]USSS ON USSS.TestCaseId = US1.TestCaseId AND USSS.InactiveDateTime IS NULL
				  LEFT JOIN [TestCase]TC ON TC.Id = US1.TestCaseId AND TC.InActiveDateTime IS NULL
				  LEFT JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
				  LEFT JOIN [TestSuite]TS ON TS.Id = TSS.TestSuiteId AND TSS.InActiveDateTime IS NULL
			WHERE UST.CompanyId = @CompanyId AND (US.GoalId <> US1.GoalId OR US1.SprintId <> US.SprintId)
			     --AND UST.IsBug = 1
                 --AND (USS.IsVerified <> 1 OR  USS.IsVerified IS NULL)
				 AND TST.[Order] NOT IN (4,6)
				 AND (@UserStoryId IS NULL OR  US.Id = @UserStoryId)
				 AND (@IsSprintUserStories IS NULL OR  (@IsSprintUserStories = 0 AND @GoalId IS NULL OR US.GoalId = @GoalId) OR (@IsSprintUserStories = 1 AND @SprintId IS NULL OR US.SprintId = @SprintId))
				 AND (@TestCaseId IS NULL OR US1.TestCaseId = @TestCaseId)
				 AND (@IsSprintUserStories IS NULL OR ((@IsSprintUserStories = 0 AND G1.ParkedDateTime IS NULL AND (G.Id <> G1.Id)) OR (@IsSprintUserStories = 1 AND S1.InActiveDateTime IS NULL AND (S.Id <> S1.Id))))
				 AND (US1.TestCaseId IS NULL OR (USSS.TestCaseId IS NOT NULL AND TS.Id IS NOT NULL))

	END
	ELSE
	BEGIN

		RAISERROR(50008,11,1)

	END
	 END TRY  
	 BEGIN CATCH 
		
		     THROW

	 END CATCH

END
GO