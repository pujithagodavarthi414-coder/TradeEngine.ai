
CREATE PROCEDURE [dbo].[USP_GetUserWebHooksById]
(
	@UserId UNIQUEIDENTIFIER
)

AS

SET NOCOUNT ON

SELECT 

WebHooksXml  AS WebHookXml,
UserId

FROM [UserWebHooks]

WHERE UserId = @UserId  AND InActiveDatetime IS NULL