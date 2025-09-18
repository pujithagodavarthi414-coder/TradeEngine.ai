CREATE PROCEDURE [dbo].[Marker255]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES
	(NEWID(),N'By using this app user can see all the  Job opening status for the site,can add Job opening status and edit the Job opening status.Also users can view the archived Job opening status and can search and sort the Job opening status from the list.', N'Job opening status', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	,(NEWID(),N'By using this app user can see all the  Hiring status for the site,can add Hiring status and edit the Hiring status.Also users can view the archived Hiring status and can search and sort the Hiring status from the list.', N'Hiring status', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	,(NEWID(),N'By using this app user can see all the  Sources for the site,can add Sources and edit the Sources.Also users can view the archived Sources and can search and sort the Sources from the list.', N'Sources', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	,(NEWID(),N'By using this app user can see all the  Interview types for the site,can add Interview types and edit the Interview types.Also users can view the archived Interview types and can search and sort the Interview types from the list.', N'Interview types', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	,(NEWID(),N'By using this app user can see all the  Interview ratings for the site,can add Interview ratings and edit the Interview ratings.Also users can view the archived Interview ratings and can search and sort the Interview ratings from the list.', N'Interview ratings', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	,(NEWID(),N'By using this app user can see all the  Document type for the site,can add Document type and edit the Document type.Also users can view the archived Document type and can search and sort the Document type from the list.', N'Document type', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] =  Source.[CompanyId],
			   [Description] =  Source.[Description],
			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
			   [UpdatedByUserId] =  Source.[UpdatedByUserId],
			   [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Job opening status' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Hiring status' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Sources' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Interview types' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Interview ratings' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Document type' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
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

MERGE INTO [dbo].[JobOpeningStatus] AS Target 
USING (VALUES 
(NEWID(),'Draft','1',@CompanyId, @UserId,GETDATE())
,(NEWID(),'Active','2',@CompanyId, @UserId,GETDATE())
,(NEWID(),'Closed','3',@CompanyId, @UserId,GETDATE())
)
AS Source ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Status] = Source.[Status] AND Target.[Status] IS NOT NULL AND Target.[CompanyId]=Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET
		   [Status] = Source.[Status],
		   [Order] = Source.[Order],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

MERGE INTO [dbo].[HiringStatus] AS Target 
	USING (VALUES 
	(NEWID(),'New','#33BBFF','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Being interviewed','#33FFFF','2',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Selected','#33FFC4','3',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'On hold','#FFC733','4',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Candidate - rejected','#ff3333','5',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Recruiter - rejected','#ff3333','6',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Offered','#36E801','7',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Offer rejected','#ff3333','8',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'On boarding','#33FFC4','9',@CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Status] = Source.[Status]  AND Target.[Status] IS NOT NULL AND Target.[CompanyId]=Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET
		   [Status] = Source.[Status],
		   [Color] = Source.[Color],
		   [Order] = Source.[Order],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]);

MERGE INTO [dbo].[Source] AS Target 
	USING (VALUES 
	(NEWID(),'Added by User','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Career Site','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Employee Referral','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'External Referral','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Facebook','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Twitter','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Search Engine','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Naukari','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Linked In','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Walk In','0',@CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Name] = Source.[Name]  AND Target.[Name] IS NOT NULL AND Target.[CompanyId]=Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET
		   [Name] = Source.[Name],
		   [IsReferenceNumberNeeded] = Source.[IsReferenceNumberNeeded],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewType] AS Target 
--	USING (VALUES 
--	(NEWID(),'Basic','#01D3E8',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Group Discussion','#FCC819',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Technical','#F5FC19',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Final-HR','#19FC1C',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[InterviewTypeName] = Source.[InterviewTypeName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [InterviewTypeName] = Source.[InterviewTypeName],
--		   [Color] = Source.[Color],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewRating] AS Target 
--	USING (VALUES 
--	(NEWID(),'Average','50',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Good','75',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Excellent','100',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Not Eligible','35',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[InterviewRatingName] = Source.[InterviewRatingName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [InterviewRatingName] = Source.[InterviewRatingName],
--		   [Value] = Source.[Value],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	


--MERGE INTO [dbo].[DocumentType] AS Target 
--	USING (VALUES 
--	(NEWID(),'SSC',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Intermediate',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'B.Tech',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'M.Tech',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'M.B.A',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[DocumentTypeName] = Source.[DocumentTypeName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [DocumentTypeName] = Source.[DocumentTypeName],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewTypeRoleCofiguration] AS Target 
--	USING (VALUES 
--	(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='Software Engineer'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Basic'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='HR'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Group Discussion'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='Software Engineer'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Technical'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='HR'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Final-HR'),@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [RoleId], [InterviewTypeId],
--	--[CompanyId], 
--	[CreatedByUserId],[CreatedDateTime])
--ON Target.Id = Source.Id 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [RoleId] = Source.[RoleId],
--		   [InterviewTypeId] = Source.[InterviewTypeId],
--		   --[CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [RoleId], [InterviewTypeId], 
----[CompanyId],
--[CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [RoleId], [InterviewTypeId], 
----[CompanyId], 
--[CreatedByUserId],[CreatedDateTime]);	

--ALTER TABLE InterviewType
--ADD IsVideoCalling BIT NULL;
--ALTER TABLE InterviewType
--ADD IsPhoneCalling BIT NULL;

MERGE INTO [dbo].[JobType] AS Target 
	USING (VALUES 
	(NEWID(),'Marketing',@UserId,GETDATE(),@companyId)
	,(NEWID(),'HR',@UserId,GETDATE(),@companyId)
	,(NEWID(),'Developer',@UserId,GETDATE(),@companyId)
	)
	AS Source ([Id], [JobTypeName], [CreatedByUserId],[CreatedDateTime],[CompanyId])
ON Target.[JobTypeName] = Source.[JobTypeName] AND Target.[JobTypeName] IS NOT NULL AND Source.[JobTypeName] IS NOT NULL AND Target.[CompanyId] = Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET
		   [JobTypeName] = Source.[JobTypeName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[JobTypeName] IS NOT NULL THEN 
INSERT ([Id], [JobTypeName], [CreatedByUserId],[CreatedDateTime],[CompanyId]) VALUES ([Id], [JobTypeName], [CreatedByUserId],[CreatedDateTime],[CompanyId]);	

 MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
 (NEWID(),45,'Recruitment',NULL,@CompanyId,@UserId,GETDATE())
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.[TagName] = Source.[TagName] AND  Target.[CompanyId] = Source.[CompanyId]
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
		   [CompanyId] = Source.[CompanyId],	
		   [ParentTagId] = Source.[ParentTagId],	
		   [Order] = Source.[Order],	
		   [CreatedDateTime] = Source.[CreatedDateTime],	
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);	

MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
(NEWID(),46,'Recruitment Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Recruitment' ),@CompanyId,@UserId,GETDATE())
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.[TagName] = Source.[TagName] AND  Target.[CompanyId] = Source.[CompanyId]
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
		   [CompanyId] = Source.[CompanyId],	
		   [ParentTagId] = Source.[ParentTagId],	
		   [Order] = Source.[Order],	
		   [CreatedDateTime] = Source.[CreatedDateTime],	
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);	

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
    (NEWID(), N'Job Openings By Type','This app provides the job opening counts for each each job opening type. User can download the information', N' SELECT ES.EmploymentStatusName [Job Type Name],COUNT(1) [Job Opening Counts]  FROM JobOpening JO INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JOS.[Order]  IN (1,2) 
                                      AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
									  INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
									  WHERE JOS.CompanyId = ''@CompanyId''
									   AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                       AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
									  GROUP BY ES.EmploymentStatusName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
   ,(NEWID(), N'Candidates By Status','This app provides the count of candidates for each hiring status. User can download the information',
   'SELECT HS.[Status],COUNT(1) [Candidates Counts]  FROM [Candidate] C INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL 
                            INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
							WHERE HS.CompanyId = ''@CompanyId''
							    AND (''@HiringStatusId'' = '''' OR C.HiringStatusId = ''@HiringStatusId'')
							    AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY HS.[Status]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
   ,(NEWID(), N'Candidates By Ownership','This app provides the count of count of candidates for each assigned owner', N'SELECT U.FirstName+'' ''+U.SurName [Candidate Owner] ,COUNT(1) [Ownership Counts]  FROM [Candidate] C INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL 
                          INNER JOIN [USER]U ON U.Id  = C.AssignedToManagerId
							WHERE U.CompanyId = ''@CompanyId''
							  AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
							 AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY U.FirstName+'' ''+U.SurName ', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Age Of Job','This app provides the information about age of job', N'SELECT JO.JobOpeningTitle [Job Opening],NoOfOpenings [No Of Positions],
       CASE WHEN DATEDIFF(DAY,JO.DateFrom,GETDATE()) > =0 THEN DATEDIFF(DAY,JO.DateFrom,GETDATE()) ELSE 0 END [Age Of Job],
       CASE WHEN DATEDIFF(DAY,JO.DateTo,GETDATE()) >= 0 THEN DATEDIFF(DAY,JO.DateTo,GETDATE()) ELSE 0 END [Dalay]
        FROM JobOpening JO INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
                            WHERE JO.CompanyId = ''@CompanyId''
							      AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
							      AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                  AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
	,(NEWID(), N'Candidates By Source','This app provides the count of candidates for each source.Users can download the information and change the visualization of the app.', 
	  'SELECT S.[Name] AS Source,COUNT(1) [Candidate Counts]  FROM [Candidate] C 
       INNER JOIN [Source] S ON S.Id = C.SourceId AND S.InActiveDateTime IS NULL
       WHERE S.CompanyId = ''@CompanyId''
       AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
       AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))      
       GROUP BY S.[Name]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Job Openings Status Wise Report','This app provides the count of job openings for each job opening status.Users can download the information and change the visualization of the app.', 
	  'SELECT [Status] [Job Opening Status],COUNT(1) [Job Opening Counts] FROM JobOpening JO 
      INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
      WHERE JOS.CompanyId = ''@CompanyId''
	  AND (''@JobOpeningStatusId'' = '' OR JO.JobOpeningStatusId = ''@JobOpeningStatusId'')
	  AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
      AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
	  GROUP BY [Status] ', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'My Job Openings','This app provides the information about the job openings that are assigned to the logged in user.Users can download the information and change the visualization of the app.', 
	  'SELECT JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],U1.FirstName+'' ''+U1.SurName [Modified By],FORMAT(DateTo,''dd MMM yyyy'') [Target Date],JOS.[Status] [Job Opening Status],
MinExperience [Min Experience],MaxExperience [Max Experience],MinSalary [Min Salary],MaxSalary [Max Salary]
FROM JobOpening JO INNER JOIN [User]U ON JO.HiringManagerId = U.Id AND U.InActiveDateTime IS NULL AND JO.InActiveDateTime IS NULL
                            INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId 
                            LEFT JOIN [User] U1 ON U1.Id = JO.CreatedByUserId 
							WHERE U.Id  = ''@OperationsPerformedBy''
							AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                           AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
							', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
, (NEWID(), N'Today''s Candidates','This app provides the information about today''s sheduled interviews along with assignee details.Users can download the information and change the visualization of the app.', 
	  'SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],JT.JobTypeName [Job Type],ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],CIS.StartTime [Start Time]
,HS.[Status] [Candidate Status] FROM JobOpening JO INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id AND IsConfirmed = 1 AND JO.InActiveDateTime IS NULL AND CIS.InActiveDateTime IS NULL
                            INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JOS.InActiveDateTime IS NULL
							INNER JOIN CandidateInterviewScheduleAssignee CISA ON CISA.CandidateInterviewScheduleId = CIS.Id AND CISA.IsApproved = 1 AND CISA.InActiveDateTime IS NULL
							INNER JOIN Candidate C ON C.Id = CIS.CandidateId
							INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
							INNER JOIN [User] U ON U.Id = CISA.AssignToUserId 
							INNER JOIN HiringStatus HS ON HS.Id = C.HiringStatusId AND HS.InActiveDateTime IS NULL
							LEFT JOIN JobType JT ON JT.Id = JO.JobTypeId
							WHERE JOS.CompanyId = ''@CompanyId'' AND InterviewDate = CAST(GETDATE() AS date)', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 , (NEWID(), N'Interview vs Job Openings','This app provides the information about the interview details for all job openings.Users can download the information and change the visualization of the app.', 
	  'SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],HS.[Status] [Candidate Status],
         ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],FORMAT(CIS.StartTime,''dd MMM yyyy'') [Start Time],
         ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') Interviewer FROM JobOpening JO
            INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		    INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		    INNER JOIN Candidate C ON C.Id = CJ.CandidateId
		    INNER JOIN [User] U ON U.Id = JO.HiringManagerId 
		    INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id  
		    INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
		    INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
         WHERE JO.CompanyId = ''@CompanyId''
	       AND (''@UserId'' = '''' OR JO.HiringManagerId = ''@UserId'')
		   AND (''@HiringStatusId'' = '''' OR C.HiringStatusId = ''@HiringStatusId'')', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Job Openings due this month','This app provides the information about the job openings in current month.Users can download the information and change the visualization of the app.', 
	  'SELECT U.FirstName+'' ''+U.SurName [Assigned Recruiter(s)],JobOpeningTitle [Posting Tittle],FORMAT(DateTo,''dd MMM yyyy'') [Target Date],U.FirstName+'' ''+U.SurName [Account Manager],FORMAT(DateFrom,''dd MMM yyyy'') [Job Opening Creation Date],JOS.Status [Job Opening Status],NoOfOpenings [Number Of Positions] 
       FROM JobOpening JO INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
       INNER JOIN [User] U ON U.Id = JO.HiringManagerId AND U.InActiveDateTime IS NULL 
       WHERE JO.CompanyId = ''@CompanyId'' 
       AND JO.[DateTo] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
       AND JO.[DateTo] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date) 
       AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.[DateTo] AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
       AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.[DateTo] AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Job Openings due today','This app provides the information about the job openings in today due.Users can download the information and change the visualization of the app.', 
	  'SELECT U.FirstName+'' ''+U.SurName [Assigned Recruiter(s)],JO.JobOpeningTitle [Posting Tittle],U.FirstName+'' ''+U.SurName [Account Manager],JOS.Status [Job Opening Status],JO.NoOfOpenings [Number Of Positions] 
       FROM JobOpening JO INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
       INNER JOIN [User] U ON U.Id = JO.HiringManagerId AND U.InActiveDateTime IS NULL
       WHERE CAST(JO.DateTo AS date) = CAST(GETDATE() AS date) AND JO.CompanyId = ''@CompanyId''', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Upcoming Interviews','This app provides the information about the upcoming job interviews.Users can download the information and change the visualization of the app.', 
	  'SELECT JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],FORMAT(CIS.InterviewDate,''dd MMM yyyy'') [Interview Date],
       ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name] FROM JobOpening JO
         INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id 
         INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId
       WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CIS.InterviewDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CIS.InterviewDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Time To Fill','This app provides the information about time to fill job openings details like job opening title,number of candidates for each position,due date,delay in days and time to fill .Users can download the information and change the visualization of the app.', 
	  'SELECT T.[Job Opening Title],T.Recruiter,T.[Time To Fill],FORMAT(T.DateTo,''dd MMM yyyy'') [Job Opening Due Date] ,
              ISNULL(CASE WHEN [Delay] < 0 THEN 0 ELSE [Delay] END,0)[Delay],Candidates/NoOfOpenings [Candidates Per Position] FROM 
              (SELECT JO.JobOpeningTitle [Job Opening Title],ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Recruiter],NoOfOpenings,
              COUNT(c.Id)Candidates,DATEDIFF(DAY,JO.CreatedDateTime,GETDATE()) [Time To Fill],DATEDIFF(DAY,JO.DateTo,GETDATE()) [Delay],JO.DateTo 
         FROM JobOpening JO INNER JOIN [User]U ON U.Id = JO.HiringManagerId AND JO.InActiveDateTime IS NULL      
                            LEFT JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.InActiveDateTime IS NULL
							LEFT JOIN Candidate C ON C.Id = CJ.Id AND C.InActiveDateTime IS NULL
							WHERE U.CompanyId = ''@CompanyId''
							AND (ISNULL(@DateFrom,@Date) IS NULL OR CAST(JO.DateTo AS date) > = CAST(ISNULL(@DateFrom,@Date) AS date))
							AND (ISNULL(@DateTo,@Date) IS NULL OR CAST(JO.DateTo AS date) <=  CAST(ISNULL(@DateTo,@Date) AS date))
							AND (JO.HiringManagerId = ''@UserId'' OR ''@UserId'' = '''')
							GROUP BY JO.JobOpeningTitle,NoOfOpenings,JO.CreatedDateTime,JO.DateTo,U.FirstName,U.SurName)T', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
    ,(NEWID(), N'Hired Candidates vs Job Openings','This app provides the information about the hired candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  'SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],HS.[Status] [Candidate Status],
        ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name] FROM JobOpening JO
         INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId
		 INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
        WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Job Openings vs Associated Candidates','This app provides the information about the associated candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  'SELECT JO.JobOpeningTitle [Posting Title],HS.[Status] [Candidate Status For Job Opening],ISNULL(U.SurName,'''')+'' ''+ISNULL(U.FirstName,'''')[Associated By],
        ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],FORMAT(HS.CreatedDateTime,''dd MMM yyyy'') AS [Associated Status Changed Time] FROM JobOpening JO
         INNER JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN [User] U ON U.Id = JO.HiringManagerId
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId
		 INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
        WHERE JO.CompanyId = ''@CompanyId''
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(HS.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(HS.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
    ,(NEWID(), N'Candidate Conversion Count across Owners ','This app provides the count of candidates for each owner.Users can download the information and change the visualization of the app.',
	  'SELECT ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') AS Owner,COUNT(1) [Candidates Counts]  FROM [Candidate] C 
         INNER JOIN [User] U ON U.Id = C.AssignedToManagerId AND U.InActiveDateTime IS NULL
            WHERE U.CompanyId = ''@CompanyId''
	          AND (''@UserId'' = '''' OR C.AssignedToManagerId = ''@UserId'')
         GROUP BY U.FirstName,U.SurName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
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
	      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidates By Ownership'),'1','Candidates By Ownership','stackedcolumn',NULL,NULL,'Candidate Owner','Ownership Counts',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidates By Status'),'1','Candidates By Status','stackedcolumn',NULL,NULL,'Status','Candidates Counts',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings By Type'),'1','Job Openings By Type','stackedcolumn',NULL,NULL,'JobTypeName','JobOpening Counts',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Age Of Job'),'1','Age Of Job','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidates By Source'),'1','Candidates By Source','stackedcolumn',NULL,NULL,'Source','Candidates Counts',GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings Status Wise Report'),'1','Job Openings Status Wise Report','line',NULL,NULL,'Job Opening Status','Job Opening Counts',GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'My Job Openings'),'1','My Job Openings','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Today''s candidates'),'1','Today''s candidates','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Interview vs Job Openings'),'1','Interview vs Job Openings','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings due this month'),'1','Job Openings due this month','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings due today'),'1','Job Openings due today','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Upcoming Interviews'),'1','Upcoming Interviews','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Time To Fill'),'1','Time To Fill','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Hired Candidates vs Job Openings'),'1','Hired Candidates vs Job Openings','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings vs Associated Candidates'),'1','Job Openings vs Associated Candidates','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidate Conversion Count Across Owners'),'1','Candidate Conversion Count Across Owners','stackedcolumn',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
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

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Candidates By Status' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Job Openings By Type' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Candidates By Ownership' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Candidates By Source' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'My Job Openings' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Job Openings Status Wise Report' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s Candidates' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Interview vs Job Openings' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Job Openings due this month' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Job Openings due today' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Upcoming Interviews' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Time To Fill' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Hired Candidates vs Job Openings' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Job Openings vs Associated Candidates' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Candidate Conversion Count Across Owners' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
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