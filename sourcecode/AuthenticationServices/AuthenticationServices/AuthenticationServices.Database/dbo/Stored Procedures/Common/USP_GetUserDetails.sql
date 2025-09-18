CREATE PROCEDURE [dbo].[USP_GetUserDetails]
(
	@UserId UNIQUEIDENTIFIER
)

AS

SET NOCOUNT ON

SELECT Id  AS Id,
		FirstName,
		SurName,
		UserName,
		IsActive,
		ProfileImage,
		IsExternal
FROM [User] WITH (NOLOCK)
WHERE Id = @UserId  AND IsActive = 1 AND [InActiveDateTime] IS NULL