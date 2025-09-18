---------------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To Upsert FileHistory by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFileHistory]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FileId = 1C3A3EE2-1836-4574-A09D-2DE26ACFDC41,@IsArchived = 0	
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFileHistory]
(
   @FileHistoryId UNIQUEIDENTIFIER = NULL,
   @FileId UNIQUEIDENTIFIER,
   @Comment NVARCHAR(150) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	   
		   	  DECLARE @FileHistoryIdCount INT = (SELECT COUNT(1) FROM FileHistory  WHERE Id = @FileHistoryId)
          		        	  
			  IF(@FileHistoryIdCount = 0 AND @FileHistoryId IS NOT NULL)
			  BEGIN
              
		  		RAISERROR(50002,16, 2,'FileHistory Type')
          
			  END
			  ELSE

			  DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			  IF (@HavePermission = '1')
			  BEGIN
       
				  DECLARE @IsLatest BIT = (CASE WHEN @FileHistoryId IS NULL THEN 1 ELSE 0 END)
			        
				  IF(@IsLatest = 1)
				  BEGIN
			      
				  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				  DECLARE @Currentdate DATETIME = GETDATE()
			      			            	            
				  DECLARE @NewFileHistoryId UNIQUEIDENTIFIER = NEWID()					
									            
				  DECLARE @VersionNumber INT
			            			            			      			            	
				  INSERT INTO [dbo].[FileHistory](
					          [Id],
			   	         	  [FileId],
							  [Comment],
			   	         	  [CreatedDateTime],
			   	         	  [CreatedByUserId]
			   	         	  )
					  SELECT @NewFileHistoryId,
			   	    		 @FileId,
							 @Comment,
							 @Currentdate,
			   	         	 @OperationsPerformedBy		
			                         			                    
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