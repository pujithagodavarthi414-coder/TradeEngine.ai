CREATE FUNCTION [dbo].[Ufn_GetQAActionDate] 
(
	@TransitionDateTime DATETIME
)
RETURNS DATETIME
AS 
BEGIN
   
    DECLARE @TransitionDate DATETIME = CONVERT(DATE,@TransitionDateTime)
	DECLARE @QADeadline DATETIME
	
	SELECT @QADeadline = CASE WHEN DATENAME(WEEkDAY,@TransitionDateTime) = 'Saturday'  THEN DATEADD(DAY,2,CAST(CONVERT(VARCHAR(10), @TransitionDateTime, 110) + ' 23:59:59' AS DATETIME))  
	                          WHEN DATENAME(WEEkDAY,@TransitionDateTime) = 'Sunday'  THEN DATEADD(DAY,1,CAST(CONVERT(VARCHAR(10), @TransitionDateTime, 110) + ' 23:59:59' AS DATETIME)) 
							  WHEN DATENAME(WEEkDAY,@TransitionDateTime) = 'Friday' THEN DATEADD(DAY,3,@TransitionDateTime) 
							  ELSE DATEADD(DAY,1,@TransitionDateTime) END

	DECLARE @Holiday DATETIME
	
	DECLARE Holidaycursor CURSOR FOR  
	SELECT [Date]
	FROM Holiday WHERE [Date] >= @TransitionDate AND InActiveDateTime IS NULL
	
	OPEN Holidaycursor   
	FETCH NEXT FROM Holidaycursor INTO @Holiday
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF(CONVERT(DATE,@QADeadline) = @Holiday)
			SET @QADeadline = DATEADD(DAY,1,@QADeadline)
	
		SELECT @QADeadline = CASE WHEN DATENAME(WEEkDAY,@QADeadline) = 'Saturday' THEN DATEADD(DAY,2,@QADeadline)
	                              WHEN  DATENAME(WEEkDAY,@QADeadline) = 'Sunday' THEN DATEADD(DAY,1,@QADeadline)
							      ELSE @QADeadline END

		FETCH NEXT FROM Holidaycursor INTO @Holiday   
	
	END
	
	CLOSE Holidaycursor
	DEALLOCATE Holidaycursor

	

RETURN @QADeadline
END
