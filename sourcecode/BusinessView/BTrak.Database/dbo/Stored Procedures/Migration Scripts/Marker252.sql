CREATE PROCEDURE [dbo].[Marker252]
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
	   	WHERE DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00'') ,SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')) > 70-- AND [Date] = cast(''@CurrentDateTime'' as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND ISNULL(ISNULL(@DateFrom,@Date),cast(''@CurrentDateTime'' as date)) <= [Date] 
		 AND ISNULL(ISNULL(@DateTo,@Date),cast(''@CurrentDateTime'' as date)) >= [Date] 
		 AND InActiveDateTime IS NULL)
		 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',@CompanyId)
	, (NEWID(),'Least spent time employees','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',
     CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd MMM yyyy'') AS [Date] FROM				
	     (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN ''@CurrentDateTime'' 
	            WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'')  
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)
				-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date]
	            FROM [User] U 
				INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE CAST(TS.[Date] AS date) >=     CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(DAY,1,DATEADD(MONTH,-1,EOMONTH(''@CurrentDateTime''))) ) AS date)
							       AND CAST(TS.[Date] AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(''@CurrentDateTime'') ) AS date)
							       AND TS.[Date] <> CAST(''@CurrentDateTime'' AS date)
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
			   	
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Date', 'datetime', 'SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],
DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]		
FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId	   	
WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND CAST([Date] AS date) = CAST(''##Date##'' AS DATE) 		
 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		
  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))							
  		    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )										
		    OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Afternoon late employee', 'nvarchar', 'SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],  DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in min]		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId	
   	WHERE DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70 
	AND FORMAT([Date],''MM-yy'') = FORMAT(CAST(''##Date##'' AS DATE),''MM-yy'') 	
	 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		 
	 AND U.Id = ''##Id##''
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))							
  		    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )										
		    OR (''@IsAll'' = 1))
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
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
