CREATE PROCEDURE [dbo].[USP_AccessisbleIpAdressesDelete]
(
	@Id uniqueidentifier
)

AS

SET NOCOUNT ON

DELETE FROM [AccessisbleIpAdresses]
WHERE [Id] = @Id