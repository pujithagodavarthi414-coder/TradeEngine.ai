CREATE PROCEDURE [dbo].[Marker229]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Afternoon late employees','SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',@CompanyId)
 ,(NEWID(),'Afternoon late trend graph','SELECT  FORMAT(T.[Date],''dd MMM yyyy'') AS [Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),ISNULL(@DateTo,EOMONTH(GETDATE()))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1), ISNULL(@DateTo,EOMONTH(GETDATE())))
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
							   AND TS.[Date] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]',@CompanyId)
	 ,(NEWID(),'Average Exit Time',' SELECT FORMAT([Date],''dd MMM yyyy'') [Date],
     FORMAT(CAST(DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),cast([Avg exit time] as time(0))) as datetime),''hh:mm'') + '' ''+ ISNULL(OTZ.TimeZoneAbbreviation,'''') [Avg exit time] FROM
	 (SELECT [Date] AS [Date],ISNULL(CAST(AVG(CAST(CAST(SWITCHOFFSET(TS.OutTime, ''+00:00'') AS DATETIME) AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId = ''@CompanyId''
	 GROUP BY [Date])T
	 INNER JOIN [User]U ON U.Id = ''@OperationsPerformedBy''
	 LEFT JOIN TimeZone OTZ on OTZ.Id = U.TimeZoneId',@CompanyId)
 ,(NEWID(),'Intime trend graph',' SELECT  FORMAT(T.[Date],''dd MMM yyyy'') [Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T 
	LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  ) 
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) 
											        and SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]',@CompanyId)

 ,(NEWID(),'Morning late employees','SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+ '' '' +U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		     INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			 AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
			 AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
		     INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.Date)
			 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND cast(SE.ExceptionDate as date) = CAST(TS.Date as date) AND SE.InActiveDateTime IS NULL
			 WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
					 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)          
	GROUP BY FORMAT(TS.[Date],''dd MMM yyyy'') ,U.FirstName, U.SurName ,U.Id',@CompanyId)
  ,(NEWID(),'Night late employees','SELECT Z.EmployeeName [Employee name] ,FORMAT(Z.Date,''dd MMM yyyy'') AS Date
,DATEADD(minute,(DATEPART(tz,Z.OutTime)),CAST(Z.OutTime AS Time)) [Out Time]
,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime
			,TS.[Date]
			,TS.OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U 
	LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,u.TimeZoneId,TimeZone.TimeZoneName)Z',@CompanyId)
 ,(NEWID(),'Least spent time employees','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',
CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd MMM yyyy'') AS [Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))',@CompanyId)
     )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

UPDATE Widget SET InActiveDateTime = GETDATE() WHERE WidgetName='Work Item Replan Type' AND CompanyId=@CompanyId AND InActiveDateTime IS NULL

					   	
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Date', 'datetime', 'SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],
DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]		
FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId	   	
WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND CAST([Date] AS date) = CAST(GETDATE() AS DATE) 		
 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		
  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))							
  		    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )										
		    OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon Late Trend Graph '),'Date', 'date', 'SELECT FORMAT(TS.[Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime)[Late in mins]
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULLWHERE TS.InActiveDateTime IS NULL 
 AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
 AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
 AND FORMAT(TS.Date,''dd MMM yyyy'') =  ''##Date##''
 GROUP BY FORMAT(TS.[Date],''dd MMM yyyy''),LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurNameHAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees'),'Date', 'date', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name] ,DATEDIFF(MINUTE,CAST(ISNULL(SE.DeadLine, SW.Deadline) AS TIME)		       
   ,CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME)) [Late in minutes]  	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
   	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     		
INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL		AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    		
AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) 	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InactiveDatetime IS NULL 		
	 	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL	
			AND SE.ExceptionDate = TS.[Date]	WHERE SWITCHOFFSET(TS.InTime,''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))   	AND FORMAT((TS.[Date]),''dd MMM yyyy'') = ''##Date##''    
						AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') 
								WHERE ChildId <>  ''@OperationsPerformedBy''))									  	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )				
											OR (''@IsAll'' = 1))       	            	
											GROUP BY FORMAT(TS.[Date],''dd MMM yyyy''),U.FirstName + '' '' + U.SurName,ISNULL(SE.DeadLine, SW.Deadline),TS.InTime',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees'),'Employee name', 'nvarchar', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name] 	,DATEDIFF(MINUTE,CAST(ISNULL(SE.DeadLine, SW.Deadline) AS TIME)	          ,CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME)) [Late in minutes]  
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL          
		INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
			AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) 	AND ES.InActiveDateTime IS NULL INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 	
			AND T.InactiveDatetime IS NULL INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id 	AND SW.DayOfWeek = DATENAME(DW,TS.[Date]) 
			    	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL	AND SE.ExceptionDate = TS.[Date]	
					WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))   	AND U.Id = ''##Id##''       AND U.CompanyId = (''@CompanyId'')	
					GROUP BY FORMAT(TS.[Date],''dd MMM yyyy''),U.FirstName + '' '' + U.SurName,ISNULL(SE.DeadLine, SW.Deadline),TS.InTime',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees  '),'Date', 'date', 'SELECT T.[Employee name],DATEADD(minute,(DATEPART(tz,T.OutTime)),
CAST(T.OutTime AS Time)) AS OutTimeFROM (SELECT U.FirstName+'' ''+U.SurName [Employee name],OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' 
else TimeZone.TimeZoneName end as OutTimeFROM [User]U LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneIdINNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') 
OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId
 AND CAST(UB.[Date] AS DATE) = TS.[Date] WHERE FORMAT(CAST(TS.[Date] AS date),''dd MMM yyyy'') = ''##Date##'' AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	
  AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))									
      OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )	OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees '),'Date', 'date', 'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',
CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],BreakTimeInMin [Break time in min],LunchBreakInMin [Lunch break in min ]FROM					 
    (SELECT    U.FirstName+'' ''+U.SurName EmployeeName	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,	      
	    (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() 	          
		  WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE()	          
		    ELSE TS.OutTime  END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,	            TS.[Date], 
			ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0) BreakTimeInMin	 ,ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)LunchBreakInMin	         
			   FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)				     
			        LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]	 WHERE  FORMAT(TS.[Date],''dd MMM yyyy'') = ''##Date##''  						
					 AND ((''@IsReportingOnly'' = 1 AND  U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))							
				         OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )				OR (''@IsAll'' = 1))	          
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId, TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Pipeline work'),'Deadline date', 'datetimeoffset', 'SELECT US.Id,US.UserStoryName FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId 
  AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL 
  AND US.ParkedDateTime IS NULL INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId LEFT JOIN Goal G ON G.Id = US.GoalId	    
   AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL 
   AND GS.IsActive = 1LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL
   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''	) 
   AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND FORMAT(CAST(US.DeadLineDate AS date),''dd MMM yyyy'') = ''##Deadline##'' OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))
   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))	
   OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)


	)
 
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND  Target.[CompanyId] = Source.[CompanyId]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden];
           


	
END