CREATE PROCEDURE USP_GetUsersActivityTrackerTime
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	DECLARE @Date DATE = DATEADD(DAY,-1,GETDATE())
	
	SELECT @Date = CASE WHEN  DATENAME(WEEkDAY,@Date) = 'Sunday' THEN DATEADD(DAY,-1,@Date) ELSE @Date END
		
	DECLARE @Holiday DATETIME
	
	DECLARE Holidaycursor CURSOR FOR  
	SELECT [Date]
	FROM Holiday WHERE [Date] >= @Date AND InActiveDateTime IS NULL
	
	OPEN Holidaycursor   
	FETCH NEXT FROM Holidaycursor INTO @Holiday
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF(@Date = @Holiday) SET @Date = DATEADD(DAY,-1,@Date)
		
		SELECT @Date = CASE WHEN  DATENAME(WEEkDAY,@Date) = 'Sunday' THEN DATEADD(DAY,-1,@Date) ELSE @Date END
	
		FETCH NEXT FROM Holidaycursor INTO @Holiday   
	
	END
	
	CLOSE Holidaycursor
	DEALLOCATE Holidaycursor
	
	SELECT UserName [User Name], FORMAT([Date],'dd-MMM-yyyy') [Date], FinalTime [Tracking Time]
	       , CASE WHEN DATENAME(WEEKDAY,[Date]) = 'Saturday' AND FinalTime < 6 AND  FinalTime >= 3  THEN 'Half Day Leave'
		          WHEN DATENAME(WEEKDAY,[Date]) = 'Saturday' AND FinalTime < 3 THEN 'Full Day Leave'
		          WHEN FinalTime < 8 AND FinalTime >= 4 THEN 'Half Day Leave'
	              WHEN FinalTime < 4 THEN 'Full Day Leave'
				  ELSE 'No Leave' END [Leave Type]
	FROM (
	SELECT UserId,U.FirstName+ISNULL(U.SurName,'') UserName,@Date [Date],CAST(ROUND(FinalTime/60.0,1) AS NUMERIC(10,1)) FinalTime
	FROM (
	SELECT T.UserId,SUM(CAST(LTRIM(DATEDIFF(MINUTE, 0, Total_Time)) AS INT)) - ISNULL(T1.IdleTime,0) FinalTime
	FROM ( SELECT UM.Id AS UserId,UA.ApplicationTypeName
	              ,CONVERT(TIME, DATEADD(MS, SUM(UA.TimeInMillisecond), 0)) AS Total_Time
			FROM [User] AS UM
				 INNER JOIN TimeSheet AS TS ON UM.Id = TS.UserId AND TS.[Date] = @Date
				 INNER JOIN UserActivityAppSummary AS UA ON UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.[Date] 
				 INNER JOIN [User] U ON U.Id = TS.UserId
			     --INNER JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id
			WHERE UA.CreatedDateTime = @Date AND U.CompanyId = @CompanyId
			GROUP BY UM.Id,ApplicationTypeName
	) T
   LEFT JOIN (SELECT UserId,TotalIdleTime AS IdleTime FROM [dbo].[Ufn_GetUserIdleTime](@Date,@Date,@CompanyId)) T1 ON T1.UserId = T.UserId
			  GROUP BY T.UserId,T1.IdleTime
	) T11
	  INNER JOIN [User] U ON U.Id = T11.UserId
	) TFinal
	ORDER BY UserName

END
GO

--EXEC USP_GetUsersActivityTrackerTime 'C24169EF-CA97-4698-9130-E40C49C3982A'