CREATE PROCEDURE [dbo].[USP_GetActivityTrackerModeConfig]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT TOP 1 CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			SELECT 
				Id,
				CompanyId,
				ModeId,
				Roles AS RolesIdsString,
				ShiftBased,
				PunchCardBased
			FROM [dbo].[ActivityTrackerModeConfiguration]
			WHERE CompanyId = @CompanyId
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END