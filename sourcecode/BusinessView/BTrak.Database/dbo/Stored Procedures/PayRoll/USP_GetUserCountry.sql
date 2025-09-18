CREATE PROCEDURE [dbo].[USP_GetUserCountry]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

DECLARE @CountryName NVARCHAR(250)

SET @CountryName = (SELECT CountryName FROM Country C
LEFT JOIN [EmployeeContactDetails] ECD ON ECD.CountryId = C.Id AND ECD.InActiveDateTime IS Null
LEFT JOIN [Employee] E ON E.Id = ECD.EmployeeId  AND E.InActiveDateTime IS Null
LEFT JOIN [User] U ON U.Id = E.UserId  AND U.InActiveDateTime IS Null
WHERE U.CompanyId = @CompanyId AND U.Id = @OperationsPerformedBy)

SELECT @CountryName

END
