-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-25 00:00:00.000'
-- Purpose      To Insert the ProcessDashBoard 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SnapshotProcessDashboard]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProcessDashboardModel=NULL
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SnapshotProcessDashboard]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @ProcessDashboardModel XML
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 
     DECLARE @MaxDashboardId INT = 0
     SELECT @MaxDashboardId = ISNULL(Max(DashboardId),0) FROM ProcessDashboard

     IF(@ProcessDashboardModel IS NULL)
     BEGIN
	  
	      DECLARE @NewIdForDashboard UNIQUEIDENTIFIER = NEWID()
	  
         INSERT INTO [dbo].[ProcessDashboard](
                        [Id],
                        [GoalId],
                        [Milestone],
                        [Delay],
                        [DashboardId],
                        [GeneratedDateTime],
                        [GoalStatusColor],
                        [CreatedByUserId])
                  SELECT NEWID(),
                        DeadLineInner.GoalId,
                        DeadLineInner.MileStoneVal,
                        DATEDIFF(DAY,MaxActualDeadLineVal,DeadLineInner.MileStoneVal),
                        @MaxDashboardId + 1,
                        GETUTCDATE(),
                        G.GoalStatusColor,
                        @OperationsPerformedBy
                        FROM Goal G 
						JOIN Project P ON G.ProjectId = P.Id
                        JOIN [User] U ON U.Id = G.GoalResponsibleUserId
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
                        LEFT JOIN (SELECT G1.Id GoalId, MAX(DeadLineDate) MileStoneVal, MAX([ActualDeadLineDate]) MaxActualDeadLineVal
                        FROM Goal G1 WITH (NOLOCK) LEFT JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G1.Id AND US.InActiveDateTime IS NULL
                        GROUP BY G1.Id) AS DeadLineInner ON DeadLineInner.GoalId = G.Id
            WHERE CONVERT(DATE,GETUTCDATE()) >= CONVERT(DATE,OnboardProcessDate)
			AND G.InActiveDateTime IS NULL 
			AND P.InActiveDateTime IS NULL
            AND (IsToBeTracked = 1)
            AND (G.ParkedDateTime IS NULL)
            AND (U.CompanyId = @CompanyId)

			SELECT ISNULL(Max(DashboardId),0) AS DashboardId FROM ProcessDashboard

     END
     ELSE
     BEGIN

          INSERT INTO [dbo].[ProcessDashboard](
                                               [Id],
                                               [GoalId],
                                               [Milestone],
                                               [Delay],
                                               [DashboardId],
                                               [GeneratedDateTime],
                                               [GoalStatusColor],
                                               [CreatedByUserId]
						                      )
                                        SELECT NEWID(),
                                               [TABLE].RECORD.value('(GoalId)[1]', 'uniqueidentifier'),
                                               [TABLE].RECORD.value('(MileStone)[1]', 'nvarchar(100)'),
                                               [TABLE].RECORD.value('(Delay)[1]', 'nvarchar(100)'),
                                               @MaxDashboardId + 1,
                                               GETUTCDATE(),
				   	                    	   [TABLE].RECORD.value('(GoalStatusColor)[1]', 'nvarchar(100)'),
                                               @OperationsPerformedBy
                                          FROM @ProcessDashboardModel.nodes('ArrayOfProcessDashboardUpsertInputModel/ProcessDashboardUpsertInputModel') AS [TABLE](RECORD)

                       SELECT Max(DashboardId) FROM ProcessDashboard

     END
   END TRY
    
   BEGIN CATCH

      THROW

   END CATCH
END
GO