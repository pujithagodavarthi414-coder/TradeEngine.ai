CREATE PROCEDURE [dbo].[USP_AccessisbleIpAdressesSelect]
(
	@Id uniqueidentifier
)

AS

SET NOCOUNT ON

SELECT [Id],
	[CompanyId],
	[Name],
	[IpAddress],
	[CreatedDateTime],
	[CreatedByUserId],
	[UpdatedDateTime],
	[UpdatedByUserId]
FROM [AccessisbleIpAdresses]
WHERE [Id] = @Id