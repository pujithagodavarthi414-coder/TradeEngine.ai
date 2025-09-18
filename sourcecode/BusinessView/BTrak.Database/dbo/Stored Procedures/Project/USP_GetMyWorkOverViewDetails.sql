-----------------------------------------------------------------------------------------------
-- Author       Aswani
-- Created      '2019-06-08 00:00:00.000'
-- Purpose      To get the work for Mywork dashboard
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetMyWorkOverViewDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetMyWorkOverViewDetails]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER =NULL,
  @TeamMemberId  XML =NULL,
  @UserStoryStatusId  UNIQUEIDENTIFIER =NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
         
         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
          DECLARE @Temp TABLE
          (
            ChildId UNIQUEIDENTIFIER,
            ParentId UNIQUEIDENTIFIER
          )
          INSERT INTO @Temp(ChildId)
          SELECT ChildId  FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)
                         
       DECLARE @ProjectManagementWorkCount INT = (SELECT COUNT(1) 
               FROM [UserStory]US 
               INNER JOIN [dbo].[Goal] G  WITH (NOLOCK) ON US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
               INNER JOIN [dbo].[Project] P  WITH (NOLOCK) ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
               LEFT JOIN [ProjectFeature]PF  WITH (NOLOCK) ON   PF.ProjectId =  US.ProjectFeatureId AND PF.InActiveDateTime IS NULL
               INNER JOIN UserStoryStatus USS  WITH (NOLOCK) ON US.UserStoryStatusId = USS.Id AND USS.InActiveDateTime IS NULL
               LEFT JOIN [UserStoryType] UST  WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
               LEFT JOIN  [BugCausedUser] BU  WITH (NOLOCK) ON BU.UserStoryId = US.Id AND BU.InActiveDateTime IS NULL
               LEFT JOIN [BugPriority]BP  WITH (NOLOCK) ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
               LEFT JOIN [dbo].[User] OU  WITH (NOLOCK) ON OU.Id = US.OwnerUserId
               LEFT JOIN [dbo].[User] DU  WITH (NOLOCK) ON OU.Id = US.DependencyUserId
               LEFT JOIN [User] BCU  WITH (NOLOCK) ON BCU.Id = BU.UserId
               LEFT JOIN [dbo].[GoalStatus] GS  WITH (NOLOCK) ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
               INNER JOIN [dbo].[BoardType] BT  WITH (NOLOCK) ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
               LEFT JOIN [User] GRU  WITH (NOLOCK) ON G.GoalResponsibleUserId = GRU.Id
               LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW  WITH (NOLOCK) ON BTW.BoardTypeId = BT.Id AND BTW.InActiveDateTime IS NULL
			   LEFT JOIN (SELECT ChildId 
				          FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) RM
						       INNER JOIN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') AS TeamMember
						              FROM @TeamMemberId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
							) TM ON TM.TeamMember = RM.ChildId) T ON T.ChildId = US.OwnerUserId OR T.ChildId = US.DependencyUserId AND @TeamMemberId IS NOT NULL
        WHERE USS.CompanyId = @CompanyId
			 AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC' OR USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B')
              AND ((@TeamMemberId IS NULL AND (US.OwnerUserId = @OperationsPerformedBy OR US.DependencyUserId = @OperationsPerformedBy))
				    OR (@TeamMemberId IS NOT NULL AND T.ChildId IS NOT NULL)
				  )
			 AND (@UserStoryStatusId IS NULL OR USS.Id = @UserStoryStatusId)
             AND GS.IsActive = 1  
             AND G.InActiveDateTime IS NULL
             AND US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL
             AND US.ParkedDateTime IS NULL 
             AND G.ParkedDateTime IS NULL)

		DECLARE @AdhocWorkCount INT = (SELECT COUNT(1) FROM UserStory US
		             INNER JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
					 LEFT JOIN [dbo].[User] OU  WITH (NOLOCK) ON OU.Id = US.OwnerUserId
					  LEFT JOIN (SELECT ChildId 
				          FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) RM
						       INNER JOIN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') AS TeamMember
						              FROM @TeamMemberId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
							) TM ON TM.TeamMember = RM.ChildId) T ON T.ChildId = US.OwnerUserId OR T.ChildId = US.DependencyUserId AND @TeamMemberId IS NOT NULL
				WHERE ((@TeamMemberId IS NULL AND (US.OwnerUserId = @OperationsPerformedBy OR US.DependencyUserId = @OperationsPerformedBy))
				        OR (@TeamMemberId IS NOT NULL AND T.ChildId IS NOT NULL)
				))

		SELECT @ProjectManagementWorkCount AS ProjectManagementWorkCount,
		       @AdhocWorkCount AS AdhocWorkCount
       END
       ELSE
       BEGIN
       
            RAISERROR (@HavePermission,11, 1)
            
       END
    END TRY  
    BEGIN CATCH 
    
          THROW
        
    END CATCH
END