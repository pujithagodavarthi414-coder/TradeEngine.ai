-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the Milestones By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetProjectOverviewReportById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId = '53C96173-0651-48BD-88A9-7FC79E836CCE'

CREATE PROCEDURE [dbo].[USP_GetProjectOverviewReportById]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@TimeFrame INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

	 DECLARE @HavePermission NVARCHAR(250) =   (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

			DECLARE @StartDate DATETIME = DATEADD(DAY,-@TimeFrame,CONVERT(DATE,GETDATE()))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
				   ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
				   ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
				   ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
				   ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
				   ,COUNT(1) AS TotalCount 
		    FROM TestSuite TS 
			     INNER JOIN Project P ON P.Id = TS.ProjectId 
		  	     INNER JOIN TestCase TC ON TC.TestSuiteId = TS.Id 
		         INNER JOIN  TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
                 LEFT JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId 
		    WHERE P.Id = @ProjectId 
		  		  AND P.CompanyId = @CompanyId 
		  		  AND TC.CreatedDateTime > = @StartDate 
				  AND P.InActiveDateTime IS NULL 
				  AND TC.InActiveDateTime IS NULL
				  AND TS.InActiveDateTime IS NULL
			      AND TCS.InActiveDateTime IS NULL

	END
    ELSE
    BEGIN

	   RAISERROR (@HavePermission,11, 1)

	END
	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO