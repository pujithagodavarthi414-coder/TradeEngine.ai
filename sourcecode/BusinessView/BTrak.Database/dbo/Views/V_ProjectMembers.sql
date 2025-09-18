CREATE VIEW [dbo].[V_ProjectMembers] AS
SELECT UP.Id, UP.ProjectId, P.ProjectName, U.UserName 
FROM UserProject UP
	 INNER JOIN [User] U ON U.Id = UP.UserId
	 INNER JOIN [Project] P ON P.Id = UP.ProjectId
