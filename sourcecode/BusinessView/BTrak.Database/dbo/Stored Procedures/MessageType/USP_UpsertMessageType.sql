CREATE PROCEDURE [dbo].[USP_UpsertMessageType]
	@MessageId UNIQUEIDENTIFIER = NULL,
	@GrdId UNIQUEIDENTIFIER = NULL,
	@DisplayText NVARCHAR(MAX) = NULL,
	@MessageTypeName NVARCHAR(250) = NULL,
	@IsDisplay BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@SelectedGrdIds NVARCHAR(MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))  
		IF (@HavePermission = '1')
		BEGIN
		   IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		   IF(@MessageId =  '00000000-0000-0000-0000-000000000000' ) SET @MessageId = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @MessageIdCount INT = (SELECT COUNT(1) FROM [MessageFieldMaster] WHERE Id = @MessageId AND CompanyId = @CompanyId)

		   IF(@IsArchived IS NULL) SET @IsArchived = 0

		   IF(@MessageIdCount = 0 AND @MessageId IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'MessageField')
			END
			ELSE
			BEGIN
			   DECLARE @IsLatest BIT = (CASE WHEN @MessageId IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[MessageFieldMaster] WHERE Id = @MessageId) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
			   IF(@IsLatest = 1)
			   BEGIN
			     IF(@MessageId IS NULL)
				 BEGIN
				     SET @MessageId = NEWID()
					  INSERT INTO [dbo].[MessageFieldMaster](
					                             [Id],
												 [MessageType],
												 [DisplayText],
												 [GrdId],
												 [IsDisplay],
												 [CompanyId],
												 [CreatedByUserId],
												 [CreatedDateTime],
												 [SelectedGrdIds]
					  )
					     SELECT @MessageId,
						        @MessageTypeName,
								@DisplayText,
								@GrdId,
								@IsDisplay,
								@CompanyId,
								@OperationsPerformedBy,
								GETDATE(),
								@SelectedGrdIds
				 END
				 ELSE
				 BEGIN
				          UPDATE [dbo].[MessageFieldMaster]
						   SET [MessageType] = @MessageTypeName,
						       [DisplayText] = @DisplayText,
							   [GrdId]       = @GrdId,
							   [IsDisplay]   = @IsDisplay,
							   [InActiveDateTime] = CASE WHEN @IsArchived = 0 THEN NULL ELSE GETDATE() END,
							   [UpdatedDateTime] = GETDATE(),
							   [UpdatedByUserId] = @OperationsPerformedBy,
							   [SelectedGrdIds] = @SelectedGrdIds
							WHERE Id = @MessageId AND CompanyId = @CompanyId
				 END
			       SELECT @MessageId
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