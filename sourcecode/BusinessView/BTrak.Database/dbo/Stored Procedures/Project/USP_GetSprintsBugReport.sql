-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To get the bugs for the sprint userstories
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSprintsBugReport] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSprintsBugReport]
(
    
    @SprintId UNIQUEIDENTIFIER = NULL,
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @OwnerUserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
           
            IF(@HavePermission = '1')
            BEGIN
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
               SELECT US.UserStoryName,
                      US.UserStoryUniqueName,
                      ISNULL(US.EstimatedTime,0) EstimatedTime,
                      U.FirstName+' '+U.SurName Assignee,
                      U.ProfileImage,
					  US.OwnerUserId,
					  US.RAGStatus,
                      ISNULL(COUNT(CASE WHEN ((US1.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND UST.Id IS NOT NULL) OR ( US1.Sprintid IS NOT NULL AND UST.Id IS NOT NULL AND S1.Id IS NOT NULL))  THEN 1 END),0)BugsCount 
                      FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                           INNER JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL  AND S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND (S.IsComplete  IS NULL OR S.IsComplete = 0)
                           LEFT JOIN [User] U ON US.OwnerUserId = U.Id 
                           INNER JOIN BoardType BT ON BT.Id = S.BoardTypeId AND (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0)
                           LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
                           LEFT JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug = 1
                           LEFT JOIN Goal G ON G.Id = US1.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
                           LEFT JOIN Sprints S1 on S1.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S1.SprintStartDate IS NOT NULL AND (S1.IsReplan IS NULL OR S1.IsReplan = 0 ) AND (S1.IsComplete  IS NULL OR S1.IsComplete = 0)
                           WHERE (@UserStoryId IS NULL OR US.Id = @UserStoryId)
                                  AND (@SprintId IS NULL OR US.SprintId = @SprintId)
                                  AND (@OwnerUserId IS NULL OR US.OwnerUserId = @OwnerUserId)
                           GROUP BY US.UserStoryName,US.UserStoryUniqueName,US.EstimatedTime,U.FirstName,
                           U.SurName,U.ProfileImage,US.OwnerUserId,US.RAGStatus
						   ORDER BY BugsCount DESC,US.UserStoryUniqueName
                END
      ELSE
      BEGIN
      
           RAISERROR (@HavePermission,10, 1)
      
      END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO
