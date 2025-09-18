CREATE PROCEDURE [dbo].[USP_UserAuthTokenInsert]
(
	@Id uniqueidentifier,
	@UserId uniqueidentifier,
	@UserName nvarchar(50),
	@DateCreated datetime,
	@AuthToken varchar(800),
	@CompanyId uniqueidentifier
)

AS

SET NOCOUNT ON

INSERT INTO [UserAuthToken]
(
	[Id],
	[UserId],
	[UserName],
	[DateCreated],
	[AuthToken],
	[CompanyId]
)
VALUES
(
	@Id,
	@UserId,
	@UserName,
	@DateCreated,
	@AuthToken,
	@CompanyId
)