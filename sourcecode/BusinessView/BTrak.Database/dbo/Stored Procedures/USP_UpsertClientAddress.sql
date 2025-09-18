----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Update Client Address by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClientAddress] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientAddressId = 'DF87F51A-8A06-4649-AE63-BE61C9B17DF4', 
-- @ClientId = '09CF62AD-B1CB-43C7-91B7-B0CC2451FBFF',@CountryId = 'EAFDF9C6-C4D2-42D0-86EB-4B70197FF1BB', @Zipcode = '456001', @Street = 'Kphb-1', @City = 'Hyderabad', 
-- @State = 'Telangana', @IsArchived = 0, @TimeStamp = 0x00000000000368FF
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClientAddress]
(
   @ClientAddressId UNIQUEIDENTIFIER = NULL,	
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @Zipcode NVARCHAR(150) = NULL,
   @Street NVARCHAR(150) = NULL,
   @City NVARCHAR(150) = NULL,
   @State NVARCHAR(150) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		  IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL  
		  
		  IF(@ClientId IS NULL)	      
		  BEGIN
		     
			  RAISERROR(50011,16, 2, 'ClientId')
		  
		  END	
	   	   	    
		  IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL  
		  
		  IF(@CountryId IS NULL)	      
		  BEGIN
		     
			  RAISERROR(50011,16, 2, 'CountryId')
		  
		  END		  
		  ELSE 	
	   	   	  		  
			DECLARE @ClientAddressIdCount INT = (SELECT COUNT(1) FROM ClientAddress WHERE Id = @ClientAddressId) 
       	  
			IF(@ClientAddressIdCount = 0 AND @ClientAddressId IS NOT NULL)
			BEGIN
              
			RAISERROR(50002,16, 2,'ClientAddress')
          
			END
			ELSE
		 
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @ClientAddressId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ClientAddress WHERE Id = @ClientAddressId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
				IF(@IsLatest = 1)
				BEGIN

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
					DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM ClientAddress WHERE Id = @ClientAddressId)

					DECLARE @Currentdate DATETIME = GETDATE()		

					DECLARE @OldZipcode NVARCHAR(250)  = (SELECT [Zipcode] FROM ClientAddress CA WHERE CA.Id = @ClientAddressId)

					DECLARE @OldStreet NVARCHAR(250)  = (SELECT [Street] FROM ClientAddress CA WHERE CA.Id = @ClientAddressId)

					DECLARE @OldCity NVARCHAR(250)  = (SELECT [City] FROM ClientAddress CA WHERE CA.Id = @ClientAddressId)

					DECLARE @OldState NVARCHAR(250)  = (SELECT [State] FROM ClientAddress CA WHERE CA.Id = @ClientAddressId) 

					DECLARE @OldCountryId UNIQUEIDENTIFIER  = (SELECT [CountryId] FROM ClientAddress CA WHERE CA.Id = @ClientAddressId)

					DECLARE @NewValue NVARCHAR (250)

					DECLARE @FieldName NVARCHAR (250)

					DECLARE @Description NVARCHAR (1000)

					IF(@ClientId IS NULL)
					BEGIN

						EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @FieldName = 'Insert', @OperationsPerformedBy = @OperationsPerformedBy

					END
					ELSE
					BEGIN

						IF(@Zipcode <> @OldZipcode)
						BEGIN 

							 SET @FieldName = 'Zipcode' 

							 SET @Description = 'ZIPCODEUPDATED'

							 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldZipcode, @NewValue = @Zipcode, @FieldName = @FieldName,
							 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END

						IF(@Street <> @OldStreet)
						BEGIN

							 SET @FieldName = 'Street'

							 SET @Description = 'STREETUPDATED'

							 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldStreet, @NewValue = @Street, @FieldName = @FieldName,
							 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END

						IF(@City <> @OldCity)
						BEGIN

							 SET @FieldName = 'City'

							 SET @Description = 'CITYUPDATED'

							 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldCity, @NewValue = @City, @FieldName = @FieldName,
							 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END

						IF(@State <> @OldState)
						BEGIN

							 SET @FieldName = 'State'

							 SET @Description = 'STATEUPDATED'

							 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldState, @NewValue = @State, @FieldName = @FieldName,
							 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END

						IF(@CountryId <> @OldCountryId)
						BEGIN

							 SET @FieldName = 'CountryId'

							 SET @Description = 'COUNTRYIDUPDATED'

							 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldCountryId, @NewValue = @CountryId, @FieldName = @FieldName,
							 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END
					END

					IF(@ClientAddressId IS NULL)
					 BEGIN
					 SET @ClientAddressId = NEWID()

					INSERT INTO [dbo].[ClientAddress](
								[Id],
			   	         		[ClientId],
								[CountryId],
								[Zipcode],
								[Street],
								[City],
								[State],
								[CreatedDateTime],
			   	         		[CreatedByUserId],		
			   	         		[InActiveDateTime]
			   	         		)
							SELECT @ClientAddressId,
								@ClientId,
								@CountryId,
								@Zipcode,
								@Street,
								@City,
								@State,
								@Currentdate,
			   	         		@OperationsPerformedBy,	
								CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END

					END
						ELSE
						BEGIN
						UPDATE [ClientAddress]
						   SET [ClientId] = @ClientId,
                               [CountryId] = @CountryId,
							   [Zipcode] = @Zipcode,
							   [Street] = @Street,
							   [City] = @City,
							   [State] = @State,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @ClientAddressId
						END	

					SELECT Id FROM [dbo].[ClientAddress] WHERE Id = @ClientAddressId

				END
				ELSE
				BEGIN

					RAISERROR(50008,11,1)

			END
			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
