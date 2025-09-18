-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update the Currency
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertCurrency] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @CurrencyName = 'Indian Rupee',@CurrencyCode='INR'                                 
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertCurrency]
(
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @CurrencyName NVARCHAR(500) = NULL, 
   @CurrencyCode NVARCHAR(500) = NULL ,
   @CurrencySymbol NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
        IF(@CurrencyName = '') SET @CurrencyName = NULL
        IF(@IsArchived = 1 AND @CurrencyId IS NOT NULL)
        BEGIN
        
         DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
         
         IF(EXISTS(SELECT Id FROM [User] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInUserPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [Asset] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInAssetPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [CanteenFoodItem] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInCanteenFoodItemPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [EmployeeMembership] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInEmployeeMemberShipPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [EmployeeSalary] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInEmployeeSalaryPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [Company] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInCompanyPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         --ELSE IF(EXISTS(SELECT Id FROM [Company] WHERE CurrencyId = @CurrencyId))
         --BEGIN
         
         --SET @IsEligibleToArchive = 'ThisCurrencyUsedInCompanyPleaseDeleteTheDependenciesAndTryAgain'
         
         --END
         ELSE IF(EXISTS(SELECT Id FROM [Expense] WHERE CurrencyId = @CurrencyId))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInExpensePleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [CurrencyConversion] WHERE (CurrencyFromId = @CurrencyId OR CurrencyToId = @CurrencyId)))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInCurrencyConversionPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         ELSE IF(EXISTS(SELECT Id FROM [Branch] WHERE CurrencyId = @CurrencyId AND InActiveDateTime IS NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCurrencyUsedInBranchPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END
        END
        IF(@CurrencyName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'CurrencyName')
        END
        ELSE 
        BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        DECLARE @CurrencyIdCount INT = (SELECT COUNT(1) FROM Currency  WHERE Id = @CurrencyId AND CompanyId = @CompanyId)
        
        DECLARE @CurrencyNameCount INT = (SELECT COUNT(1) FROM Currency WHERE CurrencyName = @CurrencyName AND (@CurrencyId IS NULL OR Id <> @CurrencyId) AND CompanyId= @CompanyId)       
       
        IF(@CurrencyIdCount = 0 AND @CurrencyId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'Currency')
        END
        ELSE IF(@CurrencyNameCount>0)
        BEGIN
        
          RAISERROR(50001,16,1,'Currency')
           
         END
         ELSE
          BEGIN
       
                    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
                     IF (@HavePermission = '1')
                     BEGIN
                        
                        DECLARE @IsLatest BIT = (CASE WHEN @CurrencyId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [Currency] WHERE Id = @CurrencyId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                         IF(@IsLatest = 1)
                        BEGIN
                     
                             DECLARE @Currentdate DATETIME = GETDATE()
                             
			IF (@CurrencyId IS NULL)        
            BEGIN

			SET @CurrencyId = NEWID()
			
			INSERT INTO [dbo].[Currency](
                         [Id],
                         [CompanyId],
                         [CurrencyName],
                         [CurrencyCode],
                         [Symbol],
                         [InActiveDateTime],
                         [CreatedDateTime],
                         [CreatedByUserId]                
                         )
                  SELECT @CurrencyId,
                         @CompanyId,
                         @CurrencyName,
                         @CurrencyCode,
                         @CurrencySymbol,
                         CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         @Currentdate,
                         @OperationsPerformedBy        
                            
			END
			ELSE
			BEGIN

					UPDATE [dbo].[Currency]
						SET  [CompanyId]	  =  		  @CompanyId,
                         [CurrencyName]		  =  		  @CurrencyName,
                         [CurrencyCode]		  =  		  @CurrencyCode,
                         [Symbol]			  =  		  @CurrencySymbol,
                         [InActiveDateTime]	  =  		  CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                         [UpdatedDateTime]	  =  		  @Currentdate,
                         [UpdatedByUserId]    =        	  @OperationsPerformedBy        
						WHERE Id = @CurrencyId
			END
                         SELECT Id FROM [dbo].[Currency] WHERE Id = @CurrencyId
                                   
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