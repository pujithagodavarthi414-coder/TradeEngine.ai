CREATE FUNCTION [dbo].[Ufn_GetRequiredPreviousDateExcludingNonWorkingDays] 
(
	@NumberOfDays INT
)
RETURNS DATETIME
AS 
BEGIN
 DECLARE @RequiredDate DATETIME  
 DECLARE @Dates TABLE(
  d DATE,
  isWeekend BIT,
  isHoliday BIT,
  PRIMARY KEY (d)
)
DECLARE @dIncr DATE = DATEADD(MONTH,-6, getdate())
DECLARE @dEnd DATE = getdate()


WHILE ( @dIncr < @dEnd )
BEGIN

  INSERT INTO @Dates (d, isWeekend) VALUES( @dIncr,  IIF(DATEPART(WEEKDAY, @dIncr) IN (7, 1), 1, NULL ))
  SELECT @dIncr = DATEADD(DAY, 1, @dIncr )
END

UPDATE @Dates SET isHoliday = 1 
FROM @Dates D JOIN Holiday H ON D.d = H.Date

DECLARE @Dates1 TABLE(
  d1 DATE 
)
INSERT INTO @Dates1 (d1) 
SELECT Top(@NumberOfDays) d FROM @Dates where isWeekend IS NULL AND isHoliday IS NULL  Order by d desc

SET @RequiredDate = (SELECT Top(1) d1 FROM @Dates1 ORDER BY d1 Asc)
	
RETURN @RequiredDate

END