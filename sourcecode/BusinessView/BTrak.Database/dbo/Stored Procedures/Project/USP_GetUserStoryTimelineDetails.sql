CREATE PROCEDURE [dbo].[USP_GetUserStoryTimelineDetails]
(
  @UserId UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN 

DECLARE @Date DATETIME = GETDATE()
  SELECT US.Id,
         US.UserStoryName,
		 US.EstimatedTime,
		 US.UserStoryStatusId,
		 USS.[Status] AS UserStoryStatus ,
		 (USST.SpentTimeInMin/60.0) as LoggedTime,
		 US.OwnerUserId,
		 U.UserName,
      CASE WHEN USST.SpentTimeInMin > US.EstimatedTime THEN 'rgb(255,255,0)' 
	       WHEN US.EstimatedTime = (USST.SpentTimeInMin/60.0) THEN '#rgb(0,128,0)'
		   WHEN (USST.SpentTimeInMin/60.0) < US.EstimatedTime THEN '#rgb(0,255,255)'
		   END AS LoggedTimeColor,
	   'rgb(128,128,128)' as RemainingTimeColor,
		   
	  CASE WHEN US.EstimatedTime >= (USST.SpentTimeInMin/60.0) THEN US.EstimatedTime - (USST.SpentTimeInMin/60.0)
	       WHEN (USST.SpentTimeInMin/60.0) > US.EstimatedTime THEN (USST.SpentTimeInMin/60.0) - US.EstimatedTime
		   END AS RemainingTime,
		  ST.SpentTime AS UserSpentTimeInOffice 
	 FROM [dbo].[UserStory]US WITH (NOLOCK)
	 INNER JOIN [dbo].[UserStoryStatus]USS ON USS.Id = US.UserStoryStatusId
	 INNER JOIN [dbo].[UserStorySpentTime]USST WITH (NOLOCK) ON USST.UserStoryId = US.Id
	 INNER JOIN [dbo].[User]U WITH (NOLOCK) ON U.Id = US.OwnerUserId
	 INNER JOIN [dbo].[TimeSheet]TS WITH (NOLOCK) ON TS.UserId = @UserId
	 LEFT JOIN [dbo].[UserBreak]UB ON UB.UserId = @UserId
	 LEFT JOIN (SELECT TS.UserId,(DATEDIFF(MINUTE, TS.InTime,CASE WHEN @Date = CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL 
	 AND OutTime IS NULL THEN GETUTCDATE() ELSE TS.OutTime END) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0))/60.0 SpentTime
		            FROM TimeSheet TS LEFT JOIN UserBreak UB ON UB.[Date] = TS.[Date] AND UB.UserId = TS.UserId
					WHERE TS.[Date] = @Date AND TS.UserId = @UserId
					GROUP BY TS.UserId,TS.InTime,OutTime,TS.LunchBreakStartTime,TS.LunchBreakEndTime) ST ON ST.UserId = U.Id
	 WHERE US.OwnerUserId = @UserId and U.CompanyId = @CompanyId

	 END