CREATE VIEW [dbo].[V_SpentTime] AS 
SELECT CPNY.CompanyName, U.FirstName + ' ' + U.SurName UserFullName, USST.SpentTimeInMin, US.Id UserStoryId, US.UserStoryName, USST.CreatedDateTime
FROM [dbo].[UserStorySpentTime] USST
	 INNER JOIN [dbo].[User] U ON USST.[UserId] = U.Id
	 INNER JOIN [dbo].[Company] CPNY ON CPNY.Id = U.CompanyId
	 LEFT OUTER JOIN [dbo].[UserStory] US ON US.Id = USST.[UserStoryId]
