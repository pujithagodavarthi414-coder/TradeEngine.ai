-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Emergency Contact
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeEmergencyContact] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' 
--,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393'
--,@FirstName = 'Test'
--,@RelationshipId = '6E1B5094-C614-4158-BAB3-DC136AFD1F89'
--,@StateOrProvinceId = '28221D82-8890-4F11-9BEA-535A269F9A8B'
--,@LastName = '123!'
--,@OtherRelation = 'Not Specified'
--,@HomeTelephone = '1023 - 88559977'
--,@MobileNo = '1122334455'
--,@WorkTelephone = '1023 - 88559977'
--,@IsEmergencyContact = 1
--,@IsDependentContact = 0
--,@AddressStreetOne = 'AddressStreetOne'
--,@AddressStreetTwo = 'AddressStreetTwo'
--,@ZipOrPostalCode = '523001'
--,@CountryId = 'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb' 
--,@IsArchived = 0
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeEmergencyContact]
(
   @EmployeeEmergencyContactId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @RelationshipId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR(800) = NULL,
   @LastName NVARCHAR(800) = NULL,
   @OtherRelation NVARCHAR(250) = NULL,
   @HomeTelephone NVARCHAR(250) = NULL,
   @MobileNo NVARCHAR(250) = NULL,
   @WorkTelephone NVARCHAR(250) = NULL,
   @IsEmergencyContact BIT = NULL,
   @IsDependentContact BIT = NULL,
   @AddressStreetOne NVARCHAR(800) = NULL,
   @AddressStreetTwo NVARCHAR(800) = NULL,
   @StateOrProvinceId UNIQUEIDENTIFIER = NULL,
   @ZipOrPostalCode NVARCHAR(100) = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@RelationshipId = '00000000-0000-0000-0000-000000000000') SET @RelationshipId = NULL

		IF(@StateOrProvinceId = '00000000-0000-0000-0000-000000000000') SET @StateOrProvinceId = NULL

		IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

	    IF(@FirstName = '') SET @FirstName = NULL

	    IF(@FirstName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'FirstName')

		END
		ELSE IF(@RelationshipId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Relation')

		END
		
		ELSE 
		BEGIN
		DECLARE @EmployeeEmergencyDetailDuplicateCount INT = 0

		DECLARE @EmployeeDependentDetailDuplicateCount INT = 0

		DECLARE @EmployeeEmergencyContactIdsCount INT = (SELECT COUNT(1) FROM [dbo].[EmployeeEmergencyContact] WHERE Id = @EmployeeEmergencyContactId  AND @IsEmergencyContact = 1)

		DECLARE @EmployeeDependentContactIdsCount INT = (SELECT COUNT(1) FROM [dbo].[EmployeeEmergencyContact] WHERE Id = @EmployeeEmergencyContactId AND @IsDependentContact = 1)

		IF (@IsEmergencyContact = 1)
		BEGIN
		SET @EmployeeEmergencyDetailDuplicateCount = (SELECT COUNT(1) FROM EmployeeEmergencyContact WHERE EmployeeId = @EmployeeId AND IsEmergencyContact = 1 AND FirstName = @FirstName AND LastName = @LastName AND MobileNo = @MobileNo AND (Id <> @EmployeeEmergencyContactId OR @EmployeeEmergencyContactId IS NULL)  AND InActiveDateTime IS NULL)
		END

		IF (@IsDependentContact = 1)
		BEGIN
		SET @EmployeeDependentDetailDuplicateCount = (SELECT COUNT(1) FROM EmployeeEmergencyContact WHERE EmployeeId = @EmployeeId AND IsDependentContact = 1 AND FirstName = @FirstName AND LastName = @LastName AND MobileNo = @MobileNo AND (Id <> @EmployeeEmergencyContactId OR @EmployeeEmergencyContactId IS NULL)  AND InActiveDateTime IS NULL)
		END

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																									 AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditOtherEmployeeDetails',11,1)
		END

		ELSE IF(@EmployeeEmergencyContactIdsCount = 0 AND @EmployeeEmergencyContactId IS NOT NULL AND @IsEmergencyContact = 1)
		BEGIN

			RAISERROR(50002,16, 1,'EmployeeEmergencyContactDetails')

		END

		ELSE IF(@EmployeeDependentContactIdsCount = 0 AND @EmployeeEmergencyContactId IS NOT NULL AND @IsDependentContact = 1)
		BEGIN

			RAISERROR(50002,16, 1,'EmployeeDependentContactDetails')
		END

		ELSE IF(@EmployeeDependentDetailDuplicateCount > 0)
		BEGIN
				 
			RAISERROR('EmployeeDependentDetailsAlreadyExists',11,1)
				   
		END
		ELSE IF(@EmployeeEmergencyDetailDuplicateCount > 0)
		BEGIN
				 
			RAISERROR('EmployeeEmergencyContactDetailsAlreadyExists',11,1)
				   
		END
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeEmergencyContactId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM EmployeeEmergencyContact WHERE Id = @EmployeeEmergencyContactId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldRelationshipId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldFirstName NVARCHAR(800) = NULL
                    DECLARE @OldLastName NVARCHAR(800) = NULL
					DECLARE @OldMobileNumber NVARCHAR(800) = NULL
					DECLARE @OldHomeTelephone NVARCHAR(800) = NULL
					DECLARE @OldWorkTelephone NVARCHAR(800) = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
			        

					SELECT @OldRelationshipId =  [RelationshipId],
					       @OldFirstName      =  [FirstName],
					       @OldLastName       =  [LastName],
					       @OldMobileNumber   =  [MobileNo],
						   @OldWorkTelephone  =  [WorkTelephone],
						   @OldHomeTelephone  =  [HomeTelephone],
					       @Inactive          =  [InActiveDateTime]
					       FROM EmployeeEmergencyContact WHERE Id = @EmployeeEmergencyContactId


			       IF(@EmployeeEmergencyContactId IS NULL)
				   BEGIN

					SET @EmployeeEmergencyContactId = NEWID()

					INSERT INTO [dbo].[EmployeeEmergencyContact](
								[Id],
								[EmployeeId],
								[RelationshipId],
								[FirstName],
								[LastName],
								[OtherRelation],
								[HomeTelephone],
								[MobileNo],
								[WorkTelephone],
								[IsEmergencyContact],
								[IsDependentContact],
								[AddressStreetOne],
								[AddressStreetTwo],
								[StateOrProvinceId],
								[ZipOrPostalCode],
								[CountryId],
								[CreatedDateTime],
								[CreatedByUserId],
								[InActiveDateTime]
								)
						 SELECT @EmployeeEmergencyContactId,
								@EmployeeId,
								@RelationshipId,
								@FirstName,
								@LastName,
								@OtherRelation,
								@HomeTelephone,
								@MobileNo,
								@WorkTelephone,
								@IsEmergencyContact,
								@IsDependentContact,
								@AddressStreetOne,
								@AddressStreetTwo,
								@StateOrProvinceId,
								@ZipOrPostalCode,
								@CountryId,
								@Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						END
						ELSE
						BEGIN

						UPDATE [EmployeeEmergencyContact]
						SET    [EmployeeId] = @EmployeeId,
							   [RelationshipId] = @RelationshipId,
							   [FirstName] = @FirstName,
							   [LastName] = @LastName,
							   [OtherRelation] = @OtherRelation,
							   [HomeTelephone] = @HomeTelephone,
							   [MobileNo] = @MobileNo,
							   [WorkTelephone] = @WorkTelephone,
							   [IsEmergencyContact] = @IsEmergencyContact,
							   [IsDependentContact] = @IsDependentContact,
							   [AddressStreetOne] = @AddressStreetOne,
							   [AddressStreetTwo] = @AddressStreetTwo,
							   [StateOrProvinceId] = @StateOrProvinceId,
							   [ZipOrPostalCode] = @ZipOrPostalCode,
							   [CountryId] = @CountryId,
							   [UpdatedDateTime] = @Currentdate,
							   [UpdatedByUserId] = @OperationsPerformedBy,
							   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @EmployeeEmergencyContactId
								
						END
					
					DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT FirstName + ' ' + ISNULL(LastName,'') FROM EmployeeEmergencyContact WHERE Id = @EmployeeEmergencyContactId)

					SET @OldValue = (SELECT RelationShipName  FROM RelationShip WHERE Id = @OldRelationshipId)
					SET @NewValue = (SELECT RelationShipName  FROM RelationShip WHERE Id = @RelationshipId)
					
					DECLARE @Field NVARCHAR(20) = IIF(ISNULL(@IsEmergencyContact,0) = 0,'Dependent contact','Emergency contact')

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Relationship',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldFirstName,'') <> @FirstName AND @FirstName IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'First name',@OldValue = @OldFirstName,@NewValue = @FirstName,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldLastName,'') <> @LastName AND @LastName IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Last name',@OldValue = @OldLastName,@NewValue = @LastName,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldMobileNumber,'') <> @MobileNo AND @MobileNo IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Mobile number',@OldValue = @OldMobileNumber,@NewValue = @MobileNo,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldHomeTelephone,'') <> @HomeTelephone AND @HomeTelephone IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Home telephone number',@OldValue = @OldHomeTelephone,@NewValue = @HomeTelephone,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldWorkTelephone,'') <> @WorkTelephone AND @WorkTelephone IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Work telephone number',@OldValue = @OldWorkTelephone,@NewValue = @WorkTelephone,@RecordTitle = @RecordTitle

					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = @Field,
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].[EmployeeEmergencyContact] WHERE Id = @EmployeeEmergencyContactId

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