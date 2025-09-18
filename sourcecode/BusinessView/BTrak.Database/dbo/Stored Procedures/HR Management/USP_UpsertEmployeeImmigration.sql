-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Immigration
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeImmigration] 
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393'
--,@Document = 'Licence Proof'
--,@DocumentNumber = '123456789'
--,@IssuedDate = '2018-01-01'
--,@ExpiryDate = '2019-01-01'
--,@ActiveFrom = '2018-01-01'
--,@ActiveTo = NULL
--,@CountryId = 'DB84FBA0-41C7-4746-92D1-03B581D81234' 
--,@IsArchived = 0
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeImmigration]
(
   @EmployeeImmigrationId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @Document NVARCHAR(100) = NULL,
   @DocumentNumber NVARCHAR(100) = NULL,
   @IssuedDate DATETIME = NULL,
   @ExpiryDate DATETIME = NULL,
   @EligibleStatus NVARCHAR(100) = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @EligibleReviewDate DATETIME = NULL,
   @Comments NVARCHAR(800) = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
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

		IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

		IF(@Document = '') SET @Document = NULL

		IF(@DocumentNumber = '') SET @DocumentNumber = NULL

	    IF(@Document IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Document')

		END
		ELSE IF(@DocumentNumber IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DocumentNumber')

		END
		ELSE IF(@CountryId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Country')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeImmigrationIdsCount INT = (SELECT COUNT(1) FROM [dbo].[EmployeeImmigration] WHERE Id = @EmployeeImmigrationId )

		DECLARE @EmployeeImmigrationDetailDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeImmigration WHERE EmployeeId = @EmployeeId AND Document = @Document AND DocumentNumber = @DocumentNumber AND (Id <> @EmployeeImmigrationId OR @EmployeeImmigrationId IS NULL)  AND InActiveDateTime IS NULL)

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeImmigrationDetails',11,1)
		END

		ELSE IF(@EmployeeImmigrationIdsCount = 0 AND @EmployeeImmigrationId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'EmployeeImmigration')

		END IF(@EmployeeImmigrationDetailDuplicateCount > 0)
		BEGIN
				 
			RAISERROR('ImmigrationDetailsWithSameDocumentNumberAlreadyExsists',11,1)
				   
		END
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN


				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeImmigrationId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM [dbo].[EmployeeImmigration] WHERE Id = @EmployeeImmigrationId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldDocument NVARCHAR(100) = NULL
                    DECLARE @OldDocumentNumber NVARCHAR(100) = NULL
                    DECLARE @OldIssuedDate DATETIME = NULL
                    DECLARE @OldExpiryDate DATETIME = NULL
                    DECLARE @OldEligibleStatus NVARCHAR(100) = NULL
                    DECLARE @OldCountryId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldEligibleReviewDate DATETIME = NULL
                    DECLARE @OldComments NVARCHAR(800) = NULL
                    DECLARE @OldActiveFrom DATETIME = NULL
                    DECLARE @OldActiveTo DATETIME = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
			        
					     SELECT @OldDocument            = [Document],
								@OldDocumentNumber      = [DocumentNumber],
								@OldIssuedDate          = [IssuedDate],
								@OldExpiryDate          = [ExpiryDate],
								@OldEligibleStatus      = [EligibleStatus],
                                @OldCountryId           = [CountryId],
                                @OldEligibleReviewDate  = [EligibleReviewDate],
								@OldComments            = [Comments],
								@OldActiveFrom          = [ActiveFrom],
								@OldActiveTo            = [ActiveTo],
								@Inactive           	= [InActiveDateTime]
								FROM EmployeeImmigration WHERE Id = @EmployeeImmigrationId


			      IF(@EmployeeImmigrationId IS NULL)
				  BEGIN

				  SET @EmployeeImmigrationId = NEWID()

					INSERT INTO [dbo].[EmployeeImmigration](
								[Id],
								[EmployeeId],
								[Document],
								[DocumentNumber],
								[IssuedDate],
								[ExpiryDate],
								[EligibleStatus],
								[CountryId],
								[EligibleReviewDate],
								[Comments],
								[ActiveFrom],
								[ActiveTo],
								[CreatedDateTime],
								[CreatedByUserId],
								[InActiveDateTime]
								)
						 SELECT @EmployeeImmigrationId,
								@EmployeeId,
								@Document,
								@DocumentNumber,
								@IssuedDate,
								@ExpiryDate,
								@EligibleStatus,
                                @CountryId,
                                @EligibleReviewDate,
								@Comments,
								@ActiveFrom,
								@ActiveTo,
								@Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END

					  END
					  ELSE
					  BEGIN

					  UPDATE [dbo].[EmployeeImmigration]
							SET [EmployeeId] = @EmployeeId,
								[Document] = @Document,
								[DocumentNumber] = @DocumentNumber,
								[IssuedDate] = @IssuedDate,
								[ExpiryDate] = @ExpiryDate,
								[EligibleStatus] = @EligibleStatus,
								[CountryId] = @CountryId,
								[EligibleReviewDate] = @EligibleReviewDate,
								[Comments] = @Comments,
								[ActiveFrom] = @ActiveFrom,
								[ActiveTo] = @ActiveTo,
								[UpdatedDateTime] = @Currentdate ,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END
                         WHERE Id = @EmployeeImmigrationId

					  END

					  UPDATE Reminder SET [InActiveDateTime] = CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END
                         WHERE ReferenceId = @EmployeeImmigrationId

					  DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT DocumentNumber  FROM [EmployeeImmigration] WHERE Id = @EmployeeImmigrationId)

						SET @OldValue = (SELECT CountryName  FROM [Country] WHERE Id = @OldCountryId)
					    SET @NewValue = (SELECT CountryName  FROM [Country] WHERE Id = @CountryId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Country',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldDocument,'') <> @Document AND @Document IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Document',@OldValue = @OldDocument,@NewValue = @Document,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldDocumentNumber,'') <> @DocumentNumber AND @DocumentNumber IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Document number',@OldValue = @OldDocumentNumber,@NewValue = @DocumentNumber,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldEligibleStatus,'') <> @EligibleStatus AND @EligibleStatus IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Eligible status',@OldValue = @OldEligibleStatus,@NewValue = @EligibleStatus,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldIssuedDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@IssuedDate,20)

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Issued date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldExpiryDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ExpiryDate,20)

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Expiry date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldEligibleReviewDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@EligibleReviewDate,20)

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Eligible review date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveFrom,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveFrom,20)

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Active from date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveTo,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveTo,20)

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Active to date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldComments,'') <> @Comments AND @Comments IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Immigration details',
					    @FieldName = 'Comments',@OldValue = @OldComments,@NewValue = @Comments,@RecordTitle = @RecordTitle


			        SELECT Id FROM [dbo].[EmployeeImmigration] WHERE Id = @EmployeeImmigrationId

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