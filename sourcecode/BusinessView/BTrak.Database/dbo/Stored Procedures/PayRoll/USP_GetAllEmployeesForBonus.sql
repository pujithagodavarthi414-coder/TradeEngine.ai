CREATE PROCEDURE [dbo].[USP_GetAllEmployeesForBonus]
(
@CompanyId uniqueidentifier
)
AS
BEGIN
SELECT EMP.Id AS EmployeeId, US.FirstName + ' ' + ISNULL(US.SurName,'') AS NickName, US.CompanyId,US.ProfileImage FROM Employee EMP
JOIN [User] AS US ON US.Id = EMP.UserId and US.IsActive = 1
WHERE US.CompanyId = @CompanyId 
ORDER BY (US.FirstName + ' ' + US.SurName)
END