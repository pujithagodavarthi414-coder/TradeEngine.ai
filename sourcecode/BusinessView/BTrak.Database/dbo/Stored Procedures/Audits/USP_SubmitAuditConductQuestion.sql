CREATE PROCEDURE [dbo].[USP_SubmitAuditConductQuestion]
(
	@ConductAnswerSubmittedId UNIQUEIDENTIFIER = NULL,
	@OperationsperformedBy UNIQUEIDENTIFIER,
	@AuditConductAnswerId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = 0,
	@TimeStamp TIMESTAMP = NULL,
	@AnswerComment NVARCHAR(800) = NULL,
	@QuestionDateAnswer DATE = NULL,
	@QuestionTextAnswer NVARCHAR(800) = NULL,
	@QuestionNumericAnswer FLOAT = NULL,
	@QuestionTimeAnswer TIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@ConductAnswerSubmittedId = '00000000-0000-0000-0000-000000000000') SET @ConductAnswerSubmittedId = NULL
		
		IF(@AuditConductAnswerId = '00000000-0000-0000-0000-000000000000') SET @AuditConductAnswerId = NULL

		IF(@IsArchived IS NULL)SET @IsArchived = 0
		 
		DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct 
		                                       WHERE Id = (SELECT AuditConductId FROM AuditConductAnswers 
											                WHERE Id = @AuditConductAnswerId))
	  
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		 
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @IsLatest BIT = (CASE WHEN @ConductAnswerSubmittedId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [AuditConductSubmittedAnswer] WHERE Id = @ConductAnswerSubmittedId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)
 
         IF(@IsLatest = 1)
         BEGIN

		 IF(@AuditConductAnswerId IS NULL)
		 BEGIN
			    
				RAISERROR(50011,16, 2, 'Answer')
			
		 END

		 DECLARE @Currentdate DATETIME = GETDATE()

		 DECLARE @OldAnswerComment NVARCHAR(800) = NULL
		 DECLARE @OldValue NVARCHAR(800) = NULL
		 DECLARE @NewValue NVARCHAR(800) = NULL
		 DECLARE @QuestionId UNIQUEIDENTIFIER = NULL
		 DECLARE @AuditConductId UNIQUEIDENTIFIER = NULL
		 DECLARE @OldAnsweId UNIQUEIDENTIFIER = @ConductAnswerSubmittedId
		 SET @ConductAnswerSubmittedId = (SELECT ACS.Id FROM [AuditConductSubmittedAnswer] ACS 
		                                                JOIN AuditConductAnswers ACA ON ACS.ConductId = ACA.AuditConductId 
														 AND ACS.QuestionId = ACA.AuditQuestionId 
														 AND ACA.Id = @AuditConductAnswerId)
		 

		 SELECT @OldAnswerComment = AnswerComment,@OldValue = COALESCE(QuestionTypeOptionName,QuestionTextAnswer,CONVERT(NVARCHAR(20),QuestionNumericAnswer),CONVERT(NVARCHAR(20),QuestionTimeAnswer,114),CONVERT(NVARCHAR(20),QuestionDateAnswer,106)) FROM [AuditConductSubmittedAnswer] WHERE Id = @ConductAnswerSubmittedId


		 IF(@ConductAnswerSubmittedId IS NULL)
		 BEGIN

			SET @ConductAnswerSubmittedId = NEWID()

			INSERT INTO [dbo].[AuditConductSubmittedAnswer](
															[Id],
															[QuestionId],
															[ConductId],
															[QuestionTypeOptionId],
															[QuestionTypeOptionName],
															[AnswerComment],
															[Score],
															[QuestionDateAnswer],
															[QuestionNumericAnswer],
															[QuestionTextAnswer],
															[QuestionTimeAnswer],
															[AuditAnswerId],
															[InActiveDateTime],
															[CreatedDateTime],
															[CreatedByUserId]
					                                       )	
                                                     SELECT @ConductAnswerSubmittedId,
												            AuditQuestionId,
														    AuditConductId,
														    QuestionTypeOptionId,
														    QuestionTypeOptionName,
														    @AnswerComment,
														    Score,
															@QuestionDateAnswer,
															@QuestionNumericAnswer,
															@QuestionTextAnswer,
															@QuestionTimeAnswer,
															@AuditConductAnswerId,
														    IIF(@IsArchived = 1,@CurrentDate,NULL),
														    @Currentdate,
															@OperationsperformedBy
			                                                FROM AuditConductAnswers WHERE Id = @AuditConductAnswerId
		      
		END
		ELSE
		BEGIN

						UPDATE [AuditConductSubmittedAnswer]
					       SET [QuestionId]             = ACA.AuditQuestionId,
						       [ConductId]              = ACA.AuditConductId,
						       [QuestionTypeOptionId]   = ACA.QuestionTypeOptionId,
						       [QuestionTypeOptionName] = ACA.QuestionTypeOptionName,
						       [AnswerComment]          = @AnswerComment,
						       [Score]                  = ACA.Score,
							   [QuestionDateAnswer]     = @QuestionDateAnswer,
							   [QuestionNumericAnswer]  = @QuestionNumericAnswer,
							   [QuestionTextAnswer]     = @QuestionTextAnswer,
							   [QuestionTimeAnswer]     = @QuestionTimeAnswer,
							   [AuditAnswerId]          = @AuditConductAnswerId,
						       [InActiveDateTime]       = IIF(@IsArchived = 1,@CurrentDate,NULL),
						       [UpdatedDateTime]        = @Currentdate,
						       [UpdatedByUserId]		= @OperationsperformedBy
						       FROM [AuditConductSubmittedAnswer] ACSA
						       JOIN AuditConductAnswers ACA ON ACSA.Id = @ConductAnswerSubmittedId 
						        AND ACA.Id = @AuditConductAnswerId
		END		
		
					SELECT @AuditConductId = AuditConductId,@QuestionId = AuditQuestionId,@NewValue = COALESCE(QuestionTypeOptionName,@QuestionTextAnswer,CONVERT(NVARCHAR(20),@QuestionDateAnswer,106),CONVERT(NVARCHAR(20),@QuestionNumericAnswer),CONVERT(NVARCHAR(20),@QuestionTimeAnswer,114)) FROM AuditConductAnswers WHERE Id = @AuditConductAnswerId   
					
					DECLARE @AuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditConduct WHERE Id = @AuditConductId)

			        IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionConductResultUpdated',@Field = 'SubmitAuidtQuestionAnswer',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = @AuditConductId

					IF(ISNULL(@OldAnswerComment,'') <> @AnswerComment)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldAnswerComment,
					@NewValue = @AnswerComment,@Description = 'QuestionCommentUpdated',@Field = 'SubmitAuidtQuestionComment',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = @AuditConductId
					
					IF(EXISTS(SELECT Id FROM AuditConductAnswers WHERE [QuestionOptionResult] = 1 AND Id = @AuditConductAnswerId) AND @OldAnsweId IS NOT NULL AND EXISTS(SELECT US.Id FROM UserStory US JOIN AuditConductQuestions ACQ ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,',')) AND ACQ.QuestionId = @QuestionId AND ACQ.AuditConductId = @AuditConductId AND US.InActiveDateTime IS NULL))
					BEGIN
						
						EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = NULL,
					    @NewValue = NULL,@Description = 'ActionRemoved',@Field = 'ActionsRemoved',@QuestionId = @QuestionId,
					    @AuditId = @AuditId,@ConductId = @AuditConductId
					    
                        UPDATE UserStory SET AuditConductQuestionId = NULL,InActiveDateTime = SYSDATETIMEOFFSET(),UpdatedByUserId = @OperationsperformedBy,UpdatedDateTime = SYSDATETIMEOFFSET()
						WHERE AuditConductQuestionId = (SELECT AQ.Id FROM AuditConductQuestions AQ JOIN AuditConductAnswers AC ON AQ.QuestionId = AC.AuditQuestionId AND AQ.AuditConductId = AC.AuditConductId AND AC.Id = @AuditConductAnswerId)

					END

			SELECT Id  FROM [dbo].[AuditConductSubmittedAnswer] WHERE Id = @ConductAnswerSubmittedId

		END
		ELSE
			RAISERROR(5008,11,1)
		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END