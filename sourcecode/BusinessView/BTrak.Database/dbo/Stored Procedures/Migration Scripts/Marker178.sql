CREATE PROCEDURE [dbo].[Marker178]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
   
 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Attendance report','This app provides the total leaves along with the dates for configured dates.Users can download the information in the app and can change the visualization of the app 
                 ', N'SELECT EmployeeNumber [Employeee ID],ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Employee Name],
  STUFF(
         (SELECT '', '' + convert(varchar(max), cast(T.[Date] as date))
          FROM [dbo].[Ufn_GetLeaveDatesOfAnUser](U.Id,NULL,NULL,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
		  CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date),NULL)t
      
          FOR XML PATH (''''))
          , 1, 1, '''')  AS date, 
		  (SELECT SUM(t.[Count]) FROM [dbo].[Ufn_GetLeaveDatesOfAnUser](U.Id,NULL,NULL,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
		  CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date),NULL)t) [Total Leaves Taken]
 FROM [User]U INNER JOIN Employee E ON E.UserId =  U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
              AND U.CompanyId =''@CompanyId''', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  , (NEWID(), 'Employees Overview Details','This app provides the all employees details like employee personal details,salary details,ESI details,,personal details and contact details.Users can download the information in the app and can change the visualization of the app 
    ', N'SELECT E.EmployeeNumber [Emp ID],CASE WHEN U.InActiveDateTime IS NOT NULL THEN ''Active'' ELSE ''InActive'' END [Status],
	G.Gender Sex,ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Name],D.DesignationName Designation,
  	B.BranchName [Location],STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''')	[Reporting Manager],
	U.RegisteredDateTime [Date of Join],E.DateofBirth [Date of Birth],MS.MaritalStatus [Marital status],CAST((DATEDIFF(MONTH,E.DateofBirth,GETDATE())*1.0)/12.0 AS decimal(10,1))	[Age],
	U.UserName [Official Email ID],ECD.OtherEmail [Personal Email ID],U.MobileNo [Contact Number],(SELECT top 1 EC.MobileNo FROM EmployeeEmergencyContact EC  WHERE IsEmergencyContact = 1 AND EC.InActiveDateTime IS NULL AND EC.EmployeeId= E.Id)	[Emergency Contact Number],	
	(SELECT TOP 1 ISNULL(EMC.FirstName,'''')+'' ''+ISNULL(EMC.LastName,'''') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = ''Father'' AND CompanyId = @CompanyId) AND InActiveDateTime IS NULL)[Father''''s Name],
(select SUM(CAST((DATEDIFF(MONTH,we.FromDate,WE.ToDate)*1.0)/12.0 AS decimal(10,1))) from  EmployeeWorkExperience WE where WE.EmployeeId = E.Id AND WE.InActiveDateTime IS NULL) [Total Experience on DOJ]
  ,ECD.Address1	[Permanent Address 1],ECD.Address2	[Permanent Address 2],S.StateName [Permanent Address 3], C.CountryName [Permanent Address 4],
  EAD.PFNumber [PF Number],EAD.UANNumber [UAN Number],EAD.ESINumber [ESI Number],BD.BankName [Bank Name],BD.AccountNumber [Bank Account] ,
  ER.ResignationDate [Date of Resignation] ,ER.CommentByEmployee [Reason For Exit]
FROM [User] U INNER JOIN Employee E ON E.USERId  = U.Id 
                       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeContactDetails ECD ON ECD.EmployeeId = E.Id AND ECD.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id AND EAD.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeDesignation ED ON ED.EmployeeId = E.Id AND (ED.[ActiveTo] IS NULL OR ED.[ActiveTo] >= GETDATE())
					   LEFT JOIN Designation D ON D.Id = ED.DesignationId AND D.InActiveDateTime IS NULL
					   LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					   LEFT JOIN MaritalStatus MS ON MS.Id = E.MaritalStatusId AND MS.InActiveDateTime IS NULL
					   LEFT JOIN Country C ON C.Id = ECD.CountryId AND C.InActiveDateTime IS NULL
					   LEFT JOIN  [State] S ON S.Id = ECD.StateId AND S.InActiveDateTime IS NULL
					   LEFT JOIN BankDetail BD ON BD.EmployeeId = E.Id AND BD.InActiveDateTime IS NULL AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id AND ER.InactiveDateTime IS NULL 
					   WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, GETDATE())
  , (NEWID(), 'Employees Details Project Wise','This app provides the all employees details like employee personal details,project details,salary details,ESI details,,personal details and contact details.Users can download the information in the app and can change the visualization of the app 
    ', N'
SELECT E.EmployeeNumber [Emp ID],CASE WHEN U.InActiveDateTime IS NOT NULL THEN ''Active'' ELSE ''InActive'' END [Status],
	   G.Gender Sex,ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Name],D.DesignationName Designation,P.ProjectName [Project Name],P.ProjectStartDate [Project Start date],P.ProjectEndDate [Project End date],
   DD.DepartmentName Division,B.BranchName [Location],STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id 
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''')	[Reporting Manager],
	U.RegisteredDateTime [Date of Join],E.DateofBirth [Date of Birth],MS.MaritalStatus [Marital status],CAST((DATEDIFF(MONTH,E.DateofBirth,GETDATE())*1.0)/12.0 AS decimal(10,1))	[Age],
	U.UserName [Email ID],ECD.OtherEmail [Personal Email ID],U.MobileNo [Contact Number],EEC.MobileNo	[Emergency Contact Number],	EEC.RelationShipName [Emergency number belongs to /relation with candidate],JC.JobCategoryType  Category,
	(SELECT TOP 1 ISNULL(EMC.FirstName,'''')+'' ''+ISNULL(EMC.LastName,'''') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = ''Father'' AND CompanyId = ''@CompanyId'') AND InActiveDateTime IS NULL)[Father''s Name],
			(SELECT TOP 1 ISNULL(EMC.FirstName,'''')+'' ''+ISNULL(EMC.LastName,'''') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = ''Mother'' AND CompanyId = ''@CompanyId'') AND InActiveDateTime IS NULL)[Mother''s Name],
			(SELECT TOP 1 ISNULL(EMC.FirstName,'''')+'' ''+ISNULL(EMC.LastName,'''') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = ''Spouse'' AND CompanyId = ''@CompanyId'') AND InActiveDateTime IS NULL)[Spouse Name],
(select SUM(CAST((DATEDIFF(MONTH,we.FromDate,WE.ToDate)*1.0)/12.0 AS decimal(10,1))) from  EmployeeWorkExperience WE where WE.EmployeeId = E.Id AND WE.InActiveDateTime IS NULL) [Total Experience on DOJ]
  ,ECD.Address1	[Permanent Address 1],ECD.Address2	[Permanent Address 2],S.StateName [Permanent Address 3], C.CountryName [Permanent Address 4],
  EAD.PFNumber [PF Number],EAD.UANNumber [UAN Number],EAD.ESINumber [ESI Number],BD.BankName [Bank Name],BD.AccountNumber [Bank Account] ,
  ER.ResignationDate [Date of Resignation] ,ER.CommentByEmployee [Reason For Exit], DATEDIFF(DAY,ER.ResignationDate,DATEADD(MONTH,J.NoticePeriodInMonths,ER.ResignationDate)) [Notice Period (in days)],
  STUFF((SELECT '','' + S.SkillName
                          FROM Skill S INNER JOIN EmployeeSkill ES  ON ES.EmployeeId =s.Id 
						  WHERE ES.EmployeeId = E.Id
                         FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') Skills
FROM [User] U INNER JOIN Employee E ON E.USERId  = U.Id 
                       INNER JOIN (SELECT UserId,UP.ProjectId FROM UserProject UP INNER JOIN [User] U ON U.Id = UP.UserId WHERE U.CompanyId = ''@CompanyId'' GROUP BY ProjectId,UserId)UPP ON UPP.UserId = U.Id
					   INNER JOIN Project P ON P.Id = UPP.ProjectId
                       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
	LEFT JOIN EmployeeContactDetails ECD ON ECD.EmployeeId = E.Id AND ECD.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id AND EAD.InActiveDateTime IS NULL
					   LEFT JOIN (SELECT top 1 EC.MobileNo,EmployeeId,RelationShipName FROM EmployeeEmergencyContact EC INNER JOIN RelationShip R ON R.Id = EC.RelationshipId AND R.InActiveDateTime IS NULL
					                                      WHERE IsEmergencyContact = 1 AND EC.InActiveDateTime IS NULL)EEC ON EEC.EmployeeId = E.Id
					   LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					   LEFT JOIN MaritalStatus MS ON MS.Id = E.MaritalStatusId AND MS.InActiveDateTime IS NULL
					   LEFT JOIN Country C ON C.Id = ECD.CountryId AND C.InActiveDateTime IS NULL
					   LEFT JOIN  [State] S ON S.Id = ECD.StateId AND S.InActiveDateTime IS NULL
					   LEFT JOIN BankDetail BD ON BD.EmployeeId = E.Id AND BD.InActiveDateTime IS NULL AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id AND ER.InactiveDateTime IS NULL 
					   LEFT JOIN Job J ON J.Id = E.Id AND J.InactiveDateTime IS NULL
					   LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InActiveDateTime IS NULL
					   LEFT JOIN Department DD ON DD.Id = J.DepartmentId AND DD.InActiveDateTime IS NULL
					    LEFT JOIN JobCategory JC ON JC.Id = J.JobCategoryId AND JC.InActiveDateTime IS NULL
					   WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, GETDATE())
  
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
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Attendance report'),'1','Attendance report_table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees Overview Details'),'1','Employees Overview Details_table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees Details Project Wise'),'1','Employees Details Project Wise_table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)	
		)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND  Target.[VisualizationName] = Source.[VisualizationName]
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

	MERGE INTO [dbo].[RelationShip] AS Target
	USING ( VALUES
	     (NEWID(), N'Spouse', CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,@CompanyId)    
	)
	AS Source ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [RelationShipName] = Source.[RelationShipName],
	         [CreatedDateTime] = Source.[CreatedDateTime],
	         [CreatedByUserId] = Source.[CreatedByUserId],
	         [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

END