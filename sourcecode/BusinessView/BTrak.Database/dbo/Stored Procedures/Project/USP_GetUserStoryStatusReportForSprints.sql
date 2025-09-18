-------------------------------------------------------------------------------
-- Author       Ajay Kommalapati
-- Created      '2019-09-16 00:00:00.000'
-- Purpose      To get sser story status report in a goal
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [USP_GetUserStoryStatusReportForSprints] @SprintId = '491d88a3-6628-4d44-b377-520bb10a893a',@OperationsPerformedBy = 'EABC9A2D-4709-410B-8ABC-60C8EFFFE2F8'
-------------------------------------------------------------------------------
CREATE PROCEDURE [USP_GetUserStoryStatusReportForSprints]
(
 @SprintId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATETIME = NULL,
 @DateTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
        IF (@DateFrom IS NULL) SET @DateFrom  = (SELECT CONVERT(DATETIME,MIN(US.CreatedDateTime)) FROM UserStory US WHERE US.SprintId = @SprintId GROUP BY SprintId)
        IF (@DateTo IS NULL) SET  @DateTo  = (CASE WHEN EXISTS(SELECT  COUNT(1)
                                                               FROM UserStory US
                                                               JOIN UserStoryStatus USS ON USS.Id=US.UserStoryStatusId
                                                                AND US.SprintId = @SprintId
                                                                --AND USS.IsCompleted IS NULL AND USS.IsVerified IS NULL
                                                                --AND USS.IsSignedOff IS NULL AND USS.IsQAApproved IS NULL
                                                                AND USS.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId <> '884947DF-579A-447A-B28B-528A29A3621D'
                                                                ) THEN GETDATE()
                                                    ELSE (SELECT Max(US.CreatedDateTime)
                                                          FROM UserStory US
                                                          JOIN UserStoryStatus USS ON USS.Id=US.UserStoryStatusId
                                                           AND US.SprintId= @SprintId
                                                           --AND (USS.IsCompleted =1 OR USS.IsVerified =1
                                                             --OR USS.IsSignedOff = 1  OR USS.IsQAApproved = 1)
                                                             AND USS.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId <> '884947DF-579A-447A-B28B-528A29A3621D'
                                                           GROUP BY US.SprintId) END)
            IF (@DateTo > GETDATE()) SET @DateTo = GETDATE()
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            DECLARE @Len INT = (SELECT MAX(LEN(UST.ShortName)) FROM UserStoryType UST JOIN UserStory US ON US.UserStoryTypeId = UST.Id AND US.SprintId = @SprintId AND UST.CompanyId = @CompanyId)
            --SELECT LEN(UST.ShortName) FROM UserStoryType UST JOIN UserStory US ON US.UserStoryTypeId = UST.Id AND US.GoalId = @GoalId AND UST.CompanyId = @CompanyId GROUP BY ShortName
            DECLARE @WorkFlowId UNIQUEIDENTIFIER = (SELECT WorkFlowId FROM BoardtypeWorkflow 
					                                 WHERE BoardTypeId = (SELECT BoardTypeId FROM Sprints WHERE Id = @SprintId))
            DECLARE @Temp Table(
                                [Date] DATETIME,
                                [UserStoryId] UNIQUEIDENTIFIER,
                                [UserStoryName] NVARCHAR(800),
                                [UserStoryStatusId] UNIQUEIDENTIFIER,
                                [UserStoryStatus] NVARCHAR(250),
                                UserStoryStatusColour NVARCHAR(30),
                                [DeveloperName] NVARCHAR(250),
                                UserStoryUniqueName NVARCHAR(250),
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
          
		   INSERT INTO @Temp([Date],UserStoryId,UserStoryName,UserStoryStatusId,UserStoryStatusColour,DeveloperName,UserStoryUniqueName)
           SELECT T.Date,Id,Z.UserStoryName,NULL,StatusColor,DeveloperName,Z.UserStoryUniqueName FROM  @Days T CROSS JOIN
			(SELECT US.Id,US.UserStoryName,US.UserStoryUniqueName,[Status],U.FirstName+' '+U.SurName DeveloperName ,StatusColor 
			FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND  (@UserId IS NULL OR OwnerUserId = @UserId)
			                                                           LEFT JOIN [User]U ON U.Id = US.OwnerUserId  WHERE US.SprintId = @SprintId
                                                                      AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
                                                                      AND US.ParkedDateTime IS NULL
                                                                      AND (@UserId IS NULL OR US.OwnerUserId = @UserId)) Z 
         
		   DECLARE @UserStoryId UNIQUEIDENTIFIER 

		   DECLARE Cursor_Script CURSOR
  
        FOR SELECT Id FROM UserStory US WHERE US.SprintId = @SprintId
                                                                      AND InActiveDateTime IS NULL AND ArchivedDateTime IS NULL
                                                                      AND ParkedDateTime IS NULL
                                                                      AND (@UserId IS NULL OR OwnerUserId = @UserId)
         
        OPEN Cursor_Script 
            FETCH NEXT FROM Cursor_Script INTO 
                @UserStoryId
             
            WHILE @@FETCH_STATUS = 0
            BEGIN
               
			   DECLARE @UserStoryStatusId UNIQUEIDENTIFIER = NULL
			   DECLARE @Date DATE = (SELECT CreatedDateTime FROM UserStory WHERE Id = @UserStoryId)
              
			  WHILE (CONVERT(DATE,@Date) < = CONVERT(DATE,@DateTo))
               BEGIN
                    
				SET @UserStoryStatusId = ISNULL((SELECT TOP 1 UserStoryStatusId FROM 
                  (SELECT UserStoryId,ToWorkflowUserStoryStatusId UserStoryStatusId,ROW_NUMBER() OVER (ORDER BY TransitionDateTime DESC) RowNo
				   FROM UserStoryWorkflowStatusTransition UST INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId
			                 WHERE CAST(TransitionDateTime AS date) = CAST(@Date AS date) AND UserStoryId = @UserStoryId )T WHERE RowNo =  1),@UserStoryStatusId) 
            
			      UPDATE @Temp SET UserStoryStatusId = @UserStoryStatusId WHERE  CAST([Date] AS DATE) = CAST(@Date AS DATE) AND UserStoryId = @UserStoryId

                 SET @Date = DATEADD(D,1,@Date)
         
		     END

			   
                FETCH NEXT FROM Cursor_Script INTO 
                @UserStoryId
        
            END
             
        CLOSE Cursor_Script
        DEALLOCATE Cursor_Script
         
		   UPDATE @Temp SET UserStoryStatusId = (SELECT WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Sprints S ON S.BoardTypeId = BTW.BoardTypeId
											                          WHERE S.Id = @SprintId 
																	        AND WS.CanAdd = 1 
																			AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL) WHERE UserStoryStatusId IS NULL

            UPDATE @Temp SET UserStoryStatus = [Status],UserStoryStatusColour = USS.StatusHexValue FROM UserStoryStatus USS WHERE Id = UserStoryStatusId

			UPDATE @Temp SET UserStoryStatus = NULL,UserStoryStatusColour = NULL,UserStoryStatusId = NULL FROM UserStory USS WHERE CAST(CreatedDateTime AS date) > CAST([Date] AS DATE) AND USS.Id = UserStoryId 


           UPDATE @Temp SET SummaryValue = WFS.[OrderId] FROM WorkflowStatus WFS
                                                         JOIN @Temp T ON T.UserStoryStatusId = WFS.UserStoryStatusId AND WFS.InActiveDateTime IS NULL 
														 JOIN WorkFlow W ON W.Id = @WorkFlowId
														 AND WFS.CompanyId = @CompanyId
           
		   SELECT T.[Date],
                  T.UserStoryId,
                  T.UserStoryName,
                  T.UserStoryUniqueName UniqueName,
                  T.UserStoryStatusId,
                  T.UserStoryStatus,
                  UserStoryStatusColour AS StatusColour,
                  T.DeveloperName,
                  @WorkFlowId AS WorkFlowId,
                  T.SummaryValue + 110 SummaryValue
                 FROM @Temp T 
           ORDER BY T.[Date],CAST(SUBSTRING(T.UserStoryUniqueName,@Len + 2,LEN(T.UserStoryUniqueName)) AS INT)

     END TRY
     BEGIN CATCH
        THROW
    END CATCH
END