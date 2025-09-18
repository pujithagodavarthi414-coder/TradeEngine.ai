CREATE PROCEDURE [dbo].[USP_GetUserNamesByIds]
(
@EmpIds nvarchar(max)
)
AS
BEGIN
select us.UserName as Email, us.UserName, us.FirstName, us.SurName, emp.Id as EmployeeId from Employee emp 
join [User] as us on us.Id = emp.UserId
where emp.Id in (select * from UfnSplit(@EmpIds))
END
