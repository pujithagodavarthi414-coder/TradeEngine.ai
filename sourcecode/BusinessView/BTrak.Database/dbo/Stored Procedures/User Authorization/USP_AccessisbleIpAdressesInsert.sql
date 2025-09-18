CREATE PROCEDURE [dbo].[USP_AccessisbleIpAdressesInsert]
(
	@Id uniqueidentifier,
	@CompanyId uniqueidentifier,
	@Name nvarchar(250),
	@IpAddress nvarchar(250),
	@CreatedDateTime datetime,
	@CreatedByUserId uniqueidentifier,
	@UpdatedDateTime datetime,
	@UpdatedByUserId uniqueidentifier
)

AS

SET NOCOUNT ON

INSERT INTO [AccessisbleIpAdresses]
(
	[Id],
	[CompanyId],
	[Name],
	[IpAddress],
	[CreatedDateTime],
	[CreatedByUserId],
	[UpdatedDateTime],
	[UpdatedByUserId]
)
VALUES
(
	@Id,
	@CompanyId,
	@Name,
	@IpAddress,
	@CreatedDateTime,
	@CreatedByUserId,
	@UpdatedDateTime,
	@UpdatedByUserId
)