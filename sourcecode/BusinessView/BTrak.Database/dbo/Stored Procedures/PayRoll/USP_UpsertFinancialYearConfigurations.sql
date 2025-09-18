-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update FinancialYearConfigurations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertFinancialYearConfigurations] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ComponentName='Test',@IsDeduction = 0,@IsVariablePay = 0			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFinancialYearConfigurations]
(
   @FinancialYearConfigurationsId UNIQUEIDENTIFIER = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @FromMonth [decimal](18,4) = NULL,
   @ToMonth [decimal] (18,4) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @FinancialYearTypeId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


		DECLARE @FinancialYearConfigurationsIdCount INT = (SELECT COUNT(1) FROM FinancialYearConfigurations  WHERE Id = @FinancialYearConfigurationsId)

	    IF(@CountryId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Country')

		END
		ELSE IF(@FromMonth IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'FromMonth')
        END
		ELSE IF(@ToMonth IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'ToMonth')

		END
		ELSE IF(@ActiveFrom IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'ActiveFrom')
        END	
		ELSE
		BEGIN

		DECLARE @FinancialYearConfigurationsCount INT = 0

		IF(@ActiveTo IS NULL)
		BEGIN

			SET @FinancialYearConfigurationsCount = (SELECT COUNT(1) FROM FinancialYearConfigurations WHERE CountryId = @CountryId AND FinancialYearTypeId = @FinancialYearTypeId AND (Id <> @FinancialYearConfigurationsId OR @FinancialYearConfigurationsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

			SET @FinancialYearConfigurationsCount = (SELECT COUNT(1) FROM FinancialYearConfigurations WHERE CountryId = @CountryId AND FinancialYearTypeId = @FinancialYearTypeId AND (Id <> @FinancialYearConfigurationsId OR @FinancialYearConfigurationsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

	    IF(@FinancialYearConfigurationsIdCount = 0 AND @FinancialYearConfigurationsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'FinancialYearConfigurations')

        END
		IF(@FinancialYearConfigurationsCount > 0)
        BEGIN

            RAISERROR('FinancialYearConfigurationsActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @FinancialYearConfigurationsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [FinancialYearConfigurations] WHERE Id = @FinancialYearConfigurationsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@FinancialYearConfigurationsId IS NULL)
							BEGIN

							SET @FinancialYearConfigurationsId = NEWID()

							INSERT INTO [dbo].[FinancialYearConfigurations](
                                                              [Id],
															  [CountryId], 
															  [FromMonth],
															  [ToMonth],
															  [FinancialYearTypeId],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
															  [ActiveFrom],
                                                              [ActiveTo]
															  )
                                                       SELECT @FinancialYearConfigurationsId,
															  @CountryId, 
															  @FromMonth,
															  @ToMonth,
															  @FinancialYearTypeId,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @ActiveFrom,
                                                              @ActiveTo
		                     
							END
							ELSE
							BEGIN

							  UPDATE [FinancialYearConfigurations]
							      SET [CountryId] = @CountryId, 
									  [FromMonth] = @FromMonth,
									  [ToMonth] = @ToMonth,
									  [FinancialYearTypeId] = @FinancialYearTypeId,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  [ActiveFrom] = @ActiveFrom,
                                      [ActiveTo]  = @ActiveTo
									  WHERE Id = @FinancialYearConfigurationsId

							END
			                
			              SELECT Id FROM [dbo].[FinancialYearConfigurations] WHERE Id = @FinancialYearConfigurationsId
			                       
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
