-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-09-16 00:00:00.000'
-- Purpose      To get burn down chart of a goal
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------
--EXEC [USP_GetGoalBurnDownChart] @GoalId = '965764dd-85a7-4178-8178-dd49d2f1654b',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@DateFrom = '2019-10-01'
------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGoalBurnDownChart]
(
 @GoalId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATE = NULL,
 @DateTo DATE = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

		IF(@UserId IS NOT NULL)
		BEGIN
		  DECLARE @UserStoryCount INT
		   SET @UserStoryCount = (SELECT COUNT(1) FROM [dbo].[User] WHERE Id = @UserId)
		   IF(@UserStoryCount = 0)
		   BEGIN
		     SET @UserId = NULL
		   END
		END

		DECLARE @IsFilter BIT = 0

		IF(@DateTo IS NOT NULL)SET @IsFilter = 1
		 
		    IF (@DateFrom IS NULL) SET @DateFrom  = (SELECT CONVERT(DATE,G.OnboardProcessDate) FROM Goal G WHERE G.Id = @GoalId)

            --IF (@DateTo IS NULL) SET  @DateTo  = (CASE WHEN EXISTS(SELECT  COUNT(1)
            --                                                       FROM UserStory US 
		          --                                                 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
												--			        AND US.GoalId = @GoalId
												--					JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] NOT IN (4,6)
												--				    ) THEN GETDATE() 
												--	   ELSE (SELECT Max(USWST.CreatedDateTime)
												--             FROM UserStory US 
												--	         JOIN UserStoryStatus USS ON USS.Id=US.UserStoryStatusId 
												--		      AND US.GoalId= @GoalId
												--			 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] NOT IN (4,6)
												--			 JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id
												--		      GROUP BY US.GoalId) END)
			 IF(@DateTo IS NULL) SET @DateTo = (SELECT MAX(DeadLineDate)
			                                    FROM UserStory US WHERE US.GoalId = @GoalId
												     AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
												GROUP BY GoalId)

			 IF (@DateTo IS NULL) SET  @DateTo  = (SELECT Max(USWST.CreatedDateTime)
												             FROM UserStory US 
													         JOIN UserStoryStatus USS ON USS.Id=US.UserStoryStatusId 
														      AND US.GoalId = @GoalId
															 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId --AND TS.[Order] NOT IN (4,6)
															 JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id
														      GROUP BY US.GoalId)
 
               DECLARE @ArchivedDate DATE = (SELECT InActiveDateTime FROM Goal WHERE Id = @GoalId AND GoalStatusId = 'B25B79E1-82E5-40BC-9D1A-4591E620D895')
               DECLARE @ParkedDate DATE = (SELECT ParkedDateTime FROM Goal WHERE Id = @GoalId AND GoalStatusId = 'B328CFA8-6D63-4F2C-9EF1-3359E8DD35C7')
             
			 IF(@DateTo < CAST(GETDATE() AS date) AND @IsFilter = 0) SET @DateTo = GETDATE()

			 IF(@ArchivedDate IS NOT NULL)SET @DateTo = @ArchivedDate

			 IF(@ParkedDate IS NOT NULL)SET @DateTo = @ParkedDate

			IF(@DateTo IS NULL) SET @DateTo  = GETDATE()

			DECLARE @Days TABLE(
                                [Date] DATE,
							    UserStoryId UNIQUEIDENTIFIER,
								TotalBurn FLOAT
                               )
            INSERT INTO @Days([Date],UserStoryId)
            SELECT T.[Date],U.Id
			FROM
			(SELECT DATEADD(DAY, NUMBER, DATEADD(DAY,-1,@DateFrom)) AS [Date]
            FROM MASTER..SPT_VALUES
            WHERE TYPE='P'
            AND NUMBER<=DATEDIFF(DAY,@DateFrom,DATEADD(DAY,1,@DateTo))) T
			CROSS JOIN (SELECT US.Id
			                   FROM UserStory US 
			                   JOIN  Goal G ON US.GoalId = G.Id AND CONVERT(DATE,US.DeadLineDate) >= CONVERT(DATE,G.OnboardProcessDate)
								 AND US.DeadLineDate IS NOT NULL AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
								 AND US.EstimatedTime IS NOT NULL AND  CONVERT(DATE,US.DeadLineDate) BETWEEN @DateFrom AND @DateTo
								 AND G.IsToBeTracked = 1 AND G.Id = @GoalId) U
            
			UPDATE @Days SET TotalBurn = (SELECT ISNULL(SUM(US.EstimatedTime),0)
			                                     FROM UserStory US 
			                                     JOIN Goal G ON US.GoalId = G.Id AND US.DeadLineDate IS NOT NULL 
												  AND (@UserId IS NULL OR US.OwnerUserId = @UserId) 
												  AND CONVERT(DATE,US.DeadLineDate) >= CONVERT(DATE,G.OnboardProcessDate)   AND  CONVERT(DATE,US.DeadLineDate) BETWEEN @DateFrom AND @DateTo
									              AND US.EstimatedTime IS NOT NULL AND G.IsToBeTracked = 1 AND G.Id = @GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
												   GROUP BY US.GoalId
									     )
		  --SELECT * FROM @Days
			
			SELECT DATEADD(DAY,1,D.[Date]) AS [Date],
			         D.TotalBurn - SUM(ISNULL(US.EstimatedTime,0)) ExpectedBurnDown,
					 D.TotalBurn - ISNULL(SUM(CASE WHEN USS.Id IS NOT NULL THEN US.EstimatedTime END),0) AS ActualBurnDown 
			FROM @Days D LEFT  JOIN UserStory US ON US.Id = D.UserStoryId AND CONVERT(DATE,US.DeadLineDate) <= D.[Date] AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			                      LEFT JOIN (SELECT D.[Date],D.UserStoryId,MAX(USWST.CreatedDateTime) AS MaxCreated 
								         FROM @Days D 
										 INNER JOIN UserStoryWorkflowStatusTransition USWST ON DATEADD(DAY,-1,USWST.CreatedDateTime) <= DATEADD(DAY,1,D.[Date])
										           AND USWST.UserStoryId = D.UserStoryId 
                                            AND  CONVERT(DATE,USWST.CreatedDateTime) BETWEEN @DateFrom AND @DateTo
									   GROUP BY D.UserStoryId,D.[Date]) T ON T.[Date] = D.[Date] AND T.UserStoryId = D.UserStoryId
                                  LEFT JOIN UserStoryWorkflowStatusTransition USWST ON USWST.CreatedDateTime = T.MaxCreated AND USWST.UserStoryId = T.UserStoryId  AND  CONVERT(DATE,USWST.CreatedDateTime) <= @DateTo
                                LEFT JOIN WorkflowEligibleStatusTransition WEST ON USWST.WorkflowEligibleStatusTransitionId = WEST.Id AND WEST.InActiveDateTime IS NULL
                                 LEFT JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.InActiveDateTime IS NULL
									  AND US.UserStoryStatusId = USS.Id AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' AND USS.TaskStatusId <> '166DC7C2-2935-4A97-B630-406D53EB14BC'
            WHERE  DATEADD(DAY,1,D.[Date]) BETWEEN @DateFrom AND @DateTo
			GROUP BY d.[Date],D.TotalBurn
		ORDER BY D.[Date] DESC
								    

	    END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO