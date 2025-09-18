-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Save or Update Merchant Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertMerchant] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@MerchantName='James'

CREATE PROCEDURE [dbo].[USP_UpsertMerchant]
(
  @MerchantId UNIQUEIDENTIFIER = NULL,
  @MerchantName NVARCHAR(200) = NULL,
  @Description NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    IF(@HavePermission = '1')		
    BEGIN
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@MerchantId = '00000000-0000-0000-0000-000000000000') SET @MerchantId = NULL
		
		IF(@MerchantName = '') SET @MerchantName = NULL
				
		IF(@MerchantName IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'MerchantName')
		END
	ELSE
		BEGIN
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @MerchantIdCount INT = (SELECT COUNT(1) FROM Merchant  WHERE Id = @MerchantId)

			DECLARE @MerchantNameCount INT = (SELECT COUNT(1) FROM Merchant WHERE MerchantName = @MerchantName AND CompanyId = @CompanyId AND (@MerchantId IS NULL OR Id <> @MerchantId))
			
			IF(@MerchantIdCount = 0 AND @MerchantId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16, 2,'Merchant')
				END
			ELSE IF(@MerchantNameCount > 0)
				BEGIN
					RAISERROR(50001,16,1,'Merchant')
				END
			ELSE
			    BEGIN
					
					IF (@HavePermission = '1')
						BEGIN
						DECLARE @IsLatest BIT = (CASE WHEN @MerchantId IS NULL 
													  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
													                         FROM [Merchant] WHERE Id = @MerchantId) = @TimeStamp 
																	   THEN 1 ELSE 0 END END)
						
						IF(@IsLatest = 1)
							BEGIN
						    
							DECLARE @Currentdate DATETIME = GETDATE()

							IF(@MerchantId IS NULL)
							BEGIN

								SET @MerchantId = NEWID()

						    	INSERT INTO [dbo].[Merchant](
						    	            Id,
						    	            MerchantName,
						    				[Description],
						    	            CompanyId,
						    	            CreatedDateTime,
						    	            CreatedByUserId,
											InActiveDateTime)
						    	     SELECT @MerchantId,
						    	            @MerchantName,
						    				@Description,
						    	            @CompanyId,
						    	            @Currentdate,
						    	            @OperationsPerformedBy,
											CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						    END
							ELSE
							BEGIN
								UPDATE [dbo].[Merchant]
											SET MerchantName			=	 @MerchantName,
												[Description]			=	 @Description,
									            CompanyId				=	 @CompanyId,
									            CreatedDateTime			=	 @Currentdate,
									            CreatedByUserId			=	 @OperationsPerformedBy,
												InActiveDateTime		=	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
												WHERE Id = @MerchantId
							END

						    SELECT Id FROM [dbo].[Merchant] WHERE Id = @MerchantId 
						    END
						ELSE 
							BEGIN
								RAISERROR (50008,11, 1)	
							END
					END
					ELSE
					  BEGIN
				   		RAISERROR (@HavePermission,11, 1)
				   END
				END
		END
	END
	ELSE
	BEGIN
		   
		   	RAISERROR (@HavePermission,11, 1)
		   		
		   END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO