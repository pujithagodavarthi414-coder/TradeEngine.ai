CREATE PROCEDURE [dbo].[USP_UserAuthTokens_ReadItem]
(
    @UserId [uniqueidentifier],
    @CompanyId [uniqueidentifier]
)
AS
BEGIN

   DECLARE @ErrorCode INT;
   SET @ErrorCode = 0;

    SELECT Id,
        [UserId],
        [UserName],
        [DateCreated],
        [AuthToken],
		[CompanyId]
    FROM [dbo].UserAuthToken
    WHERE [UserId] = @UserId AND [CompanyId] = @CompanyId
    ORDER BY DateCreated DESC

   IF (@@ERROR <> 0)
   BEGIN
       SET @ErrorCode = 1;
       GOTO Cleanup;
   END
   
   RETURN @ErrorCode;

Cleanup:

   RETURN @ErrorCode;

END