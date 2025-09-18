-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-07-25 00:00:00.000'
-- Purpose      To Get the activity  time
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetUserIdleTime]('2020-07-24','2020-07-24','C6E72DD5-A410-4B0C-B424-932955F97B83')

CREATE FUNCTION Ufn_GetUserIdleTime
(
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @Temp TABLE
( 
    UserId UNIQUEIDENTIFIER,
	TotalIdleTime  INT
)
AS
BEGIN
	
	IF(@DateFrom IS NULL) SET @DateFrom = GETDATE()

	IF(@DateTo IS NULL) SET @DateTo = GETDATE()

	IF(@DateFrom > @DateTo) SET @DateFrom = @DateTo

	SET @DateFrom =  CONVERT(DATE,@DateFrom)

	SET @DateTo =  CONVERT(DATE,@DateTo)

	DECLARE @LastDate DATETIME = DATEADD(DAY,-7,GETDATE()) --(SELECT MAX(CreatedDateTime) FROM IdleTimeHistoricalData WHERE CompanyId = @CompanyId)
				
	--DECLARE @DateFrom1 DATETIME,@DateTo1 DATETIME

	--IF(@LastDate > @DateFrom1 AND @LastDate > @DateTo1)
 --   BEGIN
        
 --       SELECT @DateFrom1 = @DateFrom,@DateTo1 = @DateTo,@DateFrom = NULL,@DateTo = NULL

 --   END
	--ELSE IF(@LastDate > @DateFrom)
	--BEGIN

	--	SELECT @DateFrom1 = @DateFrom
	--	       ,@DateFrom = DATEADD(DAY,1,@LastDate)
	--		   ,@DateTo1 = IIF(@LastDate > @DateTo,@DateTo,@LastDate)

	--END

	INSERT INTO @Temp(UserId,TotalIdleTime)
	SELECT UserId,SUM(T.IdleInMinutes) AS TotalTimeInMin
	FROM (
			SELECT UserId,SUM(IdleInMinutes)IdleInMinutes
			FROM UserActivityTimeSummary
			WHERE CompanyId = @CompanyId
			      AND CONVERT(DATE,CreatedDateTime) BETWEEN @DateFrom AND @DateTo
				  GROUP BY UserId
		  )T  
	GROUP BY UserId

RETURN
END
GO