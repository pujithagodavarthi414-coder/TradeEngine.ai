-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollCalculationConfigurations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPayRollCalculationConfigurations] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@PeriodTypeId='Test',@BranchId = 0		  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollCalculationConfigurations]
(
   @PayRollCalculationConfigurationsId UNIQUEIDENTIFIER = NULL,
   @PeriodTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @BranchId  UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @PayRollCalculationTypeId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@PeriodTypeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'PeriodType')

		END
		ELSE IF(@BranchId IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@PayRollCalculationTypeId IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'PayRollCalculationType')

		END
		ELSE IF(@ActiveFrom IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'ActiveFrom')
        END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PayRollCalculationConfigurationsIdCount INT = (SELECT COUNT(1) FROM PayRollCalculationConfigurations  WHERE Id = @PayRollCalculationConfigurationsId)
	   
		DECLARE @PayRollCalculationConfigurationsCount INT = 0

		IF(@ActiveTo IS NULL)
		BEGIN

			SET @PayRollCalculationConfigurationsCount = (SELECT COUNT(1) FROM PayRollCalculationConfigurations WHERE BranchId = @BranchId AND PayRollCalculationTypeId = @PayRollCalculationTypeId AND (Id <> @PayRollCalculationConfigurationsId OR @PayRollCalculationConfigurationsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

			SET @PayRollCalculationConfigurationsCount = (SELECT COUNT(1) FROM PayRollCalculationConfigurations WHERE BranchId = @BranchId AND PayRollCalculationTypeId = @PayRollCalculationTypeId AND (Id <> @PayRollCalculationConfigurationsId OR @PayRollCalculationConfigurationsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

	    IF(@PayRollCalculationConfigurationsIdCount = 0 AND @PayRollCalculationConfigurationsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollCalculationConfigurations')

        END
		IF(@PayRollCalculationConfigurationsCount > 0)
        BEGIN

            RAISERROR('PayRollCalculationConfigurationsActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @PayRollCalculationConfigurationsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [PayRollCalculationConfigurations] WHERE Id = @PayRollCalculationConfigurationsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@PayRollCalculationConfigurationsId IS NULL)
							BEGIN

							SET @PayRollCalculationConfigurationsId = NEWID()

							INSERT INTO [dbo].[PayRollCalculationConfigurations](
                                                              [Id],
						                                      [PeriodTypeId],
															  [BranchId],
															  [PayRollCalculationTypeId],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],.
															  [ActiveFrom],
                                                              [ActiveTo]
															  )
                                                       SELECT @PayRollCalculationConfigurationsId,
						                                      @PeriodTypeId,
															  @BranchId,
															  @PayRollCalculationTypeId,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @ActiveFrom,
															  @ActiveTo
		                     
							END
							ELSE
							BEGIN

							  UPDATE [PayRollCalculationConfigurations]
							      SET [PeriodTypeId] = @PeriodTypeId,
									  [BranchId] = @BranchId,
									  [PayRollCalculationTypeId] =@PayRollCalculationTypeId,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  [ActiveFrom] = @ActiveFrom,
                                      [ActiveTo]  = @ActiveTo
									  WHERE Id = @PayRollCalculationConfigurationsId

							END
			                
			              SELECT Id FROM [dbo].[PayRollCalculationConfigurations] WHERE Id = @PayRollCalculationConfigurationsId
			                       
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
