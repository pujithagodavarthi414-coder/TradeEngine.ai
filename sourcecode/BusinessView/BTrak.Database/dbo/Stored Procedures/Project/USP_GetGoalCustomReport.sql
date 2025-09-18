CREATE PROCEDURE [dbo].[USP_GetGoalCustomReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

SELECT G.GoalName [Goal Name],P.ProjectName [Project Name],
    FORMAT(CAST(G.OnboardProcessDate AS DATE),'dd MMM yyyy')+IIF(OnboardProcessDate IS  NULL AND TZ.TimeZoneAbbreviation IS NULL ,'',' '+TZ.TimeZoneAbbreviation) [Goal Start Date],
	FORMAT(CAST((SELECT MAX(US.DeadLineDate) FROM UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL) AS DATE),'dd MMM yyyy') [Goal End date],
	U.FirstName+' '+U.SurName [Goal Responsible Person],
	 CASE WHEN  EXISTS(SELECT HexaValue FROM PROCESSDASHBOARDSTATUS WHERE StatusName ='Serious issue. Need urgent attention ' and G.GoalStatusCOlor = HexaValue AND CompanyId = @CompanyId)  THEN 'Serious issue. Need urgent attention '
		    WHEN EXISTS(SELECT HexaValue FROM PROCESSDASHBOARDSTATUS WHERE StatusName ='Waiting on dependencies' AND CompanyId = @CompanyId and G.GoalStatusCOlor = HexaValue) THEN 'Waiting on dependencies'  ELSE 'Everything is absolutely spot on' END [Goal Status],
(SELECT COUNT(1) FROM GoalReplan  WHERE GoalId = G.Id AND InActiveDateTime IS NULL)[Number Of Replans],
(SELECT COUNT(1) FROM  UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL)[Total Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  AND US.GoalId = G.Id ) [Pending Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  AND US.GoalId = G.Id ) [Completed tasks],
 (CAST((SELECT (ISNULL(COUNT(CASE WHEN  USS.TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  THEN 1 END),0)
 *1.00 )/ CASE WHEN (COUNT(1)) = 0 THEN 1 ELSE COUNT(1) END  *1.00  
FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id= US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
 WHERE US.GoalId = G.Id) AS decimal(10,2)))* 100 [Goal Completion Percentage],
 (SELECT COUNT(1) FROM UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate < GETDATE()) OR (ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date))))[Delayed Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
WHERE US.GoalId = G.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND USS.TaskStatusId ='166DC7C2-2935-4A97-B630-406D53EB14BC' )[Blocked Tasks],
 (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN Goal S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND S2.ParkedDateTime IS NULL AND S2.GoalStatusId ='7A79AB9F-D6F0-40A0-A191-CED6C06656DE' 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId)[Total Bugs],
  (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Goal S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND S2.ParkedDateTime IS NULL AND S2.GoalStatusId ='7A79AB9F-D6F0-40A0-A191-CED6C06656DE' 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId AND USS.TaskStatusId  IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'))[Resolved bugs],
   (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Goal S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND S2.ParkedDateTime IS NULL AND S2.GoalStatusId ='7A79AB9F-D6F0-40A0-A191-CED6C06656DE' 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId AND USS.TaskStatusId  NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')) [Pending Bugs]
FROM Goal G INNER JOIN Project P ON P.ID = G.ProjectId AND G.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
                                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
                                           LEFT JOIN [User]U ON U.Id = G.GoalResponsibleUserId 
										   LEFT JOIN TimeZone TZ ON TZ.Id = G.OnboardProcessDateTimeZoneId 
										   WHERE P.CompanyId = @CompanyId AND G.GoalStatusId =  '7A79AB9F-D6F0-40A0-A191-CED6C06656DE'


	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO