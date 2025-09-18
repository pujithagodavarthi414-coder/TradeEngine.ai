CREATE PROCEDURE [dbo].[USP_UpdateUserForgottenPassword]
(
    @ResetGuid UNIQUEIDENTIFIER = NULL,
    @NewPassword NVARCHAR(250) = NULL,
    @ConfirmPassword NVARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
       
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		  
        DECLARE @ChangedToUserId UNIQUEIDENTIFIER = NULL

        IF(@ResetGuid IS NOT NULL) 
        BEGIN
                
            SET @ChangedToUserId = (SELECT UserId FROM ResetPassword WHERE ResetGuid = @ResetGuid)
        
            DECLARE @Currentdate DATETIME = GETDATE()
                
			    	UPDATE [User]
			    		SET [Password] = @NewPassword,
			    		    [UpdatedByUserId] = @ChangedToUserId,
			    			[UpdatedDateTime] = @Currentdate
			    			WHERE Id = @ChangedToUserId 

			UPDATE ResetPassword SET IsExpired = 1 WHERE ResetGuid = @ResetGuid
			                            
            SELECT Id FROM [dbo].[User] WHERE Id = @ChangedToUserId
            
        END
			
    END TRY  
    BEGIN CATCH 
        
        THROW

    END CATCH
END