CREATE FUNCTION [dbo].[Ufn_GetQATestingAge]
   (
       @DeployedDateTime DATETIME,
       @ActionDateTime DATETIME
   )
   RETURNS INT
   AS
   BEGIN

   DECLARE @DeployedDate DATETIME = CONVERT(DATE,@DeployedDateTime)

   DECLARE @ActionDate DATETIME = CONVERT(DATE,@ActionDateTime)

   DECLARE @TOTALCount INT = CASE WHEN DATEDIFF(DD,@DeployedDate,@ActionDate) < 0 THEN -DATEDIFF(DD,@DeployedDate,@ActionDate) ELSE DATEDIFF(DD,@DeployedDate,@ActionDate) END;
   DECLARE @TestingAge INT

   DECLARE @NonWorkingDays TABLE(
       Dates DATETIME
   )
   DECLARE @TotalDates TABLE(
       Dates DATETIME
   )
   INSERT INTO @TotalDates
   SELECT @DeployedDate
   UNION
   SELECT TOP (@TOTALCount) AllDays = DATEADD(DAY, ROW_NUMBER()
         OVER (ORDER BY object_id), REPLACE(@DeployedDate,'-',''))
   FROM sys.all_objects
   INSERT INTO @NonWorkingDays
   SELECT DISTINCT Dates FROM @TotalDates
   WHERE DATENAME(WEEkDAY,Dates) = 'Saturday' OR DATENAME(WEEkDAY,Dates) = 'Sunday'
   UNION
   SELECT Dates FROM @TotalDates T JOIN Holiday H ON T.Dates = H.Date
    WHERE DATENAME(WEEkDAY,Dates) <> 'Saturday' OR DATENAME(WEEkDAY,Dates) <> 'Sunday'

    DECLARE @DaysCount INT = CASE WHEN ((SELECT COUNT(*) FROM @TotalDates) - (SELECT COUNT(*) FROM @NonWorkingDays) - 1) < 0 THEN 0
                                ELSE ((SELECT COUNT(*) FROM @TotalDates) - (SELECT COUNT(*) FROM @NonWorkingDays) - 1) END

    RETURN @DaysCount
END