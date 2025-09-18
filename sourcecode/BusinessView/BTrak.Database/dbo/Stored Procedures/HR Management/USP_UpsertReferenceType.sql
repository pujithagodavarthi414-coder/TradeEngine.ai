-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update ReferenceType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertReferenceType]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ReferenceTypeName = 'Test',@IsArchived = 0								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertReferenceType]
(
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeName NVARCHAR(50) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN
	      IF(@ReferenceTypeName = '') SET @ReferenceTypeName = NULL
		  
	      IF(@ReferenceTypeName IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'ReferenceTypeName')
		  
		  END
		  ELSE 
		  BEGIN
		  
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType  WHERE Id = @ReferenceTypeId)
          
		  DECLARE @ReferenceTypeNameCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE ReferenceTypeName = @ReferenceTypeName AND (@ReferenceTypeId IS NULL OR Id <> @ReferenceTypeId))       
       	  
	      IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
          BEGIN
              
		  	RAISERROR(50002,16, 2,'ReferenceType')
          
		  END
          ELSE IF(@ReferenceTypeNameCount>0)
          BEGIN
          
            RAISERROR(50001,16,1,@ReferenceTypeName,'ReferenceType')
             
           END
          ELSE
		  BEGIN
       
			        DECLARE @IsLatest BIT = (CASE WHEN @ReferenceTypeId IS NULL 
			                                THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                            FROM [ReferenceType] WHERE Id = @ReferenceTypeId) = @TimeStamp
			        						THEN 1 ELSE 0 END END)
			        
			      IF(@IsLatest = 1)
			      BEGIN
			      
			            DECLARE @Currentdate DATETIME = GETDATE()
			            
						IF(@ReferenceTypeId IS NULL)
						BEGIN

						SET @ReferenceTypeId = NEWID()

                         INSERT INTO [dbo].[ReferenceType](
                                     [Id],
			   	         		     [CompanyId],
			   	         		     [ReferenceTypeName],
			   	         		     [InActiveDateTime],
			   	         		     [CreatedDateTime],
			   	         		     [CreatedByUserId]
			   	         		     )
                              SELECT @ReferenceTypeId,
			   	         		     @CompanyId,
			   	         		     @ReferenceTypeName,
			   	         		     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			   	         		     @Currentdate,
			   	         		     @OperationsPerformedBy
			                            
			               END
						   ELSE
						   BEGIN

						   UPDATE [ReferenceType] 
						          SET [CompanyId] = @CompanyId,
			   	         		     [ReferenceTypeName] = @ReferenceTypeName,
			   	         		     [InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
							WHERE Id = @ReferenceTypeId

						   END

			     SELECT Id FROM [dbo].[ReferenceType] WHERE Id = @ReferenceTypeId

			      END
			      ELSE
			      
			      	RAISERROR (50008,11, 1)
			      
			      END
			         
            END
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
