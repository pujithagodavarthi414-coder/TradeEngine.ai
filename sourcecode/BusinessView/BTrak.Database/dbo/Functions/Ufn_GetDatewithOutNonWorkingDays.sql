CREATE FUNCTION [dbo].[Ufn_GetDatewithOutNonWorkingDays](@InputDate AS DATETIME, @Dateaddcount AS INT)
RETURNS DATETIME
AS
BEGIN 
  DECLARE @TotalDates TABLE(
          Dates DATETIME
      )
  INSERT INTO @TotalDates
   SELECT TOP (@Dateaddcount) AllDays = DATEADD(DAY, ROW_NUMBER() 
            OVER (ORDER BY object_id), REPLACE(@InputDate,'-',''))
   FROM sys.all_objects
    
   RETURN (SELECT  DATEADD(DAY,((2*@Dateaddcount) - (SELECT COUNT(Dates) FROM @TotalDates T LEFT JOIN Holiday H ON T.Dates = H.Date
   WHERE DATENAME(WEEkDAY,Dates) <> 'Saturday' AND DATENAME(WEEkDAY,Dates) <> 'Sunday' AND H.Date IS NULL)),@InputDate))
END