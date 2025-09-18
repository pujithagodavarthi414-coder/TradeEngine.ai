CREATE PROCEDURE [dbo].[USP_UpsertEntryFormFieldType]
	@Id UNIQUEIDENTIFIER = NULL,
	@FieldTypeName NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @EntryFormIdCount INT = (SELECT COUNT(1) FROM [EntryFormFieldType] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @DisplayNameCount INT = (SELECT COUNT(1) FROM [EntryFormFieldType] WHERE [FieldTypeName] = @FieldTypeName AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InActiveDateTime IS NULL)

			IF(@EntryFormIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'EntryFormFieldType')
			END
          
			ELSE IF(@DisplayNameCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'FieldType')
			END

			
			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[EntryFormFieldType] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
			BEGIN
				IF(@Id IS NULL)
				BEGIN
					SET @Id = (SELECT NEWID())

					INSERT INTO [dbo].[EntryFormFieldType](
									[Id],
									[FieldTypeName],
									[CreatedByUserId],
									[CreatedDateTime],
									CompanyId
									)
							SELECT @Id,
								   @FieldTypeName,
								   @OperationsPerformedBy,
								   GETDATE(),
								   @CompanyId
				END
				ELSE
				BEGIN
					UPDATE [dbo].[EntryFormFieldType]
						SET [FieldTypeName] = @FieldTypeName,
							UpdatedByUserId = @OperationsPerformedBy,
							UpdatedDateTime = GETDATE(),
							InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
					WHERE Id = @Id
				END

				SELECT @Id
			END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
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
