-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-30 00:00:00.000'
-- Purpose      To Save or update the RelatinShip
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertRelationShip] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived = 0,@RelationShipName = 'ABC'
----------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertRelationShip
(
 @RelationShipId UNIQUEIDENTIFIER = NULL,
 @RelationShipName NVARCHAR(250) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 IF(@RelationShipId = '00000000-0000-0000-0000-000000000000') SET @RelationShipId = NULL

	 IF(@RelationShipName = '') SET @RelationShipName = NULL

	 IF(@IsArchived = 1 AND @RelationShipId IS NOT NULL)
     BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM [EmployeeContactDetails] WHERE RelationshipId = @RelationShipId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisRelationShipUsedInEmployeeContactDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [EmployeeEmergencyContact] WHERE RelationshipId = @RelationShipId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisRelationShipUsedInEmployeeEmergencyContactDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	    END


	 IF(@RelationShipName IS NULL)
	 BEGIN
	    
		RAISERROR(50011,16,2,'RelationShipName')

	 END
	 ELSE
	 BEGIN

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	 IF (@HavePermission = '1')
     BEGIN
                
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @RelationShipIdCount INT = (SELECT COUNT(1) FROM RelationShip 
		                                    WHERE Id = @RelationShipId 
											  AND CompanyId = @CompanyId)

		DECLARE @RelationShipNameCount INT = (SELECT COUNT(1) FROM RelationShip 
		                                      WHERE RelationShipName = @RelationShipName 
											   AND (@RelationShipId IS NULL OR Id <> @RelationShipId) 
											   AND CompanyId = @CompanyId) 

	   IF(@RelationShipIdCount = 0 AND @RelationShipId IS NOT NULL)
	   BEGIN

	      RAISERROR(50002,16,1,'RelationShip')

	   END
	   ELSE IF (@RelationShipNameCount > 0)
       BEGIN

	      RAISERROR(50001,16,1,'RelationShip')

	   END
	   ELSE
	   BEGIN

	     DECLARE @IsLatest BIT = (CASE WHEN @RelationShipId IS NULL THEN 1 ELSE 
		                          CASE WHEN (SELECT [TimeStamp] FROM RelationShip 
								             WHERE Id = @RelationShipId) = @TimeStamp THEN 1 ELSE 0 END END)

	  IF (@IsLatest = 1)
	  BEGIN

	     DECLARE @CurrentDate DATETIME = GETDATE()

		 IF(@RelationShipId IS NULL)
		 BEGIN

		 SET @RelationShipId = NEWID()

		 INSERT INTO RelationShip (
		                           Id,
								   RelationShipName,
								   CreatedDateTime,
								   CreatedByUserId,
								   CompanyId,
								   InActiveDateTime
								  )
			  			 SELECT    @RelationShipId,
						           @RelationShipName,
								   @CurrentDate,
								   @OperationsPerformedBy,
								   @CompanyId,
								   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END 

			 END
			 ELSE
			 BEGIN
			  
			  UPDATE [RelationShip]
			   SET RelationShipName = @RelationShipName,
			       CompanyId = @CompanyId,
				   InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
				   UpdatedDateTime = @CurrentDate,
				   UpdatedByUserId = @OperationsPerformedBy
				   WHERE Id = @RelationShipId

			 END
		
			SELECT Id FROM RelationShip WHERE Id = @RelationShipId

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
