-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-09-19 00:00:00.000'
-- Purpose      To Save or Update CompanySettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCompanySettings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@Key='Test',@Description = 'Description',@Value = 'fvhvwh'			  
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertCompanySettings]
(
   @CompanySettingsId UNIQUEIDENTIFIER = NULL,
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

		IF(@CompanySettingsId IS NULL OR @CompanySettingsId = '00000000-0000-0000-0000-000000000000')
		BEGIN
			SET @CompanySettingsId = (SELECT Id FROM CompanySettings  WHERE CompanyId = @CompanyId AND [Key] = @Key)
			IF(@CompanySettingsId = '00000000-0000-0000-0000-000000000000') SET @CompanySettingsId = NULL
			
			IF(@CompanySettingsId IS NOT NULL) SET @TimeStamp = (SELECT [TimeStamp] FROM CompanySettings  WHERE Id = @CompanySettingsId)
		END

		DECLARE @CompanySettingsIdCount INT = (SELECT COUNT(1) FROM CompanySettings  WHERE Id = @CompanySettingsId)

		DECLARE @KeyCount INT = (SELECT COUNT(1) FROM CompanySettings WHERE [Key] = @Key AND CompanyId = @CompanyId 
																		AND (@CompanySettingsId IS NULL OR @CompanySettingsId <> Id))
       
	    IF(@CompanySettingsIdCount = 0 AND @CompanySettingsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'CompanySettings')

        END
		IF (@KeyCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'Key')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @CompanySettingsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [CompanySettings] WHERE Id = @CompanySettingsId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@CompanySettingsId IS NULL)
							BEGIN

							SET @CompanySettingsId = NEWID()

							INSERT INTO [dbo].[CompanySettings](
                                                              [Id],
						                                      [CompanyId],
						                                      [Key],
															  [Value],
															  [Description],						 
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @CompanySettingsId,
						                                      @CompanyId,
						                                      @Key,
															  @Value,
															  @Description, 
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [CompanySettings]
							      SET CompanyId = @CompanyId,
								      [Key] = @Key,
									  [Value] = @Value,
									  [Description] = @Description,
									  InactiveDateTime = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  IsVisible= @IsVisible
									  WHERE Id = @CompanySettingsId
								IF( @Key = 'DefaultLanguage')
									BEGIN
										UPDATE [Company] SET [Language] = @Value WHERE Id = @CompanyId
									END

							END
			                
			              SELECT Id FROM [dbo].[CompanySettings] WHERE Id = @CompanySettingsId
			                       
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