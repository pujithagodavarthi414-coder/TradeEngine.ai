CREATE PROCEDURE [dbo].[Marker170]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  	UPDATE CustomWidgets SET WidgetQuery =' SELECT * FROM
(SELECT T.[Employee name],T.[Test cases created] [Test cases created],T.[TestCases updated count] [Test cases updated],T.ExecutedCases [Executed cases],
       CAST(T.ExecutionTime/(60*60.0) AS decimal(10,3)) [Execution time in hr],
       [Test cases created]*((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId = ''@CompanyId'')) [Test cases created time],
       [TestCases updated count]* ((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId = ''@CompanyId'' )) [Test cases updated time]
 FROM
(SELECT U.FirstName+'' ''+U.SurName [Employee name],(SELECT COUNT(1) FROM  TestCase TC 
                                   WHERE TC.CreatedByUserId = U.Id  AND TC.InActiveDateTime IS NULL AND (CAST(TC.CreatedDateTime AS DATE) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) AND CAST(TC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)))
 [Test cases created],
 [TestCases updated count] = (SELECT COUNT(1) FROM (SELECT TCH.TestCaseId   FROM TestCaseHistory TCH WHERE TCH.CreatedByUserId = U.Id  AND TCH.FieldName =''TestCaseUpdated''  AND (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                               AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date))
                               GROUP BY TCH.TestCaseId)T),
 ExecutionTime = ISNULL((SELECT SUM(ISNULL( Estimate,0)) FROM
              (SELECT TCH.TestCaseId,TCH.TestRunId,TCH.CreatedByUserId,TC.Estimate FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date)  AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS  date))
              AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId =  U.CompanyId)
              GROUP BY TCH.TestCaseId,TestRunId,TCH.CreatedByUserId,Estimate)T
               WHERE T.CreatedByUserId = U.Id),0),
ExecutedCases = ISNULL((SELECT COUNT(1) FROM
                (SELECT TestCaseId,TestRunId,CreatedByUserId FROM TestCaseHistory TCH WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                 AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)) AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId = U.CompanyId )
                GROUP BY TestCaseId,TestRunId,CreatedByUserId)T WHERE T.CreatedByUserId = U.Id GROUP BY T.CreatedByUserId),0)
FROM [User]U 
        WHERE   U.CompanyId =  ''@CompanyId'')T)Z 
			WHERE Z.[Test cases created] >0 OR Z.[Executed cases] > 0 OR Z.[Test cases updated] > 0' WHERE CompanyId = @CompanyId AND CustomWidgetName = 'QA created and executed test cases'

			
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Form details' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Form history' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Form observations' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Form submissions' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Form type' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Forms' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Forms' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Observation Types' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM Widget WHERE WIdgetName = 'Review Notifications' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
 )
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

END
GO

		