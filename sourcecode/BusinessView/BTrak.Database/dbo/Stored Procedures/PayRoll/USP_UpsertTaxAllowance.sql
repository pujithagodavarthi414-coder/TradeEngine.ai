-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update TaxAllowance
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertTaxAllowance] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ComponentName='Test',@IsDeduction = 0,@IsVariablePay = 0			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTaxAllowance]
(
   @TaxAllowanceId UNIQUEIDENTIFIER = NULL,
   @Name NVARCHAR(250) = NULL,
   @TaxAllowanceTypeId UNIQUEIDENTIFIER = NULL,
   @IsPercentage BIT = NULL,
   @MaxAmount DECIMAL(18,4) = NULL,
   @PercentageValue DECIMAL(18,4) = NULL,
   @ParentId UNIQUEIDENTIFIER = NULL,
   @PayRollComponentId UNIQUEIDENTIFIER = NULL,
   @ComponentId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @FromDate DATETIME = NULL,
   @ToDate DATETIME = NULL,
   @OnlyEmployeeMaxAmount DECIMAL(18,4) = NULL,
   @MetroMaxPercentage DECIMAL(18,4) = NULL,
   @LowestAmountOfParentSet BIT = NULL,
   @IsArchived BIT,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @CountryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@IsArchived = 1 AND @TaxAllowanceId IS NOT NULL)
		BEGIN
		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	          IF(EXISTS(SELECT Id FROM TaxAllowances WHERE ParentId = @TaxAllowanceId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisTaxAllowanceUsedASParentTaxAllowancePleaseDeleteTheDependenciesAndTryAgain'
	          END
			  IF(EXISTS(SELECT Id FROM EmployeeTaxAllowances WHERE TaxAllowanceId = @TaxAllowanceId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisTaxAllowanceUsedInEmployeeTaxAllowancesPleaseDeleteTheDependenciesAndTryAgain'
	          END 
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		         RAISERROR (@isEligibleToArchive,11, 1)
		     END
	    END

		 IF(@ParentId IS NOT NULL AND EXISTS(SELECT Id FROM TaxAllowances WHERE ParentId = @TaxAllowanceId))
	     BEGIN
		 RAISERROR ('ParentTaxAllowanceAlertMessage',11, 1)
	     END

	    IF(@Name IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Name')

		END
		ELSE IF(@TaxAllowanceTypeId IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'TaxAllowanceTypeId')

		END
		ELSE IF(@CountryId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @TaxAllowanceDuplicateCount INT = (SELECT COUNT(1) FROM TaxAllowances WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxAllowanceId OR @TaxAllowanceId IS NULL))

		DECLARE @TaxAllowanceIdCount INT = (SELECT COUNT(1) FROM TaxAllowances  WHERE Id = @TaxAllowanceId)

		DECLARE @TaxAllowanceCount INT = 0

        IF(@ToDate IS NULL)
        BEGIN
        
        	SET @TaxAllowanceCount = (SELECT COUNT(1) FROM TaxAllowances WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxAllowanceId OR @TaxAllowanceId IS NULL) AND
        																				((@FromDate <= FromDate AND (ToDate IS NULL OR @FromDate <= ToDate ) AND @ToDate IS NULL)
        																				OR (@FromDate >= FromDate AND (ToDate IS NULL OR @FromDate <= ToDate ) AND @ToDate IS NULL)))
        END
        IF(@ToDate IS NOT NULL)
        BEGIN
        
        	SET @TaxAllowanceCount = (SELECT COUNT(1) FROM TaxAllowances WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxAllowanceId OR @TaxAllowanceId IS NULL) AND
        																				((@FromDate <= FromDate AND @ToDate >= FromDate AND (ToDate IS NULL OR (@ToDate <= ToDate AND @ToDate >= FromDate )))
        																				OR (@FromDate <= FromDate AND @ToDate >= FromDate AND (ToDate IS NULL OR (@ToDate >= ToDate AND @ToDate >= FromDate )))
        																				OR (@FromDate >= FromDate AND @ToDate >= FromDate AND (ToDate IS NULL OR (@ToDate <= ToDate AND @ToDate >= FromDate )))
        																				OR (@FromDate >= FromDate AND @ToDate >= FromDate AND (ToDate IS NULL OR (@ToDate >= ToDate AND @ToDate >= FromDate AND @FromDate <= ToDate)))))
        
        END
       
	    IF(@TaxAllowanceIdCount = 0 AND @TaxAllowanceId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'TaxAllowance')

        END
		IF (@TaxAllowanceDuplicateCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'TaxAllowance')

		END
		IF (@TaxAllowanceCount > 0)
		BEGIN

			RAISERROR('TaxAllowancesActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)

		END
        ELSE        
		BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @TaxAllowanceId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [TaxAllowances] WHERE Id = @TaxAllowanceId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                             IF(@TaxAllowanceId IS NULL)
							BEGIN

							SET @TaxAllowanceId = NEWID()

							INSERT INTO [dbo].[TaxAllowances](
							                  [Id],
							                  [Name],
							                  [TaxAllowanceTypeId],
							                  [IsPercentage],
							                  [MaxAmount],
							                  [PercentageValue], 
							                  [ParentId],
							                  [PayRollComponentId],
											  [ComponentId],
							                  [FromDate],
							                  [ToDate],
							                  [OnlyEmployeeMaxAmount],
							                  [MetroMaxPercentage],
							                  [LowestAmountOfParentSet],
							                  [InactiveDateTime],
							                  [CreatedDateTime],
							                  [CreatedByUserId],
											  [CountryId])
                                       SELECT @TaxAllowanceId,
										      @Name,
										      @TaxAllowanceTypeId,
										      @IsPercentage,
										      @MaxAmount,
										      @PercentageValue, 
										      @ParentId,
										      @PayRollComponentId,
											  @ComponentId,
										      @FromDate,
										      @ToDate,
										      @OnlyEmployeeMaxAmount,
										      @MetroMaxPercentage,
										      @LowestAmountOfParentSet,
						                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                      @Currentdate,
						                      @OperationsPerformedBy,
											  @CountryId
		                     
							END
							ELSE
							BEGIN

							  UPDATE [TaxAllowances]           
							     SET [Name] = @Name,
									 [TaxAllowanceTypeId] = @TaxAllowanceTypeId,
									 [IsPercentage] = @IsPercentage,
									 [MaxAmount] = @MaxAmount,
									 [PercentageValue] = @PercentageValue, 
									 [ParentId] = @ParentId,
									 [PayRollComponentId] = @PayRollComponentId,
									 [ComponentId] = @ComponentId,
									 [FromDate] = @FromDate,
									 [ToDate] = @ToDate,
									 [OnlyEmployeeMaxAmount] = @OnlyEmployeeMaxAmount,
									 [MetroMaxPercentage] = @MetroMaxPercentage,
									 [LowestAmountOfParentSet] = @LowestAmountOfParentSet,
									 [InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy,
									 [CountryId] = @CountryId
									 WHERE Id = @TaxAllowanceId

							END
			                
			                 SELECT Id FROM [dbo].[TaxAllowances] WHERE Id = @TaxAllowanceId
			                       
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