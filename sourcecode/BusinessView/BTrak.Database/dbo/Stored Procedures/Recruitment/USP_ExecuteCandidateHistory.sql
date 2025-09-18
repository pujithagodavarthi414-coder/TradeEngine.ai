CREATE PROCEDURE [dbo].[USP_ExecuteCandidateHistory]
(
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @CandidateJobOpeningId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR(500) = NULL,
   @LastName NVARCHAR(500) = NULL,
   @FatherName NVARCHAR(500) = NULL,
   @Email NVARCHAR(500) = NULL,
   @ProfileImage [nvarchar](800) = NULL,
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
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

						 DECLARE @OldFirstName NVARCHAR(500)  = NULL 
						 DECLARE @OldLastName NVARCHAR(500) = NULL  
						 DECLARE @OldFatherName NVARCHAR(500) = NULL  
						 DECLARE @OldEmail NVARCHAR(500) = NULL  
						 DECLARE @OldProfileImage [nvarchar](800) = NULL  
						 DECLARE @OldSecondaryEmail NVARCHAR(500) = NULL 
						 DECLARE @OldMobile NVARCHAR(100)=NULL 
						 DECLARE @OldPhone NVARCHAR(100)=NULL 
						 DECLARE @OldFax NVARCHAR(500)=NULL 
						 DECLARE @OldWebsite NVARCHAR(500)=NULL 
						 DECLARE @OldSkypeId NVARCHAR(500)=NULL 
						 DECLARE @OldTwitterId NVARCHAR(500)=NULL 
						 DECLARE @OldAddressJson NVARCHAR(MAX) = NULL  
						 DECLARE @OldDescription NVARCHAR(MAX) = NULL  
						 DECLARE @OldCountryId UNIQUEIDENTIFIER = NULL 
						 DECLARE @OldExperienceInYears FLOAT=NULL 
						 DECLARE @OldCurrentDesignation UNIQUEIDENTIFIER=NULL 
						 DECLARE @OldCurrentSalary FLOAT=NULL 
						 DECLARE @OldExpectedSalary FLOAT=NULL 
						 DECLARE @OldSourceId UNIQUEIDENTIFIER = NULL 
						 DECLARE @OldSourcePersonId UNIQUEIDENTIFIER = NULL 
						 DECLARE @OldHiringStatusId UNIQUEIDENTIFIER = NULL 
						 DECLARE @OldAssignedToManagerId UNIQUEIDENTIFIER = NULL 
						 DECLARE @OldClosedById UNIQUEIDENTIFIER=NULL 
					       
	SELECT    @OldFirstName = FirstName,
			  @OldLastName = LastName,
			  @OldFatherName = FatherName,
			  @OldEmail = Email,
			  @ProfileImage = ISNULL(ProfileImage, ''),
			  @OldSecondaryEmail = ISNULL(SecondaryEmail, ''),
			  @OldMobile = Mobile,
			  @OldPhone = Phone,
			  @OldFax = Fax,
			  @OldWebsite = ISNULL(Website, ''),
			  @OldSkypeId = ISNULL(SkypeId, ''),
			  @OldTwitterId = ISNULL(TwitterId, ''),
			  @OldAddressJson = ISNULL(AddressJson, ''),
			  @OldCountryId = ISNULL(CountryId, '00000000-0000-0000-0000-000000000000'),
			  @OldExperienceInYears = ExperienceInYears,
			  @OldCurrentDesignation = ISNULL(CurrentDesignation, '00000000-0000-0000-0000-000000000000'),
			  @OldCurrentSalary = Currentsalary,
			  @OldExpectedSalary = ExpectedSalary,
			  @OldSourceId = ISNULL(SourceId, '00000000-0000-0000-0000-000000000000'),
			  @OldSourcePersonId = ISNULL(SourcePersonId, '00000000-0000-0000-0000-000000000000'),
			  @OldHiringStatusId = ISNULL(HiringStatusId, '00000000-0000-0000-0000-000000000000'),
			  @OldAssignedToManagerId = ISNULL(AssignedToManagerId, '00000000-0000-0000-0000-000000000000'),
			  @OldClosedById = ISNULL(ClosedById, '00000000-0000-0000-0000-000000000000')
		FROM Candidate
		WHERE Id=@CandidateId
		
		IF(@ProfileImage IS NULL) SET @ProfileImage = ''
		IF(@SecondaryEmail IS NULL) SET @SecondaryEmail = ''
		IF(@Phone IS NULL) SET @Phone = ''
		IF(@Fax IS NULL) SET @Fax = ''
		IF(@Website IS NULL) SET @Website = ''
		IF(@SkypeId IS NULL) SET @SkypeId = ''
		IF(@TwitterId IS NULL) SET @TwitterId = ''
		IF(@Description IS NULL) SET @Description = ''
		IF(@CurrentDesignation IS NULL) SET @CurrentDesignation = '00000000-0000-0000-0000-000000000000'
		IF(@SourcePersonId IS NULL) SET @SourcePersonId = '00000000-0000-0000-0000-000000000000'

		SELECT  @OldDescription = [Description] FROM CandidateJobOpening WHERE JobOpeningId = @JobOpeningId AND CandidateId = @CandidateId

		SELECT  @OldHiringStatusId = [HiringStatusId] FROM CandidateJobOpening WHERE JobOpeningId = @JobOpeningId AND CandidateId = @CandidateId
		
		DECLARE @OldValue NVARCHAR(500)

		    DECLARE @NewValue NVARCHAR(500)

		    DECLARE @FieldName NVARCHAR(200)

		    DECLARE @HistoryDescription NVARCHAR(800)

		IF(@OldFirstName <> @FirstName)
		BEGIN

		        SET @OldValue = @OldFirstName

		        SET @NewValue = @FirstName

		        SET @FieldName = 'FirstName'	

		        SET @HistoryDescription = 'FirstNameChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldLastName <> @LastName)
		BEGIN

		        SET @OldValue = @OldLastName

		        SET @NewValue = @LastName

		        SET @FieldName = 'LastName'	

		        SET @HistoryDescription = 'LastNameChanged'
		        
		        EXEC [dbo].[USP_InsertCandidateHistory] @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldFatherName <> @FatherName)
		BEGIN

		        SET @OldValue = @OldFatherName

		        SET @NewValue = @FatherName

		        SET @FieldName = 'FatherName'	

		        SET @HistoryDescription = 'FatherNameChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldEmail <> @Email)
		BEGIN

		        SET @OldValue = @OldEmail

		        SET @NewValue = @Email

		        SET @FieldName = 'Email'	

		        SET @HistoryDescription = 'EmailChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldProfileImage <> @ProfileImage)
		BEGIN

		        SET @OldValue = @OldProfileImage

		        SET @NewValue = @ProfileImage

		        SET @FieldName = 'ProfileImage'	

		        SET @HistoryDescription = 'ProfileImageChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldSecondaryEmail <> @SecondaryEmail)
		BEGIN

		        SET @OldValue = @OldSecondaryEmail

		        SET @NewValue = @SecondaryEmail

		        SET @FieldName = 'SecondaryEmail'	

		        SET @HistoryDescription = 'SecondaryEmailChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldMobile <> @Mobile)
		BEGIN

		        SET @OldValue = @OldMobile

		        SET @NewValue = @Mobile

		        SET @FieldName = 'Mobile'	

		        SET @HistoryDescription = 'MobileChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldPhone <> @Phone)
		BEGIN

		        SET @OldValue = @OldPhone

		        SET @NewValue = @Phone

		        SET @FieldName = 'Phone'	

		        SET @HistoryDescription = 'PhoneChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldFax <> @Fax)
		BEGIN

		        SET @OldValue = @OldFax

		        SET @NewValue = @Fax

		        SET @FieldName = 'Fax'	

		        SET @HistoryDescription = 'FaxChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldWebsite <> @Website)
		BEGIN

		        SET @OldValue = @OldWebsite

		        SET @NewValue = @Website

		        SET @FieldName = 'Website'	

		        SET @HistoryDescription = 'WebsiteChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldSkypeId <> @SkypeId)
		BEGIN

		        SET @OldValue = @OldSkypeId

		        SET @NewValue = @SkypeId

		        SET @FieldName = 'SkypeId'	

		        SET @HistoryDescription = 'SkypeIdChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldTwitterId <> @TwitterId)
		BEGIN

		        SET @OldValue = @OldTwitterId

		        SET @NewValue = @TwitterId

		        SET @FieldName = 'TwitterId'	

		        SET @HistoryDescription = 'TwitterIdChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldAddressJson <> @AddressJson)
		BEGIN

			SELECT * INTO #NewAddress
			FROM OPENJSON(@AddressJson) WITH (address1 NVARCHAR(MAX), address2 NVARCHAR(MAX), [state] UNIQUEIDENTIFIER, zipcode NVARCHAR(20))
			IF(@OldAddressJson IS NULL OR @OldAddressJson = '' OR ISJSON(@OldAddressJson) = 0)
			BEGIN
				SET @NewValue = (SELECT TOP(1)address1 FROM #NewAddress)
				IF(@NewValue IS NOT NULL AND @NewValue <> '')
				BEGIN
					EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @NewValue, @FieldName = 'Address1',
								@Description = 'Address1Added', @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
				END
					
				SET @NewValue = (SELECT TOP(1)address2 FROM #NewAddress)
				IF(@NewValue IS NOT NULL AND @NewValue <> '')
				BEGIN
					EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @NewValue, @FieldName = 'Address2',
								@Description = 'Address2Added', @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
				END

				IF((SELECT TOP(1)[state] FROM #NewAddress) IS NOT NULL)
				BEGIN
					SET @NewValue = (SELECT StateName FROM [State] WHERE Id = (SELECT TOP(1)[state] FROM #NewAddress))
					EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @NewValue, @FieldName = 'State',
								@Description = 'StateAdded', @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
				END

				SET @NewValue = (SELECT TOP(1)zipcode FROM #NewAddress)
				IF(@NewValue IS NOT NULL AND @NewValue <> '')
				BEGIN
					EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @NewValue, @FieldName = 'ZipCode',
								@Description = 'ZipCodeAdded', @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
				END
					
			END
			ELSE IF(@OldAddressJson IS NOT NULL)
			BEGIN
				IF(ISJSON(@OldAddressJson) = 1)
				BEGIN
					SELECT * INTO #OldAddress
						FROM OPENJSON(@OldAddressJson) WITH (address1 NVARCHAR(MAX), address2 NVARCHAR(MAX), [state] UNIQUEIDENTIFIER, zipcode NVARCHAR(20))

					SET @NewValue = (SELECT TOP(1)address1 FROM #NewAddress)
					SET @OldValue = (SELECT TOP(1)address1 FROM #OldAddress)
					IF(@NewValue <> @OldValue)
					BEGIN
						SET @HistoryDescription = IIF(@OldValue IS NULL OR @OldValue = '', 'Address1Added','Address1Changed')
						EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = 'Address1',
									@Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
					END
					
					SET @NewValue = (SELECT TOP(1)address2 FROM #NewAddress)
					SET @OldValue = (SELECT TOP(1)address2 FROM #OldAddress)
					IF(@NewValue <> @OldValue)
					BEGIN
						SET @HistoryDescription = IIF(@OldValue IS NULL OR @OldValue = '', 'Address2Added','Address2Changed')
						EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = 'Address2',
									@Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
					END
					IF((SELECT TOP(1)[state] FROM #NewAddress) <> (SELECT TOP(1)[state] FROM #OldAddress))
					BEGIN
						SET @NewValue = (SELECT StateName FROM [State] WHERE Id = (SELECT TOP(1)[state] FROM #NewAddress))
						SET @OldValue = ''
						SET @HistoryDescription = IIF((SELECT TOP(1)[state] FROM #OldAddress) IS NULL , 'StateAdded','StateChanged')
						
						IF(@HistoryDescription = 'StateChanged')
						BEGIN
							SET @OldValue = (SELECT StateName FROM [State] WHERE Id = (SELECT TOP(1)[state] FROM #OldAddress))
						END

						EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = 'State',
									@Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
					END

					SET @NewValue = (SELECT TOP(1)zipcode FROM #NewAddress)
					SET @OldValue = (SELECT TOP(1)zipcode FROM #OldAddress)
					IF(@NewValue IS NOT NULL AND @NewValue <> '')
					BEGIN
						SET @HistoryDescription = IIF(@OldValue IS NULL OR @OldValue = '', 'ZipCodeAdded','ZipCodeChanged')
						EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = 'ZipCode',
									@Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
					END
				END
			END
		    
		END

		IF(@OldCountryId <> @CountryId)
		BEGIN

		        SET @OldValue = (SELECT CountryName FROM Country WHERE Id=@OldCountryId)

		        SET @NewValue = (SELECT CountryName FROM Country WHERE Id=@CountryId)

		        SET @FieldName = 'Country'	

		        SET @HistoryDescription = 'CountryChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END
		
		IF(@OldExperienceInYears <> @ExperienceInYears)
		BEGIN

		        SET @OldValue = @OldExperienceInYears

		        SET @NewValue = @ExperienceInYears

		        SET @FieldName = 'ExperienceInYears'	

		        SET @HistoryDescription = 'ExperienceInYearsChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldCurrentDesignation <> @CurrentDesignation)
		BEGIN

		        SET @OldValue = (SELECT DesignationName FROM Designation WHERE Id = @OldCurrentDesignation)

		        SET @NewValue = (SELECT DesignationName FROM Designation WHERE Id = @CurrentDesignation)

		        SET @FieldName = 'CurrentDesignation'	

		        SET @HistoryDescription = 'CurrentDesignationChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldCurrentSalary <> @CurrentSalary)
		BEGIN

		        SET @OldValue = @OldCurrentSalary

		        SET @NewValue = @CurrentSalary

		        SET @FieldName = 'CurrentSalary'	

		        SET @HistoryDescription = 'CurrentSalaryChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END
		
		IF(@OldExpectedSalary <> @ExpectedSalary)
		BEGIN

		        SET @OldValue = @OldExpectedSalary

		        SET @NewValue = @ExpectedSalary

		        SET @FieldName = 'ExpectedSalary'	

		        SET @HistoryDescription = 'ExpectedSalaryChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldSourceId <> @SourceId)
		BEGIN
		
		        SET @OldValue = (Select [Name] FROM Source WHERE Id=@OldSourceId)

		        SET @NewValue = (Select [Name] FROM Source WHERE Id=@SourceId)

		        SET @FieldName = 'SourceId'	

		        SET @HistoryDescription = 'SourceIdChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END
		
		IF(@OldSourcePersonId <> @SourcePersonId)
		BEGIN
		
		        SET @OldValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@OldSourcePersonId)

		        SET @NewValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@SourcePersonId)

		        SET @FieldName = 'SourcePersonId'	

		        SET @HistoryDescription = 'SourcePersonIdChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldHiringStatusId <> @HiringStatusId)
		BEGIN
		
		        SET @OldValue = (Select [Status] FROM HiringStatus WHERE Id=@OldHiringStatusId)

		        SET @NewValue = (Select [Status] FROM HiringStatus WHERE Id=@HiringStatusId)

		        SET @FieldName = 'HiringStatusId'	

		        SET @HistoryDescription = 'HiringStatusChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END

		IF(@OldAssignedToManagerId <> @AssignedToManagerId)
		BEGIN
		
		        SET @OldValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@OldAssignedToManagerId)

		        SET @NewValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@AssignedToManagerId)

		        SET @FieldName = 'AssignedToManager'	

		        SET @HistoryDescription = 'AssignedToManagerChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END		
		
		IF(@OldClosedById <> @ClosedById)
		BEGIN
		
		        SET @OldValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@OldClosedById)

		        SET @NewValue = (Select FirstName+' '+SurName AS [Name] FROM [User] WHERE Id=@ClosedById)

		        SET @FieldName = 'ClosedById'	

		        SET @HistoryDescription = 'ClosedByIdChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END	

		IF(@OldDescription <> @Description)
		BEGIN
		
		        SET @OldValue = @OldDescription

		        SET @NewValue = @Description

		        SET @FieldName = 'Description'	

		        SET @HistoryDescription = 'DescriptionChanged'
		        
		        EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @JobOpeningId = @JobOpeningId
		    
		END	

	END TRY
	BEGIN CATCH

	    	THROW

	END CATCH

END
GO
