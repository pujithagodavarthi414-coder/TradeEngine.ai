CREATE PROCEDURE [dbo].[Marker133]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Goal work items VS bugs count','SELECT G.GoalName as [Goal name],COUNT(1) [Work items count], (SELECT COUNT(1) FROM  UserStory US1 INNER JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug = 1
                        INNER JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL AND  US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
						INNER JOIN UserStory US2 ON  US2.Id =  US1.ParentUserStoryId AND US2.InActiveDateTime IS NULL AND US2.ParkedDateTime IS NULL AND G.Id = US2.GoalId
						)[Bugs count] ,G.Id 
						FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
         AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND GoalStatusId =''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL  AND P.CompanyId =''@CompanyId''  AND (''@ProjectId'' = '' '' OR P.Id = ''@ProjectId'') 
WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers] (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
OR (''@IsAll'' = 1)) GROUP BY G.GoalName,G.Id' ,@CompanyId)
    )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO


