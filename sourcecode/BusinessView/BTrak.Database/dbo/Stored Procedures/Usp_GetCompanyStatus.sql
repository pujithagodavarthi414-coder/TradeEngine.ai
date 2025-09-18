CREATE PROCEDURE [dbo].[Usp_GetCompanyStatus]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @CompanyActiveStatus TABLE
	(
		TrailVersion BIT,
		PaidVersion BIT,
		Expired BIT
	)

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	INSERT INTO @CompanyActiveStatus (TrailVersion, PaidVersion, Expired)
	SELECT TrailVersion, PaidVersion, Expired FROM dbo.Ufn_GetCompanyStatus(@CompanyId)

	SELECT * FROM @CompanyActiveStatus
END
GO
