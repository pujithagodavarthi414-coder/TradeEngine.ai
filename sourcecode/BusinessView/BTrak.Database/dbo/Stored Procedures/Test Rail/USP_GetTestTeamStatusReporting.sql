-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-10-18 00:00:00.000'
-- Purpose      To get the status reporting of testteam member
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestTeamStatusReporting] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId='0B2921A9-E930-4013-9047-670B5352F308'

CREATE PROCEDURE [dbo].[USP_GetTestTeamStatusReporting]
(
   @UserId  UNIQUEIDENTIFIER = NULL, 
   @ProjectId  UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @CreatedOn NVARCHAR(250) = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	    
    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
    IF (@HavePermission = '1')
    BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@CreatedOn IS NULL) SET @CreatedOn = 'Last7dAYS'
		
		IF(@DateFrom IS NULL AND @DateTo IS NULL) SELECT @DateFrom = StartDate,@DateTo = EndDate FROM [Ufn_GetDatesWithText](@CreatedOn) 

		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

		CREATE TABLE #Temp 
		(
			[Date] DATE,
			UserId UNIQUEIDENTIFIER,
			SpentTime INT,
			ActualSpentTime INT,
			BugsCount INT,
			P0BugsCount INT,
			P1BugsCount INT,
			P2BugsCount INT,
			P3BugsCount INT,
			BugsCountText NVARCHAR(MAX)
		)

		;WITH DateRange as
		(
		  SELECT [Date] =  @DateFrom
		 -- WHERE DATEADD(dd, 1, @DateFrom) < @DateTo
		  UNION ALL
		  SELECT DATEADD(dd, 1, [Date])
		  FROM DateRange
		  WHERE DATEADD(dd, 1, [Date]) <= @DateTo
		)

		INSERT INTO #Temp(UserId,[Date],SpentTime,BugsCount,P0BugsCount,P1BugsCount,P2BugsCount,P3BugsCount)
		SELECT @UserId,CAST(DR.[Date] AS DATE),T.SpentTime,T1.TotalCount,T1.P0BugsCount,T1.P1BugsCount,T1.P2BugsCount,T1.P3BugsCount
		FROM DateRange DR

			 LEFT JOIN (SELECT (((ISNULL(DATEDIFF(MINUTE, TS.InTime,
                                          (CASE WHEN TS.[Date] = CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() 
                                                WHEN TS.[Date] <> CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN (DATEADD(HH,9,TS.InTime))
                                                ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
                               TS.UserId,
                               TS.[Date]
                        FROM TimeSheet TS
                             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.[Date] = TS.[Date]
						WHERE TS.UserId = @UserId AND TS.[Date] BETWEEN CAST(@DateFrom AS date) AND CAST(@DateTo AS date)
                        GROUP BY TS.InTime,OutTime,TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime) T ON T.[Date] = CAST(DR.[Date] AS DATE) AND T.UserId = @UserId

			LEFT JOIN (SELECT CAST(US.CreatedDateTime AS DATE) CreatedDate,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
					          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
						      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount,COUNT(1) TotalCount 
					   FROM  UserStory US 
                             INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND US.CreatedByUserId = @UserId AND (US.ProjectId = @ProjectId OR @ProjectId IS NULL)
                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
                             LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
					   WHERE CAST(US.CreatedDateTime AS DATE) BETWEEN CAST(@DateFrom AS date) AND CAST(@DateTo AS date)
                       GROUP BY CAST(US.CreatedDateTime AS DATE)) T1 ON T1.CreatedDate = CAST(DR.[Date] AS DATE)

		OPTION (MAXRECURSION 0)

	
		UPDATE #Temp SET BugsCountText = (SELECT STUFF((SELECT ', ' + CAST(CONVERT(NVARCHAR,BP.PriorityName +': '+ ISNULL(CONVERT(NVARCHAR,COUNT(US.Id)),'')) AS NVARCHAR(MAX)) [text()] 
                                                        FROM BugPriority BP INNER JOIN UserStory US ON US.BugPriorityId = BP.Id AND US.CreatedByUserId = @UserId AND (US.ProjectId = @ProjectId OR @ProjectId IS NULL)
					                                         AND  CONVERT(DATE,US.CreatedDateTime) = CONVERT(DATE,GETDATE())
                                                        WHERE BP.InActiveDateTime IS NULL 
                                                        GROUP BY BP.PriorityName
                                                        FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')) 
                                 
		UPDATE #Temp SET BugsCount = ISNULL(BugsCount,0) * ISNULL(ConfigurationTime,0) FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId

		CREATE TABLE #Temp2
        (
			[Date] DATETIME,
			ConfigurationId UNIQUEIDENTIFIER,
			ConfigurationTime INT
        )

        INSERT INTO #Temp2([Date],ConfigurationId)
        SELECT [Date],TC.Id 
		FROM TestRailConfiguration TC 
		     INNER JOIN TestRailConfiguration TC1 ON TC.Id = TC1.Id AND TC.Id = TC1.Id AND TC.InActiveDateTime IS NULL AND TC.CompanyId = @CompanyId
             INNER JOIN #Temp T ON 1=1
         
		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
					                         INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId  AND (TS.ProjectId = @ProjectId OR @ProjectId IS NULL)
					WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
		           
		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH  INNER JOIN TestSuite TS ON TCH.ReferenceId = TS.Id  AND (TS.ProjectId = @ProjectId OR @ProjectId IS NULL)  WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN TestSuiteSection TSS ON TSS.Id = TCH.ReferenceId
					                         INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND (TS.ProjectId = @ProjectId OR @ProjectId IS NULL) 
					WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN TestRun TR ON TR.Id = TCH.TestRunId  AND (TR.ProjectId = @ProjectId OR @ProjectId IS NULL) 
					WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRunCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id 
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN Milestone M ON M.Id = TCH.ReferenceId AND (M.ProjectId = @ProjectId OR @ProjectId IS NULL) 
					WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'MilestoneCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN TestRailReport TRR ON TRR.Id = TCH.ReferenceId AND  (TRR.ProjectId = @ProjectId OR @ProjectId IS NULL)   WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRepoReportCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
               
		UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime 
		FROM
			 (SELECT COUNT(1) CaseCreatedCount,ConfigurationId,CreatedDateTime 
			  FROM 
			       (SELECT TCH.ConfigurationId,CAST(TCH.CreatedDateTime AS DATE) CreatedDateTime
			        FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id =TCH.TestCaseId
					                         INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId AND  (TS.ProjectId = @ProjectId OR @ProjectId IS NULL)
						WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseViewed' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId 
			  )T  GROUP BY T.ConfigurationId,T.CreatedDateTime)t 
             INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
        WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId
              AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime	

		UPDATE #Temp2 SET ConfigurationTime  = F.ConfigurationTime  FROM(SELECT SUM(ZZ.ConfigurationTime)/60 ConfigurationTime,CreatedDateTime 
		FROM 
             (SELECT Counts * ISNULL(TC.Estimate,0) ConfigurationTime,Z.CreatedDateTime 
			  FROM
                   (SELECT COUNT(1) Counts,T.CreatedDateTime,TestCaseId 
				    FROM
	                    (SELECT TCH.TestCaseId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime FROM TestCaseHistory TCH INNER JOIN TestRun TR ON TR.Id = TCH.TestRunId AND  (TR.ProjectId = @ProjectId OR @ProjectId IS NULL)
						 WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId = @UserId
						)T GROUP BY CreatedDateTime,TestCaseId)Z INNER JOIN TestCase TC ON TC.Id = Z.TestCaseId)ZZ GROUP BY ZZ.CreatedDateTime)F 
		WHERE CAST(#Temp2.[Date] AS date) = F.CreatedDateTime AND #Temp2.ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
                       					
       SELECT CONVERT(NVARCHAR,FORMAT (T.[Date], 'dd-MMM-yyyy')) [DateName],
              T.UserId,
              T.BugsCountText,
              ISNULL(U.FirstName,'')+' '+ISNULL(U.SurName,'') UserName,
              ISNULL(CAST(T.SpentTime/60.0 AS decimal(10,2)),0) OriginalSpentTime,
              CAST((ISNULL((SELECT SUM(T2.ConfigurationTime) FROM #Temp2 T2 WHERE T2.[Date] = T.[Date] GROUP BY [Date]),0) + ISNULL(BugsCount,0))/60.0 AS DECIMAL (10,2)) ActualSpentTime,
              ISNULL(CAST(T.BugsCount/60.0 AS decimal(10,2)),0)BugsCount,
              ISNULL(T.P0BugsCount,0) P0BugsCount,
              ISNULL(T.P1BugsCount,0) P1BugsCount,
              ISNULL(T.P2BugsCount,0) P2BugsCount,
              ISNULL(T.P3BugsCount,0) P3BugsCount, 
              STUFF((SELECT ', ' + CAST(TC1.ConfigurationName AS VARCHAR(MAX)) [text()]
                                             FROM TestRailConfiguration TC INNER JOIN TestRailConfiguration TC1 ON TC.Id = TC1.Id AND TC.Id = TC.Id AND TC1.InActiveDateTime IS NULL AND TC1.CompanyId = @CompanyId
                                               ORDER BY TC.CreatedDateTime DESC
                                             FOR XML PATH(''), TYPE)
                                             .value('.','NVARCHAR(MAX)'),1,2,' ') ConfigurationName,
             STUFF((SELECT ', ' + CAST(cast(ISNULL(CASE WHEN TC1.Id = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId) THEN T.BugsCount ELSE TC.ConfigurationTime END,0)/60.0 as decimal(10,2)) AS nvarchar(MAX)) [text()]
                               FROM #Temp2 TC INNER JOIN TestRailConfiguration TC1 ON TC.ConfigurationId = TC1.Id AND TC1.InActiveDateTime IS NULL
                                              INNER JOIN TestRailConfiguration TC2 ON TC2.Id = TC1.Id AND TC2.Id = TC2.Id
                                             WHERE T.[Date] = TC.[Date]  
                                             ORDER BY TC2.CreatedDateTime DESC
                                             FOR XML PATH(''), TYPE)
                                             .value('.','NVARCHAR(MAX)'),1,2,' ') [ConfigurationTime]
            FROM #Temp T INNER JOIN [User]U ON U.Id = T.UserId AND U.InActiveDateTime IS NULL
             GROUP BY T.[Date],T.SpentTime,T.P0BugsCount,T.P1BugsCount,T.P2BugsCount,T.P3BugsCount,T.BugsCount,T.UserId,U.FirstName,U.SurName,BugsCountText
   END
   ELSE
                
     RAISERROR(@HavePermission,11,1)
    
   END TRY  
   BEGIN CATCH 
      
      THROW

   END CATCH

END     
GO                         