-------------------------------------------------------------------------------
-- Author       Rana
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get the Audit Questions 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetAuditQuestions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAuditQuestions]
(
   @QuestionId UNIQUEIDENTIFIER = NULL,
   @AuditCategoryId UNIQUEIDENTIFIER = NULL,
   @QuestionName NVARCHAR(250) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @IsHierarchical BIT = NULL,
   @IsForViewHistory BIT = NULL,
   @CreatedOn VARCHAR(100) = NULL,
   @UpdatedOn VARCHAR(100) = NULL,
   @SortBy VARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100) = NULL,
   @QuestionTypeFilterXml XML = NULL,
   @QuestionIdsXml XML = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditCompliance WHERE Id = (SELECT AuditComplianceId FROM AuditCategory WHERE Id = @AuditCategoryId))
   
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
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
           
		  IF(@IsForViewHistory	 = 1 AND @QuestionId IS NOT NULL)
          BEGIN
    
            DECLARE @QuestionHistoryId UNIQUEIDENTIFIER = NEWID()
            DECLARE @QuestionAuditId UNIQUEIDENTIFIER

            SET @QuestionAuditId = (SELECT ACC.Id FROM AuditQuestions AQ INNER JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId
                                                    INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId WHERE AQ.Id = @QuestionId)
            
            INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @QuestionHistoryId, @QuestionAuditId, NULL, @QuestionId, NULL, NULL, 'QuestionViewed', GETDATE(), @OperationsPerformedBy

          END
        
          SELECT AQ.Id AS QuestionId,
				CVDC.CanView,
				CVDC.CanEdit,
				CVDC.CanAddAction,
				CVDC.NoPermission,
				CVDC.Roles RoleIds,
				CVDC.Users SelectedEmployees,
                 AQ.QuestionName,
                 AQ.QuestionHint,
                 AQ.EstimatedTime,
                 AQ.QuestionDescription,
                 AQ.IsMandatory AS IsQuestionMandatory,
                 AQ.IsOriginalQuestionTypeScore,
                 AQ.QuestionTypeId,
				 IIF(AQ.InActiveDateTime IS NULL,0,1) AS IsArchived,
                 AQ.CreatedByUserId,
                 AQ.CreatedDateTime,
                 AQ.UpdatedByUserId,
                 AQ.UpdatedDateTime,
                 CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
                 UU.FirstName + ' ' + ISNULL(UU.SurName,'') AS UpdatedByUserName,
                 CU.ProfileImage AS CreatedByProfileImage,
                 AC.Id AS AuditCategoryId,
                 A.Id AS AuditId,
                 AI.ImpactName,
                 AQ.ImpactId ,
                 AP.PriorityName,
                 AQ.PriorityId,
                 AR.RiskName,
                 AQ.RiskId,
                 UU.ProfileImage AS UpdatedByUserProfileImage,
                 QT.QuestionTypeName,
				 QT.[IsFromMasterQuestionType] AS IsMasterQuestionType,
				 QT.TimeStamp AS QuestionTypeTimestamp,
                 MQT.Id AS MasterQuestionTypeId,
                 MQT.MasterQuestionTypeName,
                 AQ.QuestionIdentity,
                 IIF(@QuestionId IS NOT NULL,
                 (SELECT AA1.Id AS QuestionOptionId,
                         QTP1.Id As QuestionTypeOptionId,
                         QTP1.QuestionTypeOptionName AS QuestionOptionName,
                         AA1.QuestionOptionDate AS QuestionOptionDate,
                         AA1.QuestionOptionTime AS QuestionOptionTime,
                         AA1.QuestionOptionNumeric AS QuestionOptionNumeric,
                         AA1.QuestionOptionBoolean AS QuestionOptionBoolean,
                         QTP1.QuestionTypeOptionOrder AS QuestionOptionOrder,
						 AA1.QuestionOptionText,
                        ISNULL(AA1.QuestionOptionResult,0) AS QuestionOptionResult,
                         CAST(IIF(AQ.IsOriginalQuestionTypeScore = 1,QTP1.QuestionTypeOptionScore,AA1.Score) AS DECIMAL(10,2)) AS QuestionOptionScore
                         FROM AuditAnswers AA1 JOIN QuestionTypeOptions QTP1 ON AA1.QuestionTypeOptionId = QTP1.Id AND AA1.AuditQuestionId = AQ.Id
                         AND QTP1.QuestionTypeId = AQ.QuestionTypeId AND QTP1.InActiveDateTime IS NULL AND AA1.InActiveDateTime IS NULL
                         ORDER BY QTP1.QuestionTypeOptionOrder FOR XML PATH('AuditQuestionOptions'), ROOT('AuditQuestionOptions'), TYPE)
                 ,NULL) AS QuestionsXml,
				 IIF(@QuestionId IS NOT NULL,(SELECT Id AS DocumentId,
						DocumentName, DocumentOrder, IsDocumentMandatory FROM AuditQuestionDocuments WHERE AuditQuestionId = @QuestionId AND InActiveDateTime IS NULL
						ORDER BY DocumentOrder FOR XML PATH('DocumentModel'), ROOT('DocumentModel'), TYPE),NULL) AS DocumentsXml,
                 IIF(@QuestionId IS NOT NULL, 
                 (SELECT  UF.Id AS FileId,
					UF.[FileName],
					UF.FileExtension,
					UF.FilePath,
					UF.FileSize
			        FROM  [dbo].[UploadFile] UF 
			        WHERE UF.CompanyId = @CompanyId 
				  AND UF.ReferenceId = @QuestionId AND UF.InactiveDateTime IS NULL
                 FOR XML PATH('FileApiReturnModel'), ROOT('FileApiReturnModel'), TYPE)
                 ,NULL) AS QuestionFilesXml
                 ,STUFF((SELECT ',' + QTOA.QuestionTypeOptionName
                                FROM AuditAnswers AA1 
                                JOIN QuestionTypeOptions QTOA ON QTOA.Id = AA1.QuestionTypeOptionId AND QTOA.InactiveDateTime IS NULL
                                WHERE AA1.AuditQuestionId = AQ.Id AND AA1.QuestionOptionResult = 1 
                                  AND AA1.InactiveDateTime IS NULL 
                                ORDER BY QTOA.QuestionTypeOptionOrder
                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS QuestionResult
                 ,STUFF((SELECT ',' + CONVERT(NVARCHAR(20),IIF(AQ.IsOriginalQuestionTypeScore = 1, QTOA.QuestionTypeOptionScore, AA1.Score))
                                FROM AuditAnswers AA1 
                                JOIN QuestionTypeOptions QTOA ON QTOA.Id = AA1.QuestionTypeOptionId AND QTOA.InactiveDateTime IS NULL
                                WHERE AA1.AuditQuestionId = AQ.Id AND AA1.QuestionOptionResult = 1 
                                  AND AA1.InactiveDateTime IS NULL 
                                ORDER BY QTOA.QuestionTypeOptionOrder
                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS QuestionScore
				 --,AA.QuestionOptionDate AS QuestionResultDate
				 --,AA.QuestionOptionNumeric AS QuestionResultNumeric
				 --,AA.QuestionOptionBoolean AS QuestionResultBoolean
				 --,AA.QuestionOptionTime AS QuestionResultTime
				 --,AA.QuestionOptionText AS QuestionResultText
                 ,(SELECT WS.Id FROM Workspace WS WHERE WS.Id = AQ.Id) AS QuestionDashboardId
                 ,AQ.QuestionResponsiblePersonId
                 ,QR.ProfileImage AS QuestionResponsiblePersonProfileImage
                 ,QR.FirstName + ' ' + ISNULL(QR.SurName,'') AS QuestionResponsiblePersonName
                 ,AQ.[TimeStamp]
				 ,GS.[Status]
		  FROM AuditQuestions AQ
          JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId AND (AQ.Id = @QuestionId OR @QuestionId IS NULL) AND AC.InActiveDateTime IS NULL
		  LEFT JOIN AuditConductQuestionRoleConfiguration CVDC ON CVDC.AuditQuestionId = AQ.Id
		  LEFT JOIN GenericStatus GS ON GS.ReferenceId = AQ.Id AND GS.CompanyId = @CompanyId
          JOIN [User] CU ON CU.Id = AQ.CreatedByUserId
          JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL
       	  JOIN AuditCompliance A ON A.Id = AC.AuditComplianceId 
          --LEFT JOIN AuditAnswers AA ON AA.AuditQuestionId = AQ.Id AND AA.QuestionOptionResult = 1 AND AA.InactiveDateTime IS NULL
          --LEFT JOIN QuestionTypeOptions QTO ON QTO.Id = AA.QuestionTypeOptionId AND QTO.InactiveDateTime IS NULL
          LEFT JOIN [User] UU ON UU.Id = AQ.UpdatedByUserId
          LEFT JOIN [User] QR ON QR.Id = AQ.QuestionResponsiblePersonId
          LEFT JOIN #QuestionTypeFilter QTF ON (QTF.QuestionTypeId = QT.MasterQuestionTypeId  OR QTF.QuestionTypeId = QT.Id)
          LEFT JOIN MasterQuestionType MQT ON MQT.Id = QT.MasterQuestionTypeId
          LEFT JOIN #QuestionIdFilter QIF ON QIF.QuestionId = AQ.Id
          LEFT JOIN AuditImpact AI ON AI.Id = AQ.ImpactId  
          LEFT JOIN AuditPriority AP ON AP.Id = AQ.PriorityId
          LEFT JOIN AuditRisk AR ON AR.Id = AQ.RiskId
          WHERE (@AuditCategoryId IS NULL OR (@IsHierarchical = 0 AND AC.Id = @AuditCategoryId) OR (@IsHierarchical = 1 AND AC.Id IN (SELECT AuditCategoryId FROM [dbo].[Ufn_GetChildAuditCategories](@AuditCategoryId,1,NULL,0))))
            AND (@AuditComplianceId IS NULL OR A.Id = @AuditComplianceId)
            AND AQ.InActiveDateTime IS NULL
            AND A.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
            AND (@SearchText IS NULL OR AQ.QuestionName LIKE @SearchText OR AQ.QuestionIdentity LIKE @SearchText)
            AND (@CreatedOn IS NULL OR (CONVERT(DATE,AQ.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,AQ.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
            AND (@UpdatedOn IS NULL OR (CONVERT(DATE,AQ.CreatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,AQ.CreatedDateTime) <= CONVERT(DATE,@UpdateEndDate))) 
			AND (@QuestionTypeFilterXml IS NULL OR QTF.QuestionTypeId IS NOT NULL)
            AND (@QuestionIdsXml IS NULL OR QIF.QuestionId IS NOT NULL)
          ORDER BY 
            CASE WHEN( @SortDirection = 'ASC' OR @SortDirection IS NULL ) THEN
                    CASE 
                         WHEN (@SortBy = 'CreatedOn') THEN CONVERT(NVARCHAR(250),AQ.CreatedDateTime,121) 
                         WHEN (@SortBy IS NULL) THEN  CAST(AQ.[Order] AS sql_variant)
                         WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),AQ.CreatedDateTime,121)
                         WHEN  @SortBy = 'Questiontype' THEN (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = AQ.QuestionTypeId )
                         WHEN  @SortBy = 'Title' THEN AQ.QuestionName
                         WHEN  @SortBy = 'Id' THEN AQ.QuestionIdentity
                     END 
                 END  ASC ,
                 CASE WHEN @SortDirection = 'DESC' THEN
                       CASE
                         WHEN (@SortBy = 'CreatedOn') THEN CONVERT(NVARCHAR(250),AQ.CreatedDateTime,121)
                         WHEN (@SortBy IS NULL) THEN  CAST(AQ.[Order] AS sql_variant)
                         WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),AQ.CreatedDateTime,121)
                         WHEN  @SortBy = 'Questiontype' THEN (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = AQ.QuestionTypeId )
                         WHEN  @SortBy = 'Title' THEN AQ.QuestionName
                         WHEN  @SortBy = 'Id' THEN AQ.QuestionIdentity
                        END
                  END DESC, CONVERT(INT,REPLACE(AQ.QuestionIdentity,'Q-',0))
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO