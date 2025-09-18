CREATE PROCEDURE USP_GetCustomFormIdByName
(
@FormName nvarchar(max)
)
AS
BEGIN
select * from CustomApplicationForms cpf
join CustomApplication as ca on ca.Id = cpf.CustomApplicationId
where ca.CustomApplicationName = @FormName
END