-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-10-22 00:00:00.000'
-- Purpose      To Save or update the stores
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertStore] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @StoreName='Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertStore]
(
   @StoreId UNIQUEIDENTIFIER = NULL,
   @StoreName NVARCHAR(50)  = NULL,
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

		IF(@StoreName = '') SET @StoreName = NULL

	    IF(@StoreName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'StoreName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @StoreIdCount INT = (SELECT COUNT(1) FROM Store WHERE Id = @StoreId AND CompanyId = @CompanyId )

		DECLARE @StoreNameCount INT = (SELECT COUNT(1) FROM Store WHERE StoreName = @StoreName AND CompanyId = @CompanyId AND (Id <> @StoreId OR @StoreId IS NULL) AND InActiveDateTime IS NULL)

		IF(@StoreIdCount = 0 AND @StoreId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Store')
		END
		ELSE IF(@StoreNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Store')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @StoreId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Store WHERE Id = @StoreId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        IF(@StoreId IS NULL)
					BEGIN

					SET @StoreId = NEWID()

						INSERT INTO [dbo].Store(
						            [Id],
						            [StoreName],
						            [InActiveDateTime],
						            [CreatedDateTime],
						            [CreatedByUserId],
									CompanyId)
						     SELECT @StoreId,
						            @StoreName,
						            CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						            @Currentdate,
						            @OperationsPerformedBy,
									@CompanyId

					END
					ELSE
					BEGIN

						UPDATE [dbo].[Store]
								SET [StoreName] = @StoreName
								,[InActiveDateTime]=  CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
								,[UpdatedDateTime] = @Currentdate
			   			  		,[UpdatedByUserId] = @OperationsPerformedBy
								,CompanyId = @CompanyId
						WHERE Id = @StoreId

			        END

					IF(@IsArchived = 1)
					BEGIN 

						UPDATE [dbo].[Folder] SET InActiveDateTime = @Currentdate, UpdatedDateTime = @Currentdate, UpdatedByUserId = @OperationsPerformedBy WHERE StoreId = @StoreId

						UPDATE [dbo].[UploadFile] SET InActiveDateTime = @Currentdate, UpdatedDateTime = @Currentdate, UpdatedByUserId = @OperationsPerformedBy WHERE StoreId = @StoreId

					END

			        SELECT Id FROM [dbo].[Store] WHERE Id = @StoreId

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