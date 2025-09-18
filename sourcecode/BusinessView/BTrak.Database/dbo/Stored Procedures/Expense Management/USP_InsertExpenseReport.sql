---------------------------------------------------------------------------------
---- Author       Aswani Katam
---- Created      '2019-02-04 00:00:00.000'
---- Purpose      To insert expense report and update the expense with report id
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----EXEC USP_InsertExpenseReport @ExpenseReportId = null,@ReportTitle = 'test title',@BusinessPurpose = 'test business purpose',
----@DurationFrom = '2019-03-04 00:00:00.000',@DurationTo = '2019-03-04 00:00:00.000',@ReportStatusId = 'FC20D699-6B97-4764-8643-033F463F2D40',
----@AdvancePayment = '400',@AmountToBeReimbursed = '2000' , @IsReimbursed= 1,@UndoReimbursement = 0, @ExpensesXmlIds = N',
----<GenericListOfString>
----<ListItems>
----<string>4193D145-DCAF-47FC-B633-9BC5D8B1E114</string>
----</ListItems>
----</GenericListOfString>', 
----@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
---------------------------------------------------------------------------------

--CREATE PROCEDURE [dbo].[USP_InsertExpenseReport]
--(
--  @ExpenseReportId UNIQUEIDENTIFIER = NULL,
--  @ReportTitle NVARCHAR(200),
--  @BusinessPurpose NVARCHAR(500),
--  @DurationFrom DATETIME,
--  @DurationTo DATETIME,
--  @ReportStatusId UNIQUEIDENTIFIER = NULL,
--  @AdvancePayment DECIMAL = NULL,
--  @AmountToBeReimbursed DECIMAL = NULL,
--  @IsReimbursed BIT= NULL ,
--  @UndoReimbursement BIT= NULL,
--  @IsApproved BIT= NULL,
--  @IsArchived BIT = NULL,
--  @ReasonForApprovalOrRejection NVARCHAR(500) = NULL,
--  @ExpensesXmlIds XML = NULL,
--  @OperationsPerformedBy UNIQUEIDENTIFIER,
--  @TimeStamp TIMESTAMP = NULL
--)
--AS 
--BEGIN    
--	SET NOCOUNT ON
--	BEGIN TRY
--    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

--			  DECLARE @IsLatest BIT = (CASE WHEN @ExpenseReportId IS NULL THEN 1 ELSE 
--                       CASE WHEN (SELECT [TimeStamp] FROM [ExpenseReport] 
--                                   WHERE OriginalId = @ExpenseReportId AND AsAtInactiveDateTime IS NULL) = @TimeStamp
--                                   THEN 1 ELSE 0 END END)


--			  IF(@IsLatest = 1)
--			  BEGIN

--			      IF(@IsReimbursed IS NULL) SET @IsReimbursed = 0

--				  IF(@UndoReimbursement IS NULL) SET @UndoReimbursement = 0

--			      DECLARE @Currentdate DATETIME = GETDATE()

--		          DECLARE @NewExpenseReportId UNIQUEIDENTIFIER = NEWID()
		          
--                  DECLARE @OriginalId UNIQUEIDENTIFIER 
	              
--                  DECLARE @VersionNumber INT 
     	          
--	              SELECT @OriginalId = OriginalId, @VersionNumber = VersionNumber  FROM ExpenseReport 
--				  WHERE OriginalId = @ExpenseReportId AND AsAtInActiveDateTime IS NULL
			      
--				  SET @ReportStatusId = (SELECT TOP(1) Id FROM ExpenseReportStatus WHERE [IsDefault] = 1 AND InActiveDateTime IS NULL AND AsAtInActiveDateTime IS NULL)

--		          INSERT INTO [dbo].[ExpenseReport](
--			        		     [Id],
--			        			 [ReportTitle],
--			        			 [BusinessPurpose],
--			        			 [DurationFrom],
--			        			 [DurationTo],
--			        			 [ReportStatusId],
--			        			 [AdvancePayment],
--			        			 [AmountToBeReimbursed],
--			        			 [UndoReimbursement],
--			        			 [IsReimbursed],
--			        			 [IsApproved],	
--			        			 [ReasonForApprovalOrRejection],
--			        			 [CreatedByUserId],
--			        			 [CreatedDateTime],
--			        			 [SubmittedByUserId],
--			        			 [SubmittedDateTime],
--			        			 [ReimbursedByUserId],
--			        			 [ReimbursedDateTime],
--			        			 [ApprovedOrRejectedByUserId],
--			        			 [ApprovedOrRejectedDateTime],
--			        			 [VersionNumber],
--                                 [OriginalId],
--								 InActiveDateTime)
--                          SELECT @NewExpenseReportId,
--			        	         @ReportTitle,	 
--	                    	     @BusinessPurpose,
--			        			 @DurationFrom,
--			        			 @DurationTo,
--			        			 @ReportStatusId,
--			        			 @AdvancePayment,
--			        			 @AmountToBeReimbursed,
--			        			 @UndoReimbursement,
--			        			 @IsReimbursed,
--			        			 @IsApproved,	
--			        			 @ReasonForApprovalOrRejection,
--	                    	     @OperationsPerformedBy,
--			        			 @Currentdate,
--	                    	     @OperationsPerformedBy,
--			        			 @Currentdate,
--			        			 CASE WHEN @IsReimbursed = 1 THEN @OperationsPerformedBy ELSE NULL END,
--			        			 CASE WHEN @IsReimbursed = 1 THEN @Currentdate ELSE NULL END,
--			        			 CASE WHEN (@IsApproved = 1 OR @IsApproved = 0) THEN @OperationsPerformedBy ELSE NULL END,
--			        			 CASE WHEN (@IsApproved = 1 OR @IsApproved = 0) THEN @Currentdate ELSE NULL END,
--			        			 ISNULL(@VersionNumber,0) + 1,
--                                 ISNULL(@OriginalId,@NewExpenseReportId),
--								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		          
--		          UPDATE [ExpenseReport] SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @ExpenseReportId 
--				  AND AsAtInActiveDateTime IS NULL AND Id != @NewExpenseReportId

--				  DECLARE @TempExpense TABLE
--                  (
--                      RowNumber INT IDENTITY(1,1),
--                      ExpenseId UNIQUEIDENTIFIER
--                  )

--				  INSERT INTO @TempExpense (ExpenseId) 
--				  SELECT x.y.value('(text())[1]', 'uniqueidentifier')
--				  FROM @ExpensesXmlIds.nodes('/GenericListOfString/ListItems/string') AS x(y)

--				  DECLARE @ExpenseIdsCount INT =  (SELECT COUNT (1) FROM @TempExpense)

--				  DECLARE @ExpenseId UNIQUEIDENTIFIER
--				  DECLARE @Description NVARCHAR (800)
--				  DECLARE @ExpenseCategoryId UNIQUEIDENTIFIER
--				  DECLARE @PaymentStatusId UNIQUEIDENTIFIER
--				  DECLARE @ClaimedByUserId UNIQUEIDENTIFIER
--				  DECLARE @CurrencyId UNIQUEIDENTIFIER
--				  DECLARE @CashPaidThroughId UNIQUEIDENTIFIER = NULL
--				  DECLARE @ExpenseStatusId UNIQUEIDENTIFIER = NULL
--				  DECLARE @BillReceiptId UNIQUEIDENTIFIER = NULL
--				  DECLARE @ClaimReimbursement BIT
--				  DECLARE @MerchantId UNIQUEIDENTIFIER = NULL
--				  DECLARE @ReceiptDate DATETIME = NULL
--				  DECLARE @ExpenseDate DATETIME = NULL
--				  DECLARE @Amount DECIMAL (18,5)  = NULL
--				  DECLARE @RepliedByUserId UNIQUEIDENTIFIER = NULL
--				  DECLARE @RepliedDateTime DATETIME = NULL
--				  DECLARE @Reason NVARCHAR (800) = NULL
--				  DECLARE @ExpenseIsApproved BIT = NULL
--				  DECLARE @ActualBudget DECIMAL (10,2) = NULL
--				  DECLARE @ReferenceNumber NVARCHAR (1000) = NULL
--				  DECLARE @ExpenseTimeStamp  TIMESTAMP = NULL
			      
--				  WHILE(@ExpenseIdsCount >= 1)
--				  BEGIN
				  
--				    SET @ExpenseId = (SELECT ExpenseId FROM @TempExpense WHERE RowNumber = @ExpenseIdsCount)

--					DECLARE @NewExpenseId UNIQUEIDENTIFIER = NEWID()

--				    SELECT @Description = [Description],
--					       @ExpenseCategoryId = [ExpenseCategoryId],
--					       @PaymentStatusId = [PaymentStatusId],
--					       @ClaimedByUserId = [ClaimedByUserId],
--						   @CurrencyId = [CurrencyId],
--					       @CashPaidThroughId	= [CashPaidThroughId],	
--					       @ExpenseStatusId = [ExpenseStatusId],	
--					       @BillReceiptId	= [BillReceiptId],	
--					       @ClaimReimbursement = [ClaimReimbursement],	
--					       @MerchantId = [MerchantId],	
--					       @ReceiptDate = [ReceiptDate],	
--					       @ExpenseDate = [ExpenseDate],
--					       @Amount = [Amount],	
--					       @RepliedByUserId = [RepliedByUserId],
--					       @RepliedDateTime = [RepliedDateTime],
--					       @Reason = [Reason],	
--					       @ExpenseIsApproved = [IsApproved],	
--					       @ActualBudget = [ActualBudget],	
--					       @ReferenceNumber = [ReferenceNumber],
--						   @ExpenseTimeStamp = [TimeStamp]
--					 FROM Expense WHERE OriginalId = @ExpenseId 
--								  AND AsAtInActiveDateTime IS NULL

--				     EXEC [dbo].[USP_UpsertExpense] @ExpenseId = @ExpenseId,@Description = @Description,@ExpenseCategoryId = @ExpenseCategoryId,
--					 @PaymentStatusId = @PaymentStatusId,@CurrencyId = @CurrencyId,@CashPaidThroughId = @CashPaidThroughId,
--					 @ExpenseReportId = @NewExpenseReportId,@ExpenseStatusId = @ExpenseStatusId,@BillReceiptId = @BillReceiptId,
--					 @ClaimReimbursement = @ClaimReimbursement,@MerchantId = @MerchantId,@ReceiptDate = @ReceiptDate,@ExpenseDate = @ExpenseDate,
--					 @Amount = @Amount,@RepliedByUserId = @RepliedByUserId,@RepliedDateTime = @RepliedDateTime,@Reason = @Reason,
--					 @IsApproved = @ExpenseIsApproved,@ActualBudget = @ActualBudget,@ReferenceNumber = @ReferenceNumber,
--					 @OperationsPerformedBy = @OperationsPerformedBy,@TimeStamp = @ExpenseTimeStamp


--					SET @ExpenseIdsCount =  @ExpenseIdsCount - 1
--				  END

--		          SELECT OriginalId Id FROM [dbo].[ExpenseReport] WHERE Id = @NewExpenseReportId

--			  END
--			  ELSE
--			  BEGIN

--			      RAISERROR (50008,11, 1)

--			  END

--	END TRY  
--	BEGIN CATCH 
		
--		  EXEC USP_GetErrorInformation

--	END CATCH

--END