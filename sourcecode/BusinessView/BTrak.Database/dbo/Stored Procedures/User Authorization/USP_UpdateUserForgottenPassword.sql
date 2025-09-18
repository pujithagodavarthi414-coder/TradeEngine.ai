-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-08-11 00:00:00.000'
-- Purpose      To Update the Password Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpdateUserForgottenPassword] @ResetGuid = '559DD683-0FD5-4A13-B2E6-45964645489B',
-- ,@NewPassword='dgwejwsjhgdei',@ConfirmPassword ='dgwejwsjhgdei'
-------------------------------------------------------------------------------
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
GO
