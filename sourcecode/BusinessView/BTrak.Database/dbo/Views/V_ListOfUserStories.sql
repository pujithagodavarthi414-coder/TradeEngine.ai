CREATE VIEW [dbo].[V_UserStories]
	AS SELECT US.[UserStoryName] UserStoryName, 
	   G.[GoalName] GoalName,
	   USS.[Status],
	   GS.GoalStatusName,
	   GS.IsActive,
	   US.UserStoryStatusId UserStoryStatusId,
	   US.ID UserStoryId, 
	   G.Id GoalId
FROM UserStory US 
	 INNER JOIN Goal G On G.Id = US.GoalId
	 INNER JOIN [dbo].[GoalStatus] GS On GS.Id = G.GoalStatusId
	 INNER JOIN [dbo].[UserStoryStatus] USS On USS.Id = US.UserStoryStatusId
