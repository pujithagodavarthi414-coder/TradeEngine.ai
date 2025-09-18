-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-23 00:00:00.000'
-- Purpose      To Save or Update PayRollTemplate
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPayRollTemplate] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',
-- @PayRollName='Test',@PayRollShortName='Test',@IslastWorkingDay = 0,@IsRepeatInfinitly = 1			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollTemplate]
(
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL,
   @PayRollName NVARCHAR(250) = NULL,
   @PayRollShortName NVARCHAR(250) = NULL,
   @IsRepeatInfinitly BIT,
   @IslastWorkingDay BIT,
   @InfinitlyRunDate DATETIME = NULL,
   @IsArchived BIT = NULL,
   @FrequencyId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @CurrencyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@FrequencyId = '00000000-0000-0000-0000-000000000000') SET @FrequencyId = NULL	

		IF(@IsArchived = 1 AND @PayRollTemplateId IS NOT NULL)
		BEGIN
		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	          IF(EXISTS(SELECT Id FROM PayrollBranchConfiguration WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInPayRollBranchConfigurationComponentPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          IF(EXISTS(SELECT Id FROM PayrollRoleConfiguration WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInPayRollRoleConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	          END
			  ELSE IF(EXISTS(SELECT Id FROM PayrollGenderConfiguration WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInPayRollGenderConfigurationComponentPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          IF(EXISTS(SELECT Id FROM PayRollMaritalStatusConfiguration WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInPayRollMaritalStatusConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	          END
			  IF(EXISTS(SELECT Id FROM EmployeepayrollConfiguration WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInEmployeePayRollConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	          END
			  IF(EXISTS(SELECT Id FROM PayrollRun WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInPayRollRunPleaseDeleteTheDependenciesAndTryAgain'
	          END
			  IF(EXISTS(SELECT Id FROM Branch WHERE PayRollTemplateId = @PayRollTemplateId AND InactiveDateTime IS NULL))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInBranchPleaseDeleteTheDependenciesAndTryAgain'
	          END
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		         RAISERROR (@isEligibleToArchive,11, 1)
		      END
	    END

	    IF(@PayRollName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'PayRollName')

		END
		IF(@PayRollShortName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'PayRollShortName')

		END
	    ELSE IF(@CurrencyId IS NULL)
        BEGIN

           RAISERROR(50011,16, 2, 'Currency')

        END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PayRollTemplateIdCount INT = (SELECT COUNT(1) FROM PayRollTemplate WHERE Id = @PayRollTemplateId)

		DECLARE @PayRollTemplateCount INT = (SELECT COUNT(1) FROM PayRollTemplate WHERE [PayRollName] = @PayRollName AND CompanyId = @CompanyId 
																		AND (@PayRollTemplateId IS NULL OR @PayRollTemplateId <> Id))
       
	    IF(@PayRollTemplateIdCount = 0 AND @PayRollTemplateId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollTemplate')

        END
		IF (@PayRollTemplateCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'PayRollTemplate')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @PayRollTemplateId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [PayRollTemplate] WHERE Id = @PayRollTemplateId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 	DECLARE @HangFireJobId BIGINT = (SELECT MAX(Id) + 1 FROM [HangFire].[Hangfire].job)
								
                            IF(@PayRollTemplateId IS NULL)
							BEGIN

							SET @PayRollTemplateId = NEWID()
							BEGIN
							INSERT INTO [dbo].[PayRollTemplate](
                                                              [Id],
						                                      [CompanyId],
						                                      [PayRollName],
															  [PayRollShortName],
															  [IsRepeatInfinitly],
															  [IslastWorkingDay],	
															  [FrequencyId],
															  [InfinitlyRunDate],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
													          [CurrencyId]
															  )
                                                       SELECT @PayRollTemplateId,
						                                      @CompanyId,
						                                      @PayRollName,
															  @PayRollShortName,
															  @IsRepeatInfinitly,
															  @IslastWorkingDay, 
															  @FrequencyId,
															  @InfinitlyRunDate,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @CurrencyId

						 END
                          IF(@FrequencyId IS NOT NULL)
						BEGIN
			            UPDATE [PayrollTemplate] SET JobId = @HangFireJobId WHERE Id = @PayRollTemplateId
					    END

		                     
							END
							ELSE
							BEGIN
							DECLARE @CurrentJobId BIGINT = (SELECT Jobid from PayrollTemplate where Id = @PayRollTemplateId)
							BEGIN
							  UPDATE [PayRollTemplate]
							      SET CompanyId = @CompanyId,
								      [PayRollName] = @PayRollName,
									  [PayRollShortName] = @PayRollShortName,
									  [IsRepeatInfinitly] = @IsRepeatInfinitly,
									  [IslastWorkingDay] = @IslastWorkingDay,
									  [FrequencyId] = @FrequencyId,
									  [CurrencyId] = @CurrencyId,
								      [InfinitlyRunDate] = @InfinitlyRunDate,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @PayRollTemplateId
						   END
						   IF(@FrequencyId IS NOT NULL AND @CurrentJobId IS NULL)
						BEGIN
			            UPDATE [PayrollTemplate] SET JobId = @HangFireJobId WHERE Id = @PayRollTemplateId
					    END

							END
						
			              SELECT Id as PayRollTemplateId, JobId FROM [dbo].[PayRollTemplate] WHERE Id = @PayRollTemplateId
			                       
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
