CREATE PROCEDURE [dbo].[Marker70]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

    MERGE INTO [dbo].RateTagFor AS Target 
    USING (VALUES 
			(NEWID(), @CompanyId, N'Weekend',0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Remaining time',1, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId)
    )
    AS Source ([Id],[CompanyId],[RateTagForName],IsAllowance,[CreatedDateTime],[CreatedByUserId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET CompanyId = Source.CompanyId,
    	       [RateTagForName] = Source.[RateTagForName],
    		   [IsAllowance] = Source.[IsAllowance],
    	       [CreatedDateTime] = Source.[CreatedDateTime],
    		   [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id],[CompanyId],[RateTagForName],IsAllowance,[CreatedDateTime],[CreatedByUserId]) 
    VALUES ([Id],[CompanyId],[RateTagForName],IsAllowance,[CreatedDateTime],[CreatedByUserId]);

    MERGE INTO [dbo].[CompanySettings] AS TARGET
    USING( VALUES (NEWID(), @CompanyId, N'IsAuditEnable',N'0',N'Key for enable or disable Audit', GETDATE(), @UserId)
        )
	AS SOURCE ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON TARGET.[Key] = SOURCE.[Key] AND TARGET.CompanyId = SOURCE.CompanyId 
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])  
    VALUES([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);


	    MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employees with 0 keystrokes', N'This app provides the information of employee whose keystokes are 0', 'SELECT CONVERT(VARCHAR(5),DATEADD(MINUTE,DATEPART(TZ,TimeofUser),CONVERT(TIME,TimeofUser)),114) AS [Time],[Name],[Date],KeyStroke AS KeyStrokesCount 
          FROM (
          SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
          	   ,KeyStroke
          	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
          	   ,U.TimeZoneId
          	   ,TrackedDateTime
                 ,TrackedDateTime AT TIME ZONE CASE WHEN U.TimeZoneId IS NULL THEN ''India Standard Time'' ELSE TZ.TimeZoneName END AS TimeofUser
          FROM UserActivityTrackerStatus UAS
               INNER JOIN [User] U ON U.Id = UAS.UserId
          	 INNER JOIN Employee E ON E.UserId = U.Id
          	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
          	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
          WHERE KeyStroke = 0
                AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	    AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))
          ) T', @CompanyId, @UserId, GETDATE())
          ,(NEWID(), N'Employees with keystrokes more than 200', N'This app provides the information of employee whose keystokes are equal or more than 200', 'SELECT CONVERT(VARCHAR(5),DATEADD(MINUTE,DATEPART(TZ,TimeofUser),CONVERT(TIME,TimeofUser)),114) AS [Time],[Name],[Date],KeyStroke AS KeyStrokesCount 
           FROM (
           SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
           	   ,KeyStroke
           	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
           	   ,U.TimeZoneId
           	   ,TrackedDateTime
               ,TrackedDateTime AT TIME ZONE CASE WHEN U.TimeZoneId IS NULL THEN ''India Standard Time'' ELSE TZ.TimeZoneName END AS TimeofUser
           FROM UserActivityTrackerStatus UAS
                INNER JOIN [User] U ON U.Id = UAS.UserId
           	 INNER JOIN Employee E ON E.UserId = U.Id
           	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
           	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                  LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
           WHERE KeyStroke > 200
                 AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                 AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	    AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))
           ) T', @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime]);
            
        MERGE INTO [dbo].[CustomAppDetails] AS Target 
        USING ( VALUES 
        (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees with 0 keystrokes'),'1','Employees with 0 keystrokes_table','Table',GETDATE(),@UserId)
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees with keystrokes more than 200'),'1','Employees with keystrokes more than 200_table','Table',GETDATE(),@UserId)
        )
        AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId])
        ON Target.Id = Source.Id
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]) 
        VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]);
       
END
GO
