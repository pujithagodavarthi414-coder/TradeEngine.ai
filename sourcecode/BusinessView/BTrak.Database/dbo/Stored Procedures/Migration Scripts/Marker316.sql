CREATE PROCEDURE [dbo].[Marker316]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE [CustomAppColumns] 
SET SubQuery = N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	  
		 INNER JOIN (
		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,(Neutral + Productive + UnProductive) / 60000 AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTimeSummary AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) AND ''##MonthEnd##'' 	                              
   		 AND (''##UserId##'' = UA.UserId) 							
   		 ) T WHERE SpentTime > 480 	                  
   		) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
WHERE CompanyId = @CompanyId
AND [ColumnName] = N'TotalTimeInHr'
AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report')

UPDATE [CustomAppColumns] 
SET SubQuery = N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	  
		 INNER JOIN (
		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,(Neutral + Productive + UnProductive) / 60000 AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTimeSummary AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) AND ''##MonthEnd##'' 	                              
   		 AND (''##UserId##'' = UA.UserId) 							
   		 ) T WHERE SpentTime > 480 	                  
   		) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
WHERE CompanyId = @CompanyId
AND [ColumnName] = N'Name'
AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report')

UPDATE [CustomAppColumns] 
SET SubQuery = N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	  
		 INNER JOIN (
		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,(Neutral + Productive + UnProductive) / 60000 AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTimeSummary AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) AND ''##MonthEnd##'' 	                              
   		 AND (''##UserId##'' = UA.UserId) 							
   		 ) T WHERE SpentTime > 480 	                  
   		) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
WHERE CompanyId = @CompanyId
AND [ColumnName] = N'Month'
AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report')

MERGE INTO [dbo].[ActivityTrackerApplicationUrl] AS Target 
USING ( VALUES 
(NEWID(), N'8119B40C-834C-4721-80E0-0C8257C3E977', N'LockApp.exe', @UserId, CAST(N'2021-04-15 16:51:56.543' AS DateTime), @CompanyId, 0,NULL)
)
AS Source ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) 
ON Target.[ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId] 
    AND Target.[AppUrlName] = Source.[AppUrlName] AND Target.[CompanyId] = Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET 
		   [ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
		   [AppUrlName] = Source.[AppUrlName],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CompanyId] = Source.[CompanyId],
		   [IsProductive] = Source.[IsProductive]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) VALUES
	   ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]); 

DECLARE @UrlRoleCount INT = (SELECT TOP 1 COUNT(AUR.Id) FROM ActivityTrackerApplicationUrlRole AUR
JOIN [ActivityTrackerApplicationUrl] AU ON AU.Id = AUR.ActivityTrackerApplicationUrlId
WHERE AU.AppUrlName = N'LockApp.exe' AND AU.CompanyId = @CompanyId) 	

IF(@UrlRoleCount = 0)
BEGIN

	INSERT INTO ActivityTrackerApplicationUrlRole(Id,ActivityTrackerApplicationUrlId,RoleId,CompanyId,IsProductive,CreatedByUserId,CreatedByDateTime)
	SELECT NEWID(),A.Id AS ActivityTrackerApplicationUrlId,R.Id AS RoleId,@CompanyId AS CompanyId,0
			,@UserId AS CreatedByUserId,GETDATE() AS CreatedByDateTime
				FROM ActivityTrackerApplicationUrl AS A ,Role AS R 
			WHERE A.CompanyId = @CompanyId AND R.CompanyId = @CompanyId AND (R.IsHidden <> 1 OR R.IsHidden IS NULL OR R.IsHidden= 0)
			AND A.AppUrlName = N'LockApp.exe' END

END
GO
