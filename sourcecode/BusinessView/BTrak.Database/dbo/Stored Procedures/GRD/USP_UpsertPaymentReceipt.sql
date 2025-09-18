CREATE PROCEDURE [dbo].[USP_UpsertPaymentReceipt]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@EntryDate DATETIME = NULL,
	@Month DATETIME = NULL,
	@Year DATETIME = NULL,
	@Term NVARCHAR(20) = NULL,
	@SiteId UNIQUEIDENTIFIER,
	@BankReceiptDate DATETIME = NULL,
	@BankReference [nvarchar](250) = NULL,
	@CreditNoteIds [nvarchar](250),
	@EntryFormIds [nvarchar](250),
	@BankId UNIQUEIDENTIFIER,
	@Comments [nvarchar](250) = NULL,
	@PayValue DECIMAL(18,2) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL
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

			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @PaymentReceiptIdCount INT = (SELECT COUNT(1) FROM [PaymentReceipt] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @PaymentReceiptCount INT = (SELECT COUNT(1) FROM [PaymentReceipt] WHERE [BankReference] = @BankReference AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@PaymentReceiptIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'PaymentReceipt')
			END
          
			ELSE IF(@PaymentReceiptCount > 0 AND @IsArchived=0)
			BEGIN
				RAISERROR(50001,16,1,'PaymentReceipt')
			END
			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[PaymentReceipt] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)


				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [dbo].[PaymentReceipt]
													(
														[Id],
														[EntryDate],
														[Month],
														[Year],
														[Term],
														SiteId,
														[BankReceiptDate],
														[BankReference],
														[BankId],
														[Comments],
														[PayValue],
														CompanyId,
														CreatedByUserId,
														CreatedDateTime
														)
											SELECT @Id,
												   @EntryDate,
												   @Month,
												   @Year,
												   @Term,
												   @SiteId,
												   @BankReceiptDate,
												   @BankReference,
												   @BankId,
												   @Comments,
												   @PayValue,
												   @CompanyId,
												   @OperationsPerformedBy,
												   GETDATE()

					IF(@CreditNoteIds!='')
					BEGIN
						INSERT INTO [PaymentReceiptCreditNotes]
						(Id
						,PaymentReceiptId
						,CreditNoteId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@Id
							   ,Id
							   ,@OperationsPerformedBy
							   ,GETDATE()
							FROM dbo.UfnSplit(@CreditNoteIds)
					END
					IF(@EntryFormIds!='')
					BEGIN
						
						INSERT INTO [PaymentReceiptEntryForms]
						(Id
						,PaymentReceiptId
						,EntryFormId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@Id
							   ,Id
							   ,@OperationsPerformedBy
							   ,GETDATE()
							FROM dbo.UfnSplit(@EntryFormIds)
					END

					END
					ELSE
					BEGIN

						UPDATE [dbo].[PaymentReceipt]
							SET	[EntryDate]				=	@EntryDate,
								[Month]					=	@Month,
								[Year]					=	@Year,
								[Term]					=	@Term,
								SiteId					=	@SiteId,
								[BankReceiptDate]		=	@BankReceiptDate,
								[BankReference]			=	@BankReference,
								[BankId]				=	@BankId,
								[Comments]				=	@Comments,
								[PayValue]				=	@PayValue,
								UpdatedByUserId = @OperationsPerformedBy,
								UpdatedDateTime = GETDATE(),
								InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
						WHERE Id = @Id

						DECLARE @CreditNoteIdsList TABLE
					            (
					               CreditNoteId UNIQUEIDENTIFIER
					            )

						DECLARE @EntryFormIdsList TABLE
					            (
					               EntryFormId UNIQUEIDENTIFIER
					            )
                          
					IF(@CreditNoteIds!='')
					BEGIN
							INSERT INTO @CreditNoteIdsList(CreditNoteId)
							SELECT Id FROM dbo.UfnSplit(@CreditNoteIds)
					END
					IF(@EntryFormIds!='')
					BEGIN
							INSERT INTO @EntryFormIdsList(EntryFormId)
							SELECT Id FROM dbo.UfnSplit(@EntryFormIds)
					END

					UPDATE [PaymentReceiptCreditNotes] SET InactiveDateTime = GETDATE()
					                               ,[UpdatedDateTime] = GETDATE()
					           				       ,[UpdatedByUserId] = @OperationsPerformedBy
					WHERE PaymentReceiptId = @Id

					INSERT INTO [PaymentReceiptCreditNotes]
						(Id
						,PaymentReceiptId
						,CreditNoteId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@Id							 
							   ,CreditNoteId
							   ,@OperationsPerformedBy
							   ,GETDATE()
						FROM @CreditNoteIdsList AL 


						UPDATE [PaymentReceiptEntryForms] SET InactiveDateTime = GETDATE()
					                               ,[UpdatedDateTime] = GETDATE()
					           				       ,[UpdatedByUserId] = @OperationsPerformedBy
					WHERE PaymentReceiptId = @Id

					INSERT INTO [PaymentReceiptEntryForms]
						(Id
						,PaymentReceiptId
						,EntryFormId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@Id							 
							   ,EntryFormId
							   ,@OperationsPerformedBy
							   ,GETDATE()
						FROM @EntryFormIdsList EF
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