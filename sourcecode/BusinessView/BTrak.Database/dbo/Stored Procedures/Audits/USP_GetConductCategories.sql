CREATE PROCEDURE [dbo].[USP_GetConductCategories]
(
   @AuditCategoryId UNIQUEIDENTIFIER = NULL,
   @AuditConductId UNIQUEIDENTIFIER = NULL,
   @AuditCategoryName NVARCHAR(250) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @IsCategoriesRequired BIT = NULL,
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @ParentAuditCategoryId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
	    DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditConductId)

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  IF(@IsArchived IS NULL) SET @IsArchived = 0
		  
		  IF(@IsCategoriesRequired IS NULL) SET @IsCategoriesRequired = 0

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  CREATE TABLE #Temp 
           (
           AuditCategoryId UNIQUEIDENTIFIER
           )     
		  IF(@IsCategoriesRequired =  1 )
          BEGIN
           
          ;WITH Tree AS
          (
          
          SELECT ACC_Parent.AuditCategoryId,ACC_Parent.ParentAuditCategoryId
          FROM AuditConductSelectedCategory ACC_Parent
          WHERE ACC_Parent.AuditCategoryId IN (SELECT AQ.AuditCategoryId FROM AuditQuestions AQ INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditQuestionId = AQ.Id
                                                                                            AND AQ.InActiveDateTime IS NULL AND ACSQ.InActiveDateTime IS NULL
														 INNER JOIN AuditConductSelectedCategory ACC ON AQ.AuditCategoryId = ACC.AuditCategoryId AND ACC.InactiveDateTime IS NULL
          WHERE  ACC.AuditComplianceId = @AuditComplianceId AND ACSQ.AuditConductId = @AuditConductId AND AQ.InActiveDateTime IS NULL AND ACSQ.InActiveDateTime IS NULL) AND InActiveDateTime IS NULL 
          UNION ALL
          SELECT TS_Child.AuditCategoryId,TS_Child.ParentAuditCategoryId
          FROM AuditConductSelectedCategory TS_Child INNER JOIN Tree ON Tree.ParentAuditCategoryId = TS_Child.AuditCategoryId  AND TS_Child.InActiveDateTime IS NULL
          WHERE TS_Child.InActiveDateTime IS NULL 
          )
          INSERT INTO #Temp(AuditCategoryId)
          SELECT AuditCategoryId FROM Tree  GROUP BY AuditCategoryId
          UNION ALL
          SELECT ACC.AuditCategoryId FROM AuditConductSelectedCategory ACC INNER JOIN Tree ON TREE.ParentAuditCategoryId = ACC.AuditCategoryId  AND ACC.InActiveDateTime IS NULL 
          END
           
		  SELECT ACSC.AuditCategoryId,
				 ACSC.AuditCategoryName,
				 ACSC.CreatedByUserId,
				 ACSC.CreatedDateTime,
				 (CASE WHEN ACSC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 PAC.AuditCategoryName AS ParentAuditCategoryName,
				 PAC.AuditCategoryId AS ParentAuditCategoryId,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 ACSC.[TimeStamp],
				 ACSC.AuditCategoryDescription,
                 ACSC.[Order],
				 ACSC.Id AS AuditConductCategoryId,
			     ISNULL((SELECT COUNT(1) FROM AuditConductQuestions AQ1 INNER JOIN AuditConductSelectedCategory AC1 ON AC1.AuditCategoryId = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
									                      --INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                                                            WHERE AC1.AuditCategoryId = ACSC.AuditCategoryId 
                                                                AND AC1.AuditConductId = @AuditConductId AND AQ1.AuditConductId = @AuditConductId
                                                                AND AQ1.InActiveDateTime IS NULL AND AC1.InActiveDateTime IS NULL),0) AS QuestionsCount
		        ,IIF(@AuditConductId IS NULL,NULL,
                ISNULL((SELECT SUM(ACSA.Score) FROM AuditConductSubmittedAnswer ACSA 
                                          JOIN AuditConductAnswers ACS ON ACSA.AuditAnswerId = ACS.Id AND ACS.AuditConductId = @AuditConductId AND ACSA.InActiveDateTime IS NULL AND ACS.InActiveDateTime IS NULL
                                          JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = ACS.AuditQuestionId AND ACQ.AuditConductId = @AuditConductId AND ACQ.InActiveDateTime IS NULL
                                          AND ACQ.AuditCategoryId = ACSC.AuditCategoryId 
                                          ),0)) AS ConductScore,
                ISNULL((SELECT COUNT(1) FROM AuditConductSubmittedAnswer ACSA
                                          JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = ACSA.QuestionId AND ACQ.AuditConductId = @AuditConductId AND ACSA.ConductId = @AuditConductId
                                            AND ACQ.AuditCategoryId = ACSC.AuditCategoryId AND ACQ.InActiveDateTime IS NULL AND ACSA.InActiveDateTime IS NULL), 0) AS AnsweredCount,
                --(QuestionsCount - AnsweredCount) AS UnAnsweredCount,
                ISNULL((SELECT COUNT(1) FROM AuditConductSubmittedAnswer ACSA
                                          JOIN AuditConductAnswers ACS ON ACSA.AuditAnswerId = ACS.Id AND ACS.AuditConductId = @AuditConductId AND ACS.QuestionOptionResult = 1 AND ACSA.InActiveDateTime IS NULL AND ACS.InActiveDateTime IS NULL
                                          JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = ACS.AuditQuestionId AND ACQ.AuditConductId = @AuditConductId AND ACQ.InActiveDateTime IS NULL
                                          AND ACQ.AuditCategoryId = ACSC.AuditCategoryId
                                          ), 0) AS ValidAnswersCount
                --(AnsweredCount - ValidAnswersCount) AS InValidAnswersCount            
          FROM AuditConductSelectedCategory ACSC
		  INNER JOIN AuditCompliance ACM ON ACM.Id = ACSC.AuditComplianceId AND ACSC.AuditConductId = @AuditConductId
		  INNER JOIN [User] U ON U.Id = ACSC.CreatedByUserId
		  LEFT JOIN AuditConductSelectedCategory PAC ON ACSC.ParentAuditCategoryId = PAC.AuditCategoryId AND PAC.InActiveDateTime IS NULL
		  LEFT JOIN #Temp T ON T.AuditCategoryId = ACSC.AuditCategoryId
		  WHERE (@AuditComplianceId IS NULL OR (ACSC.AuditComplianceId = @AuditComplianceId))
		        AND (@AuditCategoryId IS NULL OR ACSC.AuditCategoryId = @AuditCategoryId)
				AND (@ParentAuditCategoryId IS NULL OR ACSC.ParentAuditCategoryId = @ParentAuditCategoryId)
		        AND (@AuditCategoryName IS NULL OR ACSC.AuditCategoryName = @AuditCategoryName)
				AND (@SearchText IS NULL OR ACSC.AuditCategoryName LIKE  '%'+ @SearchText +'%')
				AND ((@IsArchived = 1 AND ACSC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND ACSC.InActiveDateTime IS NULL))
                AND (@IsCategoriesRequired = 0 OR T.AuditCategoryId IS NOT NULL)
                AND ACM.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
          GROUP BY ACSC.AuditCategoryId,ACSC.AuditCategoryName,ACSC.CreatedByUserId,ACSC.CreatedDateTime,ACSC.InActiveDateTime,ACSC.[TimeStamp],PAC.AuditCategoryName,
                    PAC.AuditCategoryId,ACSC.AuditCategoryDescription,U.FirstName + ' ' + ISNULL(U.SurName,''),ACSC.[Order],ACSC.Id
		 ORDER BY -ACSC.[Order] DESC
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO