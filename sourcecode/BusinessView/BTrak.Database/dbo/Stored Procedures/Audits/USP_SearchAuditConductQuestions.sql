CREATE PROCEDURE [dbo].[USP_SearchAuditConductQuestions]
(
   @QuestionId UNIQUEIDENTIFIER = NULL,
   @AuditConductQuestionId UNIQUEIDENTIFIER = NULL,
   @AuditCategoryId UNIQUEIDENTIFIER = NULL,
   @QuestionName NVARCHAR(250) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @AuditConductId UNIQUEIDENTIFIER = NULL,
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @IsHierarchical BIT = NULL,
   @IsForViewHistory BIT = NULL,
   @CreatedOn VARCHAR(100) = NULL,
   @UpdatedOn VARCHAR(100) = NULL,
   @SortBy VARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100) = NULL,
   @QuestionTypeFilterXml XML = NULL,
   @QuestionIdsXml XML = NULL,
   @AuditReportId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsPdf BIT = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditConductId)

   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditConduct
                                             WHERE Id = (SELECT [AuditConductId] FROM AuditReport WHERE Id = @AuditReportId)
                                            )

   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

          IF(@SearchText = '') SET @SearchText = NULL
             
          SET @SearchText = '%'+ @SearchText +'%'

          IF(@CreatedOn = 'None') SET @CreatedOn = NULL
              
          IF(@UpdatedOn = 'None') SET @UpdatedOn = NULL

          DECLARE @StartDate DATETIME
          DECLARE @EndDate DATETIME
          DECLARE @UpdateStartDate DATETIME
          DECLARE @UpdateEndDate DATETIME

          CREATE TABLE #QuestionTypeFilter
          (
            QuestionTypeId UNIQUEIDENTIFIER
          )
          IF(@QuestionTypeFilterXml IS NOT NULL)
          BEGIN
            
            INSERT INTO #QuestionTypeFilter
            SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @QuestionTypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
          
          END

          CREATE TABLE #QuestionIdFilter
          (
            QuestionId UNIQUEIDENTIFIER
          )
          IF(@QuestionIdsXml IS NOT NULL)
          BEGIN
            
            INSERT INTO #QuestionIdFilter
            SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @QuestionIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
          
          END

          IF(@CreatedOn IS NOT NULL)
          SELECT @StartDate = T.StartDate,@EndDate = T.EndDate FROM [Ufn_GetDatesWithText](@CreatedOn) T
             
          IF(@UpdatedOn IS NOT NULL)
          SELECT @UpdateStartDate = T.StartDate,@UpdateEndDate = T.EndDate FROM [Ufn_GetDatesWithText](@UpdatedOn) T

          IF(@IsHierarchical IS NULL) SET @IsHierarchical = 0
          
          IF(@IsArchived IS NULL) SET @IsArchived = 0
          
          IF(@IsForViewHistory IS NULL) SET @IsForViewHistory = 0

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          DECLARE @AuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditConduct WHERE Id = @AuditConductId)           
          
		  DECLARE @Xml XML = NULL
		  IF(@AuditReportId IS NOT NULL)
		  BEGIN
			SET @Xml = (SELECT AuditCategoryId
                               ,AuditCategoryName
							   ,AuditCategoryDescription
                               ,ParentAuditCategoryId 
                               FROM AuditConductSelectedCategory AC
							   JOIN AuditReport AR ON AC.AuditConductId = AR.AuditConductId AND AR.Id = @AuditReportId
							   AND AC.InActiveDateTime IS NULL
                               FOR XML PATH('AuditCategoryApiReturnModel'), ROOT('AuditCategoryApiReturnModel'), TYPE)

		  END
          ELSE IF(@AuditConductId IS NOT NULL AND @IsPdf = 1)
          BEGIN
                SET @Xml = (SELECT AuditCategoryId
                               ,AuditCategoryName
							   ,AuditCategoryDescription
                               ,ParentAuditCategoryId 
                               FROM AuditConductSelectedCategory ACS
							   JOIN AuditConduct AC ON AC.Id = ACS.AuditConductId AND AC.Id = @AuditConductId
							   AND AC.InActiveDateTime IS NULL
                               FOR XML PATH('AuditCategoryApiReturnModel'), ROOT('AuditCategoryApiReturnModel'), TYPE)

          END
		  SELECT *, @Xml AS CategoriesXml, @AuditReportId AS AuditReportId
		  FROM (
			SELECT  ACQ.Id AS AuditConductQuestionId,
				 IIF(ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL), 1,
				 IIF( ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
				 AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0), ACQR.CanView, 0)) AS CanView,
				 IIF(ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL), 1, 
				  IIF( ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
				 AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0), ACQR.CanEdit, 0) ) AS CanEdit,
				 IIF(ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL), 1, 
				  IIF( ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
				 AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0),ACQR.CanAddAction, 0) ) AS CanAddAction,				 
                 IIF(ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL), 1, 
				 IIF( ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
				 AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0),ACQR.NoPermission, 0) ) AS NoPermission,		
				 ACD.Id AS ConductId,
                 IIF(ACD.InActiveDateTime IS NULL,0,1) AS IsConductArchived,
                 ACD.AuditConductName AS ConductName,
                 ACQ.QuestionId,
                 ACQ.QuestionName,
                 ACQ.QuestionHint,
                 ACQ.EstimatedTime,
                 ACQ.QuestionDescription,
                 ACQ.IsMandatory AS IsQuestionMandatory,	
                 ACQ.QuestionTypeId,
                 IIF(ACQ.InActiveDateTime IS NULL,0,1) AS IsArchived,
                 ACQ.CreatedByUserId,
                 ACQ.CreatedDateTime,
                 ACQ.UpdatedByUserId,
                 ACQ.UpdatedDateTime,
                 CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
                 UU.FirstName + ' ' + ISNULL(UU.SurName,'') AS UpdatedByUserName,
                 CU.ProfileImage AS CreatedByProfileImage,
                 ACSC.AuditCategoryId,
                 ACSC.AuditCategoryName,
                 ACSC.ParentAuditCategoryId,
                 ACM.Id AS AuditId,
				 ACM.EnableQuestionLevelWorkFlow EnableQuestionLevelWorkFlowInAudit,
				 IIF(IIF(EXISTS(SELECT Id FROM GenericStatus Where ReferenceId = ACQ.QuestionId OR ReferenceId = ACQ.Id),1, 0) = 1 AND IIF(ACM.EnableQuestionLevelWorkFlow = 1,1,0) = 1, 1, 0)AS EnableQuestionLevelWorkFlow,
				 --(SELECT C.Id AS DocumentId,
					--	DocumentName, DocumentOrder, IsDocumentMandatory, U.[FileName] [Name], U.FileExtension, U.FilePath  FROM ConductQuestionDocuments C 
					--	LEFT JOIN UploadFile U ON U.QuestionDocumentId = C.Id WHERE ConductQuestionId = ACQ.Id AND ACQ.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
					--	ORDER BY DocumentOrder FOR XML PATH('DocumentModel'), ROOT('DocumentModel'), TYPE) DocumentsXml,
					(SELECT C.Id AS DocumentId,
						DocumentName, DocumentOrder, IsDocumentMandatory, U.[FileName] [Name], U.FileExtension, U.FilePath  FROM ConductQuestionDocuments C 
						LEFT JOIN  (SELECT [FileName],FileExtension,FilePath,QuestionDocumentId FROM UploadFile WHERE   InActiveDateTime IS NULL) as U on u.QuestionDocumentId = C.Id
						WHERE ConductQuestionId = ACQ.Id
						ORDER BY DocumentOrder FOR XML PATH('DocumentModel'), ROOT('DocumentModel'), TYPE) DocumentsXml,
                 UU.ProfileImage AS UpdatedByUserProfileImage,
                 ACQ.QuestionTypeName,
                 ACQ.MasterQuestionTypeId,
                 AI.ImpactName,
                 AP.PriorityName,
                 AR.RiskName,
                 ACQ.QuestionIdentity,
				  GS.[Status],
                  GS.StatusColor,
				  GS.WorkflowId QuestionWorkflowId,
                 (SELECT WS.Id FROM Workspace WS WHERE WS.Id = ACQ.QuestionId) AS QuestionDashboardId,
                 (SELECT Id AS auditConductAnswerId,
                         QuestionTypeOptionId AS questionTypeOptionId,
                         QuestionTypeOptionName AS questionTypeOptionName,
                         QuestionOptionResult AS questionOptionResult,
                         CAST(Score AS NUMERIC(10,2)) AS questionOptionScore
                        FROM AuditConductAnswers
                        WHERE AuditQuestionId = ACQ.QuestionId AND AuditConductId = @AuditConductId
                        ORDER BY [Order]
                        FOR JSON PATH)
                 AS QuestionsXml,
                 (SELECT  UF.Id AS FileId,
					UF.[FileName],
					UF.FileExtension,
					UF.FilePath,
					UF.FileSize
			        FROM  [dbo].[UploadFile] UF 
			        WHERE UF.CompanyId = @CompanyId 
				  AND UF.ReferenceId = ACQ.QuestionId AND UF.InactiveDateTime IS NULL AND UF.IsQuestionDocuments IS NULL
                 FOR JSON PATH) AS QuestionFilesXml,
                 (SELECT  UF.Id AS FileId,
					UF.[FileName],
					UF.FileExtension,
					UF.FilePath,
					UF.FileSize
			        FROM  [dbo].[UploadFile] UF 
			        WHERE UF.CompanyId = @CompanyId 
				  AND UF.ReferenceId = ACQ.Id AND UF.InactiveDateTime IS NULL AND UF.IsQuestionDocuments IS NULL
                 FOR JSON PATH) AS ConductQuestionFilesXml
                 ,ACSA.QuestionTypeOptionName AS QuestionResult
                 ,ACSA.QuestionTypeOptionId
                 ,ISNULL(ACSA.Score,0) AS QuestionScore
                 ,ACSA.[TimeStamp]
                 ,IIF(ACSA.Id IS NULL,0,1) AS IsQuestionAnswered
                 ,ACSA.Id AS ConductAnswerSubmittedId
                 ,ACSA.AuditAnswerId
                 ,ACSA.AnswerComment
				 ,ACSA.QuestionDateAnswer AS QuestionResultDate
				 ,ACSA.QuestionTextAnswer AS QuestionResultText
				 ,ACSA.QuestionNumericAnswer AS QuestionResultNumeric
				 ,ACSA.QuestionTimeAnswer AS QuestionResultTime
                 ,IIF(ACSA.Id IS NULL,1,
                  IIF(EXISTS(SELECT ACA1.QuestionTypeOptionId 
                                                           FROM AuditConductAnswers ACA1 
                                                           WHERE ACA1.QuestionOptionResult = 1
                                                             AND ACA1.QuestionTypeOptionId = ACSA.QuestionTypeOptionId
                                                             AND ACA1.AuditQuestionId = ACQ.QuestionId 
                                                             AND ACA1.AuditConductId = ACD.Id
                                                             AND ACA1.InactiveDateTime IS NULL),1,
                  IIF(ACQ.MasterQuestionTypeId IN ('C1CEE1F5-B2D9-4015-BA8D-C0E28D637A2D','D628F2C7-6B90-41F6-986A-86105E2BF1A2'),
                      0,1))) AS IsAnswerValid
                  ,ISNULL((SELECT COUNT(1) 
                           FROM [UserStory]US WITH (NOLOCK)
                           INNER JOIN [AuditConductQuestions] ACQ1 ON ACQ1.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,',')) AND ACQ1.Id = ACQ.Id
				           INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL 
                                                                     AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL 
                                                                     AND UST.IsAction = 1 AND US.InActiveDateTime IS NULL AND UST.CompanyId = @CompanyId
					       INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
				           INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId
                           INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL
						   --LEFT JOIN AuditReport AR ON AR.AuditConductId = ACD.Id
						   WHERE ACQ1.[AuditConductId] = ACD.Id 
                                 --AND (@AuditReportId IS NULL 
                                 --        OR (SELECT CONVERT(DATETIME, AR.CreatedDateTime) FROM AuditReport AR WHERE AR.Id = @AuditReportId) >= CONVERT(DATETIME,US.CreatedDateTime)) 
                      ),0) AS ActionsCount
                  ,SU.FirstName + ' ' + ISNULL(SU.SurName,'') AS SubmittedByUserName
				  ,ACQ.[Order]
                  ,ACQ.QuestionResponsiblePersonId
                  ,QR.ProfileImage AS QuestionResponsiblePersonProfileImage
                  ,QR.FirstName + ' ' + ISNULL(QR.SurName,'') AS QuestionResponsiblePersonName
				  ,LAG(ACQ.QuestionId) OVER(ORDER BY ACSC.[Order], len(ACQ.QuestionIdentity), ACQ.QuestionIdentity, ACQ.[Order]) PreviousQuestion
				  ,LEAD(ACQ.QuestionId) OVER(ORDER BY ACSC.[Order], len(ACQ.QuestionIdentity), ACQ.QuestionIdentity, ACQ.[Order]) NextQuestion
                  FROM AuditConduct ACD
                  JOIN AuditConductQuestions ACQ ON ACD.Id = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND (ACD.Id = @AuditConductId OR @AuditConductId IS NULL)
                  JOIN AuditConductSelectedCategory ACSC ON ACSC.AuditCategoryId = ACQ.AuditCategoryId AND ACSC.AuditConductId = ACQ.AuditConductId
                  JOIN [User] CU ON CU.Id = ACQ.CreatedByUserId
                  JOIN AuditCompliance ACM ON ACM.Id = ACSC.AuditComplianceId AND (ACM.Id = @AuditComplianceId OR @AuditComplianceId IS NULL)
                  LEFT JOIN [User] UU ON UU.Id = ACQ.UpdatedByUserId
                  LEFT JOIN [User] QR ON QR.Id = ACQ.QuestionResponsiblePersonId
                  LEFT JOIN AuditConductSubmittedAnswer ACSA ON ACSA.ConductId = ACD.Id AND ACSA.QuestionId = ACQ.QuestionId AND ACSA.InActiveDateTime IS NULL
                  LEFT JOIN [User] SU ON SU.Id = ISNULL(ACSA.UpdatedByUserId,ACSA.CreatedByUserId)
                  LEFT JOIN #QuestionTypeFilter QTF ON QTF.QuestionTypeId = ACQ.QuestionTypeId
                  LEFT JOIN #QuestionIdFilter QIF ON QIF.QuestionId = ACQ.QuestionId
                  LEFT JOIN AuditImpact AI ON AI.Id = ACQ.ImpactId  
                  LEFT JOIN AuditPriority AP ON AP.Id = ACQ.PriorityId
      LEFT JOIN AuditRisk AR ON AR.Id = ACQ.RiskId
				  LEFT JOIN ConductQuestionRoleConfiguration ACQR ON ACQR.AuditQuestionId = ACQ.QuestionId AND ACQR.ConductQuestionId = ACQ.Id
				 --  AND (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
				 --AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0
	   LEFT JOIN [GenericStatus] GS ON GS.ReferenceId =  ACQ.Id AND GS.CompanyId = @CompanyId AND GS.IsArchived IS NULL
                  WHERE (@AuditConductQuestionId  IS NULL OR ACQ.Id = @AuditConductQuestionId )
					AND (@SearchText IS NULL OR ACQ.QuestionName LIKE @SearchText OR ACQ.QuestionIdentity LIKE @SearchText)
                    AND (@CreatedOn IS NULL OR (CONVERT(DATE,ACQ.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,ACQ.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
                    AND (@UpdatedOn IS NULL OR (CONVERT(DATE,ACQ.CreatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,ACQ.CreatedDateTime) <= CONVERT(DATE,@UpdateEndDate))) 
                    AND (@QuestionTypeFilterXml IS NULL OR QTF.QuestionTypeId IS NOT NULL)
                    AND (@QuestionIdsXml IS NULL OR QIF.QuestionId IS NOT NULL)
                    AND (@AuditReportId IS NULL OR ACD.Id = (SELECT AuditConductId FROM AuditReport AR WHERE AR.Id = @AuditReportId))
				) AS TEMP
				WHERE (QuestionId = @QuestionId OR @QuestionId IS NULL)
				AND (@AuditCategoryId IS NULL OR (@IsHierarchical = 0 AND AuditCategoryId = @AuditCategoryId) OR (@IsHierarchical = 1 AND AuditCategoryId IN (SELECT AuditCategoryId FROM [dbo].[Ufn_GetChildAuditCategories](@AuditCategoryId,0,NULL,0))))
                 ORDER BY 
                 CASE WHEN( @SortDirection = 'ASC' OR @SortDirection IS NULL ) THEN
                    CASE 
                         WHEN (@SortBy = 'CreatedOn') THEN CONVERT(NVARCHAR(250),CreatedDateTime,121) 
                         WHEN (@SortBy IS NULL) THEN  CAST([Order] AS sql_variant)
                         WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),CreatedDateTime,121)
                         WHEN  @SortBy = 'Questiontype' THEN (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = QuestionTypeId )
                         WHEN  @SortBy = 'Title' THEN QuestionName
                         WHEN  @SortBy = 'Id' THEN QuestionIdentity
                     END 
                 END  ASC ,
                 CASE WHEN @SortDirection = 'DESC' THEN
                       CASE
                         WHEN (@SortBy = 'CreatedOn') THEN CONVERT(NVARCHAR(250),CreatedDateTime,121)
                         WHEN (@SortBy IS NULL) THEN  CAST([Order] AS sql_variant)
                         WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),CreatedDateTime,121)
                         WHEN  @SortBy = 'Questiontype' THEN (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = QuestionTypeId )
                         WHEN  @SortBy = 'Title' THEN QuestionName
                         WHEN  @SortBy = 'Id' THEN QuestionIdentity
                        END	
                  END DESC, CONVERT(INT,REPLACE(QuestionIdentity,'Q-',0))

            IF(@IsForViewHistory = 1 AND @QuestionId IS NOT NULL)
            EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = NULL,
			@NewValue = NULL,@Description = 'QuestionViewed',@Field = 'AuditConductQuestion',@QuestionId = @QuestionId,
			@AuditId = @AuditId,@ConductId = @AuditConductId

        END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END