-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollComponent
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPayRollComponent] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ComponentName='Test',@IsDeduction = 0,@IsVariablePay = 0			  
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertPayRollComponent]
(
   @PayRollComponentId UNIQUEIDENTIFIER = NULL,
   @ComponentName NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsDeduction BIT,
   @IsVariablePay BIT,
   @IsVisible BIT,
   @Description NVARCHAR(500) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @EmployeeContributionPercentage DECIMAL(18,4) NULL,
   @EmployerContributionPercentage DECIMAL(18,4) NULL,
   @RelatedToContributionPercentage BIT
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@IsArchived = 1 AND @PayRollComponentId IS NOT NULL)
		BEGIN
		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	          IF(EXISTS(SELECT Id FROM PayrollTemplateConfiguration WHERE PayRollComponentId = @PayRollComponentId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollComponentUsedInPayRollTemplateConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	          END
			   IF(EXISTS(SELECT Id FROM PayrollTemplateConfiguration WHERE DependentPayrollComponentId = @PayRollComponentId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollComponentUsedInPayRollTemplateConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          ELSE IF(EXISTS(SELECT Id FROM PayrollRunEmployeeComponent WHERE ComponentId = @PayRollComponentId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollComponentUsedInPayRollRunEmployeeComponentPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          IF(EXISTS(SELECT Id FROM TaxAllowances WHERE PayRollComponentId = @PayRollComponentId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollComponentUsedInTaxAllowancePleaseDeleteTheDependenciesAndTryAgain'
	          END
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		         RAISERROR (@isEligibleToArchive,11, 1)
		     END
	    END

	    IF(@ComponentName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'ComponentName')

		END
		ELSE IF(@IsDeduction IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'IsDeduction')

		END
		ELSE IF(@IsVariablePay IS NULL)
		BEGIN
		   
		   RAISERROR(50011,16, 2, 'IsVariablePay')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PayRollComponentIdCount INT = (SELECT COUNT(1) FROM PayRollComponent  WHERE Id = @PayRollComponentId)

		DECLARE @PayRollComponentCount INT = (SELECT COUNT(1) FROM PayRollComponent WHERE [ComponentName] = @ComponentName AND CompanyId = @CompanyId 
																		AND (@PayRollComponentId IS NULL OR @PayRollComponentId <> Id))
       
	    IF(@PayRollComponentIdCount = 0 AND @PayRollComponentId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollComponent')

        END
		IF (@PayRollComponentCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'PayRollComponent')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @PayRollComponentId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [PayRollComponent] WHERE Id = @PayRollComponentId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@PayRollComponentId IS NULL)
							BEGIN

							SET @PayRollComponentId = NEWID()

							INSERT INTO [dbo].[PayRollComponent](
                                                              [Id],
						                                      [CompanyId],
						                                      [ComponentName],
															  [IsDeduction],
															  [IsVariablePay],	
															  [EmployeeContributionPercentage],
															  [EmployerContributionPercentage],
															  [IsVisible],
															  [RelatedToContributionPercentage],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @PayRollComponentId,
						                                      @CompanyId,
						                                      @ComponentName,
															  @IsDeduction,
															  @IsVariablePay, 
															  @EmployeeContributionPercentage,
															  @EmployerContributionPercentage,
															  @IsVisible,
															  @RelatedToContributionPercentage,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [PayRollComponent]
							      SET CompanyId = @CompanyId,
								      [ComponentName] = @ComponentName,
									  [IsDeduction] = @IsDeduction,
									  [IsVariablePay] = @IsVariablePay,
									  [IsVisible] = @IsVisible,
									  [EmployeeContributionPercentage] = @EmployeeContributionPercentage,
								      [EmployerContributionPercentage] = @EmployerContributionPercentage,
									  [RelatedToContributionPercentage] = @RelatedToContributionPercentage,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @PayRollComponentId

							END
			                
			              SELECT Id FROM [dbo].[PayRollComponent] WHERE Id = @PayRollComponentId
			                       
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