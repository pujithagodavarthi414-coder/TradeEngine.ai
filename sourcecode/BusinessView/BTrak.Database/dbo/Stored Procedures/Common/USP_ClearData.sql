CREATE PROCEDURE [dbo].[USP_ClearData]
AS
BEGIN
       SET NOCOUNT ON
	   BEGIN TRY

	       EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?'
           EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
           EXEC sp_MSForEachTable 'DELETE FROM ?'
           EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
           EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?'

	   END TRY  
	   BEGIN CATCH 
		
		     EXEC USP_GetErrorInformation

	  END CATCH
END
GO