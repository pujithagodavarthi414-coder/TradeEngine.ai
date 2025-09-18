-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-02 00:00:00.000'
-- Purpose      To Get Goal Counts Based On Statuses
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGoalCountsBasedOnStatuses] @OperationsPerformedBy='4A6D4334-6E5E-4A4F-81F1-C9C7F8F8A84F',
--@ProjectId = '2ECFE12A-0DF8-4555-8149-843FC8E21B6E'
--SELECT*FROM  Goal SET ArchivedDateTime = NULL
CREATE PROCEDURE [dbo].[USP_GetGoalCountsBasedOnStatuses]
(
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
       DECLARE @HavePermission NVARCHAR(250) =  (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
       
       IF (@HavePermission = '1')
       BEGIN
         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 DECLARE @EnableBugs BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

          DECLARE @ProjectMemberCount INT = (SELECT COUNT(DISTINCT UserId) FROM UserProject UP INNER JOIN Project P ON P.Id = UP.ProjectId AND UP.InActiveDateTime IS NULL
                                                                                      JOIN [USER] U ON U.Id = UP.UserId
                                                WHERE ProjectId = @ProjectId AND P.CompanyId = @CompanyId AND UP.InActiveDateTime IS NULL AND U.IsActive = 1)
                
        DECLARE @ProjectFeatureCount INT = (SELECT COUNT(1) FROM ProjectFeature PF 
                                              INNER JOIN Project P ON P.Id = PF.ProjectId AND P.InActiveDateTime IS NULL AND PF.InActiveDateTime IS NULL
                                             WHERE ProjectId = @ProjectId AND P.CompanyId = @CompanyId 
                                             AND (PF.IsDelete IS NULL OR PF.IsDelete = 0) AND PF.InActiveDateTime IS NULL) 
        DECLARE @ActiveSprintsCount INT = (SELECT COUNT( S.Id) AS ActiveSprintsCount 
                                          FROM Sprints S
										  INNER JOIN [BoardType]BT ON BT.Id = S.BoardTypeId
                                          WHERE S.ProjectId = @ProjectId 
                                                AND S.ProjectId IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL
                                                                     AND UP.UserId = @OperationsPerformedBy)
                                                AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL 
												AND (@EnableBugs = 1 OR (@EnableBugs = 0 AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
												AND S.SprintEndDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0))

	   DECLARE @ReplanSprintsCount INT = (SELECT COUNT( S.Id) AS ReplanSprintsCount 
                                          FROM Sprints S
										  INNER JOIN [BoardType]BT ON BT.Id = S.BoardTypeId
                                          WHERE S.ProjectId = @ProjectId 
                                                AND S.ProjectId IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL
                                                                     AND UP.UserId = @OperationsPerformedBy)
																	 AND (@EnableBugs = 1 OR (@EnableBugs = 0 AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                                                AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND S.SprintEndDate IS NOT NULL AND S.IsReplan = 1 AND (S.IsComplete IS NULL OR S.IsComplete = 0)) 
	  DECLARE @TemplatesCount INT = (SELECT COUNT(T.Id) AS TemplatesCount
	                                 FROM Templates T
									 INNER JOIN [BoardType]BT ON BT.Id = t.BoardTypeId
									 WHERE T.ProjectId = @ProjectId
									 AND T.ProjectId IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL
                                                                     AND UP.UserId = @OperationsPerformedBy)
												AND T.InActiveDateTime IS NULL)

	 DECLARE @CompletedSprintsCount INT = (SELECT COUNT( S.Id) AS CompletedSprintsCount 
                                          FROM Sprints S
										  INNER JOIN [BoardType]BT ON BT.Id = S.BoardTypeId
                                          WHERE S.ProjectId = @ProjectId 
                                                AND S.ProjectId IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL
                                                                     AND UP.UserId = @OperationsPerformedBy)
																	 AND (@EnableBugs = 1 OR (@EnableBugs = 0 AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))

                                                AND S.IsComplete = 1) 
               SELECT COUNT((CASE WHEN GS.IsActive = 1 THEN 1 END)) AS ActiveGoalsCount,
                         COUNT((CASE WHEN GS.IsBackLog = 1 THEN 1 END)) AS BackLogGoalsCount,
                         COUNT((CASE WHEN GS.IsReplan = 1 THEN 1 END)) AS UnderReplanGoalsCount,
                        COUNT((CASE WHEN G.InActiveDateTime IS NOT NULL THEN 1 END)) AS ArchivedGoalsCount,
                         COUNT((CASE WHEN G.ParkedDateTime IS NOT NULL THEN 1 END)) AS ParkedGoalsCount
                        ,@ProjectFeatureCount AS ProjectFeatureCount
                        ,@ProjectMemberCount AS ProjectMemberCount
						,@ActiveSprintsCount AS ActiveSprintsCount
						,@ReplanSprintsCount AS ReplanSprintsCount
						,@CompletedSprintsCount AS CompletedSprintsCount
						,@TemplatesCount AS TemplatesCount
                         FROM Goal G
                              INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
							  INNER JOIN [BoardType]BT ON BT.Id = G.BoardTypeId
                              INNER JOIN Project P ON P.Id = @ProjectId AND P.CompanyId = @CompanyId AND P.Id IN (SELECT ProjectId FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL GROUP BY ProjectId)
                         WHERE G.ProjectId = @ProjectId  AND (@EnableBugs = 1 OR (@EnableBugs = 0 AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
       END
       ELSE
           RAISERROR (@HavePermission,11, 1)
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END