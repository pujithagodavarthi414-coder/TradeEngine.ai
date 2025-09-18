CREATE PROCEDURE [dbo].[USP_UpsertJobOpening]
(
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @JobOpeningTitle NVARCHAR(500),
   @JobDescription NVARCHAR(MAX),
   @NoOfOpenings INT = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @MinExperience FLOAT = NULL,
   @MaxExperience FLOAT = NULL,
   @Qualification NVARCHAR(500) = NULL,
   @Certification NVARCHAR(500) = NULL,
   @MinSalary FLOAT = NULL,
   @MaxSalary FLOAT = NULL,
   @JobTypeId UNIQUEIDENTIFIER = NULL,
   @JobOpeningStatusId UNIQUEIDENTIFIER = NULL,
   @InterviewProcessId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @LocationIds NVARCHAR(MAX) = NULL,
   @SkillIds NVARCHAR(MAX) = NULL,
   @HiringManagerId UNIQUEIDENTIFIER = NULL,
   @DomainName NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@JobOpeningTitle IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'JobOpeningTitle')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @JobOpeningIdCount INT = (SELECT COUNT(1) FROM JobOpening  WHERE Id = @JobOpeningId)

			DECLARE @JobOpeningCount INT = 
			(SELECT COUNT(1) FROM JobOpening 
					WHERE JobOpeningTitle = @JobOpeningTitle 
					AND (((@DateFrom BETWEEN DateFrom AND DateTo) OR (@DateTo BETWEEN DateFrom AND DateTo)) 
					OR ((DateFrom BETWEEN @DateFrom AND @DateTo) OR (DateTo BETWEEN @DateFrom AND @DateTo)))
						AND (@JobOpeningId IS NULL OR (@JobOpeningId <> Id)) AND CompanyId = @CompanyId )
						--					--AND  ((@DesignationId IS NULL AND DesignationId IS NULL) OR (DesignationId = @DesignationId))
						--AND ((CAST(@DateFrom as date) >= CAST(DateFrom as date) AND CAST(@DateTo as date) <= CAST(DateTo as date)) 
						--OR (CAST(@DateTo as date) >= CAST(DateFrom as date) AND CAST(@DateTo as date) <= CAST(DateTo as date))))

			IF(@JobOpeningIdCount = 0 AND @JobOpeningId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'JobOpening')

			END
			IF (@JobOpeningCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'JobOpening')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @JobOpeningId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [JobOpening] WHERE Id = @JobOpeningId) = @TimeStamp THEN 1 ELSE 0 END END)
				   
				   IF(@JobDescription = '') SET @JobDescription = NULL
				   IF(@MinExperience = '') SET @MinExperience = NULL
				   IF(@MinSalary = '') SET @MinSalary = NULL
				   IF(@Qualification = '') SET @Qualification = NULL
				   IF(@Certification = '') SET @Certification = NULL

							DECLARE @UniqueName NVARCHAR(100)
							DECLARE @MaxNumber INT
							DECLARE @LocationIdsList TABLE
					        (
					               LocationId UNIQUEIDENTIFIER
					        )

							DECLARE @SkillIdsList TABLE
					        (
					               SkillId UNIQUEIDENTIFIER
					        )

				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@JobOpeningId IS NULL)
					  BEGIN
						DECLARE @GenericFormId UNIQUEIDENTIFIER = NULL,	@FormTypeId UNIQUEIDENTIFIER = NULL, @CustomApplicationName NVARCHAR(250) = NULL,@RoleIds VARCHAR(4000) = NULL,@IsPublished BIT = NULL,@ModuleIds NVARCHAR(MAX) = NULL,
								@CustomApplicationId UNIQUEIDENTIFIER = NULL
						
						SET @FormTypeId = (SELECT F.Id FROM [FormType] AS F WHERE F.FormTypeName LIKE '%Candidate registration form%' AND F.CompanyId = @CompanyId)

						SET @GenericFormId = (SELECT G.Id FROM [GenericForm] AS G JOIN
												[User] AS U ON U.Id = G.CreatedByUserId AND U.CompanyId = @CompanyId
												WHERE G.FormName LIKE '%Candidate registration form%')

						SET @CustomApplicationName = @JobOpeningTitle

						 SET @JobOpeningStatusId = @JobOpeningStatusId 
						 SET @IsPublished = 1
						 SET @ModuleIds = (SELECT Id FROM Module WHERE ModuleName = 'Recruitment management')
						 SET @RoleIds = (SELECT Id FROM [Role] WHERE RoleName LIKE '%Super Admin%' AND CompanyId = @CompanyId)
						 SET @CustomApplicationId = NEWID()
						 DECLARE @WigetModulesList TABLE
						 (
							ModuleId UNIQUEIDENTIFIER 
						 ) 
                
						 INSERT INTO @WigetModulesList(ModuleId)
						 SELECT Id FROM dbo.UfnSplit(@ModuleIds) WHERE Id <> '0'

						 SET @JobOpeningId = NEWID()
						 SET @UniqueName = 'JO'
						 SET @MaxNumber = (SELECT MAX(CAST(SUBSTRING(JobOpeningUniqueName,LEN(@Uniquename) + 2,LEN(JobOpeningUniqueName)) AS INT)) 
                            FROM [JobOpening] WHERE JobOpeningUniqueName IS NOT NULL AND CompanyId = @CompanyId )
						SET @UniqueName = @UniqueName + '-' +  CAST(ISNULL(@MaxNumber,0) + 1 AS NVARCHAR(250))

						 INSERT INTO [dbo].[JobOpening]([Id],
														JobOpeningTitle,
														JobOpeningUniqueName,
														JobDescription,
														NoOfOpenings,
														DateFrom,
														DateTo,
														MinExperience,
														MaxExperience,
														Qualification,
														Certification,
														MinSalary,
														MaxSalary,
														JobTypeId,
														JobOpeningStatusId,
														InterviewProcessId,
														DesignationId,
														HiringManagerId,
														CompanyId,
								                        [InActiveDateTime],
								                        [CreatedDateTime],
								                        [CreatedByUserId])
								                 SELECT @JobOpeningId,
								                        @JobOpeningTitle,
														@UniqueName,
														@JobDescription,
														@NoOfOpenings,
														@DateFrom,
														@DateTo,
														@MinExperience,
														@MaxExperience,
														@Qualification,
														@Certification,
														@MinSalary,
														@MaxSalary,
														@JobTypeId,
														@JobOpeningStatusId,
														@InterviewProcessId,
														@DesignationId,
														@HiringManagerId,
														@CompanyId,
								                        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                        @Currentdate,
								                        @OperationsPerformedBy	


					INSERT INTO @LocationIdsList(LocationId)
					SELECT Id FROM dbo.UfnSplit(@LocationIds)
							
							INSERT INTO JobLocation([Id],
													[BranchId],
													[JobOpeningId],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   LocationId,
												   @JobOpeningId,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @LocationIdsList LL

					INSERT INTO @SkillIdsList(SkillId)
					SELECT Id FROM dbo.UfnSplit(@SkillIds)
							
							INSERT INTO [JobOpeningSkill]([Id],
													[JobOpeningId],
													[SkillId],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   @JobOpeningId,
												   SkillId,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @SkillIdsList SL
					
						INSERT INTO [dbo].[CustomApplication](
					            [Id],
								[CustomApplicationName],
								[PublicMessage],
								[Description],
					            [CreatedDateTime],
					            [CreatedByUserId],
								[InActiveDateTime],
								[IsPublished]
								)
					     SELECT @CustomApplicationId,
						        @CustomApplicationName,
								NULL,
								NULL,
					            @Currentdate,
								@OperationsPerformedBy,
								NULL,
								@IsPublished
						
						DECLARE @SelectedKeyIds NVARCHAR(100) = NULL, @SelectedPrivateKeyIds NVARCHAR(100) = NULL, @SelectedEnableTrendsKeyIds NVARCHAR(100) = NULL, @SelectedTagKeyIds NVARCHAR(100) = NULL
						DECLARE @Temp TABLE ( 
	                        Id UNIQUEIDENTIFIER,
							GenericFormId UNIQUEIDENTIFIER,
	                        CustomApplicationId UNIQUEIDENTIFIER
						)

						INSERT INTO @Temp(Id,GenericFormId,CustomApplicationId)
						SELECT NEWID(),CAST([Value] AS UNIQUEIDENTIFIER),@CustomApplicationId FROM [dbo].[Ufn_StringSplit](@GenericFormId,',')

						INSERT INTO CustomApplicationForms([Id], 
													[CustomApplicationId] , 
													[GenericFormId],
													[PublicUrl],
													[CreatedDateTime],
													[CreatedByUserId],
													[InActiveDateTime]
													)
						SELECT T.Id,
								@CustomApplicationId,
								@GenericFormId,
								@DomainName +'/application/application-form/' + @CustomApplicationName + '/' + GF.FormName + '/' + CAST(@JobOpeningId AS NVARCHAR(36)),
								@Currentdate,
								@OperationsPerformedBy,
								NULL
								FROM @Temp T INNER JOIN GenericForm GF ON T.GenericFormId = GF.Id AND GF.InActiveDateTime IS NULL
								--FROM GenericForm GF WHERE GF.Id = @GenericFormId AND GF.InActiveDateTime IS NULL

						INSERT INTO CustomApplicationKey(
				            Id,
							GenericFormKeyId
							,GenericFormId
							,CustomApplicationId
							,IsDefault
							,IsPrivate
							,IsTag
							,IsTrendsEnable
							,CreatedByUserId
							,CreatedDateTime)
						SELECT NEWID()
							   ,GFK.Id
							   ,@GenericFormId
							   ,@CustomApplicationId
							   ,CASE WHEN T.Id IS NOT NULL THEN 1 ELSE 0 END
							   ,CASE WHEN Z.Id IS NOT NULL THEN 1 ELSE 0 END
							   ,CASE WHEN TK.Id IS NOT NULL THEN 1 ELSE 0 END
							   ,CASE WHEN STK.Id IS NOT NULL THEN 1 ELSE 0 END
							   ,@OperationsPerformedBy
							   ,@Currentdate
						FROM GenericFormKey GFK 
						JOIN @Temp Te ON Te.GenericFormId = GFK.GenericFormId
						LEFT JOIN (SELECT Value AS Id FROM STRING_SPLIT(@SelectedKeyIds,',')) T ON T.Id = GFK.[Id] 
						LEFT JOIN (SELECT Value AS Id FROM STRING_SPLIT(@SelectedPrivateKeyIds,',')) Z ON Z.Id = GFK.[Id] 
						LEFT JOIN (SELECT Value AS Id FROM STRING_SPLIT(@SelectedTagKeyIds,',')) TK ON TK.Id = GFK.[Id] 
						LEFT JOIN (SELECT Value AS Id FROM STRING_SPLIT(@SelectedEnableTrendsKeyIds,',')) STK ON STK.Id = GFK.[Id] 
						WHERE GFK.GenericFormId IN (SELECT GenericFormId FROM @Temp)


						INSERT INTO [dbo].[WidgetModuleConfiguration](
                            [Id],
                            [WidgetId],
                            [ModuleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
						 SELECT NEWID(),
								@CustomApplicationId, 
								ModuleId,
								@Currentdate,
								@OperationsPerformedBy
						   FROM @WigetModulesList

						INSERT INTO CustomApplicationRoleConfiguration(
				            Id
							,RoleId
							,CustomApplicationId
							,CreatedByUserId
							,CreatedDateTime)
						SELECT NEWID()
							   ,Id
							   ,@CustomApplicationId
							   ,@OperationsPerformedBy
							   ,@Currentdate
						FROM dbo.UfnSplit(@RoleIds) 

					END
					ELSE
					BEGIN

						UPDATE [JobOpening] SET JobOpeningTitle = @JobOpeningTitle,
												JobDescription = @JobDescription,
												NoOfOpenings = @NoOfOpenings,
												DateFrom = @DateFrom,
												DateTo = @DateTo,
												MinExperience = @MinExperience,
												MaxExperience = @MaxExperience,
												Qualification = @Qualification,
												Certification = @Certification,
												MinSalary = @MinSalary,
												MaxSalary = @MaxSalary,
												JobTypeId = @JobTypeId,
												JobOpeningStatusId = @JobOpeningStatusId,
												InterviewProcessId = @InterviewProcessId,
												DesignationId = @DesignationId,
												HiringManagerId = @HiringManagerId,
												CompanyId = @CompanyId,
									            InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									            UpdatedDateTime = @Currentdate,
									            UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @JobOpeningId

					INSERT INTO @LocationIdsList(LocationId)
					SELECT Id FROM dbo.UfnSplit(@LocationIds)

					INSERT INTO @SkillIdsList(SkillId)
					SELECT Id FROM dbo.UfnSplit(@SkillIds)

					UPDATE [JobOpeningSkill] SET InactiveDateTime = @Currentdate
                                           ,UpdatedByUserId = @OperationsPerformedBy
                                           ,UpdatedDateTime = @Currentdate
                                       WHERE [JobOpeningId] = @JobOpeningId 
									   AND SkillId NOT IN (SELECT SkillId FROM @SkillIdsList)

					INSERT INTO [JobOpeningSkill]([Id],
													[SkillId],
													[JobOpeningId],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   SkillId,
												   @JobOpeningId,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @SkillIdsList SL WHERE SL.SkillId NOT IN 
											(SELECT SkillId FROM [JobOpeningSkill] WHERE JobOpeningId=@JobOpeningId AND InActiveDateTime IS NULL)

					
					UPDATE JobLocation SET InactiveDateTime = @Currentdate
                                           ,UpdatedByUserId = @OperationsPerformedBy
                                           ,UpdatedDateTime = @Currentdate
                                       WHERE [JobOpeningId] = @JobOpeningId 
									   AND BranchId NOT IN (SELECT LocationId FROM @LocationIdsList)


					INSERT INTO JobLocation([Id],
													[BranchId],
													[JobOpeningId],
								                    [InActiveDateTime],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   LocationId,
												   @JobOpeningId,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @LocationIdsList LL WHERE LL.LocationId NOT IN 
											(SELECT BranchId FROM JobLocation WHERE JobOpeningId=@JobOpeningId AND InActiveDateTime IS NULL)

					END

					    EXEC USP_InsertCandidateHistory @CandidateId = NULL, @OldValue = NULL, @NewValue = NULL, @FieldName = NULL,
                       @Description = 'JobOpeningChanged', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = @JobOpeningId

				    SELECT Id FROM [dbo].[JobOpening] WHERE Id = @JobOpeningId
				                   
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
