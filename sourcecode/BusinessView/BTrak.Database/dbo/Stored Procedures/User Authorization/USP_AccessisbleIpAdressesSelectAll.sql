CREATE PROCEDURE [dbo].[USP_AccessisbleIpAdressesSelectAll]

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