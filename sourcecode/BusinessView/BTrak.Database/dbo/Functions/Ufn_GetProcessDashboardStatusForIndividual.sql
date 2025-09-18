CREATE FUNCTION [dbo].[Ufn_GetProcessDashboardStatusForIndividual]
(
	@Date DATETIME,
	@UserId UNIQUEIDENTIFIER,
	@StatusType VARCHAR(100)
)
RETURNS @GoalStatus TABLE
(
	TeamLead VARCHAR(800),
	StatusColor VARCHAR(100),
	GeneratedDate DATETIME,
	StatusNumber INT,
	RedCount INT
)
BEGIN

 INSERT INTO @GoalStatus(TeamLead,GeneratedDate)
 SELECT TeamLead,GeneratedDate
 FROM [dbo].[Ufn_GetProcessDashboardStatus](@Date,@UserId,@StatusType)
 GROUP BY GeneratedDate,TeamLead

 UPDATE @GoalStatus SET RedCount = ISNULL(FTInner.RedCount,0)
 FROM @GoalStatus GS
      LEFT JOIN (SELECT TeamLead,GeneratedDate,COUNT(1) RedCount
                 FROM [dbo].[Ufn_GetProcessDashboardStatus](@Date,@UserId,@StatusType)
                 WHERE StatusColor = '#ff141c'
                 GROUP BY TeamLead,GeneratedDate) FTInner ON FTInner.TeamLead = GS.TeamLead AND FTInner.GeneratedDate = GS.GeneratedDate

 UPDATE @GoalStatus SET StatusColor = CASE WHEN RedCount >= 1 THEN '#ff141c' ELSE '#04fe02' END

 UPDATE @GoalStatus SET StatusNumber = CASE WHEN RedCount >= 1 THEN 2 ELSE 1 END

RETURN
END