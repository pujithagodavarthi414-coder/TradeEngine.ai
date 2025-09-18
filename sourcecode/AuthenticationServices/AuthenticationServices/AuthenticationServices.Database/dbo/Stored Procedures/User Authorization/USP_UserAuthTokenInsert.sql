CREATE PROCEDURE [dbo].[USP_UserAuthTokenInsert]
(
	@Id uniqueidentifier,
	@UserId uniqueidentifier,
	@UserName nvarchar(50),
	@DateCreated datetime,
	@AuthToken NVARCHAR(MAX),
	@CompanyId uniqueidentifier
)
AS
BEGIN
SET NOCOUNT ON

	IF(EXISTS(SELECT * FROM UserAuthToken WHERE UserId = @UserId AND CompanyId = @CompanyId))
	BEGIN
		UPDATE [UserAuthToken] 
		SET AuthToken = @AuthToken,
			DateCreated = @DateCreated
		WHERE UserId = @UserId AND CompanyId = @CompanyId
	END
	ELSE
	BEGIN
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
	END

END