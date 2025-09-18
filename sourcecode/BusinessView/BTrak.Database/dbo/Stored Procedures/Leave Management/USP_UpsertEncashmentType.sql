----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-07 00:00:00.000'
-- Purpose      To upsert encashment types by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEncashmentTypes]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @EncashmentTypeId = '15296759-BEDE-40FA-89B7-CCBC200747BF', @EncashmentTypeName = 'Yearly', @IsArchived = 0	
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEncashmentTypes]
(
   @EncashmentTypeId UNIQUEIDENTIFIER = NULL,
   @EncashmentTypeName NVARCHAR(50),  
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	   	   	    
		  IF(@EncashmentTypeName = '') SET @EncashmentTypeName = NULL
		  
	      IF(@EncashmentTypeName IS NULL)
	      
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'Encashment Type')
		  
		  END
		  ELSE 
		  		  
				 DECLARE @EncashmentTypeIdCount INT = (SELECT COUNT(1) FROM EncashmentTypes  WHERE OriginalId = @EncashmentTypeId AND AsAtInactiveDateTime IS NULL)
          
				 DECLARE @EncashmentTypeNameCount INT = (SELECT COUNT(1) FROM EncashmentTypes WHERE EncashmentType = @EncashmentTypeName AND AsAtInactiveDateTime IS NULL AND (@EncashmentTypeId IS NULL OR OriginalId <> @EncashmentTypeId))       
       	  
				 IF(@EncashmentTypeIdCount = 0 AND @EncashmentTypeId IS NOT NULL)

				 BEGIN
              
		  			RAISERROR(50002,16, 2,'Encashment Type')
          
				 END
				 ELSE IF(@EncashmentTypeNameCount>0)

				 BEGIN
          
					RAISERROR(50001,16,1,@EncashmentTypeName,'Encashment Type')
             
				 END
				 ELSE

				 DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				 IF (@HavePermission = '1')
				 BEGIN
       
						DECLARE @IsLatest BIT = (CASE WHEN @EncashmentTypeId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EncashmentTypes WHERE OriginalId = @EncashmentTypeId AND AsAtInactiveDateTime IS NULL) = @TimeStamp THEN 1 ELSE 0 END END)
			        
						IF(@IsLatest = 1)
						BEGIN
			      
						DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			      
						DECLARE @Currentdate DATETIME = GETDATE()
			            
						DECLARE @NewEncashmentTypeId UNIQUEIDENTIFIER = NEWID()
																	            
						INSERT INTO [dbo].[EncashmentType](
						            [Id],
			   	         			[EncashmentType],
									[CompanyId],
									[InActiveDateTime],
			   	         			[CreatedDateTime],
			   	         			[CreatedByUserId]
			   	         			)
							 SELECT @NewEncashmentTypeId,
			   	         	        @EncashmentTypeName,
									@CompanyId,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									@Currentdate,
			   	         			@OperationsPerformedBy
			                            
						SELECT Id FROM [dbo].[EncashmentTypes] WHERE Id = @NewEncashmentTypeId
			              
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


