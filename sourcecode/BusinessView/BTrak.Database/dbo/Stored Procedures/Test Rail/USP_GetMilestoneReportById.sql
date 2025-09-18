-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the Milestones By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetMilestoneReportById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@MilestoneId = 'E01507FF-91CA-472E-82D4-741101CBC782'

CREATE PROCEDURE [dbo].[USP_GetMilestoneReportById]
(
	@MilestoneId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @TestRunIds TABLE 
		(
			Id INT IDENTITY(1,1),
			TestRunId UNIQUEIDENTIFIER
        )

		DECLARE @MilestoneReport TABLE 
		(
			PassedCount INT,
			BlockedCount INT,
			RetestCount INT,
			FailedCount INT,
			UntestedCount INT,
			TotalCount INT
		)
		
		INSERT INTO @TestRunIds(TestRunId)
		SELECT Id FROM TestRun WHERE MilestoneId = @MilestoneId

		DECLARE @Count INT = 1
		DECLARE @TestRunId UNIQUEIDENTIFIER

		WHILE (@Count <= (SELECT COUNT(1) FROM @TestRunIds))
		BEGIN

            SELECT @TestRunId = (SELECT TestRunId FROM @TestRunIds WHERE Id = @Count)

			INSERT INTO @MilestoneReport(PassedCount,BlockedCount,RetestCount,FailedCount,UntestedCount,TotalCount)
			EXEC [dbo].[USP_GetTestRunReportById] @OperationsPerformedBy = @OperationsPerformedBy,@TestRunId = @TestRunId

            SET @Count = @Count + 1

		END

        SELECT SUM(PassedCount) AS PassedCount  
               ,SUM(BlockedCount) AS BlockedCount
               ,SUM(RetestCount) AS RetestCount
               ,SUM(FailedCount) AS FailedCount
               ,SUM(UntestedCount) AS UntestedCount
               ,SUM(TotalCount) AS TotalCount 
          FROM @MilestoneReport

	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO

