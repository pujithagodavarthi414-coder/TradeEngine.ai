CREATE PROCEDURE [dbo].[uspUserAuthTokens_Create] 
(
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
    
    INSERT INTO [dbo].[UserAuthToken] (
		Id,
        [UserId],
        [UserName],
        [DateCreated],
		[AuthToken],
		[CompanyId]
        )
    VALUES (
		newid(),
        @UserId,
        @UserName,
        @DateCreated,
        @AuthToken,
		@CompanyId
        );

   IF (@@ERROR <> 0)
   BEGIN
       SET @ErrorCode = 1;
       GOTO Cleanup;
   END         
   
   RETURN @ErrorCode;

Cleanup:

   RETURN @ErrorCode;

END