-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update UserStorySubType
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUserStorySubType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStorySubTypeName ='Test1'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStorySubType]
(
    @UserStorySubTypeId UNIQUEIDENTIFIER = NULL,
    @UserStorySubTypeName NVARCHAR(250) = NULL,	
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   IF(@IsArchived = 1 AND @UserStorySubTypeId IS NOT NULL)
	   BEGIN

		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
            IF(EXISTS(SELECT Id FROM [ReviewTemplate] WHERE UserStorySubTypeId = @UserStorySubTypeId))
            BEGIN
	        
            SET @IsEligibleToArchive = 'This Review Template Used In User Story Sub Type Delete The Dependencies And Try Again'
            
            END

			IF(@IsEligibleToArchive <> '1')
            BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
             END
	    END   

	    
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @UserstoryStatusSubTypeIdCount INT = (SELECT COUNT(1) FROM UserStorySubType WHERE Id = @UserStorySubTypeId AND CompanyId = @CompanyId)

		DECLARE @UserStoryStatusSubTypeCount INT = (SELECT COUNT(1) FROM UserStorySubType WHERE UserStorySubTypeName = @UserStorySubTypeName AND CompanyId = @CompanyId)

		DECLARE @UpdateUserStoryStatusSubTypeCount INT = (SELECT COUNT(1) FROM UserStorySubType WHERE UserStorySubTypeName = @UserStorySubTypeName AND CompanyId = @CompanyId AND (@UserStorySubTypeId IS NULL OR Id <> @UserStorySubTypeId))

		IF(@UserstoryStatusSubTypeIdCount = 0 AND @UserStorySubTypeId IS NOT NULL)
		BEGIN
		
			RAISERROR(50002,16, 1,'UserstorySubType')
		
		END
		
		ELSE IF(@UserStoryStatusSubTypeCount > 0 AND @UserStorySubTypeId IS NULL)
		BEGIN
		
			RAISERROR(50001,16,1,'UserstorySubType')
		
		END
		
		ELSE IF(@UpdateUserStoryStatusSubTypeCount > 0 AND @UserStorySubTypeId IS NOT NULL)
		BEGIN
		
			RAISERROR(50001,16,1,'UserstorySubType')
		
		END
	  
		ELSE
		BEGIN

			IF (@HavePermission = '1')
			BEGIN

	  		     DECLARE @IsLatest BIT = (CASE WHEN @UserStorySubTypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStorySubType WHERE Id = @UserStorySubTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)        
	  		     IF(@IsLatest = 1)
				 BEGIN

					IF(@UserStorySubTypeId IS NULL)
					BEGIN

						SET @UserStorySubTypeId = NEWID()
						INSERT INTO [dbo].[UserStorySubType](
	  						                Id,
	  						                UserStorySubTypeName,
	  						                CompanyId,
	  						                CreatedDateTime,
	  						                CreatedByUserId,
	  										InActiveDateTime
	  										)
	  						         SELECT @UserStorySubTypeId,
	  						                @UserStorySubTypeName,
	  						                @CompanyId,
	  						                @Currentdate,
	  						                @OperationsPerformedBy,
	  										CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN

						UPDATE [dbo].[UserStorySubType]
							SET  UserStorySubTypeName			   =   @UserStorySubTypeName,
	  						                CompanyId			   =   @CompanyId,
	  						                UpdatedDateTime		   =   @Currentdate,
	  						                UpdatedByUserId		   =   @OperationsPerformedBy,
	  										InActiveDateTime	   =   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
										WHERE Id = @UserStorySubTypeId

					END
						SELECT Id FROM [dbo].[UserStorySubType] WHERE Id = @UserStorySubTypeId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)   	  
			END        
			ELSE
			BEGIN
			        
			  RAISERROR (@HavePermission,11, 1)
			           
			END
	END

	END TRY  
	BEGIN CATCH 
		
		THROW

	END CATCH

END
