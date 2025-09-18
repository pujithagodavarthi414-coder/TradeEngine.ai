-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update EmploymentStatuses
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
-------------------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmploymentStatus] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @EmploymentStatusName = 'Test'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmploymentStatus]
(
 @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
 @EmploymentStatusName NVARCHAR(50) = NULL,
 @IsPermanent BIT = NULL,
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
			
			IF (@EmploymentStatusId =  '00000000-0000-0000-0000-000000000000') SET @EmploymentStatusId = NULL

			IF (@EmploymentStatusName = ' ' ) SET @EmploymentStatusName = NULL

			IF(@IsPermanent = NULL) set @IsPermanent = 0

			
		    IF(@IsArchived = 1 AND @EmploymentStatusId IS NOT NULL)
		    BEGIN
		     
		         DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	             IF(EXISTS(SELECT Id FROM Job WHERE EmploymentStatusId = @EmploymentStatusId ))
	             BEGIN
	             
	             SET @IsEligibleToArchive = 'ThisEmployeeStatusUsedInJobPleaseDeleteTheDependenciesAndTryAgain'
	             
	             END
		         
		         IF(@IsEligibleToArchive <> '1')
		         BEGIN
		         
		             RAISERROR (@isEligibleToArchive,11, 1)
		         
		         END
		    
	        END


			IF (@EmploymentStatusName IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'EmploymentStatusName')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @EmploymentStatusIdCount INT = (SELECT COUNT(1) FROM EmploymentStatus WHERE Id = @EmploymentStatusId AND CompanyId = @CompanyId)
				
				DECLARE @EmploymentStatusCount INT = (SELECT COUNT(1) FROM EmploymentStatus WHERE EmploymentStatusName = @EmploymentStatusName AND (@EmploymentStatusId IS NULL OR Id <> @EmploymentStatusId) AND CompanyId = @CompanyId ) 

				IF (@EmploymentStatusIdCount = 0 AND @EmploymentStatusId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'EmploymentStatus')

				END
				ELSE IF(@EmploymentStatusCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'EmploymentStatus')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @EmploymentStatusId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EmploymentStatus WHERE Id = @EmploymentStatusId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@EmploymentStatusId IS NULL)
						BEGIN

						SET @EmploymentStatusId = NEWID()

						INSERT INTO EmploymentStatus( 
						                            Id,
													EmploymentStatusName,
													IsPermanent,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime
												   )
											SELECT  @EmploymentStatusId,
											        @EmploymentStatusName,
													@IsPermanent,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

						END
						ELSE
						BEGIN
						
						  UPDATE [EmploymentStatus] 
						     SET [EmploymentStatusName] = @EmploymentStatusName,
								 IsPermanent = @IsPermanent,
								 CompanyId = @CompanyId,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy,
								 InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								 WHERE Id = @EmploymentStatusId
												
						END
					
					   SELECT Id FROM EmploymentStatus WHERE Id = @EmploymentStatusId

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