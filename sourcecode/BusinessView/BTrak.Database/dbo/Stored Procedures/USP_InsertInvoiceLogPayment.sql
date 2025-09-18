----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-16 00:00:00.000'
-- Purpose      To Insert Invoice Payment Log
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_InsertInvoiceLogPayment] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceId = '2857B4FC-9010-49DB-8F6F-167EBDCC1E52'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertInvoiceLogPayment]
(	
	@InvoiceId UNIQUEIDENTIFIER = NULL,
	@PaidAccountToId UNIQUEIDENTIFIER = NULL,
	@PaymentMethodId UNIQUEIDENTIFIER = NULL,
	@AmountPaid FLOAT = NULL,
	@Date DATETIME = NULL,
	@ReferenceNumber NVARCHAR(50) = NULL,
	@Notes NVARCHAR(800) = NULL,
	@SendReceiptTo BIT = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
       BEGIN TRY
          
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')			 
            BEGIN

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@InvoiceId = '00000000-0000-0000-0000-000000000000') SET @InvoiceId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@ReferenceNumber = '') SET @ReferenceNumber = NULL
			
			IF (@Notes = '') SET @Notes = NULL

			IF (@Date IS NULL) SET @Date = GETDATE()

			IF (@SendReceiptTo IS NULL) SET @SendReceiptTo = 0

			DECLARE @InvoicePaidStatusId UNIQUEIDENTIFIER = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Paid' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
			
			DECLARE @InvoicePartialStatusId UNIQUEIDENTIFIER = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Partial' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
		    
		    DECLARE @ReferenceNumberCount INT = (SELECT COUNT(1) FROM InvoicePaymentLog WHERE ReferenceNumber = @ReferenceNumber AND ReferenceNumber IS NOT NULL)

			IF(@InvoiceId IS NULL)
		    BEGIN
		    
		    	RAISERROR(50011,16,1,'InvoiceId')
		    
		    END
			ELSE IF(@ReferenceNumberCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'ReferenceNumber',@ReferenceNumberCount)
		    
		    END
			ELSE
			BEGIN

				DECLARE @Currentdate DATETIME = GETDATE()
			        
			    DECLARE @NewInvoicePaymentLogId UNIQUEIDENTIFIER = NEWID()

				INSERT INTO [dbo].[InvoicePaymentLog](
							[Id],
							[InvoiceId],
							[PaidToAccountId],
							[AmountPaid],
							[PaidDate],
							[PaymentMethodId],
							[ReferenceNumber],
							[Notes],
							[SendReceiptTo],
							[CreatedDateTime],
							[CreatedByUserId]
							)
				SELECT @NewInvoicePaymentLogId,
					   @InvoiceId,
					   @PaidAccountToId,
					   @AmountPaid,
					   @Date,
					   @PaymentMethodId,
					   @ReferenceNumber,
					   @Notes,
					   @SendReceiptTo,
					   @Currentdate,
					   @OperationsPerformedBy

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				     SELECT NEWID(), @InvoiceId, NULL, @AmountPaid, 'InvoiceAmountAdded', @Currentdate, @OperationsPerformedBy

				DECLARE @TotalPaidAmount FLOAT = ISNULL((SELECT SUM(IPL1.AmountPaid) FROM InvoicePaymentLog IPL1 
						INNER JOIN Invoice_New INV1 ON INV1.Id = IPL1.InvoiceId AND INV1.CompanyId = @CompanyId AND INV1.Id = @InvoiceId
						GROUP BY InvoiceId),0)

				DECLARE @TotalAmount FLOAT = (SELECT ISNULL(TotalAmount,0) FROM Invoice_New WHERE Id = @InvoiceId)

				IF (@TotalPaidAmount < @TotalAmount)
				BEGIN

					UPDATE Invoice_New SET InvoiceStatusId = @InvoicePartialStatusId, 
										   UpdatedDateTime = GETDATE(),
										   UpdatedByUserId = @OperationsPerformedBy WHERE Id = @InvoiceId

				END
				ELSE IF (@TotalPaidAmount = @TotalAmount)
				BEGIN

					UPDATE Invoice_New SET InvoiceStatusId = @InvoicePaidStatusId,
										   UpdatedDateTime = GETDATE(),
										   UpdatedByUserId = @OperationsPerformedBy WHERE Id = @InvoiceId

				END

				SELECT Id FROM [dbo].[InvoicePaymentLog] WHERE Id = @NewInvoicePaymentLogId

			END

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
GO
