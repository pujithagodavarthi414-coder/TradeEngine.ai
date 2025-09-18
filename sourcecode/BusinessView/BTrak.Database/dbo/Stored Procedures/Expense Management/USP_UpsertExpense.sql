--EXEC USP_UpsertExpense 
--@PaymentStatusId = '86A5DAE0-3CE6-4E72-A493-3AB6CB8AEB87',@CurrencyId = '75BD7894-A953-4360-B1AF-022263DD1185',
--@ClaimReimbursement = 0,@OperationsPerformedBy = 'AD6EC5B8-09E5-4C0E-B52A-4BCC6142D058',@ExpenseName='1',
--@ExpensesXmlModel='<GenericListOfExpenseCategoryConfigurationModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--	<ListItems>
--		<ExpenseCategoryConfigurationModel>
--			<ExpenseId xsi:nil="true" />
--			<Description>1-1</Description>
--			<Amount>11</Amount>
--			<ExpenseCategoryId>869f36e7-d912-4b25-b927-c9b1f9c72858</ExpenseCategoryId>
--		</ExpenseCategoryConfigurationModel>
--	</ListItems>
--</GenericListOfExpenseCategoryConfigurationModel>'

CREATE PROCEDURE [dbo].[USP_UpsertExpense]
(
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @ExpenseName NVARCHAR (800),
  @ExpensesXmlModel xml,
  @PaymentStatusId UNIQUEIDENTIFIER = NULL,
  @CurrencyId UNIQUEIDENTIFIER,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @CashPaidThroughId UNIQUEIDENTIFIER = NULL,
  @ExpenseReportId UNIQUEIDENTIFIER = NULL,
  @ExpenseStatusId UNIQUEIDENTIFIER = NULL,
  @BillReceiptId UNIQUEIDENTIFIER = NULL,
  @ClaimReimbursement BIT,
  @MerchantId UNIQUEIDENTIFIER = NULL,
  @ReceiptDate DATETIME = NULL,
  @ExpenseDate DATETIME = NULL,
  @RepliedByUserId UNIQUEIDENTIFIER = NULL,
  @RepliedDateTime DATETIME = NULL,
  @Reason NVARCHAR (800) = NULL,
  @IsApproved BIT = NULL,
  @IsArchived BIT = NULL,
  @ActualBudget DECIMAL (10,2) = NULL,
  @ReferenceNumber NVARCHAR (1000) = NULL,
  @ClaimedByUserId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS 
BEGIN    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
			BEGIN
				  DECLARE @IsLatest BIT = (CASE WHEN @ExpenseId IS NULL THEN 1 ELSE 
			              CASE WHEN (SELECT [TimeStamp] FROM [Expense] 
			                          WHERE Id = @ExpenseId AND InActiveDateTime IS NULL) = @TimeStamp
			                          THEN 1 ELSE 0 END END)
									   		
				  IF(@IsLatest = 1)
				  BEGIN

			IF(@BranchId IS NULL)
				BEGIN
         
					RAISERROR(50011,16, 2, 'BranchName')
				   
				END
			ELSE
				BEGIN
			      DECLARE @Currentdate DATETIME = GETDATE()
		          
                  DECLARE @OriginalId UNIQUEIDENTIFIER 
	              
                  DECLARE @VersionNumber INT 
				  
				  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     	          
	              SELECT @OriginalId = Id FROM Expense WHERE Id = @ExpenseId AND InActiveDateTime IS NULL

				  DECLARE @ExpenseNameCount INT = (SELECT COUNT(1) FROM Expense WHERE ExpenseName = @ExpenseName AND CompanyId = @CompanyId AND (@ExpenseId IS NULL OR Id <> @ExpenseId))       

				  IF(@PaymentStatusId IS NULL)
				  BEGIN

				     SET @PaymentStatusId = (SELECT TOP(1) Id FROM PaymentStatus WHERE [IsDefault] = 1 AND InActiveDateTime IS NULL )

				  END

				  IF(@ExpenseStatusId IS NULL)
				  BEGIN

				     SET @ExpenseStatusId = (SELECT TOP(1) Id FROM ExpenseStatus WHERE IsPending = 1 AND InActiveDateTime IS NULL )

				  END

				  IF(@IsArchived IS NULL)
				  BEGIN

				     SET @IsArchived = 0

				  END
					
					DECLARE @ExpenseDetails TABLE
					(
						ExpenseCategoryConfigurationId UNIQUEIDENTIFIER,
						ExpenseId UNIQUEIDENTIFIER,
						Description NVARCHAR(800),
						ExpenseCategoryId UNIQUEIDENTIFIER,
						Amount FLOAT,
						MerchantId UNIQUEIDENTIFIER,
						ExpenseCategoryName NVARCHAR(800)
					) 

				  IF(@ExpenseId IS NULL)
					BEGIN
					SET @ExpenseId = NEWID()
					DECLARE @MaxExpenseNumber INT = (SELECT MAX(ExpenseNumber) FROM Expense WHERE CompanyId = @CompanyId)

					IF(@MaxExpenseNumber IS NULL OR @MaxExpenseNumber = 0)
					BEGIN
						SET @MaxExpenseNumber = 1
					END
					ELSE
					BEGIN
						SET @MaxExpenseNumber = @MaxExpenseNumber + 1
					END

					INSERT INTO [dbo].[Expense](
			        		     [Id],
								 [ExpenseName],
			        			 [PaymentStatusId],
			        			 [ClaimedByUserId],
			        			 [CurrencyId],
								 [BranchId],
								 [CashPaidThroughId],
			        			 [ExpenseReportId],
								 [ExpenseStatusId],
			        			 [BillReceiptId],
			        			 [ClaimReimbursement],
			        			 [ReceiptDate],
			        			 [ExpenseDate],
			        			 [PaidStatusSetByUserId],
			        			 [RepliedDateTime],
			        			 [Reason],
			        			 [IsApproved],
			        			 [ActualBudget],
			        			 [ReferenceNumber],
								 [CompanyId],
								 [CreatedByUserId],
								 [CreatedDateTime],
								 [InActiveDateTime],
								 [ExpenseNumber])
                          SELECT @ExpenseId,
								 @ExpenseName,
			        			 @PaymentStatusId,
			        			 CASE WHEN @ClaimedByUserId IS NULL THEN @OperationsPerformedBy ELSE @ClaimedByUserId END,
								 @CurrencyId,
								 @BranchId,
			        			 @CashPaidThroughId,
			        			 @ExpenseReportId,
			        			 CASE WHEN @IsApproved IS NULL THEN '29B80753-BF1A-4FA1-AB65-D5788A3A0F4D' ELSE (CASE WHEN @IsApproved = 1 THEN 'A29CC333-5C29-4DDD-9CE3-7BD608D5AB77' ELSE '2F8A8DDD-A8F4-486C-81BA-7DD061DCE1C4' END)END,
			        			 @BillReceiptId,
			        			 @ClaimReimbursement,
			        			 @ReceiptDate,
	                    	     @ExpenseDate,
	                    	     @RepliedByUserId,
			        			 @RepliedDateTime,
			        			 @Reason,
			        			 @IsApproved,
			        			 @ActualBudget,
			        			 @ReferenceNumber,
								 @CompanyId,
								 @OperationsPerformedBy,
								 @Currentdate,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								 @MaxExpenseNumber

					INSERT INTO ExpenseHistory(
											 Id,
											 ExpenseId,
											 NewValue,
											 FieldName,
											 [Description],
											 CreatedByUserId,
											 CreatedDateTime
											)
										  SELECT  NEWID(),
										          @ExpenseId,
												  @ExpenseName,
										          'ExpenseAdded',
												  'ExpenseAdded',
												  @OperationsPerformedBy,
												  GETDATE()	

				  END
				  ELSE
					BEGIN

						EXEC [USP_InsertExpenseAuditHistory] @ExpenseId = @ExpenseId,@ExpenseName = @ExpenseName,@ExpenseDate = @ExpenseDate,
						@MerchantId = @MerchantId,@ExpenseCategoryId = NULL,@CurrencyId = @CurrencyId,@Amount = NULL,@ExpensesXmlModel=@ExpensesXmlModel,
						@Description = NULL,@OperationsPerformedBy = @OperationsPerformedBy,@BranchId = @BranchId,@ClaimedByUserId = @ClaimedByUserId,@ExpenseStatusId = @ExpenseStatusId
				
						IF(@IsArchived = 0  AND  (@ExpenseStatusId = (SELECT TOP(1) Id FROM ExpenseStatus WHERE IsRejected = 1 AND InActiveDateTime IS NULL)))
						BEGIN
							SET @ExpenseStatusId = (SELECT TOP(1) Id FROM ExpenseStatus WHERE IsPending = 1 AND InActiveDateTime IS NULL )
						END

						UPDATE [dbo].[Expense]
									SET [ExpenseName]		 =	@ExpenseName,
									    [PaymentStatusId]	 =	@PaymentStatusId,
										[ClaimedByUserId]	 =  CASE WHEN @ClaimedByUserId IS NULL THEN @OperationsPerformedBy ELSE @ClaimedByUserId END,
										[CurrencyId]		 =  @CurrencyId,
										[BranchId]			 =  @BranchId,
										[CashPaidThroughId]  =  @CashPaidThroughId,
										[ExpenseReportId]	 =  @ExpenseReportId,
										[ExpenseStatusId]	 =  @ExpenseStatusId,
										[BillReceiptId]		 =  @BillReceiptId,
										[ClaimReimbursement] =  @ClaimReimbursement,
										[ReceiptDate]		 =  @ReceiptDate,
										[ExpenseDate]		 =  @ExpenseDate,
										[PaidStatusSetByUserId]	 =  @RepliedByUserId,
										[RepliedDateTime]	 =  @RepliedDateTime,
										[Reason]			 =  @Reason,
										[IsApproved]		 =  @IsApproved,
										[ActualBudget]		 =  @ActualBudget,
										[ReferenceNumber]	 =  @ReferenceNumber,
									    UpdatedByUserId		 =	@OperationsPerformedBy,
										UpdatedDateTime      =  @Currentdate,
										InActiveDateTime	 =	CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
									WHERE Id = @ExpenseId AND CompanyId = @CompanyId

				  END

				  INSERT INTO @ExpenseDetails([ExpenseId],ExpenseCategoryConfigurationId,[Description],[ExpenseCategoryName],[MerchantId],[ExpenseCategoryId],[Amount])
					SELECT @ExpenseId
						   ,x.y.value('(ExpenseCategoryConfigurationId/text())[1]','UNIQUEIDENTIFIER')
						   ,x.y.value('Description[1]', 'NVARCHAR(800)')
						   ,x.y.value('ExpenseCategoryName[1]', 'NVARCHAR(800)')
						   ,x.y.value('(MerchantId/text())[1]', 'UNIQUEIDENTIFIER')
						   ,x.y.value('(ExpenseCategoryId/text())[1]', 'UNIQUEIDENTIFIER')
						   ,x.y.value('Amount[1]', 'FLOAT')
				   FROM @ExpensesXmlModel.nodes('GenericListOfExpenseCategoryConfigurationModel/*/ExpenseCategoryConfigurationModel') AS x(y)
				 
				  UPDATE [ExpenseCategoryConfiguration] SET InactiveDatetime = @Currentdate 
				   FROM [ExpenseCategoryConfiguration] ECC 
						LEFT JOIN @ExpenseDetails ED ON ECC.Id = ED.ExpenseCategoryConfigurationId 
				   WHERE ED.ExpenseCategoryConfigurationId IS NULL AND ECC.InActiveDateTime IS NULL AND ECC.ExpenseId = @ExpenseId

				  UPDATE [ExpenseCategoryConfiguration] 
						SET [Description]		  =  ED.[Description],
							[ExpenseCategoryId]	  =  ED.ExpenseCategoryId,
							[Amount]			  =  ED.Amount,	
							[ExpenseCategoryName] =  ED.ExpenseCategoryName,
							[MerchantId]		  =  ED.MerchantId,
							[UpdatedByUserId]	  =  @OperationsPerformedBy,
							[UpdatedDateTime]	  =  @Currentdate
						FROM [ExpenseCategoryConfiguration] ECC
					INNER JOIN @ExpenseDetails ED ON ECC.Id = ED.ExpenseCategoryConfigurationId 
					WHERE ED.ExpenseCategoryConfigurationId IS NOT NULL AND ECC.InActiveDateTime IS NULL
					
				  INSERT INTO [dbo].[ExpenseCategoryConfiguration] (
			        		     [Id],
								 [ExpenseId],
			        			 [Description],
								 [ExpenseCategoryId],
			        			 [Amount],
								 [MerchantId],
								 [ExpenseCategoryName],
								 [CreatedByUserId],
								 [CreatedDateTime],
								 [InActiveDateTime])
                          SELECT ISNULL(ED.ExpenseCategoryConfigurationId,NEWID()),
								 ED.ExpenseId,
			        	         ED.Description,
								 ED.ExpenseCategoryId,
			        			 ED.Amount,	
								 ED.MerchantId,
								 ED.ExpenseCategoryName,
								 @OperationsPerformedBy,
								 @Currentdate,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								FROM @ExpenseDetails ED
								WHERE ED.ExpenseCategoryConfigurationId IS NULL OR (ED.ExpenseCategoryConfigurationId IS NOT NULL 
									AND (SELECT Id FROM ExpenseCategoryConfiguration WHERE Id = ED.ExpenseCategoryConfigurationId) IS NULL)
	
		          SELECT Id FROM [dbo].[Expense] WHERE Id = @ExpenseId
				  END
			  END
				  ELSE
				  BEGIN

				      RAISERROR (50008,11, 1)

				  END        		 
			END
		ELSE
			BEGIN
				RAISERROR (@HavePermission,11, 1)
			END
	END TRY  
	BEGIN CATCH 
		
		  EXEC USP_GetErrorInformation

	END CATCH

END
GO