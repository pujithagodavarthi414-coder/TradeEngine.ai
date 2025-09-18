-------------------------------------------------------------------------------
-- Author       saikumar kailasam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the App settings
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertAppsettings] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @AppsettingsName='Test1',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertAppsettings]
(
   @AppsettingsId UNIQUEIDENTIFIER = NULL,
   @AppsettingsName NVARCHAR(800)  =NULL,
   @AppsettingsValue NVARCHAR(800) = NULL,
   @IsSystemLevel BIT = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		IF(@AppsettingsName = '') SET @AppsettingsName = NULL

	    IF(@AppsettingsName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AppsettingsName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @AppsettingIdCount INT = (SELECT COUNT(1) FROM Appsettings WHERE Id = @AppsettingsId)

		DECLARE @AppsettingsNameCount INT = (SELECT COUNT(1) FROM Appsettings WHERE AppsettingsName = @AppsettingsName  AND (Id <> @AppsettingsId OR @AppsettingsId IS NULL) )

		IF(@AppsettingIdCount = 0 AND @AppsettingsId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'Appsettings')

		END
		ELSE IF(@AppsettingsNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Appsettings')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @AppsettingsId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Appsettings WHERE Id = @AppsettingsId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF(@AppsettingsId IS NULL)
					BEGIN

					SET @AppsettingsId = NEWID()

			        INSERT INTO [dbo].Appsettings(
			                    [Id],
			                    [AppsettingsName],
								[AppSettingsValue],
								[IsSystemLevel],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId])
			             SELECT @AppsettingsId,
			                    @AppsettingsName,
								@AppsettingsValue,
								@IsSystemLevel,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
			      
				  END
				  ELSE
				  BEGIN

				  UPDATE [AppSettings]
				    SET [AppSettingsName] = @AppsettingsName,
					    [AppSettingsValue] = @AppsettingsValue,
						[IsSystemLevel] = @IsSystemLevel,
					    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						[UpdatedDateTime] = @Currentdate,
						[UpdatedByUserId] = @OperationsPerformedBy
						WHERE Id = @AppsettingsId

				  END
					SELECT Id FROM [dbo].Appsettings WHERE Id = @AppsettingsId

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