CREATE PROCEDURE [dbo].[uspUserAuthTokens_Delete] 
(
    @UserId [uniqueidentifier]
)
AS
BEGIN

    DECLARE @ErrorCode INT;
   SET @ErrorCode = 0;
    
    DECLARE @TranStarted BIT;
   SET @TranStarted = 0;

   IF (@@TRANCOUNT = 0)
   BEGIN
        BEGIN TRANSACTION;
        SET @TranStarted = 1;
   END
   ELSE
    BEGIN
       SET @TranStarted = 0;
   END

    DELETE FROM [dbo].[UserAuthToken]
   WHERE [UserId] = @UserId;

   IF( @@ERROR <> 0)
   BEGIN
       SET @ErrorCode = 1;
       GOTO Cleanup;
   END           
   
   IF (@@ERROR <> 0 OR @@ROWCOUNT <> 1)
   BEGIN
       SET @ErrorCode = 2;
       GOTO Cleanup;
   END         
   
   IF (@TranStarted = 1)
   BEGIN
        SET @TranStarted = 0;
        COMMIT TRANSACTION;
   END

   RETURN @ErrorCode;

Cleanup:

   IF (@TranStarted = 1)
   BEGIN
       SET @TranStarted = 0;
       ROLLBACK TRANSACTION;
   END

   RETURN @ErrorCode;

END