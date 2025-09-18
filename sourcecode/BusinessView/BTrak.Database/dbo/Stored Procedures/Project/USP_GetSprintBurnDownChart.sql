-----------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2020-04-14 00:00:00.000'
-- Purpose      To get sprint burn down chart
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSprintBurnDownChart] @SprintId = '0ACE8B4F-95CF-4888-9D11-92CF80E87AB9',@OperationsPerformedBy = '54CDE140-09FD-4035-AED6-534426DEB30F'
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSprintBurnDownChart]
(
 @SprintId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATE = NULL,
 @DateTo DATE = NULL,
 @UserStoryPoints BIT = NULL,
 @IsApplyFilters BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
        DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@IsApplyFilters IS NULL) SET @IsApplyFilters = 0

		IF(@UserId IS NOT NULL)
		BEGIN
		  DECLARE @UserStoryCount INT
		   SET @UserStoryCount = (SELECT COUNT(1) FROM [dbo].[User] WHERE Id = @UserId)
		   IF(@UserStoryCount = 0)
		   BEGIN
		     SET @UserId = NULL
		   END
		END

        IF (@HavePermission = '1')
        BEGIN
            
            CREATE TABLE #SprintBurnDown(
                                         Id INT IDENTITY(1,1),
                                         [Date] DATE,
                                         [Expected] FLOAT,
                                         [Actual] FLOAT
                                        )
            IF(@UserStoryPoints IS NULL) SET @UserStoryPoints = 0
        
            IF (@DateFrom IS NULL) SET @DateFrom  = (SELECT CONVERT(DATE,S.SprintStartDate) FROM Sprints S WHERE S.Id = @SprintId)
            IF (@DateTo IS NULL) SET  @DateTo  = (CASE WHEN EXISTS(SELECT  COUNT(1)
                                                                   FROM UserStory US
                                                                   JOIN UserStoryStatus USS ON USS.Id=US.UserStoryStatusId
                                                                   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
                                                                    AND US.SprintId = @SprintId
                                                                   -- AND USS.IsCompleted IS NULL AND USS.IsVerified IS NULL
                                                                    --AND USS.IsSignedOff IS NULL AND USS.IsQAApproved IS NULL
                                                                    AND TS.[Order] < 6
                                                                    ) THEN GETDATE()
                                                       ELSE (SELECT MAX(USWST.CreatedDateTime)
                                                             FROM UserStory US
                                                             JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InactiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                                             JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id
                                                             JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
                                                             JOIN WorkflowEligibleStatusTransition WEST ON USWST.WorkflowEligibleStatusTransitionId = WEST.Id AND WEST.InActiveDateTime IS NULL AND WEST.ToWorkFlowUserStoryStatusId = USS.Id
                                                              AND US.SprintId = @SprintId
                                                              AND TS.[Order] = 6
                                                              GROUP BY US.SprintId) END)
            
            IF (@IsApplyFilters = 0 AND @DateTo < GETDATE()) SET @DateTo = GETDATE()
            
			 DECLARE @ArchivedDate DATE = (SELECT InActiveDateTime FROM Sprints WHERE Id = @SprintId)
            
			 IF(@ArchivedDate IS NOT NULL)SET @DateTo = @ArchivedDate

            DECLARE @Days TABLE(
                                [Date] DATE,
                                UserStoryId UNIQUEIDENTIFIER,
                                TotalBurn FLOAT
                               )
            INSERT INTO @Days([Date],UserStoryId)
            SELECT T.[Date],U.Id
            FROM
            (SELECT DATEADD(DAY, NUMBER, @DateFrom) AS [Date]
            FROM MASTER..SPT_VALUES
            WHERE TYPE='P'
            AND NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo)) T
            CROSS JOIN (SELECT US.Id
                               FROM UserStory US
                               JOIN  Sprints S ON US.SprintId = S.Id
                                 AND S.SprintEndDate IS NOT NULL AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
                                 AND ((@UserStoryPoints = 0 AND US.EstimatedTime IS NOT NULL) OR (@UserStoryPoints = 1 AND US.SprinteStimatedTime IS NOT NULL))
                                 AND S.Id = @SprintId) U
            UPDATE @Days SET TotalBurn = (SELECT SUM(IIF(@UserStoryPoints = 0,US.EstimatedTime,US.SprintEstimatedTime))
                                                 FROM UserStory US
                                                 JOIN Sprints S ON US.SprintId = S.Id AND S.SprintEndDate IS NOT NULL
                                                  AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
                                                  AND ((@UserStoryPoints = 0 AND US.EstimatedTime IS NOT NULL) OR (@UserStoryPoints = 1 AND US.SprinteStimatedTime IS NOT NULL)) AND  S.Id = @SprintId
                                                  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                                   GROUP BY US.SprintId
                                         )

			--DECLARE @WeekDaysCount INT = ISNULL((SELECT COUNT(1) FROM WeekDays WHERE CompanyId = @CompanyId),0)

           INSERT INTO #SprintBurnDown([Date],Expected,Actual)
           SELECT D.[Date] AS [Date]
                 ,IIF(Ex.Cnt IS NOT NULL
				     ,D.TotalBurn - (Ex.Cnt * D.TotalBurn /(CASE WHEN ISNULL(1.0 * Ex.TotalCount,0)= 0 THEN 1 ELSE 1.0 * Ex.TotalCount END))
					 ,NULL) 
				 
				 AS Expected
                 --,IIF(Ex.Cnt IS NOT NULL,D.TotalBurn * (1 - (Ex.Cnt/(CASE WHEN ISNULL(1.0 * Ex.TotalCount,0)= 0 THEN 1 ELSE 1.0 * Ex.TotalCount END ))),NULL) AS Expected
                 ,D.TotalBurn - ISNULL(B.Burned,0) AS ActualBurnDown
                 FROM @Days D
                 LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY T.[Date]) - 1 AS Cnt
                                  ,T.[Date]
                                  ,TotalCount = COUNT(1) OVER() -1
                                   FROM
                                   (SELECT DATEADD(DAY, NUMBER, @DateFrom) AS [Date]
                                           FROM MASTER..SPT_VALUES
                                           WHERE TYPE='P'
                                           AND DATEADD(DAY, NUMBER,@DateFrom) <= (SELECT SprintEndDate FROM Sprints WHERE Id = @SprintId)) T
                                           WHERE (DATENAME(WEEKDAY,T.[Date]) NOT IN (SELECT WeekDayName FROM WeekDays WHERE CompanyId = @CompanyId AND IsWeekend = 1))
                                            AND T.[Date] NOT IN (SELECT H.[Date]
                                           FROM [Holiday] H
                                           JOIN [Project] P ON P.CompanyId = H.CompanyId
                                           JOIN [Sprints] S ON S.Projectid = P.Id AND S.Id = @SprintId)) Ex ON Ex.[Date] = D.[Date]
                 LEFT JOIN(SELECT D.[Date]
                                 ,SUM(IIF(@UserStoryPoints = 0,US.EstimatedTime,US.SprintEstimatedTime)) AS Burned
                                 FROM @Days D
                                 JOIN (SELECT D.[Date],D.UserStoryId,MAX(USWST.CreatedDateTime) AS MaxCreated FROM @Days D LEFT JOIN UserStoryWorkflowStatusTransition USWST ON USWST.CreatedDateTime <= DATEADD(DAY,1,D.[Date]) AND USWST.UserStoryId = D.UserStoryId GROUP BY D.UserStoryId,D.[Date]) T ON T.[Date] = D.[Date] AND T.UserStoryId = D.UserStoryId
                                 JOIN UserStoryWorkflowStatusTransition USWST ON USWST.CreatedDateTime = T.MaxCreated AND USWST.UserStoryId = T.UserStoryId
                                 JOIN WorkflowEligibleStatusTransition WEST ON USWST.WorkflowEligibleStatusTransitionId = WEST.Id AND WEST.InActiveDateTime IS NULL
                                 JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.InActiveDateTime IS NULL
                                 JOIN UserStory US ON US.Id = D.UserStoryId AND US.InActiveDateTime IS NULL AND US.UserStoryStatusId = USS.Id AND US.ParkedDateTime IS NULL
                                 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] >= 6 AND TS.[Order] <> 5
                          GROUP BY D.[Date]) B ON B.[Date] = D.[Date]
       -- WHERE  (D.TotalBurn - ISNULL(B.Burned,0) > 0)
        GROUP BY D.[Date],D.[TotalBurn],B.Burned,Ex.Cnt,Ex.TotalCount
        
        --UPDATE #SprintBurnDown SET Expected = (SELECT [Expected] FROM #SprintBurnDown S WHERE S.Id = (SELECT MAX(Id) FROM #SprintBurnDown SP WHERE Expected IS NOT NULL AND SP.Id = Id)) WHERE Expected IS NULL
        
        --UPDATE #SprintBurnDown SET ExpectedId = T.ExpectedId
        --FROM #SprintBurnDown SBD
        --LEFT JOIN (SELECT Id
        --        ,SUM(CASE WHEN Expected IS NULL THEN 0 ELSE 1 END) OVER(ORDER BY Id) AS ExpectedId
        --FROM #SprintBurnDown 
        --) T ON T.Id = SBD.Id
        --UPDATE #SprintBurnDown SET Expected = (SELECT Expected FROM #SprintBurnDown WHERE Id = SBD.ExpectedId)
        --FROM #SprintBurnDown SBD
        --WHERE SBD.Expected IS NULL
		
		DECLARE @ExpectedId INT,@Expected FLOAT,@FinalExpected FLOAT  

        DECLARE Cursor_Sprint CURSOR
        FOR SELECT Id
            FROM #SprintBurnDown
			ORDER BY [Date]
         
        OPEN Cursor_Sprint
         
            FETCH NEXT FROM Cursor_Sprint INTO 
                @ExpectedId
             
            WHILE @@FETCH_STATUS = 0
            BEGIN

			SET @Expected = (SELECT Expected FROM #SprintBurnDown WHERE Id = @ExpectedId)
			  IF(@Expected IS NULL)
			  BEGIN
				
				SET @FinalExpected = (SELECT Expected FROM #SprintBurnDown 
				                      WHERE [Date] = DATEADD(DAY,-1,(SELECT [Date] FROM #SprintBurnDown WHERE Id = @ExpectedId)))
				
				UPDATE #SprintBurnDown SET Expected = @FinalExpected WHERE Id = @ExpectedId

			  END

			FETCH NEXT FROM Cursor_Sprint INTO 
                @ExpectedId

                SET @Expected = NULL
            END
             
        CLOSE Cursor_Sprint
         
        DEALLOCATE Cursor_Sprint

        SELECT [Date],Expected AS ExpectedBurnDown,Actual AS ActualBurnDown 
		FROM #SprintBurnDown ORDER BY [Date] DESC
        
        END
        ELSE
            RAISERROR(@HavePermission,11,1)
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO