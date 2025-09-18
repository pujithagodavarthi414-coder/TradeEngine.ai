CREATE PROCEDURE [dbo].[USP_GetFailedQuestionsbyConductId]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@AuditConductId UNIQUEIDENTIFIER = NULL
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
			
			--SELECT ACSA.QuestionId AS QuestionId,ACS.AuditConductId AS AuditCategoryId
			--FROM AuditConductSubmittedAnswer ACSA
			--	 JOIN AuditConductAnswers ACS ON ACSA.AuditAnswerId = ACS.Id 
			--		  AND ACS.AuditConductId = @AuditConductId AND ACSA.ConductId = @AuditConductId
			--		  AND ACS.QuestionOptionResult = 0
			--		  AND ACSA.InActiveDateTime IS NULL 
			--		  AND ACS.InActiveDateTime IS NULL
			--GROUP BY ACSA.QuestionId,ACS.AuditConductId 


			SELECT ACSA.QuestionId AS QuestionId,ACQ.AuditCategoryId
			FROM AuditConductSubmittedAnswer ACSA
				 JOIN AuditConductAnswers ACS ON ACSA.AuditAnswerId = ACS.Id 
				 JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = ACSA.QuestionId
					  AND ACS.AuditConductId = @AuditConductId AND ACSA.ConductId = @AuditConductId
					  AND ACQ.AuditConductId = @AuditConductId
					  AND ACS.QuestionOptionResult = 0
					  AND ACSA.InActiveDateTime IS NULL 
					  AND ACS.InActiveDateTime IS NULL
					  AND ACQ.InActiveDateTime IS NULL
			GROUP BY ACSA.QuestionId,ACQ.AuditCategoryId 

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
 GO