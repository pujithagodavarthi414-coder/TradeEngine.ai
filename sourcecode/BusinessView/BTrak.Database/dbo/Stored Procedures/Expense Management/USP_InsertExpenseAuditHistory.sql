CREATE PROCEDURE [dbo].[USP_InsertExpenseAuditHistory]
(
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @ExpenseName NVARCHAR(800) = NULL,
  @ExpenseDate DATETIME = NULL,
  @ExpensesXmlModel xml,
  @MerchantId UNIQUEIDENTIFIER = NULL ,
  @ExpenseStatusId UNIQUEIDENTIFIER = NULL ,
  @ExpenseCategoryId UNIQUEIDENTIFIER = NULL ,
  @CurrencyId UNIQUEIDENTIFIER = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @Amount FLOAT = NULL,
  @ReportId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @DueDate DATETIME = NULL,
  @Description NVARCHAR(MAX) = NULL,
  @ClaimedByUserId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')			 
			BEGIN

	        DECLARE @OldExpenseName NVARCHAR(800) = NULL

            DECLARE @OldExpenseDate DATETIME = NULL

            DECLARE @OldMerchantId UNIQUEIDENTIFIER = NULL

            DECLARE @OldClaimedByUserId UNIQUEIDENTIFIER = NULL
			
            DECLARE @OldExpenseCategoryId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldCurrencyId UNIQUEIDENTIFIER = NULL
		    
			DECLARE @OldExpenseStatusId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldAmount FLOAT = NULL

		    DECLARE	@OldReportId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldProjectId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldDueDate DATETIME = NULL

		    DECLARE @OldDescription NVARCHAR(MAX) = NULL

		    DECLARE @OldBranchId UNIQUEIDENTIFIER = NULL

		    SELECT @OldExpenseName = ExpenseName,@OldExpenseDate = ExpenseDate,@OldMerchantId = MerchantId,@OldClaimedByUserId = ClaimedByUserId,
			@OldExpenseCategoryId = ECC.ExpenseCategoryId, @OldCurrencyId = CurrencyId ,@OldAmount = ECC.Amount,
			@OldReportId = ExpenseReportId,@OldDescription = ECC.[Description],@OldExpenseStatusId = ExpenseStatusId,@OldBranchId = E.BranchId
			FROM Expense E INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id AND E.InActiveDateTime IS NULL AND ECC.InActiveDateTime IS NULL WHERE E.Id = @ExpenseId
		    
		    DECLARE @ExpenseHistoryId UNIQUEIDENTIFIER = NEWID()

		    DECLARE @Currentdate DATETIME = GETDATE()

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
	        DECLARE @OldValue NVARCHAR(500)

		    DECLARE @NewValue NVARCHAR(500)

		    DECLARE @FieldName NVARCHAR(200)

		    DECLARE @HistoryDescription NVARCHAR(800)
		    
			IF(@OldExpenseName <> @ExpenseName)
		    BEGIN
		       
		        SET @OldValue = @OldExpenseName

		        SET @NewValue = @ExpenseName

		        SET @FieldName = 'ExpenseName'	

		        SET @HistoryDescription = 'ExpenseNameChange'
		        
		        EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END

			IF(@OldExpenseDate <> @ExpenseDate OR (@OldExpenseDate IS NULL AND @ExpenseDate IS NOT NULL))
		    BEGIN
		       
		        SET @OldValue = ISNULL(CONVERT(NVARCHAR(500), FORMAT(@OldExpenseDate,'dd/MM/yyyy')),'null')
		        SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@ExpenseDate,'dd/MM/yyyy'))
		        SET @FieldName = 'ExpenseDate'	
		        SET @HistoryDescription = 'ExpenseDateChanged'
		        
		        EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END

		    IF(@OldMerchantId <> @MerchantId OR (@OldMerchantId IS NULL AND @MerchantId IS NOT NULL))
		    BEGIN
		       
		        SET @OldValue = (SELECT MerchantName FROM Merchant WHERE Id = @OldMerchantId AND InActiveDateTime IS NULL)
		        SET @NewValue = (SELECT MerchantName FROM Merchant WHERE Id = @MerchantId AND InActiveDateTime IS NULL)
				SET @FieldName = 'MerchantName'	
		        SET @HistoryDescription = 'MerchantNameChanged'
		        
		       EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		       @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END
			 
		    IF(@OldCurrencyId <> @CurrencyId OR (@OldCurrencyId IS NULL AND @OldCurrencyId IS NOT NULL))
		    BEGIN
		       
		         SET @OldValue = (SELECT CurrencyName FROM Currency WHERE Id = @OldCurrencyId AND InActiveDateTime IS NULL)
		         SET @NewValue = (SELECT CurrencyName FROM Currency WHERE Id = @CurrencyId AND InActiveDateTime IS NULL) 
				 SET @FieldName = 'CurrencyName'	
		         SET @HistoryDescription = 'CurrencyNameChanged'
		         
		        EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END
			
			IF(@OldExpenseStatusId <> @ExpenseStatusId OR (@OldExpenseStatusId IS NULL AND @ExpenseStatusId IS NOT NULL))
		    BEGIN
		       
		        SET @OldValue = (SELECT [Name] FROM ExpenseStatus WHERE Id = @OldExpenseStatusId)
		        SET @NewValue = (SELECT [Name] FROM ExpenseStatus WHERE Id = @ExpenseStatusId) 
		        SET @FieldName = 'ExpenseStatus'	
		        SET @HistoryDescription = 'ExpenseStatusChanged'		
		        
		        EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END

			IF(@OldClaimedByUserId <> @ClaimedByUserId OR (@OldClaimedByUserId IS NULL AND @ClaimedByUserId IS NOT NULL))
		    BEGIN
		       
		        SET @OldValue = (SELECT FirstName FROM [User] WHERE Id = @OldClaimedByUserId AND InActiveDateTime IS NULL)
		        SET @NewValue = (SELECT FirstName FROM [User] WHERE Id = @ClaimedByUserId AND InActiveDateTime IS NULL)
				SET @FieldName = 'ClaimedByUser'	
		        SET @HistoryDescription = 'ClaimedByUserChanged'
		        
		       EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		       @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
			END
			
			IF(@OldBranchId <> @BranchId)
		    BEGIN
		       
		         SET @OldValue = (SELECT BranchName FROM Branch WHERE Id = @OldBranchId AND InActiveDateTime IS NULL)
		         SET @NewValue = (SELECT BranchName FROM Branch WHERE Id = @BranchId AND InActiveDateTime IS NULL) 
				 SET @FieldName = 'BranchName'	
		         SET @HistoryDescription = 'BranchNameChanged'
		         
		        EXEC USP_InsertExpenseHistory @ExpenseId = @ExpenseId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
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

			INSERT INTO @ExpenseDetails([ExpenseId],ExpenseCategoryConfigurationId,[Description],[ExpenseCategoryId],[Amount],ExpenseCategoryName,MerchantId)
				SELECT @ExpenseId
					   ,x.y.value('(ExpenseCategoryConfigurationId/text())[1]','UNIQUEIDENTIFIER')
					   ,(LTRIM(RTRIM(x.y.value('Description[1]', 'NVARCHAR(800)'))))
					   ,x.y.value('(ExpenseCategoryId/text())[1]', 'UNIQUEIDENTIFIER')
					   ,x.y.value('Amount[1]', 'FLOAT')
					   ,x.y.value('ExpenseCategoryName[1]', 'NVARCHAR(800)')
					   ,x.y.value('(MerchantId/text())[1]', 'UNIQUEIDENTIFIER')
				FROM @ExpensesXmlModel.nodes('GenericListOfExpenseCategoryConfigurationModel/*/ExpenseCategoryConfigurationModel') AS x(y)
				 
			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.Id,
					'RemovedExpenseCategory',
					'ExpenseCategoryRemoved',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM [ExpenseCategoryConfiguration] ECC
					LEFT JOIN @ExpenseDetails ED ON ECC.Id = ED.ExpenseCategoryConfigurationId 
					WHERE ED.ExpenseCategoryConfigurationId IS NULL AND ECC.InActiveDateTime IS NULL 
					AND ECC.ExpenseId = @ExpenseId
			
			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ED.ExpenseCategoryId,
					'NewExpenseCategory',
					'ExpenseCategoryAdded',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					LEFT JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id 
					WHERE ECC.Id IS NULL AND ECC.InActiveDateTime IS NULL
						
			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.Amount,
					ED.Amount,
					'Amount',
					'AmountChanged',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					WHERE ECC.Amount <> ED.Amount

			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.ExpenseCategoryName,
					ED.ExpenseCategoryName,
					'ExpenseCategoryName',
					'ExpenseCategoryNameChanged',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					WHERE ECC.ExpenseCategoryName <> ED.ExpenseCategoryName

			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            OM.MerchantName,
					NM.MerchantName,
					'MerchantName',
					'MerchantNameChanged',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					INNER JOIN Merchant OM ON OM.Id = ECC.MerchantId
					INNER JOIN Merchant NM ON NM.Id = ED.MerchantId
					WHERE ECC.MerchantId <> ED.MerchantId

			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.[Description],
					ED.[Description],
					'DescriptionRemoved',
					'DescriptionRemoved',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					WHERE (ED.[Description] IS NULL OR ED.[Description] = '') AND (ECC.[Description] <> ED.[Description])  
					AND ECC.Description IS NOT NULL

			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.[Description],
					ED.[Description],
					'DescriptionAdded',
					'DescriptionAdded',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					WHERE (ECC.[Description] IS NULL OR ECC.[Description] = '') AND (ECC.[Description] <> ED.[Description])  
					AND (ED.[Description] IS NOT NULL OR ED.[Description] <> '') 
			
			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            ECC.[Description],
					ED.[Description],
					'Description',
					'DescriptionChanged',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					WHERE (ISNULL(ECC.Description,'') <> '' AND ISNULL(ED.Description,'') <> '')
					     AND (ECC.Description <>  ED.Description)
			
			INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT NEWID(),
		            @ExpenseId,
		            OEC.CategoryName,
					NEC.CategoryName,
					'Category',
					'CategoryChanged',
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy
					FROM @ExpenseDetails ED
					INNER JOIN [ExpenseCategoryConfiguration] ECC ON ED.ExpenseCategoryConfigurationId = ECC.Id
					INNER JOIN ExpenseCategory OEC ON OEC.Id = ECC.ExpenseCategoryId
					INNER JOIN ExpenseCategory NEC ON NEC.Id = ED.ExpenseCategoryId
					WHERE ECC.ExpenseCategoryId <> ED.ExpenseCategoryId

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