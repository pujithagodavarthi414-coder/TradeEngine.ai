CREATE PROCEDURE [dbo].[USP_UpsertCandidateExperienceDetails]
(
   @CandidateExperienceDetailsId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER,
   @OccupationTitle NVARCHAR(500) = NULL,
   @Company NVARCHAR(500),
   @CompanyType NVARCHAR(500) = NULL,
   @Description NVARCHAR(MAX) = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @Location NVARCHAR(500) = NULL,
   @IsCurrentlyWorkingHere BIT = NULL,
   @Salary FLOAT = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
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
		IF(@OccupationTitle IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'OccupationTitle')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateExperienceDetailsIdCount INT = (SELECT COUNT(1) FROM CandidateExperienceDetails  WHERE Id = @CandidateExperienceDetailsId)

			DECLARE @CandidateExperienceDetailsCount INT = (SELECT COUNT(1) FROM CandidateExperienceDetails WHERE CandidateId = @CandidateId AND OccupationTitle = @OccupationTitle AND (@CandidateExperienceDetailsId IS NULL OR @CandidateExperienceDetailsId <> Id))

			DECLARE @IsCurrentWorkingExists INT = (SELECT COUNT(1) FROM CandidateExperienceDetails WHERE CandidateId = @CandidateId AND IsCurrentlyWorkingHere = @IsCurrentlyWorkingHere AND (@CandidateExperienceDetailsId IS NULL OR @CandidateExperienceDetailsId <> Id))
       
			IF(@IsCurrentWorkingExists > 0 AND @IsCurrentlyWorkingHere = 1)
			BEGIN

				RAISERROR ('CandidateExperienceWithCurrentWorkngIsExisted',11, 1)

			END
			
			IF(@CandidateExperienceDetailsIdCount = 0 AND @CandidateExperienceDetailsId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateExperienceDetails')

			END
			IF (@CandidateExperienceDetailsCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateExperienceDetails')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateExperienceDetailsId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateExperienceDetails] WHERE Id = @CandidateExperienceDetailsId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateExperienceDetailsId IS NULL)
					  BEGIN

						 SET @CandidateExperienceDetailsId = NEWID()

						 INSERT INTO [dbo].[CandidateExperienceDetails]([Id],
																	    CandidateId,
																	    OccupationTitle,
																		Company,
																		CompanyType,
																		[Description],
																		DateFrom,
																		DateTo,
																		[Location],
																		IsCurrentlyWorkingHere,
																		Salary,
																		CurrencyId,
																	    [InActiveDateTime],
																	    [CreatedDateTime],
																	    [CreatedByUserId])
																 SELECT @CandidateExperienceDetailsId,
																        @CandidateId,
																 		@OccupationTitle,
																 		@Company,
																 		@CompanyType,
																 		@Description,
																 		@DateFrom,
																 		@DateTo,
																 		@Location,
																 		@IsCurrentlyWorkingHere,
																 		@Salary,
																 		@CurrencyId,
																        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
																        @Currentdate,
																        @OperationsPerformedBy		
							         								  
					END
					ELSE
					BEGIN

						UPDATE [CandidateExperienceDetails] SET CandidateId = @CandidateId,
																OccupationTitle = @OccupationTitle,
																Company = @Company,
																CompanyType = @CompanyType,
																[Description] = @Description,
																DateFrom = @DateFrom,
																DateTo = @DateTo,
																[Location] = @Location,
																IsCurrentlyWorkingHere = @IsCurrentlyWorkingHere,
																Salary = @Salary,
																CurrencyId = @CurrencyId,
									                            InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									                            UpdatedDateTime = @Currentdate,
									                            UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateExperienceDetailsId

					END

					  EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = NULL, @NewValue = NULL, @FieldName = NULL,
		               @Description = 'CandidateExperienceDetailsChanged', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = NULL

				    SELECT Id FROM [dbo].[CandidateExperienceDetails] WHERE Id = @CandidateExperienceDetailsId
				                   
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
