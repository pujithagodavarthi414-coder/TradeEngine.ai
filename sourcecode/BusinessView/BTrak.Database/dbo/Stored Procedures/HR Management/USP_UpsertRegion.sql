-------------------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update SoftLabel
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertRegion]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@RegionName = 'test',
--@CountryId = '7032EDC0-C5BF-4EAB-8025-285AFECB5292' ,@IsArchived = 0
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRegion]
(
   @RegionId UNIQUEIDENTIFIER = NULL,
   @RegionName NVARCHAR(800)  = NULL,  
   @CountryId UNIQUEIDENTIFIER  = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

		IF(@RegionName = '') SET @RegionName = NULL

	    IF(@RegionName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'RegionName')

		END
		ELSE IF(@CountryId IS NULL)
		BEGIN

		  RAISERROR(50011,16, 2,'Country')

		END
		ELSE
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @RegionCount INT = (SELECT COUNT(1) FROM Region  WHERE Id = @RegionId)
        
		DECLARE @RegionameCount INT = (SELECT COUNT(1) FROM Region WHERE RegionName = @RegionName
		                                   AND CompanyId = @CompanyId AND CountryId = @CountryId AND (@RegionId IS NULL OR Id <> @RegionId)) 

        IF(@RegionCount = 0 AND @RegionId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'Region')

        END
		ELSE IF(@RegionameCount > 0)
        BEGIN
        
          RAISERROR(50001,16,1,'Region')
           
        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @RegionId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [Region] WHERE Id = @RegionId ) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
					   IF(@RegionId IS NULL)
					   BEGIN

					   SET @RegionId = NEWID()

                       INSERT INTO [dbo].[Region](
                                   [Id],
                                   [CompanyId],
                                   [RegionName],
                                   [CountryId],
                                   [InActiveDateTime],
                                   [CreatedDateTime],
                                   [CreatedByUserId]
								   )
                            SELECT @RegionId,
                                   @CompanyId,
                                   @RegionName,
                                   @CountryId,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy
				       END
					   ELSE
					   BEGIN

					   UPDATE [Region]
					     SET [CompanyId] = @CompanyId,
						     [RegionName] = @RegionName,
							 [CountryId] = @CountryId,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [UpdatedByUserId] = @OperationsPerformedBy
							 WHERE Id = @RegionId

					   END
                            
                         SELECT Id Id FROM [dbo].[Region] WHERE Id = @RegionId
                                   
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