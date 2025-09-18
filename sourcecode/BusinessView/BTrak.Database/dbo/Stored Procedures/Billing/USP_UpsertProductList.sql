---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertAccessisbleIpAdresses]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@Name = 'Test',@IsArchived = 0,@IpAddress='10.2.3.0'
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProductList]
(
   @ProductId UNIQUEIDENTIFIER = NULL,
   @ProductName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		IF(@ProductName = '') SET @ProductName = NULL
		IF(@ProductName IS NULL)
        BEGIN
            RAISERROR(50011,16, 2, 'Name')
        END
        ELSE
        BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'

	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	    DECLARE @ProductIdIdCount INT = (SELECT COUNT(1) FROM [MasterProduct]  WHERE Id = @ProductId)
        DECLARE @NameCount INT = (SELECT COUNT(1) FROM [MasterProduct] WHERE  [Name] = @ProductName AND CompanyId = @CompanyId AND (@ProductId IS NULL OR Id <> @ProductId))
        IF(EXISTS(SELECT Id FROM BillingGrade WHERE ProductId = @ProductId AND @IsArchived=1))
	    BEGIN
	    
	    SET @IsEligibleToArchive = 'ThisProductUsedInGradeDeleteTheDependenciesAndTryAgain'
	    RAISERROR (@isEligibleToArchive,11, 1)
	    END
        
        ELSE IF(@ProductIdIdCount = 0 AND @ProductId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'ProductId')
        END
        ELSE IF(@NameCount>0)
        BEGIN
          RAISERROR(50001,16,1,'Product')
         END
         ELSE
          BEGIN
                     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                     IF (@HavePermission = '1')
                     BEGIN
                        DECLARE @IsLatest BIT = (CASE WHEN @ProductId IS NULL
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [MasterProduct] WHERE Id = @ProductId ) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                         IF(@IsLatest = 1)
                         BEGIN
                             DECLARE @Currentdate DATETIME = GETDATE()

		IF(@ProductId IS NULL)
		BEGIN

			SET @ProductId = NEWID()
             INSERT INTO [dbo].[MasterProduct](
                         [Id],
                         [CompanyId],
                         [Name],
                         [InActiveDateTime],
                         [CreatedDateTime],
                         [CreatedByUserId]
                         )
                  SELECT @ProductId,
                         @CompanyId,
                         @ProductName,
                         CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         @Currentdate,
                         @OperationsPerformedBy

		END
		ELSE
		BEGIN

				UPDATE [dbo].[MasterProduct]
					SET [CompanyId]			  =     @CompanyId,
                         [Name]				  =     @ProductName,
                         [InActiveDateTime]	  =     CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         [UpdatedDateTime]	  =     @Currentdate,
                         [UpdatedByUserId]	  =     @OperationsPerformedBy
						WHERE Id = @ProductId

		END
                         SELECT Id FROM [dbo].[MasterProduct] WHERE Id = @ProductId
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
