-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-11 00:00:00.000'
-- Purpose      To Get the Employee Working days By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkingDays_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Date='2020-01-11',@PageSize=1000

CREATE PROCEDURE  [dbo].[USP_GetWorkingDays_New]
(
  @Date DATETIME = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @TeamLeadId UNIQUEIDENTIFIER = NULL,
  @DepartmentId UNIQUEIDENTIFIER = NULL,
  @DesignationId UNIQUEIDENTIFIER = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(100)=NULL,
  @SearchText  NVARCHAR(100)=NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @PageNumber INT = 1,
  @PageSize INT = 10
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
         DECLARE @StartDate DATETIME
         
         DECLARE @EndDate DATETIME
         
         DECLARE @CurrentDate DATE
         
         DECLARE @TotalDays INT 
         
         DECLARE @NoOfHolidays INT
         
	   DECLARE @NoOfWorkingDays INT

	   DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy )
		 
         IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

	   IF (@BranchId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @BranchId = NULL
         END
         IF (@TeamLeadId = '00000000-0000-0000-0000-000000000000' OR @TeamLeadId IS NULL)
         BEGIN
         SET @TeamLeadId = @OperationsPerformedBy
         END
         IF (@DepartmentId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @DepartmentId = NULL
         END
         IF (@DesignationId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @DesignationId = NULL
         END
         
         SET @SearchText = '%'+ @SearchText+'%'
         
         SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
         
         SELECT @StartDate = DATEADD(month, DATEDIFF(MONTH, 0, @Date), 0)
         
         SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
         
         DECLARE @FirstHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId)

         DECLARE @SecondHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsSecondHalf = 1 AND CompanyId = @CompanyId)

         IF(@EndDate > @CurrentDate) SET @EndDate = @CurrentDate
          
         IF(@SortDirection IS NULL )
         BEGIN
             
             SET @SortDirection = 'ASC'
        
        END
         
         DECLARE @OrderByColumn NVARCHAR(250) 
         
         IF(@SortBy IS NULL)
         BEGIN
         
             SET @SortBy = 'fullName'
         
         END
         ELSE
         BEGIN
         
             SET @SortBy = @SortBy
         
         END
         SELECT UD.Id AS UserId,
                UD.EmployeeNumber AS EmployeeId,
                UD.FirstName AS [EmployeeName],
                UD.SurName,
                UD.FullName,
                UD.ProfileImage,
                UD.NoOfWorkingDays WorkingDays,
                UD.TotalDays,
                ISNULL(WD.Absents,0) Absents,
                ISNULL(NLD.NoOfLateDays,0) LateDays,
                ISNULL(WRKED.WorkedDays,0) WorkedDays,
                ISNULL(UD.NoOfHolidays,0) Holidays,
                ISNULL(UD.WeekOffDays,0) WeekOffDays,
                TotalCount = COUNT(1) OVER()
                FROM((SELECT U.Id,
                             E.EmployeeNumber,
                             FirstName, 
                             SurName, 
                             ProfileImage,
                             ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') FullName,
                             DATEDIFF(DAY,@StartDate,@EndDate) - IIF((DATEPART(MONTH,J.JoinedDate) = DATEPART(MONTH,@StartDate) AND DATEPART(YEAR,J.JoinedDate) = DATEPART(YEAR,@StartDate)),DATEDIFF(DAY,@StartDate,J.JoinedDate),0) AS TotalDays,
                             DATEDIFF(DAY,@StartDate,@EndDate) - ISNULL(H.Holidays,0) - ISNULL(T.WeekOffdays,0)- IIF((DATEPART(MONTH,J.JoinedDate) = DATEPART(MONTH,@StartDate) AND DATEPART(YEAR,J.JoinedDate) = DATEPART(YEAR,@StartDate)),DATEDIFF(DAY,@StartDate,J.JoinedDate),0) AS NoOfWorkingDays,
                             ISNULL(H.Holidays,0) AS NoOfHolidays,
                             ISNULL(T.WeekOffdays,0) AS WeekOffDays
                 FROM [User] U 
                      INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
                       --LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.OriginalId AND UAD.AsAtInactiveDateTime IS NULL AND UAD.InActiveDateTime IS NULL
					   INNER JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
			           INNER JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id
	                              AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                                  AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			                      AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
			           JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL
			                AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                       LEFT JOIN (SELECT U.Id,COUNT(1) AS WeekOffDays
                                         FROM [User] U
                                         JOIN MASTER..SPT_VALUES MST ON MST.Number <= DATEDIFF(DAY,@StartDate,@EndDate) AND MST.[Type] = 'P'
                                         JOIN [Employee] E ON E.UserId = U.Id AND U.IsActive = 1
                                         JOIN Job J ON J.EmployeeId = E.Id AND J.JoinedDate <= DATEADD(DAY,MST.Number,@StartDate)
                                         LEFT JOIN [EmployeeShift] ES ON ES.EmployeeId = E.Id AND ((ES.ActiveFrom <= DATEADD(DAY,MST.Number,@StartDate) AND ES.ActiveTo IS NULL) OR (DATEADD(DAY,MST.Number,@StartDate) BETWEEN ES.ActiveFrom AND ES.ActiveTo)) AND ES.InactiveDateTime IS NULL
                                         LEFT JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,DATEADD(DAY,MST.Number,@StartDate)) = SW.[DayOfWeek]
                                         LEFT JOIN [TimeSheet] TS ON TS.[Date] = DATEADD(DAY,MST.Number,@StartDate) AND TS.[UserId] = U.Id
                                         WHERE (SW.Id IS NULL) AND U.CompanyId = @CompanyId AND TS.Id IS NULL 
                                         GROUP BY U.Id)T ON T.Id = U.Id
                      LEFT JOIN (SELECT U.Id,COUNT(1) AS Holidays
                                         FROM [User] U
                                         JOIN MASTER..SPT_VALUES MST ON MST.Number <= DATEDIFF(DAY,@StartDate,@EndDate) AND MST.[Type] = 'P'
                                         JOIN [Employee] E ON E.UserId = U.Id AND U.IsActive = 1
                                         JOIN Job J ON J.EmployeeId = E.Id AND J.JoinedDate <= DATEADD(DAY,MST.Number,@StartDate)
                                         LEFT JOIN [EmployeeShift] ES ON ES.EmployeeId = E.Id AND ((ES.ActiveFrom <= DATEADD(DAY,MST.Number,@StartDate) AND ES.ActiveTo IS NULL) OR (DATEADD(DAY,MST.Number,@StartDate) BETWEEN ES.ActiveFrom AND ES.ActiveTo)) AND ES.InactiveDateTime IS NULL
                                         LEFT JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,DATEADD(DAY,MST.Number,@StartDate)) = SW.[DayOfWeek]
                                         LEFT JOIN [Holiday] H ON H.[Date] = DATEADD(DAY,MST.Number,@StartDate) AND H.WeekOffDays IS NULL AND H.InActiveDateTime IS NULL AND H.CompanyId = U.CompanyId
                                         LEFT JOIN [TimeSheet] TS ON TS.[Date] = H.[Date] AND TS.[UserId] = U.Id
                                         WHERE H.Id IS NOT NULL AND SW.Id IS NOT NULL AND TS.Id IS NULL
                                           AND U.CompanyId = @CompanyId
                                         GROUP BY U.Id)H ON H.Id = U.Id
                 WHERE U.IsActive = 1
						AND U.InActiveDateTime IS NULL
                        AND ((J.JoinedDate >= @StartDate AND J.JoinedDate <= @EndDate) OR @StartDate >= J.JoinedDate)
                        AND (@StartDate <= J.InActiveDateTime OR J.InActiveDateTime IS NULL)
                        AND CompanyId = @CompanyId)UD 
                  LEFT JOIN (SELECT T.[UserId]
                                   ,SUM(T.Cnt) AS Absents 
                                    FROM(
                                    SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN 0
                                                            ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
                                                            ELSE 1 END END AS Cnt FROM
                                   (SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
                                           FROM MASTER..SPT_VALUES MSPT
                                           JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
                                                                   AND ((LA.LeaveDateFrom BETWEEN @StartDate AND @EndDate) OR (LA.LeaveDateTo BETWEEN @StartDate AND @EndDate))
                                                                AND LA.UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND IsActive = 1)
                                                                ) T
                                           JOIN LeaveApplication LAP ON LAP.Id = T.Id 
                                           JOIN [User] U ON U.Id = LAP.UserId AND U.IsActive = 1
                                           JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1
                                           JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = U.CompanyId
                                           JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
                                           JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
                                           JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId AND (MLT.IsCasualLeave = 1 OR MLT.IsSickLeave = 1 OR MLT.IsWithoutIntimation = 1)
                                           JOIN Employee E ON E.UserId = LAP.UserId
                                           LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL))
                                           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
                                           LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = U.CompanyId AND H.WeekOffDays IS NULL
                                           WHERE T.[Date] BETWEEN @StartDate AND @EndDate) T
                GROUP BY T.[UserId]) WD ON UD.Id= WD.UserId
                LEFT JOIN (SELECT T.UserId,ISNULL(SUM(Cnt),0) AS WorkedDays FROM(
                           SELECT TS.[Date],TS.[UserId],CASE WHEN (((TS.[Date] = LA.LeaveDateFrom AND LA.FromLeaveSessionId = @SecondHalfId) OR (TS.[Date] = LA.LeaveDateTo AND LA.ToLeaveSessionId = @FirstHalfId)) AND LS.IsApproved = 1 AND (MLT.IsCasualLeave = 1 OR MLT.IsSickLeave = 1 OR MLT.IsWithoutIntimation = 1)) THEN 0.5 ELSE 
                                                        CASE WHEN ((TS.[Date] BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo) AND LS.IsApproved = 1 AND (MLT.IsCasualLeave = 1 OR MLT.IsSickLeave = 1 OR MLT.IsWithoutIntimation = 1)) THEN 0 ELSE 1 END  END AS Cnt
                           FROM TimeSheet TS 
                           JOIN [User] U ON U.Id = TS.UserId AND U.CompanyId = @CompanyId
                           LEFT JOIN LeaveApplication LA ON TS.[Date] BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo AND LA.UserId = TS.UserId AND LA.InActiveDateTime IS NULL
                           LEFT JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                           LEFT JOIN LeaveSession LSS ON LSS.Id = LA.ToLeaveSessionId
                           LEFT JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
                           LEFT JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
                           WHERE TS.InTime IS NOT NULL
                           AND TS.[Date] BETWEEN @StartDate AND @EndDate) T
                           GROUP BY T.UserId) WRKED ON WRKED.UserId = UD.Id
    --             LEFT JOIN (SELECT UserId,
          --                SUM(DATEDIFF(DAY,LeaveDateFrom,LeaveDateTo)+1) NoOfExtraWorkedDays
          --                FROM LeaveApplication LA
                --        JOIN LeaveType LT WITH (NOLOCK) ON LT.Id = LA.LeaveTypeId 
                --        JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
                --        LEFT JOIN LeaveStatus LS WITH (NOLOCK) ON LS.Id = LA.OverallLeaveStatusId 
    --                      WHERE (LS.IsApproved = 1 OR OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' ) OR OverallLeaveStatusId IS NULL)
          --                  AND LeaveDateFrom BETWEEN @StartDate AND @EndDate
                --        AND CONVERT(DATE,LeaveDateFrom) NOT IN (SELECT CONVERT(DATE,[Date]) FROM HoliDay H JOIN EmployeeContactDetails ECD 
                --           ON H.CountryId = ECD.CountryId JOIN Employee E ON E.Id = ECD.EmployeeId
                --           JOIN [User] U ON U.Id = LA.UserId AND E.UserId = U.Id WHERE H.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND ECD.InActiveDateTime IS NULL)
                --        AND (MLT.IsOnSite = 1 OR MLT.IsWorkFromHome = 1)
          --                  AND (IsDeleted = 0 OR IsDeleted IS NULL)
                --        AND DATENAME(dw,LeaveDateFrom) <> 'SUNDAY'
    --                      GROUP BY UserId) NE ON UD.Id = NE.UserId

                --LEFT JOIN (SELECT LA.UserId,
          --                SUM(DATEDIFF(DAY,LeaveDateFrom,LeaveDateTo)+1) DaysExtracted
          --                FROM LeaveApplication LA
                --        JOIN TimeSheet TS ON TS.UserId = LA.UserId AND TS.[Date] = LA.LeaveDateFrom
                --        WHERE LeaveDateFrom BETWEEN @StartDate AND @EndDate AND CONVERT(DATE,[Date]) NOT IN (SELECT CONVERT(DATE,[Date]) FROM HoliDay H JOIN EmployeeContactDetails ECD 
                --           ON H.CountryId = ECD.CountryId JOIN Employee E ON E.Id = ECD.EmployeeId
                --            JOIN [User] U ON U.Id = LA.UserId AND U.Id = E.UserId WHERE H.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND ECD.InActiveDateTime IS NULL)
    --                      GROUP BY LA.UserId) DE ON UD.Id = DE.UserId
                  
    --            LEFT JOIN (SELECT UserId,
          --                SUM(DATEDIFF(DAY,LeaveDateFrom,LeaveDateTo)+1) NoOfAbsents
          --                FROM LeaveApplication LA
                --        JOIN LeaveType LT WITH (NOLOCK) ON LT.Id = LA.LeaveTypeId 
                --        JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
                --        LEFT JOIN LeaveStatus LS WITH (NOLOCK) ON LS.Id = LA.OverallLeaveStatusId 
    --                      WHERE (LS.IsApproved = 1 OR OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved') OR OverallLeaveStatusId IS NULL)
          --                  AND LeaveDateFrom BETWEEN @StartDate AND @EndDate
                --        AND DATENAME(dw,LeaveDateFrom) <> 'SUNDAY'
                --        AND CONVERT(DATE,LeaveDateFrom) NOT IN (SELECT CONVERT(DATE,[Date]) FROM HoliDay H JOIN EmployeeContactDetails ECD 
                --           ON H.CountryId = ECD.CountryId JOIN Employee E ON E.Id = ECD.EmployeeId 
                --            JOIN [User] U ON U.Id = LA.UserId AND U.Id = E.UserId WHERE H.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND ECD.InActiveDateTime IS NULL)
                --        AND (MLT.IsSickLeave = 1 OR MLT.IsCasualLeave = 1 OR MLT.IsWithoutIntimation = 1)
          --                  AND (IsDeleted = 0 OR IsDeleted IS NULL)
    --                      GROUP BY UserId) NA ON UD.Id = NA.UserId

                --LEFT JOIN (SELECT UserId,
          --                SUM(DATEDIFF(DAY,LeaveDateFrom,LeaveDateTo)+1) NoOfHalfDayLeaves
          --                FROM LeaveApplication LA
                --        JOIN LeaveType LT WITH (NOLOCK) ON LT.Id = LA.LeaveTypeId 
                --        JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
                --        LEFT JOIN LeaveStatus LS WITH (NOLOCK) ON LS.Id = LA.OverallLeaveStatusId 
                --        LEFT JOIN LeaveSession LSN WITH (NOLOCK) ON LSN.Id = LA.FromLeaveSessionId
    --                      WHERE (LS.IsApproved = 1 OR OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved') OR OverallLeaveStatusId IS NULL)
          --                  AND LeaveDateFrom BETWEEN @StartDate AND @EndDate
                --        AND DATENAME(dw,LeaveDateFrom) <> 'SUNDAY'
                --        AND CONVERT(DATE,LeaveDateFrom) NOT IN (SELECT CONVERT(DATE,[Date]) FROM HoliDay H JOIN EmployeeContactDetails ECD 
                --           ON H.CountryId = ECD.CountryId JOIN Employee E ON E.Id = ECD.EmployeeId 
                --            JOIN [User] U ON U.Id = LA.UserId AND U.Id = E.UserId WHERE H.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND ECD.InActiveDateTime IS NULL)
                --        AND (MLT.IsSickLeave = 1 OR MLT.IsCasualLeave = 1 OR MLT.IsWithoutIntimation = 1) 
                --        AND (LSN.IsFirstHalf = 1 OR LSN.IsSecondHalf = 1)
          --                  AND (IsDeleted = 0 OR IsDeleted IS NULL)
    --                      GROUP BY UserId) HL ON UD.Id = HL.UserId
                  
                  LEFT JOIN (SELECT TS.UserId,COUNT(1) NoOfLateDays 
                            FROM TimeSheet TS 
                            JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND TS.UserId NOT IN (SELECT UserId FROM LeaveApplication LA
                            JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId  
                            WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL
							  AND TS.[Date] = LeaveDateFrom AND FromLeaveSessionId <> @SecondHalfId) AND Ts.InActiveDateTime IS NULL
                            JOIN Employee E ON E.UserId = U.Id 
                            JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])
                                 AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])) AND ES.InActiveDateTime IS NULL
                            JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
                            JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) 
                            LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
                            WHERE CONVERT(DATE,[Date]) >= @StartDate 
                                  AND CONVERT(DATE,[Date]) <= @EndDate
                                  AND CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine)
                                  AND CONVERT(DATE,[Date]) NOT IN (SELECT CONVERT(DATE,[Date]) FROM HoliDay H JOIN EmployeeContactDetails ECD 
                             ON H.CountryId = ECD.CountryId JOIN Employee E ON E.Id = ECD.EmployeeId 
                              JOIN [User] U ON U.Id = TS.UserId AND U.Id = E.UserId WHERE H.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND ECD.InActiveDateTime IS NULL)
                            GROUP BY TS.UserId) NLD ON UD.Id = NLD.UserId) 
                   WHERE (@SearchText IS NULL 
                           OR ((CONVERT(NVARCHAR(250),UD.EmployeeNumber) LIKE @SearchText)
                           OR (CONVERT(NVARCHAR(250), UD.FullName) LIKE  @SearchText)
                           OR (CONVERT(NVARCHAR(250),UD.NoOfWorkingDays) LIKE @SearchText)
                           OR (CONVERT(NVARCHAR(250),ISNULL(WD.Absents,0)) LIKE @SearchText)
                           OR (CONVERT(NVARCHAR(250),NLD.NoOfLateDays) LIKE @SearchText)
                           OR (CONVERT(NVARCHAR(250),(ISNULL(UD.NoOfWorkingDays,0) - ISNULL(WD.Absents,0))) LIKE @SearchText)
                           OR (CONVERT(NVARCHAR(250),UD.NoOfHolidays) LIKE @SearchText)
                           OR UD.FullName LIKE @SearchText
                         ))
                    ORDER BY UD.FullName,
                     CASE WHEN @SortDirection = 'ASC' THEN
                                   CASE 
                                    WHEN @SortBy = 'fullName' THEN CAST(UD.FullName AS SQL_VARIANT)  
                                    WHEN @SortBy = 'EmployeeId' THEN CAST(UD.EmployeeNumber AS SQL_VARIANT)  
                                    WHEN @SortBy = 'TotalDays' THEN UD.TotalDays
                                    WHEN @SortBy = 'WorkingDays' THEN UD.NoOfWorkingDays
                                    WHEN @SortBy = 'Absents' THEN WD.Absents
                                    WHEN @SortBy = 'LateDays' THEN NLD.NoOfLateDays
                                    WHEN @SortBy = 'WorkedDays' THEN ISNULL(UD.NoOfWorkingDays,0) - ISNULL(WD.Absents,0)
                                    WHEN @SortBy = 'Holidays' THEN UD.NoOfHolidays
                                END
                             END ASC,
                          CASE WHEN( @SortDirection= 'DESC') THEN
                               CASE 
                                    WHEN @SortBy = 'fullName' THEN CAST(UD.FullName AS SQL_VARIANT)  
                                    WHEN @SortBy = 'EmployeeId' THEN CAST(UD.EmployeeNumber AS SQL_VARIANT)  
                                    WHEN @SortBy = 'TotalDays' THEN UD.TotalDays
                                    WHEN @SortBy = 'WorkingDays' THEN UD.NoOfWorkingDays
                                    WHEN @SortBy = 'Absents' THEN WD.Absents
                                    WHEN @SortBy = 'LateDays' THEN NLD.NoOfLateDays
                                    WHEN @SortBy = 'WorkedDays' THEN ISNULL(UD.NoOfWorkingDays,0) - ISNULL(WD.Absents,0)
                                    WHEN @SortBy = 'Holidays' THEN UD.NoOfHolidays
                                END
                            END DESC
                       OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                       FETCH NEXT @PageSize ROWS ONLY
       END TRY  
       BEGIN CATCH 
        
             THROW

       END CATCH
END
