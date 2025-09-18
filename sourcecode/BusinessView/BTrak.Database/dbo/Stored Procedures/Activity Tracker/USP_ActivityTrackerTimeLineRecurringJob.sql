-- EXEC [dbo].[USP_ActivityTrackerTimeLineRecurringJob]
CREATE PROCEDURE [dbo].[USP_ActivityTrackerTimeLineRecurringJob]
(
    @Date DATE = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL

)AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY

			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
            
            DECLARE @UserId UNIQUEIDENTIFIER
                    ,@CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
		    
            DECLARE Cursor_Script CURSOR
            FOR SELECT C.Id AS ComapnyId
                FROM Company C
                WHERE (@OperationsPerformedBy IS NULL OR C.Id = @CompanyId)
         
            OPEN Cursor_Script
         
                FETCH NEXT FROM Cursor_Script INTO 
                    @CompanyId
             
                WHILE @@FETCH_STATUS = 0
                BEGIN
               
                   SET @UserId = (SELECT TOP(1) U.Id FROM [User] U 
		    	                  WHERE U.CompanyId = @CompanyId
                                  AND IsActive = 1 AND InActiveDateTime IS NULL)
               
              
                    IF(@CompanyId IS NOT NULL AND @UserId IS NOT NULL)
                    BEGIN
                    
		    			EXEC [dbo].[USP_AppUsageReport] @Date = @Date,@OperationsPerformedBy = @UserId

                    END

                    FETCH NEXT FROM Cursor_Script INTO 
                    @CompanyId
                
                    SELECT @UserId = NULL
        
                END
             
            CLOSE Cursor_Script
         
            DEALLOCATE Cursor_Script

 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO