--SELECT * FROM [dbo].[UserStoryReportWithCounts]('1AA0CF26-4147-4874-BC62-6EB82B2FC674','C834139F-D4CA-4993-99A4-59D8D53952FE','4AFEB444-E826-4F95-AC41-2175E36A0C16',NULL)
CREATE FUNCTION [dbo].[userStoryReportWithCounts]
(
 @ProjectId UNIQUEIDENTIFIER
 ,@GoalId UNIQUEIDENTIFIER
 ,@CompanyId UNIQUEIDENTIFIER
 ,@UserId UNIQUEIDENTIFIER
)
RETURNS TABLE 
AS RETURN
SELECT P.ProjectName
,G.GoalName
,G.GoalShortName
,US.UserStoryName
,BP.PriorityName
,U.Firstname + ' ' + ISNULL(U.SurName,'') AS Assigned
,GS.GoalStatusName
,UST.UserStoryTypeName
,T.TagName
,UserCounts.Counts AS [Counts Based on UserStory type] -- based on goal,user,userstory type
,BPInner.P0Count
,BPInner.P1Count
,BPInner.P2Count
,BPInner.P3Count
,BPInner.BugCount
,USInner.UserStoryCount AS TotaluserStoryCount
,USInner.UnAssigned AS ToatalUnAssignedUserStories
,USTag.Counts AS [US Count Based On Tag]
FROM Project P
INNER JOIN Goal G ON G.ProjectId = P.Id
           AND P.InActiveDateTime IS NULL
		   AND G.InActiveDateTime IS NULL
INNER JOIN UserStory US ON US.GoalId = G.Id
           AND US.InActiveDateTime IS NULL
LEFT JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
LEFT JOIN [User] U ON U.Id = US.OwneruserId
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
LEFT JOIN (
           SELECT UST.Id AS TagName,US.Id AS UserStoryId
           FROM Project P
                INNER JOIN Goal G ON G.ProjectId = P.Id
                INNER JOIN UserStory US ON US.GoalId = G.Id
                CROSS APPLY [dbo].[UfnSplit](US.Tag) UST
           WHERE CompanyId = @CompanyId
           AND US.Tag IS NOT NULL
           GROUP BY UST.Id,US.Id
) T ON  T.UserStoryId = US.Id
LEFT JOIN (SELECT US1.OwnerUserId,GoalId,COUNT(US1.UserStoryTypeId) AS Counts,US1.UserStoryTypeId
           FROM UserStory US1
                LEFT JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId
           WHERE US1.InActiveDateTime IS NULL
           GROUP BY GoalId,US1.OwnerUserId,US1.UserStoryTypeId) UserCounts ON UserCounts.OwnerUserId = US.OwnerUserId
  AND UserCounts.UserStoryTypeId = UST.Id
  AND UserCounts.GoalId = G.Id
LEFT JOIN (
	SELECT US2.OwnerUserId,GoalId
      ,COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 ELSE NULL END) AS P0Count
      ,COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 ELSE NULL END) AS P1Count
      ,COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 ELSE NULL END) AS P2Count
      ,COUNT(CASE WHEN BP.IsLow = 1 THEN 1 ELSE NULL END) AS P3Count
	  ,COUNT(1) BugCount
	  ,US2.UserStoryTypeId
  FROM UserStory US2
LEFT JOIN UserStoryType UST ON UST.Id = US2.UserStoryTypeId
LEFT JOIN BugPriority BP ON BP.Id = US2.BugPriorityId
  WHERE US2.InActiveDateTime IS NULL
        AND IsBug = 1
  GROUP BY GoalId,US2.OwnerUserId,US2.UserStoryTypeId
) BPInner ON BpInner.OwnerUserId = US.OwnerUserId
LEFT JOIN (
	SELECT COUNT(1) UserStoryCount,US3.GoalId 
	       ,COUNT(CASE WHEN US3.OwnerUserId IS NULL THEN 1 ELSE NULL END) UnAssigned
    FROM UserStory US3
    WHERE US3.InActiveDateTime IS NULL
    GROUP BY GoalId
) USInner On USInner.GoalId = G.Id
LEFT JOIN (
	SELECT  TagName,COUNT(1) AS Counts
FROM (
SELECT UST.Id AS TagName,US.Id AS UserStoryId
           FROM Project P
                INNER JOIN Goal G ON G.ProjectId = P.Id
                INNER JOIN UserStory US ON US.GoalId = G.Id
                CROSS APPLY [dbo].[UfnSplit](US.Tag) UST
           WHERE CompanyId = @CompanyId
           AND US.Tag IS NOT NULL
           GROUP BY UST.Id,US.Id
) T
GROUP BY TagName
) USTag ON USTag.TagName = T.TagName
WHERE P.CompanyId = @CompanyId
AND P.Id = @ProjectId
AND (@GoalId IS NULL OR @GoalId = G.Id)
AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
