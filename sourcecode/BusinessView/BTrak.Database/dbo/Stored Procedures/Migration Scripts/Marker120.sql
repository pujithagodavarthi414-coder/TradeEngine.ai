CREATE PROCEDURE [dbo].[Marker120]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'Goal wise spent time VS productive hrs list','SELECT T.Id,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,GoalName [Goal name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
								   GROUP BY GoalName,G.Id)T',@CompanyId)

  )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

DELETE CustomAppColumns WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Estimated time','varchar','SELECT US.Id FROM UserStory US 
								   WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.GoalId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Spent time','varchar','SELECT US.Id FROM UserStory US INNER JOIN UserStorySpentTime UST ON US.Id = UST.UserStoryId 
WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.GoalId = ''##Id##''
GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
, (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Goal name','nvarchar','SELECT Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
, (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND RTRIM(Target.[ColumnType]) = RTRIM(Source.[ColumnType])
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


