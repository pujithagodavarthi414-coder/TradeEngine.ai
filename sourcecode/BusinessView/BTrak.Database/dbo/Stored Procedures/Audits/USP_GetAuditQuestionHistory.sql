-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get the Audit Question History 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetAuditQuestionHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAuditQuestionHistory]
(
  @QuestionId UNIQUEIDENTIFIER = NULL,
  @AuditId UNIQUEIDENTIFIER = NULL,
  @ConductId UNIQUEIDENTIFIER = NULL,
  @IsFromAuditQuestion BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
      
       DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @ConductId)

       IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditCompliance 
                                                WHERE Id = (SELECT AuditComplianceId FROM AuditCategory 
                                                            WHERE Id = (SELECT [AuditCategoryId] FROM AuditQuestions WHERE Id = @QuestionId))
                                               )

	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
       
	   IF (@HavePermission = '1')
       BEGIN
           
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
           IF(@QuestionId = '00000000-0000-0000-0000-000000000000') SET  @QuestionId = NULL

           IF(@IsFromAuditQuestion IS NULL) SET @IsFromAuditQuestion = 0
          
		   SELECT AQH.Id AS AuditQuestionHistoryId,
                  (SELECT AuditConductName FROM AuditConduct WHERE Id = AQH.ConductId GROUP BY AuditConductName) AS ConductName,
                  AQH.OldValue,
                  AQH.NewValue,
                  AQH.[Description],
                  AQH.CreatedByUserId,
                  AQH.CreatedDateTime,
                  (SELECT CreatedDateTime FROM AuditConduct WHERE Id = AQH.ConductId GROUP BY CreatedDateTime) AS ConductCreatedDateTime,
                  U.FirstName +' '+ISNULL(U.SurName,'') as PerformedByUserName,
                  U.ProfileImage AS PerformedByUserProfileImage,
                  TotalCount = COUNT(1) OVER()
           FROM  [dbo].[AuditQuestionHistory] AQH WITH (NOLOCK)
                 INNER JOIN [dbo].[User] U ON U.Id = AQH.CreatedByUserId
           WHERE U.CompanyId = @CompanyId 
                 AND (@QuestionId IS NULL OR AQH.QuestionId = @QuestionId)
                 AND (@IsFromAuditQuestion = 0 OR AQH.ConductId IS NOT NULL)
				 AND ((@IsFromAuditQuestion = 0 AND (@AuditId IS NULL OR AQH.AuditId = @AuditId)) OR @IsFromAuditQuestion = 1)
				 AND ((@IsFromAuditQuestion = 0 AND ((@ConductId IS NULL AND AQH.ConductId IS NULL) OR AQH.ConductId = @ConductId)) OR @IsFromAuditQuestion = 1)
           ORDER BY AQH.CreatedDateTime DESC
        
        END
        ELSE
           RAISERROR (@HavePermission,11, 1)

     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH
END
GO