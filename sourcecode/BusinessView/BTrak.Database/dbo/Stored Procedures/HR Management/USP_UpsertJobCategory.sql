-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-06 00:00:00.000' select * from JobCategory
-- Purpose      To save or update JobCategorys
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertJobCategory] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@JobCategory = 'Rana'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertJobCategory
(
 @JobCategoryId UNIQUEIDENTIFIER = NULL,
 @JobCategory NVARCHAR(50) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@JobCategoryId =  '00000000-0000-0000-0000-000000000000') SET @JobCategoryId = NULL

			IF (@JobCategory = ' ' ) SET @JobCategory = NULL

			IF(@IsArchived = 1 AND @JobCategoryId IS NOT NULL)
            BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM Job WHERE JobCategoryId = @JobCategoryId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisJobCategoryUsedInJobPleaseDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	        END

			IF (@JobCategory IS NULL)
			BEGIN
				
				RAISERROR(50002,16,1,'JobCategory')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @JobCategoryIdCount INT = (SELECT COUNT(1) FROM JobCategory WHERE Id = @JobCategoryId AND CompanyId = @CompanyId)
				
				DECLARE @JobCategoryCount INT = (SELECT COUNT(1) FROM JobCategory WHERE JobCategoryType = @JobCategory AND (@JobCategoryId IS NULL OR Id <> @JobCategoryId) AND CompanyId = @CompanyId) 

				IF (@JobCategoryIdCount = 0 AND @JobCategoryId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'JobCategory')

				END
				ELSE IF(@JobCategoryCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'JobCategory')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @JobCategoryId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM JobCategory WHERE Id = @JobCategoryId) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						DECLARE @IsActive BIT = (SELECT IsActive FROM JobCategory WHERE Id = @JobCategoryId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

				       IF(@JobCategoryId IS NULL)
					   BEGIN

					   SET @JobCategoryId = NEWID()

					                 	INSERT INTO JobCategory( 
						                            Id,
													JobCategoryType,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime,
													IsActive
													
												   )
											SELECT  @JobCategoryId,
											        @JobCategory,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
													CASE WHEN @IsArchived = 1 THEN 0 ELSE ISNULL(@IsActive,1) END
												
                        
						END
						ELSE
						BEGIN

						UPDATE [JobCategory]
						   SET JobCategoryType = @JobCategory,
						       CompanyId = @CompanyId,
							   InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							   IsActive = CASE WHEN @IsArchived = 1 THEN 0 ELSE ISNULL(@IsActive,1) END,
							   UpdatedDateTime = @CurrentDate,
							   UpdatedByUserId  = @OperationsPerformedBy
							 
							   WHERE Id = @JobCategoryId

						END

						SELECT Id FROM JobCategory WHERE Id = @JobCategoryId
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