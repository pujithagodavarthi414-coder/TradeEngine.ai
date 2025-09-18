----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-11-08 00:00:00.000'
-- Purpose      To Add or Update Expense Merchant by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertExpenseMerchant] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @MerchantName = 'test', @ExpenseId = 'DA4F93DD-D871-4779-A62E-DD495B5721D6',
-- @ExpenseMerchantId = '5F805CE2-107D-4242-9403-7B14607B170A', @TimeStamp = 0x000000000004EFCF
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertExpenseMerchant]
(
   @ExpenseMerchantId UNIQUEIDENTIFIER = NULL,
   @ExpenseId UNIQUEIDENTIFIER = NULL,
   @MerchantName NVARCHAR(250) = NULL, 
   @StatusId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF(@ExpenseId = '00000000-0000-0000-0000-000000000000') SET @ExpenseId = NULL

			IF(@ExpenseId IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'ExpenseId')
		  
		    END
			ELSE IF(@MerchantName = '') SET @MerchantName = NULL
		  
	        IF(@MerchantName IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'MerchantName')
		  
		    END

			DECLARE @ExpenseMerchantIdCount INT = (SELECT COUNT(1) FROM ExpenseMerchant  WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL)

			--DECLARE @ExpenseIdCount INT = (SELECT COUNT(1) FROM ExpenseMerchant  WHERE ExpenseId = @ExpenseId AND AsAtInactiveDateTime IS NULL)
		  
			DECLARE @MerchantNameCount INT = (SELECT COUNT(1) FROM ExpenseMerchant WHERE MerchantName = @MerchantName AND AsAtInactiveDateTime IS NULL AND (@ExpenseMerchantId IS NULL OR OriginalId <> @ExpenseMerchantId))       		     
       	  
			IF(@ExpenseMerchantIdCount = 0 AND @ExpenseMerchantId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 2,'ExpenseMerchant')

			END
			--ELSE IF(@ExpenseIdCount = 0 AND @ExpenseId IS NOT NULL)
			--BEGIN

			--	RAISERROR(50002,16, 2,'Expense')

			--END
			ELSE IF(@MerchantNameCount>0)
			BEGIN
         
				RAISERROR(50001,16,1,@MerchantName,'MerchantName')
			   
			END
			ELSE

				DECLARE @IsLatest BIT = (CASE WHEN @ExpenseMerchantId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ExpenseMerchant WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL) = @TimeStamp THEN 1 ELSE 0 END END)
			        
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
					DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM ExpenseMerchant WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL)

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewExpenseMerchantId UNIQUEIDENTIFIER = NEWID()		
					
					DECLARE @OriginalCreatedDateTime DATETIME, @OriginalCreatedByUserId UNIQUEIDENTIFIER

					SELECT @OriginalCreatedDateTime = OriginalCreatedDateTime, @OriginalCreatedByUserId = OriginalCreatedByUserId FROM ExpenseMerchant WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL								
															            
					DECLARE @VersionNumber INT
			            
					SELECT @VersionNumber = VersionNumber FROM ExpenseMerchant WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL

					INSERT INTO [dbo].[ExpenseMerchant](
							    [Id],
								[ExpenseId],
								[MerchantName],
								[StatusId],
								[CreatedDateTime],
			   	         		[CreatedByUserId],	
								[OriginalCreatedDateTime],
								[OriginalCreatedByUserId],		
			   	         		[InActiveDateTime],		
			   	         		[VersionNumber],
			   	         		[OriginalId]
			   	         		)
						 SELECT @NewExpenseMerchantId,
								@ExpenseId,
								@MerchantName,
								@StatusId,
								@Currentdate,
			   	         		@OperationsPerformedBy,	
								ISNULL(@OriginalCreatedDateTime,@Currentdate),
                                ISNULL(@OriginalCreatedByUserId,@OperationsPerformedBy),
								CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,	
								ISNULL(@VersionNumber,0) + 1,
								ISNULL(@ExpenseMerchantId,@NewExpenseMerchantId) 

					UPDATE ExpenseMerchant SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @ExpenseMerchantId AND AsAtInactiveDateTime IS NULL AND Id <> @NewExpenseMerchantId

					SELECT OriginalId FROM [dbo].[ExpenseMerchant] WHERE Id = @NewExpenseMerchantId

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
