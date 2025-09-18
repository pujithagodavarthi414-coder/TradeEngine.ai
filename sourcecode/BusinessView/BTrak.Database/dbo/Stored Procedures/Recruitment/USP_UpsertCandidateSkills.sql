CREATE PROCEDURE [dbo].[USP_UpsertCandidateSkills]
(
   @CandidateSkillId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @SkillId UNIQUEIDENTIFIER = NULL,
   @Experience FLOAT = NULL,
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
		IF(@SkillId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'SkillId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateSkillIdCount INT = (SELECT COUNT(1) FROM CandidateSkills  WHERE Id = @CandidateSkillId)

			DECLARE @CandidateSkillCount INT = (SELECT COUNT(1) FROM CandidateSkills WHERE CandidateId = @CandidateId AND SkillId = @SkillId AND (@CandidateSkillId IS NULL OR @CandidateSkillId <> Id))
       
			IF(@CandidateSkillIdCount = 0 AND @CandidateSkillId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateSkill')

			END
			IF (@CandidateSkillCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateSkill')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateSkillId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateSkills] WHERE Id = @CandidateSkillId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateSkillId IS NULL)
					  BEGIN

						 SET @CandidateSkillId = NEWID()

						 INSERT INTO [dbo].[CandidateSkills]([Id],
														  CandidateId,
								                          SkillId,
														  Experience,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateSkillId,
								                          @CandidateId,
								                          @SkillId,
														  @Experience,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateSkills] SET CandidateId = @CandidateId,
								                  SkillId = @SkillId,
												  Experience = @Experience,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateSkillId

					END
				            

					  EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = NULL, @NewValue = NULL, @FieldName = NULL,
		               @Description = 'CandidateSkillsChanged', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = NULL

				    SELECT Id FROM [dbo].[CandidateSkills] WHERE Id = @CandidateSkillId
				                   
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
