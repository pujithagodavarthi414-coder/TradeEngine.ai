CREATE PROCEDURE [dbo].[USP_UpsertCRMPayment]
(
	@PaymentId uniqueidentifier =  NULL,
	@ReceiverId uniqueidentifier,
	@PaymentType nvarchar(50),
	@AmountDue int,
	@AmountPaid int,
	@ChequeNumber nvarchar(250),
	@BankName nvarchar(250),
	@BenificiaryName nvarchar(250),
	@PaidBy nvarchar(250),
	@OperationsPerformedBy uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON
       
       	BEGIN TRY
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @PaymentTypeId UNIQUEIDENTIFIER 

			SELECT @PaymentTypeId = Id FROM CRMPaymentType WHERE Code = @PaymentType

			IF(@PaymentId IS NOT NULL)
			BEGIN
				UPDATE CRMPaymentLog SET ReceiverId = @ReceiverId,
					PaymentType = @PaymentTypeId,
					AmountDue = @AmountDue,
					AmountPaid = @AmountPaid,
					ChequeNumber = @ChequeNumber,
					BankName = @BankName,
					BenificiaryName = @BenificiaryName,
					PaidBy = @PaidBy,
					UpdatedByUserId = @OperationsPerformedBy,
					UpdatedDateTime = GETDATE()
				WHERE Id = @PaymentId
			END
			ELSE
			BEGIN
				SET @PaymentId = NEWID();
				INSERT INTO CRMPaymentLog (Id, ReceiverId, PaymentType, AmountDue,AmountPaid, ChequeNumber, BankName, BenificiaryName, PaidBy, CreatedByUserId, CreatedDateTime)
				SELECT @PaymentId, @ReceiverId, @PaymentTypeId, @AmountDue, @AmountPaid, @ChequeNumber, @BankName, @BenificiaryName, @PaidBy, @OperationsPerformedBy, GETDATE()

			END

			SELECT ID FROM CRMPaymentLog WHERE ID = @PaymentId
			
		END TRY  
		BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

		END CATCH
END