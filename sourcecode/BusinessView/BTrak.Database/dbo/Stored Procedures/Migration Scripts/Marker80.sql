CREATE PROCEDURE [dbo].[Marker80]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

IF(@StoreId IS NOT NULL)
BEGIN

MERGE INTO [dbo].[Folder] AS Target 
USING ( VALUES
        (NEWID(), N'Payroll management', NULL ,CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId, @StoreId, NULL)
) 
AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [FolderName] = Source.[FolderName],
           [ParentFolderId] = Source.[ParentFolderId],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [StoreId] = Source.[StoreId],
		   [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);


MERGE INTO [dbo].[Folder] AS Target 
USING ( VALUES
		(NEWID(), N'Tax allowance proofs',(SELECT TOP(1) Id FROM Folder WHERE Foldername =  N'Payroll management' AND StoreId = @StoreId),CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId, @StoreId, NULL)        		
) 
AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [FolderName] = Source.[FolderName],
           [ParentFolderId] = Source.[ParentFolderId],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [StoreId] = Source.[StoreId],
		   [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);

END 


MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
      (NEWID(),'Goal work items VS bugs count','SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL))
															    AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
                									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
                										OR (''@IsAll'' = 1))
														GROUP BY G.GoalName',@CompanyId)
,(NEWID(),'Goals not ontrack','SELECT  COUNT(1)[Goals not ontrack] FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
AND GoalStatusColor= (SELECT HexaValue FROM ProcessDashboardStatus WHERE StatusName = ''Serious issue. Need urgent attention '' AND CompanyId = ''@CompanyId'')
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
AND P.CompanyId = ''@CompanyId''
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
	OR (''@IsAll'' = 1)))T ',@CompanyId)

                  	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];


MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Goal name', 'nvarchar','SELECT  Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Work items count', 'int', 'SELECT US.Id  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsUserStory = 1
INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.Id = ''##Id##''
GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Bugs count', 'int', 'SELECT US1.Id  FROM UserStory US
INNER JOIN Project P ON P.Id = US.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL 
AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
inner JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
inner JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug= 1
inner JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL	
WHERE US.GoalId = ''##Id##''
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goals not ontrack'),'Goals not ontrack','int',' select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
AND GoalStatusColor= (SELECT HexaValue FROM ProcessDashboardStatus WHERE StatusName = ''Serious issue. Need urgent attention '' AND CompanyId = ''@CompanyId'')
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
AND P.CompanyId = ''@CompanyId''
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
	OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goals'),@CompanyId,@UserId,GETDATE(),NULL)

	)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
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
		             
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Planned work','decimal','SELECT T.Id FROM (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id =  ''@OperationsPerformedBy'' ) AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id = ''@OperationsPerformedBy'') AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T
		  WHERE ((T.GoalId IS NOT NULL AND T.IsToBeTracked = 1) OR (T.SprintId IS NOT NULL))',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Un planned work','decimal','SELECT T.Id FROM
		  (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id =  ''@OperationsPerformedBy'' ) AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id = ''@OperationsPerformedBy'') AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T
		  WHERE (T.GoalId IS NOT NULL  AND (ISNULL(T.IsToBeTracked,0) = 0 ))	',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
 ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
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