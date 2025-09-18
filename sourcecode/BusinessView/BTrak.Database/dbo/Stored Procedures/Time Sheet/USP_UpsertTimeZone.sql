-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Save Or Update the TimeZone
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTimeZone]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @TimeZoneName = 'Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTimeZone]
(
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @TimeZoneName NVARCHAR(100) = NULL,
  @TimeZoneOffset NVARCHAR(10) = NULL,
  @TimeZoneAbbreviation NVARCHAR(50) = NULL,
  @CountryCode NVARCHAR(50) = NULL,
  @CountryName NVARCHAR(150) = NULL,
  @TimeZone NVARCHAR(150) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @TimeStamp  TIMESTAMP = NULL,
  @IsArchived BIT = NULL
) 
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @TimeZoneIdCount INT = (SELECT COUNT(1) FROM TimeZone WHERE Id = @TimeZoneId)

		DECLARE @TimeZoneNameCount INT = (SELECT COUNT(1) FROM TimeZone WHERE TimeZoneName = @TimeZoneName AND (@TimeZoneId IS NULL OR Id <> @TimeZoneId))

		IF(@IsArchived = 1 AND @TimeZoneId IS NOT NULL)
        BEGIN
		
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	     
		 IF(EXISTS(SELECT Id FROM [User] WHERE TimeZoneId = @TimeZoneId))
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisTimeZoneUsedInUserPleaseDeleteTheDependenciesAndTryAgain'
	     
	     END
		 
		 IF(@IsEligibleToArchive <> '1')
		 BEGIN
		 
		     RAISERROR (@isEligibleToArchive,11, 1)
		 
		 END

	    END

		IF(@TimeZoneIdCount = 0 AND @TimeZoneId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'TimeZone')

		END

		ELSE IF(@TimeZoneNameCount > 0)
		BEGIN
			
			RAISERROR(50001,16,1,'TimeZone')

		END
		
		ELSE
		BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @TimeZoneId IS NULL THEN 1 ELSE
		                                   CASE WHEN (SELECT [TimeStamp] FROM TimeZone
		                                              WHERE Id = @TimeZoneId) = @TimeStamp
		                                              THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
				BEGIN

				IF(@TimeZoneId IS NULL)
				BEGIN

					SET @TimeZoneId = NEWID()

						  INSERT INTO [dbo].[TimeZone](
						     Id,
						     TimeZoneName,
							 TimeZoneOffset,
							 TimeZone,
							 TimeZoneAbbreviation,
							 CountryCode,
							 CountryName,
						     CreatedDateTime,
							 [InActiveDateTime])

						  SELECT @TimeZoneId,
						     @TimeZoneName,
							 @TimeZoneOffset,
							 @TimeZone,
							 @TimeZoneAbbreviation,
							 @CountryCode,
							 @CountryName,
						     @Currentdate,
							 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END  

				END
				ELSE
				BEGIN

					UPDATE [dbo].[TimeZone]
						SET  TimeZoneName			  =   	  @TimeZoneName,
							 TimeZoneOffset           =       @TimeZoneOffset,
							 TimeZone                 =       @TimeZone,
							 TimeZoneAbbreviation      =       @TimeZoneAbbreviation,
							 CountryCode              =       @CountryCode,
							 CountryName              =       @CountryName,
						     UpdatedDateTime		  =   	  @Currentdate,
						     UpdatedByUserId		  =   	  @OperationsPerformedBy,
							[InActiveDateTime]		  =		  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END  
						WHERE Id = @TimeZoneId

				END
						SELECT Id FROM [dbo].TimeZone WHERE Id = @TimeZoneId

					END

					ELSE 
					BEGIN  

						RAISERROR(50008,11, 1)

				   END
		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
