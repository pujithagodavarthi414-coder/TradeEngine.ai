CREATE PROCEDURE [dbo].[Marker109]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
         
MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Spent time VS productive time','	 SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
		   WHERE UST.CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(Z.EstimatedTime,0)),0) as int) Productivity,UserId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))Z INNER JOIN UserStory US ON US.Id = Z.UserStoryId AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					        AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					  GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId)
,(NEWID(),'Planned work VS unplanned work employee wise','SELECT T.Id, T.EmployeeName [Employee name] ,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Unplanned work percent] 
		                        FROM     
							    (SELECT U.Id, U.FirstName +'' '' +U.SurName EmployeeName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) )TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND 
													 ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
													 OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                       INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
						                   WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T
',@CompanyId)
,(NEWID(),'Planned vs unplanned work percentage','SELECT CAST((Z.[Planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((Z.[Un planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Un planned work]  FROM
(SELECT ISNULL(SUM(CASE WHEN ((T.GoalId IS NOT NULL AND T.IsToBeTracked = 1) OR (T.SprintId IS NOT NULL)) THEN T.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN (T.GoalId IS NOT NULL  AND (ISNULL(T.IsToBeTracked,0) = 0 ))  THEN T.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(T.EstimatedTime),0)[Total work] FROM
		  (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST( DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST( DateTo  AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T)Z',@CompanyId)
    )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];
   
MERGE INTO [dbo].[CustomAppColumns] AS Target
    USING ( VALUES
      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Imminent deadline work items count'),'Imminent deadline work items count','int','SELECT Id FROM
                        (SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
                            AND US.OwnerUserId =  ''@OperationsPerformedBy'' AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                        	AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                        	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
                        	   AND USS.CompanyId = ''@CompanyId''
                        	INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
                        	LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                        	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
                        	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
                        	WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL 
      					AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
                        				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
                        				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL
      								  AND CAST(S.SprintEndDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)))	
                        				  GROUP BY US.Id)T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
      ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work VS unplanned work employee wise' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
      ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work VS unplanned work employee wise' AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
      INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
      LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
      LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
      LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
      LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
      WHERE    ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) 
      OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) 
       AND US.OwnerUserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
      ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work VS unplanned work employee wise' AND CompanyId = @CompanyId),'Planned work percent','decimal',' SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
      INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
      LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
      LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
      LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
      LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
      WHERE    US.OwnerUserId = ''##Id##'' AND 
      ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
      OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL))  ',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
      ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work VS unplanned work employee wise' AND CompanyId = @CompanyId),'Unplanned work percent','decimal','SELECT US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
      INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
       INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
       INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
       INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
       INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
       LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
       WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
        AND US.OwnerUserId =  ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
      ,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Planned work','decimal','SELECT T.Id FROM (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
      FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id				
      INNER JOIN Project P ON P.Id = US.ProjectId	
      AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
      AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 	
      LEFT JOIN Goal G ON G.Id = US.GoalId
      WHERE CAST(DateTo  AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
      AND   CAST( DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)	
      AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]	
      (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))				
      OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )			
      OR (''@IsAll'' = 1))		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T		
      WHERE ((T.GoalId IS NOT NULL AND T.IsToBeTracked = 1) OR (T.SprintId IS NOT NULL))',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
      ,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Un planned work','decimal','SELECT T.Id FROM		  (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId	
      FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id	
      INNER JOIN Project P ON P.Id = US.ProjectId	
      AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
      AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
      LEFT JOIN Goal G ON G.Id = US.GoalId
      WHERE CAST(DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
      AND   CAST(DateTo  AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
      AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]	
      (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
      OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )	
      OR (''@IsAll'' = 1))	
      GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T	
      WHERE (T.GoalId IS NOT NULL  AND (ISNULL(T.IsToBeTracked,0) = 0 ))	',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
      
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
              [Hidden] = SOURCE.[Hidden] WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);
	
UPDATE WorkspaceDashboards SET [Name] = 'Testrun details' WHERE  [Name] = 'Talko2  file uploads testrun details' 
AND CompanyId = @CompanyId AND CustomWidgetId IN (SELECT Id FROM  CustomWidgets WHERE  CustomWidgetName = 'Talko2  file uploads testrun details' AND CompanyId = @CompanyId)
UPDATE CustomWidgets SET CustomWidgetName = 'Testrun details' WHERE  CustomWidgetName = 'Talko2  file uploads testrun details' AND CompanyId = @CompanyId	

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'87ABB450-990F-4D24-94FC-739C1A664C7B', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]); 

MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
       (NEWID(), @CompanyId, N'DefaultLanguage','en', N'Default language for user', CAST(N'2019-09-04T11:37:09.943' AS DateTime), @UserId,1)
	   )
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsVisible] = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);

	DELETE FROM [dbo].[CompanySettings] WHERE [Key] = N'DefaultLanguage' AND CompanyId = @CompanyId

	MERGE INTO [dbo].[CompanySettings] AS TARGET
    USING( VALUES  (NEWID(), @CompanyId, N'DefaultLanguage','en', N'Default language for user', GETDATE(), @UserId,1)
        )
	AS SOURCE ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId], [IsVisible])
	ON TARGET.[Key] = SOURCE.[Key] AND TARGET.CompanyId = SOURCE.CompanyId 
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId], [IsVisible])  
    VALUES([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId], [IsVisible]);

END

