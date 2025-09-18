-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update badges
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertBadge] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpsertBadge]
(
 @BadgeId UNIQUEIDENTIFIER = NULL,
 @BadgeName NVARCHAR(50) = NULL,
 @Description NVARCHAR(250) = NULL,
 @ImageUrl NVARCHAR(250) = NULL,
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
			
			IF (@BadgeId =  '00000000-0000-0000-0000-000000000000') SET @BadgeId = NULL

			IF (@BadgeName = ' ' ) SET @BadgeName = NULL
		
	        IF(EXISTS(SELECT Id FROM [EmployeeBadge] WHERE BadgeId = @BadgeId AND InActiveDateTime IS NULL) AND @IsArchived = 1 AND @BadgeId IS NOT NULL)
	        BEGIN
	        
	          RAISERROR('ThisBadgeIsUsedInEmployeeBadgePleaseDeleteTheDependenciesAndTryAgain',11,1)
	        
	        END
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @BadgeIdCount INT = (SELECT COUNT(1) FROM Badge WHERE Id = @BadgeId AND CompanyId = @CompanyId )
			
			DECLARE @BadgesCount INT = (SELECT COUNT(1) FROM Badge WHERE BadgeName = @BadgeName AND (@BadgeId IS NULL OR Id <> @BadgeId) AND CompanyId = @CompanyId ) 

			IF (@BadgeIdCount = 0 AND @BadgeId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'BadgeName')

				END
			ELSE IF(@BadgesCount > 0)
			BEGIN
				
					RAISERROR(50001,16,1,'BadgeName')

				END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @BadgeId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Badge WHERE Id = @BadgeId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@BadgeId IS NULL)
					  BEGIN

					  SET @BadgeId = NEWID()

						  INSERT INTO Badge(Id,
							    			BadgeName,
											[Description],
											[ImageUrl],
							    			CompanyId,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @BadgeId,
											@BadgeName,
											@Description,
											@ImageUrl,
							    			@CompanyId,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE [Badge]
					     SET  [BadgeName] = @BadgeName,
							  ImageUrl = @ImageUrl,
							  [Description] = @Description,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @BadgeId

					   END

						SELECT Id FROM Badge WHERE Id = @BadgeId
					END
					ELSE
					  
						RAISERROR(50008,11,1)

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