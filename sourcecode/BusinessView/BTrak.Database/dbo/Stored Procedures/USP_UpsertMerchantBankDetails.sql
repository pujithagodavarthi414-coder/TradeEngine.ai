----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-11-08 00:00:00.000'
-- Purpose      To Add or Update Merchant Bank Details by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertMerchantBankDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ExpenseMerchantId = '5F805CE2-107D-4242-9403-7B14607B170A',
-- @MerchantBankDetailsId = '5FB4F5AA-1D22-40A2-A0E5-3546E0DA2941', @TimeStamp = 0x000000000005059B
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertMerchantBankDetails]
(
   @MerchantBankDetailsId UNIQUEIDENTIFIER = NULL,
   @ExpenseMerchantId UNIQUEIDENTIFIER = NULL,
   @PayeeName NVARCHAR(250) = NULL,
   @BankName NVARCHAR(250) = NULL,
   @BranchName NVARCHAR(250) = NULL,   
   @AccountNumber NVARCHAR(250) = NULL,
   @IFSCCode NVARCHAR(250) = NULL,
   @SortCode NVARCHAR(250) = NULL, 
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF(@ExpenseMerchantId = '00000000-0000-0000-0000-000000000000') SET @ExpenseMerchantId = NULL

			IF(@ExpenseMerchantId IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'ExpenseMerchantId')
		  
		    END

			DECLARE @MerchantBankDetailsIdCount INT = (SELECT COUNT(1) FROM MerchantBankDetails  WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL)
		  
			DECLARE @ExpenseMerchantIdCount INT = (SELECT COUNT(1) FROM ExpenseMerchant WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL)
       	  
			IF(@MerchantBankDetailsIdCount = 0 AND @MerchantBankDetailsId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 2,'MerchantBankDetails')

			END
			IF(@ExpenseMerchantIdCount = 0 AND @ExpenseMerchantId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 2,'ExpenseMerchant')

			END
			ELSE

				DECLARE @IsLatest BIT = (CASE WHEN @MerchantBankDetailsId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM MerchantBankDetails WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL) = @TimeStamp THEN 1 ELSE 0 END END)
			        
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
					DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM MerchantBankDetails WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL)

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewMerchantBankDetailsId UNIQUEIDENTIFIER = NEWID()		
					
					DECLARE @OriginalCreatedDateTime DATETIME, @OriginalCreatedByUserId UNIQUEIDENTIFIER

					SELECT @OriginalCreatedDateTime = OriginalCreatedDateTime, @OriginalCreatedByUserId = OriginalCreatedByUserId FROM MerchantBankDetails WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL								
															            
					DECLARE @VersionNumber INT
			            
					SELECT @VersionNumber = VersionNumber FROM MerchantBankDetails WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL

					INSERT INTO [dbo].[MerchantBankDetails](
							    [Id],
								[ExpenseMerchantId],
								[PayeeName],
								[BankName],
								[BranchName],
								[AccountNumber],
								[IFSCCode],
								[SortCode],
								[CreatedDateTime],
			   	         		[CreatedByUserId],	
								[OriginalCreatedDateTime],
								[OriginalCreatedByUserId],		
			   	         		[InActiveDateTime],		
			   	         		[VersionNumber],
			   	         		[OriginalId]
			   	         		)
						 SELECT @NewMerchantBankDetailsId,
								@ExpenseMerchantId,
								@PayeeName,
								@BankName,
								@BranchName,
								@AccountNumber,
								@IFSCCode,
								@SortCode,
								@Currentdate,
			   	         		@OperationsPerformedBy,	
								ISNULL(@OriginalCreatedDateTime,@Currentdate),
                                ISNULL(@OriginalCreatedByUserId,@OperationsPerformedBy),
								CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,	
								ISNULL(@VersionNumber,0) + 1,
								ISNULL(@MerchantBankDetailsId,@NewMerchantBankDetailsId) 

					UPDATE MerchantBankDetails SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @MerchantBankDetailsId AND AsAtInactiveDateTime IS NULL AND Id <> @NewMerchantBankDetailsId

					SELECT OriginalId FROM [dbo].[MerchantBankDetails] WHERE Id = @NewMerchantBankDetailsId

 				END
				ELSE

					RAISERROR(50008,11,1)

			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
