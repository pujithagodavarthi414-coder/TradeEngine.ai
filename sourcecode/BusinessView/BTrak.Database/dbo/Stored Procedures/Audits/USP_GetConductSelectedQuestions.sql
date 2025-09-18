-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the selected questions only when select specific questions scenario
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetConductSelectedQuestions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',

CREATE PROCEDURE [dbo].[USP_GetConductSelectedQuestions]
(
  @AuditConductId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
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

      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
      
            SELECT 
                  ACSQ.AuditQuestionId AS QuestionId,
                  AQ.AuditCategoryId
             FROM [AuditConductSelectedQuestion] ACSQ 
                  INNER JOIN [AuditQuestions] AQ ON AQ.Id = ACSQ.AuditQuestionId AND AQ.InActiveDateTime IS NULL AND ACSQ.InActiveDateTime IS NULL
                  INNER JOIN [User] U ON U.Id = AQ.CreatedByUserId
             WHERE ACSQ.AuditConductId = @AuditConductId 
                  AND (U.CompanyId = @CompanyId)

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
