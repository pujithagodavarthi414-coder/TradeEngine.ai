-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Licene Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertEmployeeLicenceDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LicenceIssuedDate = '2019-03-01',@LicenceExpiryDate = '2019-03-01',@LicenceNumber = 'ABC106',@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393',@LicenceTypeId = '2d7a45f3-e7e6-4e98-a30d-3137f0a7b279',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeLicenceDetails]
(
   @EmployeeLicenceDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @LicenceTypeId UNIQUEIDENTIFIER = NULL,
   @LicenceNumber NVARCHAR(800) = NULL,
   @LicenceIssuedDate DATETIME = NULL,
   @LicenceExpiryDate DATETIME = NULL,
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

	    IF(@LicenceTypeId = '00000000-0000-0000-0000-000000000000') SET @LicenceTypeId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

	    IF(@LicenceNumber = '') SET @LicenceNumber = NULL

		IF(@LicenceIssuedDate = '') SET @LicenceIssuedDate = NULL

		IF(@LicenceExpiryDate = '') SET @LicenceExpiryDate = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END

	    ELSE IF(@LicenceTypeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'LicenceType')

		END
		ELSE IF(@LicenceNumber IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'LicenceNumber')

		END
		--ELSE IF(@LicenceIssuedDate IS NULL)
		--BEGIN
		   
		--    RAISERROR(50011,16, 2, 'LicenceIssuedDate')

		--END
		--ELSE IF(@LicenceExpiryDate IS NULL)
		--BEGIN
		   
		--    RAISERROR(50011,16, 2, 'LicenceExpiryDate')

		--END
		ELSE 
		BEGIN

		DECLARE @EmployeeLicenceDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeLicence WHERE Id = @EmployeeLicenceDetailId )

		DECLARE @EmployeeLicenceDetailDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeLicence WHERE EmployeeId = @EmployeeId AND LicenceNumber = @LicenceNumber AND (Id <> @EmployeeLicenceDetailId OR @EmployeeLicenceDetailId IS NULL)  AND InActiveDateTime IS NULL)

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeLicenceDetails',11,1)
		END

		ELSE IF(@EmployeeLicenceDetailIdCount = 0 AND @EmployeeLicenceDetailId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeLiceneDetails')
		END

		ELSE IF(@EmployeeLicenceDetailDuplicateCount > 0)
		BEGIN
			RAISERROR('EmployeeWithSameLicenceDetailsAlreadyExists',11,1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeLicenceDetailId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeLicence WHERE Id = @EmployeeLicenceDetailId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldLicenceTypeId UNIQUEIDENTIFIER = NULL
					DECLARE @OldLicenceNumber NVARCHAR(800) = NULL
					DECLARE @OldLicenceIssuedDate DATETIME = NULL
					DECLARE @OldLicenceExpiryDate DATETIME = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
			        
					SELECT @OldLicenceTypeId    = [LicenceTypeId],
					       @OldLicenceNumber    = [LicenceNumber],
					       @OldLicenceIssuedDate= [IssuedDate],
					       @OldLicenceExpiryDate= [ExpiryDate],
						   @Inactive            = [InActiveDateTime]
						   FROM EmployeeLicence WHERE Id = @EmployeeLicenceDetailId

			        IF(@EmployeeLicenceDetailId IS NULL)
					BEGIN

					SET @EmployeeLicenceDetailId = NEWID()

			        INSERT INTO [dbo].EmployeeLicence(
			                    [Id],
			                    [EmployeeId],
								[LicenceTypeId],
								[LicenceNumber],
								[IssuedDate],
								[ExpiryDate],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeLicenceDetailId,
			                    @EmployeeId,
								@LicenceTypeId,
								@LicenceNumber,
								@LicenceIssuedDate,
								@LicenceExpiryDate,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy

						END
						ELSE
						BEGIN

						UPDATE [dbo].EmployeeLicence
			                SET [EmployeeId] = @EmployeeId,
								[LicenceTypeId] = @LicenceTypeId,
								[LicenceNumber] = @LicenceNumber,
								[IssuedDate] = @LicenceIssuedDate,
								[ExpiryDate] = @LicenceExpiryDate,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [CreatedByUserId] = @OperationsPerformedBy
								WHERE Id = @EmployeeLicenceDetailId

						END
					
					UPDATE Reminder SET [InActiveDateTime] = CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END
                         WHERE ReferenceId = @EmployeeLicenceDetailId
					
					DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT LicenceNumber FROM EmployeeLicence WHERE Id = @EmployeeLicenceDetailId)

				    SET @OldValue = (SELECT LicenceTypeName  FROM LicenceType WHERE Id = @OldLicenceTypeId)
					SET @NewValue = (SELECT LicenceTypeName  FROM LicenceType WHERE Id = @LicenceTypeId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'License details',
					@FieldName = 'Licence type',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldLicenceIssuedDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@LicenceIssuedDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'License details',
					@FieldName = 'Issued date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldLicenceExpiryDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@LicenceExpiryDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'License details',
					@FieldName = 'Expiry date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldLicenceNumber,'') <> @LicenceNumber AND @LicenceNumber IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'License details',
					@FieldName = 'License number',@OldValue = @OldLicenceNumber,@NewValue = @LicenceNumber,@RecordTitle = @RecordTitle

					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'License details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeLicence WHERE Id = @EmployeeLicenceDetailId

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