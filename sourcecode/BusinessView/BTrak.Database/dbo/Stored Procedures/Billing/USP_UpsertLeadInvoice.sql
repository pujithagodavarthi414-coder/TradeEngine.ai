CREATE PROCEDURE [dbo].[USP_UpsertLeadInvoice]
(
	@LeadId UNIQUEIDENTIFIER NULL,
    @PaidAmount Decimal(18,2) = NULL,
    @InvoiceNumber NVARCHAR(250)= NULL,
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

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @Id UNIQUEIDENTIFIER
			DECLARE @PaymentId UNIQUEIDENTIFIER=NEWID()
			DECLARE @TotalAmount Float
			DECLARE @PendingAmount Float
			DECLARE @CurrentDate DATETIME = GETDATE()
			DECLARE @ClientId UNIQUEIDENTIFIER = (SELECT ClientId From LeadContactSubmissions WHERE Id = @LeadId)
			DECLARE @OldCreditLimt Decimal(18,2) = (SELECT CreditLimit FROM Client WHERE Id=@ClientId)
			DECLARE @OldAvailableCreditLimit Decimal(18,2) = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)


			IF(EXISTS(SELECT Id FROM LeadInvoices WHERE LeadId = @LeadId))
			BEGIN
				SET @Id = (SELECT Id FROM LeadInvoices WHERE LeadId = @LeadId)
				SET @TotalAmount = (SELECT TotalAmount FROM LeadInvoices WHERE LeadId = @LeadId)
				SET @PendingAmount = (SELECT PaidAmount FROM LeadInvoices WHERE LeadId = @LeadId)
				DECLARE @LimitAmount Float = (SELECT PaidAmount+@PaidAmount FROM LeadInvoices WHERE LeadId = @LeadId)
					IF(@TotalAmount>=@LimitAmount)
					  BEGIN
								UPDATE LeadInvoices SET PaidAmount=@PaidAmount+PaidAmount,
										InvoiceNumber=@InvoiceNumber,
										UpdatedDateTime=@CurrentDate,
										UpdatedByUserId=@OperationsPerformedBy
										WHERE LeadId=@LeadId
									INSERT INTO LeadPayments(Id,
											[InvoiceId],
											[PaidAmount],
											[PendingAmount],
											CreatedDateTime,
											CreatedByUserId)
									SELECT @PaymentId,
										   @Id,
										   @PaidAmount,
										   @TotalAmount-@PendingAmount-@PaidAmount,
										   @CurrentDate,
										   @OperationsPerformedBy

								UPDATE Client SET AvailableCreditLimit = AvailableCreditLimit + @PaidAmount WHERE Id = @ClientId


								 INSERT INTO ClientCreditLimitHistory(
													  Id,
													  ClientId,
													  [Description],
													  OldCreditLimit,
													  NewCreditLimit,
													  OldAvailableCreditLimit,
													  NewAvailableCreditLimit,
                                                      Amount,
                                                      CreatedByUserId,
                                                      CreatedDateTime,
													  CompanyId
													 )
											  SELECT  NEWID(),
                                                      @ClientId,
                                                      'Credit-Invoice Added',
                                                      @OldCreditLimt,
                                                      (SELECT CreditLimit FROM Client WHERE Id=@ClientId),
                                                      @OldAvailableCreditLimit,
                                                      (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId),
                                                      @PaidAmount,
                                                      @OperationsPerformedBy,
													  GETDATE(),
													  @CompanyId
						END
						ELSE
						BEGIN
							RAISERROR ('ClientCreditLimitExceeded',11, 1)
						END
			END
			ELSE
			BEGIN
					  SET @Id = NEWID()
					  SET @TotalAmount = (SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id = @LeadId)
					  UPDATE Client SET AvailableCreditLimit = AvailableCreditLimit + @PaidAmount WHERE Id = (SELECT ClientId From LeadContactSubmissions WHERE Id = @LeadId)
					  INSERT INTO LeadInvoices(Id,
							    			[LeadId],
											[InvoiceNumber],
											[PaidAmount],
											[TotalAmount],
							    			CreatedDateTime,
							    			CreatedByUserId
							    		   )
							    	SELECT  @Id,
											@LeadId,
											@InvoiceNumber,
											@PaidAmount,
											@TotalAmount,
							    			@CurrentDate,
							    			@OperationsPerformedBy

						INSERT INTO LeadPayments(Id,
											[InvoiceId],
											[PaidAmount],
											[PendingAmount],
											CreatedDateTime,
											CreatedByUserId)
									SELECT @PaymentId,
										   @Id,
										   @PaidAmount,
										   @TotalAmount-@PaidAmount,
										   @CurrentDate,
										   @OperationsPerformedBy

										   UPDATE LeadContactSubmissions SET StatusId=(SELECT Id FROM LeadStages WHERE CompanyId = @CompanyId AND [Name]='Invoiced') WHERE Id=@LeadId

					    INSERT INTO ClientCreditLimitHistory(
					    									  Id,
					    									  ClientId,
					    									  [Description],
					    									  OldCreditLimit,
					    									  NewCreditLimit,
					    									  OldAvailableCreditLimit,
					    									  NewAvailableCreditLimit,
					                                          Amount,
					                                          CreatedByUserId,
					                                          CreatedDateTime,
															  CompanyId
					    									 )
					    							  SELECT  NEWID(),
					                                          @ClientId,
					                                          'Credit-Invoice Added',
					                                          @OldCreditLimt,
					                                          (SELECT CreditLimit FROM Client WHERE Id=@ClientId),
					                                          @OldAvailableCreditLimit,
					                                          (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId),
					                                          @PaidAmount,
					                                          @OperationsPerformedBy,
					    									  GETDATE(),
															  @CompanyId
				END
						SELECT  @PaymentId
				END
		
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO