CREATE PROCEDURE [dbo].[USP_UpsertCandidateEducationalDetails]
(
   @CandidateEducationalDetailsId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER,
   @Institute NVARCHAR(500),
   @Department NVARCHAR(500) = NULL,
   @NameOfDegree NVARCHAR(500) = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @IsPursuing BIT = NULL,
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
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateEducationalDetailsIdCount INT = (SELECT COUNT(1) FROM CandidateEducationalDetails  WHERE Id = @CandidateEducationalDetailsId)

			DECLARE @CandidateEducationalDetailsCount INT = (SELECT COUNT(1) FROM CandidateEducationalDetails WHERE CandidateId = @CandidateId AND NameOfDegree = @NameOfDegree AND (@CandidateEducationalDetailsId IS NULL OR @CandidateEducationalDetailsId <> Id))

			DECLARE @IsPursuingExisted INT = (SELECT COUNT(1) FROM CandidateEducationalDetails WHERE CandidateId = @CandidateId AND IsPursuing = @IsPursuing AND (@CandidateEducationalDetailsId IS NULL OR @CandidateEducationalDetailsId <> Id))
       
			IF(@IsPursuingExisted > 0 AND @IsPursuing = 1)
			BEGIN

				RAISERROR ('CandidateEducationWithPursuingIsExisted',11, 1)

			END
			
			IF(@CandidateEducationalDetailsIdCount = 0 AND @CandidateEducationalDetailsId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateEducationalDetails')

			END
			IF (@CandidateEducationalDetailsCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateEducationalDetails')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateEducationalDetailsId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateEducationalDetails] WHERE Id = @CandidateEducationalDetailsId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateEducationalDetailsId IS NULL)
					  BEGIN

						 SET @CandidateEducationalDetailsId = NEWID()

						 INSERT INTO [dbo].[CandidateEducationalDetails]([Id],
																	     CandidateId,
																	     Institute,
																	     Department,
																	     NameOfDegree,
																	     DateFrom,
																	     DateTo,
																	     IsPursuing,
																	     [InActiveDateTime],
																	     [CreatedDateTime],
																	     [CreatedByUserId])
																  SELECT @CandidateEducationalDetailsId,
																         @CandidateId,
																  		 @Institute,
																  		 @Department,
																  		 @NameOfDegree,
																  		 @DateFrom,
																  		 @DateTo,
																  		 @IsPursuing,
																         CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
																         @Currentdate,
																         @OperationsPerformedBy		
							         								  
					END
					ELSE
					BEGIN

						UPDATE [CandidateEducationalDetails] SET CandidateId = @CandidateId,
																 Institute = @Institute,
																 Department = @Department,
																 NameOfDegree = @NameOfDegree,
																 DateFrom = @DateFrom,
																 DateTo = @DateTo,
																 IsPursuing = @IsPursuing,
									                             InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									                             UpdatedDateTime = @Currentdate,
									                             UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateEducationalDetailsId

					END
				            
				  
				  EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = NULL, @NewValue = NULL, @FieldName = NULL,
		               @Description = 'CandidateEducationalDetailsChanged', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = NULL

				    SELECT Id FROM [dbo].[CandidateEducationalDetails] WHERE Id = @CandidateEducationalDetailsId
				                   
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
