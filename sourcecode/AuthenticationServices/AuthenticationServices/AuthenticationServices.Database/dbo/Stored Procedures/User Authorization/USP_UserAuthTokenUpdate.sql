CREATE PROCEDURE [dbo].[USP_UserAuthTokenUpdate]
(
	@Id uniqueidentifier,
	@UserId uniqueidentifier,
	@UserName nvarchar(50),
	@DateCreated datetime,
	@AuthToken NVARCHAR(MAX),
	@CompanyId uniqueidentifier
)

AS

SET NOCOUNT ON

UPDATE [UserAuthToken] 
	SET AuthToken = @AuthToken,
		DateCreated = @DateCreated
	WHERE UserId = @UserId AND CompanyId = @CompanyId