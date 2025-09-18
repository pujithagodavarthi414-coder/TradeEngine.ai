CREATE PROCEDURE [dbo].[USP_GetTrainingReports]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ReportType NVARCHAR(100)
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT C.Id CompanyId, C.CompanyName, 
		       --R.Id RegionId, R.RegionName, 
			   B.Id BranchId, B.BranchName, 
			   TC.Id TrainingCourseId, TC.CourseName TrainingCourseName, TC.ValidityInMonths,
			   U.Id UserId, E.Id EmployeeId, U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
			   TA.Id TrainingAssignmentId, TA.StatusGivenDate, TA.ValidityEndDate, IIF(TA.ValidityEndDate <= GETDATE() OR TA.StatusGivenDate > TA.ValidityEndDate,1,0) IsExpired,
			   ASS.StatusName, ASS.StatusColor, ASS.IsDefaultStatus, ASS.AddsValidity, ASS.IsExpiryStatus
		INTO #TrainingDetails
		FROM TrainingAssignment TA
		     INNER JOIN (SELECT TW.AssignmentId, MAX(TW.CreatedDateTime) CreatedDateTime 
			             FROM TrainingAssignment TA 
						      INNER JOIN TrainingWorkflow TW ON TA.Id = TW.AssignmentId AND TA.IsActive = 1 AND TW.IsActive = 1
							  INNER JOIN AssignmentStatus ASS ON ASS.Id = TW.StatusId AND ASS.CompanyId = TA.CompanyId AND ASS.IsExpiryStatus <> 1
						 GROUP BY TW.AssignmentId) TAInner ON TAInner.AssignmentId = TA.Id
		     INNER JOIN TrainingCourse TC ON TC.Id = TA.TrainingCourseId AND TA.IsActive = 1 AND TC.IsArchived = 0
			 INNER JOIN TrainingWorkflow TW ON TA.Id = TW.AssignmentId AND TW.IsActive = 1 AND TW.CreatedDateTime = TAInner.CreatedDateTime
			 INNER JOIN AssignmentStatus ASS ON ASS.Id = TW.StatusId
		     INNER JOIN [User] U ON U.Id = TA.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
			 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
			 INNER JOIN (SELECT EmployeeId, MAX(ActiveFrom) ActiveFrom FROM EmployeeBranch WHERE ISNULL(ActiveTo,CAST(GETDATE() AS DATE)) <= CAST(GETDATE() AS DATE) GROUP BY EmployeeId) EBInner ON EBInner.EmployeeId = EB.EmployeeId AND EBInner.ActiveFrom = EB.ActiveFrom
			 INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
			 --INNER JOIN Region R ON R.Id = B.RegionId AND R.InActiveDateTime IS NULL
			 INNER JOIN Company C ON C.Id = B.CompanyId AND C.InActiveDateTime IS NULL
		WHERE TC.CompanyId = @CompanyId

		IF(@ReportType = 'Company Course Level')
		BEGIN

			SELECT TD.CompanyName [Company Name], TD.TrainingCourseName [Course Name], 
			       ISNULL(AssignedQuery.TotalAssigned,0) [Total no of staff who need training], 
				   ISNULL(CompletedQuery.TotalCompleted,0) [Total in date], 
				   ISNULL(AssignedQuery.TotalAssigned,0) - ISNULL(CompletedQuery.TotalCompleted,0) [Total out of date or not trained and who need immediate training],
			       ROUND(CAST((IIF(ISNULL(AssignedQuery.TotalAssigned,0) = 0,0,ISNULL(CompletedQuery.TotalCompleted*1.0,0)/ISNULL(AssignedQuery.TotalAssigned*1.0,0)) * 100) AS NUMERIC(20,0)),0) [% Compliant]
			FROM #TrainingDetails TD
			     LEFT JOIN (SELECT CompanyId, TrainingCourseId, COUNT(1) TotalAssigned FROM #TrainingDetails GROUP BY CompanyId, TrainingCourseId) AssignedQuery ON AssignedQuery.CompanyId = TD.CompanyId AND AssignedQuery.TrainingCourseId = TD.TrainingCourseId
			     LEFT JOIN (SELECT CompanyId, TrainingCourseId, COUNT(1) TotalCompleted FROM #TrainingDetails WHERE IsExpired = 0 AND AddsValidity = 1 GROUP BY CompanyId, TrainingCourseId) CompletedQuery ON CompletedQuery.CompanyId = TD.CompanyId AND CompletedQuery.TrainingCourseId = TD.TrainingCourseId
			GROUP BY TD.CompanyName, TD.TrainingCourseName, AssignedQuery.TotalAssigned, CompletedQuery.TotalCompleted

		END

		--ELSE IF(@ReportType = 'Region Course Level')
		--BEGIN

		--	SELECT TD.RegionName [Region Name], TD.TrainingCourseName [Course Name], 
		--	       ISNULL(AssignedQuery.TotalAssigned,0) [Total no of staff who need training], 
		--		   ISNULL(CompletedQuery.TotalCompleted,0) [Total in date], 
		--		   ISNULL(AssignedQuery.TotalAssigned,0) - ISNULL(CompletedQuery.TotalCompleted,0) [Total out of date or not trained and who need immediate training],
		--	       ROUND(CAST((IIF(ISNULL(AssignedQuery.TotalAssigned,0) = 0,0,ISNULL(CompletedQuery.TotalCompleted*1.0,0)/ISNULL(AssignedQuery.TotalAssigned*1.0,0)) * 100) AS NUMERIC(20,0)),0) [% Compliant]
		--	FROM #TrainingDetails TD
		--	     LEFT JOIN (SELECT RegionId, TrainingCourseId, COUNT(1) TotalAssigned FROM #TrainingDetails GROUP BY RegionId, TrainingCourseId) AssignedQuery ON AssignedQuery.RegionId = TD.RegionId AND AssignedQuery.TrainingCourseId = TD.TrainingCourseId
		--         LEFT JOIN (SELECT RegionId, TrainingCourseId, COUNT(1) TotalCompleted FROM #TrainingDetails WHERE IsExpired = 0 AND AddsValidity = 1 GROUP BY RegionId, TrainingCourseId) CompletedQuery ON CompletedQuery.RegionId = TD.RegionId AND CompletedQuery.TrainingCourseId = TD.TrainingCourseId
		--	GROUP BY TD.RegionName, TD.TrainingCourseName, AssignedQuery.TotalAssigned, CompletedQuery.TotalCompleted
		--	ORDER BY TD.TrainingCourseName

		--END

		ELSE IF(@ReportType = 'Branch Course Level')
		BEGIN

			SELECT TD.BranchName [Branch Name], TD.TrainingCourseName [Course Name], 
			       ISNULL(AssignedQuery.TotalAssigned,0) [Total no of staff who need training], 
				   ISNULL(CompletedQuery.TotalCompleted,0) [Total in date], 
				   ISNULL(AssignedQuery.TotalAssigned,0) - ISNULL(CompletedQuery.TotalCompleted,0) [Total out of date or not trained and who need immediate training],
			       ROUND(CAST((IIF(ISNULL(AssignedQuery.TotalAssigned,0) = 0,0,ISNULL(CompletedQuery.TotalCompleted*1.0,0)/ISNULL(AssignedQuery.TotalAssigned*1.0,0)) * 100) AS NUMERIC(20,0)),0) [% Compliant]
			FROM #TrainingDetails TD
			     LEFT JOIN (SELECT BranchId, TrainingCourseId, COUNT(1) TotalAssigned FROM #TrainingDetails GROUP BY BranchId, TrainingCourseId) AssignedQuery ON AssignedQuery.BranchId = TD.BranchId AND AssignedQuery.TrainingCourseId = TD.TrainingCourseId
		         LEFT JOIN (SELECT BranchId, TrainingCourseId, COUNT(1) TotalCompleted FROM #TrainingDetails WHERE IsExpired = 0 AND AddsValidity = 1 GROUP BY BranchId, TrainingCourseId) CompletedQuery ON CompletedQuery.TrainingCourseId = TD.TrainingCourseId AND CompletedQuery.BranchId = TD.BranchId
			GROUP BY TD.BranchName, TD.TrainingCourseName, AssignedQuery.TotalAssigned, CompletedQuery.TotalCompleted
			ORDER BY TD.TrainingCourseName

		END

		ELSE IF(@ReportType = 'Course Level')
		BEGIN

			SELECT TD.TrainingCourseName [Course Name], 
			       ISNULL(AssignedQuery.TotalAssigned,0) [Total no of staff who need training], 
				   ISNULL(CompletedQuery.TotalCompleted,0) [Total in date], 
				   ISNULL(AssignedQuery.TotalAssigned,0) - ISNULL(CompletedQuery.TotalCompleted,0) [Total out of date or not trained and who need immediate training],
			       ROUND(CAST((IIF(ISNULL(AssignedQuery.TotalAssigned,0) = 0,0,ISNULL(CompletedQuery.TotalCompleted*1.0,0)/ISNULL(AssignedQuery.TotalAssigned*1.0,0)) * 100) AS NUMERIC(20,0)),0) [% Compliant]
			FROM #TrainingDetails TD
			     LEFT JOIN (SELECT TrainingCourseId, COUNT(1) TotalAssigned FROM #TrainingDetails GROUP BY TrainingCourseId) AssignedQuery ON AssignedQuery.TrainingCourseId = TD.TrainingCourseId
		         LEFT JOIN (SELECT TrainingCourseId, COUNT(1) TotalCompleted FROM #TrainingDetails WHERE IsExpired = 0 AND AddsValidity = 1 GROUP BY TrainingCourseId) CompletedQuery ON CompletedQuery.TrainingCourseId = TD.TrainingCourseId
			GROUP BY TD.TrainingCourseName, AssignedQuery.TotalAssigned, CompletedQuery.TotalCompleted

		END

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