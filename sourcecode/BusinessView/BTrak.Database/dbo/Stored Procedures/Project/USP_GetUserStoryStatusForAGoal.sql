------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga 
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To get heat map of user stories in a goal
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [USP_GetUserStoryStatusForAGoal] @GoalId = '8115ee0c-bcd1-4d1e-b8ef-c8054b5f2b87'
-------------------------------------------------------------------------------
CREATE PROCEDURE [USP_GetUserStoryStatusForAGoal]
(
 @GoalId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @OperatinsPerformedBy UNIQUEIDENTIFIER = NULL,
 @DateFrom DATETIME = NULL,
 @DateTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperatinsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN
        
		IF (@DateFrom IS NULL) SET @DateFrom = (SELECT CONVERT(DATETIME,MIN(US.CreatedDateTime)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)

        IF (@DateTo IS NULL) SET @DateTo = (CASE WHEN (SELECT InactiveDateTime FROM Goal WHERE Id = @GoalId ) IS NOT NULL THEN
		                                                (SELECT CONVERT(DATETIME,MAX(US.DeadLineDate)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)
												ELSE GETDATE() END)


            DECLARE @Temp Table(
                                [Date] DATETIME,
                                [UserStoryId] UNIQUEIDENTIFIER,
                                [UserStoryName] NVARCHAR(250),
                                [UserStoryStatusId] UNIQUEIDENTIFIER,
                                [UserStoryStatus] NVARCHAR(250),
                                [StatusColour] NVARCHAR(30),
                                [DeveloperName] NVARCHAR(250),
                                [SummaryValue] INT
                               )
            
              DECLARE @Days TABLE(
                           [Date] DATETIME
                          )

              INSERT INTO @Days
              SELECT DATEADD(DAY, NUMBER, @DateFrom)
              FROM MASTER..SPT_VALUES
              WHERE TYPE='P'
              AND NUMBER<=DATEDIFF(DAY,@DateFrom,@DateTo)

           WHILE (CONVERT(DATE,@DateFrom) < = CONVERT(DATE,@DateTo))
           BEGIN
 
           INSERT INTO @Temp([Date],UserStoryId,UserStoryName,UserStoryStatusId,UserStoryStatus,StatusColour,DeveloperName)
           SELECT @DateFrom,
                  US.Id,
                  US.UserStoryName,
                  USS.Id,USS.[Status],
                  USS.StatusHexValue,
                  U.FirstName + ' ' + ISNULL(U.SurName,'')
                  FROM UserStory US 
                  JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
                  JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
                  JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                  JOIN (SELECT US.Id,MAX(US.CreatedDateTime) AS MaxCreated 
                               FROM UserStory US 
                               JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
                                               AND CONVERT(DATE,US.CreatedDateTime) <= CONVERT(DATE,@DateFrom)
                                               AND G.Id = @GoalId
                  GROUP BY US.Id) S ON S.Id = US.Id AND US.CreatedDateTime = S.MaxCreated
                  WHERE G.Id = @GoalId
                   AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
                   AND CONVERT(DATE,S.MaxCreated) <= CONVERT(DATE,@DateFrom)
                                                                                                    
           SET @DateFrom = DATEADD(D,1,@DateFrom)
           END
           UPDATE @Temp SET SummaryValue = CASE WHEN UserStoryStatus = 'Not Started' THEN 0
                                                WHEN UserStoryStatus = 'Analysis Completed' THEN 1
                                                WHEN UserStoryStatus = 'Dev Inprogress' THEN 2
                                                WHEN UserStoryStatus = 'Dev Completed' THEN 3
                                                WHEN UserStoryStatus = 'Deployed' THEN 4
                                                WHEN UserStoryStatus = 'QA Approved' THEN 5
                                                WHEN UserStoryStatus = 'Signed Off' THEN 6
                                                WHEN UserStoryStatus = 'New' THEN 1
                                                WHEN UserStoryStatus = 'Inprogress' THEN 2
                                                WHEN UserStoryStatus = 'Resolved' THEN 3
                                                WHEN UserStoryStatus = 'Completed' THEN 3
                                                WHEN UserStoryStatus = 'Verified' THEN 5
                                                WHEN UserStoryStatus = 'Blocked' THEN 8
                                            END
         
            DECLARE @UserStoryList TABLE(
                                         UserStoryId UNIQUEIDENTIFIER,
                                         UserStoryName NVARCHAR(200),
										 UniqueName NVARCHAR(50)
                                        )
            INSERT INTO @UserStoryList 
            SELECT US.Id,US.UserStoryName,US.UserStoryUniqueName FROM UserStory US WHERE US.GoalId = @GoalId 
			                                                          AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL
																	  AND (@UserId IS NULL OR OwnerUserId = @UserId)
           
		   SELECT T.[Date],
		          T.UserStoryId,
				  T.UserStoryName,
				  T.UniqueName,
				  T.UserStoryStatusId,
				  T.UserStoryStatus,
				  ISNULL(T.StatusColour,'#b7b7b7') AS StatusColour,
				  T.DeveloperName,
				  ISNULL(T.SummaryValue,0) AS SummaryValue
		          FROM (SELECT DUSL.[Date],DUSL.[UserStoryId],DUSL.UserStoryName,DUSL.UniqueName,S.UserStoryStatus,S.UserStoryStatusId,S.StatusColour,S.DeveloperName,S.SummaryValue
                  FROM ((SELECT * FROM @Days 
				                  CROSS JOIN @UserStoryList) DUSL 
                                  LEFT JOIN  @Temp S ON S.[Date] = DUSL.[Date] AND S.UserStoryId = DUSL.UserStoryId))T
           ORDER BY T.[Date]                    
          
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
