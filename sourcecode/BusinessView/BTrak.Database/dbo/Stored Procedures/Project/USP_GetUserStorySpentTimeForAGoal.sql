-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To get spent time status of user stories
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------
--EXEC [USP_GetUserStorySpentTimeForAGoal] @GoalId = '21AA6A6A-74A0-4105-8794-4EB6F4610E57'
-----------------------------------------------------------------
CREATE PROCEDURE [USP_GetUserStorySpentTimeForAGoal]
(
 @GoalId UNIQUEIDENTIFIER,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @UserId UNIQUEIDENTIFIER = NULL,
 @DateFrom DATETIME = NULL,
 @DateTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF (@DateFrom IS NULL) SET @DateFrom = (SELECT CONVERT(DATETIME,MIN(US.CreatedDateTime)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)
        IF (@DateTo IS NULL) SET @DateTo = (SELECT CONVERT(DATETIME,MAX(US.DeadLineDate)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)
        IF (@DateTo > GETDATE()) SET @DateTo = GETDATE()
       DECLARE @Days TABLE(
                           [Date] DATETIME
                          )
       INSERT INTO @Days
       SELECT DATEADD(DAY, number, @DateFrom)
              FROM MASTER..spt_values
              WHERE TYPE='p'
              AND number<=DATEDIFF(D,@DateFrom,@DateTo)
            DECLARE @Temp TABLE(
                                [Date] DATETIME,
                                [UserStoryId] UNIQUEIDENTIFIER,
                                [UserStoryName] NVARCHAR(250),
                                [UserStorySpentTime] FLOAT,
                                [UserStoryEstimated] FLOAT,
                                StatusColour NVARCHAR(20),
                                DeveloperName NVARCHAR(250),
                                SummaryValue INT,
                                TotalSpentTimeSoFar FLOAT
                               )
           WHILE (@DateFrom < = DATEADD(DAY,1,@DateTo))
           BEGIN
              
           INSERT INTO @Temp([Date],[UserStoryId],[UserStoryName],[UserStoryEstimated],[UserStorySpentTime],DeveloperName)
           SELECT @DateFrom,
		          US.Id,
				  US.UserStoryName,
				  US.EstimatedTime,
				  ISNULL(S.SpentTime,0),
				  U.FirstName + ' ' + ISNULL(U.SurName,'')
                  FROM UserStory US 
                  JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL
                  JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                  JOIN (SELECT US.Id,MAX(US.CreatedDateTime) AS MaxCreated 
                        FROM UserStory US 
                        JOIN Goal G ON US.GoalId = G.Id 
                         AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
                         AND CONVERT(DATE,US.CreatedDateTime) <= CONVERT(DATE,@DateFrom)
                         AND G.Id = @GoalId
                        GROUP BY US.Id) L ON L.Id = US.Id AND US.CreatedDateTime = L.MaxCreated
                  LEFT JOIN (SELECT US.Id,UST.UserId,SUM(ISNULL(UST.SpentTimeInMin,0))/60.00 AS SpentTime FROM UserStory US 
                        INNER JOIN Goal G ON US.GoalId = G.Id 
                        INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
                        AND UST.UserId = US.OwnerUserId 
						AND G.InActiveDateTime IS NULL
                        AND G.Id = @GoalId
                        AND (@UserId IS NULL 
						 OR UST.UserId = @UserId)
                        AND CONVERT(DATE,UST.CreatedDateTime) = CONVERT(DATE,@DateFrom)
                        GROUP BY US.Id,UST.UserId) S ON S.Id = US.Id
           WHERE G.Id = @GoalId
            AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
            AND CONVERT(DATE,L.MaxCreated) <= CONVERT(DATE,@DateFrom)
                                           
            
            UPDATE @Temp SET StatusColour = (CASE WHEN T.UserStoryEstimated < Rinner.TotalSpentTime THEN '#ff141c' ELSE '#04fe02' END),
                             SummaryValue = (CASE WHEN T.UserStoryEstimated < Rinner.TotalSpentTime THEN 0 ELSE 1 END),
                             TotalSpentTimeSoFar = Rinner.TotalSpentTime 
                         FROM @Temp T
                         JOIN (SELECT US.Id,SUM(ISNULL(UST.SpentTimeInMin,0))/60.00 AS TotalSpentTime FROM UserStory US 
                                                                                                              JOIN Goal G ON US.GoalId = G.Id 
                                                                                                              LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
                                                                                                               AND UST.UserId = US.OwnerUserId 
                                                                                                               AND G.InActiveDateTime IS NULL 
                                                                                                               AND G.Id = @GoalId
                                                                                                               AND (@UserId IS NULL OR UST.UserId = @UserId)
                                                                                                               AND CONVERT(DATE,UST.CreatedDateTime) <= CONVERT(DATE,@DateFrom)
                                                                                                               GROUP BY US.Id) Rinner ON Rinner.Id = T.UserStoryId 
                                                                                                               WHERE T.StatusColour IS NULL 
                                                                                                                 AND T.UserStorySpentTime IS NOT NULL
                                                                                                                 AND T.[Date] = @DateFrom 
            SET @DateFrom = DATEADD(DAY,1,@DateFrom)
            END

            --SELECT D.[Date],T.[UserStoryId],T.UserStoryName,T.UserStorySpentTime,T.UserStoryEstimated,T.StatusColour,T.DeveloperName,T.TotalSpentTimeSoFar,T.SummaryValue FROM @Days D LEFT JOIN @Temp T ON D.[Date] = T.[Date] ORDER BY D.[Date]

			DECLARE @UserStoryList TABLE(
                                         UserStoryId UNIQUEIDENTIFIER,
                                         UserStoryName NVARCHAR(200),
										 UniqueName NVARCHAR(50)
                                        )
            INSERT INTO @UserStoryList 
            SELECT US.Id,
			       US.UserStoryName,
				   US.UserStoryUniqueName 
				   FROM UserStory US WHERE US.GoalId = @GoalId 
			        AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL
			        AND (@UserId IS NULL OR OwnerUserId = @UserId)

		     SELECT T.[Date],
		          T.UserStoryId,
				  T.UserStoryName,
				  T.UniqueName,
				  ISNULL(T.UserStoryEstimated,0) AS UserStoryEstimateTime,
				  ISNULL(T.UserStorySpentTime,0) AS UserStorySpentTime,
				  ISNULL(T.StatusColour,'#b7b7b7') AS StatusColour,
				  T.DeveloperName,
				  ISNULL(T.SummaryValue,2) AS SummaryValue,
				  ISNULL(T.TotalSpentTimeSoFar,0) AS TotalSpentTimeSoFar
		          FROM (SELECT DUSL.[Date],DUSL.[UserStoryId],DUSL.UserStoryName,DUSL.UniqueName,S.UserStoryEstimated,S.UserStorySpentTime,S.StatusColour,S.DeveloperName,S.SummaryValue,S.TotalSpentTimeSoFar
                  FROM ((SELECT * FROM @Days 
				                  CROSS JOIN @UserStoryList) DUSL 
                                  LEFT JOIN  @Temp S ON S.[Date] = DUSL.[Date] AND S.UserStoryId = DUSL.UserStoryId))T
           ORDER BY T.[Date]                    
     
	 END TRY
     BEGIN CATCH

        THROW

    END CATCH
END