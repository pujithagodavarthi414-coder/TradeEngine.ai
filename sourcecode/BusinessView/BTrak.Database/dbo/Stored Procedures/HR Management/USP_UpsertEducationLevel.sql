-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update educationlevels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertEducationLevel] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@EducationLevel = 'MTech'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertEducationLevel
(
 @EducationLevelId UNIQUEIDENTIFIER = NULL,
 @EducationLevel NVARCHAR(50) = NULL,
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
			
			IF (@EducationLevelId =  '00000000-0000-0000-0000-000000000000') SET @EducationLevelId = NULL

			IF (@EducationLevel = ' ' ) SET @EducationLevel = NULL

			IF(@IsArchived = 1 AND @EducationLevelId IS NOT NULL)
            BEGIN
		
		        DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	            IF(EXISTS(SELECT Id FROM [EmployeeEducation] WHERE EducationLevelId = @EducationLevelId ))
	            BEGIN
	            
	            SET @IsEligibleToArchive = 'ThisEducationLevelUsedInEmployeeEducationPleaseDeleteTheDependenciesAndTryAgain'
	            
	            END
		        
		        IF(@IsEligibleToArchive <> '1')
		        BEGIN
		        
		            RAISERROR (@isEligibleToArchive,11, 1)
		        
		        END

	        END


			IF (@EducationLevel IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'EducationLevel')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @EducationLevelIdCount INT = (SELECT COUNT(1) FROM EducationLevel WHERE Id = @EducationLevelId AND CompanyId = @CompanyId )
				
				DECLARE @EducationLevelCount INT = (SELECT COUNT(1) FROM EducationLevel WHERE EducationLevel = @EducationLevel AND (@EducationLevelId IS NULL OR Id <> @EducationLevelId) AND CompanyId = @CompanyId ) 

				IF (@EducationLevelIdCount = 0 AND @EducationLevelId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'EducationLevel')

				END
				ELSE IF(@EducationLevelCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'EducationLevel')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @EducationLevelId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EducationLevel WHERE Id = @EducationLevelId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@EducationLevelId IS NULL)
					  BEGIN

					  SET @EducationLevelId = NEWID()

						INSERT INTO EducationLevel( 
						                            Id,
													EducationLevel,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime
												   )
											SELECT  @EducationLevelId,
											        @EducationLevel,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
					  END
					   ELSE
					   BEGIN

					   UPDATE [EducationLevel]
					     SET  [EducationLevel] = @EducationLevel,
						      [CompanyId] = @CompanyId,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @EducationLevelId

					   END

						SELECT Id FROM EducationLevel WHERE Id = @EducationLevelId
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