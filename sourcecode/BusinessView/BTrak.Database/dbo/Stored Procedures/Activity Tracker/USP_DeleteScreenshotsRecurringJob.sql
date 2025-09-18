-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-16 00:00:00.000'
-- Purpose      Delete Screenshots after companies data exceeds limit
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_DeleteScreenshotsRecurringJob]

CREATE PROCEDURE [dbo].[USP_DeleteScreenshotsRecurringJob]
(
  @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
     SET NOCOUNT ON
	 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
     BEGIN TRY
	     
		 DECLARE Cursor_Script CURSOR
			FOR SELECT Id AS ComapnyId
						  FROM Company
			              WHERE (@CompanyId IS NULL OR Id = @CompanyId)
         
            OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
             
				WHILE @@FETCH_STATUS = 0
				BEGIN
				 
				        DECLARE @MaxDataDeleteAfter AS INT

						DECLARE @CurrentDate DATETIME = GETDATE()

						--SET @MaxDataDeleteAfter = (SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = @UserId) AND [Key] = 'DeleteScreenshotDataBefore')
          
						SET @MaxDataDeleteAfter = 30 --- ToDo
					
						DELETE AC FROM ActivityScreenShot AC
						       INNER JOIN [User] U ON U.Id = AC.UserId
						WHERE U.CompanyId = @CompanyId
						      AND AC.CreatedDateTime < (@CurrentDate - @MaxDataDeleteAfter)

					FETCH NEXT FROM Cursor_Script INTO 
					@CompanyId
                
                END
             
           CLOSE Cursor_Script
         
          DEALLOCATE Cursor_Script
	     
		      
	 END TRY  
	 BEGIN CATCH 
		
	   THROW

	 END CATCH
END