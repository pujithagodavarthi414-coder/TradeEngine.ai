CREATE PROCEDURE [dbo].[USP_UpsertEntryFormField]
	@EntryFormId UNIQUEIDENTIFIER = NULL,
	@Unit NVARCHAR(250) = NULL,
	@DisplayName NVARCHAR(250) = NULL,
	@FieldName NVARCHAR(250) = NULL,
	@IsDisplay BIT = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@FieldTypeId UNIQUEIDENTIFIER = NULL,
	@GRDId UNIQUEIDENTIFIER = NULL,
	@SelectedGrds NVARCHAR(MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@EntryFormId =  '00000000-0000-0000-0000-000000000000') SET @EntryFormId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @EntryFormIdCount INT = (SELECT COUNT(1) FROM [EntryFormField] WHERE Id = @EntryFormId AND CompanyId = @CompanyId)

			DECLARE @DisplayNameCount INT = (SELECT COUNT(1) FROM [EntryFormField] WHERE [DisplayName] = @DisplayName AND CompanyId = @CompanyId AND (@EntryFormId IS NULL OR Id <> @EntryFormId) AND InActiveDateTime IS NULL)

			DECLARE @FieldNameCount INT = (SELECT COUNT(1) FROM [EntryFormField] WHERE [FieldName] = @FieldName AND CompanyId = @CompanyId AND (@EntryFormId IS NULL OR Id <> @EntryFormId) AND InActiveDateTime IS NULL)

			IF(@EntryFormIdCount = 0 AND @EntryFormId IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'EntryForm')
			END
          
			ELSE IF(@DisplayNameCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'DisplayName')
			END

			ELSE IF(@FieldNameCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'FieldName')
			END

			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @EntryFormId IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[EntryFormField] WHERE Id = @EntryFormId) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
			BEGIN
				IF(@EntryFormId IS NULL)
				BEGIN
					SET @EntryFormId = (SELECT NEWID())

					INSERT INTO [dbo].[EntryFormField](
									[Id],
									[DisplayName],
									[Unit],
									[FieldTypeId],
									[FieldName],
									[IsDisplay],
									[CreatedByUserId],
									[CreatedDateTime],
									CompanyId,
									[GRDId],
									[SelectedGrdIds]
									)
							SELECT @EntryFormId,
								   @DisplayName,
								   @Unit,
								   @FieldTypeId,
								   @FieldName,
								   @IsDisplay,
								   @OperationsPerformedBy,
								   GETDATE(),
								   @CompanyId,
								   @GRDId,
								   @SelectedGrds
				END
				ELSE
				BEGIN
					UPDATE [dbo].[EntryFormField]
						SET [DisplayName] = @DisplayName,
							[FieldName] = @FieldName,
							[FieldTypeId] = @FieldTypeId,
							[IsDisplay] = @IsDisplay,
							Unit = @Unit,
							GRDId = @GRDId,
							UpdatedByUserId = @OperationsPerformedBy,
							UpdatedDateTime = GETDATE(),
							[SelectedGrdIds] = @SelectedGrds,
							InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
					WHERE Id = @EntryFormId
				END

				SELECT @EntryFormId
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
