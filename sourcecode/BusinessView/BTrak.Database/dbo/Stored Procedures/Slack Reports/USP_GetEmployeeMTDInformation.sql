CREATE PROCEDURE [dbo].[USP_GetEmployeeMTDInformation]
(
    @UserId UNIQUEIDENTIFIER,
    @Date DATETIME,
    @CompanyId UNIQUEIDENTIFIER = NULL    
)
AS
BEGIN
DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
IF (@HavePermission = '1')
BEGIN  
DECLARE @EmployeeMTDInformation TABLE
(
   EmployeeId UNIQUEIDENTIFIER,
   FullName VARCHAR(500),
   [Date] DATETIME,
   Intime TIME,
   LunchBreakStartTime TIME,
   LunchBreakEndTime TIME,
   DeadlineTime TIME,
   MorningLate BIT,
   LunchLate BIT,
   Top5PercentOfMorningLate BIT,
   Top5PercentOfLunchLate BIT,
   LongSickLeave BIT,
   CasualLeave BIT,
   MondayLeave BIT,
   DateKey INT,
   IsHoliday BIT,
   IsSunday BIT,
   [Description] VARCHAR(100),
   Value INT
   
)

   IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
   BEGIN
   SET @CompanyId = NULL
   END

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
   DECLARE @Types TABLE
   (
        [Description] VARCHAR(100)
   )

   INSERT INTO @Types([Description]) VALUES('Monday(A)')
   INSERT INTO @Types([Description]) VALUES('Casual(A)')
   INSERT INTO @Types([Description]) VALUES('Sick(A)')
   INSERT INTO @Types([Description]) VALUES('Top 5(L.L)')
   INSERT INTO @Types([Description]) VALUES('Top 5(M.L)')
   INSERT INTO @Types([Description]) VALUES('Late(L)')
   INSERT INTO @Types([Description]) VALUES('Late(M)')

   DECLARE @PresentDate DATETIME
   DECLARE @PresentDescription VARCHAR(100)
   DECLARE DATE_CURSOR CURSOR FOR  
   SELECT [Date] FROM @DimDate
   
   OPEN DATE_CURSOR  
   FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
   
   WHILE @@FETCH_STATUS = 0  
   BEGIN

    DECLARE Description_CURSOR CURSOR FOR  
    SELECT [Description] FROM @Types
   
	OPEN Description_CURSOR  
	FETCH NEXT FROM Description_CURSOR INTO @PresentDescription  
   
	WHILE @@FETCH_STATUS = 0  
	BEGIN

		INSERT INTO @EmployeeMTDInformation(EmployeeId,FullName,DeadlineTime,[Date],[Description])
		SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),ISNULL(SE.DeadLine,SW.DeadLine),@PresentDate,@PresentDescription
		FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE())) LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
		     LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = DATENAME(WEEKDAY,GETDATE())   LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id
			 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND ISNULL(SE.DeadLine,SW.DeadLine) IS NULL
		WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
		         AND @UserId = U.Id AND (U.CompanyId = @CompanyId)

	    FETCH NEXT FROM Description_CURSOR INTO @PresentDescription  

	END  

   CLOSE Description_CURSOR  
   DEALLOCATE Description_CURSOR

   FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  

   END  

   CLOSE DATE_CURSOR  
   DEALLOCATE DATE_CURSOR

    UPDATE @EmployeeMTDInformation SET Intime = TS.InTime, LunchBreakStartTime = TS.LunchBreakStartTime, LunchBreakEndTime = TS.LunchBreakEndTime
    FROM @EmployeeMTDInformation SS JOIN TimeSheet TS ON TS.UserId = SS.EmployeeId AND TS.[Date] = SS.[Date]

    UPDATE @EmployeeMTDInformation SET MorningLate = CASE WHEN Intime > DeadLineTime THEN 1 ELSE 0 END,
	                                   LunchLate = CASE WHEN DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime) > 70 THEN 1 ELSE 0 END,
									   IsHoliday = CASE WHEN [Date] IN (SELECT [Date] FROM Holiday) THEN 1 ELSE 0 END,
									   IsSunday = CASE WHEN DATENAME(DW,[Date]) = 'SUNDAY' THEN 1 ELSE 0 END

    UPDATE @EmployeeMTDInformation SET LongSickLeave = CASE WHEN  LeaveTypeId = 'F2785350-EF29-42E4-A7D5-7AC4FF086AD6' THEN 1 ELSE 0 END,
                                      CasualLeave = CASE WHEN  LeaveTypeId = 'D2184B73-FD09-460B-9B13-81600A0C8084' THEN 1 ELSE 0 END
   FROM @EmployeeMTDInformation SS JOIN LeaveApplication LA ON LA.UserId = SS.EmployeeId AND SS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo

    UPDATE @EmployeeMTDInformation SET MondayLeave = CASE WHEN  DATENAME(dw,SS.[Date]) = 'Monday' AND (SS.[Date] BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo) THEN 1 ELSE 0 END 
	FROM @EmployeeMTDInformation SS JOIN LeaveApplication LA ON LA.UserId = SS.EmployeeId AND SS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo

    UPDATE @EmployeeMTDInformation SET Top5PercentOfMorningLate = 1
	FROM  @EmployeeMTDInformation SS JOIN [dbo].[USP_GetTop5LateEmployee](@StartDate,@EndDate) GE ON SS.EmployeeId = GE.UserId AND CONVERT(Date,SS.[Date])= CONVERT(Date,GE.[Date])

    UPDATE @EmployeeMTDInformation SET Top5PercentOfMorningLate = 0 WHERE Top5PercentOfMorningLate IS NULL

    UPDATE @EmployeeMTDInformation SET Top5PercentOfLunchLate = 1
	FROM  @EmployeeMTDInformation SS JOIN [dbo].[USP_GetTop5LunchBreakLongTakeEmployees](@StartDate,@EndDate) GE ON SS.EmployeeId = GE.UserId AND CONVERT(Date,SS.[Date]) = CONVERT(Date,GE.[Date])

    UPDATE @EmployeeMTDInformation SET Top5PercentOfLunchLate = 0 WHERE Top5PercentOfLunchLate IS NULL

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN CasualLeave = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Casual(A)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN LongSickLeave = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Sick(A)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN MorningLate = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Late(M)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN LunchLate = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Late(L)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN MondayLeave = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Monday(A)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN Top5PercentOfMorningLate = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Top 5(M.L)'

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN Top5PercentOfLunchLate = 1 THEN 1 ELSE 0 END WHERE [Description] = 'Top 5(L.L)'

    UPDATE @EmployeeMTDInformation SET Value = 2 
	WHERE CONVERT(Date,[Date]) > @CurrentDate OR (CONVERT(Date,[Date]) <= @CurrentDate AND InTime IS NULL AND IsSunday = 0 AND IsHoliday =0 AND LongSickLeave <> 1 AND CasualLeave <> 1 AND MondayLeave <> 1)
           AND ([Description] <> 'Casual(A)' OR [Description] <> 'Sick(A)' OR [Description] <> 'Late(M)' OR [Description] <> 'Late(L)' OR [Description] <> 'Monday(A)' OR [Description] <> 'Top 5(M.L)' OR [Description] <> 'Top 5(L.L)')

    UPDATE @EmployeeMTDInformation SET Value = CASE WHEN IsHoliday = 1 THEN 3 
                                                    WHEN IsSunday = 1 THEN 4 END 
    WHERE CAST(CONVERT(CHAR(8), [Date], 112) AS INT) IN (SELECT DateKey FROM Holiday) OR DATENAME(WEEKDAY,[Date])='Sunday' 
          AND ([Description] <> 'Casual(A)' OR [Description] <> 'Sick(A)' OR [Description] <> 'Late(M)' OR [Description] <> 'Late(L)' OR [Description] <> 'Monday(A)' OR [Description] <> 'Top 5(M.L)' OR [Description] <> 'Top 5(L.L)')
    
   SELECT * FROM @EmployeeMTDInformation ORDER BY [Date]

END
END