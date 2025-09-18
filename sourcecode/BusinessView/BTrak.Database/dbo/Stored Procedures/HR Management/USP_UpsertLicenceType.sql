------------------------------------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-28 00:00:00.000'
-- Purpose      To Save or update the License Type
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertLicenceType] @LicenseTypeName = 'Test',@IsArchived = 0,@OperationsPerformedBy = 
-- '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertLicenceType
(
 @LicenseTypeId UNIQUEIDENTIFIER = NULL,
 @LicenseTypeName NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	   
	    IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF (@LicenseTypeId = '00000000-0000-0000-0000-000000000000') SET @LicenseTypeId = NULL    

		IF (@LicenseTypeName = '') SET @LicenseTypeName = NULL

		IF(@IsArchived = 1 AND @LicenseTypeId IS NOT NULL)
		BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM EmployeeLicence WHERE LicenceTypeId = @LicenseTypeId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisLicenceTypeUsedInEmployeeLicencePleaseDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	    END

		IF(@LicenseTypeName IS NULL)
        BEGIN
		   
		   RAISERROR(50011,16, 2, 'LicenseType')

		END
		ELSE
		BEGIN

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		    IF (@HavePermission = '1')
		    BEGIN
			
		    
		        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
		    
		       DECLARE @LicenseTypeIdCount INT = (SELECT COUNT(1) FROM LicenceType 
		                                           WHERE  Id = @LicenseTypeId AND CompanyId = @CompanyId)
		    
		       DECLARE @LicenseTypeNameCount INT = (SELECT COUNT(1) FROM LicenceType 
		                                                   WHERE @LicenseTypeName = [LicenceTypeName] 
														    AND (@LicenseTypeId IS NULL OR Id <> @LicenseTypeId)
															AND CompanyId = @CompanyId)
		    
	        IF (@LicenseTypeIdCount = 0 AND @LicenseTypeId IS NOT NULL)
            BEGIN
		     
		      RAISERROR(50002,16, 1,'LicenseType')
		    
		    END
		    ELSE IF(@LicenseTypeNameCount > 0)
		    BEGIN
		       
		       RAISERROR(50001,16,1,'LicenseType')
		    
		    END
		    ELSE
		    BEGIN
		    
		       DECLARE @IsLatest INT = (CASE WHEN @LicenseTypeId IS NULL THEN 1 ELSE 
		                                CASE WHEN (SELECT [TimeStamp] FROM LicenceType 
		    							WHERE Id = @LicenseTypeId) = @TimeStamp THEN 1 ELSE 0 END END)
		    						
		    IF (@IsLatest = 1)
		    BEGIN
		       
		       DECLARE @CurrentDateTime DATETIME = GETDATE()
		    
			   IF(@LicenseTypeId IS NULL)
			   BEGIN

			   SET @LicenseTypeId = NEWID()
		       INSERT INTO LicenceType ( 
			                            Id,
                                        CompanyId,
                                        LicenceTypeName,
                                        CreatedDateTime,
                                        CreatedByUserId,
                                        InActiveDateTime
									    )
								 SELECT @LicenseTypeId,
								        @CompanyId,
										@LicenseTypeName,
										@CurrentDateTime,
										@OperationsPerformedBy,
										CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END
					
				END
				ELSE
				BEGIN

				UPDATE LicenceType
							    	SET  CompanyId		   =   	 @CompanyId,
                                        LicenceTypeName	   =   	 @LicenseTypeName,
                                        UpdatedDateTime	   =   	 @CurrentDateTime,
                                        UpdatedByUserId	   =   	 @OperationsPerformedBy,
                                        InActiveDateTime   =   	 CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END
										WHERE Id = @LicenseTypeId

				END
				SELECT Id FROM LicenceType WHERE Id = @LicenseTypeId

				END
		    ELSE
		      
		      RAISERROR(50008,11, 1)
		    END
		END
		ELSE
		 
		  RAISERROR(@HavePermission,11,1)

		END
		END TRY
		BEGIN CATCH

		  THROW

        END CATCH

 END
 GO