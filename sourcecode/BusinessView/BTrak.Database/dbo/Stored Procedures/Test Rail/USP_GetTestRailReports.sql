-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Get the TestRail Reports
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestRailReports] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTestRailReports]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@Name NVARCHAR(250) = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER,
	@MilestoneId  UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
	@ReportId  UNIQUEIDENTIFIER = NULL
)		
AS
BEGIN
    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
			
		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	     IF(@HavePermission = '1')
	     BEGIN

			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			 
			 IF(@MilestoneId = '00000000-0000-0000-0000-000000000000') SET @MilestoneId = NULL
			 
			 IF(@ReportId = '00000000-0000-0000-0000-000000000000') SET @ReportId = NULL			 			 

			 SELECT  TRR.Id AS TestRailReportId, 
			         TRR.[Name] TestRailReportName,
					 TRR.[Description],
					 TRR.PdfUrl,
					 TRR.MilestoneId,
					 TRR.ProjectId,
					 TRR.TestPlanId,
					 TRR.TestRunId,
					 TRR.TestRailReportOptionId,
					 CAST(TRR.CreatedDateTime AS datetime) CreatedDateTime,
					 TRR.CreatedByUserId,
					 ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') CreatedBy,
					 U.ProfileImage CreatedByProfileImage,
					 TRR.[TimeStamp],
                     (TR.BlockedCount*100/(CASE WHEN  ISNULL(TR.TotalCount,0) = 0 THEN 1 ELSE TR.TotalCount END)) BlockedPercent, 
                     (TR.FailedCount*100/(CASE WHEN   ISNULL(TR.TotalCount,0) = 0 THEN 1 ELSE TR.TotalCount END)) FailedPercent,
                     (TR.PassedCount*100/(CASE WHEN   ISNULL(TR.TotalCount,0) = 0 THEN 1 ELSE TR.TotalCount END)) PassedPercent,
                     (TR.RetestCount*100/(CASE WHEN   ISNULL(TR.TotalCount,0) = 0 THEN 1 ELSE TR.TotalCount END)) RetestPercent,
                     (TR.UntestedCount*100/(CASE WHEN ISNULL(TR.TotalCount,0) = 0 THEN 1 ELSE TR.TotalCount END)) UntestedPercent,
					 TR.BlockedCount,
                     TR.FailedCount,
                     TR.PassedCount,
                     TR.RetestCount,
                     TR.UntestedCount,
                     TR.TotalCount ReportCasesCount,			 
				  	 TotalCount = COUNT(1) OVER()
			    FROM  TestRailReport TRR WITH (NOLOCK) INNER JOIN Project P WITH (NOLOCK) ON P.Id = TRR.ProjectId  AND TRR.InActiveDateTime IS NULL  AND P.InActiveDateTime IS NULL	    
			                                           INNER JOIN [User]U WITH(NOLOCK) ON U.Id = TRR.CreatedByUserId 
													   LEFT JOIN (SELECT COUNT(CASE WHEN IsPassed = 1 THEN  IsPassed END) AS PassedCount
                                      ,COUNT(CASE WHEN IsBlocked = 1 THEN  IsBlocked END) AS BlockedCount
                                      ,COUNT(CASE WHEN IsReTest = 1THEN IsReTest END) AS RetestCount
                                      ,COUNT(CASE WHEN IsFailed = 1 THEN  IsFailed END) AS FailedCount
                                      ,COUNT(CASE WHEN IsUntested = 1 THEN IsUntested END) AS UntestedCount
                                      ,COUNT(1) AS TotalCount,
									  TCR.ReportId
                               FROM TestCasesReport TCR INNER JOIN TestCaseStatus TCS ON TCS.Id = TCR.StatusId AND TCS.CompanyId = @CompanyId AND TCS.InActiveDateTime IS NULL
							   GROUP BY TCR.ReportId
							   ) TR ON TR.ReportId = TRR.Id
			    WHERE P.CompanyId = @CompanyId
				     AND (@MilestoneId IS NULL OR TRR.MilestoneId = @MilestoneId)
					 AND (@ReportId IS NULL OR TRR.Id = @ReportId)
				     AND (@ProjectId IS NULL OR TRR.ProjectId = @ProjectId)
					 AND (@Name IS NULL OR TRR.[Name] = @Name)
					 AND ((@DateFrom IS NULL OR TRR.CreatedDateTime >= @DateFrom) AND (@DateTo IS NULL OR TRR.CreatedDateTime <= @DateTo))
			 ORDER BY TRR.CreatedDateTime
		
	  END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,16, 1)
	  
	  END
	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation

	END CATCH

END