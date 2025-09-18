-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update AccessisbleIpAdresses
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertAccessisbleIpAdresses]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@Name = 'Test',@IsArchived = 0,@IpAddress='10.2.3.0'
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertAccessisbleIpAdresses]
(
   @AccessisbleIpAdressesId UNIQUEIDENTIFIER = NULL,
   @Name NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IpAddress NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		IF(@Name = '') SET @Name = NULL
		IF(@Name IS NULL)
        BEGIN
            RAISERROR(50011,16, 2, 'Name')
        END
        ELSE
        BEGIN
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	    DECLARE @AccessisbleIpAdressesIdCount INT = (SELECT COUNT(1) FROM AccessisbleIpAdresses  WHERE Id = @AccessisbleIpAdressesId)
        DECLARE @NameCount INT = (SELECT COUNT(1) FROM AccessisbleIpAdresses WHERE  [Name] = @Name AND CompanyId = @CompanyId AND (@AccessisbleIpAdressesId IS NULL OR Id <> @AccessisbleIpAdressesId))
        DECLARE @IpCount INT = (SELECT COUNT(1) FROM AccessisbleIpAdresses WHERE  IpAddress = @IpAddress AND CompanyId = @CompanyId AND (@AccessisbleIpAdressesId IS NULL OR Id <> @AccessisbleIpAdressesId))
        IF(@AccessisbleIpAdressesIdCount = 0 AND @AccessisbleIpAdressesId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'AccessisbleIPAdresses')
        END
        ELSE IF(@NameCount>0)
        BEGIN
          RAISERROR(50001,16,1,'AccessisbleIPAdresses')
         END
		  ELSE IF(@IpCount>0)
        BEGIN
          RAISERROR(50001,16,1,'AccessisbleIP')
         END
         ELSE
          BEGIN
                     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                     IF (@HavePermission = '1')
                     BEGIN
                        DECLARE @IsLatest BIT = (CASE WHEN @AccessisbleIpAdressesId IS NULL
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [AccessisbleIpAdresses] WHERE Id = @AccessisbleIpAdressesId ) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                         IF(@IsLatest = 1)
                         BEGIN
                             DECLARE @Currentdate DATETIME = GETDATE()

		IF(@AccessisbleIpAdressesId IS NULL)
		BEGIN

			SET @AccessisbleIpAdressesId = NEWID()
             INSERT INTO [dbo].[AccessisbleIpAdresses](
                         [Id],
                         [CompanyId],
                         [Name],
                         [IpAddress],
                         [InActiveDateTime],
                         [CreatedDateTime],
                         [CreatedByUserId]
                         )
                  SELECT @AccessisbleIpAdressesId,
                         @CompanyId,
                         @Name,
                         @IpAddress,
                         CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         @Currentdate,
                         @OperationsPerformedBy

		END
		ELSE
		BEGIN

				UPDATE [dbo].[AccessisbleIpAdresses]
					SET [CompanyId]			  =     @CompanyId,
                         [Name]				  =     @Name,
                         [IpAddress]		  =     @IpAddress,
                         [InActiveDateTime]	  =     CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         [UpdatedDateTime]	  =     @Currentdate,
                         [UpdatedByUserId]	  =     @OperationsPerformedBy
						WHERE Id = @AccessisbleIpAdressesId

		END
                         SELECT Id FROM [dbo].[AccessisbleIpAdresses] WHERE Id = @AccessisbleIpAdressesId
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
