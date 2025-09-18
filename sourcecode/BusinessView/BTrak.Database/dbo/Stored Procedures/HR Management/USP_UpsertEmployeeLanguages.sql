-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-17 00:00:00.000'
-- Purpose      To Save or update the Employee Language Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertEmployeeLanguages] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393', @CompetencyId = '7A5986ED-A3AC-488B-9AB9-CAF026CADD99', @LanguageId = '316bdbac-ff42-45b9-8897-ff4750e562ff',@FluencyId = 'ad60cdf2-6515-4d18-a563-094aac22340a',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeLanguages]
(
   @EmployeeLanguageDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @LanguageId UNIQUEIDENTIFIER = NULL,
   --@FluencyId UNIQUEIDENTIFIER = NULL,
   @CanRead BIT = NULL,
   @CanWrite BIT = NULL,
   @CanSpeak BIT = NULL,
   @CompetencyId UNIQUEIDENTIFIER = NULL,
   @Comments NVARCHAR(800) = NULL, 
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@LanguageId = '00000000-0000-0000-0000-000000000000') SET @LanguageId = NULL

		--IF(@FluencyId = '00000000-0000-0000-0000-000000000000') SET @FluencyId = NULL

		IF(@CanRead IS NULL) SET @CanRead = 0

		IF(@CanWrite IS NULL) SET @CanWrite = 0

		IF(@CanSpeak IS NULL) SET @CanSpeak = 0
		
		IF(@CompetencyId = '00000000-0000-0000-0000-000000000000') SET @CompetencyId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@LanguageId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Language')

		END
		ELSE IF(@CanRead = 0 AND @CanWrite = 0 AND @CanSpeak = 0)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Fluency')

		END
		ELSE IF(@CompetencyId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Competency')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeLanguageDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeLanguage WHERE Id = @EmployeeLanguageDetailId )

		DECLARE @EmployeeLanguageDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeLanguage WHERE EmployeeId = @EmployeeId AND LanguageId = @LanguageId AND (Id <> @EmployeeLanguageDetailId OR @EmployeeLanguageDetailId IS NULL)  AND InActiveDateTime IS NULL)

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeLanguagesDetails',11,1)
		END

		ELSE IF(@EmployeeLanguageDetailIdCount = 0 AND @EmployeeLanguageDetailId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeLanguageDetails')
		END

		ELSE IF(@EmployeeLanguageDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeLanguageDetailId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeLanguage WHERE Id = @EmployeeLanguageDetailId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldLanguageId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldCompetencyId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldCanSpeek BIT = NULL
                    DECLARE @OldCanWrite BIT = NULL
                    DECLARE @OldCanRead BIT = NULL
                    DECLARE @OldComments NVARCHAR(800) = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					SELECT @OldLanguageId  = [LanguageId],
					       @OldCanSpeek   = CanSpeak,
						   @OldCanWrite = CanWrite,
						   @OldCanRead = CanRead,
					       @OldCompetencyId= [CompetencyId],
					       @OldComments    = [Comments],
					       @Inactive	   = [InActiveDateTime]
						   FROM EmployeeLanguage WHERE Id = @EmployeeLanguageDetailId

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        IF(@EmployeeLanguageDetailId IS NULL)
					BEGIN

					SET @EmployeeLanguageDetailId = NEWID()

			        INSERT INTO [dbo].EmployeeLanguage(
			                    [Id],
			                    [EmployeeId],
								[LanguageId],
								[CompetencyId],
								[Comments],
								[CanRead],
								[CanSpeak],
								[CanWrite],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeLanguageDetailId,
			                    @EmployeeId,
								@LanguageId,
								@CompetencyId,
								@Comments,
								@CanRead
								,@CanSpeak
								,@CanWrite,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
			                   
						END
						ELSE
						BEGIN

						UPDATE [dbo].EmployeeLanguage
			                 SET [EmployeeId] = @EmployeeId,
								 [LanguageId] = @LanguageId,
								 [CompetencyId] = @CompetencyId,
								 [Comments] = @Comments,
								 [CanRead] = @CanRead,
								 [CanSpeak] = @CanSpeak,
								 [CanWrite] = @CanWrite,
			                     [InActiveDateTime] =CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								 [UpdatedDateTime] = @Currentdate,
								 [UpdatedByUserId] = @OperationsPerformedBy
							WHERE Id = @EmployeeLanguageDetailId

						END
			       
					    DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT LanguageName  FROM [Language] WHERE Id = @LanguageId)

						SET @OldValue = (SELECT LanguageName  FROM [Language] WHERE Id = @OldLanguageId)
					    SET @NewValue = (SELECT LanguageName  FROM [Language] WHERE Id = @LanguageId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Language details',
					    @FieldName = 'Language',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue = ''
						IF(@OldCanSpeek = 1) SET @OldValue = @OldValue + 'CanSpeak'
						IF(@OldCanWrite = 1 AND @OldValue = '') SET @OldValue = @OldValue + 'CanWrite'
						IF(@OldCanWrite = 1 AND @OldValue <> '') SET @OldValue = @OldValue + ',CanWrite'
						IF(@OldCanRead = 1 AND @OldValue = '') SET @OldValue = @OldValue + 'CanRead'
						IF(@OldCanRead = 1 AND @OldValue <> '') SET @OldValue = @OldValue + ',CanRead'

						SET @NewValue = ''
						IF(@CanSpeak = 1) SET @OldValue = @OldValue + 'CanSpeak'
						IF(@CanWrite = 1 AND @NewValue = '') SET @OldValue = @OldValue + 'CanWrite'
						IF(@CanWrite = 1 AND @NewValue <> '') SET @OldValue = @OldValue + ',CanWrite'
						IF(@CanRead = 1 AND @NewValue = '') SET @OldValue = @OldValue + 'CanRead'
						IF(@CanRead = 1 AND @NewValue <> '') SET @OldValue = @OldValue + ',CanRead'

					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Language details',
					    @FieldName = 'Fluency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue = (SELECT CompetencyName  FROM Competency WHERE Id = @OldCompetencyId)
					    SET @NewValue = (SELECT CompetencyName  FROM Competency WHERE Id = @CompetencyId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Language details',
					    @FieldName = 'Competency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldComments,'') <> @Comments AND @Comments IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Language details',
					    @FieldName = 'Comments',@OldValue = @Comments,@NewValue = @Comments,@RecordTitle = @RecordTitle

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Language details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeLanguage WHERE Id = @EmployeeLanguageDetailId

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