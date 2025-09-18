/****** Object:  UserDefinedFunction [dbo].[USP_GetLiveDashboardBasedOnProject]    Script Date: 23-08-2018 19:23:27 ******/
CREATE PROCEDURE [dbo].[USP_GetLiveDashboardBasedOnProject]
(
@UserId uniqueidentifier,
@ProjectId uniqueidentifier,
  @DashboardId int
)

AS

SET NOCOUNT ON

SELECT PD.Id,
  [GoalId],
  CASE WHEN (GoalShortName IS NULL OR GoalShortName = '') THEN GoalName ELSE GoalShortName END GoalName,
  GoalResponsibleUserId,
  U.FirstName + ' '+ U.SurName GoalResponsibleUserName,
  [MileStone],
  [Delay],
  [DashboardId],
  [GeneratedDateTime],
  PD.GoalStatusColor,
  PD.CreatedByUserId
FROM [ProcessDashboard] PD WITH (NOLOCK) JOIN Goal G ON G.Id = PD.GoalId
                          JOIN [User] U WITH (NOLOCK) ON U.Id = G.GoalResponsibleUserId
WHERE [DashboardId] = @DashboardId 
and G.ProjectId = @ProjectId 
and G.GoalResponsibleUserId = @UserId