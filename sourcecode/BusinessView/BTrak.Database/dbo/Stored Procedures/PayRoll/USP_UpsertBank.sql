CREATE PROCEDURE [dbo].[USP_UpsertBank]
(
	@BankId UNIQUEIDENTIFIER = NULL,
	@BankName NVARCHAR(500) = NULL,
	@CountryId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@CountryId IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'Country')

			END
			ELSE IF (@BankName IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'BankName')

			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @BankIdCount INT = (SELECT COUNT(1) FROM Bank WHERE Id = @BankId)

				DECLARE @BankDuplicateCount INT = (SELECT COUNT(1) FROM Bank WHERE CountryId = @CountryId AND BankName = @BankName AND (@BankId IS NULL OR Id <> @BankId));

				IF (@BankIdCount = 0 AND @BankId IS NOT NULL )
				BEGIN
					RAISERROR(50002,16,1,'Bank')
				END

				IF (@BankDuplicateCount > 0)
				BEGIN
					 RAISERROR(50027,16,1,'ThisBankIsAlreadyExists')
				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @BankId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Bank WHERE Id = @BankId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest <> 1) 
					BEGIN
						RAISERROR (50008,11, 1)
					END
					ELSE
					BEGIN

						DECLARE @RateTagtIdCount INT

						DECLARE @CurrentDate DATETIME = GETDATE();

						IF(@BankId IS NULL)
						BEGIN

						SET @BankId = NEWID();

						INSERT INTO [dbo].[Bank](
			 	     		          [Id],
			 	     		          [BankName],
			 						  [CountryId],
									  [CompanyId],
			 	     		          [CreatedDateTime],
			 	     		          [CreatedByUserId])
			 	     		   SELECT @BankId,
			 	     		          @BankName,
			 						  @CountryId,
									  @CompanyId,
			 	     		          @Currentdate,
			 	     		          @OperationsPerformedBy

						END
						ELSE
						BEGIN

							UPDATE [Bank] 
						    SET [BankName] = @BankName,
							    [CountryId] = @CountryId,
								[UpdatedDateTime] = @CurrentDate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								WHERE Id = @BankId

						END

					
					END
					
					SELECT Id FROM [Bank] WHERE Id = @BankId

				END
			END
		END
		ELSE
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END