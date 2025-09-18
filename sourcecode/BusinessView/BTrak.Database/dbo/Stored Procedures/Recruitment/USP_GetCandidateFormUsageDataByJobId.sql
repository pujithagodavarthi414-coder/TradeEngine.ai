CREATE PROCEDURE [dbo].[USP_GetCandidateFormUsageDataByJobId]
(
@JobOpeningId UNIQUEIDENTIFIER
)
AS 
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER,@OperationsPerformedBy UNIQUEIDENTIFIER
		SET @CompanyId = (SELECT CompanyId FROM JobOpening WHERE Id = @JobOpeningId)
		--SET @OperationsPerformedBy = (SELECT TOP(1)Id FROM [User] WHERE CompanyId = @CompanyId AND UserName = 'Support@snovasys.com')
		SET @OperationsPerformedBy = (SELECT TOP(1) U.Id
											FROM UserRole UR 
											INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId
											WHERE R.IsHidden = 1 AND U.CompanyId = @CompanyId)

		SELECT @OperationsPerformedBy AS LoggedInUserId, @CompanyId AS CompanyGuid
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END