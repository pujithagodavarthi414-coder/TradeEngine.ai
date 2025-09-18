CREATE PROCEDURE [dbo].[Marker300]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

  MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
    (NEWID(), N'Job Openings By Type','This app provides the count of job openings for each job type. User can filter the information and user can download the information and user can change the visualization for the app', N' SELECT ES.EmploymentStatusName [Job Type Name],COUNT(1) [Job Opening Counts]  FROM JobOpening JO INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId 
                                      AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
									  LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
									  WHERE JOS.CompanyId = ''@CompanyId''
									   AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                       AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
									  GROUP BY ES.EmploymentStatusName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
   ,(NEWID(), N'Candidates By Status','This app provides the count of candidates for each hiring status. User can download the information',
   'SELECT HS.[Status],COUNT(1) [Candidates Counts]  FROM [Candidate] C INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL 
                            INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
							INNER JOIN JobOpening JO ON JO.Id = CJ.JobOpeningId AND JO.InActiveDateTime IS NULL 
							WHERE HS.CompanyId = ''@CompanyId''
							    AND (''@HiringStatusId'' = '''' OR HS.Id = ''@HiringStatusId'')
								AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
							    AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY HS.[Status]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
   ,(NEWID(), N'Candidates By Ownership','This app provides the count of count of candidates for each assigned owner and user can download the information',
   N'SELECT U.FirstName+'' ''+U.SurName [Candidate Owner] ,COUNT(1) [Ownership Counts]  FROM [Candidate] C INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL 
                          INNER JOIN [USER]U ON U.Id  = C.AssignedToManagerId
						  INNER JOIN JobOpening JO ON JO.Id = CJ.JobOpeningId AND JO.InActiveDateTime IS NULL
							WHERE U.CompanyId = ''@CompanyId''
							  AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
							  AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
							 AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY U.FirstName+'' ''+U.SurName ', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Age Of Job','This app provides the information about job openings details like job opening start and age of job. User can download the information', N'SELECT JO.JobOpeningTitle [Job Opening],NoOfOpenings [No Of Positions],
       CASE WHEN DATEDIFF(DAY,JO.DateFrom,GETDATE()) > =0 THEN DATEDIFF(DAY,JO.DateFrom,GETDATE()) ELSE 0 END [Age Of Job],
       CASE WHEN DATEDIFF(DAY,JO.DateTo,GETDATE()) >= 0 THEN DATEDIFF(DAY,JO.DateTo,GETDATE()) ELSE 0 END [Delay]
        FROM JobOpening JO LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId AND JO.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL 
                            WHERE JO.CompanyId = ''@CompanyId'' AND  JO.InActiveDateTime IS NULL
							      AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
								  AND (''@JobOpeningStatusId'' = '''' OR JO.JobOpeningStatusId = ''@JobOpeningStatusId'')
							      AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                  AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
	,(NEWID(), N'Candidates By Source','This app provides the count of candidates for each source.Users can download the information and change the visualization of the app.', 
	  'SELECT S.[Name] AS Source,COUNT(1) [Candidate Counts]  FROM [Candidate] C 
       INNER JOIN [Source] S ON S.Id = C.SourceId AND S.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL
       WHERE S.CompanyId = ''@CompanyId''
	        AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
	        AND (''@SourceId'' = '''' OR C.SourceId = ''@SourceId'')
            AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
            AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))      
       GROUP BY S.[Name]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Job Openings Status Wise Report','This app provides the count of job openings for each job opening status.Users can download the information and change the visualization of the app.', 
	  'SELECT [Status] [Job Opening Status],COUNT(1) [Job Opening Counts] FROM JobOpening JO 
      INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
      WHERE JOS.CompanyId = ''@CompanyId''
	  AND (''@JobOpeningStatusId'' = '''' OR JO.JobOpeningStatusId = ''@JobOpeningStatusId'')
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
	  ' SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],JT.JobTypeName [Job Type],ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],FORMAT(CIS.StartTime,''dd MMM yyy hh:mm'') [Interview Time]
,HS.[Status] [Candidate Status] FROM  Candidate C INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId = C.Id AND C.InActiveDateTime IS NULL AND CJO.InActiveDateTime IS NULL
                                                  INNER JOIN CandidateInterviewSchedule CIS ON CJO.JobOpeningId = CIS.JobOpeningId AND C.Id = CIS.CandidateId   AND CIS.InActiveDateTime IS NULL AND ISNULL(CIS.IsCancelled,0) = 0
                                          INNER JOIN JobOpening JO ON JO.Id = CJO.JobOpeningId AND JO.InActiveDateTime IS NULL
										 INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JOS.InActiveDateTime IS NULL
							             INNER JOIN CandidateInterviewScheduleAssignee CISA ON CISA.CandidateInterviewScheduleId = CIS.Id AND CISA.InActiveDateTime IS NULL AND CISA.IsApproved = 1
							             INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
							             INNER JOIN [User] U ON U.Id = CISA.AssignToUserId 
							             INNER JOIN ScheduleStatus HS ON HS.Id = CIS.StatusId AND HS.InActiveDateTime IS NULL
							            LEFT JOIN JobType JT ON JT.Id = JO.JobTypeId
							WHERE JOS.CompanyId = ''@CompanyId'' AND CAST(InterviewDate AS date) = CAST(GETDATE() AS date)
							      AND (''@UserId'' = '''' OR U.Id = ''@UserId'')', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
 , (NEWID(), N'Interview vs Job Openings','This app provides the information about the interview details for all job openings.Users can download the information and change the visualization of the app.', 
	  'SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],HS.[Status] [Candidate Status],
         ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],FORMAT(CIS.StartTime,''dd MMM yyyy'') [Interview Date],
         ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') Interviewer FROM JobOpening JO
            
		    INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.InActiveDateTime IS NULL AND JO.InActiveDateTime IS NULL
		    INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
		    INNER JOIN [User] U ON U.Id = JO.HiringManagerId AND U.InActiveDateTime IS NULL
		    INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id  AND CIS.InActiveDateTime IS NULL
		    INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
		    INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
			LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
         WHERE JO.CompanyId = ''@CompanyId''
	       AND (''@UserId'' = '''' OR JO.HiringManagerId = ''@UserId'')
		   AND (''@HiringStatusId'' = '''' OR HS.Id = ''@HiringStatusId'')', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
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
	  ' SELECT JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],FORMAT(CIS.InterviewDate,''dd MMM yyyy'') [Interview Date],
       ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],(SELECT  
       STUFF((SELECT '', '' + U.FirstName+'' ''+ISNULL(U.SurName,'''')  [text()]
         FROM CandidateInterviewScheduleAssignee CISA INNER JOIN [User] U ON U.Id = CISA.AssignToUserId AND CISA.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL 
         WHERE CISA.CandidateInterviewScheduleId = CIS.Id
         FOR XML PATH(''''), TYPE)
        .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') [Interviewers]
)[Interviewers],SS.[Status] [Interviewe Status]   FROM JobOpening JO
         INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id AND JO.InActiveDateTime IS NULL AND CIS.InActiveDateTime IS NULL AND ISNULL(IsCancelled,0)= 0 
         LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.CandidateId=CIS.CandidateId AND CJ.InActiveDateTime IS NULL
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
	     INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId AND IT.InActiveDateTime IS NULL
		 LEFT JOIN ScheduleStatus SS ON SS.Id = CIS.StatusId AND SS.InActiveDateTime IS NULL
       WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
		 AND (''@HiringStatusId'' = '''' OR CJ.HiringStatusId = ''@HiringStatusId'')
		 AND CAST(CIS.InterviewDate AS date) > CAST(GETDATE() AS DATE)
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
         
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.InActiveDateTime IS NULL AND JO.InActiveDateTime IS NULL
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
		 INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
		 LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
        WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Job Openings vs Associated Candidates','This app provides the information about the associated candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  'SELECT JO.JobOpeningTitle [Posting Title],HS.[Status] [Candidate Status For Job Opening],ISNULL(U.SurName,'''')+'' ''+ISNULL(U.FirstName,'''')[Associated By],
        ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],FORMAT(HS.CreatedDateTime,''dd MMM yyyy'') AS [Associated Status Changed Time] FROM JobOpening JO
         LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId AND JO.InActiveDateTime IS NULL
		 INNER JOIN [User] U ON U.Id = JO.HiringManagerId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.InActiveDateTime IS NULL
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
		 INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
        WHERE JO.CompanyId = ''@CompanyId''
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(HS.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(HS.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
    ,(NEWID(), N'Candidate Conversion Count across Owners ','This app provides the count of candidates for each owner.Users can download the information and change the visualization of the app.',
	  'SELECT ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') AS Owner,COUNT(1) [Candidates Counts]  FROM [Candidate] C 
         INNER JOIN [User] U ON U.Id = C.AssignedToManagerId AND U.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL
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
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Job Openings By Type'),'1','Job Openings By Type','stackedcolumn',NULL,NULL,'Job Type Name','Job Opening Counts',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Age Of Job'),'1','Age Of Job','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Candidates By Source'),'1','Candidates By Source','stackedcolumn',NULL,NULL,'Source','Candidate Counts',GETDATE(),@UserId)
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
	
  MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
     (NEWID(), N'Upcoming Interviews','This app provides the information about the upcoming job interviews.Users can download the information and change the visualization of the app.', 
	  ' SELECT JO.JobOpeningTitle [Posting Title],ES.EmploymentStatusName [Job Type],FORMAT(CIS.InterviewDate,''dd MMM yyyy'') [Interview Date],
       ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],(SELECT  
       STUFF((SELECT '', '' + U.FirstName+'' ''+ISNULL(U.SurName,'''')  [text()]
         FROM CandidateInterviewScheduleAssignee CISA INNER JOIN [User] U ON U.Id = CISA.AssignToUserId AND CISA.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL 
         WHERE CISA.CandidateInterviewScheduleId = CIS.Id
         FOR XML PATH(''''), TYPE)
        .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') [Interviewers]
)[Interviewers],SS.[Status] [Interviewe Status]   FROM JobOpening JO
         INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id AND JO.InActiveDateTime IS NULL AND CIS.InActiveDateTime IS NULL AND ISNULL(IsCancelled,0)= 0 
         LEFT JOIN EmploymentStatus ES ON ES.Id = JO.JobTypeId 
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.CandidateId=CIS.CandidateId AND CJ.InActiveDateTime IS NULL
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
	     INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId AND IT.InActiveDateTime IS NULL
		 LEFT JOIN ScheduleStatus SS ON SS.Id = CIS.StatusId AND SS.InActiveDateTime IS NULL
       WHERE JO.CompanyId = ''@CompanyId''
	     AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
		 AND (''@HiringStatusId'' = '''' OR CJ.HiringStatusId = ''@HiringStatusId'')
		 AND CAST(CIS.InterviewDate AS date) > CAST(GETDATE() AS DATE)
         AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CIS.InterviewDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CIS.InterviewDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	    ,(NEWID(), N'Hired Candidates vs Job Openings','This app provides the information about the hired candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  ' SELECT JobOpeningTitle [Job Name],NoOfOpenings [No Of Openings],(SELECT COUNT(1) FROM CandidateJobOpening CJO JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND CJO.InActiveDateTime IS NULL
					WHERE CJO.JobOpeningId= JO.Id AND HS.[Status]=''On boarding''
					AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.AppliedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.AppliedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
					AND   (''@CandidateId'' = '''' OR CJO.CandidateId = ''@CandidateId'')
					) [Hired Candidates] 
					FROM  JobOpening JO
					WHERE CompanyId = ''@CompanyId'' AND JO.InActiveDateTime IS NULL 
         AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
      ,(NEWID(), N'Candidate Conversion Count across Owners ','This app provides the count of candidates for each owner.Users can download the information and change the visualization of the app.',
	  'SELECT ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') AS Owner,COUNT(1) [Candidates Counts]  FROM [Candidate] C 
         INNER JOIN [User] U ON U.Id = C.AssignedToManagerId AND U.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL
		 INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId = C.Id AND CJO.InActiveDateTime IS NULL
		 JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND   HS.[Status]=''On boarding''
            WHERE U.CompanyId = ''@CompanyId''
	          AND (''@UserId'' = '''' OR C.AssignedToManagerId = ''@UserId'')
			  AND   ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
              AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date)))) 
         GROUP BY U.FirstName,U.SurName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Job Openings vs Associated Candidates','This app provides the information about the associated candidate details for all job openings.Users can download the information and change the visualization of the app.',
	  'SELECT JO.JobOpeningTitle [Posting Title],HS.[Status] [Candidate Status For Job Opening],ISNULL(U.SurName,'''')+'' ''+ISNULL(U.FirstName,'''')[Associated By],
        ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],FORMAT(CJ.AppliedDateTime,''dd MMM yyyy hh:mm:ss'') AS [Associated Status Changed Time] FROM JobOpening JO
		 INNER JOIN [User] U ON U.Id = JO.HiringManagerId AND JO.InActiveDateTime IS NULL
		 INNER JOIN CandidateJobOpening CJ ON CJ.JobOpeningId = JO.Id AND CJ.InActiveDateTime IS NULL
		 INNER JOIN Candidate C ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL
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

	
	 UPDATE CustomAppColumns SET SubQuery = 'SELECT FORMAT(TS.[Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),
SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in mins]    FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL   
 WHERE TS.InActiveDateTime IS NULL    
 AND U.CompanyId = ''@CompanyId''  
 AND FORMAT(TS.Date,''dd MMM yyyy'') = CAST(''##Date##'' AS DATE)   
 GROUP BY FORMAT(TS.[Date],''dd MMM yyyy''),LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName  
  HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70'
   WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Afternoon late trend graph' AND CompanyId = @CompanyId) AND InActiveDateTime IS NULL

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Today''s morning late people count'),'Today''s morning late people count', 'int', 'SELECT U.FirstName+'' ''+U.SurName [Employee Name],DATEDIFF(MI,CAST(TS.Date AS DATETIME) + CAST(SW.DeadLine AS DATETIME) ,SWITCHOFFSET(TS.InTime, ''+00:00'')) [Late In Mins]
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId
	AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId             
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,''@CurrentDateTime'')  
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL 
	AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)  
	WHERE TS.[Date] = CONVERT(DATE,''@CurrentDateTime'')
	AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))  
	AND U.CompanyId = ''@CompanyId'' 
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName]
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
GO