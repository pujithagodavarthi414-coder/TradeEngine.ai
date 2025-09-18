-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the Milestones By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTestRunReportById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestRunId = '987FB2BC-D536-4126-A65F-3AC82BBF3C86'

CREATE PROCEDURE [dbo].[USP_GetTestRunReportById]
(
	@TestRunId UNIQUEIDENTIFIER  = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN 
	
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                IF((SELECT IsIncludeAllCases FROM TestRun WHERE Id = @TestRunId) = 1 )
                BEGIN

                    SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
						   ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
						   ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
						   ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
						   ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
						   ,COUNT(1) AS TotalCount 
			        FROM TestRun TR 
					     INNER JOIN Project P ON P.Id = TR.ProjectId  AND TR.InActiveDateTime IS NULL
				         INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId  AND TS.InActiveDateTime IS NULL
				         INNER JOIN TestCase TC ON TC.TestSuiteId = TS.Id AND TC.InActiveDateTime IS NULL
			             INNER JOIN  TestRunSelectedCase TRSC ON TRSC.TestcaseId = TC.Id 
                         LEFT JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId 
			        WHERE TR.Id = @TestRunId 
					      AND P.CompanyId = @CompanyId 
						  AND TR.InActiveDateTime IS NULL
						  AND TC.InActiveDateTime IS NULL
						  AND TS.InActiveDateTime IS NULL
						  AND TCS.InActiveDateTime IS NULL

                END
                ELSE
                BEGIN

                    SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
					       ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
						   ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
						   ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
						   ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
						   ,COUNT(1) AS TotalCount 
			    	FROM TestRunSelectedCase TRSC
                         INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL
						 INNER JOIN Project P ON P.Id = TR.ProjectId 
				         INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId   AND TS.InActiveDateTime IS NULL
				         INNER JOIN TestCase TC ON TC.TestSuiteId = TS.Id AND TC.InActiveDateTime IS NULL
                         LEFT JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
			        WHERE TR.Id = @TestRunId 
					      AND P.CompanyId = @CompanyId 
						  AND TR.InActiveDateTime IS NULL
						  AND TC.InActiveDateTime IS NULL
						  AND TS.InActiveDateTime IS NULL
						  AND TCS.InActiveDateTime IS NULL

                END

	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation

	END CATCH
END
GO