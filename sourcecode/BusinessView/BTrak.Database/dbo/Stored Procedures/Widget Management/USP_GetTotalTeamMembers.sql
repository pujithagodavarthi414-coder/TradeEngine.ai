CREATE PROCEDURE [dbo].[USP_GetTotalTeamMembers]
(
@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN 
SET NOCOUNT ON

BEGIN TRY
	DECLARE @HavePermission NVARCHAR(250)  = 1 --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	IF(@HavePermission= '1')
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)

		SELECT TeamMembers 
			FROM Ufn_TeamMembersCount(@OperationsPerformedBy,@CompanyId)
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