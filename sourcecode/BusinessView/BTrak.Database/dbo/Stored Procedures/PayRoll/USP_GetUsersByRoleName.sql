CREATE PROCEDURE [USP_GetUsersByRoleName]
(
@RoleName nvarchar(200),
@CompanyId uniqueidentifier
)
AS
BEGIN
SELECT US.UserName as Email, US.* FROM [User] US
JOIN UserRole AS USR ON USR.UserId = US.Id
JOIN [ROLE] AS RS ON RS.Id = USR.RoleId
WHERE RS.RoleName = @RoleName and RS.CompanyId = @CompanyId and usr.InactiveDateTime is null
END