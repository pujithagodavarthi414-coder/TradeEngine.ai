CREATE PROCEDURE [dbo].[USP_GetSprintCustomReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

SELECT S.SprintName [Sprint Name],P.ProjectName [Project Name],
FORMAT(CAST(S.SprintStartDate AS DATE),'dd MMM yyyy') [Sprint Start Date],
FORMAT(CAST(S.SprintEndDate AS DATE),'dd MMM yyyy') [Sprint End Date],U.FirstName+' '+U.SurName [Sprint Responsible Person],
(SELECT COUNT(1) FROM GoalReplan WHERE GoalId = S.Id)[Number Of Replans],
(SELECT COUNT(1) FROM  UserStory US WHERE US.SprintId = S.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL)[Total Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  AND US.SprintId = S.Id ) [Pending Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  AND US.SprintId = S.Id ) [Completed tasks],
CAST((SELECT (COUNT(CASE WHEN  USS.TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  THEN 1 END)
 *1.00 )/ CASE WHEN (COUNT(1))  = 0 THEN 1 ELSE (COUNT(1))*1.00 END 
FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id= US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND S.Id = US.SprintId
 ) AS DECIMAL(10,2)) * 100 [Sprint Completion Percentage],
 (SELECT COUNT(1) FROM UserStory US WHERE US.SprintId = S.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND CAST(S.SprintEndDate AS DATE) < CAST(GETDATE() AS DATE))[Delayed Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
WHERE US.SprintId = S.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND USS.TaskStatusId ='166DC7C2-2935-4A97-B630-406D53EB14BC' )[Blocked Tasks],
 (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId)[Total Bugs],
  (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId AND USS.TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'))[Resolved bugs],
   (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId AND USS.TaskStatusId  NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')) [Pending Bugs]
FROM Sprints S INNER JOIN Project P ON P.ID = S.ProjectId AND S.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL
                           AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
                                           LEFT JOIN [User]U ON U.Id = S.SprintResponsiblePersonId 
										   WHERE P.CompanyId = @CompanyId AND  S.SprintStartDate IS NOT NULL AND ISNULL(IsReplan,0) =0

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO