CREATE PROCEDURE [dbo].[USP_GetUserAuthToken]
(	
	@UserName VARCHAR(50)
)
AS
BEGIN
	
	SET NOCOUNT ON;    
	SELECT AuthToken FROM [dbo].[UserAuthToken] WITH (NOLOCK) WHERE UserName=@UserName;
END