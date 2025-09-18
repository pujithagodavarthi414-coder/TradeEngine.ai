-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-14 00:00:00.000'
-- Purpose      To Get the Late Employee Count By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetLateEmployeeCount_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308', @DateFrom='2019-06-20',@DateTo='2019-07-20'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLateEmployeeCount_New]
(
    @DateFrom DATETIME,
    @DateTo DATETIME,
    @TeamLeadId UNIQUEIDENTIFIER = NULL,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @DepartmentId UNIQUEIDENTIFIER = NULL,
    @DesignationId UNIQUEIDENTIFIER = NULL,
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
   BEGIN​

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

    IF (@TeamLeadId = '00000000-0000-0000-0000-000000000000' OR @TeamLeadId IS NULL)
    BEGIN
    SET @TeamLeadId = @OperationsPerformedBy
    END
    IF (@BranchId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @BranchId = NULL
    END
    IF (@DepartmentId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @DepartmentId = NULL
    END
    IF(@DesignationId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @DesignationId = NULL
    END
    DECLARE @MorningLateExcludingPermissionCount INT
  
           SELECT T.[Date],
                  T.TotalCount,
                  T.MorningLateCount,
                  T.MorningLatePermissionCount,
                  T.LunchbreakLateCount,
                  (T.MorningLateCount-T.MorningLatePermissionCount) MorningLateExcludingPermissionCount,
                  TotalRowCount = COUNT(1) OVER() 
          FROM(SELECT A.[Date],
                      ISNULL(TC.TotalCount,0)TotalCount,
                      ISNULL(MLC.MorningLateCount,0)MorningLateCount,
                      ISNULL(MLPC.MorningLatePermissionCount,0)AS MorningLatePermissionCount,
                      ISNULL(LBLC.LunchbreakLateCount,0)AS LunchbreakLateCount
               FROM (( SELECT [Date] FROM [User] U WITH (NOLOCK) JOIN TimeSheet TS WITH (NOLOCK) ON U.Id = TS.UserId 
                               AND U.InactiveDateTime IS NULL 
							   INNER JOIN [Employee] E ON E.UserId = U.Id 
	                           INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                      AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                                      AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                          AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                             WHERE (cast(@DateFrom as date) <= [Date] AND cast(@DateTo as date) >= [Date]) AND (U.CompanyId = @CompanyId) 
                                   AND [Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)
                             GROUP BY [Date])A 
           LEFT JOIN
              (SELECT [Date],
                      COUNT(1) TotalCount
               FROM TimeSheet TS WITH (NOLOCK) JOIN [User] U WITH (NOLOCK) ON U.Id = TS.UserId  AND U.InactiveDateTime IS NULL AND TS.UserId NOT IN (SELECT UserId FROM LeaveApplication LA
               JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId 
			   JOIN LeaveStatus LST ON LST.IsApproved = 1 AND LA.OverallLeaveStatusId = LST.Id 
               WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL) AND Ts.InActiveDateTime IS NULL
                                               JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id
                                                    AND E.InactiveDateTime IS NULL  
                                               JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id 
                                                    AND (EB.BranchId = @BranchId OR @BranchId IS NULL) 
                                               JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL
                                                    AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                                               JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
              WHERE [Date] >= cast(@DateFrom as date)
                    AND [Date] <= cast(@DateTo as date)
                    AND (U.CompanyId = @CompanyId) 
                     AND [Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)
              GROUP BY [Date])TC ON A.[Date]=TC.[Date] 
              LEFT JOIN    
             (SELECT [Date],
                     COUNT(1) MorningLateCount
              FROM TimeSheet TS WITH (NOLOCK) INNER JOIN [User] U WITH (NOLOCK) ON U.Id = TS.UserId  AND U.InactiveDateTime IS NULL AND Ts.InActiveDateTime IS NULL
                                              JOIN Employee E WITH (NOLOCK) ON E.UserId = TS.UserId AND E.InactiveDateTime IS NULL 
                                              INNER JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id
                                              AND ES.InActiveDateTime IS NULL AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
                                               AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))                                             
											   INNER JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId
                                              INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date]))
                                              LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
                                              INNER JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id
                                                        AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
                                              JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
                                              INNER JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL
                                                    AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
              WHERE [Date] >= cast(@DateFrom as date) AND [Date] <= cast(@DateTo as date)
               AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME))
               AND (U.CompanyId = @CompanyId) 
               AND [Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)
              GROUP BY [Date])MLC ON MLC.[Date]=A.[Date] 
              LEFT JOIN
             (SELECT P.[Date],COUNT(DISTINCT P.UserId) MorningLatePermissionCount
              FROM Permission P WITH (NOLOCK) INNER JOIN [User] U WITH (NOLOCK) ON U.Id = P.UserId 
                                                          AND U.InactiveDateTime IS NULL AND P.InactiveDateTime IS NULL
                                              JOIN Employee E WITH (NOLOCK) ON E.UserId = P.UserId AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL 
                                              JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id
                                                         AND (EB.BranchId = @BranchId OR @BranchId IS NULL) 
                                              JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL
                                                         AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                                              INNER JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = P.UserId AND TS.[Date] = P.[Date]  AND Ts.InActiveDateTime IS NULL
                                              INNER JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id 
                                              AND E.InactiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
                                              AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
                                              AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) AND ES.InActiveDateTime IS NULL
                                              AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
                                              AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]) )))
                                              INNER JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId
                                              INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date]))
                                              LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
                                              JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
              WHERE IsMorning = 1 AND (U.CompanyId = @CompanyId)
              AND TS.[Date] >= cast(@DateFrom as date) AND TS.[Date] <= cast(@DateTo as date) AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME))
              AND TS.[Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId) 
              GROUP BY P.[Date])MLPC ON MLPC.[Date]=MLC.[Date]
              LEFT JOIN
             (SELECT [Date],COUNT(1) LunchbreakLateCount
              FROM TimeSheet TS WITH (NOLOCK) JOIN [User] U WITH (NOLOCK) ON U.Id = TS.UserId
                                                         AND U.InactiveDateTime IS NULL AND TS.UserId NOT IN (SELECT UserId FROM LeaveApplication LA
                                              JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId  
											  JOIN LeaveStatus LST ON LST.IsApproved = 1 AND LA.OverallLeaveStatusId = LST.Id
                                              WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL) AND Ts.InActiveDateTime IS NULL
                                              JOIN Employee E WITH (NOLOCK) ON E.UserId = TS.UserId AND E.InactiveDateTime IS NULL 
                                              JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id
                                                         AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
                                             JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL
                                                         AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                                             JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
              WHERE [Date] >= cast(@DateFrom as date) AND [Date] <= cast(@DateTo as date) AND ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) >= 71
			     AND (U.CompanyId = @CompanyId ) 
                 AND [Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)
              GROUP BY [Date])LBLC ON LBLC.[Date]=A.[Date]))T
              WHERE NOT EXISTS (SELECT [Date] FROM Holiday WHERE [Date] = T.[Date] AND [Date] BETWEEN cast(@DateFrom as date) AND cast(@DateTo as date) AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

      END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END ​
        END TRY  
     BEGIN CATCH 
        
        THROW

    END CATCH
END
GO