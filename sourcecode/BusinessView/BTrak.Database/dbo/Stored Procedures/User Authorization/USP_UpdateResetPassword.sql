-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-18 00:00:00.000'
-- Purpose      To Update Reset Password
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpdateResetPassword]@ResetId='61E0890F-B976-478B-B34D-237BC197A41D'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateResetPassword]
(
    @ResetId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
        SET NOCOUNT ON
       	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		   IF(GETDATE() > (SELECT ExpiredDateTime FROM ResetPassword WHERE ResetGuid = @ResetId))
           BEGIN

               UPDATE ResetPassword SET IsExpired = 1 WHERE ResetGuid = @ResetId
               SELECT 1 AS IsExpired

           END
           ELSE 
		   BEGIN 
               SELECT IsExpired FROM ResetPassword WHERE ResetGuid = @ResetId
		   END

       END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END
GO