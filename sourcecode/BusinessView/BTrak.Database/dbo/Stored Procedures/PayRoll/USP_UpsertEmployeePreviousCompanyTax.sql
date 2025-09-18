-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeePreviousCompanyTax
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeePreviousCompanyTax]
(
   @EmployeePreviousCompanyTaxId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @TaxAmount DECIMAL(18,4) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


		DECLARE @EmployeePreviousCompanyTaxIdCount INT = (SELECT COUNT(1) FROM EmployeePreviousCompanyTax  WHERE Id = @EmployeePreviousCompanyTaxId)

	    IF(@EmployeeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@TaxAmount IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'TaxAmount')

		END
		ELSE
		BEGIN

	    IF(@EmployeePreviousCompanyTaxIdCount = 0 AND @EmployeePreviousCompanyTaxId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'EmployeePreviousCompanyTax')

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeePreviousCompanyTaxId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [EmployeePreviousCompanyTax] WHERE Id = @EmployeePreviousCompanyTaxId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@EmployeePreviousCompanyTaxId IS NULL)
							BEGIN

							SET @EmployeePreviousCompanyTaxId = NEWID()

							   INSERT INTO [dbo].[EmployeePreviousCompanyTax](
                                                    [Id],
							                        [EmployeeId], 
													[TaxAmount],
						                            [InActiveDateTime],
						                            [CreatedDateTime],
						                            [CreatedByUserId])
                                             SELECT @EmployeePreviousCompanyTaxId,
							                        @EmployeeId, 
													@TaxAmount,
						                            CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                            @Currentdate,
						                            @OperationsPerformedBy
		                     
							END
							ELSE
							BEGIN

							  UPDATE [EmployeePreviousCompanyTax]
							      SET [EmployeeId] = @EmployeeId, 
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  TaxAmount = @TaxAmount,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @EmployeePreviousCompanyTaxId

							END
			                
			              SELECT Id FROM [dbo].[EmployeePreviousCompanyTax] WHERE Id = @EmployeePreviousCompanyTaxId
			                       
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