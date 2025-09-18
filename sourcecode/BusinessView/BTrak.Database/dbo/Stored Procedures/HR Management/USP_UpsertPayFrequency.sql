-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-28 00:00:00.000'
-- Purpose      To save or update PayFrequencies
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertPayFrequency] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@PayFrequencyName = 'Test'
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertPayFrequency
(
 @PayFrequencyId UNIQUEIDENTIFIER = NULL,
 @PayFrequencyName NVARCHAR(50) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER ,
 @CronExpression NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		set @HavePermission = 1;
		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@PayFrequencyId =  '00000000-0000-0000-0000-000000000000') SET @PayFrequencyId = NULL

			IF (@PayFrequencyName = ' ' ) SET @PayFrequencyName = NULL

			IF(@IsArchived = 1 AND @PayFrequencyId IS NOT NULL)
            BEGIN
		    
		       DECLARE @IsEligibleToDelete NVARCHAR(1000) = '1'
	
	           IF(EXISTS(SELECT Id FROM [EmployeeSalary] WHERE SalaryPayFrequencyId = @PayFrequencyId ))
	           BEGIN
	           
	           SET @IsEligibleToDelete = 'ThisPayFrequencyUsedInEmployeeSalaryPleaseDeleteTheDependenciesAndTryAgain'
	           
	           END
		       
		       IF(@IsEligibleToDelete <> '1')
		       BEGIN
		       
		           RAISERROR (@IsEligibleToDelete,11, 1)
		       
		       END

	         END

			--IF (@PayFrequencyName IS NULL)
			--BEGIN
				
			--	RAISERROR(50002,16,1,'PayFrequency')

			--END
			--ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @PayFrequencyIdCount INT = (SELECT COUNT(1) FROM PayFrequency WHERE Id = @PayFrequencyId AND CompanyId = @CompanyId)
				
				DECLARE @PayFrequencyCount INT = (SELECT COUNT(1) FROM PayFrequency WHERE PayFrequencyName = @PayFrequencyName AND (@PayFrequencyId IS NULL OR Id <> @PayFrequencyId) AND CompanyId = @CompanyId) 

				IF (@PayFrequencyIdCount = 0 AND @PayFrequencyId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'PayFrequency')

				END
				ELSE IF(@PayFrequencyCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'PayFrequency')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @PayFrequencyId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM PayFrequency WHERE Id = @PayFrequencyId) = @TimeStamp THEN 1 ELSE 0 END END )
				SET @IsLatest = 1;
					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@PayFrequencyId IS NULL)
					  BEGIN

					  SET @PayFrequencyId = NEWID()

						                INSERT INTO PayFrequency( 
						                            Id,
													PayFrequencyName,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime,
													CronExpression
												   )
											SELECT  @PayFrequencyId,
											        @PayFrequencyName,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
													@CronExpression

						END
						ELSE
						BEGIN

						UPDATE [PayFrequency]
						   SET PayFrequencyName = @PayFrequencyName,
						       CompanyId = @CompanyId,
							   UpdatedDateTime = @CurrentDate,
							   UpdatedByUserId = @OperationsPerformedBy,
							   InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							   CronExpression = @CronExpression
							   WHERE Id = @PayFrequencyId

						END
						SELECT Id FROM PayFrequency WHERE Id = @PayFrequencyId
					END
					ELSE
					  
						RAISERROR(50008,11,1)

				END
			END
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO