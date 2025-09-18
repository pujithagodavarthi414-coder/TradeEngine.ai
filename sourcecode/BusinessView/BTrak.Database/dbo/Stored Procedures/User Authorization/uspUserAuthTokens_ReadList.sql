CREATE PROCEDURE [dbo].[uspUserAuthTokens_ReadList]
AS
BEGIN

   DECLARE @ErrorCode INT;
   SET @ErrorCode = 0;

    SELECT [UserAuthTokenId],
        [UserId],
        [UserName],
        [DateCreated],
        [AuthToken],
		[CompanyId]
    FROM [dbo].[UserAuthTokens];
    
   IF (@@ERROR <> 0)
   BEGIN
       SET @ErrorCode = 1;
       GOTO Cleanup;
   END
   
   RETURN @ErrorCode;

Cleanup:

   RETURN @ErrorCode;

END