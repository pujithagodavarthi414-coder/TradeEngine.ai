CREATE PROCEDURE [dbo].[USP_AccessisbleIpAdressesUpdate]
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

UPDATE [AccessisbleIpAdresses]
SET [CompanyId] = @CompanyId,
	[Name] = @Name,
	[IpAddress] = @IpAddress,
	[CreatedDateTime] = @CreatedDateTime,
	[CreatedByUserId] = @CreatedByUserId,
	[UpdatedDateTime] = @UpdatedDateTime,
	[UpdatedByUserId] = @UpdatedByUserId
WHERE [Id] = @Id