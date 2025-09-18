CREATE PROCEDURE [dbo].[USP_UpsertTaxSlabs]
(
@TaxSlabId UNIQUEIDENTIFIER = null,
@Name nvarchar(150) = null,
@FromRange decimal(18, 4) = null,
@ToRange decimal(18, 4) = null,
@TaxPercentage decimal(10, 4) = null,
@ActiveFrom datetime = null,
@ActiveTo datetime = null,
@MinAge int = null,
@MaxAge int = null,
@ForMale bit = null,
@ForFemale bit = null,
@Handicapped bit = null,
@Order int = null,
@IsArchived bit = null,
@ParentId uniqueidentifier = null,
@CountryId UNIQUEIDENTIFIER = NULL,
@PayRollTemplateIds XML = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsFlatRate bit = null,
@TimeStamp timestamp = null,
@TaxCalculationTypeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

       IF(@CountryId IS NULL)
       BEGIN
       
       RAISERROR(50011,16, 2, 'Country')
       
       END
       ELSE
       BEGIN
       DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
       
       IF(@IsArchived = 1 AND @TaxSlabId IS NOT NULL)
       BEGIN
          IF(EXISTS(SELECT Id FROM TaxSlabs WHERE ParentId = @TaxSlabId))
          BEGIN
          SET @IsEligibleToArchive = 'ThisTaxSlabUsedASParentInTaxSlabsPleaseDeleteTheDependenciesAndTryAgain'
          END
          IF(@IsEligibleToArchive <> '1')
          BEGIN
             RAISERROR (@isEligibleToArchive,11, 1)
         END
       END
       	   
       DECLARE @TaxSlabsDuplicateCount INT = (SELECT COUNT(1) FROM TaxSlabs WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxSlabId OR @TaxSlabId IS NULL))
       
       DECLARE @TaxSlabsCount INT = 0
       DECLARE @TaxSlabsDuplicateRangeCount INT = 0
       
       SET @TaxSlabsDuplicateRangeCount = (SELECT COUNT(1) FROM TaxSlabs WHERE CountryId = @CountryId AND ParentId = @ParentId AND (Id <> @TaxSlabId OR @TaxSlabId IS NULL)  
       	                                                                            AND ((FromRange = @FromRange) 
                                                                                            OR (ToRange = @ToRange)
                                                                                            OR (ToRange = @FromRange)
       																					 OR (FromRange = @ToRange)
                                                                                            OR (FromRange > @FromRange AND FromRange < @ToRange)
                                                                                            OR (FromRange < @FromRange AND ToRange > @FromRange)
                                                                                            OR (FromRange < @ToRange AND ToRange > @ToRange)))
       
       IF(@ActiveTo IS NULL)
       BEGIN
       
       	SET @TaxSlabsCount = (SELECT COUNT(1) FROM TaxSlabs WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxSlabId OR @TaxSlabId IS NULL) AND
       																				((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
       																				OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
       END
       IF(@ActiveTo IS NOT NULL)
       BEGIN
       
       	SET @TaxSlabsCount = (SELECT COUNT(1) FROM TaxSlabs WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @TaxSlabId OR @TaxSlabId IS NULL) AND
       																				((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))
       
       END
       
       
       
       DECLARE @ParentIdCount INT = 0
       
       DECLARE @PayRollTemplateTaxSlabTable TABLE
       (
          PayRollTemplateTaxSlabId UNIQUEIDENTIFIER DEFAULT NEWID(),
          PayRollTemplateId UNIQUEIDENTIFIER,
          TaxSlabId UNIQUEIDENTIFIER
       )
       
       DECLARE @Currentdate DATETIME = GETDATE()   
       
       DECLARE @OrderCount INT = 0
       
       IF(@Order IS NOT NULL AND @IsEligibleToArchive = '1' AND @ParentIdCount = 0)
       BEGIN
       
       SET @OrderCount = (SELECT COUNT(1) FROM TaxSlabs WHERE [Order] = @Order AND CountryId = @CountryId AND (@TaxSlabId IS NULL OR @TaxSlabId <> Id))
       END
       
       IF(@ParentId IS NOT NULL AND @TaxSlabId IS NOT NULL)
       BEGIN
       
       SET @ParentIdCount = (SELECT COUNT(1) FROM TaxSlabs WHERE ParentId = @TaxSlabId)
       END
       
       IF (@ParentIdCount > 0 AND @IsEligibleToArchive = 1)
       BEGIN
       
       	RAISERROR('TaxSlabParentAlreadyExists',11,1)
       
       END
       ELSE IF (@OrderCount > 0)
       BEGIN
       
       	RAISERROR('PriorityShouldBeUnique',11,1)
       
       END
       ELSE IF(@TaxSlabsDuplicateRangeCount > 0)
       BEGIN
            RAISERROR('TaxSlabWithThisRangeAlreadyExists',16, 1)
       END
       ELSE IF(@TaxSlabsCount > 0)
       BEGIN
            RAISERROR('TaxSlabsActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)
       END
       ELSE IF (@TaxSlabsDuplicateCount > 0)
       BEGIN
       
       	RAISERROR(50001,11,1,'TaxSlabs')
       
       END
       
       ELSE
       BEGIN

	   
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
		IF (@HavePermission = '1')
		BEGIN
			         	
			      DECLARE @IsLatest BIT = (CASE WHEN @TaxSlabId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [TaxSlabs] WHERE Id = @TaxSlabId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
	   IF(@IsLatest = 1)
	   BEGIN
			
			 
       IF(@TaxSlabId IS NULL)
       BEGIN
       
                SET @TaxSlabId = NEWID()
                
                INSERT INTO TaxSlabs (
				       Id, 
				       [Name], 
				       FromRange, 
				       ToRange, 
				       TaxPercentage, 
				       ActiveFrom, 
				       ActiveTo, 
				       MinAge, 
				       MaxAge, 
				       ForMale, 
				       ForFemale, 
				       Handicapped, 
				       [Order], 
				       IsArchived,
				       IsFlatRate, 
				       ParentId,
				       CountryId,
					   CreatedByUserId,
					   CreatedDateTime,
					   TaxCalculationTypeId)
                values(@TaxSlabId, 
                       @Name, 
                       @FromRange, 
                       @ToRange, 
                       @TaxPercentage, 
                       @ActiveFrom, 
                       @ActiveTo, 
                       @MinAge, 
                       @MaxAge, 
                       @ForMale, 
                       @ForFemale, 
                       @Handicapped, 
                       @Order, 
                       0,
                       @IsFlatRate, 
                       @ParentId,
                       @CountryId,
					   @OperationsPerformedBy,
					   @CurrentDate,
					   @TaxCalculationTypeId)
       
       END
       ELSE
       BEGIN
       
                UPDATE TaxSlabs 
                      SET [Name] = @Name, 
                      FromRange = @FromRange, 
                      ToRange = @ToRange, 
                      TaxPercentage = @TaxPercentage, 
                      ActiveFrom = @ActiveFrom, 
                      ActiveTo = @ActiveTo, 
                      MinAge = @MinAge, 
                      MaxAge = @MaxAge, 
                      ForMale = @ForMale, 
                      ForFemale = @ForFemale, 
                      Handicapped = @Handicapped, 
                      [Order] = @Order, 
                      IsArchived = @IsArchived,
                      IsFlatRate = @IsFlatRate, 
                      ParentId = @ParentId,
                      CountryId = @CountryId,
					  UpdatedByUserId = @OperationsPerformedBy,
					  UpdatedDateTime = @CurrentDate,
					  TaxCalculationTypeId = @TaxCalculationTypeId
                      WHERE Id = @TaxSlabId
                
                DELETE FROM PayRollTemplateTaxSlab WHERE TaxSlabId = @TaxSlabId
       
       END
       
       
                INSERT INTO @PayRollTemplateTaxSlabTable(PayRollTemplateId,TaxSlabId)
                SELECT x.y.value('(text())[1]', 'nvarchar(100)'),@TaxSlabId
                FROM @PayRollTemplateIds.nodes('/GenericListOfGuid/ListItems/guid') AS x(y)
                
                DECLARE @Count INT = (SELECT COUNT(*) FROM @PayRollTemplateTaxSlabTable)
       
       IF(@Count > 0)
       BEGIN
       
       
              INSERT INTO [dbo].[PayrollTemplateTaxSlab](
                          [Id],
                          [PayRollTemplateId],
                          [TaxSlabId],
                          [CreatedDateTime],
                          [CreatedByUserId])
                   SELECT PayRollTemplateTaxSlabId,
                          PayRollTemplateId,
                          TaxSlabId,
                          @Currentdate,
                          @OperationsPerformedBy
              FROM @PayRollTemplateTaxSlabTable
       
       END
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
END