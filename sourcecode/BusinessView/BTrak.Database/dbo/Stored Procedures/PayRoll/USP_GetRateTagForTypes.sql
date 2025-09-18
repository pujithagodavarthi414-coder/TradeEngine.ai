CREATE PROCEDURE USP_GetRateTagForTypes
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

 SELECT * FROM
 (
	SELECT Id RateTagForId, RateTagForName,'RateTag' RateTagForType, 1 [Order] FROM RateTagFor WHERE CompanyId = @CompanyId
	UNION
	SELECT Id RateTagForId, PartsOfDayName,'PartsOfDay' RateTagForType, 2 [Order] FROM PartsOfDay WHERE CompanyId = @CompanyId
	UNION
	SELECT Id RateTagForId, WeekDayName,'WeekDays' RateTagForType, 3 [Order] FROM WeekDays WHERE CompanyId = @CompanyId
	UNION
	SELECT Id RateTagForId, Reason,'Holiday' RateTagForType, 4 [Order] FROM Holiday WHERE CompanyId = @CompanyId
	UNION
	SELECT Id RateTagForId, Reason,'SpecificDay' RateTagForType, 5 [Order] FROM SpecificDay WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL
 ) T
 ORDER BY [Order],RateTagForName

END
GO