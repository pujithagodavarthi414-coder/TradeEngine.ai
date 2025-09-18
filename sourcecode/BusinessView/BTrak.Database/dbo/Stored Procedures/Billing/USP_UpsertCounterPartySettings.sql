---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCounterPartySettings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@Key='Test',@Description = 'Description',@Value = 'fvhvwh'			  
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertCounterPartySettings]
(
   @CounterPartySettingsId UNIQUEIDENTIFIER = NULL,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @Key NVARCHAR(500) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Value NVARCHAR(500) = NULL,
   @Description NVARCHAR(500) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsVisible BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		IF(@IsVisible IS NULL)
			SET @IsVisible = 0;

	    IF(@Key IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Key')

		END
		ELSE IF(@Description IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Description')

		END
		ELSE IF(@Value IS NULL)
		BEGIN
		   
		   RAISERROR(50011,16, 2, 'Value')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @CounterPartySettingsIdCount INT = (SELECT COUNT(1) FROM CounterPartySettings  WHERE Id = @CounterPartySettingsId)

		DECLARE @KeyCount INT = (SELECT COUNT(1) FROM CounterPartySettings WHERE [Key] = @Key AND CompanyId = @CompanyId 
																		AND (@CounterPartySettingsId IS NULL OR @CounterPartySettingsId <> Id))
       
	    IF(@CounterPartySettingsIdCount = 0 AND @CounterPartySettingsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'CounterPartySettings')

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @CounterPartySettingsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM CounterPartySettings WHERE Id = @CounterPartySettingsId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@CounterPartySettingsId IS NULL)
							BEGIN

							SET @CounterPartySettingsId = NEWID()

							INSERT INTO [dbo].[CounterPartySettings](
                                                              [Id],
						                                      [CompanyId],
															  [ClientId],
						                                      [Key],
															  [Value],
															  [Description],						 
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
															  [IsVisible]
															  )
                                                       SELECT @CounterPartySettingsId,
						                                      @CompanyId,
															  @ClientId,
						                                      @Key,
															  @Value,
															  @Description, 
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @IsVisible
		                     
							END
							ELSE
							BEGIN

							  UPDATE [CounterPartySettings]
							      SET CompanyId = @CompanyId,
								      [ClientId] = @ClientId,
								      [Key] = @Key,
									  [Value] = @Value,
									  [Description] = @Description,
									  InactiveDateTime = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  IsVisible= @IsVisible
									  WHERE Id = @CounterPartySettingsId

							END
			                
			              SELECT Id FROM [dbo].[CounterPartySettings] WHERE Id = @CounterPartySettingsId
			                       
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