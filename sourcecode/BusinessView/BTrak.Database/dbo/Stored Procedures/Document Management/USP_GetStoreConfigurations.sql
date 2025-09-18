-- Author       Sai Praneeth M
-- Created      '2019-12-30 00:00:00.000'
-- Purpose      To get store configurations from company settings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetStoreConfigurations] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetStoreConfigurations]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT	(SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL AND [Key] = 'MaxFileSize') AS MaxFileSize,
					(SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL AND [Key] = 'MaxStoreSize') AS MaxStoreSize,
					(SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL AND [Key] = 'FileExtensions') AS FileExtensions,
					@OperationsPerformedBy AS UserId

		END
		ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END

	END TRY
    BEGIN CATCH

		THROW

	END CATCH
END