--CREATE PROCEDURE [dbo].[USP_CheckFormType]
--(
--@CustomApplicationId uniqueidentifier
--)
--AS
--BEGIN
--   SET NOCOUNT ON
--   BEGIN TRY		 
--select count(*) from FormType ft
--join GenericForm as gf on gf.FormTypeId = ft.Id

--where ca.Id = @CustomApplicationId and ft.FormTypeName = 'Notification'

--   END TRY
--   BEGIN CATCH
       
--       THROW

--   END CATCH 
--END
--GO