-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-28 00:00:00.000'
-- Purpose      To Save or update the State
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertState] @StateName = 'Test',@IsArchived = 0,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
--------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertState
(
 @StateId UNIQUEIDENTIFIER = NULL,
 @StateName NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
 )
 AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@StateId = '00000000-0000-0000-0000-000000000000') SET @StateId = NULL

		 IF(@StateName = '') SET @StateName = NULL

		 IF(@IsArchived = 1 AND @StateId IS NOT NULL)
		 BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM [EmployeeContactDetails] WHERE StateId = @StateId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisStateUsedInEmployeeContactDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [EmployeeEmergencyContact] WHERE StateOrProvinceId = @StateId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisStateUsedInEmployeeEmergencyContactDetailsDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM [Customer] WHERE StateId = @StateId ))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisStateUsedInCustomerDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	     END

		 IF(@StateName IS NULL)
		 BEGIN

		     RAISERROR(50011,16, 2,'StateName')

		 END
		 ELSE
		 BEGIN

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 IF(@HavePermission = '1')
		 BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

		 DECLARE @StateIdCount INT = (SELECT COUNT(1) FROM [State] 
		                              WHERE @StateId = Id)

		 DECLARE @StateNameCount INT = (SELECT COUNT(1) FROM [State] 
		                                WHERE @StateName = StateName 
										  AND (@StateId IS NULL OR @StateId <> Id)
										  AND CompanyId = @CompanyId)

		IF(@StateIdCount = 0 AND @StateId  IS NOT NULL)
		BEGIN
		   
		   RAISERROR(50002,16,1,'State')

		END
		ELSE IF(@StateNameCount > 0)
		BEGIN
             
			RAISERROR(50001,16,1,'State')
		
		END
		ELSE
		BEGIN
		   
		   DECLARE @IsLatest BIT = (CASE WHEN @StateId IS NULL THEN 1 ELSE 
		                            CASE WHEN (SELECT [TimeStamp] FROM [State] 
									WHERE @StateId = Id) = @TimeStamp THEN 1 ELSE 0 END END )
									
		 IF(@IsLatest = 1)
		 BEGIN

		 DECLARE @CurrentDate DATETIME = GETDATE()

         IF(@StateId IS NULL)
		 BEGIN

		   SET @StateId = NEWID()

		 INSERT INTO [dbo].[State](
		                           Id,
                                   StateName,
								   CompanyId,
                                   CreatedDateTime,
                                   CreatedByUserId,
                                   InActiveDateTime
								  )
	                        SELECT @StateId,
								   @StateName,
								   @CompanyId,
								   @CurrentDate,
								   @OperationsPerformedBy,
								   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

				END
				ELSE
				BEGIN

				UPDATE [State]
				  SET StateName = @StateName,
				      CompanyId = @CompanyId,
					  UpdatedDateTime = @CurrentDate,
					  UpdatedByUserId = @OperationsPerformedBy,
					  InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					  WHERE Id = @StateId AND CompanyId = @CompanyId

				END

			 SELECT Id FROM [State] WHERE Id = @StateId
		    
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








