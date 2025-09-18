CREATE PROCEDURE [dbo].[Marker313]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  UPDATE CustomWidgets 
	SET WidgetQuery = '  SELECT FORMAT(Da.[Date],''dd-MMM-yyyy'') AS Date,ISNULL(P.Productive,0)[Productive Hours],ISNULL(P.UnProductive,0)[UnProductive Hours],ISNULL(P.Neutral,0)[Neutral Hours] 
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
            AND UAT.UserId = ''@OperationsPerformedBy''  
    ) P ON P.[Date] = Da.[Date]'
	WHERE CustomWidgetName = N'Weekly activity' AND CompanyId = @CompanyId

    UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
				FROM(
				SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
					FROM (
					       SELECT UA.UserId,ROUND(TimeInMillisecond / 1000.0,3) AS SpentInHours
					       ,UA.ApplicationName AS AppUrlName    
					       FROM UserActivityAppSummary UA   
					       WHERE UserId = ''@OperationsPerformedBy''      
					       AND UA.IsApp = 0       
					       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date)
					    ) T ORDER BY SpentInHours DESC
					)Z' 
	WHERE CustomWidgetName = 'My web usage' AND CompanyId = @CompanyId

    UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
						FROM(
						SELECT TOP(1000) * ,SUM(SpentInHours) OVER() TotalValue
							FROM (
							       SELECT UA.UserId,ROUND(TimeInMillisecond / 1000.0,3) AS SpentInHours
							       ,UA.ApplicationName AS AppUrlName    
							       FROM UserActivityAppSummary UA   
							       WHERE UserId = ''@OperationsPerformedBy''      
							       AND UA.IsApp = 1      
							       AND UA.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,''@CurrentDateTime''),@Date)
							    ) T ORDER BY SpentInHours DESC
							)Z' 
	WHERE CustomWidgetName = 'My app usage' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = N'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
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
							    ) T ORDER BY SpentInHours DESC)Z' 
	WHERE CustomWidgetName = N'Team app usage' AND CompanyId = @CompanyId

	UPDATE CustomWidgets 
	SET WidgetQuery = 'SELECT TOP (500) U.FirstName + '' '' + ISNULL(U.Surname,'' '') AS UserName
	                   ,CONVERT(DECIMAl(10,2),UTS.Productive/3600000.0) AS Productive
					   ,CONVERT(DECIMAl(10,2),UTS.UnProductive/3600000.0) AS UnProductive
					   ,CONVERT(DECIMAl(10,2),UTS.Neutral/3600000.0) AS Neutral
                       FROM [User] U
                             LEFT JOIN UserActivityTimeSummary UTS ON UTS.UserId = U.Id
                       WHERE U.CompanyId = ''@CompanyId'' 
                       	  AND UTS.CreatedDateTime = CONVERT(DATE,GETDATE())
                             AND ((SELECT COUNT(1) FROM Feature AS F
                       						JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
                       						JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                       						JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
                       						WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
                       			U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                       						 (''@OperationsPerformedBy'',''@CompanyId'')
                       		              WHERE (ChildId <> ''@OperationsPerformedBy'')))
                       ORDER BY U.FirstName + '' '' + ISNULL(U.Surname,'' '')' 
	WHERE CustomWidgetName = N'Team members activity on single date' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT ApplicationName,CAST((SpentValue*1.0/CASE WHEN CAST(ISNULL(OverallSpentValue,0) AS int) = 0 
	      THEN 1 ELSE (OverallSpentValue*1.0) END)*100 AS decimal(10,2)) SpentValue  
		   FROM ( SELECT *,(SUM(SpentValue) OVER())  AS OverallSpentValue  
		         FROM (SELECT TOP 5 UAS.ApplicationName,(UAS.TimeInMillisecond/60000) AS SpentValue
	            		FROM UserActivityAppSummary UAS
	            		WHERE UAS.ApplicationName IS NOT NULL AND UAS.ApplicationName <> ''''
	            		      AND (CONVERT(DATE,UAS.CreatedDateTime) = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date))
	            			  AND UAS.CompanyId = ''@CompanyId''
							  AND ((SELECT COUNT(1) FROM Feature AS F
													JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
													JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
													JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
													WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
									       OR UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
	                    ORDER BY UAS.TimeInMillisecond DESC) T ) Z' WHERE CustomWidgetName = 'Team top 5 websites and applications' AND CompanyId = @CompanyId

						 UPDATE CustomWidgets SET WidgetQuery ='SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m''
           , CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Un Productive Time]  
			FROM (SELECT FLOOR(UnProductive * 1.0 / 60000 * 1.0) TotalTime
			      FROM UserActivityTimeSummary UAT
				  WHERE UAT.CreatedDateTime = CONVERT(DATE,GETDATE())
			          AND UAT.CompanyId = ''@CompanyId'' 
					   AND ((SELECT COUNT(1) FROM Feature AS F
					   			JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
					   			JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
					   			JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
					   			WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UAT.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))
				) Main' WHERE CustomWidgetName = 'Team un productive hours' AND CompanyId = @CompanyId
	 
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT UserId,AppUrlName,CAST(((SpentInHours*1.0)/ CASE WHEN CAST(ISNULL(TotalValue,0) AS int) = 0 THEN 1 ELSE (TotalValue*1.0) END)*100 AS decimal(10,2))SpentInHours 
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
							    ) T ORDER BY SpentInHours DESC)Z' WHERE CustomWidgetName = 'Team web usage' AND CompanyId = @CompanyId

        UPDATE CustomWidgets SET WidgetQuery = 'SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Unproductive Time] 
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
                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''' WHERE CustomWidgetName = 'Unproductive time' AND CompanyId = @CompanyId

END
GO