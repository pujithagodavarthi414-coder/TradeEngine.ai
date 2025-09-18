CREATE PROCEDURE [dbo].[USP_GetProjectCustomReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	CREATE TABLE #Projects
	(
	ProjectId UNIQUEIDENTIFIER,
	[Pending Bugs] INT,
	[Total Bugs] INT,
	[Resolved bugs] INT
	)

	INSERT INTO #Projects(ProjectId,[Pending Bugs],[Total Bugs],[Resolved bugs])
	SELECT T.ProjectId,ISNULL([Pending Bugs],0),ISNULL([Total Bugs],0),ISNULL([Resolved bugs],0) FROM
	(SELECT DISTINCT ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)T 
	        LEFT JOIN (SELECT US.ProjectId,COUNT(CASE WHEN  USS.TaskStatusId NOT IN( 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D') THEN 1 END) [Pending Bugs] 
			                              ,COUNT(1) [Total Bugs]
										  ,COUNT(CASE WHEN  USS.TaskStatusId  = '5C561B7F-80CB-4822-BE18-C65560C15F5B' THEN 1 END)  [Resolved bugs]
			FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND UST.CompanyId = @CompanyId
            INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  
            LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
            LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE'
            WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL)
			GROUP BY US.ProjectId
			)Rinner ON  T.ProjectId = Rinner.ProjectId


SELECT  P.ProjectName [Project Name],ISNULL(U.FirstName,'')+' '+ISNULL(U.SurName,'') [Project Manager],
        FORMAT(CAST(P.ProjectStartDate AS DATE),'dd MMM yyyy')+IIF(TZ.TimeZoneAbbreviation IS NULL AND P.ProjectStartDate IS NULL,'',' '+TZ.TimeZoneAbbreviation) [Project Start date],
		FORMAT(CAST(P.ProjectEndDate AS DATE),'dd MMM yyyy')+IIF(TZ.TimeZoneAbbreviation IS NULL AND P.ProjectEndDate IS NULL,'',' '+TZ.TimeZoneAbbreviation) [Project End Date],
		(SELECT COUNT(1) FROM(SELECT UP.UserId FROM UserProject UP WHERE UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL GROUP BY UP.UserId)T) [Project Members]
       ,(SELECT COUNT(1) FROM Goal G WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE' AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL)[Active Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.InActiveDateTime IS NULL AND  S.ProjectId = P.Id AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0 AND ISNULL(S.IsComplete,0) = 0)[Active Sprints]
	   , CASE WHEN  EXISTS(SELECT Id  FROM Goal G WHERE G.ProjectId = P.Id AND G.GoalStatusCOlor =(SELECT HexaValue FROM ProcessDashboardStatus WHERE StatusName ='Serious issue. Need urgent attention ' AND CompanyId = @CompanyId) ) THEN (SELECT ShortName FROM ProcessDashboardStatus WHERE StatusName ='Serious issue. Need urgent attention ' AND CompanyId = @CompanyId)
		    WHEN EXISTS(SELECT Id  FROM Goal G WHERE G.ProjectId = P.Id AND G.GoalStatusCOlor =(SELECT HexaValue FROM ProcessDashboardStatus WHERE StatusName ='Waiting on dependencies' AND CompanyId = @CompanyId) ) THEN (SELECT ShortName FROM ProcessDashboardStatus WHERE StatusName ='Waiting on dependencies' AND CompanyId = @CompanyId) 
			ELSE (SELECT ShortName FROM ProcessDashboardStatus WHERE StatusName NOT IN ('Waiting on dependencies','Serious issue. Need urgent attention ') AND CompanyId = @CompanyId) END [Project Status]
       ,(SELECT COUNT(1) FROM Goal G WHERE Id IN (SELECT GoalId FROM UserStory US WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND P.Id = US.ProjectId AND ((ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS DATE) < CAST(GETDATE() AS date))) OR ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate  < GETDATE()))) AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL  AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE') [Delayed Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.ProjectId = P.Id AND CAST(S.SprintEndDate AS date) < CAST( GETDATE() AS date) ) [Delayed Sprints],
        (SELECT COUNT(1) FROM Goal G 
	               LEFT JOIN (SELECT US.GoalId, COUNT(1)Counts FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId AND US.ProjectId = P.Id  AND US.InActiveDateTime IS NULL AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
       									AND USS.TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
                                      GROUP BY US.GoalId)T ON G.Id = T.GoalId
									  WHERE T.GoalId IS NULL AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL) [Completed goals],
        (SELECT COUNT(1) FROM Sprints S  WHERE S.ProjectId = P.Id AND S.IsComplete = 1)[Completed Sprints],
         PP.[Total Bugs],
         PP.[Resolved bugs],
		 PP.[Pending Bugs],		
		 (SELECT  CAST(((SUM(CASE WHEN USS.TaskStatusId IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D') THEN US.EstimatedTime END)*1.0) / (CASE WHEN ISNULL(SUM(US.EstimatedTime),0) = 0 THEN 1 ELSE SUM(US.EstimatedTime)*1.0 END))*100 AS  decimal(10,2))
         FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.ProjectId = P.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL      
                           LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
						   WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL) AND US.ProjectId = P.Id)[Project Completion Percentage],dbo.Ufn_GetFilesCount(P.Id)  [Number Of Documents]

FROM Project P INNER JOIN [User] U ON U.Id = P.ProjectResponsiblePersonId AND P.InActiveDateTime IS NULL
               INNER JOIN #Projects PP ON PP.ProjectId = P.Id
			   LEFT JOIN TimeZone TZ ON TZ.Id = P.ProjectStartDateTimeZoneId
    WHERE P.CompanyId = @CompanyId


	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO