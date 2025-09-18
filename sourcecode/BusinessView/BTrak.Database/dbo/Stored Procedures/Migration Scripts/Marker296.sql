CREATE PROCEDURE [dbo].[Marker296]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

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
                AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
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
                 AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                 AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
            AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
            AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))
           ) T' 
   WHERE CustomWidgetName = 'Employees with keystrokes more than 200' AND CompanyId = @CompanyId

END
GO

