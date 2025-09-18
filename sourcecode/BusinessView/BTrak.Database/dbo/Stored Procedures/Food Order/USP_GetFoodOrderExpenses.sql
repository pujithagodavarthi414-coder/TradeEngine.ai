CREATE PROCEDURE [dbo].[USP_GetFoodOrderExpenses]
(
  @Date DATETIME
)
AS
BEGIN
	DECLARE @Expenses TABLE 
	(
	    [Date] DATETIME,
	    Amount numeric(18,2)
	)
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @CurrentDate DATE
	SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
	SELECT @StartDate = DATEADD(month, DATEDIFF(month, 0, @Date), 0)
	SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
	DECLARE @DimDate TABLE
	(
	    [Date] DATETIME
	)   
	;WITH CTE AS
	(
	    SELECT @StartDate AS Result
	    UNION ALL
	    SELECT Result+1 FROM CTE WHERE Result+1 <= @EndDate
	)
	INSERT INTO @DimDate([Date])
	SELECT Result FROM CTE
	DECLARE @PresentDate DATETIME
	DECLARE DATE_CURSOR CURSOR FOR  
	SELECT [Date] FROM @DimDate
	
	OPEN DATE_CURSOR  
	FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	        INSERT INTO @Expenses ([Date])
	        SELECT @PresentDate
	FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
	END  
	CLOSE DATE_CURSOR  
	DEALLOCATE DATE_CURSOR
	UPDATE @Expenses SET Amount = AmountVal FROM @Expenses ES 
	RIGHT JOIN (SELECT SUM(Amount) AmountVal, CONVERT(DATE,OrderedDateTime) OrderedDate FROM FoodOrder
				GROUP BY CONVERT(DATE,OrderedDateTime)) FTInner 
	       ON OrderedDate = CONVERT(DATE,ES.[Date])
	        
	SELECT * FROM @Expenses
END


--EXEC [USP_GetFoodOrderExpenses] '2018-08-01'