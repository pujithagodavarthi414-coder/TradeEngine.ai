CREATE PROCEDURE [dbo].[USP_UpsertShipToAddress]
(
   @AddressId UNIQUEIDENTIFIER = NULL,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @AddressName NVARCHAR(50) = NULL,  
   @Description NVARCHAR(250) = NULL,  
   @Comments NVARCHAR(250) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @IsVerified BIT = NULL,
   @IsShiptoAddress BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@AddressName = '') SET @AddressName = NULL

		
	    IF(@AddressName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ShipAddressName')

		END
		ELSE
		BEGIN
		 
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @IdCount INT = (SELECT COUNT(1) FROM [ShipToAddress]  WHERE Id = @AddressId)
        
		DECLARE @NameCount INT = (SELECT COUNT(1) FROM [ShipToAddress] WHERE AddressName = @AddressName 
		                                       AND CompanyId = @CompanyId AND IsShiptoAddress = @IsShiptoAddress AND (@AddressId IS NULL OR Id <> @AddressId))       
       
	    IF(@IdCount = 0 AND @AddressId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'ShipAddress')
        END
        ELSE IF(@NameCount>0)
        BEGIN
        
          RAISERROR(50001, 16 ,1 ,'ShipAddress')
           
         END
         ELSE
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @AddressId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [ShipToAddress] WHERE Id = @AddressId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                    IF (@AddressId IS NULL)
					BEGIN
					
					SET @AddressId = NEWID()
             INSERT INTO [dbo].[ShipToAddress](
                         [Id],
						 [CompanyId],
						 ClientId,
						 AddressName,
						 [Description],
						 [Comments],
						 IsShiptoAddress,
						 IsVerified,
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]				
						 )
                  SELECT @AddressId,
						 @CompanyId,
						 @ClientId,
						 @AddressName,
						 @Description,
						 @Comments,
						 @IsShiptoAddress,
						 @IsVerified,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy		
			                
					END
					ELSE
					BEGIN

					UPDATE [dbo].[ShipToAddress]
						SET [CompanyId]					= 	   @CompanyId,
							AddressName						= 	   @AddressName,
							ClientId						= 	   @ClientId,
							[Description]						= 	   @Description,
							[Comments]						= 	   @Comments,
							IsShiptoAddress						= 	   @IsShiptoAddress,
							IsVerified						= 	   @IsVerified,
							[InActiveDateTime]			= 	   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
							[UpdatedDateTime]			= 	   @Currentdate,
							[UpdatedByUserId]			= 	   @OperationsPerformedBy
							WHERE (Id = @AddressId)

					END
			             SELECT Id FROM [dbo].[ShipToAddress] WHERE Id = @AddressId
			       

			                       
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