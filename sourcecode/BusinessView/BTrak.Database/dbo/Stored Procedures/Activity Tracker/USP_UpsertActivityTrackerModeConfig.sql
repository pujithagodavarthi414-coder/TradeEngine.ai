CREATE PROCEDURE [dbo].[USP_UpsertActivityTrackerModeConfig]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ConfigId UNIQUEIDENTIFIER NULL,
	@CompanyId UNIQUEIDENTIFIER NULL,
	@RoleIds NVARCHAR(MAX),
	@ModeId UNIQUEIDENTIFIER,
	@PunchCardBased BIT NULL,
	@ShiftBased BIT NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN
			DECLARE @IsInsert BIT

			SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
			SET @ConfigId = (SELECT TOP 1 Id FROM [ActivityTrackerModeConfiguration] WHERE CompanyId = @CompanyId AND ModeId = @ModeId)

			IF(@ConfigId IS NULL OR @ConfigId = '00000000-0000-0000-0000-000000000000')
			BEGIN
				SET @IsInsert = 1
			END
			ELSE
			BEGIN
				SET @IsInsert = 0
			END

			IF(@IsInsert = 1)
			BEGIN
				
				INSERT INTO [dbo].[ActivityTrackerModeConfiguration](
									[Id],
									[CompanyId],
									[ModeId],
									[Roles],
									[PunchCardBased],
									[ShiftBased],
									[CreatedByUserId],
									[CreatedDateTime]
									)
							SELECT NEWID(),
								   @CompanyId,
								   @ModeId,
								   @RoleIds,
								   @PunchCardBased,
								   @ShiftBased,
								   @OperationsPerformedBy,
								   GETUTCDATE()
			END
			ELSE
			BEGIN
				
				UPDATE [dbo].[ActivityTrackerModeConfiguration]
						SET [CompanyId] = @CompanyId,
								[ModeId] = @ModeId,
								[Roles] = @RoleIds,
								[PunchCardBased] = @PunchCardBased,
								[ShiftBased] = @ShiftBased,
								UpdatedByUserId = @OperationsPerformedBy,
								UpdatedDateTime = GETUTCDATE()
					WHERE Id = @ConfigId

			END

			-- permissions config
			DECLARE @Roles TABLE
			(
				RoleId UNIQUEIDENTIFIER,
				RowNumber INT,
				AddOrRemoveTrackerPermission BIT NULL,
				AddOrRemoveMessengerPermission BIT NULL
			)

			INSERT INTO @Roles
			SELECT R.Id RoleId, ROW_NUMBER() OVER (ORDER BY R.Id) AS RowNumber, NULL, NULL
			FROM  [dbo].[Role] AS R WITH (NOLOCK)
			WHERE (R.CompanyId = @CompanyId)
				AND R.InActiveDateTime IS NULL
				AND (R.IsHidden IS NULL OR R.IsHidden = 0)

			DECLARE @MinRow INT = 1
			DECLARE @MaxRow INT = (SELECT MAX(RowNumber) FROM @Roles)

			DECLARE @ActivityTrackerFeatureId UNIQUEIDENTIFIER = '2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D'
			DECLARE @MessengerFeatureId UNIQUEIDENTIFIER = '5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3'

			WHILE(@MinRow <= @MaxRow)
			BEGIN
				DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT TOP 1 RoleId FROM @Roles WHERE RowNumber = @MinRow)
				DECLARE @AddOrRemoveTrackerPermission BIT = 0
				DECLARE @AddOrRemoveMessengerPermission BIT = 0

				IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration WHERE CHARINDEX(CONVERT(NVARCHAR(50), @RoleId), Roles) > 0) > 0)
				BEGIN
					SET @AddOrRemoveTrackerPermission = 1
				END

				IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration WHERE CHARINDEX(CONVERT(NVARCHAR(50), @RoleId), Roles) > 0 AND ModeId = '11A41B04-FCAB-4457-B42A-05CA8DD12616') > 0)
				BEGIN
					SET @AddOrRemoveMessengerPermission = 1
				END

				IF(@AddOrRemoveTrackerPermission = 1)
				BEGIN
					IF((SELECT COUNT(*) FROM RoleFeature WHERE FeatureId = @ActivityTrackerFeatureId AND RoleId = @RoleId) > 0)
					BEGIN
						UPDATE RoleFeature SET InActiveDateTime = NULL WHERE FeatureId = @ActivityTrackerFeatureId AND RoleId = @RoleId
					END
					ELSE
					BEGIN
						INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
						VALUES (NEWID(), @RoleId, @ActivityTrackerFeatureId, @OperationsPerformedBy, GETUTCDATE())
					END
				END
				ELSE
				BEGIN
					UPDATE RoleFeature SET InActiveDateTime = GETUTCDATE() WHERE FeatureId = @ActivityTrackerFeatureId AND RoleId = @RoleId
				END

				IF(@AddOrRemoveMessengerPermission = 1)
				BEGIN
					IF((SELECT COUNT(*) FROM RoleFeature WHERE FeatureId = @MessengerFeatureId AND RoleId = @RoleId) > 0)
					BEGIN
						UPDATE RoleFeature SET InActiveDateTime = NULL WHERE FeatureId = @MessengerFeatureId AND RoleId = @RoleId
					END
					ELSE
					BEGIN
						INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
						VALUES (NEWID(), @RoleId, @MessengerFeatureId, @OperationsPerformedBy, GETUTCDATE())
					END
				END
				ELSE
				BEGIN
					UPDATE RoleFeature SET InActiveDateTime = GETUTCDATE() WHERE FeatureId = @MessengerFeatureId AND RoleId = @RoleId
				END
				SET @MinRow = @MinRow + 1
			END

			SELECT 1
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END