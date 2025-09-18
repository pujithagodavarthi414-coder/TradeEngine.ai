CREATE PROCEDURE [dbo].[Marker309]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  MERGE INTO [dbo].[CustomWidgets] AS Target 
        USING ( VALUES 
     ( N'Idle time','SELECT CASE WHEN NOT EXISTS(SELECT T.TotalIdleTIme) THEN ''0h 0m'' ELSE  IIF(T.TotalIdleTIme < 60,
				CAST(T.TotalIdleTIme AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalIdleTIme,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) AS VARCHAR(100))+''m'')) END [Idle Time] 
                          FROM [User] U 
						  LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetUserIdleTimeForMultipleDates]
						  (CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')) T ON T.[UserId] = U.Id  AND T.TrackedDateTime = CONVERT(DATE,GETDATE())
                           where U.Id = ''@OperationsPerformedBy''', @CompanyId)
    ,( N'Team idle hours','SELECT CASE WHEN NOT EXISTS(SELECT Main.TotalIdleTIme) THEN ''0h 0m'' ELSE  IIF(Main.TotalIdleTIme < 60,
				CAST(Main.TotalIdleTIme AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalIdleTIme,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalIdleTIme,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalIdleTIme,0)%60 AS INT) AS VARCHAR(100))+''m'')) END [Idle Time] 
				FROM
				(SELECT SUM(T.TotalIdleTIme) AS TotalIdleTIme
                          FROM [User] U 
						  LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetUserIdleTimeForMultipleDates](CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')) T ON T.[UserId] = U.Id  AND T.TrackedDateTime = CONVERT(DATE,GETDATE())
                           where U.CompanyId=''@CompanyId'' AND (0 > 0 OR
									U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy''))))Main', @CompanyId)
  ,('Weekly activity','  SELECT FORMAT(Da.[Date],''dd-MMM-yyyy'') AS Date,ISNULL(P.Productive,0)[Productive Hours],ISNULL(P.UnProductive,0)[UnProductive Hours],ISNULL(P.Neutral,0)[Neutral Hours] 
    FROM  (SELECT CONVERT(DATE,DATEADD(DAY,NUMBER+1,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)))) AS [Date]     
           FROM Master..SPT_VALUES
           WHERE number < DATEDIFF(DAY,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)),IIF(@Date IS NULL,GETDATE(),@Date)) AND [type] = ''p''
    ) Da 
    LEFT JOIN  (
    SELECT CONVERT(DATE,UAT.CreatedDateTime) AS [Date] 
    ,CONVERT(DECIMAl(10,2),UAT.Productive/3600000.0) Productive  
    ,CONVERT(DECIMAl(10,2),UAT.UnProductive/3600000.0) UnProductive 
    ,CONVERT(DECIMAl(10,2),UAT.Neutral/3600000.0) Neutral 
    FROM [User] AS UM                           
         INNER JOIN UserActivityTimeSummary UAT ON UAT.UserId = UM.Id
                    AND UAT.CompanyId = ''@CompanyId''                                          
            AND UAT.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date))) 
                                             AND CONVERT(DATE,IIF(@Date IS NULL,GETDATE(),@Date))
            AND UM.UserId = ''@OperationsPerformedBy''  
    ) P ON P.[Date] = Da.[Date]', @CompanyId)
  ,('Unproductive time','SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Unproductive Time] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(SUM(UnProductive) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (
                  SELECT UserId,CAST(CreatedDateTime AS date)CreatedDateTime,UnProductive 
                  FROM UserActivityTimeSummary UATS
                  WHERE UATS.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UATS.CompanyId = ''@CompanyId'' AND UserId = ''@OperationsPerformedBy''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''', @CompanyId)
  ,('Productive time','SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Productive Time] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(SUM(Productive) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (
                  SELECT UserId,CAST(CreatedDateTime AS date) AS CreatedDateTime,Productive
                  FROM UserActivityTimeSummary UATS
                  WHERE UATS.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UATS.CompanyId = ''@CompanyId'' AND UserId = ''@OperationsPerformedBy''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''', @CompanyId)
  ,('Team productive hours','SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Productive Time]  
			FROM(
			SELECT SUM(T.TotalTime) AS TotalTime
				from [User] UDD 
				LEFT JOIN 
				(SELECT UM.Id AS UserId,UAT.CreatedDateTime
			                        ,FLOOR(SUM(Productive) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM [User] AS UM
			                           INNER JOIN (
			                  SELECT UserId,CAST(CreatedDateTime AS date) AS CreatedDateTime,Productive
			                  FROM UserActivityTimeSummary UATS
			                  WHERE UATS.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                        AND UATS.CompanyId = ''@CompanyId'' 
			                                        ) UAT ON UAT.UserId = UM.Id
			                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId AND UDD.CompanyId = ''@CompanyId'' AND ((SELECT COUNT(1) FROM Feature AS F
															JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
															JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
															JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
															WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UDD.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))) Main', @CompanyId)
,('Neutral time',' SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Neutral time] 
	from (SELECT UserId ,CAST(CreatedDateTime AS date) CreatedDateTime ,FLOOR(SUM(Neutral) * 1.0 / 60000 * 1.0) AS TotalTime
                  FROM UserActivityTimeSummary UAH
                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UAH.CompanyId = ''@CompanyId'' AND UserId = ''@OperationsPerformedBy''
                              GROUP BY UserId,CAST(CreatedDateTime AS date))T', @CompanyId)
,('Team neutral hours','SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Neutral]  
			FROM(SELECT FLOOR(SUM(Neutral) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM (
			                  SELECT UserId,CAST(CreatedDateTime AS date) CreatedDateTime,Neutral
			                  FROM UserActivityTimeSummary UAH
			                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                        AND UAH.CompanyId = ''@CompanyId''
									AND  ((SELECT COUNT(1) FROM Feature AS F
															JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
															JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
															JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
															WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))
			                                        ) UAT) Main', @CompanyId)
,('My app usage','SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
						FROM(
						SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
							FROM (
							       SELECT UA.UserId,ROUND(TimeInMillisecond / 3600000.0,3) AS SpentInHours
							       ,UA.ApplicationName AS AppUrlName    
							       FROM UserActivityAppSummary UA   
							       WHERE UserId = ''@OperationsPerformedBy''      
							       AND UA.IsApp = 1      
							       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date)
							       GROUP BY UA.UserId,UA.ApplicationName
							    ) T ORDER BY SpentInHours DESC
							)Z ', @CompanyId)
,('Team app usage','SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
						FROM(
						SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
							FROM (
							       SELECT UA.UserId,ROUND(TimeInMillisecond / 3600000.0,3) AS SpentInHours
							       ,UA.ApplicationName AS AppUrlName    
							       FROM UserActivityAppSummary UA   
							       WHERE UserId = ''@OperationsPerformedBy''      
							       AND UA.IsApp = 1      
								   AND  ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId AND UR.InactiveDateTime IS NULL AND RF.InactiveDateTime IS NULL
		                                    WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0 OR
		                                 UA.UserId IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId'')))
							       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date) 
							       GROUP BY UA.UserId,UA.ApplicationName
							    ) T ORDER BY SpentInHours DESC)Z', @CompanyId)
,('Team web usage','SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
						FROM(
						SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
							FROM (
							       SELECT UA.UserId,ROUND(TimeInMillisecond / 3600000.0,3) AS SpentInHours
							       ,UA.ApplicationName AS AppUrlName    
							       FROM UserActivityAppSummary UA   
							       WHERE UserId = ''@OperationsPerformedBy''      
							       AND UA.IsApp = 0     
								   AND  ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId AND UR.InactiveDateTime IS NULL AND RF.InactiveDateTime IS NULL
		                                    WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0 OR
		                                 UA.UserId IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId'')))
							       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date) 
							       GROUP BY UA.UserId,UA.ApplicationName
							    ) T ORDER BY SpentInHours DESC)Z', @CompanyId)
)
	AS Source ([CustomWidgetName] , [WidgetQuery], [CompanyId])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId];
    
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT ApplicationName,CAST((SpentValue*1.0/CASE WHEN CAST(ISNULL(OverallSpentValue,0) AS int) = 0 
       THEN 1 ELSE (OverallSpentValue*1.0) END)*100 AS decimal(10,2)) SpentValue  
	   FROM(
             SELECT ApplicationName,SpentValue,(SUM(SpentValue) OVER())  AS OverallSpentValue 
             FROM (
             		SELECT TOP 5 UAS.ApplicationName,UAS.TimeInMillisecond AS SpentValue
             		FROM UserActivityAppSummary UAS
             		WHERE UAS.ApplicationName IS NOT NULL AND UAS.ApplicationName <> ''''
             		      AND (CONVERT(DATE,UAS.CreatedDateTime) = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date))
             			  AND UAS.CompanyId = ''@CompanyId''
             			  AND (UAS.UserId = ''@OperationsPerformedBy'')
                     ORDER BY UAS.TimeInMillisecond DESC
             	) T
             )Z'
	WHERE CustomWidgetName = 'Top five websites and applications' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m''
           , CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Un Productive Time]  
			FROM (SELECT FLOOR(UnProductive * 1.0 / 60000 * 1.0)
			      FROM UserActivityTimeSummary UAT
				  WHERE UAT.CreatedDateTime = CONVERT(DATE,GETDATE())
			          AND UAT.CompanyId = ''@CompanyId'' 
					   AND ((SELECT COUNT(1) FROM Feature AS F
					   			JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
					   			JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
					   			JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
					   			WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UAT.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))
				) Main'
	WHERE CustomWidgetName = 'Team un productive hours' AND CompanyId = @CompanyId
	
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT TOP 5 UAS.ApplicationName,UAS.TimeInMillisecond AS SpentValue
             		FROM UserActivityAppSummary UAS
             		WHERE UAS.ApplicationName IS NOT NULL AND UAS.ApplicationName <> ''''
             		      AND (CONVERT(DATE,UAS.CreatedDateTime) = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date))
             			  AND UAS.CompanyId = ''@CompanyId''
						  AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
								       OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
                     ORDER BY UAS.TimeInMillisecond DESC'
	WHERE CompanyId = @CompanyId AND Customwidgetname = 'Team top 5 websites and applications'
                    
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT ISNULL((SELECT IIF(Main.SpentTime < 60,CAST(Main.SpentTime AS NVARCHAR(50)) + ''m''
	                                        , CAST(CAST(ISNULL(Main.SpentTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) = 0,'''',CAST(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [System usage time]  
		                                    FROM (
		                                    	SELECT UM.Id AS UserId,
		                                    		FLOOR((UA.Neutral + UA.Productive + UA.UnProductive) * 1.0 / 60000 * 1.0) AS SpentTime
		                                    	    FROM [User] AS UM WITH (NOLOCK) 
		                                    	      INNER JOIN TimeSheet AS TS WITH (NOLOCK) ON UM.Id = TS.UserId 
		                                    	                 AND (TS.Date = CONVERT(DATE, GETDATE()))
		                                    	      INNER JOIN UserActivityTimeSummary AS UA WITH (NOLOCK) ON ( UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.Date ) 
		                                    	      WHERE CONVERT(DATE,UA.CreatedDateTime) = CONVERT(DATE, GETDATE())
		                                    	         AND UM.IsActive = 1
		                                    	         AND UM.InActiveDateTime IS NULL
		                                    		     AND UM.Id = ''@OperationsPerformedBy''
		                                    		     AND UM.CompanyId = ''@CompanyId''
        )
		                                    		Main) ,''0 h'') [System usage time]'
	WHERE CompanyId = @CompanyId AND Customwidgetname = 'System usage time'

		UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
						FROM(
						SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
							FROM (
							       SELECT UA.UserId,ROUND(TimeInMillisecond / 3600000.0,3) AS SpentInHours
							       ,UA.ApplicationName AS AppUrlName    
							       FROM UserActivityAppSummary UA   
							       WHERE UserId = ''@OperationsPerformedBy''      
							       AND UA.IsApp = 0       
							       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date) AND UA.InActiveDateTime IS NULL
							       GROUP BY UA.UserId,UA.AbsoluteAppName
							    ) T ORDER BY SpentInHours DESC
							)Z' 
	WHERE CustomWidgetName = 'My web usage' AND CompanyId = @CompanyId
	
	UPDATE CustomWidgets 
	SET WidgetQuery = 'SELECT TOP(1000)* FROM (SELECT U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name],U.Id AS UserId,Productivity
			           FROM [User] U
			           LEFT JOIN (
			           SELECT UA.UserId,ROUND(Productive/ 3600000.0,3) AS Productivity
			           FROM UserActivityTimeSummary UA
			           WHERE UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'')
			                 AND UA.CompanyId = ''@CompanyId''
			           ) T ON U.Id = T.UserId
			           WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL
			           AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			                     AND UR.InactiveDateTime IS NULL
			                     AND RF.InactiveDateTime IS NULL
			                      WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
			                OR U.Id IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
			                                )) T ORDER BY Productivity DESC' 
	WHERE CustomWidgetName = 'Team members productive hours rating' AND CompanyId = @CompanyId

	UPDATE CustomWidgets 
	SET WidgetQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY TotalTimeInHr DESC) AS [RowNumber],UserName AS [Name],TotalTimeInHr,[Month],UserId,[MonthEnd]
		FROM
		(
			SELECT UM.Id AS UserId
			,UM.FirstName + CONCAT('' '',UM.SurName) As UserName
			 ,ROUND(SUM(SpentTime * 1.0 /60.0),0) AS TotalTimeInHr
			  ,DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime) AS [Month]
			  ,EOMONTH(UAT.CreatedDateTime) AS [MonthEnd]
			  FROM [User] AS UM
			  	  INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime
				              FROM(
				                    SELECT UserId,(Neutral + Productive + UnProductive) / 60000 AS SpentTime,CreatedDateTime
			                        FROM UserActivityTimeSummary AS UA 
			                        WHERE UA.CreatedDateTime BETWEEN ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) AND ISNULL(@DateTo,EOMONTH(GETDATE()))
								    	  AND (''@UserId'' = '''' OR ''@UserId'' = UA.UserId)
								 ) T WHERE SpentTime > 480
			                  ) UAT ON UAT.UserId = UM.Id
			   GROUP BY UM.Id,UM.FirstName + CONCAT('' '',UM.SurName),DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime)
			  ,EOMONTH(UAT.CreatedDateTime)
		) MainQ' 
	WHERE CustomWidgetName = N'Employee over time report' AND CompanyId = @CompanyId

	UPDATE CustomWidgets 
	SET WidgetQuery = 'SELECT TOP (500) U.FirstName + '' '' + ISNULL(U.Surname,'' '') AS UserName,UTS.Productive,UTS.UnProductive, UTS.Neutral
                       FROM [User] U
                             LEFT JOIN UserActivityTimeSummary UTS ON UTS.UserId = U.Id
                       WHERE U.CompanyId = @CompanyId 
                       	  AND UTS.CreatedDateTime = CONVERT(DATE,GETDATE())
                             AND ((SELECT COUNT(1) FROM Feature AS F
                       						JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
                       						JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                       						JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
                       						WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = @OperationsPerformedBy) > 0 OR
                       			U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                       						 (@OperationsPerformedBy,@CompanyId)
                       		              WHERE (ChildId <> @OperationsPerformedBy)))
                       ORDER BY U.FirstName + '' '' + ISNULL(U.Surname,'' '')' 
	WHERE CustomWidgetName = N'Team members activity on single date' AND CompanyId = @CompanyId

END
GO