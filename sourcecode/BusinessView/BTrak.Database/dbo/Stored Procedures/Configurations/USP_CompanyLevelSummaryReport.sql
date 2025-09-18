--EXEC [dbo].[USP_CompanyLevelSummaryReport] '10FB41D6-9678-499F-B0EC-276AB17E35D3','2020-12-15'
CREATE PROCEDURE [dbo].[USP_CompanyLevelSummaryReport]
(
	@CompanyId UNIQUEIDENTIFIER
	,@Date DATETIME
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		IF(@Date IS NULL) SET @Date = GETDATE()

		SET @Date = CONVERT(DATE,@Date)
		DECLARE @YesterDay DATETIME = DATEADD(DAY,-1,@Date)

		--DECLARE @OfficeWorkingHours FLOAT = (CONVERT(FLOAT,(REPLACE(ISNULL((SELECT [Value] FROM CompanySettings 
		--                                                             WHERE CompanyId = @CompanyId 
		--															        AND [Key] = 'SpentTime'),8), 'h', '') * 3600000.00)))
		
		DECLARE @OfficeWorkingHours FLOAT = 8 * 3600000.00

		SELECT 
		--office anniversary today
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			  ,CONVERT(NVARCHAR,J.JoinedDate,106) AS Result
		FROM Employee E
			 INNER JOIN [User] U ON U.Id = E.UserId
			            AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
			 			AND E.InActiveDateTime IS NULL
			 INNER JOIN Job J ON J.EmployeeId = E.Id
			 			AND J.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
			  AND (DATEPART(MONTH,J.JoinedDate) = DATEPART(MONTH,@Date))
			  AND (DATEPART(DAY,J.JoinedDate) = DATEPART(DAY,@Date))
		FOR JSON PATH ) AS OfficeAnniversaryToday,

		--people whos marriage anniversary today
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			  ,CONVERT(NVARCHAR,E.MarriageDate,106) AS Result
		FROM Employee E
			 INNER JOIN [User] U ON U.Id = E.UserId
			            AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
			 			AND E.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
			  AND (DATEPART(MONTH,E.MarriageDate) = DATEPART(MONTH,@Date))
			  AND (DATEPART(DAY,E.MarriageDate) = DATEPART(DAY,@Date))
		FOR JSON PATH ) AS MarriageAnniversaryToday,
		
		--people who have birthday today
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			  ,CONVERT(NVARCHAR,E.DateofBirth,106) AS Result
		FROM Employee E
			 INNER JOIN [User] U ON U.Id = E.UserId
			            AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
			 			AND E.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
			  AND (DATEPART(MONTH,E.DateofBirth) = DATEPART(MONTH,@Date))
			  AND (DATEPART(DAY,E.DateofBirth) = DATEPART(DAY,@Date))
		FOR JSON PATH ) AS BirthdayToday,
		
		--people who are in leave today
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			  ,CASE WHEN (LA.LeaveDateFrom = @Date AND LA.LeaveDateTo = @Date) 
						 --OR (LA.LeaveDateFrom <> @Date AND LA.LeaveDateTo <> @Date)
			         THEN CASE WHEN FLA.Id <> TLA.Id THEN (SELECT LeaveSessionName FROM LeaveSession 
					                                      WHERE CompanyId = @CompanyId 
														        AND InActiveDateTime IS NULL 
																AND IsFullDay = 1)
						  ELSE FLA.LeaveSessionName END
					WHEN (LA.LeaveDateFrom <> @Date AND LA.LeaveDateTo <> @Date)
					THEN (SELECT LeaveSessionName FROM LeaveSession 
					                                      WHERE CompanyId = @CompanyId 
														        AND InActiveDateTime IS NULL 
																AND IsFullDay = 1)
					WHEN LA.LeaveDateFrom = @Date THEN FLA.LeaveSessionName
					WHEN LA.LeaveDateTo = @Date THEN TLA.LeaveSessionName
					END AS Result
		FROM LeaveApplication LA
			 INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
			 INNER JOIN LeaveSession FLA ON FLA.Id = LA.FromLeaveSessionId
			 INNER JOIN LeaveSession TLA ON TLA.Id = LA.ToLeaveSessionId
			 INNER JOIN [User] U ON U.Id = LA.UserId
						AND (LA.IsDeleted = 0 OR LA.IsDeleted IS NULL) AND LA.InActiveDateTime IS NULL
			INNER JOIN Employee E ON E.UserId = U.Id
			AND E.InActiveDateTime IS NULL 
			AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
			 AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
			  AND LA.LeaveDateFrom <= @Date
			  AND LA.LeaveDateTo >= @Date
		FOR JSON PATH ) AS PeopleLeaveToday,
		
		--people who started late yesterday
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			       ,CONVERT(VARCHAR,(DATEDIFF(MINUTE,(CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)),SWITCHOFFSET(TS.InTime, '+00:00'))) /60) + 'h : '
			        + IIF((DATEDIFF(MINUTE,(CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)),SWITCHOFFSET(TS.InTime, '+00:00'))) %60 < 10
					      ,ISNULL('0' + CONVERT(VARCHAR,(DATEDIFF(MINUTE,(CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)),SWITCHOFFSET(TS.InTime, '+00:00'))) %60),'00')
						  ,ISNULL(CONVERT(VARCHAR,(DATEDIFF(MINUTE,(CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)),SWITCHOFFSET(TS.InTime, '+00:00'))) %60) ,'00')) + 'm'
				  AS Result
		FROM TimeSheet TS
			 INNER JOIN [User] U ON U.Id = TS.UserId
		     INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id
			 LEFT JOIN EmployeeShift ES ON  ES.EmployeeId = E.Id  
						AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
						AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) AND ES.InActiveDateTime IS NULL
		    LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
		    LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
		    LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
		WHERE U.CompanyId = @CompanyId
			 AND TS.[Date] = @YesterDay
			 AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
		ORDER BY TS.InTime DESC
		FOR JSON PATH ) AS PeopleLateToday,
		
		--people who are on leave yesterday
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			  ,CASE WHEN (LA.LeaveDateFrom = @YesterDay AND LA.LeaveDateTo = @YesterDay) 
						 --OR (LA.LeaveDateFrom <> @Date AND LA.LeaveDateTo <> @Date)
			         THEN CASE WHEN FLA.Id <> TLA.Id THEN (SELECT LeaveSessionName FROM LeaveSession 
					                                      WHERE CompanyId = @CompanyId 
														        AND InActiveDateTime IS NULL 
																AND IsFullDay = 1)
						  ELSE FLA.LeaveSessionName END
					WHEN (LA.LeaveDateFrom <> @YesterDay AND LA.LeaveDateTo <> @YesterDay)
					THEN (SELECT LeaveSessionName FROM LeaveSession 
					                                      WHERE CompanyId = @CompanyId 
														        AND InActiveDateTime IS NULL 
																AND IsFullDay = 1)
					WHEN LA.LeaveDateFrom = @YesterDay THEN FLA.LeaveSessionName
					WHEN LA.LeaveDateTo = @YesterDay THEN TLA.LeaveSessionName
					END AS Result
		FROM LeaveApplication LA
			 INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
			 INNER JOIN LeaveSession FLA ON FLA.Id = LA.FromLeaveSessionId
			 INNER JOIN LeaveSession TLA ON TLA.Id = LA.ToLeaveSessionId
			 INNER JOIN [User] U ON U.Id = LA.UserId
						AND (LA.IsDeleted = 0 OR LA.IsDeleted IS NULL) AND LA.InActiveDateTime IS NULL
			INNER JOIN Employee E ON E.UserId = U.Id
			AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
			 AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
			  AND LA.LeaveDateFrom <= @YesterDay
			  AND LA.LeaveDateTo >= @YesterDay
		FOR JSON PATH ) AS PeopleLeaveYesterday,
		
		--people who didnot finish tracker time
		
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email
			   ,CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) / 60) + 'h : ' 
			     + IIF((T.TotalTimeInMS / 60000) % 60 < 10, ISNULL('0' + CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) % 60),'00') 
				       , ISNULL(CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) % 60),'00')
					   )+ 'm' AS Result
		FROM (
		SELECT UA.UserId,SUM(UA.Productive + UA.UnProductive + UA.Neutral) TotalTimeInMS
		FROM UserActivityTimeSummary UA
		WHERE UA.CreatedDateTime = CONVERT(DATE,@YesterDay)
			  AND UA.CompanyId = @CompanyId
		GROUP BY UA.UserId
		) T 
		INNER JOIN [User] U ON U.Id = T.UserId 
		WHERE (T.TotalTimeInMS) < @OfficeWorkingHours
		ORDER BY T.TotalTimeInMS
		FOR JSON PATH ) AS PeopleDidnotFinishTrackerYesterday,
		
		--people who worked as per desk time
		
		(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Name]
		      ,U.Id AS UserId,U.UserName AS Email 
			   ,CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) / 60) + 'h :' 
			   + IIF((T.TotalTimeInMS / 60000) % 60 < 10,
			        ISNULL( '0' + CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) % 60),'00')
			        ,ISNULL(CONVERT(VARCHAR,(T.TotalTimeInMS / 60000) % 60),'00')) + 'm' AS Result
		FROM (
		SELECT  UA.UserId,SUM(UA.Productive + UA.UnProductive + UA.Neutral) TotalTimeInMS
		FROM UserActivityTimeSummary UA
		WHERE UA.CreatedDateTime = CONVERT(DATE,@YesterDay)
			  AND UA.CompanyId = @CompanyId
		GROUP BY UA.UserId
		) T 
		INNER JOIN [User] U ON U.Id = T.UserId 
		WHERE (T.TotalTimeInMS) > @OfficeWorkingHours
		ORDER BY T.TotalTimeInMS DESC
		FOR JSON PATH ) AS PeopleWorkMoreThanTrackerYesterday

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO