CREATE PROCEDURE [dbo].[Marker284]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  
 MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES
     (NEWID(), N'Upcoming Interviews','This app provides the information about the upcoming job interviews.Users can download the information and change the visualization of the app.', 
	  ' SELECT JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],CIS.InterviewDate [Interview Date],
       ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name] FROM JobOpening JO
         INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id 
         INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId
       WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
		 AND CAST(CIS.InterviewDate AS date) > CAST(GETDATE() AS DATE)
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CIS.InterviewDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CIS.InterviewDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	    ,(NEWID(), N'Hired Candidates vs Job Openings','This app provides the information about the hired candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  ' SELECT JobOpeningTitle [Job Name],NoOfOpenings [No Of Openings],(SELECT COUNT(1) FROM CandidateJobOpening CJO JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId
					WHERE CJO.JobOpeningId= JO.Id AND HS.[Status]=''On boarding''
					AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.AppliedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.AppliedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
					AND   (''@CandidateId'' = '''' OR CJO.CandidateId = ''@CandidateId'')
					) [Hired Candidates] 
					FROM  JobOpening JO
					WHERE CompanyId = ''@CompanyId''', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
      ,(NEWID(), N'Candidate Conversion Count across Owners ','This app provides the count of candidates for each owner.Users can download the information and change the visualization of the app.',
	  'SELECT ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') AS Owner,COUNT(1) [Candidates Counts]  FROM [Candidate] C 
         INNER JOIN [User] U ON U.Id = C.AssignedToManagerId AND U.InActiveDateTime IS NULL
		 INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId = C.Id
		 JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND   HS.[Status]=''On boarding''
            WHERE U.CompanyId = ''@CompanyId''
	          AND (''@UserId'' = '''' OR C.AssignedToManagerId = ''@UserId'')
			  AND   ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
              AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date)))) 
         GROUP BY U.FirstName,U.SurName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Job Openings vs Associated Candidates','This app provides the information about the associated candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  'SELECT JO.JobOpeningTitle [Posting Title],HS.[Status] [Candidate Status For Job Opening],ISNULL(U.SurName,'''')+'' ''+ISNULL(U.FirstName,'''')[Associated By],
        ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],FORMAT(CJ.AppliedDateTime,''dd MMM yyyy'') AS [Associated Status Changed Time] FROM JobOpening JO
		 INNER JOIN [User] U ON U.Id = JO.HiringManagerId
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId
		 INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
        WHERE JO.CompanyId = ''@CompanyId''
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJ.AppliedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CJ.AppliedDateTime AS date) <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
   
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
 	      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Hired Candidates vs Job Openings'),'1','Hired Candidates vs Job Openings','column',NULL,NULL,'Job Name','No Of Openings,Hired Candidates',GETDATE(),@UserId)
 		  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidate Conversion Count Across Owners'),'1','Candidate Conversion Count Across Owners','stackedcolumn',NULL,NULL,'Owner','Candidates Counts',GETDATE(),@UserId)
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
  
  MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Age Of Job' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
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