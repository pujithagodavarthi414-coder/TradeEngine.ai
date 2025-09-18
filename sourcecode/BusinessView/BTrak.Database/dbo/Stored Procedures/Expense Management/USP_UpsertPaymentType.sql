
-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Save or update the payment types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------------------------
--EXEC USP_UpsertPaymentType @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PaymentTypeName='Test'
-----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertPaymentType
(
 @PaymentTypeId UNIQUEIDENTIFIER = NULL,
 @PaymentTypeName NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
   
      SET NOCOUNT ON
	  BEGIN TRY 
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@PaymentTypeName = '') SET @PaymentTypeName = NULL
		
		IF(@PaymentTypeId = '00000000-0000-0000-0000-000000000000') SET @PaymentTypeId = NULL    

		IF (@PaymentTypeName IS NULL)
		BEGIN
		   
		   RAISERROR(50011,16,2,'PaymentTypeName')

		END
		ELSE
		BEGIN

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
        IF (@HavePermission = '1')
        BEGIN


		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @PaymentTypeIdCount INT = (SELECT COUNT(1) FROM PaymentType WHERE Id = @PaymentTypeId  AND CompanyId = @CompanyId) 

		   DECLARE @PaymentTypeNameCount INT = (SELECT COUNT(1) FROM PaymentType WHERE (PaymentTypeName = @PaymentTypeName) AND (@PaymentTypeId IS NULL OR Id <> @PaymentTypeId ) AND CompanyId = @CompanyId) 

		   IF(@PaymentTypeIdCount = 0 AND @PaymentTypeId IS NOT NULL)
		   BEGIN
		    
			  RAISERROR(50002,16,1,'PaymentType')

		   END
		   ELSE IF(@PaymentTypeNameCount > 0)
		   BEGIN

		      RAISERROR(50001,16,1,'PaymentType')

		   END
		   ELSE
		   BEGIN

		     DECLARE @IsLatest BIT = (CASE WHEN @PaymentTypeId IS NULL THEN 1 ELSE 
			                          CASE WHEN (SELECT [TimeStamp] FROM PaymentType WHERE Id = @PaymentTypeId) = @TimeStamp THEN 1 ELSE 0 END END )

		   IF (@IsLatest = 1)
		   BEGIN
		     
			 DECLARE @CurrentDate DATETIME = GETDATE()

			 IF(@PaymentTypeId IS NULL)
			 BEGIN

			 SET @PaymentTypeId = NEWID()
			  INSERT INTO PaymentType( Id,
	                                   CompanyId,
	                                   PaymentTypeName,
	                                   CreatedDateTime,
	                                   CreatedByUserId,
                                       InActiveDateTime
									  )
							  SELECT  @PaymentTypeId,
							          @CompanyId,
									  @PaymentTypeName,
									  @CurrentDate,
									  @OperationsPerformedBy,
									  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

			END
			ELSE
			BEGIN

			UPDATE PaymentType
				SET  CompanyId					=				  @CompanyId,
	                 PaymentTypeName		   	=				  @PaymentTypeName,
	                 UpdatedDateTime			=				  @CurrentDate,
	                 UpdatedByUserId			=				  @OperationsPerformedBy,
                     InActiveDateTime			=				  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					 WHERE ID = @PaymentTypeId

			END

				SELECT Id FROM PaymentType WHERE Id = @PaymentTypeId

			END
			ELSE
			   
			   RAISERROR(50008,16,1)

		   END
		    
		   END

		   ELSE
		     RAISERROR(@HavePermission,11,1)

		   END

	  END TRY

	BEGIN CATCH
	   THROW
	END CATCH
END
GO