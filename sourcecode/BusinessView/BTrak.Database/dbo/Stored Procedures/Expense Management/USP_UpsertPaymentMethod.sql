-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update PaymentMethod
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPaymentMethod] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@PaymentMethodName = 'Test1'								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPaymentMethod]
(
   @PaymentMethodId UNIQUEIDENTIFIER = NULL,
   @PaymentMethodName NVARCHAR(50) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@PaymentMethodName = '') SET @PaymentMethodName = NULL

		IF(@IsArchived = 1 AND @PaymentMethodId IS NOT NULL)
        BEGIN
		
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	     IF(EXISTS(SELECT Id FROM [EmployeeSalary] WHERE PaymentMethodId = @PaymentMethodId))
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisPayMethodUsedInEmployeeSalaryPleaseDeleteTheDependenciesAndTryAgain'
	     
	     END
		 
		 IF(@IsEligibleToArchive <> '1')
		 BEGIN
		 
		     RAISERROR (@isEligibleToArchive,11, 1)
		 
		 END

	    END

	    IF(@PaymentMethodName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PaymentMethodName')

		END
		ELSE
		BEGIN
		 
		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PaymentMethodIdCount INT = (SELECT COUNT(1) FROM PaymentMethod  WHERE Id = @PaymentMethodId)
        
		DECLARE @PaymentMethodNameCount INT = (SELECT COUNT(1) FROM PaymentMethod WHERE PaymentMethodName = @PaymentMethodName 
		                                       AND CompanyId = @CompanyId AND (@PaymentMethodId IS NULL OR Id <> @PaymentMethodId))       
       
	    IF(@PaymentMethodIdCount = 0 AND @PaymentMethodId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'PaymentMethod')
        END
        ELSE IF(@PaymentMethodNameCount>0)
        BEGIN
        
          RAISERROR(50001, 16 ,1 ,'PaymentMethod')
           
         END
         ELSE
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @PaymentMethodId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [PaymentMethod] WHERE Id = @PaymentMethodId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                    IF (@PaymentMethodId IS NULL)
					BEGIN
					
					SET @PaymentMethodId = NEWID()
             INSERT INTO [dbo].[PaymentMethod](
                         [Id],
						 [CompanyId],
						 [PaymentMethodName],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]				
						 )
                  SELECT @PaymentMethodId,
						 @CompanyId,
						 @PaymentMethodName,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy		
			                
					END
					ELSE
					BEGIN

					UPDATE [dbo].[PaymentMethod]
						SET [CompanyId]					= 	   @CompanyId,
							[PaymentMethodName]			= 	   @PaymentMethodName,
							[InActiveDateTime]			= 	   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
							[UpdatedDateTime]			= 	   @Currentdate,
							[UpdatedByUserId]			= 	   @OperationsPerformedBy
							WHERE (Id = @PaymentMethodId)

					END
			             SELECT Id FROM [dbo].[PaymentMethod] WHERE Id = @PaymentMethodId
			                       
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