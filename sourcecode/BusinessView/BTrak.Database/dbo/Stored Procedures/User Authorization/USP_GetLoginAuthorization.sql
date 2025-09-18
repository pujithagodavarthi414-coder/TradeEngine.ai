-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-15 00:00:00.000'
-- Purpose      To Get the Authorization with Email and Password
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--    EXEC [dbo].[USP_GetLoginAuthorization] @EmailId='srihari@snovasys.com',@Password='gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi'

CREATE PROCEDURE [dbo].[USP_GetLoginAuthorization]
(
    @EmailId NVARCHAR(250) = NULL,
    @Password NVARCHAR(250) = NULL
)
AS
BEGIN
        SET NOCOUNT ON
       
       	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		SELECT IIF((SELECT Id FROM [User] WHERE UserName = @EmailId COLLATE SQL_Latin1_General_CP1_CS_AS AND [Password] = @Password COLLATE SQL_Latin1_General_CP1_CS_AS) IS NOT NULL,1,0)
       
       END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END
GO