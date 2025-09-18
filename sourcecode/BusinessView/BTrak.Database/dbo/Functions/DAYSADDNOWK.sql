CREATE FUNCTION [dbo].[DAYSADDNOWK](@addDate AS DATE, @numDays AS INT)
RETURNS DATETIME
AS
BEGIN
    SET @addDate = DATEADD(d, @numDays, @addDate)
    IF DATENAME(DW, @addDate) = 'sunday'   SET @addDate = DATEADD(d, 1, @addDate)
    IF DATENAME(DW, @addDate) = 'saturday' SET @addDate = DATEADD(d, 2, @addDate)
  
    RETURN CAST(@addDate AS DATETIME)
END