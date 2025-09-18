--EXEC [dbo].[USP_GetComponents] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetComponents]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ComponentName NVARCHAR(500) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		
           SELECT C.Id AS ComponentId,
				  C.[ComponentName]
           FROM Component AS C		
		   WHERE (@ComponentName IS NULL OR C.ComponentName = @ComponentName)
           ORDER BY C.[ComponentName] ASC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO