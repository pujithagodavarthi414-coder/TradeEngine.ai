CREATE FUNCTION [dbo].[Ufn_GetProcessDashboardStatus]
(
	@Date DATETIME,
	@UserId UNIQUEIDENTIFIER,
	@StatusType VARCHAR(100)
)

RETURNS @GoalStatus TABLE
(
	GoalId UNIQUEIDENTIFIER,
	GoalName VARCHAR(MAX),
	TeamLeadId UNIQUEIDENTIFIER,
	TeamLead VARCHAR(800),
	StatusColor VARCHAR(100),
	GeneratedDateTime DATETIME,
	GeneratedDate DATETIME,
	StatusNumber INT
)
BEGIN
DECLARE @UserIds TABLE
(
	UserId UNIQUEIDENTIFIER
)

DECLARE @IsAdmin BIT
SET @IsAdmin = (SELECT IsAdmin FROM [User] WHERE Id = @UserId)
IF (@IsAdmin = 1)
BEGIN
    INSERT INTO @UserIds (UserId)
    SELECT Id FROM [User]  
    WHERE IsActive = 1
END
ELSE
BEGIN
    INSERT INTO @UserIds (UserId)
    SELECT @UserId
END

 DECLARE @StartDate DATETIME
 DECLARE @EndDate DATETIME
 DECLARE @CurrentDate DATE
 SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
 SELECT @StartDate =  DATEADD(q, DATEDIFF(q, 0, @Date), 0)
 SELECT @EndDate = DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, @Date) + 1, 0))

 IF(@EndDate >= @CurrentDate)
 BEGIN
     SET @EndDate = @CurrentDate
 END

 DECLARE @PresentDate DATETIME

 DECLARE DATE_CURSOR CURSOR FOR  
 SELECT CONVERT(DATE,GeneratedDateTime) GeneratedDate
 FROM [dbo].[ProcessDashboard]
 WHERE (DATENAME(WEEKDAY,GeneratedDateTime) = 'Monday' OR DATENAME(WeekDay,GeneratedDateTime) = 'Thursday')
       AND (CONVERT(DATE,GeneratedDateTime) >= @StartDate OR @StartDate IS NULL)
       AND (CONVERT(DATE,GeneratedDateTime) <= @EndDate OR @EndDate IS NULL)
 GROUP BY CONVERT(DATE,GeneratedDateTime)

 OPEN DATE_CURSOR  
 FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  

 WHILE @@FETCH_STATUS = 0  
 BEGIN
 
      DECLARE @GenerateDate DATETIME

      IF(@StatusType = 'OvernightStatus')
      BEGIN
           IF(DATENAME(WEEKDAY,@PresentDate) = 'Monday')
           BEGIN
               SELECT @GenerateDate = DATEADD(DAY,-2,@PresentDate)
           END
           ELSE IF(DATENAME(WEEKDAY,@PresentDate) = 'Thursday')
           BEGIN
               SELECT @GenerateDate = DATEADD(DAY,-1,@PresentDate)
           END
      END
      ELSE IF(@StatusType = 'NextdayEndStatus')
      BEGIN
           SELECT @GenerateDate = @PresentDate
      END

     DECLARE @MaxDashboardId INT
     SELECT @MaxDashboardId = MAX(DashboardId) FROM [ProcessDashboard] WHERE CONVERT(DATE,GeneratedDateTime) = @GenerateDate

       IF (@IsAdmin = 1)
     BEGIN
       INSERT INTO @GoalStatus(GoalId,GoalName,TeamLeadId,TeamLead,[StatusColor],GeneratedDateTime,GeneratedDate)
       SELECT GoalId,GoalName,GoalResponsibleUserId,U.FirstName,PD.[GoalStatusColor],GeneratedDateTime,@GenerateDate
       FROM [ProcessDashboard] PD JOIN Goal G ON G.Id = PD.GoalId JOIN [User] U ON U.Id = G.GoalResponsibleUserId
       WHERE DashboardId = @MaxDashboardId AND U.Id IN (SELECT UserId FROM @UserIds)
       GROUP BY GoalId,GoalName,GoalResponsibleUserId,U.FirstName,PD.[GoalStatusColor],GeneratedDateTime
     END
     ELSE
     BEGIN
       INSERT INTO @GoalStatus(GoalId,GoalName,TeamLeadId,TeamLead,[StatusColor],GeneratedDateTime,GeneratedDate)
       SELECT GoalId,GoalName,GoalResponsibleUserId,U.FirstName,PD.[GoalStatusColor],GeneratedDateTime,@GenerateDate
       FROM [ProcessDashboard] PD JOIN Goal G ON G.Id = PD.GoalId JOIN [User] U ON U.Id = G.GoalResponsibleUserId
       WHERE DashboardId = @MaxDashboardId AND GoalResponsibleUserId = @UserId
       GROUP BY GoalId,GoalName,GoalResponsibleUserId,U.FirstName,PD.[GoalStatusColor],GeneratedDateTime
     END

     UPDATE @GoalStatus SET StatusNumber = CASE WHEN ([StatusColor] = '#ff141c') THEN 2 ELSE 1 END
     --UPDATE @GoalStatus SET TeamLead = 'Praveen CH' --WHERE TeamLeadId = 38

     FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  

 END  
 
 CLOSE DATE_CURSOR  
 DEALLOCATE DATE_CURSOR

RETURN
END