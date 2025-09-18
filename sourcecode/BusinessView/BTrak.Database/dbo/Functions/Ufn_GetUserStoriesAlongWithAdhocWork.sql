--SELECT * FROM [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork]('4AFEB444-E826-4F95-AC41-2175E36A0C16','0B2921A9-E930-4013-9047-670B5352F308','16B0E1D2-311F-4356-9FA7-DA2AE36059E3','0EDE6685-0C68-48A2-9FCE-855679E45B03')
CREATE FUNCTION [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork]
(
    @CompanyId UNIQUEIDENTIFIER
    ,@OperationsPerformedBy UNIQUEIDENTIFIER
    ,@EntityId UNIQUEIDENTIFIER = NULL
    ,@AdhocGoalId UNIQUEIDENTIFIER
	,@ProjectId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS RETURN
   
    SELECT US.UserStoryName,
         P.ProjectName As ProjectName,
         G.GoalName,
		 S.SprintName,
		 US.GoalId,
		 S.SprintStartDate,
		 S.SprintEndDate,
		 US.SprintId,
         DU.Id AS DependencyUserId,
         DU.FirstName + ' ' + ISNULL(DU.SurName,'') AS DependencyName,
         OU.Id AS OwnerUserId,
         OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OwnerName,
		 OU.ProfileImage,
         ISNULL(US.EstimatedTime,0) EstimatedTime,
		 TZ.TimeZoneAbbreviation,
		 TZ.TimeZoneName,
		 TZ1.TimeZoneAbbreviation SprintTimeZoneAbbreviation,
		 TZ1.TimeZoneName SprintTimeZoneName,
         US.[DeadLineDate] 
    FROM [dbo].[UserStory] US 
	     INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
         LEFT JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId AND G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL
         LEFT JOIN [dbo].[Sprints]S WITH (NOLOCK) ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0)  AND S.SprintStartDate IS NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
         AND P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy) 
                    AND P.InactiveDateTime IS NULL
         INNER JOIN [dbo].[User] OU WITH (NOLOCK) ON OU.Id = US.OwnerUserId
		 INNER JOIN [Employee] E ON E.UserId = OU.Id
         INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
         LEFT JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
         LEFT JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
         LEFT JOIN [TaskStatus] TS WITH (NOLOCK) ON TS.Id = USS.TaskStatusId
         LEFT JOIN [dbo].[User] DU WITH (NOLOCK) ON DU.Id = US.DependencyUserId
		 LEFT JOIN TimeZone TZ ON TZ.Id = US.DeadLineDateTimeZone AND TZ.InactiveDateTime IS NULL
		 LEFT JOIN TimeZone TZ1 ON TZ1.Id = S.SprintEndDateTimeZoneId AND TZ1.InactiveDateTime IS NULL
    WHERE P.CompanyId = @CompanyId
          AND P.InactiveDateTime IS NULL
          AND TS.TaskStatusName IN (N'ToDo',N'Inprogress')
          AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND US.SprintId IS NOT NULL))
          AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL AND P.InActiveDateTime IS NULL AND (US.IsBacklog = 0 OR US.IsBacklog IS NULL)
		  AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
    
    UNION
        
    SELECT USAdhoc.UserStoryName,
            'Adhoc Work' As ProjectName,
            'Adhoc Work' AS GoalName,
			NULL AS SprintName,
			USAdhoc.GoalId AS GoalId,
			NULL AS SprintStartDate,
			NULL AS SprintEndDate,
			NULL AS SprintId,
            NULL AS DependencyUserId,
            NULL AS DependencyName,
            OUA.Id AS OwnerUserId,
            OUA.FirstName + ' '+ ISNULL(OUA.SurName,'') AS OwnerName,
			OUA.ProfileImage,
            ISNULL(USAdhoc.EstimatedTime,0) EstimatedTime,
	        TZ.TimeZoneAbbreviation,
		    TZ.TimeZoneName,
		    NULL SprintTimeZoneAbbreviation,
		    NULL  SprintTimeZoneName,
            USAdhoc.DeadLineDate
    FROM UserStory USAdhoc 
         INNER JOIN [dbo].[User] OUA WITH (NOLOCK) ON OUA.Id = USAdhoc.OwnerUserId 
                     AND OUA.InActiveDateTime IS NULL 
		 INNER JOIN [Employee] E ON E.UserId = OUA.Id 
         INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
         LEFT JOIN [UserStoryStatus] USSAdhoc WITH (NOLOCK) ON USSAdhoc.Id = USAdhoc.UserStoryStatusId
		 LEFT JOIN TimeZone TZ ON TZ.Id = USAdhoc.DeadLineDateTimeZone
    WHERE USSAdhoc.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' --Todo Status
         AND USAdhoc.ArchivedDateTime IS NULL AND USAdhoc.ParkedDateTime IS NULL
         AND USAdhoc.InactiveDateTime IS NULL AND GoalId = @AdhocGoalId
GO