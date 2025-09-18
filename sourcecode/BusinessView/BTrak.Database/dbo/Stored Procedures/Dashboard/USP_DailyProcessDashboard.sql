CREATE PROCEDURE  [dbo].[USP_DailyProcessDashboard]
(
  @Parameter VARCHAR(500) = null,
  @UserId UNIQUEIDENTIFIER
)
AS
BEGIN
DECLARE @UserIds TABLE
(
   UserId UNIQUEIDENTIFIER
)
DECLARE @IsAdmin BIT
SELECT @IsAdmin = IsAdmin FROM [User] WHERE Id = @UserId
IF (@IsAdmin = 1)
BEGIN
    INSERT INTO @UserIds (UserId)
    SELECT Id FROM [User]
    WHERE IsActive = 1
END
ELSE
BEGIN
    INSERT INTO @UserIds (UserId) VALUES(@UserId)
END
 DECLARE @ProcessDashboard TABLE
 (
     GoalId UNIQUEIDENTIFIER,
     GoalName NVARCHAR(1000),
     GoalResponsibleUserId UNIQUEIDENTIFIER,
     GoalResponsibleUserName VARCHAR(250),
     GoalStatusColor VARCHAR(250),
     OnBoardProcessDate DATETIME,
     MileStone DATETIME,
     [Delay] INT,
     DelayColor VARCHAR(250),
     MaxActualDeadLine DATETIME
 )
 INSERT INTO @ProcessDashboard(GoalId,GoalName,GoalResponsibleUserId,GoalResponsibleUserName,GoalStatusColor,OnBoardProcessDate)
 SELECT G.Id,CASE WHEN (GoalShortName IS NULL OR GoalShortName = '') THEN GoalName ELSE GoalShortName END Goal,
 GoalResponsibleUserId,U.FirstName + ' '+ U.SurName,GoalStatusColor,OnboardProcessDate 
 FROM Goal G JOIN Project P ON G.ProjectId = P.Id
             JOIN [User] U ON U.Id = G.GoalResponsibleUserId
             WHERE CONVERT(DATE,GETUTCDATE()) >= OnboardProcessDate
             AND (G.InActiveDateTime IS NULL)
			 AND G.GoalStatusId IN ('7A79AB9F-D6F0-40A0-A191-CED6C06656DE','5AF65423-AFC4-4E9D-A011-F4DF97ED5FAF')
			 AND IsToBeTracked = 1 AND G.ParkedDateTime IS NULL

 UPDATE @ProcessDashboard SET MileStone = MileStoneVal, MaxActualDeadLine = MaxActualDeadLineVal
 FROM @ProcessDashboard PD JOIN
         (SELECT G.Id GoalId, MAX(DeadLineDate) MileStoneVal,MAX([ActualDeadLineDate]) MaxActualDeadLineVal
          FROM Goal G JOIN UserStory US ON US.GoalId = G.Id
          GROUP BY G.Id) FTInner ON FTInner.GoalId = PD.GoalId

 UPDATE @ProcessDashboard SET [Delay] =  DATEDIFF(DAY,MaxActualDeadLine,MileStone)
 UPDATE @ProcessDashboard SET DelayColor =  CASE WHEN ISNULL([Delay],0) <= 0 THEN '#f0c6c2' ELSE '#daead4' END

 INSERT INTO @ProcessDashboard (GoalId,GoalName,GoalResponsibleUserId,GoalResponsibleUserName ,GoalStatusColor,OnBoardProcessDate,MileStone,[Delay],DelayColor)
 SELECT G.Id,CASE WHEN (GoalShortName IS NULL OR GoalShortName = '') THEN GoalName ELSE GoalShortName END Goal,U.Id, U.FirstName + ' ' + U.SurName,'#04fefe' GoalStatusColor, 
 G.OnboardProcessDate,NULL,0,'#04fefe'
 FROM Goal G JOIN Project P ON G.ProjectId = P.Id
             JOIN [User] U ON G.GoalResponsibleUserId = U.Id
             WHERE CONVERT(DATE,GETUTCDATE()) < OnboardProcessDate
             AND (G.InActiveDateTime IS NULL)
             AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE'
			 AND IsToBeTracked = 1 AND G.ParkedDateTime IS NULL

 INSERT INTO @ProcessDashboard (GoalId,GoalName,GoalResponsibleUserId,GoalResponsibleUserName ,GoalStatusColor,OnBoardProcessDate,MileStone,[Delay],DelayColor)
 SELECT G.Id,CASE WHEN (GoalShortName IS NULL OR GoalShortName = '') THEN GoalName ELSE GoalShortName END Goal,U.Id, U.FirstName + ' ' + U.SurName,'#ff141c' GoalStatusColor, 
 G.OnboardProcessDate,NULL,0,'#ff141c'
 FROM Goal G JOIN Project P ON G.ProjectId = P.Id
             JOIN [User] U ON G.GoalResponsibleUserId = U.Id
             WHERE CONVERT(DATE,GETUTCDATE()) >= OnboardProcessDate
             AND (G.InActiveDateTime IS NULL)
			 AND G.GoalStatusId = 'F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3'
			 AND IsToBeTracked = 1 AND G.ParkedDateTime IS NULL

 SELECT * FROM @ProcessDashboard WHERE (GoalStatusColor = @Parameter OR @Parameter IS NULL) AND GoalResponsibleUserId IN (SELECT UserId FROM @UserIds) ORDER BY GoalName

END