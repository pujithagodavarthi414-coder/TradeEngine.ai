----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-08 00:00:00.000'
-- Purpose      To Upsert Leave Approval Request by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertLeaveApprovalRequest]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @LeaveApprovalRequestId = 'FAEDC3C2-B4DC-4ACA-85CA-16D943F55E42', @RequestedToUserId = 'E036FB47-C741-4351-BDFA-57AF8FE7196D', @LeaveApplicationId = 'BB3EA960-9F77-490B-9C58-F097F4690A95', @IsArchived = 0	
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveApprovalRequest]
(
   @LeaveApprovalRequestId UNIQUEIDENTIFIER = NULL,
   @RequestedToUserId UNIQUEIDENTIFIER = NULL,
   @LeaveApplicationId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY

		  IF(@RequestedToUserId = '00000000-0000-0000-0000-000000000000') SET @RequestedToUserId = NULL  
		  
	      IF(@RequestedToUserId IS NULL)
	      
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'RequestedToUserId')
		  
		  END	
	   	   	    
		  IF(@LeaveApplicationId = '00000000-0000-0000-0000-000000000000') SET @LeaveApplicationId = NULL  
		  
	      IF(@LeaveApplicationId IS NULL)
	      
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'LeaveApplicationId')
		  
		  END		  
		  ELSE 
		  		  
				 DECLARE @LeaveApprovalRequestIdCount INT = (SELECT COUNT(1) FROM LeaveApprovalRequest)
          				        	  
				 IF(@LeaveApprovalRequestIdCount = 0 AND @LeaveApprovalRequestId IS NOT NULL)

				 BEGIN
              
		  			RAISERROR(50002,16, 2,'LeaveApprovalRequestId')
          
				 END
				 ELSE

				 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				 IF (@HavePermission = '1')
				 BEGIN
       
						DECLARE @IsLatest BIT = (CASE WHEN @LeaveApprovalRequestId IS NULL THEN 1 ELSE 0 END)
			        
						IF(@IsLatest = 1)
						BEGIN
			      									      
						DECLARE @Currentdate DATETIME = GETDATE()
			            
						DECLARE @NewLeaveApprovalRequestId UNIQUEIDENTIFIER = NEWID()
																	            
						DECLARE @VersionNumber INT												
                  
						INSERT INTO [dbo].[LeaveApprovalRequest](
						            [Id],
									[RequestedToUserId],
			   	         			[LeaveApplicationId],
									[CreatedDateTime],
			   	         			[CreatedByUserId],
									[InActiveDateTime],					
			   	         			[VersionNumber]
			   	         			)
							 SELECT @NewLeaveApprovalRequestId,
									@RequestedToUserId,
			   	         	        @LeaveApplicationId,
									@Currentdate,
			   	         			@OperationsPerformedBy,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,		
									ISNULL(@VersionNumber,0) + 1					                            
									              
						END				
						ELSE
			      
			      			RAISERROR (50008,11, 1)
			      
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


