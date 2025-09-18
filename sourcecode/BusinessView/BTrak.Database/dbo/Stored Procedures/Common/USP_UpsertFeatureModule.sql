-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update the FeatureModule
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertFeatureModule]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId='312C1E47-8601-4D48-A3D4-53C7A075A908',@ModuleId='12C29CF7-CC76-4436-9DE1-3AE02DD1BD39',@IsActive='1', @FeatureModuleId='2F37C1C7-FF0B-4409-9C49-C882B7379CC1'

CREATE PROCEDURE [dbo].[USP_UpsertFeatureModule]
(
    @FeatureModuleId UNIQUEIDENTIFIER = NULL,
    @FeatureId UNIQUEIDENTIFIER = NULL,
    @ModuleId  UNIQUEIDENTIFIER = NULL,
    @IsActive BIT = 1,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

    IF(@HavePermission = '1')
    BEGIN

		IF(@FeatureModuleId IS NULL)
		BEGIN
		 
			SET @FeatureModuleId = NEWID()

			INSERT INTO [dbo].[FeatureModule](
		                    [Id],
		                    [FeatureId],
		                    [ModuleId],
							[InActiveDateTime],
		                    [CreatedDateTime],
		                    [CreatedByUserId]
		                    )
		             SELECT @FeatureModuleId,
		                    @FeatureId,
		                    @ModuleId,
							CASE WHEN @IsActive = 1 THEN NULL ELSE @CurrentDate END,
		                    @Currentdate,
		                    @OperationsPerformedBy

		END
		ELSE
		BEGIN
			
			UPDATE [dbo].[FeatureModule]
				SET [FeatureId] = @FeatureId
				    ,[ModuleId] = @ModuleId
					,[InActiveDateTime] = CASE WHEN @IsActive = 1 THEN NULL ELSE @CurrentDate END
					,[UpdatedByUserId] = @OperationsPerformedBy
					,[UpdatedDateTime] = @CurrentDate
				WHERE Id = @FeatureModuleId

		END

		SELECT Id FROM [dbo].[FeatureModule] WHERE Id = @FeatureModuleId

	END
	ELSE
	BEGIN

	     RAISERROR (@HavePermission,10, 1)

	END

    END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END
GO