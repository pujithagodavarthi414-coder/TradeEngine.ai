CREATE PROCEDURE [dbo].[Marker261]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Candidates By Source','SELECT S.[Name] AS Source,COUNT(1) [Candidate Counts]  FROM [Candidate] C 
       INNER JOIN [Source] S ON S.Id = C.SourceId AND S.InActiveDateTime IS NULL
       WHERE S.CompanyId = ''@CompanyId''
	   AND (''@SourceId'' = '''' OR C.SourceId = ''@SourceId'')
	   AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
       AND ((ISNULL(@DateFrom,@Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
       AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))      
       GROUP BY S.[Name] ',@CompanyId)
 ,(NEWID(),'Candidates By Status','SELECT HS.[Status],COUNT(1) [Candidates Counts]  FROM [CandidateJobOpening] CJ 
                            INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND HS.InActiveDateTime IS NULL
							WHERE HS.CompanyId = ''@CompanyId''
							    AND (''@HiringStatusId'' = '''' OR CJ.HiringStatusId = ''@HiringStatusId'')
								AND (''@CandidateId'' = '''' OR CJ.CandidateId = ''@CandidateId'')
							    AND ((ISNULL(@DateFrom,@Date) IS NULL OR CAST(CJ.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CJ.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY HS.[Status]',@CompanyId)
,(NEWID(),'Time To Fill','SELECT T.[Job Opening Title],T.Recruiter,T.[Time To Fill],FORMAT(T.DateTo,''dd MMM yyyy'') [Job Opening Due Date] ,
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
							GROUP BY JO.JobOpeningTitle,NoOfOpenings,JO.CreatedDateTime,JO.DateTo,U.FirstName,U.SurName)T',@CompanyId)
,(NEWID(),'Candidates By Ownership','SELECT U.FirstName+'' ''+U.SurName [Candidate Owner] ,COUNT(1) [Ownership Counts]  FROM [Candidate] C 
                INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND C.InActiveDateTime IS NULL 
                INNER JOIN [USER]U ON U.Id  = C.AssignedToManagerId
							WHERE U.CompanyId = ''@CompanyId''
							  AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
							   AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
							  AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                              AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY U.FirstName+'' ''+U.SurName',@CompanyId)
,(NEWID(),'Job Openings Status Wise Report','SELECT [Status] [Job Opening Status],COUNT(1) [Job Opening Counts] FROM JobOpening JO 
      INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JO.InActiveDateTime IS NULL AND JOS.InActiveDateTime IS NULL
      WHERE JOS.CompanyId = ''@CompanyId''
	  AND (''@JobOpeningStatusId'' = ''''  OR JO.JobOpeningStatusId = ''@JobOpeningStatusId'')
	  AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.DateTo  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
      AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(JO.DateTo  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
	  GROUP BY [Status] ',@CompanyId)
,(NEWID(),'Interview Vs Job Openings','SELECT JO.JobOpeningUniqueName [Job Opening ID],JO.JobOpeningTitle [Posting Title],JT.JobTypeName [Job Type],ISNULL(C.FirstName,'''')+'' ''+ISNULL(C.LastName,'''')[Candidate Name],IT.InterviewTypeName [Interview Name],CIS.StartTime [Start Time]
,HS.[Status] [Candidate Status],ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') Interviewer FROM JobOpening JO INNER JOIN CandidateInterviewSchedule CIS ON CIS.JobOpeningId = JO.Id AND IsConfirmed = 1 AND JO.InActiveDateTime IS NULL AND CIS.InActiveDateTime IS NULL
                            INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId AND JOS.InActiveDateTime IS NULL
							INNER JOIN CandidateInterviewScheduleAssignee CISA ON CISA.CandidateInterviewScheduleId = CIS.Id AND CISA.IsApproved = 1 AND CISA.InActiveDateTime IS NULL
							INNER JOIN Candidate C ON C.Id = CIS.CandidateId
							INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
							INNER JOIN [User] U ON U.Id = CISA.AssignToUserId 
							INNER JOIN HiringStatus HS ON HS.Id = C.HiringStatusId AND HS.InActiveDateTime IS NULL
							LEFT JOIN JobType JT ON JT.Id = JO.JobTypeId
							WHERE JOS.CompanyId = ''@CompanyId''
							    AND (CISA.AssignToUserId  = ''@UserId'' OR ''@UserId'' = '''')
								AND (''@HiringStatusId'' = '''' OR C.HiringStatusId = ''@HiringStatusId'')',@CompanyId)

 )
 
  AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO