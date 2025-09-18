CREATE PROCEDURE [dbo].[Marker302]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

         UPDATE CustomWidgets SET WidgetQuery = 'SELECT JobOpeningTitle [Job Name],NoOfOpenings [No Of Openings],(SELECT COUNT(1) FROM CandidateJobOpening CJO JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND CJO.InActiveDateTime IS NULL
					WHERE CJO.JobOpeningId= JO.Id AND HS.[Status]=''On boarding''
					AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.AppliedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.AppliedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
					AND   (''@CandidateId'' = '''' OR CJO.CandidateId = ''@CandidateId'')
					) [Hired Candidates] 
					FROM  JobOpening JO LEFT JOIN CandidateJobOpening COJ ON JO.Id = COJ.JobOpeningId AND COJ.InActiveDateTime IS NULL
					WHERE CompanyId = ''@CompanyId'' AND JO.InActiveDateTime IS NULL
					   AND (''@CandidateId'' = '''' OR COJ.CandidateId = ''@CandidateId'')
                       AND (''@EmploymentStatusId'' = ''''  OR JO.JobTypeId = ''@EmploymentStatusId'')
					   GROUP BY JobOpeningTitle ,NoOfOpenings ,JO.Id' WHERE CustomWidgetName = 'Hired Candidates vs Job Openings' AND CompanyId = @CompanyId
					   
 UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],IIF(''@UserId''= '''',NULL ,''@UserId'') AS UserId ,ISNULL((SELECT COUNT(1) MorningLateEmployeesCount 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL   
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL           
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
	AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL 
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) 
	AND SE.InActiveDateTime IS NULL              
	WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
	AND TS.[Date] = TS1.[Date]
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)      
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]          
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))            
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )         
	OR (''@IsAll'' = 1))       
	GROUP BY TS.[Date]),0) MorningLateEmployeesCount, 
	(SELECT COUNT(1) 
	FROM(SELECT  
	TS.UserId,ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'')
	,SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) AfternoonLateEmployee          
	FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL  
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	WHERE TS.[Date] = TS1.[Date]        
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'')         
	OR (''@IsAll'' = 1))         
	GROUP BY TS.[Date],SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00''),TS.UserId)T   
	WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee       
	FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId     
	AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL          
	WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
	AND TS1.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
	AND TS1.[Date] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date) 
	AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(TS1.[Date] AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
    AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(TS1.[Date] AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
    AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )          
	OR (''@IsAll'' = 1))        
	GROUP BY TS1.[Date]'  WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Lates trend graph'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT  FORMAT(T.[Date],''dd MMM yyyy'') [Date], ISNULL([Morning late],0) [Morning late],''@UserId'' AS UserId  FROM		
	(SELECT  CAST(DATEADD( day,-(number-1), ISNULL(ISNULL(@DateTo,@Date),CAST(GETDATE() AS date))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and DATEDIFF(DAY,ISNULL(ISNULL(@DateFrom,@Date),CAST(DATEADD(DAY,-30,GETDATE()) AS date)),ISNULL(ISNULL(@DateTo,@Date),GETDATE()))+1)T 
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
											   WHERE (TS.[Date] >= ISNULL(ISNULL(@DateFrom,@Date ),CAST(DATEADD(DAY,-30,GETDATE()) AS date)))
											       AND (TS.[Date] <= ISNULL(ISNULL(@DateTo,@Date),CAST(GETDATE() AS date)))
											        AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											  AND U.CompanyId = ''@CompanyId''
											  AND  (''@UserId'' = '''' OR ''@UserId'' = U.Id)
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' WHERE CustomWidgetName = 'Intime trend graph' AND CompanyId = @CompanyId




 MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Lates trend graph'),'UserId', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'MorningLateEmployeesCount','int','SELECT U.FirstName+'' ''+U.SurName EmployeeName,DATEDIFF(MINUTE,cast(ISNULL(SE.Deadline,SW.DeadLine) as time),cast(InTime as time)) [Late in minutes]			       
FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL		          			          
INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL			      					         
INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL										  
AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)											                
OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)															  				         
OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)) 						    
INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL							    
INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])								    
LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL       							    
WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SW.DeadLine,SE.Deadline) AS DATETIME)) AND TS.[Date] = ''##Date##''							          
AND U.CompanyId =	''@CompanyId''							  AND (''##UserId##'' = '''' OR ''##UserId##'' = U.Id)							  
AND ((''@IsReportingOnly'' = 1 							      
AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))  
OR (''@IsMyself''= 1 AND  U.Id  = ''@OperationsPerformedBy'' )													 
OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'AfternoonLateEmployee','int','SELECT   U.FirstName+'' ''+U.SurName [Employee name],                  
         ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) - 70 [Lunch late in minutes]	    		 
		FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 	   AND U.CompanyId = ''@CompanyId''		    		 
		WHERE   TS.[Date] = ''##Date##''     	   
		     AND (''##UserId##''  = '''' OR ''##UserId##''  = U.Id)	    		 
			 AND ((''@IsReportingOnly'' = 1 
			 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') 		  
			 WHERE ChildId <>  ''@OperationsPerformedBy''))		     
			      OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )		 
				  OR (''@IsAll'' = 1))			  		  
				GROUP BY U.FirstName,U.SurName, LunchBreakEndTime,LunchBreakStartTime		 	  
HAVING ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) > 70',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'UserId', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Intime trend graph' AND CompanyId = @CompanyId),'Morning late','int',' SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+u.SurName AS [Employee name], FORMAT(TS.InTime,''HH:mm'') + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,'''')  AS [In time],
  CONVERT(NVARCHAR(5),CAST(DATEADD(MINUTE,ISNULL(OTZ.OffsetMinutes,''330''),
  (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))) AS TIME)) + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,''IST'') AS [Late allowance time] 
  FROM TimeSheet TS  JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL	                                          
  INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 										 
  INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL			    
  AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)			          
  OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)					  
  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)				  ) 	      
  INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId												  
  INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
  LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId					  
  LEFT JOIN TimeZone OTZ on OTZ.Id = TS.InTimeTimeZone										 
   WHERE FORMAT(cast(TS.[Date] as date),''dd MMM yyyy'') = ''##Date##'' 
   AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))		 AND (''##UserId##'' = '''' OR ''##UserId##'' = U.Id)						
 			  AND U.CompanyId = ''@CompanyId''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL) 
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

 UPDATE CustomAppColumns SET SubQuery = 'SELECT P.ProjectName, SUM(ISNULL(PID.ProductivityIndex,0)) Productivity     
       FROM             (SELECT PIN.UserId,SUM(ISNULL(PIN.ProductivityIndex,0)) ProductivityIndex,ProjectId        
	        	              FROM ProductivityIndex PIN            				  
							  WHERE PIN.CompanyId = ''@CompanyId''     
							  AND (''@ProjectId'' = '''' OR PIN.ProjectId = ''@ProjectId'')
							  AND PIN.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())            				 
							   GROUP BY UserId,ProjectId) PID            		
							   INNER JOIN Project P ON P.Id = PID.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')            		
							   INNER JOIN Employee E ON E.UserId = PID.UserId AND E.InActiveDateTime IS NULL            		
							   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id            		   
							    AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())           
								 WHERE P.CompanyId = ''@CompanyId''             AND EB.BranchId = ''##Id##''                    
								 GROUP BY P.ProjectName ' WHERE ColumnName = 'BranchName' AND CompanyId = @CompanyId AND CustomWidgetId IN 
	(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Branch wise monthly productivity report' AND CompanyId = @CompanyId) AND InActiveDateTime IS NULL

END
GO

