---------------------------------------------------------------------------
-- Author       Siva Kumar Garadappagari
-- Created      '2021-01-18'
-- Purpose      To add or update integration at company level
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_AddOrUpdateCompanyLevelIntegration] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_AddOrUpdateCompanyLevelIntegration]
(
	@Id UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IntegrationTypeId UNIQUEIDENTIFIER = NULL,
	@IntegrationUrl NVARCHAR(250) = NULL,
	@UserName NVARCHAR(250) = NULL,
	@ApiToken NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @InActiveDateTime DATETIME = NULL
		DECLARE @DuplicateIntegrationUrl INT = (SELECT COUNT(1) FROM [CompanyLevelIntegrations] WHERE [IntegrationUrl] = @IntegrationUrl AND CompanyId = @CompanyId AND [IntegrationTypeId] = @IntegrationTypeId)
		IF(@IntegrationUrl = '') SET @IntegrationUrl = NULL
		IF(@UserName = '') SET @UserName = NULL
		IF(@ApiToken = '') SET @ApiToken = NULL
		IF(@IsArchived = '' OR @IsArchived = 0) SET @IsArchived = NULL
		IF(@IsArchived = 1) SET @InActiveDateTime = GETDATE()
		
		IF(@IntegrationTypeId IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'IntegrationType')
		END
		ELSE IF(@IntegrationUrl IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'IntegrationUrl')
		END
		ELSE IF(@UserName IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'UserName')
		END
		ELSE IF(@ApiToken IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'ApiToken')
		END
		ELSE
		BEGIN
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF (@HavePermission = '1')
			BEGIN
				DECLARE @IsLatest BIT = CASE WHEN @Id IS NULL THEN 1 ELSE 0 END
				DECLARE @CurrentDate DATETIME = GETDATE()
				DECLARE @CurrentUserId UNIQUEIDENTIFIER = @OperationsPerformedBy

				IF(@IsLatest = '1')
				BEGIN
					
					IF(@DuplicateIntegrationUrl > 0)
					BEGIN
						RAISERROR(50001,16,1,'IntegrationUrl')
					END
					ELSE
					BEGIN
					SET @Id = NEWID()
					INSERT INTO [dbo].[CompanyLevelIntegrations](
																[Id],
																[IntegrationTypeId],
																[IntegrationUrl],
																[UserName],
																[ApiToken],
																[CompanyId],
																[CreatedByUserId],
																[CreatedDateTime],
																[InactiveDateTime])
														SELECT	@Id,
																@IntegrationTypeId,
																@IntegrationUrl,
																@UserName,
																@ApiToken,
																@CompanyId,
																@CurrentUserId,
																@CurrentDate,
																@InActiveDateTime
					END
				END
				ELSE
				BEGIN
				--update
					UPDATE [CompanyLevelIntegrations]
											SET [IntegrationTypeId] = @IntegrationTypeId,
												[IntegrationUrl] = @IntegrationUrl,
												[UserName] = @UserName,
												[ApiToken] = @ApiToken,
												[UpdatedByUserId] = @CurrentUserId,
												[UpdatedDateTime] = @CurrentDate,
												[InactiveDateTime] = @InActiveDateTime
											WHERE [Id] = @Id
				END
				SELECT [Id] FROM [CompanyLevelIntegrations] WHERE [Id] = @Id
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