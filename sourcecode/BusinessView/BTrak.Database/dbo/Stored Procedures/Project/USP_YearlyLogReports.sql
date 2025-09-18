CREATE PROCEDURE [dbo].[USP_YearlyLogReports]
(
   @SelectedDate DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @TeamLeadId UNIQUEIDENTIFIER = NULL,
   @PageLoad BIT = 1,
   @CompanyId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER
)
AS
BEGIN
   DECLARE @YearlyLogReport TABLE
    (
        UserId UniqueIdentifier NOT NULL,
        FullName nVARCHAR(800),
        [Date] DATETIME,
        SpentTime INT,
        LogTime INT,
        SummaryValue NVARCHAR(1000),
        Summary NVARCHAR(800)
    )
    DECLARE @DateFrom DATETIME = NULL
    DECLARE @DateTo DATETIME = NULL
    SET @DateFrom = DATEADD(YEAR, DATEDIFF(YEAR, 0, @SelectedDate), 0)
    SET @DateTo = DATEADD (dd, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @SelectedDate) + 1, 0))
    DECLARE @ret TABLE 
    (
        lvl INTEGER,
        ParentId UNIQUEIDENTIFIER,
        ChildId UNIQUEIDENTIFIER
    )
    IF (@BranchId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @BranchId = NULL
    END
    IF (@TeamLeadId = '00000000-0000-0000-0000-000000000000')
    BEGIN
        SET @TeamLeadId = NULL
    END
    IF(@PageLoad = 1)
    BEGIN
        IF((SELECT IsAdmin FROM [User] WHERE Id = @TeamLeadId) = 1)
            SET @TeamLeadId = NULL
    END
    IF(@TeamLeadId IS NULL)
    BEGIN
        INSERT INTO @ret(ChildId)
        SELECT U.Id FROM [User] U 
    END
    ELSE
    BEGIN
        DECLARE @GetParent UNIQUEIDENTIFIER
        SELECT @GetParent = E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE U.Id = @TeamLeadId
         
         DECLARE @lvl INTEGER
         SET @lvl = 1
         INSERT INTO @ret (lvl, ParentId, ChildId) SELECT @lvl, @GetParent, EmployeeId FROM EmployeeReportTo WHERE ReportToEmployeeId = @GetParent AND ActiveTo IS NULL
         WHILE (@@ROWCOUNT > 0)
         BEGIN
            SET @lvl = @lvl + 1
            INSERT INTO @ret (lvl, ParentId, ChildId)
            SELECT @lvl, p.ReportToEmployeeId, P.EmployeeId
            FROM EmployeeReportTo P
            JOIN @ret r ON r.lvl = @lvl - 1 and P.ReportToEmployeeId = r.ChildId
            JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId 
            WHERE U.CompanyId = @CompanyId AND  P.ActiveTo IS NULL
         END
         UPDATE @ret SET  ChildId = U.Id
         FROM @ret r JOIN Employee E ON E.Id = r.ChildId JOIN [User] U On U.Id = E.UserId
        
        INSERT INTO @ret VALUES(0,@TeamLeadId,@TeamLeadId)
    END
    DECLARE @DimDate TABLE
    (
        [Date] DATETIME
    )
    
    ;WITH CTE AS
    (
        SELECT @DateFrom AS Result
        UNION ALL
        SELECT Result+1 FROM CTE WHERE Result+1 <= @DateTo
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
        INSERT INTO @YearlyLogReport(UserId,FullName,[Date])
        SELECT U.Id,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),@PresentDate
        FROM [User] U JOIN @ret r ON r.ChildId = U.Id JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN Company C ON C.Id = U.CompanyId LEFT JOIN Employee E ON E.UserId = U.Id
             LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
			 LEFT JOIN ProjectFeatureResposiblePerson PFR ON PFR.UserId = U.Id
			 LEFT JOIN ProjectFeature PF ON PFR.ProjectFeatureId = PF.Id
        WHERE ((UAD.ActiveFrom >= @DateFrom AND UAD.ActiveFrom <= @DateTo) OR @DateFrom >= UAD.ActiveFrom)  AND (@DateFrom <= UAD.ActiveTo OR UAD.ActiveTo IS NULL) AND U.IsActive = 1
              AND (CompanyId = @CompanyId)
              AND (EB.BranchId = @BranchId OR @BranchId IS NULL)
			  AND (PF.ProjectId = @ProjectId OR @ProjectId IS NULL)
        GROUP BY U.Id,FirstName,SurName
        FETCH NEXT FROM DATE_CURSOR INTO @PresentDate 
    END 
     
    CLOSE DATE_CURSOR  
    DEALLOCATE DATE_CURSOR
    
    UPDATE @YearlyLogReport SET LogTime = CEILING(ISNULL(MLRInner.SpentTime,0)) 
    FROM @YearlyLogReport MLR 
         LEFT JOIN (SELECT OwnerUserId,CONVERT(DATE,UST.CreatedDateTime) [Date],SUM(SpentTimeInMin/60.0) SpentTime
                    FROM UserStory US JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND US.OwnerUserId = UST.CreatedByUserId
                    WHERE (CONVERT(DATE,UST.CreatedDateTime) <= @DateTo) AND (CONVERT(DATE,UST.CreatedDateTime) >= @DateFrom)
                    GROUP BY OwnerUserId,CONVERT(DATE,UST.CreatedDateTime)) MLRInner ON MLRInner.OwnerUserId = MLR.UserId AND MLRInner.[Date] = MLR.[Date]
    
    UPDATE @YearlyLogReport SET SpentTime = (ISNULL(MLRInner.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60
    FROM @YearlyLogReport MLR 
         LEFT JOIN (SELECT UserId, [Date],ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) SpentTime
                    FROM TimeSheet TS
                    WHERE  Date <= @DateTo AND Date >= @DateFrom) MLRInner ON MLRInner.UserId = MLR.UserId AND MLRInner.[Date] = MLR.[Date]
        LEFT JOIN (SELECT SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)) BreakTime,UB.UserId,UB.[Date] 
                    FROM UserBreak UB
                    WHERE  Date <= @DateTo AND Date >= @DateFrom
                    GROUP BY UB.UserId,UB.[Date]) UBInner ON UBInner.UserId = MLR.UserId AND UBInner.[Date] = MLR.[Date]
        
     UPDATE @YearlyLogReport SET SummaryValue = CASE WHEN DATENAME(DW,MLR.[Date]) = 'SUNDAY' THEN 'rgb(200,200,200)'
                                                     WHEN H.[Date] IS NOT NULL THEN 'rgb(255,255,0)'
                                                     WHEN LogTime < SpentTime THEN 	'rgb(255, 0, 0)' 
                                                     WHEN LogTime >= SpentTime THEN  'rgb(64, 255, 0)' END FROM Holiday H RIGHT JOIN @YearlyLogReport MLR ON H.[Date] = MLR.[Date]
    --UPDATE @MonthlyLogReport SET SummaryValue = CASE WHEN H.[Date] IS NOT NULL THEN 3  END
    --FROM Holiday H RIGHT JOIN @MonthlyLogReport MLR ON H.[Date] = MLR.[Date]
    UPDATE @YearlyLogReport SET Summary = CASE WHEN SummaryValue IN ('rgb(255, 0, 0)' ,'rgb(64, 255, 0)') THEN (FullName+' (Log Time :' + CAST(LogTime AS nvarchar(100)) + ', SpentTime :' + CAST(SpentTime AS nvarchar(100)) + ') ')
                                                WHEN SummaryValue = 'rgb(200,200,200)' THEN 'Sunday'
                                                WHEN SummaryValue = 'rgb(255,255,0)' THEN 'Holiday' 
												WHEN SummaryValue = 'rgb(200,200,200)' THEN 'No record of Logged Hours' 
												END
    
    IF((SELECT COUNT(SummaryValue) FROM @YearlyLogReport  WHERE SummaryValue = 'rgb(255,255,0)') = 'rgb(200,200,200)')
        UPDATE  @YearlyLogReport SET SummaryValue = 'rgb(255,255,0)' WHERE SummaryValue = 'rgb(200,200,200)'
		
    IF(@PageLoad <> 1)
        DELETE  @YearlyLogReport  WHERE UserId = @TeamLeadId

	Update @YearlyLogReport SET SummaryValue ='rgb(200,200,200)' where [Date] > GETDATE()
	Update @YearlyLogReport SET SummaryValue ='rgb(30,144,255)' From @YearlyLogReport MLR 
	            LEFT JOIN [dbo].[LeaveApplication]LA ON LA.UserId = MLR.UserId
				 	where ((LA.LeaveDateFrom >=@DateFrom and LA.LeaveDateFrom <=@DateTo) and (LA.LeaveDateTo >= @DateFrom and LA.LeaveDateTo < @DateTo))
				

				 SELECT * FROM @YearlyLogReport
    END