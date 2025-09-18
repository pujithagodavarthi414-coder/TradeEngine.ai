CREATE PROCEDURE [dbo].[USP_GetCustomFormIdByName]
(
@FormName nvarchar(max),
@CompanyId uniqueidentifier
)
AS
BEGIN
select * from CustomApplication ca
join CustomApplicationForms caf on caf.CustomApplicationId = ca.Id
join GenericForm as gf on gf.Id = caf.GenericFormId
join FormType as ft on ft.Id = gf.FormTypeId
where CustomApplicationName = @FormName and ft.CompanyId = @CompanyId
END