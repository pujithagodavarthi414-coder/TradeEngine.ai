CREATE PROCEDURE [dbo].[uspUserAuthTokens_Update]
(
    @UserAuthTokenId [uniqueidentifier],
    @UserId [uniqueidentifier],
    @UserName NVARCHAR(255),
    @DateCreated DATETIME,
    @AuthToken NVARCHAR(500),
	@CompanyId [uniqueidentifier]
)
AS
BEGIN

    DECLARE @ErrorCode INT;
   SET @ErrorCode = 0;
            
    UPDATE [dbo].[UserAuthTokens]
    SET [UserId] = @UserId,
        [UserName] = @UserName,
        [DateCreated] = @DateCreated,
        [AuthToken] = @AuthToken,
		[CompanyId] = @CompanyId
    WHERE [UserAuthTokenId] = @UserAuthTokenId;
           
   IF (@@ERROR <> 0)
   BEGIN
       SET @ErrorCode = 1;
       GOTO Cleanup;
   END         
   
   RETURN @ErrorCode;

Cleanup:

   RETURN @ErrorCode;

END