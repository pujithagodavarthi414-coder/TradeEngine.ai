CREATE PROCEDURE [dbo].[USP_GetAuditComplianceBasedOnVersionId]
(
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @AuditComplianceVersionId UNIQUEIDENTIFIER = NULL,
   @MultipleAuditIdsXml XML = NULL,
   @AuditComplianceName NVARCHAR(150) = NULL,
   @AuditDescription NVARCHAR(800) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @UserId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditComplianceVersions WHERE Id = @AuditComplianceVersionId)

   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  IF(@IsArchived IS NULL)SET @IsArchived = 0

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  --DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
				--										AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
				--										                      WHERE ProjectId = @ProjectId 
				--															        AND UserId = @OperationsPerformedBy
				--																	AND InActiveDateTime IS NULL
				--															)
				--										AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)

		  CREATE TABLE #AuditIds
          (
            AuditId UNIQUEIDENTIFIER
          )
          IF(@MultipleAuditIdsXml IS NOT NULL)
          BEGIN
            
            INSERT INTO #AuditIds
            SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @MultipleAuditIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
          
          END
           
		  SELECT AC.AuditId AS AuditId,
			     AC.Id AS AuditVersionId,
				 AC.AuditName,
				 AC.[Description] AS AuditDescription,
				 AC.[IsRAG],
				 AC.[CanLogTime],
				 AC.[InboundPercent] AS InBoundPercent,
				 AC.[OutboundPercent] AS OutBoundPercent,
				 AC.CreatedByUserId,
				 AC.CreatedDateTime,
				 NULL AS UpdatedDateTime,
				 NULL AS [TimeStamp],
				 --AC.SpanInYears,
				 --AC.SpanInMonths,
				 --AC.SpanInDays,
						 --TODO
				 --(SELECT CE.CronExpression,
					--	 CE.JobId,
					--	 CE.Id AS CronExpressionId,
					--	 CE.IsPaused,
					--	 CE.EndDate AS ScheduleEndDate,
					--	 CE.ConductStartDate,
					--	 CE.ConductEndDate,
					--	 CE.[TimeStamp] AS CronExpressionTimeStamp,
					--	 ACSD.SpanInYears,
					--	 ACSD.SpanInMonths,
					--	 ACSD.SpanInDays,
					--	 CE.ResponsibleUserId,
					--	 (	SELECT DISTINCT ASQ.AuditQuestionId [QuestionId], AC.Id [AuditCategoryId] 
					--	    FROM AuditSelectedQuestion ASQ
					--	 	INNER JOIN AuditQuestionVersions AQ ON ASQ.AuditQuestionId = AQ.Id 
					--	 	INNER JOIN AuditCategoryVersions AC ON AQ.AuditCategoryId = AC.Id AND ASQ.AuditComplianceId = AC.AuditComplianceId WHERE AuditSchedulingDetailsId = ACSD.Id FOR JSON PATH) [SelectedQuestions]
					--	 FROM  CronExpression CE
					--	 INNER JOIN [AuditComplianceSchedulingDetails] ACSD ON ACSD.AuditComplianceId = AC.AuditId AND ACSD.CronExpressionId = CE.Id AND ACSD.InActiveDateTime IS NULL
					--	  WHERE CE.CustomWidgetId = AC.AuditId AND CE.InActiveDateTime IS NULL 
				 --FOR JSON PATH) [SchedulingDetailsString],
				  (SELECT CAST(CAST(SUM(ISNULL(AQ.EstimatedTime,0)) AS FLOAT) AS NVARCHAR(250)) Estimate 
                    FROM AuditQuestionVersions AQ 
					     INNER JOIN AuditCategoryVersions ACC ON ACC.Id = AQ.AuditCategoryId 
						            AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
	                WHERE ACC.AuditComplianceVersionId = AC.Id
					      AND AQ.AuditComplianceVersionId = AC.Id) AS TotalEstimatedTime,
				 (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 U.ProfileImage AS CreatedByProfileImage,
				 UUU.FirstName + ' ' + ISNULL(UUU.SurName,'') AS ResponsibleUserName,
				 UUU.ProfileImage AS ResponsibleProfileImage,
				 AC.ResposibleUserId  ResponsibleUserId,
				 ISNULL((SELECT COUNT(1) FROM AuditCategoryVersions AC1 
				          WHERE AC1.AuditComplianceVersionId = AC.Id AND AC1.InActiveDateTime IS NULL),0) AS AuditCategoriesCount,
                 ISNULL((SELECT COUNT(1) FROM AuditQuestionVersions AQ1 
				            INNER JOIN AuditCategoryVersions AC1 ON AC1.Id = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
							INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                                        WHERE AC1.AuditComplianceVersionId = AC.Id 
										      AND AQ1.AuditComplianceVersionId = AC.Id
										      AND AQ1.InActiveDateTime IS NULL),0) AS AuditQuestionsCount
                ,ISNULL((SELECT COUNT(1) FROM AuditConduct WHERE [AuditComplianceId] = AC.AuditId AND InactiveDateTime IS NULL),0) AS ConductsCount
				,(SELECT AG.TagId,AG.TagName FROM AuditTagVersions AG WHERE AG.AuditComplianceVersionId = AC.Id AND AG.InActiveDateTime IS NULL FOR XML PATH('AuditTagsModel'), ROOT('AuditTagsModel'), TYPE) AS AuditTagsModelXml
				,AC.EnableQuestionLevelWorkFlow
				,AC.AuditFolderId ParentAuditId
				,AF.AuditFolderName ParentAuditName
				,AC.ProjectId
				,P.ProjectName
				,1 IsAudit
				,CASE WHEN EXISTS(SELECT 1 FROM AuditComplianceVersions WHERE AuditId = AC.Id AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END AS HaveAuditVersions
				,AC.Id AS AuditVersionId
		  FROM AuditComplianceVersions AC
		  JOIN [User] U ON AC.CreatedByUserId = U.Id
		  JOIN [User] UUU ON AC.ResposibleUserId = UUU.Id
          LEFT JOIN #AuditIds T ON T.AuditId = AC.Id
		  LEFT JOIN AuditFolder AF ON AF.Id = AC.AuditFolderId AND AF.InActiveDateTime IS NULL
		  LEFT JOIN Project P ON P.Id = AC.ProjectId AND P.CompanyId = @CompanyId
		  WHERE AC.CompanyId = @CompanyId
				AND (@ProjectId IS NULL OR @ProjectId = AC.ProjectId)
		        AND (@AuditComplianceId IS NULL OR AC.AuditId = @AuditComplianceId)
		        AND (@AuditComplianceVersionId IS NULL OR AC.Id = @AuditComplianceVersionId)
				AND (@UserId IS NULL OR U.Id = @UserId)
		        AND (@AuditComplianceName IS NULL OR AuditName = @AuditComplianceName)
				AND (@AuditDescription IS NULL OR AC.[Description] = @AuditDescription)
				AND (@SearchText IS NULL OR AuditName LIKE  '%'+ @SearchText +'%' OR AC.[Description] LIKE '%'+ @SearchText +'%')
				AND ((@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL))
                AND (@MultipleAuditIdsXml IS NULL OR T.AuditId IS NOT NULL)
		 ORDER BY AuditName ASC
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
