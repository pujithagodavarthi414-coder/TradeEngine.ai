CREATE PROCEDURE [dbo].[USP_SubmitAuditConduct]
(
	@AuditConductId UNIQUEIDENTIFIER,
	@AuditRatingId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
	  DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditConductId)
	  
	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	  DECLARE @AuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditConduct WHERE Id = @AuditConductId)

      IF(@HavePermission = '1')
      BEGIN

			IF((SELECT [dbo].[Ufn_ValidateConductSubmit](@AuditConductId,1,@OperationsPerformedBy)) = 0)
			BEGIN

				RAISERROR('PleaseSubmitAllMandatoryQuestions',11,1)

			END
			ELSE
			BEGIN

				UPDATE AuditConduct SET IsCompleted = 1
				                       ,AuditRatingId = @AuditRatingId
									   ,UpdatedByUserId = @OperationsPerformedBy
									   ,UpdatedDateTime = GETDATE()
										WHERE Id = @AuditConductId

										
                IF(@AuditRatingId IS NOT NULL)
				BEGIN

					INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
					SELECT NEWID(), @AuditId, @AuditConductId, NULL, NULL,(SELECT AuditRatingName FROM AuditRating WHERE Id = @AuditRatingId), 'AuditRatingUpdated', GETDATE(), @OperationsPerformedBy

				END

				INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
					SELECT NEWID(), @AuditId, @AuditConductId, NULL, NULL, NULL, 'AuditConductSubmitted', GETDATE(), @OperationsPerformedBy

				SELECT @AuditConductId AS AuditConductId

			END

	  END
      ELSE
      BEGIN
      
           RAISERROR (@HavePermission,10, 1)
	 
	  END
	
	END TRY
	BEGIN CATCH

		THROW

	END CATCH


END