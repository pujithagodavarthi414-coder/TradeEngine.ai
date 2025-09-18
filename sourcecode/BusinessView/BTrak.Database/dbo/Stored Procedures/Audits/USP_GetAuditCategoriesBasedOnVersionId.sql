CREATE PROCEDURE [dbo].[USP_GetAuditCategoriesBasedOnVersionId]
(
   @AuditCategoryId UNIQUEIDENTIFIER = NULL,
   @AuditComplianceVersionId UNIQUEIDENTIFIER = NULL,
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

   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditComplianceVersions WHERE Id = @AuditComplianceVersionId)
   
   IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditConductId)

   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  IF(@IsArchived IS NULL) SET @IsArchived = 0
		  
		  IF(@IsCategoriesRequired IS NULL) SET @IsCategoriesRequired = 0

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
		  SELECT AC.Id AS AuditCategoryId,
				 AC.AuditCategoryName,
				 @AuditComplianceId,
				 AC.CreatedByUserId,
				 AC.CreatedDateTime,
				 (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 PAC.AuditCategoryName AS ParentAuditCategoryName,
				 PAC.Id AS ParentAuditCategoryId,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 NULL AS [TimeStamp],
				 AC.AuditCategoryDescription,
			     ISNULL((SELECT COUNT(1) 
				         FROM AuditQuestionVersions AQ1 
				              INNER JOIN AuditCategoryVersions AC1 ON AC1.Id = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
						      INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                        WHERE AC1.Id = AC.Id 
						      AND AC1.AuditComplianceVersionId = @AuditComplianceVersionId 
							  AND AQ1.InActiveDateTime IS NULL),0) AS QuestionsCount
				,AC.AuditComplianceVersionId AS AuditVersionId
          FROM AuditCategoryVersions AC
		  INNER JOIN AuditComplianceVersions ACM ON ACM.Id = AC.AuditComplianceVersionId AND AC.[AuditComplianceId] = ACM.AuditId
		  INNER JOIN [User] U ON U.Id = AC.CreatedByUserId
		             AND ACM.Id = @AuditComplianceVersionId
		  LEFT JOIN AuditCategoryVersions PAC ON AC.ParentAuditCategoryId = PAC.Id AND PAC.InActiveDateTime IS NULL
		  WHERE (@AuditComplianceId IS NULL OR (AC.AuditComplianceId = @AuditComplianceId))
		       AND ACM.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
		        AND (@AuditCategoryId IS NULL OR AC.Id = @AuditCategoryId)
				AND (@ParentAuditCategoryId IS NULL OR AC.ParentAuditCategoryId = @ParentAuditCategoryId)
		        AND (@AuditCategoryName IS NULL OR AC.AuditCategoryName = @AuditCategoryName)
				AND (@SearchText IS NULL OR AC.AuditCategoryName LIKE '%'+ @SearchText +'%')
				AND ((@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL))
			   AND AC.AuditComplianceVersionId = @AuditComplianceVersionId
          GROUP BY AC.Id,AC.AuditCategoryName,AC.CreatedByUserId,AC.CreatedDateTime,AC.InActiveDateTime,PAC.AuditCategoryName,
                    PAC.Id,AC.AuditCategoryDescription,U.FirstName + ' ' + ISNULL(U.SurName,''),AC.AuditComplianceVersionId 
		 ORDER BY AC.CreatedDateTime ASC,AuditCategoryName
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO