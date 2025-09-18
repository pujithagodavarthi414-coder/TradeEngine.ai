-----------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-30 00:00:00.000'
-- Purpose      To Get User Daily tracker report
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
--EXEC [dbo].[USP_UserDailyTrackerReport] @Date = '2020-12-17 09:50:10.437'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UserDailyTrackerReport]
(
 @CompanyId UNIQUEIDENTIFIER = NULL,
 @LeadLevelUserId UNIQUEIDENTIFIER = NULL,
 @Date DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
			SET @Date = CONVERT(DATE,@Date) 

			CREATE TABLE #UsersData 
			(
				 UserId UNIQUEIDENTIFIER
				,CompanyId UNIQUEIDENTIFIER
				,UserName NVARCHAR(250)
				,UserEmail NVARCHAR(150)
				,TotalDeskTime NVARCHAR(100)
				,DeskTime BIGINT
				,ProductiveTime NVARCHAR(100)
				,TotalIdleTime NVARCHAR(100)
				,MostUsedApps NVARCHAR(2000)
				,Commits NVARCHAR(MAX)
				,WorkItemsActivity NVARCHAR(MAX)
				,LoggedWorkItems NVARCHAR(MAX)
			)
			
			INSERT INTO #UsersData(UserId,CompanyId,UserName,UserEmail)
			SELECT U.Id,U.CompanyId,U.FirstName + ' '  + ISNULL(U.SurName,''),U.UserName
			FROM [User] U 
			WHERE U.IsActive = 1 AND U.InActiveDateTime IS NULL
				 AND (@LeadLevelUserId IS NULL OR U.Id IN (SELECT ChildId FROM dbo.Ufn_ReportedMembersByUserId(@LeadLevelUserId,(SELECT dbo.Ufn_GetCompanyIdBasedOnUserId(@LeadLevelUserId))) WHERE ChildId <> @LeadLevelUserId))
			AND (@CompanyId IS NULL OR U.CompanyId = @CompanyId)

			UPDATE #UsersData SET ProductiveTime = T.TotalTime
			FROM #UsersData UD
				 INNER JOIN (
					SELECT UM.Id UserId,UM.CompanyId,
					       CONVERT(NVARCHAR,DATEPART(HH, CONVERT(TIME, DATEADD(MS, SUM(UA.Productive), 0)))) + 'h '
						   + CONVERT(NVARCHAR,DATEPART(MI,CONVERT(TIME, DATEADD(MS, SUM(UA.Productive), 0)))) + 'm'  AS TotalTime 
					FROM [User] AS UM WITH (NOLOCK) 
						 INNER JOIN TimeSheet AS TS WITH (NOLOCK) ON UM.Id = TS.UserId 
						            AND (TS.Date = @Date)
						 INNER JOIN UserActivityTimeSummary AS UA WITH (NOLOCK) ON ( UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.Date ) 
					WHERE CONVERT(DATE,UA.CreatedDateTime) = @Date
						  AND UM.IsActive = 1
						  AND UM.InActiveDateTime IS NULL
						  AND (@CompanyId IS NULL OR UM.CompanyId = @CompanyId)
					GROUP BY UM.Id,UM.CompanyId --,TS.[Date],UM.FirstName,UM.SurName,UM.UserName
					) T ON T.UserId = UD.UserId AND T.CompanyId = UD.CompanyId

			--select * from #UsersData

			UPDATE #UsersData SET DeskTime =  (ISNULL(T.DeskTime,0) / 60000) + ISNULL(IdleTime,0)
			                      ,TotalIdleTime = CONVERT(NVARCHAR,(TT.TotalTimeInMin)/60) + 'h ' + CONVERT(NVARCHAR,(TT.TotalTimeInMin)%60) + 'm'
			FROM #UsersData UD
			INNER JOIN 
			(SELECT UM.Id AS UserId,(UA.Productive + UA.UnProductive + UA.Neutral) AS DeskTime,UA.IdleInMinutes AS TotalTimeInMin
			 FROM [User] AS UM WITH (NOLOCK) 
			 	 INNER JOIN TimeSheet AS TS WITH (NOLOCK) ON UM.Id = TS.UserId 
			 	            AND (TS.Date = @Date)
			 	 INNER JOIN UserActivityTimeSummary AS UA WITH (NOLOCK) ON ( UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.Date ) 
			 WHERE CONVERT(DATE,UA.CreatedDateTime) = @Date
			 	  AND UM.IsActive = 1
			 	  AND UM.InActiveDateTime IS NULL
			 --GROUP BY UM.Id,UM.CompanyId,TS.[Date],UM.FirstName,UM.SurName,UM.UserName 
			 ) T ON T.UserId = UD.UserId
			 
			UPDATE #UsersData SET TotalDeskTime = CONVERT(NVARCHAR,(DeskTime)/60) + 'h ' + CONVERT(NVARCHAR,(DeskTime)%60) + 'm'

			UPDATE #UsersData SET Commits = (STUFF((SELECT ' $ ' + CommitMessage
								FROM RepositoryCommits
								WHERE CONVERT(DATE,CreatedDateTime) = @Date AND CommitedByUserId = UD.UserId 
								FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,3,''))
								FROM #UsersData UD

			UPDATE #UsersData SET LoggedWorkItems = (SELECT US.UserStoryUniqueName
													,US.Id AS UserStoryId
													,US.UserStoryName
													,CASE WHEN UST.SpentTimeInMin IS NOT NULL
													      THEN CONVERT(NVARCHAR,(CONVERT(INT,UST.SpentTimeInMin))/60) + 'h ' + CONVERT(NVARCHAR,(CONVERT(INT,UST.SpentTimeInMin))%60) + 'm'
														ELSE CONVERT(NVARCHAR,DATEDIFF(MINUTE,UST.StartTime,UST.EndTime)/60) + 'h ' + CONVERT(NVARCHAR,DATEDIFF(MINUTE,UST.StartTime,UST.EndTime)%60) + 'm'
														END AS SpentTime
								FROM UserStorySpentTime UST
								     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
								WHERE (CONVERT(DATE,UST.DateTo) = @Date OR CONVERT(DATE,UST.EndTime) = @Date)
								AND UST.CreatedByUserId = UD.UserId 
								FOR XML PATH('LoggedUserStories'), ROOT('WorkItemsLog'))
								FROM #UsersData UD

			UPDATE #UsersData SET WorkItemsActivity = (SELECT US.UserStoryUniqueName
													,US.Id AS UserStoryId
													,US.UserStoryName
													,USS.[Status] AS CurrentStatus
													,USS.StatusHexValue AS StatusColor
								FROM UserStoryHistory USH
								     INNER JOIN UserStory US ON US.Id = USH.UserStoryId
									 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								WHERE (CONVERT(DATE,USH.CreatedDateTime) = @Date)
								AND USH.CreatedByUserId = UD.UserId AND USH.FieldName = 'UserStoryStatus'
								GROUP BY US.UserStoryUniqueName,US.Id,US.UserStoryName,USS.[Status],USS.StatusHexValue
								FOR XML PATH('LoggedUserStories'),ROOT('WorkItemsActivity'))
								FROM #UsersData UD
			
			/* Need to change using of UserActivityTime to UserActivityApp Summary*/
			UPDATE #UsersData SET MostUsedApps = (SELECT TOP (5) ApplicationName
			 FROM 
			(SELECT ISNULL(AbsoluteAppName,OtherApplication) ApplicationName,COUNT(1) Counts,UserId 
				FROM UserActivityTime UA
			LEFT JOIN ActivityTrackerApplicationUrl A ON (UA.ApplicationId = A.Id)
			WHERE UserId = UD.UserId AND ISNULL(AbsoluteAppName,OtherApplication) IS NOT NULL
				  AND ISNULL(AbsoluteAppName,OtherApplication) <> ''
				  AND  CONVERT(DATE, UA.CreatedDateTime) = @Date
			GROUP BY ISNULL(AbsoluteAppName,OtherApplication),UserId ) T
			ORDER BY Counts DESC
			FOR XML PATH('ApplicationReportModel'), ROOT('ApplicationReports'))
			FROM #UsersData UD

			SELECT UD.*,FORMAT(TS.InTime,'hh:mm tt') AS StartTime
			,FORMAT(TS.outtime,'hh:mm tt') AS FinishTime
			FROM #UsersData UD
				 LEFT JOIN TimeSheet TS ON TS.UserId = UD.UserId AND TS.[Date] = CONVERT(DATE,@Date)
			WHERE DeskTime <> 0 
				  OR ProductiveTime IS NOT NULL
				  OR TotalIdleTime IS NOT NULL
 
	END TRY
	BEGIN CATCH

	THROW

END CATCH
END