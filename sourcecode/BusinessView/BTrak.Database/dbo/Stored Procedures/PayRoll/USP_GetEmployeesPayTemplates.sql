CREATE PROCEDURE [dbo].[USP_GetEmployeesPayTemplates]
(
@CompanyId uniqueidentifier
)
AS
BEGIN
select distinct emp.Id EmployeeId,pmt.Id as PayRollTemplateId, pmt.PayrollName as PayRollTemplateName from Employee emp
join [User] as us on us.Id = emp.UserId and us.IsActive = 1
join UserRole as usr on usr.UserId = us.Id 
JOIN EmployeeBranch as eb on eb.EmployeeId = emp.Id
join (select distinct pt.Id, pt.PayrollName, pbc.BranchId, pgc.GenderId, prc.RoleId, pmc.MaritalStatusId 
from PayrollTemplate pt
LEFT join PayrollBranchConfiguration as pbc on pbc.PayrollTemplateId = pt.Id and pbc.InactiveDateTime is null
LEFT join PayrollGenderConfiguration as pgc on pgc.PayrollTemplateId = pt.Id and pgc.InactiveDateTime is null
LEFT join PayRollMaritalStatusConfiguration as pmc on pmc.PayrollTemplateId = pt.Id and pmc.InactiveDateTime is null
LEFT join PayrollRoleConfiguration as prc on prc.PayrollTemplateId = pt.Id and prc.InactiveDateTime is null) 
as pmt on pmt.GenderId = emp.GenderId or (pmt.BranchId = emp.BranchId or pmt.BranchId = eb.BranchId) 
or pmt.RoleId = usr.RoleId or pmt.MaritalStatusId = emp.MaritalStatusId
where us.CompanyId = @CompanyId
END