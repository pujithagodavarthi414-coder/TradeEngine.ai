CREATE PROCEDURE [dbo].[USP_GetAuditQuestionsBasedonAuditId]
(
	@AuditComplainceId uniqueidentifier,
	@OperationsPerformedBy uniqueidentifier
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance AC WHERE Id = @AuditComplainceId)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@AuditComplainceId = '00000000-0000-0000-0000-000000000000') SET @AuditComplainceId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           DECLARE @IsRecurring bit 

		   IF (SELECT COUNT(*) FROM AuditComplianceSchedulingDetails WHERE AuditComplianceId = @AuditComplainceId) > 0
		   BEGIN
				SET @IsRecurring = 1;
		   END

           SELECT DISTINCT AQ.Id AS QuestionId,
                  AQ.AuditCategoryId,
                  A.Id AS AuditId
           FROM [dbo].[AuditQuestions] AS AQ INNER JOIN [AuditCategory] AC ON AC.Id = AQ.AuditCategoryId AND AQ.InActiveDateTime IS NULL
		   INNER JOIN [AuditCompliance] A ON A.Id = AC.AuditComplianceId AND A.Id = @AuditComplainceId
		   LEFT JOIN AuditComplianceSchedulingDetails ACD ON ACD.AuditComplianceId = A.Id
		   LEFT JOIN [AuditSelectedQuestion] ASQ ON ASQ.AuditComplianceId = A.Id AND AQ.Id = ASQ.AuditQuestionId AND ASQ.InActiveDateTime IS NULL
		   WHERE (@IsRecurring = NULL OR (@IsRecurring = 1 AND ACD.ID IS NOT NULL AND ASQ.Id IS NOT NULL))
		   AND A.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)

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