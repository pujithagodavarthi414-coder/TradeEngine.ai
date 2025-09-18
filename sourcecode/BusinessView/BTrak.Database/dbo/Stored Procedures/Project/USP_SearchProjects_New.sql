-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-08 00:00:00.000'
-- Purpose      To Search the project By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SearchProjects_New] @OperationsPerformedBy='539CA415-4EE0-4562-ACAF-0B32EB6247D4',@SearchText = 'tag:user'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchProjects_New]
(
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @ProjectName NVARCHAR(250) = NULL,
  @ProjectResponsiblePersonId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @ArchivedDateTime DATETIMEOFFSET = NULL,
  @ProjectStatusColor NVARCHAR(20) = NULL,
  @ProjectTypeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SearchText NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @Tags NVARCHAR(250) = NULL,
  @PageNo INT = 1,
  @PageSize INT = 10,
  @ProjectsIdsXml XML = NULL,
  @ProjectSearchFilter NVARCHAR(MAX) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
         DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		  DECLARE @EnableBugs BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
            
        IF (@HavePermission = '1')
        BEGIN
		
		--DECLARE @HaveTestRepoAccess BIT = CASE WHEN EXISTS(SELECT F.Id FROM [Feature] F INNER JOIN [RoleFeature] RF ON F.Id = RF.FeatureId AND F.InActiveDateTime IS NULL AND RF.InActiveDateTime IS NULL
		--															  INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
  --                                                                    INNER JOIN [UserRole] UR ON UR.RoleId = R.Id AND UR.UserId = @OperationsPerformedBy AND UR.InactiveDateTime IS NULL
		--															  INNER JOIN [FeatureModule] FM ON F.Id = FM.FeatureId AND FM.InActiveDateTime IS NULL
		--															  INNER JOIN [CompanyModule] CM ON FM.ModuleId = CM.ModuleId AND CM.InActiveDateTime IS NULL
		--															  AND CM.CompanyId = @CompanyId AND F.Id = '721aee4b-bb75-4db0-b351-2ba2b5505229') THEN 1 ELSE 0 END

		 DECLARE @HaveTestRepoAccess BIT = (CASE WHEN EXISTS(SELECT Id FROM RoleFeature WHERE FeatureId = '721aee4b-bb75-4db0-b351-2ba2b5505229' AND 
								  RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND InActiveDateTime IS NULL)
								  THEN 1 ELSE 0 END)

		DECLARE @ProjectNameSearch NVARCHAR(100) = NULL, @FullName NVARCHAR(100) = NULL, @ActiveGoalCount NVARCHAR(10) = NULL, @TestSuiteCount NVARCHAR(10) = NULL, @TestRunCount NVARCHAR(10) = NULL, @MilestoneCount NVARCHAR(10) = NULL,
				@ReportCount NVARCHAR(10) = NULL, @CasesCount NVARCHAR(10) = NULL, @AuditsCount NVARCHAR(10) = NULL, @ConductsCount NVARCHAR(10) = NULL, @AuditReportsCount NVARCHAR(10) = NULL, @AuditQuestionsCount NVARCHAR(10) = NULL,
				@IsSprintsConfiguration NVARCHAR(10) = NULL, @CreatedDateTime NVARCHAR(50) = NULL, @ProjectStartDate NVARCHAR(50) = NULL, @ProjectEndDate NVARCHAR(50) = NULL

	    IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
	
	    IF(@ProjectName = '') SET @ProjectName = NULL
	
        IF(@ProjectResponsiblePersonId = '00000000-0000-0000-0000-000000000000') SET @ProjectResponsiblePersonId = NULL

        IF(@ProjectTypeId = '00000000-0000-0000-0000-000000000000') SET @ProjectTypeId = NULL
	
        IF(@ProjectStatusColor = '') SET @ProjectStatusColor = NULL

		IF(@SearchText = '') SET @SearchText = NULL

		IF (@SortBy IS NULL) SET @SortBy = 'createdDateTime'

		IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		SET @SearchText = CASE WHEN @SearchText LIKE 'tag:%' THEN   ('%' + (SELECT SUBSTRING(@SearchText,5,LEN(@SearchText))) + '%') ELSE   ('%'+ @SearchText+'%') END 
		
		IF (@ProjectSearchFilter IS NOT NULL)
		BEGIN
			SELECT * INTO #ProjectSearchFilter FROM OPENJSON(@ProjectSearchFilter) WITH (Field NVARCHAR(100) '$.field',[Value] NVARCHAR(100) '$.value') ;
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'projectName') > 0)
				SET @ProjectNameSearch = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'projectName')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'fullName') > 0)
				SET @FullName = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'fullName')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'activeGoalCount') > 0)
				SET @ActiveGoalCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'activeGoalCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'testSuiteCount') > 0)
				SET @TestSuiteCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'testSuiteCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'testRunCount') > 0)
				SET @TestRunCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'testRunCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'milestoneCount') > 0)
				SET @MilestoneCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'milestoneCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'reportCount') > 0)
				SET @ReportCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'reportCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'casesCount') > 0)
				SET @CasesCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'casesCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'auditsCount') > 0)
				SET @AuditsCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'auditsCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'conductsCount') > 0)
				SET @ConductsCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'conductsCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'auditReportsCount') > 0)
				SET @AuditReportsCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'auditReportsCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'auditQuestionsCount') > 0)
				SET @AuditQuestionsCount = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'auditQuestionsCount')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'isSprintsConfiguration') > 0)
				SET @IsSprintsConfiguration = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'isSprintsConfiguration')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'createdDateTime') > 0)
				SET @CreatedDateTime = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'createdDateTime')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'projectStartDate') > 0)
				SET @ProjectStartDate = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'projectStartDate')
			IF((SELECT COUNT(*) FROM #ProjectSearchFilter WHERE Field = 'projectEndDate') > 0)
				SET @ProjectEndDate = (SELECT [Value] FROM #ProjectSearchFilter WHERE Field = 'projectEndDate')
				
		END

		 CREATE TABLE #ProjectIds
          (
                Id UNIQUEIDENTIFIER
          )
          IF(@ProjectsIdsXml IS NOT NULL) 
          BEGIN
            
            SET @ProjectId = NULL
            INSERT INTO #ProjectIds(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @ProjectsIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
          END

	    SELECT *, TotalCount = COUNT(1) OVER() FROM(
		SELECT P.Id AS ProjectId,
		       P.ProjectName,
			   P.ProjectResponsiblePersonId,
			   CASE WHEN P.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
			   P.InactiveDateTime AS ArchivedDateTime,
			   P.ProjectStatusColor,
			   P.ProjectTypeId,
			   P.IsDateTimeConfiguration,
			   P.IsSprintsConfiguration,
			   P.ProjectStartDate,
			   P.ProjectEndDate,
			   @EnableTestRepo AS EnableTestRail,
			   P.CreatedDateTime,
			   --P.CreatedByUserId,
			   --P.UpdatedByUserId,
			   --P.UpdatedDateTime,
			   U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
		       U.CompanyId,
               --U.FirstName,
               --U.SurName,
               --U.UserName AS Email,
               --'' AS [Password], --TODO: Why?
               --U.IsPasswordForceReset,
               --U.IsActive,
               --U.TimeZoneId,
               --U.MobileNo,
               --U.IsAdmin,
               --U.IsActiveOnMobile,
               U.ProfileImage,
               --U.RegisteredDateTime,
               --U.LastConnection,
			   PT.ProjectTypeName,
			   (SELECT COUNT(1) FROM TestRun TR WITH(NOLOCK) INNER JOIN TestSuite TS ON TR.TestSuiteId = TS.Id AND TS.InActiveDateTime IS NULL 
													WHERE TR.ProjectId = P.Id AND TR.InActiveDateTime IS NULL AND @HaveTestRepoAccess = 1) AS TestRunCount,
			   (SELECT COUNT(1) FROM TestSuite TS WHERE TS.ProjectId = P.Id  AND TS.InActiveDateTime IS NULL AND @HaveTestRepoAccess = 1) AS TestSuiteCount,
			   (SELECT COUNT(1) FROM Milestone M WHERE M.ProjectId = P.Id AND M.InActiveDateTime IS NULL AND @HaveTestRepoAccess = 1) AS MilestoneCount,
			   (SELECT COUNT(1) FROM TestRailReport TRR WHERE TRR.ProjectId = P.Id  AND TRR.InActiveDateTime IS NULL AND @HaveTestRepoAccess = 1) AS ReportCount,
			   (SELECT COUNT(1) FROM TestCase TC WITH(NOLOCK)
                                     INNER JOIN [dbo].[TestSuiteSection] TSS ON TSS.Id = TC.SectionId AND TSS.InactiveDateTime IS NULL 
                                     INNER JOIN [dbo].[TestSuite] TS ON TS.Id = TC.TestSuiteId AND TS.InactiveDateTime IS NULL AND TS.ProjectId = P.Id 
									 WHERE TC.InActiveDateTime IS NULL AND @HaveTestRepoAccess = 1) AS CasesCount,
			   (SELECT COUNT(1)
			    FROM Goal G WITH(NOLOCK) 
					 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
					           AND GS.IsActive = 1  
							   AND (G.InActiveDateTime IS NULL)
							   AND G.ParkedDateTime IS NULL 
					INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
				WHERE G.ProjectId=P.Id
				AND ((@EnableBugs = 0 AND (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0 )) OR @EnableBugs = 1)) AS ActiveGoalCount,
				(SELECT COUNT(1)
			    FROM Goal G WITH(NOLOCK) 
					 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND  (G.InActiveDateTime IS NULL) AND G.ParkedDateTime IS NULL
				WHERE G.ProjectId=P.Id AND G.GoalStatusColor='#ff141c') AS NumberOfReds,
				P.Tag,
				P.[TimeStamp],	
				AuditsCount = (SELECT COUNT(1)
								FROM AuditCompliance
								WHERE InActiveDateTime IS NULL
									  AND ProjectId = P.Id
								),
				ConductsCount = (SELECT COUNT(1)
								  FROM AuditConduct
								  WHERE InActiveDateTime IS NULL
								  	  AND ProjectId = P.Id
								  ),
				AuditReportsCount = (SELECT COUNT(1)
									 FROM AuditReport AR
									      INNER JOIN AuditConduct AC ON AC.Id = AR.AuditConductId
									 WHERE AR.InActiveDateTime IS NULL
									       AND AC.InActiveDateTime IS NULL
									 	  AND AC.ProjectId = P.Id
									 ),

				AuditQuestionsCount = (SELECT COUNT(1)
									   FROM AuditQuestions AQ
									        INNER JOIN AuditCategory ACT ON ACT.Id = AQ.AuditCategoryId
									        INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId
									   WHERE AQ.InActiveDateTime IS NULL
									         AND AC.InActiveDateTime IS NULL
									         AND ACT.InActiveDateTime IS NULL
									   	  AND AC.ProjectId = P.Id
									   ),
				--CASE WHEN P.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				TZ.TimeZoneAbbreviation,
				TZ.TimeZoneName,
				TZ1.TimeZoneAbbreviation StartDateTimeZoneAbbreviation,
				TZ1.TimeZoneName StartDateTimeZoneName,
				TZ2.TimeZoneAbbreviation EndDateTimeZoneAbbreviation,
				TZ2.TimeZoneName EndDateTimeZoneName
			  
        FROM [dbo].[Project] P WITH(NOLOCK) 
		    LEFT JOIN TimeZone TZ ON TZ.Id = P.CreatedDateTimeZone
			LEFT JOIN TimeZone TZ1 ON TZ1.Id = P.ProjectStartDateTimeZoneId
			LEFT JOIN TimeZone TZ2 ON TZ2.Id = P.ProjectEndDateTimeZoneId
		     LEFT JOIN [dbo].[User] U ON P.ProjectResponsiblePersonId = U.Id 
		     LEFT JOIN [dbo].[ProjectType] PT ON P.ProjectTypeId = PT.Id
			 LEFT JOIN #ProjectIds PInner ON PInner.Id = P.Id
			 --LEFT JOIN [dbo].[Userproject] UP ON UP.ProjectId = P.Id
	    WHERE (@ProjectId IS NULL OR P.Id = @ProjectId)
		       AND P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE 
					  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
			  AND P.ProjectName <> 'Adhoc project'
			  AND (@ProjectsIdsXml IS NULL OR PInner.Id IS NOT NULL)
		      AND (@ProjectName IS NULL OR P.ProjectName LIKE '%'+ @ProjectName + '%') 
			  AND (@ProjectResponsiblePersonId IS NULL OR P.ProjectResponsiblePersonId = @ProjectResponsiblePersonId) 
			  AND (@ProjectStatusColor IS NULL OR P.ProjectStatusColor = @ProjectStatusColor) 
			  AND (@ProjectTypeId IS NULL OR P.ProjectTypeId = @ProjectTypeId) 
			  AND ((ISNULL(@IsArchived,0) = 0 AND P.CompanyId = @CompanyId) OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL AND ( P.CompanyId= '00000000-0000-0000-0000-000000000000' OR P.CompanyId = @CompanyId)))
			  AND (@SearchText IS NULL OR (P.ProjectName LIKE @SearchText) OR (P.Tag LIKE @SearchText))
			  AND (@IsArchived IS NULL OR (@IsArchived = 0 AND P.InactiveDateTime IS NULL) OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL))
			  AND (@ProjectNameSearch IS NULL OR P.ProjectName LIKE '%'+ @ProjectNameSearch + '%')
			  AND (@FullName IS NULL OR U.FirstName +' '+ISNULL(U.SurName,'') LIKE '%'+ @FullName + '%')
			  )Z
			  WHERE (@ActiveGoalCount IS NULL OR ActiveGoalCount LIKE '%' + @ActiveGoalCount + '%')
				AND (@TestSuiteCount IS NULL OR TestSuiteCount LIKE '%' + @TestSuiteCount + '%')
				AND (@TestRunCount IS NULL OR TestRunCount LIKE '%' + @TestRunCount + '%')
				AND (@MilestoneCount IS NULL OR MilestoneCount LIKE '%' + @MilestoneCount  + '%')
				AND (@ReportCount IS NULL OR ReportCount LIKE '%' + @ReportCount + '%')
				AND (@CasesCount IS NULL OR CasesCount LIKE '%' + @CasesCount + '%')
				AND (@AuditsCount IS NULL OR AuditsCount LIKE '%' + @AuditsCount + '%')
				AND (@ConductsCount IS NULL OR ConductsCount LIKE '%' + @ConductsCount + '%')
				AND (@AuditReportsCount IS NULL OR AuditReportsCount LIKE '%' + @AuditReportsCount + '%')
				AND (@AuditQuestionsCount IS NULL OR AuditQuestionsCount LIKE '%' + @AuditQuestionsCount + '%')
				AND (@IsSprintsConfiguration IS NULL OR ('YES' LIKE '%' + @IsSprintsConfiguration + '%' AND IsSprintsConfiguration = 1) OR ('NO' LIKE '%' + @IsSprintsConfiguration + '%' AND IsSprintsConfiguration = 0))
				AND (@CreatedDateTime IS NULL OR (FORMAT(CreatedDateTime, 'MMM', 'en-US')  + ' ' +  CAST(DAY(CreatedDateTime) AS VARCHAR(10))+ ',' + CAST(YEAR(CreatedDateTime) AS VARCHAR(4))) LIKE '%' + @CreatedDateTime + '%')
				AND (@ProjectStartDate IS NULL OR (FORMAT(ProjectStartDate, 'MMM', 'en-US')  + ' ' +  CAST(DAY(ProjectStartDate) AS VARCHAR(10))+ ',' + CAST(YEAR(ProjectStartDate) AS VARCHAR(4))) LIKE '%' + @ProjectStartDate + '%')
				AND (@ProjectEndDate IS NULL OR (FORMAT(ProjectEndDate, 'MMM', 'en-US')  + ' ' +  CAST(DAY(ProjectEndDate) AS VARCHAR(10))+ ',' + CAST(YEAR(ProjectEndDate) AS VARCHAR(4))) LIKE '%' + @ProjectEndDate + '%')
			    ORDER BY 
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'projectName') THEN ProjectName
                              WHEN(@SortBy = 'auditsCount') THEN AuditsCount
                              WHEN @SortBy = 'conductsCount' THEN ConductsCount
                              WHEN @SortBy = 'fullName' THEN FullName
                              WHEN @SortBy = 'auditReportsCount' THEN AuditReportsCount
                              WHEN @SortBy = 'createdDateTime' THEN Cast(CreatedDateTime as sql_variant)
							  WHEN @SortBy = 'projectStartDate' THEN Cast(ProjectStartDate as sql_variant)
							  WHEN @SortBy = 'projectEndDate' THEN Cast(ProjectEndDate as sql_variant)
                              WHEN @SortBy = 'auditQuestionsCount' THEN AuditQuestionsCount
							  WHEN(@SortBy = 'testRunCount') THEN TestRunCount
                              WHEN @SortBy = 'testSuiteCount' THEN TestSuiteCount
							  WHEN(@SortBy = 'milestoneCount') THEN MilestoneCount
                              WHEN @SortBy = 'reportCount' THEN ReportCount
							  WHEN @SortBy = 'activeGoalCount' THEN ActiveGoalCount
							  WHEN @SortBy = 'isSprintsConfiguration' THEN IsSprintsConfiguration
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'projectName') THEN ProjectName
                              WHEN(@SortBy = 'auditsCount') THEN AuditsCount
                              WHEN @SortBy = 'conductsCount' THEN ConductsCount
                              WHEN @SortBy = 'fullName' THEN FullName
                              WHEN @SortBy = 'auditReportsCount' THEN AuditReportsCount
                              WHEN @SortBy = 'createdDateTime' THEN Cast(CreatedDateTime as sql_variant)
							  WHEN @SortBy = 'projectStartDate' THEN Cast(ProjectStartDate as sql_variant)
							  WHEN @SortBy = 'projectEndDate' THEN Cast(ProjectEndDate as sql_variant)
                              WHEN @SortBy = 'auditQuestionsCount' THEN AuditQuestionsCount
							  WHEN(@SortBy = 'testRunCount') THEN TestRunCount
                              WHEN @SortBy = 'testSuiteCount' THEN TestSuiteCount
							  WHEN(@SortBy = 'milestoneCount') THEN MilestoneCount
                              WHEN @SortBy = 'reportCount' THEN ReportCount
							  WHEN @SortBy = 'activeGoalCount' THEN ActiveGoalCount
							  WHEN @SortBy = 'isSprintsConfiguration' THEN IsSprintsConfiguration
                          END
                      END DESC
			  
	  OFFSET ((@PageNo - 1) * @PageSize) ROWS

        FETCH NEXT @PageSize ROWS ONLY

	   END
       ELSE
	   BEGIN

           RAISERROR (@HavePermission,11, 1)
	 
	  END
	END TRY  
	BEGIN CATCH 
		
		 RAISERROR ('Unexpected error searching for projects.',11, 1)

	END CATCH

END
