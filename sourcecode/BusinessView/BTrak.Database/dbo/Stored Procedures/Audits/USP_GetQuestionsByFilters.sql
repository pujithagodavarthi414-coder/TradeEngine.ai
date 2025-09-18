-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-05-06 00:00:00.000'
-- Purpose      To Get Questions with different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetQuestionsByFilters] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetQuestionsByFilters]
(
    @QuestionId UNIQUEIDENTIFIER = NULL,
    @AuditCategoryId UNIQUEIDENTIFIER = NULL,
    @AuditId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @CreatedOn VARCHAR(100) = NULL,
    @UpdatedOn VARCHAR(100) = NULL,
    @QuestionTypeFilterXml XML = NULL,
    @SearchText NVARCHAR(250) = NULL
)       
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
         DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	     IF(@HavePermission = '1')
	     BEGIN

			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@SearchText IS NULL) SET @SearchText = NULL
               SET @SearchText = '%'+ @SearchText +'%'
               
               DECLARE @StartDate DATETIME
               DECLARE @EndDate DATETIME
               DECLARE @UpdateStartDate DATETIME
               DECLARE @UpdateEndDate DATETIME
               
               IF(@CreatedOn = 'None') SET @CreatedOn = NULL
              
               IF(@UpdatedOn = 'None') SET @UpdatedOn = NULL
                
               IF(@CreatedOn IS NOT NULL)
               SELECT @StartDate = T.StartDate,@EndDate = T.EndDate  FROM [Ufn_GetDatesWithText](@CreatedOn) T
             
               IF(@UpdatedOn IS NOT NULL)
               SELECT @UpdateStartDate = T.StartDate,@UpdateEndDate = T.EndDate FROM [Ufn_GetDatesWithText](@UpdatedOn) T
                              
                CREATE TABLE #QuestionTypeFilter
               (
                QuestionTypeId UNIQUEIDENTIFIER
               )
               IF(@QuestionTypeFilterXml IS NOT NULL)
               BEGIN
                
                 INSERT INTO #QuestionTypeFilter
                 SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @QuestionTypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                
               END  
          
              SELECT AQ.Id AS QuestionId 
                    ,AQ.AuditCategoryId
                    ,CASE WHEN (COUNT(1) OVER(PARTITION BY AQ.AuditCategoryId)) = QuestionsCount THEN 1 ELSE 0 END IsChecked
               FROM AuditQuestions AQ WITH (NOLOCK)
                       INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL                       
                       INNER JOIN AuditCompliance AC ON AC.Id = ACC.AuditComplianceId AND AC.InActiveDateTime IS NULL
                       INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL
                       INNER JOIN MasterQuestionType MQT ON MQT.Id = QT.MasterQuestionTypeId
                       LEFT JOIN #QuestionTypeFilter QTF ON QTF.QuestionTypeId = AQ.QuestionTypeId
                       LEFT JOIN (SELECT AuditCategoryId,COUNT(QuestionIdentity) QuestionsCount FROM AuditQuestions WHERE InActiveDateTime IS NULL GROUP BY AuditCategoryId)T ON T.AuditCategoryId = AQ.AuditCategoryId
               WHERE AC.CompanyId = @CompanyId
                     AND AC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                          WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
                     AND (@AuditCategoryId IS NULL OR AQ.AuditCategoryId = @AuditCategoryId)
                     AND AQ.InActiveDateTime IS NULL 
                     AND (@AuditId IS NULL OR AC.Id = @AuditId)
                     AND (@SearchText IS NULL OR AQ.QuestionName LIKE @SearchText)
                     AND (@QuestionTypeFilterXml IS NULL OR QTF.QuestionTypeId IS NOT NULL)
                     AND (@CreatedOn IS NULL OR (CONVERT(DATE,AQ.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,AQ.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
                     AND (@UpdatedOn IS NULL OR (CONVERT(DATE,AQ.UpdatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,AQ.UpdatedDateTime) <= CONVERT(DATE,@UpdateEndDate)))
           
	  END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,16, 1)
	  
	  END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
