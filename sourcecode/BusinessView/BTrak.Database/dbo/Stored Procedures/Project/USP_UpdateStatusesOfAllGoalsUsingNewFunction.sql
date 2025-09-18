CREATE PROCEDURE [dbo].[USP_UpdateStatusesOfAllGoalsUsingNewFunction]
AS
BEGIN

       DECLARE @GoalSummary TABLE
        (
		  NewGoalId UNIQUEIDENTIFIER,
		  GoalId UNIQUEIDENTIFIER,
          NewStatusColor VARCHAR(50)
        )

        INSERT INTO @GoalSummary
               SELECT NEWID()
			         ,G.Id
                     ,[dbo].[Ufn_GetGoalStatus](G.Id)
               FROM Goal G
			   INNER JOIN [dbo].[Project] P ON G.ProjectId = P.Id 
			   INNER JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId 
               WHERE  (G.InActiveDateTime IS NULL)
		              AND (IsToBeTracked = 1)
	                  AND (G.ParkedDateTime IS NULL) 
					  AND G.OnboardProcessDate <= CONVERT(DATE,GETUTCDATE())

           DECLARE @GoalId UNIQUEIDENTIFIER

		   DECLARE @GoalIdsCount INT =  (SELECT COUNT (1) FROM @GoalSummary)

		   IF(@GoalIdsCount > 0)
		   BEGIN

			  UPDATE Goal SET GoalStatusColor = GS.NewStatusColor
			  FROM @GoalSummary GS 
			  JOIN Goal G ON G.Id = GS.GoalId 

		   END
    END
