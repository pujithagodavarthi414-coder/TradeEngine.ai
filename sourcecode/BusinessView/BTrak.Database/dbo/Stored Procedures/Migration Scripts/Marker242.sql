CREATE PROCEDURE [dbo].[Marker242]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON


	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Top five websites and applications', N'This app displays the top 5 websites and applications which are tracked on user computer',
	N'SELECT TOP 5 ApplicationName, SpentValue FROM (
						SELECT AppUrlImage, ApplicationName, 
								CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
								( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
								SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, CompanyId
							FROM (
						SELECT A.AppUrlImage,ISNULL(CONVERT(varchar(8000),UA.CommonUrl),ISNULL(UA.OtherApplication,A.AppUrlName)) AS ApplicationName,
							  CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
							( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
							SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, U.CompanyId 
						FROM [User] AS U  					
							INNER JOIN Employee AS E  ON U.Id = E.UserId
							INNER JOIN (SELECT MACAddress,ApplicationId,LTRIM(RTRIM(OtherApplication)) AS OtherApplication,LTRIM(RTRIM(CommonUrl)) AS CommonUrl,ApplicationTypeId,SpentTime
							                   ,UserId,CreatedDateTime,LTRIM(RTRIM(TrackedUrl)) AS TrackedUrl,0 AS IsIdleRecord
							            FROM UserActivityTime
									    WHERE InActiveDateTime IS NULL
										UNION ALL
										SELECT '''',NULL,''Idle Time'',NULL,''A5149B84-7074-4098-A1E4-6C218CA4DE5D'',CONVERT(VARCHAR, DATEADD(S,TotalIdleTime * 60, 0), 108)
										     ,UserId,CONVERT(DATE,GETDATE()),NULL,1 AS IsIdleRecord
										FROM [dbo].[Ufn_GetUserIdleTime](CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')
									   ) AS UA ON (U.Id = UA.UserId 
									   --AND 
									   --(IsIdleRecord = 1 
									   --OR CONVERT(DATE, UA.CreatedDateTime) = TS.Date 
									   --)
									   )
									   AND (CONVERT(DATE,UA.CreatedDateTime) BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE()))
							INNER JOIN (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](NULL, NULL, NULL, ''@OperationsPerformedBy'', NULL)) UInner ON UInner.UserId = U.Id
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id
								       AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
							WHERE U.CompanyId = ''@CompanyId''
							AND (U.Id = ''@OperationsPerformedBy'')
                            GROUP BY  UA.MACAddress,UA.ApplicationId,UA.OtherApplication,A.AppUrlName,A.AppUrlImage,UA.CommonUrl, U.CompanyId
						    UNION ALL
							SELECT AppUrlImage,ApplicationName,SpentTime,(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, NULL AS CompanyId
							FROM UserActivityHistoricalData UAH
							     INNER JOIN Employee AS E ON UAH.UserId = E.UserId
							     INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
							      AND UAH.CompanyId = ''@CompanyId''
							      AND (E.UserId = ''@OperationsPerformedBy'')
						) T WHERE T.ApplicationName IS NOT NULL AND T.ApplicationName <> ''''
						GROUP BY AppUrlImage, ApplicationName, CompanyId
						)TT
						Order by SpentTime desc', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))

	,(NEWID(), N'Productivity', N'This app displays the monthly productivity index of an employee',
		N'SELECT ISNULL(SUM(EstimatedTime),0) AS Productivity FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
		''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

	,(NEWID(), N'Neutral time', N'This app displays the current day neutral time of an employee',
		N'SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Neutral time] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
                                          FROM UserActivityTime AS UA 
                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''Neutral'')
                                          UNION ALL
                  SELECT UserId,CreatedDateTime,SpentTime
                  FROM UserActivityHistoricalData UAH
                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''Neutral''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
	,(NEWID(), N'Team productivity', N'This app displays the monthly team productivity index based on permission. If permission exists it will display count of all employees else reporting members only',
		N'SELECT U.FirstName + '' '' + ISNULL(U.Surname,'' '') AS UserName,ISNULL(SUM(ProductivityIndex),0) AS ProductivityIndex FROM ProductivityIndex AS PRI
								INNER JOIN [User] U ON U.Id = PRI.UserId
								WHERE PRI.CompanyId = ''674c8f9d-17f2-4180-96fe-6b2c946fe6a6''
									  AND PRI.CreatedDateTime BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
									  AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''d9962e84-86e4-47d0-aafa-10372a575260'') > 0 OR 
									 [UserId] IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
												 (''d9962e84-86e4-47d0-aafa-10372a575260'',''674c8f9d-17f2-4180-96fe-6b2c946fe6a6'') WHERE (ChildId <> ''d9962e84-86e4-47d0-aafa-10372a575260'')))
												 Group by userid, U.FirstName, U.Surname', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

	,(NEWID(), N'Team productive hours', N'This app displays the monthly team productive hours based on permission. If permission exists it will display productivity hours of all employees else reporting members only',
		N'SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Productive Time]  
			FROM(
			SELECT SUM(T.TotalTime) AS TotalTime
				from [User] UDD 
				LEFT JOIN 
				(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
			                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM [User] AS UM
			                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
			                                          FROM UserActivityTime AS UA 
			                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''productive'')
			                                          UNION ALL
			                  SELECT UserId,CreatedDateTime,SpentTime
			                  FROM UserActivityHistoricalData UAH
			                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''productive''
			                                        ) UAT ON UAT.UserId = UM.Id
			                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId AND UDD.CompanyId = ''@CompanyId'' AND ((SELECT COUNT(1) FROM Feature AS F
															JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
															JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
															JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
															WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UDD.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))) Main', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

	,(NEWID(), N'Team un productive hours', N'This app displays the monthly team un productivity hours based on permission. If permission exists it will display un productivity hours of all employees else reporting members only',
		N'SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Un Productive Time]  
			FROM(
			SELECT SUM(T.TotalTime) AS TotalTime
				from [User] UDD 
				LEFT JOIN 
				(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
			                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM [User] AS UM
			                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
			                                          FROM UserActivityTime AS UA 
			                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''unproductive'')
			                                          UNION ALL
			                  SELECT UserId,CreatedDateTime,SpentTime
			                  FROM UserActivityHistoricalData UAH
			                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''unproductive''
			                                        ) UAT ON UAT.UserId = UM.Id
			                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId AND UDD.CompanyId = ''@CompanyId'' AND ((SELECT COUNT(1) FROM Feature AS F
															JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
															JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
															JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
															WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UDD.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))) Main', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Team neutral hours', N'This app displays the monthly team neutral hours based on permission. If permission exists it will display neutral hours of all employees else reporting members only',
		N'SELECT IIF(Main.TotalTIme < 60,CAST(Main.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Neutral]  
			FROM(
			SELECT SUM(T.TotalTime) AS TotalTime
				from [User] UDD 
				LEFT JOIN 
				(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
			                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM [User] AS UM
			                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
			                                          FROM UserActivityTime AS UA 
			                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''neutral'')
			                                          UNION ALL
			                  SELECT UserId,CreatedDateTime,SpentTime
			                  FROM UserActivityHistoricalData UAH
			                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
			                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''neutral''
			                                        ) UAT ON UAT.UserId = UM.Id
			                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId AND UDD.CompanyId = ''@CompanyId'' AND ((SELECT COUNT(1) FROM Feature AS F
															JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
															JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
															JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
															WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR
									UDD.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))) Main', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Team idle hours', N'This app displays the monthly team idle hours based on permission. If permission exists it will display idle hours of all employees else reporting members only',
		N'SELECT CASE WHEN NOT EXISTS(SELECT Main.TotalIdleTIme) THEN ''0h 0m'' ELSE  IIF(Main.TotalIdleTIme < 60,
				CAST(Main.TotalIdleTIme AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.TotalIdleTIme,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.TotalIdleTIme,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.TotalIdleTIme,0)%60 AS INT) AS VARCHAR(100))+''m'')) END [Idle Time] 
				FROM
				(SELECT SUM(T.TotalIdleTIme) AS TotalIdleTIme
                          FROM [User] U 
						  LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetUserIdleTimeForMultipleDates](CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')) T ON T.[UserId] = U.Id  AND T.TrackedDateTime = CONVERT(DATE,GETDATE())
                           where U.CompanyId=''@CompanyId'' AND (0 > 0 OR
									U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
															 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy''))))Main', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Team top 5 websites and applications', N'This app displays the top 5 websites and applications which are tracked on team members computer based on permission. If permission exists it will display information of all employees else reporting members only',
		N'SELECT TOP 5 ApplicationName, SpentValue FROM (
						SELECT AppUrlImage, ApplicationName, 
								CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
								( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
								SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, CompanyId
							FROM (
						SELECT A.AppUrlImage,ISNULL(CONVERT(varchar(8000),UA.CommonUrl),ISNULL(UA.OtherApplication,A.AppUrlName)) AS ApplicationName,
							  CONVERT(TIME, DATEADD(MS, SUM(( DATEPART(HH, SpentTime) * 3600000 ) + 
							( DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)), 0)) AS SpentTime,
							SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, U.CompanyId 
						FROM [User] AS U  					
							INNER JOIN Employee AS E  ON U.Id = E.UserId
							INNER JOIN (SELECT MACAddress,ApplicationId,LTRIM(RTRIM(OtherApplication)) AS OtherApplication,LTRIM(RTRIM(CommonUrl)) AS CommonUrl,ApplicationTypeId,SpentTime
							                   ,UserId,CreatedDateTime,LTRIM(RTRIM(TrackedUrl)) AS TrackedUrl,0 AS IsIdleRecord
							            FROM UserActivityTime
									    WHERE InActiveDateTime IS NULL
										UNION ALL
										SELECT '''',NULL,''Idle Time'',NULL,''A5149B84-7074-4098-A1E4-6C218CA4DE5D'',CONVERT(VARCHAR, DATEADD(S,TotalIdleTime * 60, 0), 108)
										     ,UserId,CONVERT(DATE,GETDATE()),NULL,1 AS IsIdleRecord
										FROM [dbo].[Ufn_GetUserIdleTime](CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')
									   ) AS UA ON (U.Id = UA.UserId 
									   --AND 
									   --(IsIdleRecord = 1 
									   --OR CONVERT(DATE, UA.CreatedDateTime) = TS.Date 
									   --)
									   )
									   AND (CONVERT(DATE,UA.CreatedDateTime) BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE()))
							INNER JOIN (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](NULL, NULL, NULL, ''@OperationsPerformedBy'', NULL)) UInner ON UInner.UserId = U.Id
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id
								       AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
							WHERE U.CompanyId = ''@CompanyId''
							AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
								       OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
                            GROUP BY  UA.MACAddress,UA.ApplicationId,UA.OtherApplication,A.AppUrlName,A.AppUrlImage,UA.CommonUrl, U.CompanyId
						    UNION ALL
							SELECT AppUrlImage,ApplicationName,SpentTime,(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, NULL AS CompanyId
							FROM UserActivityHistoricalData UAH
							     INNER JOIN Employee AS E ON UAH.UserId = E.UserId
							     INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
							      AND UAH.CompanyId = ''@CompanyId''
							      AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
								       OR E.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
						) T WHERE T.ApplicationName IS NOT NULL AND T.ApplicationName <> ''''
						GROUP BY AppUrlImage, ApplicationName, CompanyId
						)TT
						Order by SpentTime desc', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Team members activity on single date', N'This app displays the today team productive, unproductive, neutral hours based on permission. If permission exists it will display productive, unproductive, neutral hours of all employees else reporting members only',
		N'SELECT UserName AS [UserName],Productive AS [Productive],UnProductive AS [UnProductive], Neutral AS [Neutral]
			FROM Ufn_TeamMembersActivity(''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
		,(NEWID(), N'System usage time', N'This app displays the today system usage time which is tracked time',
		N'SELECT ISNULL((SELECT IIF(Main.SpentTime < 60,CAST(Main.SpentTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.SpentTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [System usage time]  
		FROM (
			SELECT UM.Id AS UserId,
				FLOOR(SUM(( DATEPART(HH, SpentTime) * 3600000 ) + (DATEPART(MI, SpentTime) * 60000 ) + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)) * 1.0 / 60000 * 1.0) AS SpentTime
			    FROM [User] AS UM WITH (NOLOCK) 
			      INNER JOIN TimeSheet AS TS WITH (NOLOCK) ON UM.Id = TS.UserId 
			                 AND (TS.Date = CONVERT(DATE, GetDate()))
			      INNER JOIN UserActivityTime AS UA WITH (NOLOCK) ON ( UM.Id = UA.UserId AND CONVERT(DATE, UA.CreatedDateTime) = TS.Date ) 
			           AND UA.InActiveDateTime IS NULL
			      INNER JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id
			    WHERE CONVERT(DATE,UA.CreatedDateTime) = CONVERT(DATE, GetDate())
			       AND UM.IsActive = 1
			       AND UM.InActiveDateTime IS NULL
				   AND UM.Id = ''@OperationsPerformedBy''
				   AND UM.CompanyId=''@CompanyId''
			    GROUP BY UM.Id,UM.CompanyId,TS.[Date],UM.FirstName,UM.SurName,UM.UserName)Main) ,''0 h'') [System usage time] ', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
		,(NEWID(), N'Self declared time', N'This app displays total time which is calculated from start time to current time. And if user finish time exists then it is calculated to finish time',
		N'SELECT ISNULL((SELECT IIF(Main.SpentTime < 60,CAST(Main.SpentTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(Main.SpentTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Self declared time]  
		FROM(
			 SELECT ISNULL(((ISNULL(DATEDIFF(MINUTE, TS.InTime, ISNULL(TS.OutTime,GETDATE())),0) - 
			                       ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))),0) -
			 					  ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0) AS SpentTime
			             FROM TimeSheet TS
			 			LEFT JOIN UserBreak UB ON UB.[Date] = CONVERT(DATE, GetDate()) AND UB.UserId = ''@OperationsPerformedBy''
						INNER JOIN [User] US ON US.Id = TS.UserId AND US.CompanyId = ''@CompanyId''
			             WHERE TS.[Date] = CONVERT(DATE, GetDate()) AND TS.UserId = ''@OperationsPerformedBy''
			 			GROUP BY UB.UserId,UB.[Date], TS.InTime, TS.LunchBreakStartTime, TS.LunchBreakEndTime, TS.OutTime) Main),''0 h'') [Self declared time]', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Top five websites and applications'),'1','Top five websites and applications_pie','pie',NULL,'','ApplicationName','SpentValue',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productivity'),'1','Productivity_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Productivity</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Neutral time'),'1','Neutral time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Neutral time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Neutral time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'System usage time'),'1','System usage time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>System usage time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','System usage time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Self declared time'),'1','Self declared time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Self declared time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Self declared time',GETDATE(),@UserId)
	
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team top 5 websites and applications'),'1','Team top 5 websites and applications_pie','pie',NULL,'','ApplicationName','SpentValue',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team productive hours'),'1','Team productive hours_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Productive Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Productive Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team un productive hours'),'1','Team un productive hours_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Un Productive Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Un Productive Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team neutral hours'),'1','Team neutral hours_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Neutral</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Neutral',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team idle hours'),'1','Team idle hours_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Idle Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Idle Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team members activity on single date'),'1','Team members activity on single date_stacked column chart','stackedcolumn',NULL,'','UserName','Productive,UnProductive,Neutral',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team productivity'),'1','Team productivity_column chart','column',NULL,'','UserName','ProductivityIndex',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
	  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Top five websites and applications' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Productivity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Neutral time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team top 5 websites and applications' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team productive hours' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team un productive hours' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team neutral hours' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team idle hours' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team members activity on single date' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team productivity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='System usage time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Self declared time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  )
	AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
	ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
	WHEN MATCHED THEN 
	UPDATE SET
			   [WidgetId] = Source.[WidgetId],
			   [ModuleId] = Source.[ModuleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
	INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);
	
	MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the detailed usage of users related to their timesheet activity and work items in timeline view. This app displays the details of all reporting members based on selected date',N'Daily activity', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
    WHEN MATCHED THEN 
    UPDATE SET [WidgetName] = Source.[WidgetName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;
  
	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
     USING (VALUES 
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Daily activity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
     )
    AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
    ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
    WHEN MATCHED THEN 
    UPDATE SET
         [WidgetId] = Source.[WidgetId],
         [ModuleId] = Source.[ModuleId],
         [CreatedDateTime] = Source.[CreatedDateTime],
         [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
    INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]); 


	MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
    USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  0,5,23,10,5,5, 3 ,'Top five websites and applications','Top five websites and applications',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Top five websites and applications' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Top five websites and applications' AND VisualizationName = 'Top five websites and applications_pie' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  37,10,13,5,5,5, 3 ,'Productivity','Productivity',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Productivity' AND VisualizationName = 'Productivity_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  37,5,13,5,5,5, 3 ,'Neutral time','Neutral time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Neutral time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Neutral time' AND VisualizationName = 'Neutral time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  30,0,10,5,5,5, 3 ,'System usage time','System usage time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'System usage time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'System usage time' AND VisualizationName = 'System usage time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  21,0,9,5,5,5, 3 ,'Self declared time','Self declared time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Self declared time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Self declared time' AND VisualizationName = 'Self declared time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  0,26,50,11,5,5, 3 ,'Daily activity','Daily activity',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			    [X] = Source.[X],	
    			    [Y] = Source.[Y],	
    			    [Col] = Source.[Col],	
    			    [Order] = Source.[Order],	
    			    [Row] = Source.[Row],	
    			    [MinItemCols] = Source.[MinItemCols],	
    			    [MinItemRows] = Source.[MinItemRows],	
                    [DashboardName] = Source.[DashboardName],
    			    [Name] = Source.[Name],	
    			    [CustomWidgetId] = Source.[CustomWidgetId],	
    			    [IsCustomWidget] = Source.[IsCustomWidget],	
    			    [CreatedDateTime] = Source.[CreatedDateTime],
    			    [CompanyId] = Source.[CompanyId],
    			    [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
              ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);		

		UPDATE dbo.[WorkspaceDashboards] SET X = 0, Y = 0, COL = 10, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Start time'
		UPDATE dbo.[WorkspaceDashboards] SET X = 10, Y = 0, COL = 11, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Finish time'
		UPDATE dbo.[WorkspaceDashboards] SET X = 23, Y = 5, COL = 14, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Productive time'
		UPDATE dbo.[WorkspaceDashboards] SET X = 40, Y = 0, COL = 10, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Idle time'
		UPDATE dbo.[WorkspaceDashboards] SET X = 23, Y = 10, COL = 14, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Unproductive time'
		UPDATE dbo.[WorkspaceDashboards] SET X = 0, Y = 15, COL = 50, [Row] = 11 WHERE CompanyId = @CompanyId AND DashboardName = 'Weekly activity'
		UPDATE dbo.[WorkspaceDashboards] SET X = 0, Y = 0, COL = 9, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Team members'
		UPDATE dbo.[WorkspaceDashboards] SET X = 9, Y = 0, COL = 10, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Working'
		UPDATE dbo.[WorkspaceDashboards] SET X = 19, Y = 0, COL = 10, [Row] = 5 WHERE CompanyId = @CompanyId AND DashboardName = 'Late'
END
GO