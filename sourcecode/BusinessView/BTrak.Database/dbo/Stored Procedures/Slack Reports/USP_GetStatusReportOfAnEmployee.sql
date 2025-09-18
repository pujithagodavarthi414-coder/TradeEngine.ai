-----------------------------------------------------------------------------------------
--EXEC [USP_GetStatusReportOfAnEmployee] @UserId = '62aeb97d-4ed9-4727-991c-065abbe78479' ,@DateFrom='12/4/2020 12:00:00 AM',@DateTo='12/4/2020 4:14:18 PM'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetStatusReportOfAnEmployee]
(
    @UserId UNIQUEIDENTIFIER,
    @DateFrom DATETIME = null,
    @DateTo DATETIME = null
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY          
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
          IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
          DECLARE @Currentdate DATETIME = CONVERT(DATE,GETDATE()) 
          DECLARE @WeekDateTo DATETIME
          DECLARE @WeekDateFrom DATETIME
          SELECT @WeekDateTo = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Currentdate), @Currentdate)
          SELECT @WeekDateFrom = DATEADD(dd, -(DATEPART(dw, @WeekDateTo)-1), CAST(@WeekDateTo AS DATE))
          DECLARE @TodayProductivityIndex INT = (SELECT SUM(ProductivityIndex) FROM dbo.[Ufn_ProductivityIndexForDevelopers_New](@Currentdate,@Currentdate,@UserId,@CompanyId))
          DECLARE @WeekProductivityIndex INT = (SELECT SUM(ProductivityIndex) FROM dbo.[Ufn_ProductivityIndexForDevelopers_New](@WeekDateFrom,@WeekDateTo,@UserId,@CompanyId))
          DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST(SUBSTRING([Value], 1, LEN([Value]) - CHARINDEX('h', REVERSE([Value]))) AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)
		  
             SELECT E.Id EmployeeId,
                    U.Id,
                    U.FirstName + ' ' + ISNULL(U.SurName,'')  EmployeeName,
                    USSInner1.UserStoryName TaskName,
					USSInner1.GoalName GoalName,
                    CASE WHEN USTInner.Transition IS NULL THEN USSInner1.StatusTransition ELSE USTInner.Transition END AS Transition,
                    USSInner1.BoardTypeName TaskType,
                   
                    (STUFF((SELECT  ',' + USTInner.Comment  
                     FROM UserStorySpentTime USTInner 
                     WHERE USTInner.UserStoryId = USSInner1.UserStoryId AND USTInner.CreatedByUserId = @UserId
                     AND CONVERT(DATE,USTInner.DateTo) = @Currentdate
                     FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) AS WorkDescription,
                    
                     IIF(FLOOR(ISNULL(USSInner1.EstimatedTime,0)) = 0,IIF(CAST((ISNULL(USSInner1.EstimatedTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(USSInner1.EstimatedTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(USSInner1.EstimatedTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(USSInner1.EstimatedTime,0) *60)AS int)%60) + 'm') OrginalEstimate,

                     IIF(FLOOR(ISNULL(USSInner.SpentTime,0)) = 0,IIF(CAST((ISNULL(USSInner.SpentTime,0)*60)AS int) %60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(ISNULL(USSInner.SpentTime,0))) + 'h')+' '+IIF(CAST((ISNULL(USSInner.SpentTime,0)*60)AS int) %60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(USSInner.SpentTime,0)*60)AS int) %60) + 'm') SpentSoFar,

                     IIF(FLOOR(ISNULL(USSInner1.TodaySpentTime,0)) = 0,IIF(CAST((USSInner1.TodaySpentTime*60) AS int)%60 = 0 ,'0h',''),CONVERT(NVARCHAR,FLOOR(USSInner1.TodaySpentTime)) + 'h')+' '+IIF(CAST((USSInner1.TodaySpentTime*60) AS int)%60 = 0 ,'',CONVERT(NVARCHAR,CAST((USSInner1.TodaySpentTime*60) AS int)%60) + 'm') SpentToday,
					
                     IIF(FLOOR(ISNULL(USSInner2.RemainingTime,0)) = 0,IIF(CAST((USSInner2.RemainingTime*60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(USSInner2.RemainingTime)) + 'h')+' '+IIF(CAST((USSInner2.RemainingTime*60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((USSInner2.RemainingTime*60)AS int)%60) + 'm') Remaining,

                     IIF(CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) - ISNULL(UBInner.BreakTime*1.0,0))/60 AS int) = 0,IIF(CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) - ISNULL(UBInner.BreakTime*1.0,0))%60 AS int) = 0,'0h',''),CONVERT(NVARCHAR,CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) - ISNULL(UBInner.BreakTime*1.0,0))/60 AS int)) + 'h')+' '+IIF(CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) - ISNULL(UBInner.BreakTime*1.0,0))%60 AS int) = 0,'',CONVERT(NVARCHAR,CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) - ISNULL(UBInner.BreakTime*1.0,0))%60 AS int))+'m')  TotalSpentHoursInOffice,
                    
					CASE WHEN ISNULL(USSInner3.TodayTotalSpentTime,0) >= @CompliantHours THEN '0h' 
					ELSE
					CASE WHEN
					 ((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0)) - (ISNULL(USSInner3.TodayTotalSpentTime,0)*60) < = 30 THEN '0h' 
					ELSE
					CASE WHEN (ISNULL(USSInner3.TodayTotalSpentTime,0) >= (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = @UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE()))) THEN '0h'
					ELSE
                          CASE WHEN ISNULL(USSInner1.TodaySpentTime,0) > (ISNULL(TSInner.SpentTimeWithOutBreaks,0) - ISNULL(UBInner.BreakTime,0))/60 THEN '0h'
                          ELSE 
						  IIF(FLOOR(((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0))/60.00-ISNULL(USSInner3.TodayTotalSpentTime,0)) = 0,IIF(CAST(((((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0)) - ((ISNULL(USSInner3.TodayTotalSpentTime,0))*60))%60)AS int) = 0,'0h',''),REPLACE(CONVERT(NVARCHAR,CAST(FLOOR(((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0))/60.00-ISNULL(USSInner3.TodayTotalSpentTime,0)) AS INT))+'h','-',''))  +' '+ 
						       IIF(CAST(((((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0)) - ((ISNULL(USSInner3.TodayTotalSpentTime,0))*60))%60)AS int) = 0,'',REPLACE(CONVERT(NVARCHAR,CAST(((((ISNULL(TSInner.SpentTimeWithOutBreaks,0)) - ISNULL(UBInner.BreakTime,0)) - ((ISNULL(USSInner3.TodayTotalSpentTime,0))*60))%60)AS int))+'m','-',''))
						   END
                    END
					END
					END RemainingHoursToBeLogged,
                   
                    IIF(FLOOR(ISNULL(USSInner3.TodayTotalSpentTime,0)) = 0,IIF(CAST(((ISNULL(USSInner3.TodayTotalSpentTime,0))*60)%60 AS int) = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(ISNULL(USSInner3.TodayTotalSpentTime,0))) + 'h')+' '+IIF(CAST(((ISNULL(USSInner3.TodayTotalSpentTime,0))*60)%60 AS int) = 0,'',CONVERT(NVARCHAR,CAST(((ISNULL(USSInner3.TodayTotalSpentTime,0))*60)%60 AS int)) + 'm')  TotalHoursLogged,
                    
                    CASE WHEN CEILING(ISNULL(USSInner3.TodayTotalSpentTime,0)) < (ISNULL(TSInner.SpentTimeWithOutBreaks,0) - ISNULL(UBInner.BreakTime,0))/60 
                    THEN '#e01a28' ELSE '#1d7042' END [OverAllStatus],
                    
                    CASE WHEN USSInner2.RemainingTime = 0 AND (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))) > 0)  THEN 'Remaining time left on estimated hours was none ' 
                                + '- Ahead of time by '+ IIF(CAST(ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))) AS INT) = 0,IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int) = 0,'0h',''), CONVERT(NVARCHAR,CAST(ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))) AS INT)) + ' hours ')+ IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int) = 0,'',REPLACE(CONVERT(NVARCHAR,CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int))+' minutes ','-',''))
                         
                         WHEN USSInner2.RemainingTime = 0 AND (ISNULL(USSInner1.EstimatedTime,0)- (ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))) < 0)  THEN 'Remaining time left on estimated hours was none ' 
                                + REPLACE('- Spent '+ IIF(CAST((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))))) AS INT) = 0,IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int) = 0,'0h', ''), CONVERT(NVARCHAR,CAST((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))))) AS INT))+' hours ')+ IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int) = 0,'', CONVERT(NVARCHAR,CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS int))+' minutes '),'-','')+ ' more than expected estimate'
                         
                         WHEN USSInner2.RemainingTime = 0 THEN 'Remaining time left on estimated hours was none'
                         
                         WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))) > 0)
                              THEN ' Ahead of time by '+ IIF(CAST((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))))) AS INT) = 0,IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS INT)=0,'0h',''), CONVERT(NVARCHAR,CAST((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))))) AS INT)) + ' hours ')+ IIF(CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS INT) = 0,'',CONVERT(NVARCHAR,CAST(((ISNULL(USSInner1.EstimatedTime,0) - ((ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0)))))*60)%60 AS INT)) + ' minutes ')
                        
                           WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))) < 0)
                              THEN REPLACE(' Remaining time left '+ IIF(CAST(ISNULL(USSInner2.RemainingTime,0) AS INT) = 0,IIF(CAST((ISNULL(USSInner2.RemainingTime,0)*60)%60 AS int) = 0,'0h',''), CONVERT(NVARCHAR,CAST(ISNULL(USSInner2.RemainingTime,0) AS INT))+ ' hours ')+ IIF(CAST((ISNULL(USSInner2.RemainingTime,0)*60)%60 AS int) = 0,'', CONVERT(NVARCHAR,CAST((ISNULL(USSInner2.RemainingTime,0)*60)%60 AS int))+' minutes'),'-','')
                        
                         WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + (ISNULL(USSInner2.RemainingTime,0))) = 0)
                              THEN ' '+ IIF(FLOOR((ISNULL(USSInner2.RemainingTime,0))) = 0,IIF(CAST(((ISNULL(USSInner2.RemainingTime,0))*60)%60 AS INT) = 0,'0h',''), CONVERT(NVARCHAR,FLOOR((ISNULL(USSInner2.RemainingTime,0)))) + ' hours ')+IIF(CAST(((ISNULL(USSInner2.RemainingTime,0))*60)%60 AS INT) = 0,'',CONVERT(NVARCHAR,CAST(((ISNULL(USSInner2.RemainingTime,0))*60)%60 AS INT))+' minutes ')+ 'Ahead' 
							  END StatusText,
                    
                    CASE WHEN USSInner2.RemainingTime = 0 THEN '#04510c' 
                         WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + ISNULL(USSInner2.RemainingTime,0)) > 0) THEN '#1d7042'
                         WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + ISNULL(USSInner2.RemainingTime,0)) < 0) THEN '#ffff00' 
                         WHEN (ISNULL(USSInner1.EstimatedTime,0) - (ISNULL(USSInner.SpentTime,0) + ISNULL(USSInner2.RemainingTime,0)) = 0) THEN '#0000ff' 
                         END StatusColor,
                         @TodayProductivityIndex  TodayProductivityIndex,
                         @WeekProductivityIndex  WeekProductivityIndex,
                         CONVERT(NVARCHAR ,CAST(WAInner.WorkAllocated AS INT)) + 'h' WorkAllocated
              FROM [User] U WITH (NOLOCK)
                   LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                   LEFT JOIN 
                   (SELECT BT.BoardTypeName,ISNULL(G.GoalName,S.SprintName) GoalName,USS.[Status] StatusTransition,UserStoryStatusId, US.OwnerUserId ,US.UserStoryName,US.EstimatedTime, UST.UserStoryId UserStoryId,
                    CONVERT(DATE,UST.CreatedDateTime) [CreatedDateTime],CAST(SUM(UST.SpentTimeInMin*1.0/60) AS DECIMAL(10,2)) AS TodaySpentTime
                        FROM UserStory US WITH (NOLOCK) 
                        JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
                        JOIN UserStorySpentTime UST WITH (NOLOCK) ON UST.UserStoryId = US.Id 
						AND @UserId = UST.CreatedByUserId --AND US.OwnerUserId = @UserId
						LEFT JOIN Goal G WITH (NOLOCK) ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL
						LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
						LEFT JOIN BoardType BT WITH (NOLOCK) ON (G.BoardTypeId = BT.Id OR BT.Id = S.BoardTypeId)
                        WHERE CONVERT(DATE,UST.CreatedDateTime) = @Currentdate
                          AND US.InActiveDateTime IS NULL
						  AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) OR (S.Id IS NOT NULL AND US.SprintId IS NOT NULL))
                        GROUP BY UST.UserStoryId,UserStoryStatusId,USS.[Status],G.GoalName,S.SprintName,CONVERT(DATE,UST.CreatedDateTime),US.UserStoryName,US.OwnerUserId,US.EstimatedTime,BT.BoardTypeName --,UST.Comment
                        ) USSInner1 ON @UserId = U.Id
        
                   LEFT JOIN (SELECT UserStoryId,CAST(SUM(UST.SpentTimeInMin*1.0/60) AS DECIMAL(10,2)) AS SpentTime
                        FROM UserStory US WITH (NOLOCK) 
                        JOIN UserStorySpentTime UST WITH (NOLOCK) ON UST.UserStoryId = US.Id AND @UserId = UST.CreatedByUserId AND US.InactiveDateTime IS NULL
                        GROUP BY UserStoryId) USSInner ON USSInner.UserStoryId = USSInner1.UserStoryId
                  LEFT JOIN (SELECT UserStoryId,WFEST.ToWorkFlowUserStoryStatusId ToTransistion,
                                CASE WHEN USS.[Status] = USS1.[Status] THEN USS.[Status]
                                     ELSE USS.[Status] + ' => ' + USS1.[Status] END AS Transition
                                FROM UserStoryWorkflowStatusTransition USW 
                                JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USW.WorkflowEligibleStatusTransitionId
                                JOIN UserStoryStatus USS ON USS.Id = WFEST.FromWorkFlowUserStoryStatusId
                                JOIN UserStoryStatus USS1 ON USS1.Id = WFEST.ToWorkFlowUserStoryStatusId
                                WHERE Convert(Date,TransitionDateTime) = @Currentdate
                                )USTInner ON USTInner.UserStoryId = USSInner1.UserStoryId AND USSInner1.UserStoryStatusId =USTInner.ToTransistion
                   LEFT JOIN (SELECT UST.CreatedByUserId UserId,CONVERT(DATE,UST.CreatedDateTime) [CreatedDateTime],CAST(SUM(UST.SpentTimeInMin*1.0/60) AS DECIMAL(10,2)) AS TodayTotalSpentTime
                        FROM UserStory US WITH (NOLOCK) 
                        JOIN UserStorySpentTime UST WITH (NOLOCK) ON UST.UserStoryId = US.Id
						     AND @UserId = UST.CreatedByUserId --AND US.OwnerUserId = @UserId
                        WHERE CONVERT(DATE,UST.CreatedDateTime) = @Currentdate
                        GROUP BY UST.CreatedByUserId,CONVERT(DATE,UST.CreatedDateTime)) USSInner3 ON USSInner3.UserId = U.Id
                   
                   LEFT JOIN (SELECT CAST((UST.RemainingTimeInMin*1.0/60.0) AS DECIMAL(10,2)) AS RemainingTime,UST.UserStoryId 
                        FROM  UserStorySpentTime UST
                        JOIN (select UserStoryId UserStoryId1,MAX(CreatedDateTime) CreatedDateTime1 from UserStorySpentTime GROUP BY UserStoryId)
                        USSOuter ON USSOuter.UserStoryId1 = UST.UserStoryId AND USSOuter.CreatedDateTime1 = UST.CreatedDateTime)
                        USSInner2 ON USSInner2.UserStoryId = USSInner1.UserStoryId
                   
                   LEFT JOIN (SELECT TS.UserId, TS.[Date] ,
                         ((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, '+00:00'), (CASE WHEN @Currentdate = CAST(GETDATE() AS Date) 
                         AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(TS.OutTime, '+00:00') END)),0) - 
                         ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))) AS SpentTimeWithOutBreaks
                            FROM TimeSheet TS
                            WHERE [Date] = @Currentdate
                            GROUP BY TS.UserId,TS.[Date], TS.LunchBreakStartTime,TS.LunchBreakEndTime,
                        TS.InTime,TS.OutTime) TSInner ON TSInner.UserId = U.Id 
                   
                   LEFT JOIN (SELECT SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))) BreakTime,UB.UserId,UB.[Date]
                        FROM UserBreak UB
                        WHERE [Date] = @Currentdate
                        GROUP BY UB.UserId,UB.[Date]) UBInner ON UBInner.UserId = U.Id
                   
                   LEFT JOIN (SELECT ISNULL(SUM(GEU.EstimatedTime),0) WorkAllocated,GEU.UserId
                     FROM [Ufn_GetEmployeeUserStories](@UserId,NULL,NULL,NULL,@CompanyId) GEU
                          INNER JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = GEU.UserStoryStatusId
                          AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
						  --AND (USS.IsNew = 1 OR USS.IsBlocked = 1 OR USS.IsInprogress = 1 
                          --OR USS.IsAnalysisCompleted = 1 OR IsDevInprogress = 1 OR USS.IsNotStarted = 1)
						   GROUP BY GEU.UserId) WAInner ON WAInner.UserId = U.Id
               WHERE @UserId IS NULL OR U.Id = @UserId AND U.CompanyId = @CompanyId
               AND U.IsActive = 1
               AND U.InActiveDateTime IS NULL
			   ORDER BY SpentToday DESC
    END
	END TRY
    BEGIN CATCH
        THROW
    END CATCH
END