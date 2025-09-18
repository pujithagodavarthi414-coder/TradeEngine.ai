--EXEC [dbo].[USP_UpsertCandidate] @FirstName='5',@LastName='5',@Email='5@3.com',@Phone='5',@AddressJson='4',@JobOpeningId='2C2D0A27-23DF-4AD5-AB90-380A271437BB',@OperationsPerformedBy='498C2AC7-A670-42F7-AF90-2B35624617E8'
CREATE PROCEDURE [dbo].[USP_UpsertCandidate]
(
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @CandidateJobOpeningId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR(500),
   @LastName NVARCHAR(500),
   @FatherName NVARCHAR(500) = NULL,
   @Email NVARCHAR(500),
   @ProfileImage [nvarchar](800),
   @SecondaryEmail NVARCHAR(500)=NULL,
   @Mobile NVARCHAR(100)=NULL,
   @Phone NVARCHAR(100)=NULL,
   @Fax NVARCHAR(500)=NULL,
   @Website NVARCHAR(500)=NULL,
   @SkypeId NVARCHAR(500)=NULL,
   @TwitterId NVARCHAR(500)=NULL,
   @AddressJson NVARCHAR(MAX),
   @Description NVARCHAR(MAX),
   @CountryId UNIQUEIDENTIFIER = NULL,
   @ExperienceInYears FLOAT=NULL,
   @CurrentDesignation UNIQUEIDENTIFIER=NULL,
   @CurrentSalary FLOAT=NULL,
   @ExpectedSalary FLOAT=NULL,
   @SourceId UNIQUEIDENTIFIER = NULL,
   @SourcePersonId UNIQUEIDENTIFIER = NULL,
   @HiringStatusId UNIQUEIDENTIFIER = NULL,
   @AssignedToManagerId UNIQUEIDENTIFIER = NULL,
   @ClosedById UNIQUEIDENTIFIER=NULL,
   @JobOpeningId UNIQUEIDENTIFIER=NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@Email IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateTitle')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateIdCount INT = (SELECT COUNT(1) FROM Candidate  WHERE Id = @CandidateId)

			DECLARE @CandidateCount INT = (SELECT COUNT(1) FROM CandidateJobOpening CJO 
			INNER JOIN Candidate C ON C.Id = CJO.CandidateId 
			WHERE C.Email = @Email AND CJO.JobOpeningId = @JobOpeningId 
			AND (@CandidateId IS NULL OR @CandidateId <> C.Id) AND CJO.InActiveDateTime IS NULL)
       
			 IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET @JobOpeningId = NULL

			 IF(@HiringStatusId = '00000000-0000-0000-0000-000000000000') SET @HiringStatusId = NULL

			 IF(@CandidateJobOpeningId = '00000000-0000-0000-0000-000000000000') SET @CandidateJobOpeningId = NULL

			 IF(@Description = '') SET @Description = NULL

			 IF(@SecondaryEmail = '') SET @SecondaryEmail = NULL
			 IF(@Mobile = '') SET @Mobile = NULL
			 IF(@Fax = '') SET @Fax = NULL
			 IF(@Website = '') SET @Website = NULL
			 IF(@SkypeId = '') SET @SkypeId = NULL
			 IF(@TwitterId = '') SET @TwitterId = NULL
			 
			IF(@CandidateIdCount = 0 AND @CandidateId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'Candidate')

			END
			IF (@CandidateCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'Candidate')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				DECLARE @AppliedDateTime DATETIME
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [Candidate] WHERE Id = @CandidateId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateId IS NULL)
					  BEGIN

						 SET @CandidateId = NEWID()
						 DECLARE @UniqueName NVARCHAR(100) = 'CR'
						DECLARE @MaxNumber INT = (SELECT MAX(CAST(SUBSTRING(CandidateUniqueName,LEN(@Uniquename) + 2,LEN(CandidateUniqueName)) AS INT)) 
                            FROM Candidate WHERE CandidateUniqueName IS NOT NULL AND CompanyId = @CompanyId )
						SET @UniqueName = @UniqueName + '-' +  CAST(ISNULL(@MaxNumber,0) + 1 AS NVARCHAR(250))

						 INSERT INTO [dbo].[Candidate]([Id],
												       [CandidateUniqueName],
													   FirstName,
													   LastName,
													   FatherName,
													   Email,
													   ProfileImage,
													   SecondaryEmail,
													   Mobile,
													   Phone,
													   Fax,
													   Website,
													   SkypeId,
													   TwitterId,
													   AddressJson,
													   CountryId,
													   ExperienceInYears,
													   CurrentDesignation,
													   CurrentSalary,
													   ExpectedSalary,
													   SourceId,
													   SourcePersonId,
													   AssignedToManagerId,
													   ClosedById,
													   CompanyId,
								                       [InActiveDateTime],
								                       [CreatedDateTime],
								                       [CreatedByUserId])
								                 SELECT @CandidateId,
														@UniqueName,
								                        @FirstName,
													    @LastName,
														@FatherName,
													    @Email,
														@ProfileImage,
													    @SecondaryEmail,
													    @Mobile,
													    @Phone,
													    @Fax,
													    @Website,
													    @SkypeId,
													    @TwitterId,
													    @AddressJson,
													    @CountryId,
													    @ExperienceInYears,
													    @CurrentDesignation,
													    @CurrentSalary,
													    @ExpectedSalary,
													    @SourceId,
													    @SourcePersonId,
													    @AssignedToManagerId,
													    @ClosedById,
														@CompanyId,
								                        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                        @Currentdate,
								                        @OperationsPerformedBy		

						IF(@JobOpeningId IS NOT NULL AND @CandidateJobOpeningId IS NULL)
						BEGIN
						SET @HiringStatusId=(Select Id From HiringStatus Where [Order]='1' AND CompanyId=@CompanyId)
						SET @AppliedDateTime  = GETDATE()
						EXEC USP_UpsertCandidateJobOpening @OperationsPerformedBy=@OperationsPerformedBy,
														   @CandidateId=@CandidateId,
														   @JobOpeningId=@JobOpeningId,
														   @AppliedDateTime=@AppliedDateTime,
														   @Description=@Description,
														   @HiringStatusId=@HiringStatusId,
														   @CandidateJobOpeningId=@CandidateJobOpeningId
						END

						EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @FirstName, @FieldName = 'CandidateAdded',
		                                                @Description = 'CandidateAdded', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId=@JobOpeningId


					END
					ELSE
					BEGIN

						EXEC [dbo].[USP_ExecuteCandidateHistory]    
															  @CandidateId = @CandidateId,
															  @CandidateJobOpeningId = @CandidateJobOpeningId,
															  @FirstName = @FirstName,
															  @LastName = @LastName,
															  @FatherName = @FatherName,
															  @Email = @Email,
															  @ProfileImage = @ProfileImage,
															  @SecondaryEmail = @SecondaryEmail,
															  @Mobile = @Mobile,
															  @Phone = @Phone,
															  @Fax = @Fax,
															  @Website = @Website,
															  @SkypeId = @SkypeId,
															  @TwitterId = @TwitterId,
															  @AddressJson = @AddressJson,
															  @Description = @Description,
															  @CountryId = @CountryId,
															  @ExperienceInYears = @ExperienceInYears,
															  @CurrentDesignation = @CurrentDesignation,
															  @CurrentSalary = @CurrentSalary,
															  @ExpectedSalary = @ExpectedSalary,
															  @SourceId = @SourceId,
															  @SourcePersonId = @SourcePersonId,
															  @HiringStatusId = @HiringStatusId,
															  @AssignedToManagerId = @AssignedToManagerId,
															  @ClosedById = @ClosedById,
															  @JobOpeningId = @JobOpeningId,
															  @OperationsPerformedBy = @OperationsPerformedBy

						UPDATE [Candidate] SET FirstName = @FirstName,
											   LastName = @LastName,
											   FatherName = @FatherName,
											   Email = @Email,
											   ProfileImage = @ProfileImage,
											   SecondaryEmail = @SecondaryEmail,
											   Mobile = @Mobile,
											   Phone = @Phone,
											   Fax = @Fax,
											   Website = @Website,
											   SkypeId = @SkypeId,
											   TwitterId = @TwitterId,
											   AddressJson = @AddressJson,
											   CountryId = @CountryId,
											   ExperienceInYears = @ExperienceInYears,
											   CurrentDesignation = @CurrentDesignation,
											   CurrentSalary = @CurrentSalary,
											   ExpectedSalary = @ExpectedSalary,
											   SourceId = @SourceId,
											   SourcePersonId = @SourcePersonId,
											   --HiringStatusId = @HiringStatusId,
											   AssignedToManagerId = @AssignedToManagerId,
											   ClosedById = @ClosedById,
											   CompanyId = @CompanyId,
									           InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									           UpdatedDateTime = @Currentdate,
									           UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateId

						IF((SELECT IsOffered From HiringStatus where Id=@HiringStatusId) = 1)
						BEGIN

						UPDATE [Candidate] SET ClosedById = @OperationsPerformedBy WHERE Id = @CandidateId

						END

						IF(@JobOpeningId IS NOT NULL AND @CandidateJobOpeningId IS NOT NULL)
						BEGIN

						DECLARE @TimestampInner TIMESTAMP = (SELECT [TimeStamp] FROM [CandidateJobOpening] WHERE Id = @CandidateJobOpeningId) 
				     
						SET @AppliedDateTime  = GETDATE()
						EXEC USP_UpsertCandidateJobOpening @OperationsPerformedBy=@OperationsPerformedBy,
														   @CandidateId=@CandidateId,
														   @JobOpeningId=@JobOpeningId,
														   @AppliedDateTime=@AppliedDateTime,
														   @HiringStatusId=@HiringStatusId,
														   @Description=@Description,
														   @CandidateJobOpeningId=@CandidateJobOpeningId,
														   @TimeStamp=@TimestampInner

						END
					END
				            
				    SELECT Id FROM [dbo].[Candidate] WHERE Id = @CandidateId
				                   
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
