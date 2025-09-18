-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-09 00:00:00.000'
-- Purpose      To Get the Employee Attendance for Day By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSpentTime_New] @OperationsPerformedBy='7FBADFF8-7084-4B84-9E5E-26A36BDAD6AF',@FromDate='2019-06-01',@ToDate='2019-11-11',@UserId = '00000000-0000-0000-0000-000000000000'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSpentTime_New]
(
   @UserId UNIQUEIDENTIFIER,
   @FromDate VARCHAR(200),
   @ToDate VARCHAR(200),
   @EntityId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
SET NOCOUNT ON 
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          
      IF (@HavePermission = '1')
      BEGIN

		CREATE TABLE #SpentTime
          (
              UserId UNIQUEIDENTIFIER,
              UserName VARCHAR(200),
              [Date] DATETIME,
              TimeSpent VARCHAR(100),
              TotalTimeSpent NUMERIC(10,2)
          )
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

        IF(@UserId = '00000000-0000-0000-0000-000000000000' OR @UserId IS NULL)
        BEGIN

             INSERT INTO #SpentTime ([Date],TotalTimeSpent)
             SELECT [Date],AVG(TotalTimeSpent) FROM (
             SELECT TS.[Date], (ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), SWITCHOFFSET(OutTime, '+00:00')),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0) - ISNULL(UB.BreakTime,0)) TotalTimeSpent
                    ,TS.[UserId]
                    --[dbo].[Ufn_GetMinutesToHHMM](ISNULL(AVG(DATEDIFF(MINUTE,InTime, OutTime)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0)) TimeSpent
             FROM [User] U WITH (NOLOCK) 
                  INNER JOIN [Employee] E ON E.UserId = U.Id
	              INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                         AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                             AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                  JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id AND U.InactiveDateTime IS NULL AND TS.UserId NOT IN (SELECT UserId FROM LeaveApplication LA
                  JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId 
				  JOIN LeaveStatus LST ON LST.IsApproved = 1 AND LA.OverallLeaveStatusId = LST.Id 
                  WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL) 
                        AND Ts.InActiveDateTime IS NULL
                  LEFT JOIN (SELECT U.Id
                                    ,UB.[Date]
                                    ,ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))),0) AS BreakTime 
                                    FROM [User] U 
                                    LEFT JOIN UserBreak UB ON UB.UserId = U.Id AND U.InActiveDateTime IS NULL 
                                                          AND U.CompanyId = @CompanyId AND CONVERT(DATE,UB.[Date]) BETWEEN @FromDate AND @ToDate
                                    GROUP BY U.Id,UB.[Date]) UB ON UB.Id = TS.UserId AND (UB.[Date] = TS.[Date]) 
             WHERE ((CONVERT(DATE,TS.[Date]) BETWEEN @FromDate AND @ToDate)
                    OR (CONVERT(DATE,UB.[Date]) BETWEEN @FromDate AND @ToDate))
                    AND (CompanyId = @CompanyId) 
             ) T
             GROUP BY [Date]
             UPDATE #SpentTime SET TotalTimeSpent = CASE WHEN (TotalTimeSpent/60) < 0 THEN 0 ELSE TotalTimeSpent/60 END
        
        END
        ELSE
        BEGIN
             INSERT INTO #SpentTime (UserId,UserName,[Date],TotalTimeSpent,TimeSpent)
             SELECT U.Id UserId,U.FirstName,TS.[Date], (ISNULL(AVG(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), SWITCHOFFSET(OutTime, '+00:00'))),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))),0)),
                    [dbo].[Ufn_GetMinutesToHHMM](ISNULL(AVG(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), SWITCHOFFSET(OutTime, '+00:00'))),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))),0))
             FROM [User] U WITH (NOLOCK) 
                  INNER JOIN [Employee] E ON E.UserId = U.Id
	              INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                         AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                             AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                  JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id AND U.InactiveDateTime IS NULL AND TS.UserId NOT IN (SELECT LA.UserId FROM LeaveApplication LA
                  JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId  
				  JOIN LeaveStatus LST ON LST.IsApproved = 1 AND LA.OverallLeaveStatusId = LST.Id
                                   WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL) AND Ts.InActiveDateTime IS NULL
                  LEFT JOIN UserBreak UB WITH (NOLOCK) ON UB.UserId = TS.UserId AND UB.[Date] = TS.[Date]
             WHERE ((CONVERT(DATE,TS.[Date]) BETWEEN @FromDate AND @ToDate)
                    OR (CONVERT(DATE,UB.[Date]) BETWEEN @FromDate AND @ToDate))
                    AND U.Id = @UserId
                    AND (CompanyId = @CompanyId) 
             GROUP BY U.Id,U.FirstName,TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.InTime,TS.OutTime 
             UPDATE #SpentTime SET TotalTimeSpent = CASE WHEN (TotalTimeSpent/60) < 0 THEN 0 ELSE TotalTimeSpent/60 END
        END

		SELECT T.Date,ST.TimeSpent,ST.TotalTimeSpent,ST.UserName,ST.UserId FROM(SELECT  CAST(DATEADD( day,(number-1),@FromDate) AS date) [Date]
	FROM master..spt_values
	WHERE Type = 'P' and number between 1 
	and datediff(day, @FromDate, DATEADD(DAY,1,@ToDate)))T LEFT JOIN #SpentTime ST ON CAST(ST.Date  AS date) = T.Date
    --SELECT * FROM #SpentTime
    
	  END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
    END TRY 
    BEGIN CATCH 
        
          THROW
    END CATCH
END