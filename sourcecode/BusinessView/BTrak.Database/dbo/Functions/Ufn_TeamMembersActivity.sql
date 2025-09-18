CREATE FUNCTION [dbo].[Ufn_TeamMembersActivity] --TODO
(	
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @returntable TABLE
(
	UserName NVARCHAR(MAX),
	Productive DECIMAL(10,2),
	UnProductive DECIMAL(10,2),
	Neutral DECIMAL(10,2)
)
AS
BEGIN
	INSERT INTO @returntable (UserName, Productive, UnProductive, Neutral)
	SELECT Da.UserName,ISNULL(P.Productive,0)Productive,ISNULL(P.UnProductive,0)UnProductive,ISNULL(P.Neutral,0)Neutral FROM
			(SELECT U.FirstName + ' ' + ISNULL(U.Surname,' ') AS UserName,U.Id AS UserId
			        FROM [User] U 
					WHERE U.CompanyId = @CompanyId AND ((SELECT COUNT(1) FROM Feature AS F
											JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
											JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
											WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy) > 0 OR
								U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
											 (@OperationsPerformedBy,@CompanyId)WHERE (ChildId <> @OperationsPerformedBy)))
					)  Da
			LEFT JOIN
			(SELECT UserId,UserName
			,IIF(Productive/60 > 0,CONVERT(DECIMAl(10,2),Productive/60),0) Productive
			,IIF(UnProductive/60 > 0,CONVERT(DECIMAl(10,2),UnProductive/60),0) UnProductive
			,IIF(Neutral/60 > 0,CONVERT(DECIMAl(10,2),Neutral/60),0) Neutral
			FROM
			(SELECT UserId,UserName,ApplicationTypeName
			,CONVERT(DECIMAL,ISNULL(T.TotalTime,0)) AS TotalTime
				from (SELECT UM.Id AS UserId,UM.FirstName + '' + ISNULL(UM.Surname,'') AS UserName,ApplicationTypeName
			                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
									FROM [User] AS UM
			                           INNER JOIN (
									   SELECT UserId,U.FirstName + ' ' + ISNULL(U.Surname,' ') AS UserName,SpentTime,ApplicationTypeName
			                                          FROM UserActivityTime AS UA
													  JOIN ApplicationType [AT] ON [AT].Id = UA.ApplicationTypeId
													  JOIN [User] [U] ON U.Id = UA.UserId
			                                          WHERE UA.CreatedDateTime = CONVERT(DATE,GETDATE())
			                                                AND UA.InActiveDateTime IS NULL
															AND ((SELECT COUNT(1) FROM Feature AS F
																		JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
																		JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
																		JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
																		WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy) > 0 OR
															U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
																		 (@OperationsPerformedBy,@CompanyId)WHERE (ChildId <> @OperationsPerformedBy)))
			                                          UNION ALL
			                  SELECT UserId,UM.FirstName + '' + ISNULL(UM.Surname,'') AS UserName,SpentTime,ApplicationTypeName
			                  FROM UserActivityHistoricalData UAH
							  JOIN [User] UM ON UM.Id = UAH.UserId
			                  WHERE UAH.CreatedDateTime = CONVERT(DATE,GETDATE())
			                        AND UAH.CompanyId = @CompanyId
			                                        ) UAT ON UAT.UserId = UM.Id
									AND ((SELECT COUNT(1) FROM Feature AS F
																		JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
																		JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
																		JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
																		WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy) > 0 OR
															UM.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
																		 (@OperationsPerformedBy,@CompanyId)WHERE (ChildId <> @OperationsPerformedBy)))
			                        GROUP BY UM.Id,UM.FirstName + '' + ISNULL(UM.Surname,''),ApplicationTypeName) T 
									) Pvt
									PIVOT( SUM([TotalTime])
							        FOR ApplicationTypeName IN ([Neutral],[Productive],[UnProductive]))PivotTab) P ON P.UserId = Da.UserId
									ORDER BY P.UserName
	RETURN
END
