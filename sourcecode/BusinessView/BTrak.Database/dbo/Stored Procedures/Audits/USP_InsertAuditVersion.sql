CREATE PROCEDURE [dbo].[USP_InsertAuditVersion]
(
    @AuditId UNIQUEIDENTIFIER
    ,@VersionName NVARCHAR(100) --AuditVersionname
    ,@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
        
        IF(@AuditId = '00000000-0000-0000-0000-000000000000') SET @AuditId = NULL

        IF(@VersionName = '') SET @VersionName = NULL

        DECLARE @VersionnameCount INT = (SELECT COUNT(1) FROM AuditComplianceVersions WHERE AuditId = @AuditId AND VersionName = @VersionName)

        IF(@VersionnameCount > 0)
        BEGIN
            
            RAISERROR('VersionWithThisNameAlreadyExists',16,2)

        END
        ELSE IF(@AuditId IS NULL)
        BEGIN
            
            RAISERROR(50011,16,2,'AuditCompliance')

        END
        ELSE
        BEGIN
		 
            DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)
		    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
		    BEGIN
            
                DECLARE @AuditComplianceVersionId UNIQUEIDENTIFIER = NEWID()
            
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                DECLARE @CurrentDate DATETIME = GETDATE()

                INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId],[Field])
				SELECT NEWID(), @AuditId, NULL, NULL, NULL, @VersionName, 'AuditVersionAdded', GETDATE(), @OperationsPerformedBy,'AuditVersion'

                INSERT INTO AuditComplianceVersions(
                            [Id]
                            ,[AuditId]
                            ,[VersionName]
                            ,[VersionNumber]
                            ,[CompanyId]
                            ,[AuditName]
                            ,[Description]
                            ,[IsRAG]
                            ,[CanLogTime]
                            ,[InboundPercent]
                            ,[OutboundPercent]
                            ,[ResposibleUserId]
                            ,[EnableQuestionLevelWorkFlow]
                            ,AuditFolderId
                            ,[CreatedDateTime]
                            ,[CreatedByUserId]
                            ,[ProjectId]
               )
               SELECT @AuditComplianceVersionId
                      ,Id
                      ,@VersionName
                      ,ISNULL((SELECT COUNT(1) FROM AuditComplianceVersions WHERE AuditId = @AuditId AND InActiveDateTime IS NULL),0) + 1
                      ,@CompanyId
                      ,AuditName
                      ,[Description]
                      ,IsRAG
                      ,CanLogTime
                      ,InboundPercent
                      ,OutboundPercent
                      ,ResposibleUserId
                      ,EnableQuestionLevelWorkFlow
                      ,AuditFolderId
                      ,@CurrentDate
                      ,@OperationsPerformedBy
                      ,ProjectId
              FROM AuditCompliance
              WHERE InActiveDateTime IS NULL
                    AND Id = @AuditId

                INSERT INTO AuditTagVersions(
                [Id]
                ,[AuditId]
                ,[TagId]
                ,[TagName]
                ,[CreatedByUserId]
                ,[CreatedDateTime]
                ,[AuditComplianceVersionId]
                )
               SELECT Id
                      ,AuditId
                      ,TagId
                      ,TagName
                      ,@OperationsPerformedBy
                      ,@CurrentDate
                      ,@AuditComplianceVersionId
               FROM AuditTags
              WHERE InActiveDateTime IS NULL
                    AND AuditId = @AuditId
  
               INSERT INTO AuditCategoryVersions(
               [Id]
               ,[AuditCategoryName]
               ,[AuditCategoryDescription]
               ,[AuditComplianceId]
               ,[AuditComplianceVersionId]
               ,[CreatedByUserId]
               ,[CreatedDateTime]
               ,[ParentAuditCategoryId]
               )
               SELECT Id
                      ,AuditCategoryName
                      ,AuditCategoryDescription 
                      ,AuditComplianceId
                      ,@AuditComplianceVersionId
                      ,@OperationsPerformedBy
                      ,CreatedDateTime
                      ,ParentAuditCategoryId
                FROM AuditCategory
                WHERE InActiveDateTime IS NULL
                      AND AuditComplianceId = @AuditId

                INSERT INTO AuditQuestionVersions(
                [Id]
                ,[AuditComplianceVersionId]
                ,[AuditCategoryId]
                ,[CompanyId]
                ,[CreatedByUserId]
                ,[CreatedDateTime]
                ,[EstimatedTime]
                ,[ImpactId]
                ,[IsMandatory]
                ,[Order]
                ,[PriorityId]
                ,[QuestionDescription]
                ,[QuestionIdentity]
                ,[QuestionName]
                ,[QuestionResult]
                ,[QuestionTypeId]
                ,[RiskId]
                ,[IsOriginalQuestionTypeScore]
                ,[QuestionHint]
                ,[QuestionResponsiblePersonId]
                )
                SELECT AQ.[Id]
                ,@AuditComplianceVersionId
                ,AQ.[AuditCategoryId]
                ,AQ.[CompanyId]
                ,AQ.[CreatedByUserId]
                ,AQ.[CreatedDateTime]
                ,AQ.[EstimatedTime]
                ,AQ.[ImpactId]
                ,AQ.[IsMandatory]
                ,AQ.[Order]
                ,AQ.[PriorityId]
                ,AQ.[QuestionDescription]
                ,AQ.[QuestionIdentity]
                ,AQ.[QuestionName]
                ,AQ.[QuestionResult]
                ,AQ.[QuestionTypeId]
                ,AQ.[RiskId]
                ,AQ.IsOriginalQuestionTypeScore
                ,AQ.QuestionHint
                ,AQ.QuestionResponsiblePersonId
             FROM AuditQuestions AQ
                  INNER JOIN AuditCategory AC ON AC.Id = AQ.[AuditCategoryId]
                             AND AC.AuditComplianceId = @AuditId
                             AND AC.InActiveDateTime IS NULL
                             AND AQ.[InActiveDateTime] IS NULL
        
               INSERT INTO AuditAnswerVersions(
               [Id]
               ,[AuditId]
               ,[AuditComplianceVersionId]
               ,[AuditQuestionId]
               ,[Answer]
               ,[CreatedByUserId]
               ,[CreatedDateTime]
               ,[QuestionOptionBoolean]
               ,[QuestionOptionDate]
               ,[QuestionOptionNumeric]
               ,[QuestionOptionResult]
               ,[QuestionOptionText]
               ,[QuestionOptionTime]
               ,[QuestionTypeOptionId]
               ,[Score]
               )
               SELECT [Id]
                     ,[AuditId]
                     ,@AuditComplianceVersionId
                     ,[AuditQuestionId]
                     ,[Answer]
                     ,[CreatedByUserId]
                     ,[CreatedDateTime]
                     ,[QuestionOptionBoolean]
                     ,[QuestionOptionDate]
                     ,[QuestionOptionNumeric]
                     ,[QuestionOptionResult]
                     ,[QuestionOptionText]
                     ,[QuestionOptionTime]
                     ,[QuestionTypeOptionId]
                     ,[Score]
               FROM AuditAnswers 
               WHERE InactiveDateTime IS NULL
                     AND [AuditId] = @AuditId

          END
        
        END

    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO