-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Contact Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeContactDetails] @CountryId = 'D63C0274-8BEA-4B78-83F6-2D39157C0DB4',@StateId = 'A74CE294-1171-4C81-BF88-1A5C3D4E227A',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeContactDetails]
(
   @EmployeeContactDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @StateId UNIQUEIDENTIFIER = NULL,
   @Address1 NVARCHAR(800) = NULL,
   @Address2 NVARCHAR(800) = NULL,
   @PostalCode NVARCHAR(800) = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @HomeTelephone NVARCHAR(800) = NULL,
   @Mobile NVARCHAR(800) = NULL,
   @WorkTelephone NVARCHAR(800) = NULL,
   @WorkEmail NVARCHAR(800) = NULL,
   @OtherEmail NVARCHAR(800) = NULL,
   @ContactPersonName NVARCHAR(800) = NULL,
   @RelationshipId UNIQUEIDENTIFIER = NULL,
   @DateOfBirth DATETIME = NULL,
   @EmployeeContactTypeId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@StateId = '00000000-0000-0000-0000-000000000000') SET @StateId = NULL

		IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END

	    IF(@StateId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'State')

		END
		ELSE IF(@CountryId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Country')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeContactDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeContactDetails WHERE Id = @EmployeeContactDetailId)

		DECLARE @EmployeeContactDetailDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeContactDetails WHERE EmployeeId = @EmployeeId AND StateId = @StateId AND CountryId <> @CountryId AND (Id <> @EmployeeContactDetailId OR @EmployeeContactDetailId IS Null))

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																								 AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeContactDetails',11,1)
		END

		ELSE IF(@EmployeeContactDetailIdCount = 0 AND @EmployeeContactDetailId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeContactDetails')
		END

		ELSE IF(@EmployeeContactDetailDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))


			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeContactDetailId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeContactDetails WHERE Id = @EmployeeContactDetailId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					DECLARE @OldStateId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldAddress1 NVARCHAR(800) = NULL
                    DECLARE @OldAddress2 NVARCHAR(800) = NULL
                    DECLARE @OldPostalCode NVARCHAR(800) = NULL
                    DECLARE @OldCountryId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldValue NVARCHAR(MAX) = NULL
                    DECLARE @NewValue NVARCHAR(MAX) = NULL
                    DECLARE @OldHomeTelephone NVARCHAR(800) = NULL
                    DECLARE @OldMobile NVARCHAR(800) = NULL
                    DECLARE @OldWorkTelephone NVARCHAR(800) = NULL
                    DECLARE @OldWorkEmail NVARCHAR(800) = NULL
                    DECLARE @OldOtherEmail NVARCHAR(800) = NULL
                    DECLARE @OldContactPersonName NVARCHAR(800) = NULL
                    DECLARE @OldRelationshipId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldDateOfBirth DATETIME = NULL
                    DECLARE @Inactive DATETIME = NULL
                    DECLARE @OldEmployeeContactTypeId UNIQUEIDENTIFIER = NULL

					SELECT @OldStateId              =[StateId],
					       @OldAddress1             =[Address1],
					       @OldAddress2             =[Address2],
					       @OldPostalCode           =[PostalCode],
					       @OldCountryId            =[CountryId],
					       @OldHomeTelephone        =[HomeTelephoneno],
					       @OldMobile               =[Mobile],
					       @OldWorkTelephone        =[WorkTelephoneno],
					       @OldWorkEmail            =[WorkEmail],
					       @OldOtherEmail           =[OtherEmail],
					       @OldContactPersonName    =[ContactPersonName],
					       @OldRelationshipId       =[RelationshipId],
					       @OldDateOfBirth          =[DateOfBirth],
					       @OldEmployeeContactTypeId=[EmployeeContactTypeId],
						   @Inactive                =[InActiveDateTime]
						   FROM EmployeeContactDetails WHERE EmployeeId = @EmployeeId

			      IF(@EmployeeContactDetailId IS NULL)
				  BEGIN

				  SET @EmployeeContactDetailId = NEWID()

			        INSERT INTO [dbo].EmployeeContactDetails(
			                    [Id],
			                    [EmployeeId],
								[StateId],
								[Address1],
								[Address2],
								[PostalCode],
								[CountryId],
								[HomeTelephoneno],
								[Mobile],
								[WorkTelephoneno],
								[WorkEmail],
								[OtherEmail],
								[ContactPersonName],
								[RelationshipId],
								[DateOfBirth],
								[EmployeeContactTypeId],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeContactDetailId,
			                    @EmployeeId,
								@StateId,
								@Address1,
								@Address2,
								@PostalCode,
								@CountryId,
								@HomeTelephone,
								@Mobile,
								@WorkTelephone,
								@WorkEmail,
								@OtherEmail,
								@ContactPersonName,
								@RelationshipId,
								@DateOfBirth,
								@EmployeeContactTypeId,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy

					  END
					  ELSE
					  BEGIN

					  UPDATE [EmployeeContactDetails]
					    SET  [EmployeeId] = @EmployeeId,
							 [StateId] = @StateId,
							 [Address1] = @Address1,
							 [Address2] = @Address2,
							 [PostalCode] = @PostalCode,
							 [CountryId] = @CountryId,
							 [HomeTelephoneno] = @HomeTelephone,
							 [Mobile] = @Mobile,
							 [WorkTelephoneno] = @WorkTelephone,
							 [WorkEmail] = @WorkEmail,
							 [OtherEmail] = @OtherEmail,
							 [ContactPersonName] = @ContactPersonName,
							 [RelationshipId] =@RelationshipId,
							 [DateOfBirth] = @DateOfBirth,
							 [EmployeeContactTypeId] = @EmployeeContactTypeId,
			                 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						     [UpdatedDateTime] = @Currentdate,
							 [UpdatedByUserId] = @OperationsPerformedBy
							WHERE Id = @EmployeeContactDetailId

					  END
			       
				    --For employee history
				    SET @OldValue = (SELECT StateName FROM [State] WHERE Id = @OldStateId)
					SET @NewValue = (SELECT StateName FROM [State] WHERE Id = @StateId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'State',@OldValue = @OldValue,@NewValue = @NewValue

					IF(@OldAddress1 <> @Address1 AND @Address1 IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Address1',@OldValue = @OldAddress1,@NewValue = @Address1

					IF(@OldAddress2 <> @Address2 AND @Address2 IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Address2',@OldValue = @OldAddress2,@NewValue = @Address2

					IF(@OldPostalCode <> @PostalCode AND @PostalCode IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Postal code',@OldValue = @OldPostalCode,@NewValue = @PostalCode

					SET @OldValue = (SELECT CountryName FROM Country WHERE Id = @OldCountryId)
					SET @NewValue = (SELECT CountryName FROM Country WHERE Id = @CountryId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Country',@OldValue = @OldValue,@NewValue = @NewValue

					IF(@OldHomeTelephone <> @HomeTelephone AND @HomeTelephone IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Home telephone number',@OldValue = @OldHomeTelephone,@NewValue = @HomeTelephone

					IF(@OldMobile <> @Mobile AND @Mobile IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Mobile number',@OldValue = @OldMobile,@NewValue = @Mobile

					IF(@OldWorkTelephone <> @WorkTelephone AND @WorkTelephone IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Work telephone number',@OldValue = @OldWorkTelephone,@NewValue = @WorkTelephone

					IF(@OldWorkEmail <> @WorkEmail AND @WorkEmail IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Work email',@OldValue = @OldWorkEmail,@NewValue = @WorkEmail

					IF(@OldContactPersonName <> @ContactPersonName AND @ContactPersonName IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Contact person',@OldValue = @OldContactPersonName,@NewValue = @ContactPersonName

					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue

					SET @OldValue = (SELECT RelationShipName FROM RelationShip WHERE Id = @OldRelationshipId)
					SET @NewValue = (SELECT RelationShipName FROM RelationShip WHERE Id = @RelationshipId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Relation ship',@OldValue = @OldValue,@NewValue = @NewValue

					SET @OldValue = CONVERT(NVARCHAR(40),@OldDateOfBirth,20)
					SET @NewValue = CONVERT(NVARCHAR(40),@DateOfBirth,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					@FieldName = 'Date of birth',@OldValue = @OldValue,@NewValue = @NewValue

			        SELECT Id FROM [dbo].EmployeeContactDetails WHERE Id = @EmployeeContactDetailId

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