-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-23 00:00:00.000'
-- Purpose      To Save or Update PayRollTemplateConfiguration
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPayRollTemplateConfiguration] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@PayRollComponentId='B686EB00-445A-432C-9519-6CCA3E20462E',
-- @PayRollTemplateId='85B5F9A0-1DD4-4C78-8745-248DABE6B1F6',@CurrencyId = '1F8A1142-DEFD-496E-A69C-264CBF7BEDD1',@IsCtcDependent = true,@IsPercentage = true,@Percentagevalue = '50'
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollTemplateConfiguration]
(
   @PayRollTemplateConfigurationId UNIQUEIDENTIFIER = NULL,
   @PayRollComponentId UNIQUEIDENTIFIER  = NULL,
   @PayRollComponentIds XML = NULL,
   @PayRollTemplateId UNIQUEIDENTIFIER  = NULL,
   @IsPercentage BIT = NULL,
   @Amount decimal (18, 4) = NULL,
   @Percentagevalue decimal (18, 4) = NULL,
   @IsCtcDependent BIT = NULL,
   @IsRelatedToPT  BIT = NULL,
   @ComponentId NVARCHAR(500) = NULL,
   @IsArchived BIT = NULL,
   @Order INT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @DependentPayRollComponentId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@PayRollComponentId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'PayRollComponent')

		END
		IF(@PayRollTemplateId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'PayRollTemplate')

		END
		ELSE IF(@IsCtcDependent IS NULL AND @IsRelatedToPT IS NULL AND @ComponentId IS NULL AND @IsPercentage = 1 AND @IsArchived <> 1)
		BEGIN
		   
		   RAISERROR(50011,16, 2, 'IsCtcDependentORIsRelatedToPTORComponentName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PayRollTemplateConfigurationIdCount INT = (SELECT COUNT(1) FROM PayRollTemplateConfiguration WHERE Id = @PayRollTemplateConfigurationId)

       
	    IF(@PayRollTemplateConfigurationIdCount = 0 AND @PayRollTemplateConfigurationId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollTemplateConfiguration')

        END
        ELSE        
		BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = 1
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			                DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@PayRollTemplateConfigurationId IS NULL)
							BEGIN

							  DECLARE @PayRollTemplateConfigurationTable TABLE
                              (
                                 PayRollTemplateConfigurationId UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
                                 PayRollComponentId UNIQUEIDENTIFIER
                              )
        
                              INSERT INTO @PayRollTemplateConfigurationTable(PayRollComponentId)
                              SELECT x.y.value('(text())[1]', 'varchar(100)')
                              FROM @PayRollComponentIds.nodes('/GenericListOfGuid/*/guid') AS x(y)


							INSERT INTO [dbo].[PayRollTemplateConfiguration](
							                  [Id],
							                  [PayRollComponentId],
							                  [PayRollTemplateId],
							                  [Ispercentage],
							                  [Amount],
							                  [Percentagevalue],
							                  [IsCtcDependent],
							                  [IsRelatedToPT],
							                  [ComponentId],
											  [Order],
											  [InactiveDateTime],
							                  [CreatedDateTime],
							                  [CreatedByUserId],
											  [DependentPayRollComponentId])
                                       SELECT PayRollTemplateConfigurationId,
						                      PayRollComponentId,
											  @PayRollTemplateId,
											  CASE WHEN PC.RelatedToContributionPercentage = 1 THEN 1 ELSE @IsPercentage END,
											  CASE WHEN PC.RelatedToContributionPercentage = 1 THEN NULL ELSE @Amount END,
											  CASE WHEN PC.RelatedToContributionPercentage = 1 
											  THEN ISNULL(PC.EmployeeContributionPercentage,0) + ISNULL(PC.EmployerContributionPercentage,0) ELSE @Percentagevalue END,
											  @IsCtcDependent,
											  @IsRelatedToPT,
											  @ComponentId,
											  @Order,
						                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
						                      @Currentdate,
						                      @OperationsPerformedBy,
											  @DependentPayRollComponentId	
							             FROM @PayRollTemplateConfigurationTable PTCT
										 INNER JOIN PayrollComponent PC ON PC.Id = PTCT.PayRollComponentId

						    SELECT @PayRollTemplateId
		                     
							END
							ELSE
							BEGIN

							  UPDATE [PayRollTemplateConfiguration]
							      SET [PayRollComponentId] = @PayRollComponentId,
							          [PayRollTemplateId] =	 @PayRollTemplateId,
							          [Ispercentage] = @IsPercentage,
							          [Amount] = @Amount,
							          [Percentagevalue] = @Percentagevalue,
							          [IsCtcDependent] = @IsCtcDependent,
							          [IsRelatedToPT] = @IsRelatedToPT,
							          [ComponentId] =	@ComponentId,
									  [Order] = @Order,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  DependentPayRollComponentId = @DependentPayRollComponentId
									  WHERE Id = @PayRollTemplateConfigurationId

							  SELECT Id FROM [dbo].[PayRollTemplateConfiguration] WHERE Id = @PayRollTemplateConfigurationId

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
		
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO