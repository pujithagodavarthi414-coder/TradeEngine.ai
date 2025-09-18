-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or Update UserStoryType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryTypeName='goal'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertUserStoryType]
(
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @UserStoryTypeName NVARCHAR(100) = NULL,
  @UserStoryTypeShortName NVARCHAR(100) = NULL,
  @UserStoryTypeColor NVARCHAR(50) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @IsQaRequired BIT = NULL,
  @IsLogTimeRequired BIT = NULL,
  @IsBug BIT = NULL,
  @IsAction BIT = NULL,
  @TimeStamp TIMESTAMP = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @UserstoryStatusTypeIdCount INT = (SELECT COUNT(1) FROM UserStoryType WHERE Id = @UserStoryTypeId AND CompanyId = @CompanyId)

		DECLARE @UserStoryTypeCount INT = (SELECT COUNT(1) FROM UserStoryType WHERE UserStoryTypeName = @UserStoryTypeName AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

		DECLARE @UpdateUserStoryTypeCount INT = (SELECT COUNT(1) FROM UserStoryType WHERE UserStoryTypeName = @UserStoryTypeName AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND Id <> @UserStoryTypeId)

		IF(@UserstoryStatusTypeIdCount = 0 AND @UserStoryTypeId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'UserStoryStatusType')

		END

		ELSE IF(@UserStoryTypeCount > 0 AND @UserStoryTypeId IS NULL)
		BEGIN

			RAISERROR(50001,16,1,'UserStoryType')

		END

		ELSE IF(@UpdateUserStoryTypeCount > 0 AND @UserStoryTypeId IS NOT NULL)
		BEGIN

			RAISERROR(50001,16,1,'UserStoryType')

		END

		ELSE
		BEGIN

		IF (@HavePermission = '1')
		BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @UserStoryTypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStoryType WHERE Id = @UserStoryTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
		IF(@IsLatest = 1)
		BEGIN

					IF(@UserStoryTypeId IS NULL)
					BEGIN

						SET @UserStoryTypeId = NEWID()
					    INSERT INTO [dbo].[UserStoryType](
						            Id,
						            UserStoryTypeName,
						            CompanyId,
						            CreatedDateTime,
						            CreatedByUserId,
									InActiveDateTime,
									IsQaRequired,
									IsLogTimeRequired,
									ShortName,
									Color,
									IsBug,
									IsAction
									)
						     SELECT @UserStoryTypeId,
						            @UserStoryTypeName,
						            @CompanyId,
						            @Currentdate,
						            @OperationsPerformedBy,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									@IsQaRequired,
									@IsLogTimeRequired,
									@UserStoryTypeShortName,
									@UserStoryTypeColor,
									@IsBug,
									@IsAction
					  
					END
					ELSE
					BEGIN

						UPDATE [dbo].[UserStoryType]
							SET UserStoryTypeName		 =  	 @UserStoryTypeName,
						            CompanyId			 =  	 @CompanyId,
						            UpdatedDateTime		 =  	 @Currentdate,
						            UpdatedByUserId		 =  	 @OperationsPerformedBy,
									InActiveDateTime	 =  	 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									IsQaRequired         =       @IsQaRequired,
									IsLogTimeRequired    =       @IsLogTimeRequired,
									ShortName            =       @UserStoryTypeShortName,
									Color                =       @UserStoryTypeColor,
									IsBug                =       @IsBug
								WHERE Id = @UserStoryTypeId

					END
					    SELECT Id FROM [dbo].[UserStoryType] WHERE Id = @UserStoryTypeId

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
GO
