CREATE PROCEDURE [dbo].[Marker291]
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
AS
BEGIN

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT TOP 5 ApplicationName, SpentValue FROM (
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
							SELECT AppUrlImage,[ApplicationTypeName] AS ApplicationName,SpentTime,(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, NULL AS CompanyId
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
						Order by SpentTime desc'
	WHERE CompanyId = @CompanyId
	AND Customwidgetname = 'Top five websites and applications'
	
	UPDATE CustomWidgets SET WidgetQuery ='
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
							AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
								       OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
                            GROUP BY  UA.MACAddress,UA.ApplicationId,UA.AbsoluteAppName,A.AppUrlImage,U.CompanyId
						    UNION ALL
							SELECT AppUrlImage,[ApplicationTypeName] AS ApplicationName,SpentTime,(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) SpentValue, NULL AS CompanyId
							FROM UserActivityHistoricalData UAH
							     INNER JOIN Employee AS E ON UAH.UserId = E.UserId
							     INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id 
								 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)
								 AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)))
							WHERE UAH.CreatedDateTime = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date)
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
						Order by SpentTime desc'
	WHERE CompanyId = @CompanyId
	AND Customwidgetname = 'Team top 5 websites and applications'

END
GO