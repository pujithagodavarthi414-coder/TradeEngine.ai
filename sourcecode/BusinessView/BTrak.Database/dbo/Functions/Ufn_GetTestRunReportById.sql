-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestCases Counts
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from TestRun
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetTestRunReportById]('447E6195-6FBA-42F7-A413-D8CAE46A3421','127133F1-4427-4149-9DD6-B02E0E036971')

CREATE FUNCTION [dbo].[Ufn_GetTestRunReportById]
(
    @TestRunId UNIQUEIDENTIFIER  = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@MilestoneId UNIQUEIDENTIFIER  = NULL
)
RETURNS @TestCaseCount TABLE
(
    PassedCount INT,
    BlockedCount INT,
    RetestCount INT,
    FailedCount INT,
    UntestedCount INT,
	BlockedPercent FLOAT, 
	FailedPercent FLOAT,
	PassedPercent FLOAT,
	RetestPercent FLOAT,
	UntestedPercent FLOAT,
    TotalCount INT

)
AS
BEGIN 
    
	            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
      
                   INSERT INTO @TestCaseCount (BlockedCount,FailedCount,PassedCount,RetestCount,UntestedCount,BlockedPercent,FailedPercent,PassedPercent,RetestPercent,UntestedPercent,TotalCount)
                           
						   SELECT 
                                  T.BlockedCount,
                                  T.FailedCount,
                                  T.PassedCount,
                                  T.RetestCount,
                                  T.UntestedCount,
                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
							      T.TotalCount
		                       FROM 
							   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
                                      ,COUNT(1) AS TotalCount
                               FROM TestRunSelectedCase TRSC
                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
			                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
			                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
                               WHERE (@TestRunId IS NULL OR TRSC.TestRunId = @TestRunId)
							        AND (@MilestoneId IS NULL OR TR.MilestoneId = @MilestoneId)
									AND  TRSC.InActiveDateTime IS NULL
									)T

RETURN
        
END
GO