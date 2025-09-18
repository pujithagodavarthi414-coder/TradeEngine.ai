-------------------------------------------------------------------------------
-- Author      Geetha CH
-- Created      '2020-03-13 00:00:00.000'
-- Purpose      To Get Productivity Based on daily basis
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeProductivityOnDailyBasis] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeProductivityOnDailyBasis]
(
    @UserId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    
    SET NOCOUNT ON
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY 
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
            BEGIN
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                DECLARE @DateFrom DATETIME = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()),0)
                DECLARE @DateTo DATETIME = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1,-1)
                
                 DECLARE @ProductiveHours TABLE
                (
                    UserName NVARCHAR(500),
                    UserId UNIQUEIDENTIFIER,
                    UserStoryId UNIQUEIDENTIFIER,
                    EstimatedTime NUMERIC(10,2),
                    GoalId UNIQUEIDENTIFIER,
                    ApprovedDate DATETIME,
                    IsLoggedHours BIT,
                    IsEsimatedHours BIT
                )
                INSERT INTO @ProductiveHours(UserName,UserStoryId,UserId,GoalId,IsLoggedHours,IsEsimatedHours,ApprovedDate)
                SELECT U.FirstName + ' ' + ISNULL(U.SurName,''),US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,CONVERT(DATE,UW.DeadLine)
                FROM Goal G 
                     INNER JOIN UserStory US ON US.GoalId = G.Id
                     INNER JOIN (SELECT US.Id
                                       ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                        FROM UserStory US 
                                        INNER JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
                                        INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
                                        INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
                                        INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
                                        INNER JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
                                        INNER JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
                                      GROUP BY US.Id) UW ON US.Id = UW.Id
                     INNER JOIN [User] U ON U.Id = US.OwnerUserId
                     --INNER JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) EM ON EM.ChildId =  U.Id
                     INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
                     INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
                     INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
                     INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
                     LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
                    WHERE (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
                           AND (TS.TaskStatusName IN (N'Done',N'Verification completed')) --AND (TS.[Order] IN (4,6))
                           AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
                           AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
                           AND U.IsActive = 1 
                           AND (U.Id = ISNULL(@UserId,@OperationsPerformedBy))
                           AND U.CompanyId = @CompanyId
                           AND IsProductiveBoard = 1  
                           AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
                      GROUP BY U.FirstName,U.SurName,US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,ISForQA,CONVERT(DATE,UW.DeadLine)
                 UPDATE @ProductiveHours 
                     SET EstimatedTime = US.EstimatedTime
                     FROM UserStory US 
                          INNER JOIN @ProductiveHours PUS ON US.Id = PUS.UserStoryId 
                     WHERE IsEsimatedHours = 1
                     
                  UPDATE @ProductiveHours 
                     SET EstimatedTime = LUSInner.LoggedTime
                     FROM @ProductiveHours PUS
                          INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
                                FROM UserStorySpentTime UST 
                                     INNER JOIN @ProductiveHours PUS ON PUS.UserStoryId = UST.UserStoryId AND UST.CreatedbyUserId = PUS.UserId
                                WHERE IsLoggedHours = 1
                                GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId
                
                DECLARE @MaxLenth INT,@MaxValue INT 
                
                SET @MaxValue = (SELECT CEILING(MAX(EstimatedTime)) FROM (SELECT SUM(EstimatedTime) EstimatedTime
                                                FROM @ProductiveHours
                                                GROUP BY ApprovedDate)T)
                SET @MaxLenth = (SELECT CONVERT(INT,CAST(1 AS VARCHAR(1)) + REPLICATE(0,LEN(@MaxValue))))

                ;WITH CTE AS  
                (  
                 SELECT 0 Number  
                 UNION all  
                 SELECT Number + 1 FROM CTE WHERE Number < DATEDIFF(DAY,@DateFrom,@DateTo) 
                )  
                  
                SELECT DateValue AS ApprovedDate,UserName,UserId,ISNULL(Productivity,0) AS Productivity,ISNULL(Productivity * 1.00/@MaxLenth * 1.00,0) AS ReducedProductivity
                FROM 
                (SELECT DATEADD(DAY,Number,@DateFrom) AS DateValue
                FROM CTE ) CTE
                LEFT JOIN (SELECT UserName,UserId,ApprovedDate,SUM(EstimatedTime) AS Productivity
                           FROM @ProductiveHours
                           GROUP BY UserName,UserId,ApprovedDate) PH ON PH.ApprovedDate = CTE.DateValue
                ORDER BY ApprovedDate
                OPTION ( MAXRECURSION 0)
       END
       ELSE
           RAISERROR (@HavePermission,11, 1)
    END TRY
    BEGIN CATCH
        THROW 
    END CATCH
END
GO