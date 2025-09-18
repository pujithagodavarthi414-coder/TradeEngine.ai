CREATE PROCEDURE [dbo].[USP_UpsertExpenseBooking]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@Type [nvarchar](250),
	@EntryDate DATETIME = NULL,
	@Month DATETIME = NULL,
	@Year DATETIME = NULL,
	@Term NVARCHAR(20) = NULL,
	@SiteId UNIQUEIDENTIFIER,
	@AccountId UNIQUEIDENTIFIER,
	@VendorName [nvarchar](250) = NULL,
	@InvoiceNo [nvarchar](250) = NULL,
	@Description [nvarchar](250) = NULL,
	@InvoiceDate DATETIME = NULL,
	@IsTVAApplied BIT = NULL,
	@Comments [nvarchar](250) = NULL,
	@InvoiceValue DECIMAL(18,2) = NULL,
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
			DECLARE @ExpenseBookingIdCount INT = (SELECT COUNT(1) FROM [ExpenseBooking] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @ExpenseBookingCount INT = (SELECT COUNT(1) FROM [ExpenseBooking] WHERE InvoiceNo = @InvoiceNo AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@ExpenseBookingIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'ExpenseBooking')
			END
          
			ELSE IF(@ExpenseBookingCount > 0 AND @IsArchived=0)
			BEGIN
				RAISERROR(50001,16,1,'ExpenseBooking')
			END
			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[ExpenseBooking] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)


				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [dbo].[ExpenseBooking]
													(
														[Id],
														[Type],
														[EntryDate],
														[Month],
														[Year],
														[Term],
														SiteId,
														[AccountId],
														[VendorName],
														[InvoiceNo],
														[Description],
														[InvoiceDate],
														[IsTVAApplied],
														[TVA],
														[Comments],
														InvoiceValue,
														CompanyId,
														CreatedByUserId,
														CreatedDateTime
														)
											SELECT @Id,
												   @Type,
												   @EntryDate,
												   @Month,
												   @Year,
												   @Term,
												   @SiteId,
												   @AccountId,
												   @VendorName,
												   @InvoiceNo,
												   @Description,
												   @InvoiceDate,
												   @IsTVAApplied,
												   (SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL),
												   @Comments,
												   @InvoiceValue,
												   @CompanyId,
												   @OperationsPerformedBy,
												   GETDATE()

					END
					ELSE
					BEGIN

						UPDATE [dbo].[ExpenseBooking]
							SET [Type]			=	@Type,
								[EntryDate]		=	@EntryDate,
								[Month]			=	@Month,
								[Year]			=	@Year,
								[Term]			=	@Term,
								SiteId			=	@SiteId,
								[AccountId]		=	@AccountId,
								[VendorName]	=	@VendorName,
								[InvoiceNo]		=	@InvoiceNo,
								[Description]	=	@Description,
								[InvoiceDate]	=	@InvoiceDate,
								[IsTVAApplied]	=	@IsTVAApplied,
								[TVA]			=	(SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL),
								[Comments]		=	@Comments,
								InvoiceValue	=	@InvoiceValue,
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