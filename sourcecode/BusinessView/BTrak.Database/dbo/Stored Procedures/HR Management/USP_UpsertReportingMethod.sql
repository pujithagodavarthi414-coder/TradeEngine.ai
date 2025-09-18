------------------------------------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update ReportingMethods
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
-- EXEC  [dbo].[USP_UpsertReportingMethod] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @ReportingMethodType = 'Direct'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertReportingMethod
(
 @ReportingMethodId UNIQUEIDENTIFIER = NULL,
 @ReportingMethodType NVARCHAR(50) = NULL,
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
			
			IF (@ReportingMethodId =  '00000000-0000-0000-0000-000000000000') SET @ReportingMethodId = NULL

			IF (@ReportingMethodType = ' ' ) SET @ReportingMethodType = NULL

			IF(@IsArchived = 1 AND @ReportingMethodId IS NOT NULL)
            BEGIN
		
		        DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	            IF(EXISTS(SELECT Id FROM [EmployeeReportTo] WHERE ReportingMethodId = @ReportingMethodId))
	            BEGIN
	            
	            SET @IsEligibleToArchive = 'ThisReportingMethodUsedInEmployeeReportToPleaseDeleteTheDependenciesAndTryAgain'
	            
	            END
		        
		        IF(@IsEligibleToArchive <> '1')
		        BEGIN
		        
		            RAISERROR (@isEligibleToArchive,11, 1)
		        
		        END

	        END

			IF (@ReportingMethodType IS NULL)
			BEGIN
				
				RAISERROR(50002,16,1,'ReportingMethod')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @ReportingMethodIdCount INT = (SELECT COUNT(1) FROM ReportingMethod WHERE Id = @ReportingMethodId AND CompanyId = @CompanyId )
				
				DECLARE @ReportingMethodCount INT = (SELECT COUNT(1) FROM ReportingMethod WHERE ReportingMethodType = @ReportingMethodType AND (@ReportingMethodId IS NULL OR Id <> @ReportingMethodId) AND CompanyId = @CompanyId ) 

				IF (@ReportingMethodIdCount = 0 AND @ReportingMethodId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'ReportingMethod')

				END
				ELSE IF(@ReportingMethodCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'ReportingMethod')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ReportingMethodId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ReportingMethod WHERE Id = @ReportingMethodId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@ReportingMethodId IS NULL)
						BEGIN

						SET @ReportingMethodId = NEWID()

						INSERT INTO ReportingMethod( 
						                            Id,
													ReportingMethodType,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime
												   )
											SELECT  @ReportingMethodId,
											        @ReportingMethodType,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

						END
						ELSE
						BEGIN

						 UPDATE [ReportingMethod]
						     SET ReportingMethodType = @ReportingMethodType,
							     CompanyId = @CompanyId,
								 InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @ReportingMethodId
								 
						END

						SELECT Id FROM ReportingMethod WHERE Id = @ReportingMethodId
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