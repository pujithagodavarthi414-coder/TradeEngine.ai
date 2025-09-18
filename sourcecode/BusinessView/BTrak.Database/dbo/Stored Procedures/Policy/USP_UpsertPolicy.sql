----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-06-12 00:00:00.000'
-- Purpose      To Add Policy
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--	EXEC [dbo].[USP_UpsertPolicy] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @Name='Sample'

CREATE PROCEDURE [dbo].[USP_UpsertPolicy]
(
	@PolicyId UNIQUEIDENTIFIER = NULL,
	@Name NVARCHAR(250) = NULL,
	@Description NVARCHAR(800) = NULL,
	@Version NVARCHAR(100) = NULL,
	@MustRead BIT = NULL,
	@IsArchived BIT = NULL,
	@SelectedRoles NVARCHAR(MAX) = NULL,
	@SelectedUsers NVARCHAR(MAX) = NULL,
	@ReviewDate DATETIME = NULL,
	@FilePath NVARCHAR(MAX) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER		
)
AS
BEGIN

	SET NOCOUNT ON
       BEGIN TRY
          
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')			 
            BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@PolicyId = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@Name = '') SET @Name = NULL

			IF (@Description = '') SET @Description = NULL
			IF (@SelectedRoles = '') SET @SelectedRoles = NULL
			IF (@SelectedUsers = '') SET @SelectedUsers = NULL

			IF (@MustRead IS NULL) SET @MustRead = 0

			IF (@IsArchived IS NULL) SET @IsArchived = 0

			DECLARE @PolicyIdCount INT = (SELECT COUNT(1) FROM [Policy] WHERE [Id] = @PolicyId AND CompanyId = @CompanyId)
			DECLARE @PolicyTitleCount INT = (SELECT COUNT(1) FROM [Policy] WHERE [Name] = @Name AND [Name] IS NOT NULL AND (@PolicyId IS NULL OR Id <> @PolicyId) AND CompanyId = @CompanyId)

			DECLARE @IsLatest BIT = (CASE WHEN @PolicyId IS NULL THEN 1
										ELSE CASE WHEN (SELECT [TimeStamp] FROM [Policy] WHERE Id = @PolicyId) = @TimeStamp
											THEN 1 ELSE 0 END END)

			IF(@Name IS NULL)
			BEGIN
			    
				RAISERROR(50011,16, 2, 'PolicyName')
			
			END
			ELSE IF(@PolicyTitleCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001, 16, 2,'PolicyName')
		    
		    END
			ELSE IF(@PolicyIdCount = 0 AND @PolicyId IS NOT NULL)
		    BEGIN
		    
		    	RAISERROR(50002, 16, 2,'PolicyId')
		    
		    END
			ELSE IF(@IsLatest = 1)
			BEGIN
			
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@PolicyId IS NULL)
				BEGIN

					SET @PolicyId = NEWID()

					INSERT INTO [dbo].[Policy](
								[Id],
								[Name],
								[Description],
								[ReviewDate],
								[MustRead],
								[CreatedDateTime],
								[CreatedByUserId],
								[CompanyId]
					)
					SELECT @PolicyId,
						   @Name,
						   @Description,
						   @ReviewDate,
						   @MustRead,
						   @CurrentDate,
						   @OperationsPerformedBy,
						   @CompanyId

					IF(@SelectedRoles IS NOT NULL OR @SelectedUsers IS NOT NULL)
					BEGIN

						INSERT INTO [dbo].[PolicyUser]([Id], [PolicyId], [Role], [User], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @PolicyId, @SelectedRoles, @SelectedUsers, @CurrentDate, @OperationsPerformedBy

					END
			
				END
				ELSE
				BEGIN

					UPDATE [Policy] SET [Name] = @Name,
										[Description] = @Description,
										[ReviewDate] = @ReviewDate,
										[MustRead] = @MustRead,
										[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
										[UpdatedDateTime] = @CurrentDate,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[CompanyId] = @CompanyId
										WHERE Id = @PolicyId

					UPDATE [PolicyUser] SET [Role] = @SelectedRoles,
											[User] = @SelectedUsers,
											[UpdatedDateTime] = @CurrentDate,
											[UpdatedByUserId] = @OperationsPerformedBy
										WHERE PolicyId = @PolicyId

				END

				SELECT Id FROM [Policy] WHERE Id = @PolicyId

			END
			END
			ELSE
			BEGIN

				RAISERROR (@HavePermission,11, 1)
					
			END
		END TRY
		BEGIN CATCH
	  
	  		THROW
	  
		END CATCH
END
GO