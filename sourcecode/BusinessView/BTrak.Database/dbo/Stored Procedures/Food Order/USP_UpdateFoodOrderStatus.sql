-------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To update the foodorder status
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--declare @TimeStamp timestamp = (select [timestamp] from FoodOrder where id='8126E349-D32C-4418-86A9-0CC1DB27493F')
--EXEC [dbo].[USP_UpdateFoodOrderStatus] @FoodOrderId= '8126E349-D32C-4418-86A9-0CC1DB27493F',
--@IsApproveOrder  = 1, @Reason='Test',@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TimeStamp = @TimeStamp
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateFoodOrderStatus]
(
  @FoodOrderId UNIQUEIDENTIFIER = NULL,
  @IsApproveOrder BIT = NULL,
  @Reason NVARCHAR(800) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			 IF(@HavePermission = '1')
			 BEGIN

		         DECLARE @Count INT = (SELECT COUNT(1) FROM FoodOrder WHERE Id = @FoodOrderId)
			     
		         IF(@Count >= 1 AND @FoodOrderId IS NOT NULL) 
                 BEGIN

			         DECLARE @IsLatest BIT = (CASE WHEN @FoodOrderId IS NULL 
						  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
						                         FROM [FoodOrder] WHERE Id = @FoodOrderId ) = @TimeStamp 
										   THEN 1 ELSE 0 END END)

			         IF(@IsLatest = 1)
			         BEGIN

					      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
					      
					      IF(@Reason = '') SET @Reason = NULL
		     		      
		                  DECLARE @Currentdate DATETIME = GETUTCDATE()
		                  
				          DECLARE @FoodOrderStatusId UNIQUEIDENTIFIER 

					      SET @FoodOrderStatusId = CASE WHEN @IsApproveOrder = 1 THEN (SELECT Id FROM FoodOrderStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)
		                                                 WHEN @IsApproveOrder = 0 THEN (SELECT Id FROM FoodOrderStatus WHERE IsRejected = 1 AND CompanyId = @CompanyId)
					          			                 WHEN @IsApproveOrder IS NULL THEN (SELECT Id FROM FoodOrderStatus WHERE IsPending = 1 AND CompanyId = @CompanyId) 
					          				         END
     	                  
                                UPDATE [FoodOrder]
								   SET [Reason] = @Reason,
									   [StatusSetByUserId] = @OperationsPerformedBy,
									   [StatusSetDateTime] = @Currentdate,
									   [FoodOrderStatusId] = @FoodOrderStatusId
									   WHERE Id = @FoodOrderId
									   
	                      SELECT  Id FROM [dbo].[FoodOrder] where Id = @FoodOrderId

                END
			    ELSE
			    BEGIN
			    
			        RAISERROR (50008,11, 1)
			    
			    END

		     END
		     ELSE
		     BEGIN
			 
		           RAISERROR ('DataIsNotFoundToUpdateTheRecord',11, 1)
			 
		     END

			 END
			 ELSE
			 BEGIN

			   RAISERROR (@HavePermission,10, 1)

			 END
		     
	   END TRY  
	   BEGIN CATCH 
		
		    THROW

	  END CATCH
END
GO