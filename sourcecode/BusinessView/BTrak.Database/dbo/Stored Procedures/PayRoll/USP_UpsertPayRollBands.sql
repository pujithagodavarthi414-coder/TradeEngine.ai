CREATE PROCEDURE [dbo].[USP_UpsertPayRollBands]
(
@PayRollBandId UNIQUEIDENTIFIER,
@Name NVARCHAR(250),
@FromRange DECIMAL(18, 4),
@ToRange DECIMAL(18, 4),
@Percentage DECIMAL(18, 4),
@ActiveFrom DATETIME,
@ActiveTo DATETIME,
@IsArchived BIT,
@ParentId UNIQUEIDENTIFIER = null,
@CountryId UNIQUEIDENTIFIER = NULL,
@PayRollComponentId UNIQUEIDENTIFIER = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@TimeStamp TIMESTAMP = null,
@MinAge INT = null,
@MaxAge INT = null,
@ForMale BIT = null,
@ForFemale BIT = null,
@Handicapped BIT = null,
@IsMarried  BIT = null,
@Order INT = NULL
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
       
       IF(@IsArchived = 1 AND @PayRollBandId IS NOT NULL)
       BEGIN
          IF(EXISTS(SELECT Id FROM PayRollBands WHERE ParentId = @PayRollBandId))
          BEGIN
          SET @IsEligibleToArchive = 'ThisPayRollBandUsedASParentInPayRollBandsPleaseDeleteTheDependenciesAndTryAgain'
          END
          IF(@IsEligibleToArchive <> '1')
          BEGIN
             RAISERROR (@isEligibleToArchive,11, 1)
         END
       END
       	   
       DECLARE @PayRollBandsDuplicateCount INT = (SELECT COUNT(1) FROM PayRollBands WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @PayRollBandId OR @PayRollBandId IS NULL))
       
       DECLARE @PayRollBandsCount INT = 0
       DECLARE @PayRollBandsDuplicateRangeCount INT = 0
       
       SET @PayRollBandsDuplicateRangeCount = (SELECT COUNT(1) FROM PayRollBands WHERE CountryId = @CountryId AND ParentId = @ParentId AND (Id <> @PayRollBandId OR @PayRollBandId IS NULL)  
       	                                                                            AND ((FromRange = @FromRange) 
                                                                                            OR (ToRange = @ToRange)
                                                                                            OR (ToRange = @FromRange)
       																					 OR (FromRange = @ToRange)
                                                                                            OR (FromRange > @FromRange AND FromRange < @ToRange)
                                                                                            OR (FromRange < @FromRange AND ToRange > @FromRange)
                                                                                            OR (FromRange < @ToRange AND ToRange > @ToRange)))
       
       IF(@ActiveTo IS NULL)
       BEGIN
       
       	SET @PayRollBandsCount = (SELECT COUNT(1) FROM PayRollBands WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @PayRollBandId OR @PayRollBandId IS NULL) AND
       																				((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
       																				OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
       END
       IF(@ActiveTo IS NOT NULL)
       BEGIN
       
       	SET @PayRollBandsCount = (SELECT COUNT(1) FROM PayRollBands WHERE CountryId = @CountryId AND [Name] = @Name AND (Id <> @PayRollBandId OR @PayRollBandId IS NULL) AND
       																				((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
       																				OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))
       
       END
       
       
       
       DECLARE @ParentIdCount INT = 0
       
       
       DECLARE @Currentdate DATETIME = GETDATE()   
       
       DECLARE @OrderCount INT = 0
       
       IF(@ParentId IS NOT NULL AND @PayRollBandId IS NOT NULL)
       BEGIN
       
       SET @ParentIdCount = (SELECT COUNT(1) FROM PayRollBands WHERE ParentId = @PayRollBandId)
       END
       
       IF (@ParentIdCount > 0 AND @IsEligibleToArchive = 1)
       BEGIN
       
       	RAISERROR('PayRollBandParentAlreadyExists',11,1)
       
       END
       ELSE IF (@OrderCount > 0)
       BEGIN
       
       	RAISERROR('PriorityShouldBeUnique',11,1)
       
       END
       ELSE IF(@PayRollBandsDuplicateRangeCount > 0)
       BEGIN
            RAISERROR('PayRollBandWithThisRangeAlreadyExists',16, 1)
       END
       ELSE IF(@PayRollBandsCount > 0)
       BEGIN
            RAISERROR('PayRollBandsActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)
       END
       ELSE IF (@PayRollBandsDuplicateCount > 0)
       BEGIN
       
       	RAISERROR(50001,11,1,'PayRollBands')
       
       END
       
       ELSE
       BEGIN

	   
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
		IF (@HavePermission = '1')
		BEGIN
			         	
			      DECLARE @IsLatest BIT = (CASE WHEN @PayRollBandId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [PayRollBands] WHERE Id = @PayRollBandId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
	   IF(@IsLatest = 1)
	   BEGIN
			
			 
       IF(@PayRollBandId IS NULL)
       BEGIN
       
                SET @PayRollBandId = NEWID()
                
                INSERT INTO PayRollBands (
				       Id, 
				       [Name], 
				       FromRange, 
				       ToRange, 
					   [Percentage],
				       ActiveFrom, 
				       ActiveTo, 
				       ParentId,
				       CountryId,
					   PayRollComponentId,
					   MinAge, 
				       MaxAge, 
				       ForMale, 
				       ForFemale, 
				       Handicapped,
					   IsMarried,
					   [Order],
					   InactiveDateTime,
					   CreatedByUserId,
					   CreatedDateTime)
                values(@PayRollBandId, 
                       @Name, 
                       @FromRange, 
                       @ToRange, 
					   @Percentage,
                       @ActiveFrom, 
                       @ActiveTo, 
                       @ParentId,
                       @CountryId,
					   @PayRollComponentId,
					   @MinAge, 
				       @MaxAge, 
				       @ForMale, 
				       @ForFemale, 
				       @Handicapped, 
					   @IsMarried,
					   @Order,
					   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
					   @OperationsPerformedBy,
					   @CurrentDate)
       
       END
       ELSE
       BEGIN
       
                UPDATE PayRollBands 
                      SET [Name] = @Name, 
                      FromRange = @FromRange, 
                      ToRange = @ToRange, 
					  [Percentage] = @Percentage,
                      ActiveFrom = @ActiveFrom, 
                      ActiveTo = @ActiveTo, 
                      InactiveDateTime =  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                      ParentId = @ParentId,
                      CountryId = @CountryId,
					  MinAge = @MinAge, 
				      MaxAge = @MaxAge, 
				      ForMale = @ForMale, 
				      ForFemale = @ForFemale, 
				      Handicapped = @Handicapped,
					  IsMarried = @IsMarried,
					  [Order] = @Order,
					  PayRollComponentId = @PayRollComponentId,
					  UpdatedByUserId = @OperationsPerformedBy,
					  UpdatedDateTime = @CurrentDate
                      WHERE Id = @PayRollBandId
                
                SELECT Id FROM PayRollBands WHERE Id = @PayRollBandId
       
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
