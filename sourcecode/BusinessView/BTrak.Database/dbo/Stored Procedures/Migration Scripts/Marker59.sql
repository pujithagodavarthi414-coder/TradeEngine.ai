CREATE PROCEDURE [dbo].[Marker59]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

  IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId AND IndustryId = '744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71'))
  BEGIN

		MERGE INTO [dbo].[RoleFeature] AS Target 
		USING ( VALUES 
				   (NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Consultant'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'HR Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'HR Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Software Trainee'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Analyst Developer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Goal Responsible Person'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Digital Sales Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Director'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Lead Generation Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Recruiter'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Hr Consultant'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Senior Software Engineer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Business Development Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Temp Grp'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Lead Developer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'QA'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Freelancer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Software Engineer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'COO'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				  ,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Business Analyst'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		)
		AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [RoleId] = Source.[RoleId],
				   [FeatureId] = Source.[FeatureId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET AND Source.[RoleId] IS NOT NULL THEN 
		INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
	
 END
	
		MERGE INTO [dbo].[CustomWidgets] AS Target 
		USING ( VALUES
(NEWID(),'Night late employees','','SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(@Date AS date) 
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z		 ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late people count','','SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST( @Date AS date) 
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z		 
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Afternoon late trend graph','','SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),@DateTo) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, @DateFrom, @DateTo)
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(@DateTo AS date) 
							   AND TS.[Date] >= CAST(@DateFrom  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Average Exit Time','','SELECT [Date],cast([Avg exit time] as time(0))[Avg exit time] FROM
	(SELECT TOP 100 PERCENT [Date] ,ISNULL(CAST(AVG(CAST(OutTime AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
	       AND TS.[Date] >= CAST(DATEADD(DAY,1,DATEADD(MONTH,-1,eomonth(GETDATE()))) AS date)
		   AND TS.[Date] <= CAST(eomonth(GETDATE()) AS date)
	 GROUP BY [Date])T',@CompanyId,@UserId,GETDATE())

	)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];	

END
GO