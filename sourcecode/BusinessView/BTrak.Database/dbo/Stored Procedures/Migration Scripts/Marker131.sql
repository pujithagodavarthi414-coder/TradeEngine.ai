CREATE PROCEDURE [dbo].[Marker131]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'QA created and executed test cases',' SELECT * FROM
(SELECT T.[Employee name],T.[Test cases created] [Test cases created],T.[TestCases updated count] [Test cases updated],T.ExecutedCases [Executed cases],
       CAST(T.ExecutionTime/(60*60.0) AS decimal(10,3)) [Execution time in hr],
       [Test cases created]*((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''))) [Test cases created time],
       [TestCases updated count]* ((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') )) [Test cases updated time]
 FROM
(SELECT U.FirstName+'' ''+U.SurName [Employee name],(SELECT COUNT(1) FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TS.Id = tss.TestSuiteId AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
                                   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
                                   WHERE TC.CreatedByUserId = U.Id AND (CAST(TC.CreatedDateTime AS DATE) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) AND CAST(TC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)))
 [Test cases created],
 [TestCases updated count] = (SELECT COUNT(1) FROM (SELECT TCH.TestCaseId   FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
                               AND TC.InActiveDateTime IS NULL AND TCH.FieldName =''TestCaseUpdated'' WHERE TCH.CreatedByUserId = U.Id AND (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                               AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date))
                               GROUP BY TCH.TestCaseId)T),
 ExecutionTime = ISNULL((SELECT SUM(ISNULL( Estimate,0)) FROM
              (SELECT TCH.TestCaseId,TCH.TestRunId,TCH.CreatedByUserId,TC.Estimate FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
               WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date)  AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS  date))
              AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId =  U.CompanyId)
              GROUP BY TCH.TestCaseId,TestRunId,TCH.CreatedByUserId,Estimate)T
               WHERE T.CreatedByUserId = U.Id),0),
ExecutedCases = ISNULL((SELECT COUNT(1) FROM
                (SELECT TestCaseId,TestRunId,CreatedByUserId FROM TestCaseHistory TCH WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                 AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)) AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId = U.CompanyId )
                GROUP BY TestCaseId,TestRunId,CreatedByUserId)T WHERE T.CreatedByUserId = U.Id GROUP BY T.CreatedByUserId),0)
FROM [User]U 
        WHERE   U.CompanyId =  ''@CompanyId'')T)Z 
			WHERE Z.[Test cases created] >0 OR Z.[Executed cases] > 0 OR Z.[Test cases updated] > 0',@CompanyId)
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

UPDATE WorkspaceDashboards SET [Name] = 'Version details' WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets 
WHERE CustomWidgetName = 'Milestone  details' AND CompanyId = @CompanyId) AND [Name] = 'Milestone  details'

UPDATE CustomWidgets SET CustomWidgetName = 'Version details' WHERE CustomWidgetName  ='Milestone  details'  AND CompanyId = @CompanyId

UPDATE CustomWidgets SET Description = 'This app provides the count of audits that should be conducted in the today and coming five days.Users can download the information in the app and can change the visualization of the app 
                and they can filter data in the app' WHERE CustomWidgetName ='Upcoming audits' AND CompanyId = @CompanyId


END