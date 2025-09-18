CREATE PROCEDURE [dbo].[USP_GetUserDetailsAndCountry]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN

-- DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

DECLARE @CountryName NVARCHAR(250)

SELECT C.CountryName,U.MobileNo,U.UserName AS Email, CountryCode, U.UserName AS UserName, FirstName + ' '+SurName as FullName FROM [User] U 
LEFT JOIN [Employee] E ON E.UserId = U.Id
LEFT JOIN [EmployeeContactDetails] ECD ON ECD.EmployeeId=E.Id
LEFT JOIN [Country] C ON C.Id = ECD.CountryId
WHERE U.CompanyId = @CompanyId AND (U.Id = @OperationsPerformedBy OR U.UserAuthenticationId = @OperationsPerformedBy)

END