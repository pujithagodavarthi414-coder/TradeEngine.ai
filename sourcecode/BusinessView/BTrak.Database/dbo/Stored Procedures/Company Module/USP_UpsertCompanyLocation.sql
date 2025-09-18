-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Save or update the Company Location
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertCompanyLocation] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LocationName='TEST',
-- @Address='S.Road',@Latitude='99.0',@Longitude='12.112'
-------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertCompanyLocation
(
  @CompanyLocationId UNIQUEIDENTIFIER = NULL,
  @LocationName NVARCHAR(250) = NULL,
  @Address     NVARCHAR(1000) = NULL,
  @TimeStamp  TIMESTAMP = NULL,
  @Latitude    FLOAT = NULL,
  @Longitude   FLOAT = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	 IF(@CompanyLocationId = '00000000-0000-0000-0000-000000000000') SET @CompanyLocationId = NULL
     IF (@LocationName = '') SET @LocationName = NULL
	 IF (@Address = '') SET @Address = NULL
	 IF (@LocationName = '') SET @LocationName = NULL
	 IF(@LocationName IS NULL)
	 BEGIN
	   RAISERROR(50011,16, 2, 'LocationName')
	 END
	 ELSE IF(@Address IS NULL)
	 BEGIN
	    RAISERROR(50011,16, 2, 'Address')
	 END
	 ELSE IF(@Latitude IS NULL)
	 BEGIN
	    RAISERROR(50011,16, 2, 'Latitude')
	 END
	 ELSE IF(@Longitude IS NULL)
	 BEGIN
	    RAISERROR(50011,16, 2, 'Longitude')
	 END
	 ELSE
	 BEGIN
		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 IF(@HavePermission = '1')
		 BEGIN
			    DECLARE @IsLatest BIT = (CASE WHEN @CompanyLocationId IS NULL THEN 1 ELSE
		                                   CASE WHEN (SELECT [TimeStamp] FROM [CompanyLocation]
		                                              WHERE Id = @CompanyLocationId) = @TimeStamp
		                                              THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
				BEGIN
					      DECLARE @CurrentDate DATETIME = GETDATE()
						  DECLARE @LocationIdCount INT = (SELECT COUNT(1) FROM [CompanyLocation] WHERE Id = @CompanyLocationId)
						  DECLARE @LocationNameCount INT = (SELECT COUNT(1) FROM [CompanyLocation]
	                                        WHERE LocationName = @LocationName AND [Address] = @Address AND Latitude = @Latitude AND Longitude = @Longitude AND CompanyId = @CompanyId  AND
	                                             (@CompanyLocationId IS NULL OR Id <> @CompanyLocationId))
						IF (@LocationIdCount = 0 AND @CompanyLocationId IS NOT NULL)
						BEGIN
							RAISERROR(50002,16,1,'LocationName')
						END
						ELSE IF(@LocationNameCount > 0)
						BEGIN
							RAISERROR('CompanyLocationWithTheseDetailsAlreadyExists',16,1,'LocationName')
						END
						ELSE
						BEGIN

						IF (@CompanyLocationId IS NULL)
						BEGIN

						SET @CompanyLocationId = NEWID()
						INSERT INTO [dbo].[CompanyLocation](
							                                   [Id],
							                                   [CompanyId],
							                                   [LocationName],
							                                   [Address],
							                                   [Longitude],
							                                   [Latitude],
							                                   [CreatedDateTime],
							                                   [CreatedByUserId],
											  	               [InActiveDateTime]
																  )
							                            SELECT @CompanyLocationId,
							                                   @CompanyId,
							                                   @LocationName,
							                                   @Address,
							                                   @Longitude,
							                                   @Latitude,
							                                   @Currentdate,
							                                   @OperationsPerformedBy,
											              	   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

						END
						ELSE
						BEGIN

								UPDATE [dbo].[CompanyLocation]
													      SET  [CompanyId]			 = 	   @CompanyId,
							                                   [LocationName]		 = 	   @LocationName,
							                                   [Address]			 = 	   @Address,
							                                   [Longitude]			 = 	   @Longitude,
							                                   [Latitude]			 = 	   @Latitude,
							                                   [UpdatedDateTime]	 = 	   @Currentdate,
							                                   [UpdatedByUserId]	 = 	   @OperationsPerformedBy,
											  	               [InActiveDateTime]	 = 	   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
														WHERE Id = @CompanyLocationId

						END
							    SELECT Id FROM [dbo].[CompanyLocation] WHERE Id = @CompanyLocationId
						END
					END
					ELSE
					BEGIN
					 RAISERROR(50008,11, 1)
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
