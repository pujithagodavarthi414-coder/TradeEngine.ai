CREATE PROCEDURE [dbo].[Marker315]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON


      UPDATE CustomWidgets SET WidgetQuery = 'SELECT CONVERT(VARCHAR(5),TimeofUser,114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
          FROM (
          SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
          	   ,KeyStroke
          	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
          	   ,U.TimeZoneId
          	   ,TrackedDateTime
                 ,DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,330) ,TrackedDateTime) AS TimeofUser
          FROM UserActivityTrackerStatus UAS
               INNER JOIN [User] U ON U.Id = UAS.UserId
          	 INNER JOIN Employee E ON E.UserId = U.Id
          	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
          	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
          WHERE KeyStroke = 0
                AND U.InActiveDateTime  IS NULL AND U.IsActive = 1
                AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
				AND U.CompanyId = ''@CompanyId''
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	    AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))) T'
				WHERE CustomWidgetName = 'Employees with 0 keystrokes' AND CompanyId = @CompanyId

  UPDATE CustomWidgets SET WidgetQuery = 'SELECT CONVERT(VARCHAR(5),TimeofUser,114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
           FROM (
           SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
           	   ,KeyStroke
           	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
           	   ,U.TimeZoneId
           	   ,TrackedDateTime
               ,DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,330) ,TrackedDateTime) AS TimeofUser
           FROM UserActivityTrackerStatus UAS
                INNER JOIN [User] U ON U.Id = UAS.UserId
           	 INNER JOIN Employee E ON E.UserId = U.Id
           	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
           	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                  LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
           WHERE KeyStroke > 200
                 AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                 AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
				AND U.CompanyId = ''@CompanyId''
          	 AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	 AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))
           ) T' WHERE CustomWidgetName = 'Employees with keystrokes more than 200' AND CompanyId = @CompanyId

		   UPDATE CustomWidgets 
	            SET WidgetQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY TotalTimeInHr DESC) AS [RowNumber],UserName AS [Name],TotalTimeInHr,[Month],UserId,[MonthEnd]
		FROM
		(
			SELECT UM.Id AS UserId
			,UM.FirstName + CONCAT('' '',UM.SurName) As UserName
			 ,ROUND(SUM(SpentTime * 1.0 /60.0),0) AS TotalTimeInHr
			  ,DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime) AS [Month]
			  ,EOMONTH(UAT.CreatedDateTime) AS [MonthEnd]
			  FROM [User] AS UM
			  	  INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime
				              FROM(
				                    SELECT UserId,(Neutral + Productive + UnProductive) / 60000 AS SpentTime,CreatedDateTime
			                        FROM UserActivityTimeSummary AS UA 
			                        WHERE UA.CreatedDateTime BETWEEN ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) AND ISNULL(@DateTo,EOMONTH(GETDATE()))
								    	  AND (''@UserId'' = '''' OR ''@UserId'' = UA.UserId)
								 ) T WHERE SpentTime > 480
			                  ) UAT ON UAT.UserId = UM.Id  AND UM.CompanyId = ''@CompanyId''
			   GROUP BY UM.Id,UM.FirstName + CONCAT('' '',UM.SurName),DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime)
			  ,EOMONTH(UAT.CreatedDateTime)
		) MainQ' 
	WHERE CustomWidgetName = N'Employee over time report' AND CompanyId = @CompanyId

END
GO