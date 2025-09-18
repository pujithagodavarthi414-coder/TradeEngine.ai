---------------------------------------------------------------------------------
---- Author       Geetha CH
---- Created      '2020-09-21 00:00:00.000'
---- Purpose      To save or update entities
---- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEntity] @EntityName = 'Snovasys Groups',@IsGroup = 1,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_UpsertEntity]
(
	 @EntityId UNIQUEIDENTIFIER = NULL
	,@EntityName NVARCHAR(250)
	,@IsEntity BIT = NULL
	,@IsGroup BIT = NULL
	,@IsBranch BIT = NULL
	,@IsCountry BIT = NULL
	,@IsHeadOffice BIT = NULL
	,@TimeStamp TIMESTAMP = NULL
	,@ParentEntityId UNIQUEIDENTIFIER = NULL
	,@ChildEntityId  UNIQUEIDENTIFIER = NULL
	,@CurrencyId UNIQUEIDENTIFIER = NULL
	,@CountryId UNIQUEIDENTIFIER = NULL
	,@TimeZoneId UNIQUEIDENTIFIER = NULL
	,@IsArchive BIT = NULL
	,@DefaultPayrollTemplateId UNIQUEIDENTIFIER = NULL
	,@Address NVARCHAR(1000) = NULL
	,@Description NVARCHAR(1000) = NULL
	,@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS BEGIN
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@ChildEntityId = '00000000-0000-0000-0000-000000000000') SET @ChildEntityId = NULL
		
		IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@ParentEntityId = '00000000-0000-0000-0000-000000000000') SET @ParentEntityId = NULL

		IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL

		IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL

		IF(@DefaultPayrollTemplateId = '00000000-0000-0000-0000-000000000000') SET @DefaultPayrollTemplateId = NULL

		IF(@EntityName = '') SET @EntityName = NULL

		IF(@Description = '') SET @Description = NULL

		IF(@Address = '') SET @Address = NULL

		IF(@IsEntity IS NULL) SET @IsEntity = 0

		IF(@IsGroup IS NULL) SET @IsGroup = 0

		IF(@IsBranch IS NULL) SET @IsBranch = 0

		IF(@IsCountry IS NULL) SET @IsCountry = 0

		IF(@IsHeadOffice IS NULL) SET @IsHeadOffice = 0

		IF(@IsArchive IS NULL) SET @IsArchive = 0

		IF(@ParentEntityId IS NOT NULL AND @EntityId = @ParentEntityId)
		BEGIN

			RAISERROR('CreatesACircularDependencyPleaseContactTheAdministrator',11,1)

		END
		ELSE IF(@EntityName IS NULL)
		BEGIN
			
			RAISERROR(50011,11,1,'EntityName')

		END
		ELSE IF(@CountryId IS NULL AND @IsBranch = 1)
		BEGIN

		  RAISERROR(50011,16, 2,'Country')

		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @EntityIdCount INT = (SELECT COUNT(1) FROM [Entity] WHERE Id = @EntityId) 
				
				DECLARE @EntityNameCount INT = (SELECT COUNT(1) FROM [Entity] 
				                                WHERE EntityName = @EntityName AND (@EntityId IS NULL OR Id <> @EntityId)
												      AND InactiveDateTime IS NULL
													  AND CompanyId = @CompanyId)
				
				IF(@ChildEntityId IS NOT NULL AND @ParentEntityId IS NULL)
				BEGIN
					
					SET @ParentEntityId = (SELECT ParentEntityId FROM Entity WHERE Id = @ChildEntityId AND @ParentEntityId <> @ChildEntityId)

				END

				--DECLARE @ParentBranch BIT = CASE WHEN ISNULL((SELECT COUNT(1) FROM Entity WHERE Id = @ParentEntityId AND IsBranch = 1 AND InactiveDateTime IS NULL),0) > 0 
				--								 THEN 1 ELSE 0 END
				
				--DECLARE @HeadOfficeCount NVARCHAR(250) = (SELECT COUNT(1) FROM [Branch] 
				--                                          WHERE CompanyId = @CompanyId 
				--										        AND IsHeadOffice = 1 AND InActiveDateTime IS NULL
				--												AND (@EntityId IS NULL OR Id <> @EntityId))

				--IF(@EntityId IS NOT NULL AND @IsArchive = 0)
				--BEGIN
				--    --TODO total count 0 then allow any change
				--	DECLARE @GroupsCount INT = 0,@EntitiesCount INT = 0,@CountriesCount INT = 0,@BranchesCount INT = 0
				--	        ,@TotalCount INT = 0

				--	SELECT @GroupsCount = GroupsCount
				--	       ,@EntitiesCount = EntitiesCount
				--	       ,@CountriesCount = CountriesCount
				--	       ,@BranchesCount = BranchesCount
				--	       ,@TotalCount = TotalCount
				--	FROM [dbo].[Ufn_GetAllChildEntities](@EntityId)

				--	DECLARE @OldIsBranch BIT = 0,@OldIsEntity BIT = 0,@OldIsCountry BIT = 0,@OldIsGroup BIT = 0
					
				--	SELECT @OldIsBranch = [IsBranch],@OldIsEntity = [IsEntity]
				--	       ,@OldIsCountry = [IsCountry],@OldIsGroup = [IsGroup]
				--	FROM Entity WHERE Id = @EntityId

				--	DECLARE @ChangeValidation BIT = 0

				--	IF(@TotalCount = 0)
				--	BEGIN
					
				--		SET @ChangeValidation = 0

				--	END
				--	ELSE IF(@OldIsGroup <> @IsGroup)
				--	BEGIN
						
				--		IF(@IsEntity = 1 AND @EntitiesCount > 0)
				--			SET @ChangeValidation = 1
				--		ELSE IF(@IsCountry = 1 AND @CountriesCount > 0)
				--			SET @ChangeValidation = 1
				--		ELSE IF(@IsBranch = 1 AND @BranchesCount > 0)
				--			SET @ChangeValidation = 1
							
				--	END
				--	ELSE IF(@OldIsEntity <> @IsEntity)
				--	BEGIN
						
				--		IF(@IsCountry = 1 AND @CountriesCount > 0)
				--			SET @ChangeValidation = 1
				--		ELSE IF(@IsBranch = 1 AND @BranchesCount > 0)
				--			SET @ChangeValidation = 1

				--	END
				--	ELSE IF(@OldIsCountry <> @IsCountry)
				--	BEGIN
						
				--		IF(@IsBranch = 1 AND @BranchesCount > 0)
				--			SET @ChangeValidation = 1

				--	END
				--END

				--IF(@ChangeValidation = 1 AND @EntityId IS NOT NULL)
				--BEGIN
					
				--	RAISERROR('DeleteChildsAndTryAgain',11,1)

				--END
				--ELSE 
				
				IF(@EntityIdCount = 0 AND @EntityId IS NOT NULL)
				BEGIN

					RAISERROR(50002,16, 2,'Entity')
				     
				END
				ELSE IF(@EntityNameCount > 0)
				BEGIN
				
				     RAISERROR(50001,16,1,'Entity')
				 	
				END		
				ELSE IF(@ParentEntityId IS NULL OR ((SELECT IsBranch FROM Entity WHERE Id = @ParentEntityId AND InactiveDateTime IS NULL) = 0)) --TODO
				BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @EntityId IS NULL THEN 1
												  WHEN (SELECT [TimeStamp]
					                               FROM [Entity] WHERE Id = @EntityId) = @TimeStamp
					                         THEN 1 ELSE 0 END)
		
					IF(@IsLatest = 1)
					BEGIN
						 
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@EntityId IS NULL)
						BEGIN
							
							SET @EntityId = NEWID()

							INSERT INTO [Entity]
							            (
							             [Id],
					                     [CompanyId],
					                     [EntityName],
							             [InActiveDateTime],
							             [IsGroup],
							             [IsEntity],
							             [IsCountry],
							             [IsBranch],
							             [ParentEntityId],
										 [Description],
					                     [CreatedDateTime],
					                     [CreatedByUserId]
							            )
					             SELECT @EntityId
								        ,@CompanyId
										,@EntityName
										,CASE WHEN @IsArchive = 1 THEN @CurrentDate ELSE NULL END
										,@IsGroup
										,@IsEntity
										,@IsCountry
										,@IsBranch
										,@ParentEntityId
										,@Description
										,@CurrentDate
										,@OperationsPerformedBy
							      
							IF(@IsBranch = 1 AND @IsArchive = 0)
							BEGIN
								
								INSERT INTO [Branch](Id,CompanyId,BranchName,[IsHeadOffice],[TimeZoneId],[Address],[PayrollTemplateId],[CurrencyId],[CountryId],CreatedDateTime,CreatedByUserId)
								SELECT @EntityId,@CompanyId,@EntityName,@IsHeadOffice,@TimeZoneId,@Address,@DefaultPayrollTemplateId,@CurrencyId,@CountryId,@CurrentDate,@OperationsPerformedBy

								INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
							    VALUES(NEWID(),0.0000,15000.0000,0.0000,@Currentdate,0,@EntityId)

								INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
								VALUES(NEWID(),15001.0000,20000.0000,150.0000,@Currentdate,0,@EntityId)

								INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
								VALUES(NEWID(),20001.0000,NULL,200.0000,@Currentdate,0,@EntityId)

								DECLARE @ShiftTimingId UNIQUEIDENTIFIER = NEWID();
								INSERT INTO ShiftTiming(Id,CompanyId,ShiftName,BranchId,CreatedDateTime,CreatedByUserId)
								VALUES(@ShiftTimingId,@CompanyId,'Morning Shift',@EntityId,@CurrentDate,@OperationsPerformedBy)

								--SELECT @ShiftTimingId = Id FROM ShiftTiming WHERE ShiftName = 'Morning Shift' AND BranchId = @EntityId AND CompanyId = @CompanyId

								INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
								VALUES(NEWId(),@ShiftTimingId,'Monday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

								INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
								VALUES(NEWId(),@ShiftTimingId,'Tuesday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

								INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
								VALUES(NEWId(),@ShiftTimingId,'Wednesday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

								INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
								VALUES(NEWId(),@ShiftTimingId,'Thursday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

								INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
								VALUES(NEWId(),@ShiftTimingId,'Friday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

								SELECT T.*
								INTO #BranchEntities
								FROM [dbo].[Ufn_GetAllParentEntities](@EntityId) T

								INSERT INTO EntityBranch([Id],BranchId,EntityId,CreatedDateTime,CreatedByUserId)
								SELECT NEWID(),@EntityId,T.EntityId,@CurrentDate,@OperationsPerformedBy
								FROM #BranchEntities T
								UNION
								SELECT NEWID(),@EntityId,@EntityId,@CurrentDate,@OperationsPerformedBy

								INSERT INTO EmployeeEntityBranch(Id,EmployeeId,BranchId,CreatedByUserId,CreatedDateTime)
								SELECT NEWID(),T.EmployeeId,@EntityId,@OperationsPerformedBy,@Currentdate
								FROM ( 
										SELECT EE.EmployeeId
										FROM EmployeeEntity EE
										WHERE EE.EntityId IN (SELECT EntityId FROM #BranchEntities)
											  AND EE.InactiveDateTime IS NULL
										GROUP BY EE.EmployeeId
									  ) T

								IF(@DefaultPayrollTemplateId IS NOT NULL)
								BEGIN
										
										IF(EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId AND InactiveDateTime IS NOT NULL))
										BEGIN

											UPDATE [dbo].[PayRollBranchConfiguration] 
											       SET InactiveDateTime = NULL
												       ,[UpdatedByUserId] = @OperationsPerformedBy
													   ,[UpdatedDateTime] = @CurrentDate
												WHERE BranchId = @EntityId 
												      AND InactiveDateTime IS NOT NULL
													  AND PayrollTemplateId = @DefaultPayrollTemplateId
											 
										END
										ELSE IF(NOT EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId))
										BEGIN
											
											INSERT INTO [dbo].[PayRollBranchConfiguration](
																[Id],
																[PayRollTemplateId],
																[BranchId],
																[CreatedDateTime],
																[CreatedByUserId],
																[CompanyId],
																[InActiveDateTime]
																)
														 SELECT NEWID(),
																@DefaultPayrollTemplateId,
																@EntityId,
																@Currentdate,
																@OperationsPerformedBy,
																@CompanyId,
																NULL

										END

								END

							END

							IF(@IsHeadOffice = 1)
							BEGIN
								
								UPDATE Branch SET IsHeadOffice = 0 WHERE InActiveDateTime IS NULL AND Id <> @EntityId

							END

						END
						ELSE
						BEGIN

							DECLARE @OldIsBranch BIT = 0
							DECLARE @IsvalidBranchDelete BIT = 0
							DECLARE @IsValid NVARCHAR(250)

							SELECT @OldIsBranch = [IsBranch]
							FROM Entity WHERE Id = @EntityId

							IF(@IsArchive = 1 OR (@IsBranch = 0 AND @OldIsBranch = 1))
							BEGIN
								
								IF(@IsBranch = 1 OR (@IsBranch = 0 AND @OldIsBranch = 1))
								BEGIN
									
									SET @IsValid = (SELECT [dbo].[Ufn_BranchDeleteValidation](@EntityId))

									IF(@IsValid = '1')
									BEGIN
										
										UPDATE [Branch] SET InActiveDateTime = @CurrentDate
										                    ,UpdatedByUserId = @OperationsPerformedBy
															,UpdatedDateTime = @CurrentDate
													WHERE Id = @EntityId
									
									END
									ELSE
										SET @IsvalidBranchDelete = 1
									
								END
								ELSE
								BEGIN

									CREATE TABLE #BranchesList
									(
										BranchId UNIQUEIDENTIFIER
										,IsValid NVARCHAR(250)
									)

									INSERT INTO #BranchesList(BranchId)
									SELECT EntityId
									FROM [dbo].[Ufn_GetAllChildEntities](@EntityId,0)
									WHERE [IsBranch] = 1

									UPDATE #BranchesList SET IsValid = [dbo].[Ufn_BranchDeleteValidation](BranchId)

									DECLARE @InValidcount INT = (SELECT COUNT(1) FROM #BranchesList WHERE IsValid <> '1')

									IF(@InValidcount > 0)
									BEGIN
										
										SET @IsValid = (SELECT TOP (1) Isvalid FROM #BranchesList WHERE IsValid <> '1')
										
										SET @IsvalidBranchDelete = 1

									END

								END

							END
							
							IF(@IsvalidBranchDelete = 1)
							BEGIN
								
								RAISERROR(@IsValid,11,1)

							END
							ELSE
							BEGIN

								UPDATE [Entity] SET [Id] = @EntityId
								                    ,[CompanyId] = @CompanyId
													,[EntityName] = @EntityName
													,[InactiveDateTime] = CASE WHEN @IsArchive = 1 THEN @CurrentDate ELSE NULL END
													,[IsGroup] = @IsGroup
													,[IsEntity] = @IsEntity
													,[IsCountry] = @IsCountry
													,[IsBranch] = @IsBranch
													,[Description] = @Description
													,[ParentEntityId] = @ParentEntityId
													,[UpdatedByUserId] = @OperationsPerformedBy
													,[UpdatedDateTime] = @CurrentDate
										WHERE Id = @EntityId

								IF(@IsBranch = 1 AND @OldIsBranch = 1 AND @IsArchive = 0)
								BEGIN

									UPDATE [Branch] SET BranchName = @EntityName
									                    ,UpdatedByUserId = @OperationsPerformedBy
														,UpdatedDateTime = @CurrentDate
														,[IsHeadOffice] = @IsHeadOffice
														,[TimeZoneId] = @TimeZoneId
														,[Address] = @Address
														,[CurrencyId] = @CurrencyId
														,[CountryId] = @CountryId
														,[PayrollTemplateId] = @DefaultPayrollTemplateId
													WHERE Id = @EntityId

									IF(@DefaultPayrollTemplateId IS NOT NULL)
									BEGIN
										
										IF(EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId AND InactiveDateTime IS NOT NULL))
										BEGIN

											UPDATE [dbo].[PayRollBranchConfiguration] 
											       SET InactiveDateTime = NULL
												       ,[UpdatedByUserId] = @OperationsPerformedBy
													   ,[UpdatedDateTime] = @CurrentDate
												WHERE BranchId = @EntityId 
												      AND InactiveDateTime IS NOT NULL
													  AND PayrollTemplateId = @DefaultPayrollTemplateId
											 
										END
										ELSE IF(NOT EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId))
										BEGIN
											
											INSERT INTO [dbo].[PayRollBranchConfiguration](
																[Id],
																[PayRollTemplateId],
																[BranchId],
																[CreatedDateTime],
																[CreatedByUserId],
																[CompanyId],
																[InActiveDateTime]
																)
														 SELECT NEWID(),
																@DefaultPayrollTemplateId,
																@EntityId,
																@Currentdate,
																@OperationsPerformedBy,
																@CompanyId,
																NULL

										END

									END

								END

								IF(@IsBranch = 1 AND @OldIsBranch = 0)
								BEGIN
								
									INSERT INTO [Branch](Id,CompanyId,BranchName,[IsHeadOffice],[TimeZoneId],[Address],[PayrollTemplateId],[CurrencyId],[CountryId],CreatedDateTime,CreatedByUserId)
									SELECT @EntityId,@CompanyId,@EntityName,@IsHeadOffice,@TimeZoneId,@Address,@DefaultPayrollTemplateId,@CurrencyId,@CountryId,@CurrentDate,@OperationsPerformedBy

									SELECT T.*
									INTO #NewBranchEntities
									FROM [dbo].[Ufn_GetAllParentEntities](@EntityId) T

									INSERT INTO EntityBranch([Id],BranchId,EntityId,CreatedDateTime,CreatedByUserId)
									SELECT NEWID(),@EntityId,T.EntityId,@CurrentDate,@OperationsPerformedBy
									FROM #NewBranchEntities T
									UNION
									SELECT NEWID(),@EntityId,@EntityId,@CurrentDate,@OperationsPerformedBy

									INSERT INTO EmployeeEntityBranch(Id,EmployeeId,BranchId,CreatedByUserId,CreatedDateTime)
									SELECT NEWID(),T.EmployeeId,@EntityId,@OperationsPerformedBy,@Currentdate
									FROM ( 
											SELECT EE.EmployeeId
											FROM EmployeeEntity EE
											WHERE EE.EntityId IN (SELECT EntityId FROM #NewBranchEntities)
												  AND EE.InactiveDateTime IS NULL
											GROUP BY EE.EmployeeId
										  ) T

 									IF(@DefaultPayrollTemplateId IS NOT NULL)
									BEGIN
										
										IF(EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId AND InactiveDateTime IS NOT NULL))
										BEGIN

											UPDATE [dbo].[PayRollBranchConfiguration] 
											       SET InactiveDateTime = NULL
												       ,[UpdatedByUserId] = @OperationsPerformedBy
													   ,[UpdatedDateTime] = @CurrentDate
												WHERE BranchId = @EntityId 
												      AND InactiveDateTime IS NOT NULL
													  AND PayrollTemplateId = @DefaultPayrollTemplateId
											 
										END
										ELSE IF(NOT EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE BranchId = @EntityId AND PayrollTemplateId = @DefaultPayrollTemplateId))
										BEGIN
											
											INSERT INTO [dbo].[PayRollBranchConfiguration](
																[Id],
																[PayRollTemplateId],
																[BranchId],
																[CreatedDateTime],
																[CreatedByUserId],
																[CompanyId],
																[InActiveDateTime]
																)
														 SELECT NEWID(),
																@DefaultPayrollTemplateId,
																@EntityId,
																@Currentdate,
																@OperationsPerformedBy,
																@CompanyId,
																NULL

										END

									END

								END
								
								--all strucutre delete
								IF(@IsArchive = 1)
								BEGIN

									CREATE TABLE #ChildEntitiesList
									(
										EntityId UNIQUEIDENTIFIER
										,IsBranch NVARCHAR(250)
									)

									INSERT INTO #ChildEntitiesList(EntityId,IsBranch)
									SELECT EntityId,[IsBranch] 	
									FROM [dbo].[Ufn_GetAllChildEntities](@EntityId,1)

									UPDATE [Entity] SET InactiveDateTime = @CurrentDate
									                    ,UpdatedByUserId = @OperationsPerformedBy
														,UpdatedDateTime = @CurrentDate
												WHERE Id IN (SELECT EntityId FROM #ChildEntitiesList)

									UPDATE EntityBranch SET InactiveDateTime = @CurrentDate
									                    ,UpdatedByUserId = @OperationsPerformedBy
														,UpdatedDateTime = @CurrentDate
												WHERE EntityId IN (SELECT EntityId FROM #ChildEntitiesList) 

									UPDATE Branch SET InactiveDateTime = @CurrentDate
									                    ,UpdatedByUserId = @OperationsPerformedBy
														,UpdatedDateTime = @CurrentDate
												WHERE Id IN (SELECT EntityId FROM #ChildEntitiesList WHERE IsBranch = 1)  

								END
							
								IF(@IsHeadOffice = 1)
								BEGIN
									
									UPDATE Branch SET IsHeadOffice = 0 WHERE InActiveDateTime IS NULL AND Id <> @EntityId

								END

							END


						END
								
						IF(@ChildEntityId IS NOT NULL)
						BEGIN
							
							UPDATE Entity SET ParentEntityId = @EntityId 
							                  ,UpdatedByUserId = @OperationsPerformedBy
											  ,UpdatedDateTime = @CurrentDate
							WHERE Id = @ChildEntityId AND Id <> @EntityId

						END

						SELECT Id FROM Entity WHERE Id = @EntityId

					END
					ELSE
						RAISERROR (50008,11, 1)

				END

			END
			ELSE
			BEGIN
				
				RAISERROR(@HavePermission,11,1)

			END

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO