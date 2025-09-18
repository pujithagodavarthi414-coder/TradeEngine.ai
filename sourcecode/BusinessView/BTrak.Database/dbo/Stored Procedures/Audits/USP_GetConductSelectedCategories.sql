-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-08-01 00:00:00.000'
-- Purpose      To Get the selected categories only when select specific questions scenario
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetConductSelectedCategories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetConductSelectedCategories]
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
      
                                    SELECT T.AuditCategoryId FROM 
                                                       (SELECT AQ.AuditCategoryId,
													           COUNT(ACSQ.AuditQuestionId) QuestionCount 
															   FROM AuditConductSelectedQuestion ACSQ 
                                                       JOIN AuditQuestions AQ ON AQ.Id = ACSQ.AuditQuestionId
                                                       JOIN [User] U ON U.Id = AQ.CreatedByUserId
                                                       AND ACSQ.InActiveDateTime IS NULL
                                                       AND AQ.InActiveDateTime IS NULL
                                                       WHERE AuditConductId = @AuditConductId AND U.CompanyId = @CompanyId
                                                       GROUP BY AQ.AuditCategoryId) T 
                                                       JOIN 
                                                       (SELECT AQ.AuditCategoryId,COUNT(AQ.Id) QuestionCount FROM AuditCategory AC
                                                       JOIN AuditQuestions AQ ON AQ.AuditCategoryId = AC.Id
                                                       AND AC.InActiveDateTime IS NULL
                                                       AND AQ.InActiveDateTime IS NULL
                                                       GROUP BY AQ.AuditCategoryId) J ON T.AuditCategoryId = J.AuditCategoryId AND T.QuestionCount = J.QuestionCount
  
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
