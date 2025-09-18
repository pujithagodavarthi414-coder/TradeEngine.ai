CREATE PROCEDURE [dbo].[USP_GetTaxSlabs]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TaxSlabName NVARCHAR(500) = NULL
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

SELECT  
PTS.[Name] ParentName,
ISNULL(@CountryName,'C') CountryName,
dbo.Ufn_GetCurrency(CU.CurrencyCode,TS.FromRange,1) ModifiedFromRange,
dbo.Ufn_GetCurrency(CU.CurrencyCode,TS.ToRange,1) ModifiedToRange,
TemplateNames = STUFF((SELECT ',' + PayrollName 
					      FROM PayrollTemplateTaxSlab PRTTS
						  INNER JOIN PayrollTemplate PT ON PT.Id = PRTTS.PayRollTemplateId
						  WHERE PRTTS.TaxSlabId = TS.Id
						  ORDER BY PayrollName
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
TemplateIds = STUFF((SELECT ',' +  LOWER(CONVERT(NVARCHAR(50),PayRollTemplateId))  
					      FROM PayrollTemplateTaxSlab PRTTS
						  INNER JOIN PayrollTemplate PT ON PT.Id = PRTTS.PayRollTemplateId
						  WHERE PRTTS.TaxSlabId = TS.Id
						  ORDER BY PayrollName
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
TS.Id TaxSlabId, 
TS.[Name], 
TS.FromRange, 
TS.ToRange, 
TS.TaxPercentage, 
TS.ActiveFrom, 
TS.ActiveTo, 
TS.MinAge, 
TS.MaxAge, 
TS.ForMale, 
TS.ForFemale, 
TS.Handicapped, 
TS.PayrollTemplateId,
TS.[Order], 
TS.IsArchived,
TS.IsFlatRate, 
TS.[TimeStamp], 
TS.ParentId,
TS.CountryId,
C.CountryName,
TS.TaxCalculationTypeId,
TCT.TaxCalculationTypeName
FROM TaxSlabs TS
LEFT JOIN TaxSlabs PTS ON PTS.Id = TS.ParentId
LEFT JOIN Country C ON C.Id = TS.CountryId
INNER JOIN Company COM on COM.Id = C.CompanyId
LEFT JOIN SYS_Currency CU on CU.Id = COM.CurrencyId
LEFT JOIN TaxCalculationType TCT ON TCT.Id = TS.TaxCalculationTypeId
WHERE C.CompanyId = @CompanyId 
AND (@TaxSlabName IS NULL OR TS.[Name] = @TaxSlabName)
END