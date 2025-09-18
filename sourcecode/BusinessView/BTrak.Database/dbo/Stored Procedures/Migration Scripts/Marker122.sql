CREATE PROCEDURE [dbo].[Marker122]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Goal work items VS bugs count','SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(G2.Id) [Bugs count] ,G.Id FROM UserStory US 
 INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
         AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '' '' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId =''@CompanyId''
LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL 
LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	                           								   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	                           								    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
	                           									OR (''@IsAll'' = 1)) GROUP BY G.GoalName,G.Id 
',@CompanyId)
, (NEWID(),'Goal wise spent time VS productive hrs list','SELECT T.Id,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,GoalName [Goal name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	                           								   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	                           								    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
	                           									OR (''@IsAll'' = 1)) 
								   GROUP BY GoalName,G.Id)T',@CompanyId)
,(NEWID(),'Active goals','  SELECT COUNT(1) [Active goals] FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
                               AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = ''''
                                OR P.Id = ''@ProjectId'') AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                               INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
							   WHERE GS.IsActive = 1 
                               AND P.CompanyId = ''@CompanyId''
                                AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                               	OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'')
                               	OR (''@IsAll'' = 1))
								AND ((ISNULL(BT.IsBugBoard,0) = 0) 
								OR ((SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = ''@CompanyId'' AND [key] like ''%EnableBugBoard%'') = 1 AND BT.IsBugBoard =1))
',@CompanyId)
,(NEWID(),'Goals vs Bugs count (p0,p1,p2)',' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
					COUNT(US.Id)TotalCount,G.Id     
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND g.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  g.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id',@CompanyId)
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Active goals'),N'Active goals','int', N'SELECT G.Id FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                        INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy'' 
						INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
WHERE GS.IsActive = 1 AND ((''@IsReportingOnly'' = 1 
AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') 
WHERE ChildId <>  ''@OperationsPerformedBy''))	OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'')	
OR (''@IsAll'' = 1))AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
AND ((ISNULL(BT.IsBugBoard,0) = 0) OR ((SELECT CAST([Value] as bit) FROM CompanySettings 
where CompanyId = ''@CompanyId'' AND [key] like ''%EnableBugBoard%'') = 1 AND BT.IsBugBoard =1))
GROUP BY G.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goals'), @CompanyId,@UserId,GETDATE(),NULL)

)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND Target.[ColumnType] = Source.[ColumnType]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
  WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);     				


END