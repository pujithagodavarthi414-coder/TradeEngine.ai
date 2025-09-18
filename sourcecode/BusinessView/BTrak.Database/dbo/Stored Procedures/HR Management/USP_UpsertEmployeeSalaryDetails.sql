-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-13 00:00:00.000'
-- Purpose      To Save or update the Employee Salary Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertEmployeeSalaryDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393', @CurrencyId = 'df549957-74cc-4622-a094-05f64973f092', @PayFrequencyId = '97f7cc8b-f49e-4fa9-8d31-02b0353242f4',@PayGradeId = '80d56629-2c05-4d16-a25f-f1af9128cbc0',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeSalaryDetails]
(
   @EmployeeSalaryDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @PayGradeId UNIQUEIDENTIFIER = NULL,
   @SalaryComponent NVARCHAR(800) = NULL,
   @PayFrequencyId UNIQUEIDENTIFIER = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL, 
   @Amount DECIMAL(18,5) = NULL,
   @StartDate DATETIME = NULL,
   @EndDate DATETIME = NULL,
   @PaymentMethodId UNIQUEIDENTIFIER = NULL,
   @SalaryParticularsFileId UNIQUEIDENTIFIER = NULL,
   @Comments NVARCHAR(800) = NULL, 
   @IsDirectDeposit BIT = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @NetPayAmount DECIMAL(18,5) = NULL,
   @PayrollTemplateId UNIQUEIDENTIFIER = NULL,
   @NotReturnValue BIT = NULL,
   @TaxCalculationTypeId UNIQUEIDENTIFIER = NULL
   )
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@PayGradeId = '00000000-0000-0000-0000-000000000000') SET @PayGradeId = NULL

		IF(@PayFrequencyId = '00000000-0000-0000-0000-000000000000') SET @PayFrequencyId = NULL

		IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@PayrollTemplateId = '00000000-0000-0000-0000-000000000000' OR @PayrollTemplateId IS NULL)
		BEGIN

			SELECT @PayrollTemplateId = Id FROM PayrollTemplate WHERE PayrollName = 'Template For India' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL

		END

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@PayGradeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'SalaryPayGrade')

		END
		ELSE IF(@PayFrequencyId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PayFrequency')

		END
		ELSE IF(@CurrencyId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Currency')

		END
		ELSE 
		BEGIN
		DECLARE @PayrollConfigId uniqueidentifier;
		DECLARE @EmployeeSalaryDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeSalary WHERE Id = @EmployeeSalaryDetailId )

		DECLARE @EmployeeSalaryDuplicateCount INT = 0

		SET @EmployeeSalaryDuplicateCount = (SELECT COUNT(1) FROM EmployeeSalary WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeSalaryDetailId OR @EmployeeSalaryDetailId IS NULL) AND ActiveTo IS NULL AND InActiveDateTime IS NULL)

		IF(@EndDate IS NULL AND ISNULL(@EmployeeSalaryDuplicateCount,0) = 0)
		BEGIN

			SET @EmployeeSalaryDuplicateCount = (SELECT COUNT(1) FROM EmployeeSalary WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeSalaryDetailId OR @EmployeeSalaryDetailId IS NULL) 
			                                      AND (@StartDate BETWEEN ActiveFrom AND ActiveTo) 
												  AND InActiveDateTime IS NULL)
		
		END
		IF(@EndDate IS NOT NULL AND ISNULL(@EmployeeSalaryDuplicateCount,0) = 0)
		BEGIN

			SET @EmployeeSalaryDuplicateCount = (SELECT COUNT(1) FROM EmployeeSalary WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeSalaryDetailId OR @EmployeeSalaryDetailId IS NULL) 
			                                      AND (@StartDate BETWEEN ActiveFrom AND ActiveTo) 
			                                      AND (@EndDate BETWEEN ActiveFrom AND ActiveTo) 
												  AND InActiveDateTime IS NULL)

		END

				DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeSalaryDetails',11,1)
		END

		ELSE IF(@EmployeeSalaryDetailIdCount = 0 AND @EmployeeSalaryDetailId IS NOT NULL)
		BEGIN
			RAISERROR('EmployeeSalaryDetailsIsAlreadyExistedWithThisDateRange',16, 1)
		END

		ELSE IF(ISNULL(@EmployeeSalaryDuplicateCount,0) > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeSalaryDetailId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeSalary WHERE Id = @EmployeeSalaryDetailId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldPayGradeId UNIQUEIDENTIFIER = NULL
					DECLARE @OldSalaryComponent NVARCHAR(800) = NULL
					DECLARE @OldPayFrequencyId UNIQUEIDENTIFIER = NULL
					DECLARE @OldCurrencyId UNIQUEIDENTIFIER = NULL
					DECLARE @OldAmount DECIMAL(18,5) = NULL
					DECLARE @OldStartDate DATETIME = NULL
					DECLARE @OldEndDate DATETIME = NULL
					DECLARE @OldPaymentMethodId UNIQUEIDENTIFIER = NULL
					DECLARE @OldSalaryParticularsFileId UNIQUEIDENTIFIER = NULL
					DECLARE @OldComments NVARCHAR(800) = NULL
					DECLARE @OldIsDirectDeposit BIT = NULL
					DECLARE @OldNetPayAmount DECIMAL(18,5) = NULL
                    DECLARE @OldPayrollTemplateId UNIQUEIDENTIFIER = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
			        
					SELECT @OldPayGradeId               = [SalaryPayGradeId],
					       @OldSalaryComponent          = [SalaryComponent],
					       @OldPayFrequencyId           = [SalaryPayFrequencyId],
					       @OldCurrencyId               = [CurrencyId],
					       @OldAmount                   = [Amount],
					       @OldComments                 = [Comments],
					       @OldIsDirectDeposit          = [IsAddedDepositDetails],
					       @OldStartDate                = [ActiveFrom],
					       @OldPaymentMethodId          = [PaymentMethodId],
					       @OldSalaryParticularsFileId  = [SalaryParticularsFileId],
					       @OldEndDate                  = [ActiveTo],
					       @OldNetPayAmount             = [NetpayAmount],
						   @Inactive                    = [InactiveDateTime]
						   FROM EmployeeSalary WHERE Id = @EmployeeSalaryDetailId

			      IF(@EmployeeSalaryDetailId IS NULL)
				  BEGIN

				  SET @EmployeeSalaryDetailId = NEWID()
				  
				  BEGIN
			        INSERT INTO [dbo].EmployeeSalary(
			                    [Id],
			                    [EmployeeId],
								[SalaryPayGradeId],
								[SalaryComponent],
								[SalaryPayFrequencyId],
								[CurrencyId],
								[Amount],
								[Comments],
								[IsAddedDepositDetails],
								[ActiveFrom],
								[PaymentMethodId],
								[SalaryParticularsFileId],
								[ActiveTo],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								[NetpayAmount]
								)
			             SELECT @EmployeeSalaryDetailId,
			                    @EmployeeId,
								@PayGradeId,
								@SalaryComponent,
								@PayFrequencyId,
								@CurrencyId, 
								@Amount,
								@Comments,
								@IsDirectDeposit,
								@StartDate,
								@PaymentMethodId,
								@SalaryParticularsFileId,
								@EndDate,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@NetPayAmount
								END

								BEGIN
								INSERT INTO EmployeepayrollConfiguration(Id, EmployeeId, PayrollTemplateId, ActiveFrom, ActiveTo, CreatedByUserId, CreatedDateTime, SalaryId,TaxCalculationTypeId)
                                VALUES(NEWID(), @EmployeeId, @PayrollTemplateId, @StartDate, @EndDate, @UserId, GETDATE(), @EmployeeSalaryDetailId,@TaxCalculationTypeId)
								END
						END
						ELSE
						BEGIN
						BEGIN
						UPDATE  [dbo].EmployeeSalary
			                SET [EmployeeId] = @EmployeeId,
								[SalaryPayGradeId] = @PayGradeId,
								[SalaryComponent] = @SalaryComponent,
								[SalaryPayFrequencyId] = @PayFrequencyId,
								[CurrencyId] = @CurrencyId,
								[Amount] = @Amount,
								[Comments] = @Comments,
								[IsAddedDepositDetails] = @IsDirectDeposit,
								[ActiveFrom] = @StartDate,
								[PaymentMethodId] = @PaymentMethodId,
								[SalaryParticularsFileId] = @SalaryParticularsFileId,
								[ActiveTo] = @EndDate,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy,
								[NetPayAmount] = @NetPayAmount
			                  WHERE Id = @EmployeeSalaryDetailId
						END
						BEGIN
						SET @PayrollConfigId = (SELECT TOP 1 Id FROM EmployeepayrollConfiguration WHERE EmployeeId = @EmployeeId AND SalaryId = @EmployeeSalaryDetailId)
						IF(@PayrollConfigId IS NULL)
						BEGIN
						INSERT INTO EmployeepayrollConfiguration(Id, EmployeeId, PayrollTemplateId, ActiveFrom, ActiveTo, CreatedByUserId, CreatedDateTime, SalaryId,TaxCalculationTypeId
						)
                                VALUES(NEWID(), @EmployeeId, @PayrollTemplateId, @StartDate, @EndDate, @UserId, GETDATE(), @EmployeeSalaryDetailId,@TaxCalculationTypeId)
						END
						ELSE
						BEGIN

						SET @OldPayrollTemplateId = (SELECT PayrollTemplateId  FROM EmployeepayrollConfiguration WHERE Id = @PayrollConfigId)

						UPDATE EmployeepayrollConfiguration SET PayrollTemplateId = @PayrollTemplateId, SalaryId = @EmployeeSalaryDetailId, 
						ActiveFrom = @StartDate, ActiveTo = @EndDate, UpdatedDateTime = GETDATE(), UpdatedByUserId = @UserId,TaxCalculationTypeId = @TaxCalculationTypeId
						WHERE Id = @PayrollConfigId
						END
						
						END
			       END

					DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT SalaryComponent FROM EmployeeSalary WHERE Id = @EmployeeSalaryDetailId)

				    SET @OldValue = (SELECT PayGradeName  FROM PayGrade WHERE Id = @OldPayGradeId)
					SET @NewValue = (SELECT PayGradeName  FROM PayGrade WHERE Id = @PayGradeId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Pay grade',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT PayrollName FROM PayrollTemplate WHERE Id = @OldPayrollTemplateId)
					SET @NewValue = (SELECT PayrollName  FROM PayrollTemplate WHERE Id = @PayrollTemplateId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Pay roll template',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT PayFrequencyName  FROM PayFrequency WHERE Id = @OldPayFrequencyId)
					SET @NewValue = (SELECT PayFrequencyName  FROM PayFrequency WHERE Id = @PayFrequencyId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Pay frequency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT PayFrequencyName  FROM PayFrequency WHERE Id = @OldPayFrequencyId)
					SET @NewValue = (SELECT PayFrequencyName  FROM PayFrequency WHERE Id = @PayFrequencyId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Pay frequency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT CurrencyName  FROM Currency WHERE Id = @OldCurrencyId)
					SET @NewValue = (SELECT CurrencyName  FROM Currency WHERE Id = @CurrencyId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Currency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT PaymentMethodName  FROM PaymentMethod WHERE Id = @OldPaymentMethodId)
					SET @NewValue = (SELECT PaymentMethodName  FROM PaymentMethod WHERE Id = @PaymentMethodId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Payment method',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldSalaryComponent,'') <> @SalaryComponent AND @SalaryComponent IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Salary component',@OldValue = @OldSalaryComponent,@NewValue = @SalaryComponent,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldComments,'') <> @Comments AND @Comments IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Comments',@OldValue = @OldComments,@NewValue = @Comments,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldStartDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@StartDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Start date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldEndDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@EndDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'End date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldAmount)
					SET @NewValue =  CONVERT(NVARCHAR(40),@Amount)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Amount',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldNetPayAmount)
					SET @NewValue =  CONVERT(NVARCHAR(40),@NetPayAmount)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Net pay amount',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = IIF(ISNULL(@OldIsDirectDeposit,0) = 1,'Direct','none')
					SET @NewValue = IIF(ISNULL(@OldIsDirectDeposit,0) = 1,'Direct','none')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Direct pay',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					IF(ISNULL(@NotReturnValue,0) = 0)
					BEGIN

						SELECT Id FROM [dbo].EmployeeSalary WHERE Id = @EmployeeSalaryDetailId

					END

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END	
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO