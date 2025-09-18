-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USP_GetTestTeamStatusReportProjectWise
	-- Add the parameters for the stored procedure here
   @UserId  UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @DateFrom DATETIME = NULL,
   @SelectedDate DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @CreatedOn NVARCHAR(250) = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
        IF (@HavePermission = '1')
          BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        IF(@CreatedOn IS NULL) SET @CreatedOn = 'Last7dAYS'
        
        IF(@DateFrom IS NULL AND @DateTo IS NULL)
        BEGIN
        SELECT @DateFrom = T.StartDate,@DateTo = T.EndDate  FROM [Ufn_GetDatesWithText](@CreatedOn) T
        END

		SET @DateFrom = @SelectedDate

        IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL
            CREATE TABLE #Temp 
            (
            [Date] DATE,
            UserId UNIQUEIDENTIFIER,
            SpentTime INT,
            ActualSpentTime INT,
            BugsCount int,
            P0BugsCount INT,
            P1BugsCount INT,
            P2BugsCount INT,
            P3BugsCount INT,
            BugsCountText NVARCHAR(MAX)
            )
			
			IF(@DateFrom IS NOT NULL AND @DateTo IS NOT NULL)
			BEGIN

            ;with dateRange as
            (
              select dt =  @DateFrom
             -- where dateadd(dd, 1, @DateFrom) < @DateTo
              union all
              select dateadd(dd, 1, dt)
              from dateRange
              where dateadd(dd, 1, dt) <= @DateTo
            )
            INSERT INTO #Temp([Date])
            select * from dateRange OPTION (MAXRECURSION 0)
            
			INSERT INTO #Temp([Date])
            SELECT CAST(@DateFrom AS date) WHERE CAST(@DateFrom AS date) = CAST(@DateTo AS date) AND CAST(@DateFrom AS date) NOT IN (SELECT [Date] FROM #Temp)
            		
					UPDATE #Temp SET UserId = @UserId 
			END
			
			IF(@DateFrom IS NOT NULL AND @DateTo IS  NULL)
			BEGIN

			INSERT INTO #Temp([Date],UserId,SpentTime)
			SELECT CAST(@DateFrom AS date),@UserId,(SELECT (((ISNULL(DATEDIFF(MINUTE, TS.InTime,
                                                   (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
                                                    THEN GETDATE() 
                                                    WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
                                                    THEN (DATEADD(HH,9,TS.InTime))
                                                    ELSE TS.OutTime 
                                                    END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0))))
                                                    FROM  TimeSheet TS LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.[Date] = TS.[Date]
	                                                WHERE  TS.UserId = @UserId AND TS.Date = CAST(@DateFrom AS date)
                                                      GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime)

			END

			CREATE TABLE #Temp2
            (
            [Date] DATETIME,
            ConfigurationId UNIQUEIDENTIFIER,
            ConfigurationTime INT,
			TestCaseCount INT,
			ProjectId UNIQUEIDENTIFIER
            )
            INSERT INTO #Temp2([Date],ConfigurationId,ProjectId)
            SELECT [Date],TC.Id, P.Id FROM TestRailConfiguration TC INNER JOIN TestRailConfiguration TC1 ON TC.Id = TC1.Id AND TC.Id = TC1.Id 
                                              AND TC.InActiveDateTime IS NULL AND TC.CompanyId = @CompanyId
                                              INNER JOIN #Temp T ON 1=1
											  INNER JOIN Project P ON 1=1 AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            
			--UPDATE #Temp SET UserId =T.UserId,SpentTime = T.SpentTime,[Date] = T.[Date] from
   --                                 (SELECT (((ISNULL(DATEDIFF(MINUTE, TS.InTime,
   --                                       (CASE WHEN T.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
   --                                             THEN GETDATE() 
   --                                             WHEN T.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
   --                                             THEN (DATEADD(HH,9,TS.InTime))
   --                                             ELSE TS.OutTime 
   --                                             END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
   --                                             TS.UserId,
   --                                             TS.[Date]
   --                                             FROM #Temp T INNER JOIN TimeSheet TS ON TS.[Date] = T.[Date] AND TS.UserId = @UserId
   --                                                          LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.[Date] = T.[Date]
   --                                                          GROUP BY TS.InTime,OutTime,T.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime)T WHERE #Temp.[Date] = T.[Date]
                   
                   
				   UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from
				         (SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestCase TC ON TCH.TestCaseId = TC.Id
					JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId  AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)

					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					      
                     )T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId,
				                                                                                       CAST(TS.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestSuite TS INNER JOIN TestCaseHistory TCH ON  TS.Id = TCH.ReferenceId AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteCreatedOrUpdated' AND CompanyId = @CompanyId)					
					WHERE  TCH.CreatedByUserId =  @UserId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId))T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					--UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
     --              (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId)
				 --  ,CAST(TSS.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
     --               FROM  TestSuiteSection TSS 
					--JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId
					
					--WHERE TSS.CreatedByUserId =  @UserId 
     --               )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
     --               INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
     --              WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
     --               AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from(SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TR.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestRun TR on TR.Id = tch.TestRunId AND (@ProjectId IS NULL OR TR.ProjectId = @ProjectId)
					
					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRunCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					
                    )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId=#Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT M.ProjectId,CAST(TCH.CreatedDateTime AS DATE)CreatedDateTime,ConfigurationId
				   FROM TestCaseHistory TCH INNER JOIN Milestone M ON M.Id = TCH.ReferenceId WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'MilestoneCreatedOrUpdated' AND CompanyId = @CompanyId)
				    AND TCH.CreatedByUserId =  @UserId AND (@ProjectId IS NULL OR M.ProjectId = @ProjectId))T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
        
					UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId
				   ,CAST(TRP.CreatedDateTime AS date)CreatedDateTime, TRP.ProjectId
                    FROM TestRailReport TRP INNER JOIN TestCaseHistory TCH ON TCH.ReferenceId = TRP.Id AND (@ProjectId IS NULL OR TRP.ProjectId = @ProjectId) AND ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRepoReportCreatedOrUpdated' AND CompanyId = @CompanyId)
					
					WHERE TCH.CreatedByUserId =  @UserId )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH  
					JOIN TestCase TC ON TCH.TestCaseId = TC.Id
					JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)

					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseViewed' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					
                    )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					---  For Count

					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from
				         (SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestCase TC ON TCH.TestCaseId = TC.Id
					JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)

					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					      
                     )T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId, 
				         CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestSuite TS  INNER JOIN TestCaseHistory TCH ON TS.Id = TCH.ReferenceId AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteCreatedOrUpdated' AND CompanyId = @CompanyId)				
					WHERE  TCH.CreatedByUserId =  @UserId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId))T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					--UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
     --              (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId)
				 --  ,CAST(TSS.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
     --               FROM  TestSuiteSection TSS 
					--JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId				
					--WHERE TSS.CreatedByUserId =  @UserId 
     --               )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
     --               INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
     --              WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
     --               AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from(SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TR.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestRun TR on TR.Id = tch.TestRunId AND (@ProjectId IS NULL OR TR.ProjectId = @ProjectId)
					
					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRunCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					
                    )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId=#Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId
				    ,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, M.ProjectId
                    FROM Milestone M INNER JOIN TestCaseHistory TCH ON TCH.ReferenceId = M.Id AND (@ProjectId IS NULL OR M.ProjectId = @ProjectId) AND TCH.ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'MilestoneCreatedOrUpdated' AND CompanyId = @CompanyId)
					
					WHERE TCH.CreatedByUserId =  @UserId )T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
        
					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId
				   ,CAST(TRP.CreatedDateTime AS date)CreatedDateTime, TRP.ProjectId
                    FROM TestRailReport TRP INNER JOIN TestCaseHistory TCH ON TCH.ReferenceId = TRP.Id AND (@ProjectId IS NULL OR TRP.ProjectId = @ProjectId) AND ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRepoReportCreatedOrUpdated' AND CompanyId = @CompanyId)
					
					WHERE TCH.CreatedByUserId =  @UserId )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
                  
					UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime,T.ProjectId from(SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH  
					JOIN TestCase TC ON TCH.TestCaseId = TC.Id
					JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)

					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseViewed' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					
                    )T  group by T.ConfigurationId,T.CreatedDateTime,T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime
        
		 UPDATE #Temp2 SET ConfigurationTime =  T.CaseCreatedCount * TCR.ConfigurationTime FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from
				         (SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestSuiteSection TSS ON TSS.Id = TCH.ReferenceId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)
					WHERE ConfigurationId=
					(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId					      
                     )T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

						UPDATE #Temp2 SET TestCaseCount =  T.CaseCreatedCount FROM
                   (select COUNT(1)CaseCreatedCount ,ConfigurationId,CreatedDateTime, T.ProjectId from
				         (SELECT ConfigurationId,CAST(TCH.CreatedDateTime AS date)CreatedDateTime, TS.ProjectId
                    FROM TestCaseHistory TCH
					JOIN TestSuiteSection TSS ON TSS.Id = TCH.ReferenceId
					JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId

					WHERE ConfigurationId=(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId =  @UserId
					      
                     )T  group by T.ConfigurationId,T.CreatedDateTime, T.ProjectId)t 
                    INNER JOIN TestRailConfiguration TCR ON T.ConfigurationId = TCR.Id
                   WHERE TCR.InActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL AND  T.ConfigurationId = #Temp2.ConfigurationId AND T.ProjectId = #Temp2.ProjectId
                    AND CAST(#Temp2.[Date] AS date) = t.CreatedDateTime

					UPDATE #Temp2 SET ConfigurationTime  = F.ConfigurationTime  FROM(SELECT SUM(ZZ.ConfigurationTime)/60 ConfigurationTime,CreatedDateTime,ProjectId FROM 
                                     (SELECT Counts * ISNULL(TC.Estimate,0) ConfigurationTime,Z.CreatedDateTime, TS.ProjectId FROM
                                      (SELECT COUNT(1) Counts,T.CreatedDateTime,TestCaseId FROM
	                                 (SELECT TestCaseId,CAST(CreatedDateTime AS date)CreatedDateTime FROM TestCaseHistory TCH WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId = @UserId
									   )T 
	                                 GROUP BY CreatedDateTime,TestCaseId)Z INNER JOIN TestCase TC ON TC.Id = Z.TestCaseId INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId)ZZ GROUP BY ZZ.CreatedDateTime,ZZ.ProjectId)F 
									 WHERE CAST(#Temp2.[Date] AS date) = F.CreatedDateTime AND #Temp2.ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
									 AND #Temp2.ProjectId = F.ProjectId

                    UPDATE #Temp2 SET TestCaseCount  = F.TestCaseCount  FROM(SELECT SUM(ZZ.TestCaseCount) TestCaseCount,CreatedDateTime,ProjectId FROM 
                                     (SELECT Counts TestCaseCount,Z.CreatedDateTime, TS.ProjectId FROM
                                      (SELECT COUNT(1) Counts,T.CreatedDateTime,TestCaseId FROM
	                                 (SELECT TestCaseId,CAST(CreatedDateTime AS date)CreatedDateTime FROM TestCaseHistory TCH WHERE ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId) AND TCH.CreatedByUserId = @UserId
									   )T 
	                                 GROUP BY CreatedDateTime,TestCaseId)Z INNER JOIN TestCase TC ON TC.Id = Z.TestCaseId INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId)ZZ GROUP BY ZZ.CreatedDateTime,ZZ.ProjectId)F 
									 WHERE CAST(#Temp2.[Date] AS date) = F.CreatedDateTime AND #Temp2.ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
									 AND #Temp2.ProjectId = F.ProjectId
        
					  UPDATE #Temp SET BugsCount = T.TotalCount,P0BugsCount = T.P0BugsCount,P1BugsCount = T.P1BugsCount,P2BugsCount = T.P2BugsCount,P3BugsCount = T.P3BugsCount FROM  
					  (SELECT CAST(us.CreatedDateTime as date) CreatedDate,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
					                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
						                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
						                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
						                                      COUNT(1)TotalCount 
						                                FROM  UserStory US 
                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND US.CreatedByUserId = @UserId
                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
                                                        GROUP BY cast(us.CreatedDateTime as date))T WHERE #Temp.[Date] = T.CreatedDate 
                
					UPDATE #Temp SET BugsCountText = (SELECT STUFF((SELECT ', ' + CAST(CONVERT(NVARCHAR,BP.PriorityName +': '+ ISNULL(CONVERT(NVARCHAR,COUNT(UST.Id)),'')) AS nvarchar(MAX)) [text()] 
                                                      FROM BugPriority BP  LEFT JOIN UserStory US ON US.BugPriorityId = BP.Id AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
					                                                     AND US.CreatedByUserId = @UserId
					                                                     AND  CONVERT(DATE,US.CreatedDateTime) = CONVERT(DATE,GETDATE())
																		 LEFT JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
                                                     WHERE BP.InActiveDateTime IS NULL 
                                                     GROUP BY BP.PriorityName
                                                      FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')) 
                                 
				UPDATE #Temp SET BugsCount = ISNULL(BugsCount,0) * ISNULL(ConfigurationTime,0) FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId
				
                  SELECT CONVERT(NVARCHAR,FORMAT (T.[Date], 'dd-MMM-yyyy')) [DateName],
                         T.UserId,
                         T.BugsCountText,
                         ISNULL(U.FirstName,'')+' '+ISNULL(U.SurName,'') UserName,
                         ISNULL(CAST(T.SpentTime/60.0 AS decimal(10,2)),0) OriginalSpentTime,
                         CAST((ISNULL((SELECT SUM(T2.ConfigurationTime) FROM #Temp2 T2 WHERE T2.[Date] = T.[Date] GROUP BY [Date]),0) + ISNULL(BugsCount,0))/60.0 AS DECIMAL (10,2)) ActualSpentTime,
                         --ISNULL(CAST(T.BugsCount/60.0 AS decimal(10,2)),0)BugsCount,
						 (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON UST.Id  = US.UserStoryTypeId 
						 WHERE CONVERT(NVARCHAR,FORMAT (US.CreatedDateTime, 'dd-MMM-yyyy')) = CONVERT(NVARCHAR,FORMAT (@DateFrom, 'dd-MMM-yyyy')) AND UST.IsBug = 1 AND CompanyId = @CompanyId AND US.ProjectId = P.Id) AS BugsCount,
                         ISNULL(T.P0BugsCount,0) P0BugsCount,
                         ISNULL(T.P1BugsCount,0) P1BugsCount,
                         ISNULL(T.P2BugsCount,0) P2BugsCount,
                         ISNULL(T.P3BugsCount,0) P3BugsCount,
                         STUFF((SELECT ', ' + CAST(TC1.ConfigurationName AS VARCHAR(MAX)) [text()]
                                                        FROM TestRailConfiguration TC INNER JOIN TestRailConfiguration TC1 ON TC.Id = TC1.Id AND TC.Id = TC.Id AND TC1.InActiveDateTime IS NULL AND TC1.CompanyId = @CompanyId
                                                          ORDER BY TC.CreatedDateTime DESC
                                                        FOR XML PATH(''), TYPE)
                                                        .value('.','NVARCHAR(MAX)'),1,2,' ') ConfigurationName,
                        STUFF((SELECT ', ' + CAST(cast(ISNULL(CASE WHEN TC1.Id = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId) THEN (SELECT COUNT(1)TotalCount  FROM  UserStory US 
                                                            INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND US.CreatedByUserId = @UserId
                                                            AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
                                                            LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
                                                            WHERE CAST(us.CreatedDateTime as date) =  t.Date AND ProjectId = p.Id)*  (SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId)  ELSE TC.ConfigurationTime END,0)/60.0 as decimal(10,2)) AS nvarchar(MAX)) [text()]
                                          FROM #Temp2 TC INNER JOIN TestRailConfiguration TC1 ON TC.ConfigurationId = TC1.Id AND TC1.InActiveDateTime IS NULL 
                                                         INNER JOIN TestRailConfiguration TC2 ON TC2.Id = TC1.Id AND TC2.Id = TC2.Id
                                                        WHERE T.[Date] = TC.[Date]  AND TC.ProjectId = P.Id
                                                        ORDER BY TC2.CreatedDateTime DESC
                                                        FOR XML PATH(''), TYPE)
                                                        .value('.','NVARCHAR(MAX)'),1,2,' ') ConfigurationTime,
                        STUFF((SELECT ', ' + CAST(ISNULL(CASE WHEN TC1.Id = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'BugsCreated' AND CompanyId = @CompanyId) THEN (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON UST.Id  = US.UserStoryTypeId 
                        WHERE CONVERT(NVARCHAR,FORMAT (US.CreatedDateTime, 'dd-MMM-yyyy')) = CONVERT(NVARCHAR,FORMAT (@DateFrom, 'dd-MMM-yyyy')) AND UST.IsBug = 1 AND CompanyId = @CompanyId AND US.CreatedByUserId = @UserId AND US.ProjectId = P.Id) ELSE TC.TestCaseCount END,0) AS nvarchar(MAX)) [text()]
                                          FROM #Temp2 TC LEFT JOIN TestRailConfiguration TC1 ON TC.ConfigurationId = TC1.Id AND TC1.InActiveDateTime IS NULL
                                                         LEFT JOIN TestRailConfiguration TC2 ON TC2.Id = TC1.Id AND TC2.Id = TC2.Id
                                                        WHERE T.[Date] = TC.[Date]  AND TC.ProjectId = P.Id
                                                        ORDER BY TC2.CreatedDateTime DESC
                                                        FOR XML PATH(''), TYPE) 
                                                        .value('.','NVARCHAR(MAX)'),1,2,' ') TestCasesCount,

						ISNULL((SELECT SUM(TestCaseCount) FROM #Temp2 TC INNER JOIN TestRailConfiguration TC1 ON TC.ConfigurationId = TC1.Id AND TC1.InActiveDateTime IS NULL
                                                         INNER JOIN TestRailConfiguration TC2 ON TC2.Id = TC1.Id AND TC2.Id = TC2.Id
                                                        WHERE T.[Date] = TC.[Date] AND TC.ProjectId = P.Id ),0) TestCaseCreated                                                        

						, p.Id AS ProjectId, p.ProjectName

                       FROM #Temp T INNER JOIN [User]U ON U.Id = T.UserId AND U.InActiveDateTime IS NULL
					   INNER JOIN Project P ON P.CompanyId = U.CompanyId AND P.InActiveDateTime IS NULL AND (@ProjectId IS NULL OR P.Id = @ProjectId)
					   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId= @UserId AND InActiveDateTime IS NULL)
					   WHERE CONVERT(NVARCHAR,FORMAT (T.[Date], 'dd-MMM-yyyy')) = CONVERT(NVARCHAR,FORMAT (@DateFrom, 'dd-MMM-yyyy')) AND P.ProjectName <> 'Adhoc project'
                       AND T.UserId = @UserId
                       
					   GROUP BY T.[Date],T.SpentTime,T.P0BugsCount,T.P1BugsCount,T.P2BugsCount,T.P3BugsCount,T.BugsCount,T.UserId,U.FirstName,U.SurName,BugsCountText,P.Id,P.ProjectName
            END
				ELSE
                
					RAISERROR(@HavePermission,11,1)
    
     END TRY  
     BEGIN CATCH 
        
        THROW

    END CATCH
    
END
GO