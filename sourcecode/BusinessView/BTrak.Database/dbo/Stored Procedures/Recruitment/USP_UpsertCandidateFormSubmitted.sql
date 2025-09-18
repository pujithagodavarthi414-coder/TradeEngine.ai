CREATE PROCEDURE [dbo].[USP_UpsertCandidateFormSubmitted]
(
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR(500),
   @LastName NVARCHAR(500),
   @Email NVARCHAR(500),
   @ProfileImage [nvarchar](800) = NULL,
   @SecondaryEmail NVARCHAR(500) = NULL,
   @Mobile NVARCHAR(100) = NULL,
   @Phone NVARCHAR(100) = NULL,
   @Fax NVARCHAR(500) = NULL,
   @Website NVARCHAR(500) = NULL,
   @SkypeId NVARCHAR(500) = NULL,
   @TwitterId NVARCHAR(500) = NULL,
   @AddressJson NVARCHAR(MAX) = NULL,
   @AddressStreet1 NVARCHAR(200) = NULL,
   @AddressStreet2 NVARCHAR(200) = NULL,
   @ZipCode NVARCHAR(20) = NULL,
   @State UNIQUEIDENTIFIER = NULL,
   @Description NVARCHAR(MAX) = NULL,
   @Country UNIQUEIDENTIFIER = NULL,
   @ExperienceInYears FLOAT = NULL,
   @CurrentDesignation UNIQUEIDENTIFIER = NULL,
   @CurrentSalary FLOAT = NULL,
   @ExpectedSalary FLOAT = NULL,
   @SourceId UNIQUEIDENTIFIER = NULL,
   @SourcePersonId UNIQUEIDENTIFIER = NULL,
   @HiringStatusId UNIQUEIDENTIFIER = NULL,
   @AssignedToManagerId UNIQUEIDENTIFIER = NULL,
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @CandidateJobOpeningId UNIQUEIDENTIFIER = NULL,
   @ReferenceEmployeeId NVARCHAR(100) = NULL,
   @EducationDetailsXml XML = NULL,
   @ExperienceXml XML = NULL,
   @SkillsXml XML = NULL,
   @DocumentsXml XML = NULL,
   @UploadedDocumentsXml XML = NULL,
   @ResumeXml XML = NULL,
   @UploadedResumeXml XML = NULL,
   @FatherName NVARCHAR(500) = NULL
)
AS 
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		IF(@JobOpeningId IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'JobOpening')
		END

		DECLARE @CandidateCount INT = (SELECT COUNT(1) FROM CandidateJobOpening CJO 
			INNER JOIN Candidate C ON C.Id = CJO.CandidateId WHERE C.Email = @Email AND CJO.JobOpeningId = @JobOpeningId)

		IF (@CandidateCount > 0)
		BEGIN
			RAISERROR(50001,11,1,'Candidate')
		END
		DECLARE @HavePermission NVARCHAR(250)  = '1'
		DECLARE @AppliedDateTime DATETIME = GETDATE()
		DECLARE @CompanyId UNIQUEIDENTIFIER, @OperationsPerformedBy UNIQUEIDENTIFIER
		SET @CompanyId = (SELECT CompanyId FROM JobOpening WHERE Id = @JobOpeningId)

		IF(@AddressStreet1 IS NULL)
		BEGIN
			SET @AddressStreet1 = ''
		END
		IF(@AddressStreet2 IS NULL)
		BEGIN
			SET @AddressStreet2 = ''
		END
		IF(@ZipCode IS NULL)
		BEGIN
			SET @ZipCode = ''
		END

		SET @AddressJson = '{"address1":"'+@AddressStreet1+'"'+',"address2":"'+@AddressStreet2+'"'+',"state":"'+CAST(@State AS nvarchar(36))+'"'+',"zipcode":"'+@ZipCode+'"}'
		SET @OperationsPerformedBy = (SELECT TOP(1) U.Id
											FROM UserRole UR 
											INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId
											WHERE R.IsHidden = 1 AND U.CompanyId = @CompanyId)

		IF(@AddressStreet1 IS NULL)
		BEGIN
			SET @AddressStreet1 = ''
		END
		IF(@AddressStreet2 IS NULL)
		BEGIN
			SET @AddressStreet2 = ''
		END
		IF(@ZipCode IS NULL)
		BEGIN
			SET @ZipCode = ''
		END

		SET @AddressJson = '{"address1":"'+@AddressStreet1+'"'+',"address2":"'+@AddressStreet2+'"'+',"state":"'+CAST(@State AS nvarchar(36))+'"'+',"zipcode":"'+@ZipCode+'"}'
		SET @OperationsPerformedBy = (SELECT TOP(1) U.Id
											FROM UserRole UR 
											INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId
											WHERE R.IsHidden = 1 AND U.CompanyId = @CompanyId)

		IF (@HavePermission = '1')
		BEGIN
			
			IF(@ReferenceEmployeeId IS NOT NULL AND @ReferenceEmployeeId <> '')
			BEGIN
				SET @SourcePersonId = (SELECT TOP(1)U.Id FROM [User] AS U
							JOIN Employee AS E ON E.UserId = U.Id
							WHERE E.EmployeeNumber = @ReferenceEmployeeId AND U.CompanyId = @CompanyId
									AND U.InActiveDateTime IS NULL)
				IF(@SourcePersonId IS NOT NULL AND @SourcePersonId <> '')
				BEGIN
					SET @SourceId = (SELECT TOP(1)Id FROM [Source] WHERE CompanyId = @CompanyId AND [IsReferenceNumberNeeded] = 1)
				END
			END

			SET @CandidateId = NEWID()
			DECLARE @UniqueName NVARCHAR(100) = 'CR'
			DECLARE @MaxNumber INT = (SELECT MAX(CAST(SUBSTRING(CandidateUniqueName,LEN(@Uniquename) + 2,LEN(CandidateUniqueName)) AS INT)) 
                FROM Candidate WHERE CandidateUniqueName IS NOT NULL )
			SET @UniqueName = @UniqueName + '-' +  CAST(ISNULL(@MaxNumber,0) + 1 AS NVARCHAR(250))

			INSERT INTO [dbo].[Candidate]([Id],
											[CandidateUniqueName],
											FirstName,
											LastName,
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
											FatherName,
											CompanyId,
											SourceId,
											SourcePersonId,
								            [InActiveDateTime],
								            [CreatedDateTime],
								            [CreatedByUserId])
								        SELECT @CandidateId,
											@UniqueName,
								            @FirstName,
											@LastName,
											@Email,
											@ProfileImage,
											@SecondaryEmail,
											REPLACE(REPLACE(REPLACE(REPLACE(@Mobile,'(',''),')',''),'-', ''), ' ', ''),
											REPLACE(REPLACE(REPLACE(REPLACE(@Phone,'(',''),')',''),'-', ''), ' ', ''),
											@Fax,
											@Website,
											@SkypeId,
											@TwitterId,
											@AddressJson,
											@Country,
											@ExperienceInYears,
											@CurrentDesignation,
											@CurrentSalary,
											@ExpectedSalary,
											@FatherName,
											@CompanyId,
											@SourceId,
											@SourcePersonId,
								            NULL,						 
								            @AppliedDateTime,
								            @OperationsPerformedBy		
			
			EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @FirstName, @FieldName = 'CandidateRegistered',
		                                                @Description = 'CandidateRegistered', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId=@JobOpeningId

			SET @HiringStatusId=(Select Id From HiringStatus Where [Order]='1' AND CompanyId=@CompanyId)
			SET @CandidateJobOpeningId = NEWID()

			INSERT INTO [dbo].[CandidateJobOpening]([Id],
													JobOpeningId,
													CandidateId,
													AppliedDateTime,
													HiringStatusId,
													[Description],
													[InActiveDateTime],
													[CreatedDateTime],
													[CreatedByUserId])
											SELECT @CandidateJobOpeningId,
													@JobOpeningId,
													@CandidateId,
													@AppliedDateTime,
													@HiringStatusId,
													@Description,
													NULL,
													@AppliedDateTime,
													@OperationsPerformedBy		

			--EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = '', @NewValue = @FirstName, @FieldName = 'CandidateAdded',
		 --                                               @Description = 'CandidateAdded', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId=@JobOpeningId
		 IF(@EducationDetailsXml IS NOT NULL)
		 BEGIN

			SELECT NEWID() AS Id,
				   x.value('Department[1]', 'NVARCHAR(MAX)') Department,
				   x.value('NameOfDegree[1]', 'NVARCHAR(MAX)') NameOfDegree,
				   x.value('Institute[1]', 'NVARCHAR(MAX)') Institute,
				   x.value('DateFrom[1]', 'DATETIME') DateFrom,
				   x.value('DateTo[1]', 'DATETIME') DateTo,
				   x.value('IsPursuing[1]', 'BIT') IsPursuing
			INTO #EducationDetails
			FROM @EducationDetailsXml.nodes('/GenericListOfEducationDetails/ListItems/EducationDetails') XmlData(x)

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
															[CreatedByUserId]
															)
												SELECT Id,
														@CandidateId,
														Institute,
														Department,
														NameOfDegree,
														DateFrom,
														DateTo,
														IsPursuing,
														NULL,						 
														GETDATE(),
														@OperationsPerformedBy
												FROM #EducationDetails
		 END

		 IF(@ExperienceXml IS NOT NULL)
		 BEGIN

			SELECT NEWID() AS Id,
				   x.value('OccupationTitle[1]', 'NVARCHAR(500)') OccupationTitle,
				   x.value('CompanyName[1]', 'NVARCHAR(500)') CompanyName,
				   x.value('CompanyType[1]', 'NVARCHAR(500)') CompanyType,
				   x.value('Description[1]', 'NVARCHAR(500)') [Description],
				   x.value('DateFrom[1]', 'DATETIME') DateFrom,
				   x.value('DateTo[1]', 'DATETIME') DateTo,
				   x.value('Location[1]', 'nvarchar(500)') [Location],
				   x.value('IsCurrentlyWorkingHere[1]', 'BIT') IsCurrentlyWorkingHere,
				   x.value('Salary[1]', 'FLOAT') Salary
			INTO #ExperienceDetails
			FROM @ExperienceXml.nodes('/GenericListOfExperience/ListItems/Experience') XmlData(x)

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
														SELECT Id,
															@CandidateId,
															OccupationTitle,
															CompanyName,
															CompanyType,
															[Description],
															DateFrom,
															DateTo,
															Location,
															IsCurrentlyWorkingHere,
															Salary,
															NULL,
															NULL,
															GETDATE(),
															@OperationsPerformedBy
														FROM #ExperienceDetails
		 END

		 IF(@SkillsXml IS NOT NULL)
		 BEGIN
			
			SELECT NEWID() AS Id,
				   x.value('SkillName[1]', 'UNIQUEIDENTIFIER') SkillId,
				   x.value('Experience[1]', 'NVARCHAR(MAX)') Experience
			INTO #SkillDetails
			FROM @SkillsXml.nodes('/GenericListOfSkills/ListItems/Skills') XmlData(x)

			INSERT INTO [dbo].[CandidateSkills]([Id],
												CandidateId,
								                SkillId,
												Experience,
								                [InActiveDateTime],
								                [CreatedDateTime],
												[CreatedByUserId])
								        SELECT Id,
								                @CandidateId,
								                SkillId,
												Experience,
								                NULL,						 
								                GETDATE(),
												@OperationsPerformedBy
											FROM #SkillDetails
		 END

		 IF(@DocumentsXml IS NOT NULL)
		 BEGIN

			SELECT NEWID() AS Id,
				   x.value('DocumentName[1]', 'NVARCHAR(MAX)') DocumentName,
				   x.value('Description[1]', 'NVARCHAR(MAX)') [Description],
				   x.value('DocumentType[1]', 'UNIQUEIDENTIFIER') DocumentType,
				   x.value('Index[1]', 'INT') [Index]
			INTO #DocumentDetails
			FROM @DocumentsXml.nodes('/GenericListOfDocumentsList/ListItems/DocumentsList') XmlData(x)

			INSERT INTO [dbo].[CandidateDocuments]([Id],
													CandidateId,
													DocumentTypeId,
													Document,
													[Description],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
													[CreatedByUserId])
								            SELECT Id,
								                    @CandidateId,
													DocumentType,
													DocumentName,
													[Description],
								                    NULL,
								                    GETDATE(),
													@OperationsPerformedBy
												FROM #DocumentDetails
			
			IF(@UploadedDocumentsXml IS NOT NULL)
			BEGIN
				
				SELECT NEWID() AS Id,
				   '00000000-0000-0000-0000-000000000000' AS ReferenceId, 
				   x.value('FilesListXml[1]', 'NVARCHAR(MAX)') FileList,
				   x.value('Index[1]', 'INT') [Index]
				INTO #UploadedDocument
				FROM @UploadedDocumentsXml.nodes('/GenericListOfUploadedData/ListItems/UploadedData') XmlData(x)

				UPDATE #UploadedDocument SET FileList = REPLACE(FileList,'&lt;','<') FROM #UploadedDocument
				UPDATE #UploadedDocument SET FileList = REPLACE(FileList,'&gt;','>') FROM #UploadedDocument

				--UPDATE #UploadedDocument SET FileListXml = CAST(FileList AS XML) FROM #UploadedDocument

				UPDATE #UploadedDocument SET ReferenceId = D.Id 
					FROM #UploadedDocument AS U 
					INNER JOIN #DocumentDetails AS D ON D.[Index] = U.[Index]

				DECLARE @Counter INT = 0
				DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
				DECLARE @RecruitmentParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Recruitment management' AND StoreId = @StoreId AND InActiveDateTime IS NULL)
				DECLARE @TempRecruitment Table ( Id UNIQUEIDENTIFIER, FolderId UNIQUEIDENTIFIER, FileSize BIGINT, StoreId UNIQUEIDENTIFIER)
				DECLARE @Temp1 Table ( Id UNIQUEIDENTIFIER )
				DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
				WHILE (@Counter < (SELECT COUNT(*) FROM #UploadedDocument))
				BEGIN
					DECLARE @FileListXml XML = CAST((SELECT FileList FROM #UploadedDocument WHERE [Index] = @Counter) AS XML),
					@ReferenceId UNIQUEIDENTIFIER = (SELECT ReferenceId FROM #UploadedDocument WHERE [Index] = @Counter)

					--INSERT INTO @Temp1(Id, FolderId, FileSize, StoreId)
					--EXEC [dbo].[USP_UpsertCandidateFiles] @FilesXML = @FileListXml, @ReferenceId = @ReferenceId ,@OperationsPerformedBy = @OperationsPerformedBy, 
					--		@ReferenceTypeId = 'C2F6B138-E412-4905-9E78-A4AB4D3C804C' 
					--DELETE FROM @Temp1

					IF(@RecruitmentParentFolderId IS NULL)
					BEGIN
				    
					    INSERT INTO @Temp1(Id) EXEC [USP_UpsertFolder] @FolderName = 'Recruitment management',@ParentFolderId = NULL,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						SELECT TOP(1) @RecruitmentParentFolderId =  Id FROM @Temp1

					END

					DECLARE @RecruitmentFolderName NVARCHAR(50) = (SELECT REPLACE(CONVERT(NVARCHAR(15), Document, 106),' ',' - ') FROM CandidateDocuments WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)

					IF(@RecruitmentFolderName IS NULL)
					BEGIN
						INSERT INTO @TempRecruitment(Id, FolderId, FileSize, StoreId)
							EXEC [USP_UpsertFile] @FilesXML = @FileListXml,@FolderId = @RecruitmentParentFolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = 'C2F6B138-E412-4905-9E78-A4AB4D3C804C', @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed = 1
						DELETE FROM @TempRecruitment
					END
					ELSE
					BEGIN
						DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @RecruitmentFolderName 
											AND ((@RecruitmentParentFolderId IS NOT NULL AND ParentFolderId = @RecruitmentParentFolderId) OR (@RecruitmentParentFolderId IS NULL AND StoreId = @StoreId)) AND InActiveDateTime IS NULL)

						DECLARE @FolderId UNIQUEIDENTIFIER

						IF(@FolderCount = 0 )
							BEGIN

							
							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = @RecruitmentFolderName,@ParentFolderId = @RecruitmentParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
							
							SELECT TOP(1) @FolderId =  Id FROM @Temp

						END
							BEGIN
							
							SET @FolderId = (SELECT Top(1)Id FROM Folder WHERE FolderName = @RecruitmentFolderName 
							AND ((@RecruitmentParentFolderId IS NOT NULL AND ParentFolderId = @RecruitmentParentFolderId) OR (@RecruitmentParentFolderId IS NULL AND StoreId = @StoreId))
							AND InActiveDateTime IS NULL)

						END
						INSERT INTO @TempRecruitment(Id, FolderId, FileSize, StoreId)
							EXEC [USP_UpsertFile] @FilesXML = @FileListXml,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = 'C2F6B138-E412-4905-9E78-A4AB4D3C804C', @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed = 1
						DELETE FROM @TempRecruitment

					END

					SET @Counter  = @Counter  + 1
				END

			END

		 END

		 IF(@ResumeXml IS NOT NULL)
		 BEGIN

			SET @ReferenceId = NEWID()
			INSERT INTO [dbo].[CandidateDocuments]([Id],
													CandidateId,
													DocumentTypeId,
													Document,
													[Description],
													[IsResume],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
													[CreatedByUserId])
								            SELECT @ReferenceId,
								                    @CandidateId,
													NULL,
													'Resume',
													'Resume',
													1,
								                    NULL,
								                    GETDATE(),
													@OperationsPerformedBy
												
			
			IF(@UploadedResumeXml IS NOT NULL)
			BEGIN
				SET @FileListXml =  @UploadedResumeXml
				SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
				SET @RecruitmentParentFolderId = (SELECT Id From Folder WHERE FolderName = 'Recruitment management' AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					IF(@RecruitmentParentFolderId IS NULL)
					BEGIN
				    
					    INSERT INTO @Temp1(Id) EXEC [USP_UpsertFolder] @FolderName = 'Recruitment management',@ParentFolderId = NULL,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						SELECT TOP(1) @RecruitmentParentFolderId =  Id FROM @Temp1

					END

					SET @RecruitmentFolderName = (SELECT REPLACE(CONVERT(NVARCHAR(15), Document, 106),' ',' - ') FROM CandidateDocuments WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)

					IF(@RecruitmentFolderName IS NULL)
					BEGIN
						INSERT INTO @TempRecruitment(Id, FolderId, FileSize, StoreId)
							EXEC [USP_UpsertFile] @FilesXML = @FileListXml,@FolderId = @RecruitmentParentFolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = 'C2F6B138-E412-4905-9E78-A4AB4D3C804C', @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed = 1
						DELETE FROM @TempRecruitment
					END
					ELSE
					BEGIN
						SET @FolderCount = (SELECT COUNT(1) FROM Folder WHERE FolderName = @RecruitmentFolderName 
											AND ((@RecruitmentParentFolderId IS NOT NULL AND ParentFolderId = @RecruitmentParentFolderId) OR (@RecruitmentParentFolderId IS NULL AND StoreId = @StoreId)) AND InActiveDateTime IS NULL)

					

						IF(@FolderCount = 0 )
							BEGIN

							
							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = @RecruitmentFolderName,@ParentFolderId = @RecruitmentParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
							
							SELECT TOP(1) @FolderId =  Id FROM @Temp

						END
							BEGIN
							
							SET @FolderId = (SELECT Top(1)Id FROM Folder WHERE FolderName = @RecruitmentFolderName 
							AND ((@RecruitmentParentFolderId IS NOT NULL AND ParentFolderId = @RecruitmentParentFolderId) OR (@RecruitmentParentFolderId IS NULL AND StoreId = @StoreId))
							AND InActiveDateTime IS NULL)

						END
						INSERT INTO @TempRecruitment(Id, FolderId, FileSize, StoreId)
							EXEC [USP_UpsertFile] @FilesXML = @FileListXml,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = 'C2F6B138-E412-4905-9E78-A4AB4D3C804C', @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed = 1
						DELETE FROM @TempRecruitment

					END
					
			END

		 END
			
			
			DECLARE @DefaultUser UNIQUEIDENTIFIER
			SET @DefaultUser = (SELECT TOP(1) U.Id
											FROM UserRole UR 
											INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId
											WHERE R.IsHidden = 1 AND U.CompanyId = @CompanyId)

			SELECT @UniqueName+','+CAST(@CandidateId AS NVARCHAR(36))+','+CAST(@CompanyId AS NVARCHAR(36))+','+ CAST(@DefaultUser AS NVARCHAR(36)) FROM Candidate WHERE Id = @CandidateId

		END


	END TRY
	BEGIN CATCH
        
		THROW

	END CATCH
END
