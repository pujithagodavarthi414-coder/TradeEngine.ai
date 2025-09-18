CREATE PROCEDURE [dbo].[Marker154]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Training assignments due','This app provides the training assignment counts which are need to complete .Users can download the information in the app and can change the visualization of the app and they can filter data in the app', 
   N'SELECT COUNT(1) [Training assignments due]   
       FROM TrainingAssignment TA INNER JOIN AssignmentStatus ASS ON ASS.Id = TA.StatusId AND TA.IsActive = 1
       INNER JOIN TrainingCourse TC ON TC.Id = TA.TrainingCourseId AND (TC.IsArchived IS NULL OR TC.IsArchived = 0)
       INNER JOIN [User]U ON U.Id = TA.UserId AND U.InActiveDateTime IS NULL
       INNER JOIN Employee E ON E.UserId =U.Id AND E.InActiveDateTime IS NULL
       WHERE ASS.IsActive = 1 AND (ASS.IsDefaultStatus = 1 OR (IsSelectable = 1 AND AddsValidity = 0))
        AND ASS.CompanyId = ''@CompanyId''
		AND (''@UserId''   = '''' OR TA.UserId = ''@UserId'')
        AND ((@DateFrom IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) >= CAST(@DateFrom AS date))
        AND ((@DateTo IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) <= CAST(@DateTo AS date))))
       AND CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) >= CAST(GETDATE() AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
, (NEWID(), N'Training assignments over due','This app provides the training assignment counts which are deadline crossed and need to complete .Users can download the information in the app and can change the visualization of the app and they can filter data in the app', 
   N'SELECT COUNT(1) [Training assignments over due]   
      FROM TrainingAssignment TA INNER JOIN AssignmentStatus ASS ON ASS.Id = TA.StatusId AND TA.IsActive = 1
      INNER JOIN TrainingCourse TC ON TC.Id = TA.TrainingCourseId AND (TC.IsArchived IS NULL OR TC.IsArchived = 0)
      INNER JOIN [User]U ON U.Id = TA.UserId AND U.InActiveDateTime IS NULL
      INNER JOIN Employee E ON E.UserId =U.Id AND E.InActiveDateTime IS NULL
      WHERE ASS.IsActive = 1 AND (ASS.IsDefaultStatus = 1 OR (IsSelectable = 1 AND AddsValidity = 0))
      AND ASS.CompanyId =''@CompanyId''
	  AND (''@UserId''   = '''' OR TA.UserId = ''@UserId'')
	  AND ((@DateFrom IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) >= CAST(@DateFrom AS date))
      AND ((@DateTo IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) <= CAST(@DateTo AS date))))
      AND CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) < CAST(GETDATE() AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
)
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],
			    [Description] =  Source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

     MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Training assignments due'),'1','Training assignments due_kpi','kpi',NULL,NULL,'','Training assignments due',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Training assignments over due'),'1','TTraining assignments over due_kpi','kpi',NULL,NULL,'','Training assignments over due',GETDATE(),@UserId)
			)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);
	
UPDATE CustomWidgets SET WidgetQuery =' select  G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END) [P1 bugs count],
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END) [P3 bugs count] ,
					COUNT(US.Id) [Total count],G.Id     ,G.GoalName 
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id' WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId
		
		
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0, p1, p2)'),N'GoalName','nvarchar', NULL,NULL, @CompanyId,@UserId,GETDATE(),1)
 )
 AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[ColumnName] = Source.[ColumnName] AND Target.[CustomWidgetId] = Source.[CustomWidgetId]
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

	