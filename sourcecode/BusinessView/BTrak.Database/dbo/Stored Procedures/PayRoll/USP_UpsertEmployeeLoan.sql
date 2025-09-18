-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeLoan
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeLoan]
(
   @EmployeeLoanId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @LoanAmount DECIMAL(18,4) = NULL,
   @LoanTakenOn DATETIME = NULL,
   @LoanInterestPercentagePerMonth DECIMAL(18,6) = NULL,
   @TimePeriodInMonths DECIMAL(18,4) = NULL,
   @LoanTypeId  UNIQUEIDENTIFIER = NULL,
   @CompoundedPeriodId UNIQUEIDENTIFIER = NULL,
   @LoanPaymentStartDate DATETIME = NULL,
   @LoanBalanceAmount DECIMAL(18,4) = NULL,
   @LoanTotalPaidAmount DECIMAL(18,4) = NULL,
   @LoanClearedDate DATETIME = NULL,
   @IsApproved BIT,
   @IsArchived BIT,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Name NVARCHAR(250),
   @Description NVARCHAR(800)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	    IF(@EmployeeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@LoanAmount IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'LoanAmount')

		END
		ELSE IF(@LoanInterestPercentagePerMonth IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'LoanInterestPercentagePerMonth')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeLoanIdCount INT = (SELECT COUNT(1) FROM EmployeeLoan  WHERE Id = @EmployeeLoanId)
       
	    IF(@EmployeeLoanIdCount = 0 AND @EmployeeLoanId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'EmployeeLoan')

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeeLoanId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [EmployeeLoan] WHERE Id = @EmployeeLoanId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@EmployeeLoanId IS NULL)
							BEGIN

							SET @EmployeeLoanId = NEWID()

							INSERT INTO [dbo].[EmployeeLoan](
							                  [Id],
							                  [EmployeeId],
							                  [LoanAmount],
											  [LoanTakenOn],
											  [LoanInterestPercentagePerMonth],
											  [TimePeriodInMonths],
											  [LoanTypeId],
											  [CompoundedPeriodId],
											  [LoanPaymentStartDate],
											  [LoanBalanceAmount],
											  [LoanTotalPaidAmount],
											  [LoanClearedDate],
											  [IsApproved],
							                  [InactiveDateTime],
							                  [CreatedDateTime],
							                  [CreatedByUserId],
											  [Name],
                                              [Description])
                                       SELECT @EmployeeLoanId,
										      @EmployeeId,
										      @LoanAmount,
											  @LoanTakenOn,
											  @LoanInterestPercentagePerMonth,
											  @TimePeriodInMonths,
											  @LoanTypeId,
											  @CompoundedPeriodId,
											  @LoanPaymentStartDate,
											  @LoanBalanceAmount,
											  @LoanTotalPaidAmount,
											  @LoanClearedDate,
											  @IsApproved,
						                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
						                      @Currentdate,
						                      @OperationsPerformedBy,
											  @Name,
                                              @Description
		                     
							END
							ELSE
							BEGIN

							  UPDATE [EmployeeLoan]           
							     SET [EmployeeId] = @EmployeeId,
									 [LoanAmount] = @LoanAmount,
									 [LoanTakenOn] = @LoanTakenOn,
									 [LoanInterestPercentagePerMonth] = @LoanInterestPercentagePerMonth,
									 [TimePeriodInMonths] = @TimePeriodInMonths,
									 [LoanTypeId]= @LoanTypeId,
									 [CompoundedPeriodId] = @CompoundedPeriodId,
									 [LoanPaymentStartDate] = @LoanPaymentStartDate,
									 [LoanBalanceAmount] = @LoanBalanceAmount,
									 [LoanTotalPaidAmount] = @LoanTotalPaidAmount,
									 [LoanClearedDate] = @LoanClearedDate,
									 [IsApproved] = @IsApproved,
									 [InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy,
									 [Name] = @Name,
									 [Description] = @Description
									 WHERE Id = @EmployeeLoanId
							END
			                
			              SELECT Id FROM [dbo].[EmployeeLoan] WHERE Id = @EmployeeLoanId
			                       
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