CREATE FUNCTION [dbo].[Ufn_GetUsernameBasedOnUserId]
(
	@UserId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(250)
AS
BEGIN

	DECLARE @Username NVARCHAR(250) = (SELECT FirstName + SurName  FROM [User] WHERE Id = @UserId AND InActiveDateTime IS NULL)

	RETURN @Username

END