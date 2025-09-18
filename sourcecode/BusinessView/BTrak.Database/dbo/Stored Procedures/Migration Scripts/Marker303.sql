CREATE PROCEDURE [dbo].[Marker303]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,T.AppUrlName,CAST(((SpentInHours*1.0)/CASE WHEN CAST(ISNULL(TotalSpentHours,0) AS int) = 0 THEN 1 ELSE  (TotalSpentHours*1.0) END)*100 AS decimal(10,2)) SpentInHours  FROM (
	SELECT TOP(1000) *,SUM(SpentInHours) Over()TotalSpentHours  FROM (SELECT UA.UserId,ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +  
	( DATEPART(MI, SpentTime) * 60000 )     
	+ DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime))/ 3600000.0,3) AS SpentInHours 
	,UA.AbsoluteAppName AS AppUrlName  
	FROM UserActivityTime UA       
	LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId 
	WHERE UserId = ''@OperationsPerformedBy''   
	AND IsApp = 1    
	AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date) AND UA.InActiveDateTime IS NULL 
	GROUP BY UA.UserId,UA.AbsoluteAppName) T ORDER BY SpentInHours DESC)T' WHERE CustomWidgetName = 'My app usage' AND CompanyId = @CompanyId


	UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours FROM(
SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
	FROM (SELECT UA.UserId,ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
	( DATEPART(MI, SpentTime) * 60000 )       
	+ DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime))/ 3600000.0,3) AS SpentInHours
	,UA.AbsoluteAppName AS AppUrlName    
	FROM UserActivityTime UA   
	LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId 
	WHERE UserId = ''@OperationsPerformedBy''      
	AND IsApp = 0       
	AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date) AND UA.InActiveDateTime IS NULL
	GROUP BY UA.UserId,UA.AbsoluteAppName) T ORDER BY SpentInHours DESC)Z' WHERE CustomWidgetName = 'My web usage' AND CompanyId = @CompanyId
	
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT ApplicationName,CAST((SpentValue*1.0/CASE WHEN CAST(ISNULL(OverallSpentValue,0) AS int) = 0 THEN 1 ELSE (OverallSpentValue*1.0) END)*100 AS decimal(10,2)) SpentValue  FROM(
SELECT ApplicationName,SpentValue,(Sum(SpentValue) OVER ())  AS OverallSpentValue FROM (
SELECT TOP 5 ApplicationName, SpentValue FROM (
						SELECT AppUrlImage, ApplicationName, 
								CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
								( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
								SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, CompanyId
							FROM (
						SELECT A.AppUrlImage,UA.AbsoluteAppName AS ApplicationName,
							  CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
							( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
							SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, U.CompanyId 
						FROM [User] AS U  					
							INNER JOIN Employee AS E  ON U.Id = E.UserId
							INNER JOIN (SELECT MACAddress,ApplicationId,AbsoluteAppName,ApplicationTypeId,SpentTime
							                   ,UserId,CreatedDateTime,0 AS IsIdleRecord
							            FROM UserActivityTime
									    WHERE InActiveDateTime IS NULL
										UNION ALL
										SELECT '''',NULL,''Idle Time'',''A5149B84-7074-4098-A1E4-6C218CA4DE5D'',CONVERT(VARCHAR, DATEADD(S,TotalIdleTime * 60, 0), 108)
										     ,UserId,IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date),1 AS IsIdleRecord
										FROM [dbo].[Ufn_GetUserIdleTime](IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date),IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date),''@CompanyId'')
									   ) AS UA ON (U.Id = UA.UserId)
									   AND (CONVERT(DATE,UA.CreatedDateTime) = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date))
							INNER JOIN (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](NULL, NULL, NULL, ''@OperationsPerformedBy'', NULL)) UInner ON UInner.UserId = U.Id
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id
								       AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)
									   AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)))
							LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
							WHERE U.CompanyId = ''@CompanyId''
							AND (U.Id = ''@OperationsPerformedBy'')
                            GROUP BY  UA.MACAddress,UA.ApplicationId,UA.AbsoluteAppName,A.AppUrlImage, U.CompanyId
						    UNION ALL
							SELECT AppUrlImage,AbsoluteAppName AS ApplicationName,SpentTime,(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, NULL AS CompanyId
							FROM UserActivityHistoricalData UAH
							     INNER JOIN Employee AS E ON UAH.UserId = E.UserId
							     INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id 
								 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date) 
								             AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)))
							WHERE UAH.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)
							      AND UAH.CompanyId = ''@CompanyId''
							      AND (E.UserId = ''@OperationsPerformedBy'')
						) T WHERE T.ApplicationName IS NOT NULL AND T.ApplicationName <> ''''
						GROUP BY AppUrlImage, ApplicationName, CompanyId
						)TT
						Order by SpentTime desc) T
						GROUP BY  ApplicationName,SpentValue)Z' WHERE CustomWidgetName = 'Top five websites and applications' AND CompanyId = @CompanyId
	
	
 UPDATE CustomAppDetails SET YCoOrdinate = 'Productive Hours,UnProductive Hours,Neutral Hours',VisualizationType = 'column'
 WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Weekly activity' AND CompanyId = @CompanyId) 
 AND VisualizationName = 'Weekly activity_stacked column chart' AND VisualizationType = 'stackedcolumn'
	
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(Da.[Date],''dd-MMM-yyyy'') AS Date,ISNULL(P.Productive,0)[Productive Hours],ISNULL(P.UnProductive,0)[UnProductive Hours],ISNULL(P.Neutral,0)[Neutral Hours] 
			 FROM  (SELECT CONVERT(DATE,DATEADD(DAY,NUMBER+1,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)))) AS [Date]     
			        FROM Master..SPT_VALUES
			        WHERE number < DATEDIFF(DAY,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)),IIF(@Date IS NULL,GETDATE(),@Date)) AND [type] = ''p''
			 ) Da 
			 LEFT JOIN  (SELECT CONVERT(DATE,CreatedDateTime) AS [Date]  ,productive AS Productivemin  
			 ,IIF(Productive/60 > 0,CONVERT(DECIMAl(10,2),Productive/60),0) Productive  
			 ,IIF(UnProductive/60 > 0,CONVERT(DECIMAl(10,2),UnProductive/60),0) UnProductive 
			 ,IIF(Neutral/60 > 0,CONVERT(DECIMAl(10,2),Neutral/60),0) Neutral 
			 FROM  (SELECT CreatedDateTime,ApplicationTypeName 
			    ,CONVERT(DECIMAL,ISNULL(T.TotalTime,0)) AS TotalTime  
			 from (SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime,ApplicationTypeName  
			 ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 )
			 + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
			 FROM [User] AS UM                           
			 INNER JOIN (SELECT UserId,UA.CreatedDateTime,SpentTime,ApplicationTypeName
			 FROM UserActivityTime AS UA              
			 JOIN ApplicationType [AT] ON [AT].Id = UA.ApplicationTypeId 
			 WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date))) AND CONVERT(DATE,IIF(@Date IS NULL,GETDATE(),@Date)) 
			 AND UA.InActiveDateTime IS NULL                             
			 UNION ALL                 
			 SELECT UserId,CreatedDateTime,SpentTime,ApplicationTypeName 
			 FROM UserActivityHistoricalData UAH                 
			 WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date))) AND CONVERT(DATE,IIF(@Date IS NULL,GETDATE(),@Date))   
			 AND UAH.CompanyId = ''@CompanyId''                                          
			 ) UAT ON UAT.UserId = UM.Id                
			 GROUP BY UM.Id,UAT.CreatedDateTime,ApplicationTypeName) T WHERE T.UserId=''@OperationsPerformedBy''     
			 ) Pvt        PIVOT( SUM([TotalTime])              
			 FOR ApplicationTypeName IN ([Neutral],[Productive],[UnProductive]))PivotTab) P ON P.[Date] = Da.[Date]' WHERE CustomWidgetName = 'Weekly activity' AND CompanyId = @CompanyId

END
GO