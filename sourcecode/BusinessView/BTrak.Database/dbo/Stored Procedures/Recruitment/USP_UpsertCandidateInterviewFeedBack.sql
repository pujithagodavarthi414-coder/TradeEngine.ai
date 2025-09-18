CREATE PROCEDURE [dbo].[USP_UpsertCandidateInterviewFeedBack]
(
   @CandidateInterviewFeedBackId UNIQUEIDENTIFIER = NULL,
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER,
   @InterviewRatingId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@InterviewRatingId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewRatingId')

		END
		IF(@CandidateInterviewScheduleId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateInteviewScheduleId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateId UNIQUEIDENTIFIER = NULL
			DECLARE @JobOpeningId UNIQUEIDENTIFIER = NULL
			DECLARE @NewValue NVARCHAR(250) = NULL
			DECLARE @OldValue NVARCHAR(250) = NULL

			DECLARE @OldInterviewRatingId UNIQUEIDENTIFIER = (SELECT Id FROM [CandidateInterviewFeedBack] WHERE Id = @CandidateInterviewFeedBackId)
			SET @OldValue = (SELECT InterviewRatingName FROM InterviewRating WHERE Id = @OldInterviewRatingId AND @OldInterviewRatingId IS NOT NULL)
			SET @NewValue = (SELECT InterviewRatingName FROM InterviewRating WHERE Id = @InterviewRatingId)
			

			 SELECT  @CandidateId = CandidateId,@JobOpeningId = JobOpeningId FROM CandidateInterviewSchedule WHERE Id = @CandidateInterviewScheduleId

			DECLARE @CandidateInterviewFeedBackIdCount INT = (SELECT COUNT(1) FROM CandidateInterviewFeedBack WHERE Id = @CandidateInterviewFeedBackId)

			--DECLARE @CandidateInterviewFeedBackCount INT = (SELECT COUNT(1) FROM CandidateInterviewFeedBack WHERE InterviewRatingId = @InterviewRatingId AND CandidateInterviewScheduleId = @CandidateInterviewScheduleId AND (@CandidateInterviewFeedBackId IS NULL OR @CandidateInterviewFeedBackId <> Id))
       
			IF(@CandidateInterviewFeedBackIdCount = 0 AND @CandidateInterviewFeedBackId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateInterviewFeedBack')

			END
			--IF (@CandidateInterviewFeedBackCount > 0)
			--BEGIN

			--	RAISERROR(50001,11,1,'CandidateInterviewFeedBack')

			--END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateInterviewFeedBackId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateInterviewFeedBack] WHERE Id = @CandidateInterviewFeedBackId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateInterviewFeedBackId IS NULL)
					  BEGIN

						 SET @CandidateInterviewFeedBackId = NEWID()

						 INSERT INTO [dbo].[CandidateInterviewFeedBack]([Id],
														  InterviewRatingId,
								                          CandidateInterviewScheduleId,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateInterviewFeedBackId,
								                          @InterviewRatingId,
								                          @CandidateInterviewScheduleId,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateInterviewFeedBack] SET InterviewRatingId = @InterviewRatingId,
								                  CandidateInterviewScheduleId = @CandidateInterviewScheduleId,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateInterviewFeedBackId

					END

						 EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = NULL,
                       @Description = 'CandidateInterviewFeedBack', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = @JobOpeningId

				            
				    SELECT Id FROM [dbo].[CandidateInterviewFeedBack] WHERE Id = @CandidateInterviewFeedBackId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
