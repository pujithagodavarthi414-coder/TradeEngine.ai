CREATE PROCEDURE [dbo].[USP_UpsertCandidateJobOpening]
(
   @CandidateJobOpeningId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @AppliedDateTime DATETIME,
   @Description NVARCHAR(MAX),
   @InterviewProcessId UNIQUEIDENTIFIER = NULL,
   @HiringStatusId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@CandidateId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateId')

		END
		IF(@JobOpeningId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'JobOpeningId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateJobOpeningIdCount INT = (SELECT COUNT(1) FROM CandidateJobOpening  WHERE Id = @CandidateJobOpeningId)

			DECLARE @CandidateJobOpeningCount INT = (SELECT COUNT(1) FROM CandidateJobOpening WHERE JobOpeningId = @JobOpeningId AND CandidateId = @CandidateId AND (@CandidateJobOpeningId IS NULL OR @CandidateJobOpeningId <> Id) AND InActiveDateTime IS NULL)
       
			IF(@CandidateJobOpeningIdCount = 0 AND @CandidateJobOpeningId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateJobOpening')

			END
			IF (@CandidateJobOpeningCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateJobOpening')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateJobOpeningId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateJobOpening] WHERE Id = @CandidateJobOpeningId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateJobOpeningId IS NULL)
					  BEGIN

						 SET @CandidateJobOpeningId = NEWID()

						 INSERT INTO [dbo].[CandidateJobOpening]([Id],
														  JobOpeningId,
								                          CandidateId,
														  AppliedDateTime,
														  HiringStatusId,
														  InterviewProcessId,
														  [Description],
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateJobOpeningId,
								                          @JobOpeningId,
								                          @CandidateId,
														  @AppliedDateTime,
														  @HiringStatusId,
														  @InterviewProcessId,
														  @Description,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateJobOpening] SET JobOpeningId = @JobOpeningId,
								                  CandidateId = @CandidateId,
												  AppliedDateTime = @AppliedDateTime,
												  HiringStatusId = @HiringStatusId,
												  InterviewProcessId = @InterviewProcessId,
												  [Description]=@Description,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateJobOpeningId

					END
				            
				    --SELECT Id FROM [dbo].[CandidateJobOpening] WHERE Id = @CandidateJobOpeningId
				                   
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
