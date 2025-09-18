CREATE PROCEDURE USP_GetProfessionalTaxRanges
(
@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

SELECT 
PTR.Id, 
FromRange, 
dbo.Ufn_GetCurrency(CU.CurrencyCode,FromRange,1) ModifiedFromRange, 
ToRange,
dbo.Ufn_GetCurrency(CU.CurrencyCode,ToRange,1) ModifiedToRange, 
TaxAmount, 
dbo.Ufn_GetCurrency(CU.CurrencyCode,TaxAmount,1) ModifiedTaxAmount, 
IsArchived,
BranchId,
B.BranchName,
ActiveFrom,
ActiveTo
FROM ProfessionalTaxRange PTR
LEFT JOIN Branch B ON B.Id = PTR.BranchId
INNER JOIN Company COM ON COM.Id = B.CompanyId
LEFT JOIN SYS_Currency CU on CU.Id = COM.CurrencyId
WHERE B.CompanyId = @CompanyId
END