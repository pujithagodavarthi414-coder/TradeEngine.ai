-------------------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update SoftLabel
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCountry]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@CountryName = 'test',
--@CountryCode = 'IND' ,@IsArchived = 0
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertCountry]
(
   @CountryId UNIQUEIDENTIFIER = NULL,
   @CountryName NVARCHAR(800) = NULL,  
   @CountryCode NVARCHAR(100) = NULL,  
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

	    IF(@CountryName = '') SET @CountryName = NULL

		IF(@IsArchived = 1 AND @CountryId IS NOT NULL)
		BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM [Holiday] WHERE CountryId = @CountryId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInHolidayDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [Region] WHERE CountryId = @CountryId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInRegionDeleteTheDependenciesAndTryAgain'
	         
	         END
			 ELSE IF(EXISTS(SELECT Id FROM [Branch] WHERE CountryId = @CountryId AND InActiveDateTime IS NULL))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInBranchDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [EmployeeContactDetails] WHERE CountryId = @CountryId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInEmployeeContactDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [EmployeeEmergencyContact] WHERE CountryId = @CountryId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInEmployeeEmergencyDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [EmployeeImmigration] WHERE CountryId = @CountryId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInEmployeeImmigrationDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [Customer] WHERE CountryId = @CountryId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInCustomerDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [Company] WHERE CountryId = @CountryId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisCountryUsedInCompanyDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	    END

	    IF(@CountryName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CountryName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @CountryCount INT = (SELECT COUNT(1) FROM Country  WHERE Id = @CountryId )

		DECLARE @CountryNameCount INT = (SELECT COUNT(1) FROM Country WHERE CountryName = @CountryName 
		                                   AND CompanyId = @CompanyId AND (@CountryId IS NULL OR Id <> @CountryId)) 

		DECLARE @CountryCodeCount INT = (SELECT COUNT(1) FROM Country WHERE CountryCode = @CountryCode 
		                                   AND CompanyId = @CompanyId AND (@CountryId IS NULL OR Id <> @CountryId)) 
        
        IF(@CountryCount = 0 AND @CountryId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'Country')

        END
		ELSE IF(@CountryNameCount > 0)
        BEGIN
        
          RAISERROR(50001,16,1,'Country')
           
        END
		ELSE IF(@CountryCodeCount > 0)
        BEGIN
        
          RAISERROR(50001,16,1,'CountryCode')
           
        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @CountryId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [Country] WHERE Id = @CountryId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
                     IF(@CountryId IS NULL)
					 BEGIN

					 SET @CountryId = NEWID()

                       INSERT INTO [dbo].[Country](
                                   [Id],
                                   [CompanyId],
                                   [CountryName],
                                   [CountryCode],
                                   [InActiveDateTime],
                                   [CreatedDateTime],
                                   [CreatedByUserId]                 
                                   )
                            SELECT @CountryId,
                                   @CompanyId,
                                   @CountryName,
                                   @CountryCode,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                                   
						END
						ELSE
						BEGIN

						UPDATE [Country]
						   SET [CompanyId] = @CompanyId,
                               [CountryName] = @CountryName,
                               [CountryCode] = @CountryCode,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @CountryId

						END

                            
                         SELECT Id FROM [dbo].[Country] WHERE Id = @CountryId
                                   
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