CREATE PROCEDURE USP_GetPayrollConfiguration
(
@CompanyId uniqueidentifier
)
AS
BEGIN
select ept.Id, emp.Id as EmployeeId, (us.FirstName + us.SurName) as EmployeeName, ept.PayrollTemplateId, ept.PayrollName ,ept.ActiveFrom, ept.ActiveTo, ept.IsApproved from Employee emp
join [User] as us on us.Id = emp.UserId and us.IsActive = 1
left join (select epc.EmployeeId, epc.PayrollTemplateId, epc.Id, pt.PayrollName, epc.ActiveFrom, epc.ActiveTo, epc.IsApproved from EmployeepayrollConfiguration epc
join PayrollTemplate as pt on pt.Id = epc.PayrollTemplateId) as ept on ept.EmployeeId = emp.Id
where us.CompanyId = @CompanyId

END