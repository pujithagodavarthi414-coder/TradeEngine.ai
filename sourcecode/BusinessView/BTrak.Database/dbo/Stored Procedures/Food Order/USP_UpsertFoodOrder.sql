-------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To save or update the FoodOrders By applying different Filters select * from Foodorder where originalId = '63EAAC2A-7C01-4EF8-91D8-BE2FE54EE6CD'
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFoodOrder] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FoodOrderItems='Test',
--@Amount=1000,@Comment='Test',@Reason='Meeting'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertFoodOrder] 
(
    @FoodOrderId UNIQUEIDENTIFIER = NULL,
    @FoodOrderItems NVARCHAR(800) = NULL,
    @Amount MONEY = NULL,
    @CurrencyId UNIQUEIDENTIFIER = NULL,
    @OrderedDateTime DATETIME = NULL,
    @FoodOrderedUsersXml XML = NULL,
    @Comment NVARCHAR(250) = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @Reason NVARCHAR(800) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@FoodOrderItems = '') SET @FoodOrderItems = NULL

		DECLARE @CurrentDate DATETIME = GETDATE()

		IF(@OrderedDateTime IS NULL) SET @OrderedDateTime = @CurrentDate

	    IF(@FoodOrderItems IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Item')

		END
		ELSE 
		BEGIN

		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @IsEligibleToUpdate BIT = 0

		    IF(@HavePermission = '1')
			BEGIN

			   IF(@FoodOrderId IS NOT NULL)
		       BEGIN
			    
		            DECLARE @Count INT = (SELECT COUNT(1) FROM FoodOrder WHERE Id = @FoodOrderId)
			    
		            IF(@Count >= 1) 
                    BEGIN
			           
					   SET @IsEligibleToUpdate =  1

		            END
		            ELSE
		            BEGIN
		            
		                RAISERROR (50002,11, 1,'FoodOrder')
			        
		            END
		       END
            
			   IF(@FoodOrderId IS NULL OR @IsEligibleToUpdate  = 1)
			   BEGIN

			       DECLARE @IsLatest BIT = (CASE WHEN @FoodOrderId IS NULL 
						  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
						                         FROM [FoodOrder] WHERE Id = @FoodOrderId) = @TimeStamp 
										   THEN 1 ELSE 0 END END)

			       IF(@IsLatest = 1)
			       BEGIN

				          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
					      
					      IF(@Reason = '') SET @Reason = NULL
		                  
					      
				          DECLARE @FoodOrderStatusId UNIQUEIDENTIFIER 

					      SET @FoodOrderStatusId = CASE WHEN @StatusId IS NULL THEN (SELECT Id FROM FoodOrderStatus WHERE IsPending = 1 AND CompanyId = @CompanyId) 
						                           ELSE @StatusId END

     	                  IF(@FoodOrderId IS NULL)
						  BEGIN

						  SET @FoodOrderId = NEWID()

					      INSERT INTO [dbo].[FoodOrder](
			        		          [Id],
								      [CompanyId],
			        			      [FoodItemName],
								      [Amount],
									  [CurrencyId],
									  [Reason],
									  [Comment],
									  [ClaimedByUserId],
									  [StatusSetByUserId],
									  [StatusSetDateTime],
									  [FoodOrderStatusId],
									  [OrderedDateTime],			        			        			 
								      [CreatedByUserId],
								      [CreatedDateTime]
								     )
                               SELECT @FoodOrderId,
								      @CompanyId,
									  @FoodOrderItems,
									  @Amount,
									  @CurrencyId,
									  @Reason,
									  @Comment,
								      @OperationsPerformedBy,
									  CASE WHEN @FoodOrderId IS NULL THEN NULL ELSE @OperationsPerformedBy END,
								      @Currentdate,
									  @FoodOrderStatusId,
									  @OrderedDateTime,
									  @OperationsPerformedBy,
									  @Currentdate

							END
							ELSE
							BEGIN

							UPDATE [FoodOrder]
							  SET [CompanyId] = @CompanyId,
			        			  [FoodItemName] = @FoodOrderItems,
								  [Amount] = @Amount,
								  [CurrencyId] = @CurrencyId,
								  [Reason] = @Reason,
								  [Comment] = @Comment,
								  [ClaimedByUserId] = @OperationsPerformedBy,
								  [StatusSetByUserId] = CASE WHEN @FoodOrderId IS NULL THEN NULL ELSE @OperationsPerformedBy END,
								  [StatusSetDateTime] = @CurrentDate,
								  [FoodOrderStatusId] = @FoodOrderStatusId,
								  [OrderedDateTime] = @OrderedDateTime,
								  [UpdatedDateTime] = @CurrentDate,
								  [UpdatedByUserId] = @OperationsPerformedBy
								  WHERE Id = @FoodOrderId

							END
                          
						  DECLARE @ResultId UNIQUEIDENTIFIER = (SELECT Id Id FROM [dbo].[FoodOrder] where Id = @FoodOrderId)

					      DELETE [dbo].[FoodOrderUser]  WHERE OrderId = @FoodOrderId

                          INSERT INTO [dbo].[FoodOrderUser](
                                      Id,
                                      OrderId,
                                      UserId,
                                      CreatedByUserId,
                                      CreatedDateTime)
                                SELECT NEWID(),
                                      @ResultId,
                                      X.Y.value('(text())[1]', 'varchar(100)'),
                                      @OperationsPerformedBy,
                                      @Currentdate
                                 FROM @FoodOrderedUsersXml.nodes('/GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)

	                      SELECT @ResultId AS Id

				   END
			       ELSE
			       BEGIN
			       
			           RAISERROR (50008,11, 1)
			       
			       END
			   END

            END
			ELSE
			BEGIN

			  RAISERROR (@HavePermission,10, 1)

			END
		END
    END TRY
    BEGIN CATCH
       
	   THROW
    
	END CATCH
END
GO