CREATE PROCEDURE [dbo].[USP_GetEmployeeUserStorySpentTimeReport]
(
    @ProjectId UNIQUEIDENTIFIER,
    @DateDesc VARCHAR(100),
    @DateFrom DATETIME,
    @DateTo DATETIME,
    @Days INT,
    @UserDesc VARCHAR(100),
    @UserId UNIQUEIDENTIFIER,
	@HoursDesc VARCHAR(100),
	@HoursFrom INT,
	@HoursTo INT

)
AS
BEGIN
   DECLARE @MaxDate DATETIME
    DECLARE @MinDate DATETIME
    DECLARE @CurrentDate DATETIME
    DECLARE @WeekStart DATETIME
    DECLARE @WeekEnd DATETIME
    DECLARE @MonthStart DATETIME
    DECLARE @MonthEnd DATETIME
    DECLARE @StartOfYear DATETIME
    DECLARE @EndOfYear DATETIME
    DECLARE @MaxHours INT
    DECLARE @MinHours INT

    SELECT @MaxDate = MAX(CONVERT(DATE,StartDateTime)) FROM UserStoryLogTime
    SELECT @MinDate = MIN(CONVERT(DATE,StartDateTime)) FROM UserStoryLogTime
    SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
    SELECT @WeekStart = DATEADD(dd, -(DATEPART(dw, @CurrentDate)-1), @CurrentDate) 
    SELECT @WeekEnd = DATEADD(dd, 7-(DATEPART(dw, @CurrentDate)), @CurrentDate)
    SELECT @MonthStart = DATEADD(MONTH, DATEDIFF(month, 0,  @CurrentDate), 0) 
    SELECT @MonthEnd = DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate) , 0) ) )
    SELECT @StartOfYear = DATEADD(yy, DATEDIFF(yy, 0, @CurrentDate), 0)
    SELECT @MaxHours =  MAX(DATEDIFF(HOUR, StartDateTime, EndDateTime)) FROM UserStoryLogTime
    SELECT @MinHours =  MIN(DATEDIFF(HOUR, StartDateTime, EndDateTime)) FROM UserStoryLogTime

    IF (@ProjectId = '00000000-0000-0000-0000-000000000000')
    SET @ProjectId = NULL

    IF(@DateDesc = 'any')
    BEGIN
        SET @DateFrom = NULL
        SET @DateTo = NULL
    END
    ELSE IF(@DateDesc = 'is')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @DateFrom
    END
    ELSE IF(@DateDesc = '>=')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @MaxDate
    END
    ELSE IF(@DateDesc = '<=')
    BEGIN
        SET @DateFrom = @MinDate
        SET @DateTo = @DateFrom
    END
    ELSE IF(@DateDesc = 'between')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @DateTo
    END
    ELSE IF(@DateDesc = 'lessthandaysago')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-@Days,@CurrentDate)
        SET @DateTo = @CurrentDate
    END
    ELSE IF(@DateDesc = 'morethandaysago')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = DATEADD(DAY,@Days,@CurrentDate)
    END
    ELSE IF(@DateDesc = 'daysago')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-@Days,@CurrentDate)
        SET @DateTo = NULL
    END
    ELSE IF(@DateDesc = 'today')
    BEGIN
        SET @DateFrom = @CurrentDate
        SET @DateTo = NULL
    END
    ELSE IF(@DateDesc = 'yesterday')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-1,@CurrentDate)
        SET @DateTo = NULL
    END
    ELSE IF(@DateDesc = 'thisweek')
    BEGIN
        SET @DateFrom = DATEADD(dd, -(DATEPART(dw, @CurrentDate)-1), @CurrentDate)
        SET @DateTo = @CurrentDate
    END
    ELSE IF(@DateDesc = 'lastweek')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-7,@WeekStart)
        SET @DateTo = DATEADD(DAY,-7,@WeekEnd)
    END
    ELSE IF(@DateDesc = 'last2weeks')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-14,@WeekStart)
        SET @DateTo = DATEADD(DAY,-14,@WeekEnd)
    END
    ELSE IF(@DateDesc = 'thismonth')
    BEGIN
        SET @DateFrom = @MonthStart
        SET @DateTo = @MonthEnd
    END
    ELSE IF(@DateDesc = 'lastmonth')
    BEGIN
        SET @DateFrom = DATEADD(MONTH,-1,@MonthStart)
        SET @DateTo = DATEADD(MONTH,-1,@MonthEnd)
    END
    ELSE IF(@DateDesc = 'thisyear')
    BEGIN
        SET @DateFrom = @StartOfYear
        SET @DateTo = @EndOfYear
    END
    ELSE IF(@DateDesc = 'none')
    BEGIN
        SET @DateFrom = '1800-01-01'
        SET @DateTo = '1800-01-01'
    END
    DECLARE @Users TABLE
    (
        UserId UNIQUEIDENTIFIER
    )
    IF(@UserDesc = 'is')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User] WHERE Id = @UserId
    END
    ELSE IF(@UserDesc = 'isnot')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User] WHERE Id NOT IN (@UserId)
    END
    ELSE IF(@UserDesc = 'any')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User]
    END
	IF(@HoursDesc = 'any')
    BEGIN
        SET @HoursFrom = NULL
        SET @HoursTo = NULL
    END
	ELSE IF(@HoursDesc = 'is')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @HoursFrom
    END
	ELSE IF(@HoursDesc = '>=')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @MaxHours
    END
	ELSE IF(@HoursDesc = '<=')
    BEGIN
        SET @HoursTo = @HoursFrom
        SET @HoursFrom = @MinHours
    END
	ELSE IF(@HoursDesc = 'between')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @HoursTo
    END
	ELSE IF(@HoursDesc = 'none')
    BEGIN
        SET @HoursFrom = -999999
        SET @HoursTo = -999999
    END

    SELECT U.Id UserId,ISNULL(U.FirstName,'') +' ' + ISNULL(U.SurName,'') UserName,ULT.StartDateTime [Date],US.UserStoryName,DATEDIFF(HOUR, StartDateTime, EndDateTime) SpentTime 
    FROM [User] U WITH (NOLOCK)
        JOIN UserStoryLogTime ULT WITH (NOLOCK) ON ULT.UserId = U.Id JOIN UserStory US WITH (NOLOCK) ON US.Id = ULT.UserStoryId
		JOIN Project P ON P.Id = US.ProjectId
		LEFT JOIN Goal G WITH (NOLOCK) ON G.Id = US.GoalId
		LEFT JOIN Sprints S WITH (NOLOCK) ON S.Id = US.SprintId
    WHERE (@ProjectId IS NULL OR @ProjectId = US.ProjectId) 
          AND (CONVERT(DATE,ULT.StartDateTime) >= @DateFrom OR @DateFrom IS NULL) 
          AND (CONVERT(DATE,ULT.StartDateTime) <= @DateTo OR @DateTo IS NULL)
          AND ULT.UserId IN (SELECT UserId FROM @Users)
		  AND (DATEDIFF(HOUR, StartDateTime, EndDateTime) >= @HoursFrom OR @HoursFrom IS NULL) 
          AND (DATEDIFF(HOUR, StartDateTime, EndDateTime) <= @HoursTo OR @HoursTo IS NULL) 
    END