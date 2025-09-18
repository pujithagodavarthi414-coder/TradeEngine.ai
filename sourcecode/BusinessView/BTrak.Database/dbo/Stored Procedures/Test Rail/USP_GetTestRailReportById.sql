-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-07-09 00:00:00.000'
-- Purpose      To Get the TestRail Reports by appplying different fileters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestRailReportById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestRailReportById]
(
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER,
    @MilestoneId  UNIQUEIDENTIFIER = NULL,
    @ReportId  UNIQUEIDENTIFIER = NULL,
	@IsForPdf BIT  = NULL
	
)       
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             
             IF(@MilestoneId = '00000000-0000-0000-0000-000000000000') SET @MilestoneId = NULL
             
             IF(@ReportId = '00000000-0000-0000-0000-000000000000') SET @ReportId = NULL    
			 
			 DECLARE @PageSize INT = 100
             DECLARE @PageNumber INT = 1   
			 
			 IF(@IsForPdf = 1) SET @PageSize = (SELECT COUNT(1) FROM TestCasesReport WHERE ReportId = @ReportId)               
              
    --         CREATE TABLE #Temp
			 --(
			 --TestRunId UNIQUEIDENTIFIER
			 --)
			 --INSERT INTO #Temp(TestRunId)
			 --SELECT TRR.Id FROM TestRailReport TRR INNER JOIN Milestone M ON TRR.MilestoneId = M.Id
			 --                                              INNER JOIN TestRun TR ON TR.MilestoneId = M.Id  WHERE TRR.Id  = @ReportId
			
			SELECT  TRR.Id AS TestRailReportId, 
                     TRR.[Name] TestRailReportName,
                     TRR.[Description],
					 TRR.PdfUrl,
					 TRR.TestRunId,
                     TRR.MilestoneId,
                     M.Title MilestoneName,
                     TRR.ProjectId,
                     P.ProjectName,
					 (SELECT COUNT(1) FROM TestCasesReport TCR WHERE ReportId = TRR.Id AND TCR.InActiveDateTime IS NULL)CasesCount,
                     TRR.TestRailReportOptionId,
                     CAST(TRR.CreatedDateTime AS datetime) CreatedDateTime,
                     TRR.CreatedByUserId,
                     TRR.[TimeStamp],   
                     U.FirstName + ' ' + U.SurName CreatedBy,
                     U.ProfileImage CreatedByProfileImage,
					(SELECT TR.Id TestRunId,
                            (SELECT TOP 1 [Name] FROM TestRun T WHERE T.CreatedDateTime <=  TRR1.CreatedDateTime AND TR.Id = T.Id 
							ORDER BY T.CreatedDateTime DESC
							       )TestRunName,
                            TR.[Name] NewTestRunName,
							TR.IsCompleted,
							CASE WHEN TR.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived
                            FROM TestRun TR  WITH (NOLOCK) INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId AND (TS.InActiveDateTime IS NULL OR TS.InActiveDateTime >= TRR1.CreatedDateTime)
                                                  WHERE TR.CreatedDateTime <=  TRR1.CreatedDateTime 
												       AND (TR.MilestoneId= TRR.MilestoneId OR TR.Id = TRR.TestRunId)
													   AND TR.Id IN (SELECT TestRunId FROM TestCasesReport TCR WHERE ReportId = @ReportId)
												  GROUP BY  TR.Id,TR.[Name],TR.IsCompleted,TR.InActiveDateTime,TR.Id
                      FOR XML PATH('TestRunReportMiniModel'), ROOT('TestRunModel'), TYPE) AS TestRunsXml,
                     (SELECT 
                              TCR.TestCaseId
                             ,TCR.TestCaseTitle AS Title
                             ,TCR.TestRunId
                             ,TC.TestCaseId TestCaseIdentity
                             ,TCR.AssignToId
                             ,TCS.[Status] AS StatusName
                             ,TCS.StatusHexValue AS StatusColor 
                             ,U.FirstName + ' ' + U.SurName AssignToName
                             ,TU.FirstName + ' ' + TU.SurName TestedByUserName
                             ,U.ProfileImage AssignToProfileImage  
                             ,TotalCount = COUNT(1) OVER()
                             ,CASE WHEN (SELECT COUNT(1) FROM TestRunSelectedCase TRSC 
                                                                          INNER JOIN TestCase TC1 ON TC1.Id = TRSC.TestCaseId AND TC1.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
                                                                          INNER JOIN TestSuiteSection TSS ON TSS.Id = TC1.SectionId AND TSS.InActiveDateTime IS NULL
                                                                          INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
                                                                          INNER JOIN TestRun TR1 ON TR1.Id = TRSC.TestRunId AND TRSC.InActiveDateTime IS NULL AND TR1.InActiveDateTime IS NULL
                                                                         WHERE TRSC.TestCaseId = TCR.TestCaseId  AND TRSC.TestRunId = TCR.TestRunId)>0 THEN 0 ELSE 1 END AS IsDeleted
                             ,TC.CreatedByUserId
                               FROM  TestCasesReport TCR INNER JOIN   TestCase TC WITH(NOLOCK) ON TCR.TestCaseId = TC.Id AND TCR.InActiveDateTime IS NULL AND (@ReportId IS NULL OR TCR.ReportId = @ReportId)
                               INNER JOIN TestCaseStatus TCS  WITH (NOLOCK) ON TCR.StatusId = TCS.Id AND TCS.InactiveDateTime IS NULL
                               LEFT JOIN [User]TU  WITH (NOLOCK) ON TU.Id = TCR.TestedByUserId
                               LEFT JOIN [User]U  WITH (NOLOCK) ON U.Id = TCR.AssignToId
                               WHERE TCR.ReportId = TRR.Id
                               ORDER BY TCS.CreatedDateTime,TCS.[TimeStamp]
							    OFFSET ((@PageNumber - 1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
                               FOR XML PATH('TestRailReportsMiniModel'), ROOT('TestCaseModel'), TYPE) AS TestCasesXml,
                     TotalCount = COUNT(1) OVER()
                FROM  TestRailReport TRR WITH (NOLOCK) INNER JOIN Project P WITH(NOLOCK) ON P.Id = TRR.ProjectId AND P.InActiveDateTime IS NULL AND TRR.InActiveDateTime IS NULL
				                                       INNER JOIN TestRailReport TRR1 ON TRR1.Id = TRR.Id 
                                                       LEFT JOIN  Milestone M WITH(NOLOCK) ON M.Id = TRR.MilestoneId -- AND M.InActiveDateTime IS NULL
                                                       INNER JOIN [User]U WITH(NOLOCK) ON U.Id = TRR.CreatedByUserId
                WHERE P.CompanyId = @CompanyId
                     AND (@MilestoneId IS NULL OR TRR.MilestoneId = @MilestoneId)
                     AND (@ReportId IS NULL OR TRR.Id = @ReportId)
                     AND (@ProjectId IS NULL OR TRR.ProjectId = @ProjectId)
             ORDER BY TRR.CreatedDateTime
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
