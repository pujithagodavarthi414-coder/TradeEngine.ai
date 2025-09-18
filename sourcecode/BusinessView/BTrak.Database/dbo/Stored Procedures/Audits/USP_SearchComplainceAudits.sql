CREATE PROCEDURE [dbo].[USP_SearchComplainceAudits]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @NonComplaintAnswers INT = (SELECT COUNT(1) FROM AuditQuestions AQ
				INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL AND QT.CompanyId = @CompanyId
				INNER JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = AQ.Id AND AQ.InactiveDateTime IS NULL
                JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
                JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
                AND ACS.AuditAnswerId = ACA.Id AND ISNULL(ACA.QuestionOptionResult,0) = 0)

			DECLARE @ComplaintAnswers INT = (SELECT COUNT(1) FROM AuditQuestions AQ
				INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL AND QT.CompanyId = @CompanyId
				INNER JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = AQ.Id AND AQ.InactiveDateTime IS NULL
                JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
                JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
                AND ACS.AuditAnswerId = ACA.Id AND ISNULL(ACA.QuestionOptionResult,0) = 1)

			DECLARE @Complaince INT = (SELECT COUNT(1) FROM AuditQuestions AQ
				INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL AND QT.CompanyId = @CompanyId
				INNER JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = AQ.Id AND AQ.InactiveDateTime IS NULL
                JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
                JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
                AND ACS.AuditAnswerId = ACA.Id)
           
		   SELECT AQ.QuestionName,
		   AQ.Id AS QuestionId FROM AuditQuestions AQ
		   INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL AND QT.CompanyId = @CompanyId
				INNER JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = AQ.Id AND AQ.InactiveDateTime IS NULL
                JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
                JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
                AND ACS.AuditAnswerId = ACA.Id


		  -- SELECT AQ.Id  AS QuestionId,
		  -- AQ.QuestionName AS QuestionName,
		  -- ACC.AuditName,
		  -- ACC.Id AS AuditId,
		  -- AC.Id AS AuditConductId,
		  -- AC.AuditConductName,
		  -- U.[FirstName] + ' ' +ISNULL(U.SurName,'') SubmittedBy,
		  -- B.Id AS BranchId,
		  -- B.BranchName,
		  -- ACQ.CreatedDateTime,
		  -- ACS.CreatedDateTime AS UpdatedDateTime
		  -- FROM AuditConductQuestions ACQ 
    --           JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId-- AND ACQ.AuditConductId = @AuditConductId
    --            AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
    --           JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
    --            AND ACS.AuditAnswerId = ACA.Id AND ISNULL(ACA.QuestionOptionResult,0) = 1
			 --  JOIN AuditConduct AC ON AC.Id = ACQ.AuditConductId AND AC.InActiveDateTime IS NULL
			 --  JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.InActiveDateTime IS NULL
			 --  JOIN AuditCategory ACT  ON ACT.AuditComplianceId = ACC.Id AND ACT.InactiveDateTime IS NULL
			 --  JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACT.Id AND AQ.InactiveDateTime IS null
			 --  JOIN [User] U ON ACS.CreatedByUserId = U.Id AND U.InActiveDateTime IS NULL
			 --  INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
				--INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
				--INNER JOIN Branch B ON EB.BranchId = B.Id AND B.InActiveDateTime IS NULL
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
