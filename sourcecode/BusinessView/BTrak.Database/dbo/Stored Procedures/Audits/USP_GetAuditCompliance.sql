CREATE PROCEDURE [dbo].[USP_GetAuditCompliance]
(
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @MultipleAuditIdsXml XML = NULL,
   @AuditComplianceName NVARCHAR(150) = NULL,
   @AuditDescription NVARCHAR(800) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @UserId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @IsForFilter BIT = NULL 
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  --IF(@IsArchived IS NULL)SET @IsArchived = 0

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)

		  CREATE TABLE #AuditIds
          (
            AuditId UNIQUEIDENTIFIER
          )
          IF(@MultipleAuditIdsXml IS NOT NULL)
          BEGIN
            
            INSERT INTO #AuditIds
            SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @MultipleAuditIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
          
          END
           
		  SELECT AC.Id AS AuditId,
				 AC.AuditName,
				 AC.[Description] AS AuditDescription,
				 AC.[IsRAG],
				 AC.[CanLogTime],
				 AC.[InboundPercent] AS InBoundPercent,
				 AC.[OutboundPercent] AS OutBoundPercent,
				 AC.CreatedByUserId,
				 AC.CreatedDateTime,
				 AC.UpdatedDateTime,
				 AC.[TimeStamp],
				 AC.SpanInYears,
				 AC.SpanInMonths,
				 AC.SpanInDays,
				 (SELECT CE.CronExpression,
				 CE.JobId,
				 CE.Id AS CronExpressionId,
				 CE.IsPaused,
				 CE.EndDate AS ScheduleEndDate,
				 CE.ConductStartDate,
				 CE.ConductEndDate,
				 CE.[TimeStamp] AS CronExpressionTimeStamp,
				 ACSD.SpanInYears,
				 ACSD.SpanInMonths,
				 ACSD.SpanInDays,
				 CASE WHEN EXISTS(SELECT Id FROM CustomField F WHERE ReferenceId = AC.Id AND  F.InactiveDateTime IS NULL) THEN 1 ELSE 0 END HaveCustomFields, 
				 CE.ResponsibleUserId,
				 (	SELECT DISTINCT ASQ.AuditQuestionId [QuestionId], AC.Id [AuditCategoryId] from AuditSelectedQuestion ASQ
					INNER JOIN AuditQuestions AQ ON ASQ.AuditQuestionId = AQ.Id 
					INNER JOIN AuditCategory AC ON AQ.AuditCategoryId = AC.Id AND ASQ.AuditComplianceId = AC.AuditComplianceId WHERE AuditSchedulingDetailsId = ACSD.Id FOR JSON PATH) [SelectedQuestions]
				 FROM  CronExpression CE
				 INNER JOIN [AuditComplianceSchedulingDetails] ACSD ON ACSD.AuditComplianceId = AC.Id AND ACSD.CronExpressionId = CE.Id AND ACSD.InActiveDateTime IS NULL
				  WHERE CE.CustomWidgetId = AC.Id AND CE.InActiveDateTime IS NULL FOR JSON PATH) [SchedulingDetailsString],
				  (SELECT CAST(CAST(SUM(ISNULL(AQ.EstimatedTime,0)) AS FLOAT) AS NVARCHAR(250)) Estimate 
                    FROM AuditQuestions AQ INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
	                WHERE ACC.AuditComplianceId = AC.Id) AS TotalEstimatedTime,
				 (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 U.ProfileImage AS CreatedByProfileImage,
				 UUU.FirstName + ' ' + ISNULL(UUU.SurName,'') AS ResponsibleUserName,
				 UUU.ProfileImage AS ResponsibleProfileImage,
				 AC.ResposibleUserId  ResponsibleUserId,
				 ISNULL((SELECT COUNT(1) FROM AuditCategory AC1 WHERE AC1.AuditComplianceId = AC.Id AND AC1.InActiveDateTime IS NULL),0) AS AuditCategoriesCount,
                 ISNULL((SELECT COUNT(1) FROM AuditQuestions AQ1 INNER JOIN AuditCategory AC1 ON AC1.Id = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
									                      INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                                                            WHERE AC1.AuditComplianceId = AC.Id AND AQ1.InActiveDateTime IS NULL),0) AS AuditQuestionsCount
                ,ISNULL((SELECT COUNT(1) FROM AuditConduct WHERE [AuditComplianceId] = AC.Id AND InactiveDateTime IS NULL),0) AS ConductsCount
				,(SELECT AG.TagId,AG.TagName FROM AuditTags AG WHERE AG.AuditId = AC.Id AND AG.InActiveDateTime IS NULL AND AG.AuditConductId IS NULL FOR XML PATH('AuditTagsModel'), ROOT('AuditTagsModel'), TYPE) AS AuditTagsModelXml
				,AC.EnableQuestionLevelWorkFlow
				,AC.AuditFolderId ParentAuditId
				,AF.AuditFolderName ParentAuditName
				,AC.ProjectId
				,P.ProjectName
				,1 IsAudit
				,AC.EnableWorkFlowForAudit
				,AC.EnableWorkFlowForAuditConduct
				,GS.[Status]
				,CASE WHEN EXISTS(SELECT 1 FROM AuditComplianceVersions WHERE AuditId = AC.Id AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END AS HaveAuditVersions
				,GS.WorkflowId AS AuditWorkFlowId
		  FROM AuditCompliance AC
		  JOIN [User] U ON AC.CreatedByUserId = U.Id
		  JOIN [User] UUU ON AC.ResposibleUserId = UUU.Id
		  LEFT JOIN [GenericStatus] GS ON GS.ReferenceId = AC.Id AND GS.CompanyId = @CompanyId AND GS.ReferenceTypeId = '1618EA33-ACE8-4838-9658-B8E713CEB9DB' AND GS.IsArchived IS NULL
		  LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN(
                             SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL OR BU.BusinessUnitId IS NOT NULL,1,0) AS Permission
		                            FROM AuditTags AG
			                 	    JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 	    LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
                                          AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
			                 	    LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
									LEFT JOIN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](@OperationsPerformedBy,@CompanyId,NULL)) BU ON BU.BusinessUnitId = AG.TagId
			                 	    ) T ON T.AuditId = A.Id
					LEFT JOIN ( SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			                 	    WHERE A.CompanyId = @CompanyId
									      AND (@ProjectId IS NULL OR @ProjectId = A.ProjectId)
			                 	    AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
									--AND (@BusinessUnitIds IS NULL OR T.Permission = 1) 
			                 	    GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = AC.Id
          LEFT JOIN #AuditIds T ON T.AuditId = AC.Id
		  LEFT JOIN AuditFolder AF ON AF.Id = AC.AuditFolderId AND AF.InActiveDateTime IS NULL
		  LEFT JOIN Project P ON P.Id = AC.ProjectId AND P.CompanyId = @CompanyId
		  WHERE AC.CompanyId = @CompanyId
				--AND (@IsForFilter = 1 OR (@AuditComplianceId IS NOT NULL OR GS.[Status] = 'Approved')) 
				AND (@IsForFilter = 1 OR (@AuditComplianceId IS NOT NULL OR ((AC.EnableWorkFlowForAudit = 1 AND GS.[Status] = 'Approved') OR (AC.EnableWorkFlowForAudit = 0 OR AC.EnableWorkFlowForAudit IS NULL)))) 
				AND (@ProjectId IS NULL OR @ProjectId = AC.ProjectId)
		        AND (@AuditComplianceId IS NULL OR AC.Id = @AuditComplianceId)
				AND (@UserId IS NULL OR U.Id = @UserId)
		        AND (@AuditComplianceName IS NULL OR AuditName = @AuditComplianceName)
				AND (@AuditDescription IS NULL OR AC.[Description] = @AuditDescription)
				--AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
				AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
				AND (@SearchText IS NULL OR AuditName LIKE  '%'+ @SearchText +'%' OR AC.[Description] LIKE '%'+ @SearchText +'%')
				AND (@IsArchived IS NULL OR ((@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL)))
                AND (@MultipleAuditIdsXml IS NULL OR T.AuditId IS NOT NULL)
		 ORDER BY AuditName ASC
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END