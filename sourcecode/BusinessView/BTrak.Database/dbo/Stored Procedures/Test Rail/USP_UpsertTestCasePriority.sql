-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestCasePriority
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestCasePriority
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestCasePriority] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PriorityType = 'test'

CREATE PROCEDURE USP_UpsertTestCasePriority
(
	@TestCasePriorityId UNIQUEIDENTIFIER = NULL,
	@PriorityType NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	  
	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
		IF (@HavePermission = '1')
        BEGIN
		
		IF(@PriorityType = '') SET @PriorityType = NULL

		IF(@IsArchived = 1 AND @TestCasePriorityId IS NOT NULL)
		BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM [TestCase] WHERE PriorityId = @TestCasePriorityId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisTestCasePriorityUsedInTestCaseDeleteTheDependenciesAndTryAgain'
	         
	         END
			
			 IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END
        END
		
		IF(@PriorityType IS NULL)
		BEGIN
			
		    RAISERROR(50011,16, 2, 'PriorityType')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @TestCasePriorityIdCount INT = (SELECT COUNT(1) FROM TestCasePriority WHERE Id = @TestCasePriorityId AND CompanyId = @CompanyId)
			  
			DECLARE @PriorityTypesCount INT = (SELECT COUNT(1) FROM [dbo].[TestCasePriority] WHERE [PriorityType] = @PriorityType AND CompanyId = @CompanyId AND (Id <> @TestCasePriorityId OR @TestCasePriorityId IS NULL)  AND InactiveDateTime IS NULL)

		    IF(@TestCasePriorityIdCount = 0 AND @TestCasePriorityId IS NOT NULL)
		    BEGIN

		    	RAISERROR(50002,16, 1,'TestCasePriority')

		    END
		    ELSE IF(@PriorityTypesCount > 0)
			BEGIN

				RAISERROR(50001,16,1,'TestCasePriorityType')

			END
		    ELSE
		    BEGIN
								
					DECLARE @IsLatest BIT = (CASE WHEN @TestCasePriorityId IS NULL 
					                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [TestCasePriority] WHERE Id = @TestCasePriorityId ) = @TimeStamp
																   THEN 1 ELSE 0 END END)
        
					IF(@IsLatest = 1)
					BEGIN

						DECLARE @Currentdate DATETIME = GETDATE()
	       				
					   IF(@TestCasePriorityId IS NULL)
					   BEGIN

					   SET @TestCasePriorityId = NEWID()

						INSERT INTO [dbo].TestCasePriority(
					                 [Id],
					                 [PriorityType],
									 [InActiveDateTime],
									 [CompanyId],
					                 [CreatedDateTime],
					                 [CreatedByUserId]
									 )
					          SELECT @TestCasePriorityId,
									 @PriorityType,
									 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 @CompanyId,
					                 @Currentdate,
					                 @OperationsPerformedBy
							  
							  END
							  ELSE
							  BEGIN

							  UPDATE [dbo].[TestCasePriority]
							     SET PriorityType = @PriorityType,
								     InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 CompanyId = @CompanyId,
									 UpdatedByUserId = @OperationsPerformedBy,
									 UpdatedDateTime = @Currentdate
									 WHERE Id = @TestCasePriorityId

							  END
						
						SELECT Id FROM [dbo].TestCasePriority WHERE Id = @TestCasePriorityId

				END
				ELSE
				  RAISERROR (50008,11, 1)

				END
		END
		END
		ELSE
        RAISERROR (@HavePermission,11, 1)   
		
    END TRY
    BEGIN CATCH
        
       THROW

    END CATCH
END
GO