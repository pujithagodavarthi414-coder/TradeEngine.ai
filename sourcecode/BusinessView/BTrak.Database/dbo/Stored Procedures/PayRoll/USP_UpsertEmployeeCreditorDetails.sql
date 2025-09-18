-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeCreditorDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeCreditorDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@BranchId='1210DB37-93F7-4347-9240-E978A270B707',
-- @BankName = 'Test', @AccountNumber = '5945743850943', @AccountName = 'Test',@IfScCode = '45gdhgfh'
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeCreditorDetails]
(
   @EmployeeCreditorDetailsId UNIQUEIDENTIFIER = NULL,
   @BranchId  UNIQUEIDENTIFIER = NULL,
   @BankId UNIQUEIDENTIFIER = NULL,
   @AccountNumber NVARCHAR(50) = NULL,
   @PanNumber NVARCHAR(50) = NULL,
   @AccountName NVARCHAR(250) = NULL,
   @IfScCode NVARCHAR(100) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @Email NVARCHAR(800) = NULL,
   @MobileNo NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @UseForPerformaInvoice BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@BankId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Bank')

		END
		ELSE IF(@BranchId IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@AccountNumber IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'AccountNumber')

		END
		ELSE IF(@AccountName IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'AccountName')

		END
		ELSE IF(@IfScCode IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'IfScCode')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeCreditorDetailsIdCount INT = (SELECT COUNT(1) FROM EmployeeCreditorDetails  WHERE Id = @EmployeeCreditorDetailsId)
       
	    DECLARE @EmployeeCreditorDetailsDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeCreditorDetails WHERE BranchId = @BranchId 
																		AND (@EmployeeCreditorDetailsId IS NULL OR @EmployeeCreditorDetailsId <> Id))
		
	    IF(@UseForPerformaInvoice = 1)
        BEGIN

		DECLARE @EmployeeCreditorDetails INT = (SELECT COUNT(1) FROM EmployeeCreditorDetails AS ECD	
																INNER JOIN Branch B ON B.Id = ECD.BranchId  
																WHERE ECD.UseForPerformaInvoice = 1 
																AND B.CompanyId = @CompanyId
																AND (@EmployeeCreditorDetailsId IS NULL OR @EmployeeCreditorDetailsId <> ECD.Id))
		   IF (@EmployeeCreditorDetails > 0  )
            RAISERROR(50002,16, 2,'PerformaInvoiceIsUsedForOthercreditorDetailsRemoveForOtherCreditorDetails')

        END
		ELSE IF(@EmployeeCreditorDetailsIdCount = 0 AND @EmployeeCreditorDetailsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'EmployeeCreditorDetails')

        END
		IF (@EmployeeCreditorDetailsDuplicateCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'EmployeeCreditorDetails')

		END

        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeeCreditorDetailsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [EmployeeCreditorDetails] WHERE Id = @EmployeeCreditorDetailsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@EmployeeCreditorDetailsId IS NULL)
							BEGIN

							SET @EmployeeCreditorDetailsId = NEWID()

							INSERT INTO [dbo].[EmployeeCreditorDetails](
                                                              [Id],
															  [BranchId],  
                                                              [BankId], 
                                                              [AccountNumber],
                                                              [AccountName],
                                                              [IfScCode], 
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
															  [Email],
															  [MobileNo],
															  [UseForPerformaInvoice],
															  [PanNumber]
															  )
                                                       SELECT @EmployeeCreditorDetailsId,
                                                              @BranchId,  
                                                              @BankId, 
                                                              @AccountNumber,
                                                              @AccountName ,
                                                              @IfScCode, 
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @Email,
															  @MobileNo,
															  @UseForPerformaInvoice,
															  @PanNumber
		                     
							END
							ELSE
							BEGIN

							  UPDATE [EmployeeCreditorDetails]
							      SET [BranchId] = @BranchId, 
									  [BankId] = @BankId, 
									  [AccountNumber] = @AccountNumber,
									  [AccountName] = @AccountName ,
									  [IfScCode] = @IfScCode, 
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  [Email] = @Email,
									  [MobileNo] = @MobileNo,
									  [UseForPerformaInvoice] = @UseForPerformaInvoice,
									  [PanNumber] = @PanNumber
									  WHERE Id = @EmployeeCreditorDetailsId

							END
			                
			              SELECT Id FROM [dbo].[EmployeeCreditorDetails] WHERE Id = @EmployeeCreditorDetailsId
			                       
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
