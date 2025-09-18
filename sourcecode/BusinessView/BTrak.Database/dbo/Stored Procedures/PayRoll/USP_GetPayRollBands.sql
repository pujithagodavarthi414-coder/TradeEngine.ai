CREATE PROCEDURE [dbo].[USP_GetPayRollBands]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT= NULL
)
AS
BEGIN

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

SELECT  
PRB.[Name] ParentName,
dbo.Ufn_GetCurrency(CU.CurrencyCode,PB.FromRange,1) ModifiedFromRange,
dbo.Ufn_GetCurrency(CU.CurrencyCode,PB.ToRange,1) ModifiedToRange,
PB.Id PayRollBandId, 
PB.[Name], 
PB.FromRange, 
PB.ToRange, 
PB.[Percentage],
PB.ActiveFrom, 
PB.ActiveTo, 
PB.[TimeStamp], 
PB.ParentId,
PB.CountryId,
C.CountryName,
PB.PayRollComponentId,
PRC.ComponentName PayRollComponentName,
PB.MinAge, 
PB.MaxAge, 
PB.ForMale, 
PB.ForFemale, 
PB.Handicapped, 
PB.IsMarried,
PB.[Order]
FROM PayRollBands PB
LEFT JOIN PayRollBands PRB ON PRB.Id = PB.ParentId
INNER JOIN Country C ON C.Id = PB.CountryId
INNER JOIN Company COM on COM.Id = C.CompanyId
LEFT JOIN PayrollComponent PRC on PRC.Id = PB.PayRollComponentId
LEFT JOIN SYS_Currency CU on CU.Id = COM.CurrencyId
WHERE C.CompanyId = @CompanyId 
AND (@IsArchived IS NULL
	 OR (@IsArchived = 1 AND PB.InActiveDateTime IS NOT NULL)
     OR (@IsArchived = 0 AND PB.InActiveDateTime IS NULL))	
END