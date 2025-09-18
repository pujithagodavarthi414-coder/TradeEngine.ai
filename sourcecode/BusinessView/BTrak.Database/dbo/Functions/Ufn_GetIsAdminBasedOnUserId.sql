CREATE FUNCTION [dbo].[Ufn_GetIsAdminBasedOnUserId]
(
	@UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN

	DECLARE @IsAdmin INT = (SELECT IsAdmin FROM [User] WHERE Id = @UserId  AND InActiveDateTime IS NULL)

	RETURN @IsAdmin

END