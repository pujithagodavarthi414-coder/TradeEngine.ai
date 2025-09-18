CREATE PROCEDURE USP_GetTemplateIdByName
(
@TemplateName nvarchar(max),
@CompanyId uniqueidentifier
)
AS
BEGIN
select tmp.Id from templates tmp
join Project as p on p.Id = tmp.ProjectId
where p.CompanyId = @CompanyId and TemplateName = @TemplateName
END

