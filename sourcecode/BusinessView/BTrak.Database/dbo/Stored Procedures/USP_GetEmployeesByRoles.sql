---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2019-09-17 00:00:00.000'
---- Purpose      To Get the Employees By Roles
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeesByRoles] @OperationPerformedBy='74615421-4968-4534-BF88-E0A6DB75DC93'

CREATE PROCEDURE [dbo].[USP_GetEmployeesByRoles](
@RoleId XML = NULL,
@BranchId XML = NULL,
@OperationPerformedBy UNIQUEIDENTIFIER,
@EntityId UNIQUEIDENTIFIER = NULL,
@IsAllEmployee BIT = NULL
)
AS
BEGIN
SET NOCOUNT ON
   BEGIN TRY
		IF (@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationPerformedBy)
        IF (@HavePermission = '1')
        BEGIN
		IF(@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

			DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationPerformedBy)

			DECLARE @BranchIdList TABLE
			(
				BranchId UNIQUEIDENTIFIER NULL
			)

			DECLARE @RoleIdList TABLE
			(
				RoleId UNIQUEIDENTIFIER NULL
			)

				INSERT INTO @BranchIdList VALUES( '00000000-0000-0000-0000-000000000000' )
				INSERT INTO @RoleIdList VALUES( '00000000-0000-0000-0000-000000000000' )
				IF(@BranchId IS NOT NULL)
				BEGIN
						DELETE FROM @BranchIdList WHERE BranchId = '00000000-0000-0000-0000-000000000000'
						INSERT INTO @BranchIdList (BranchId)
						SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
						FROM  @BranchId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
				END
				IF(@RoleId IS NOT NULL)
				BEGIN
						DELETE FROM @RoleIdList WHERE RoleId = '00000000-0000-0000-0000-000000000000'
						INSERT INTO @RoleIdList (RoleId)
						SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
						FROM  @RoleId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
				END

				IF(@IsAllEmployee = 1)
				BEGIN

					SELECT DISTINCT U.Id UserId,
							CONCAT(U.FirstName,' ',U.SurName) AS [Name], UR.RoleId
							FROM [User] AS U
							LEFT JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
							JOIN @RoleIdList AS RI ON UR.RoleId = RI.RoleId OR RI.RoleId = '00000000-0000-0000-0000-000000000000'
							INNER JOIN Employee AS E ON E.UserId = U.Id 
							INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
									 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
									 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							JOIN @BranchIdList AS BI ON BI.BranchId = EB.BranchId OR BI.BranchId = '00000000-0000-0000-0000-000000000000'
							--INNER JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationPerformedBy, @CompanyId) ret
							--		ON ret.ChildId = U.Id AND U.InactiveDateTime IS NULL
							WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
							AND (@IsAllEmployee = 1 OR @CanAccessAllEmployee > 0
								 OR EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationPerformedBy))
								 --OR EB.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId)
								)
							GROUP BY U.Id,CONCAT(U.FirstName,' ',U.SurName), UR.RoleId
							ORDER BY CONCAT(U.FirstName,' ',U.SurName)
				END
				ELSE
				BEGIN
				CREATE TABLE #TrackStatusId
						(
						 Id UNIQUEIDENTIFIER,
						 UserId UNIQUEIDENTIFIER,
						 UserName NVARCHAR(100),
						 ProfileImage NVARCHAR(MAX),
						 IsOff BIT
						)

						CREATE TABLE #TrackTable
						(
						 Id UNIQUEIDENTIFIER,
						 UserId UNIQUEIDENTIFIER,
						 UserName NVARCHAR(100),
						 ProfileImage NVARCHAR(MAX),
						 IsOff BIT,
						 ScreenShotFrequency INT,
						 Multiplier INT
						)

						INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage, IsOff)
						SELECT DISTINCT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage,
									 (CASE WHEN ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off')
																					THEN 0 ELSE 1 END)
										FROM ActivityTrackerUserConfiguration AS A 
										JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
										JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.InactiveDateTime IS NULL
										JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
										INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
													 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
										JOIN RoleFeature AS RF ON RF.RoleId = UR.RoleId AND RF.InActiveDateTime IS NULL 
										WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL AND E.UserId = U.Id
												AND (@IsAllEmployee = 1 OR @CanAccessAllEmployee > 0 
													 OR EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationPerformedBy))
													)
												AND E.TrackEmployee = 1 AND
												RF.FeatureId IN (SELECT F.Id FROM Feature AS F
													WHERE FeatureName = 'Can have activity tracker') 

						INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage, IsOff)
						SELECT DISTINCT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage,
									 (CASE WHEN ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off')
																					THEN 0 ELSE 1 END)
										FROM ActivityTrackerRoleConfiguration AS A 
										JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
										JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
										JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
										INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
													 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
										JOIN RoleFeature AS RF ON RF.RoleId = UR.RoleId AND RF.InActiveDateTime IS NULL 
										WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
												AND (@IsAllEmployee = 1 OR @CanAccessAllEmployee > 0 
													 OR EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationPerformedBy))
													)
												AND A.ComapnyId = @CompanyId AND U.Id NOT IN (SELECT UserId FROM #TrackStatusId) AND
												RF.FeatureId IN (SELECT F.Id FROM Feature AS F
													WHERE FeatureName = 'Can have activity tracker') 

						--INSERT INTO #TrackTable (Id, UserId, UserName, ProfileImage, IsOff, ScreenShotFrequency, Multiplier)
						--SELECT T.Id, T.UserId, T.UserName, T.ProfileImage, T.IsOff, AU.ScreenShotFrequency, AU.Multiplier
						--		FROM #TrackStatusId AS T
						--		LEFT JOIN ActivityTrackerUserConfiguration AS AU ON AU.InActiveDateTime IS NULL AND AU.UserId = T.UserId
						--		JOIN Employee AS E ON E.UserId = T.UserId
						--		WHERE AU.ComapnyId = @CompanyId AND E.TrackEmployee = 1
						
						--IF((SELECT COUNT(*) FROM ActivityTrackerScreenShotFrequency WHERE ComapnyId = @CompanyId) > 0 OR (SELECT COUNT(*) FROM ActivityTrackerScreenShotFrequencyUser WHERE ComapnyId = @CompanyId) > 0)
						--BEGIN
						--	INSERT INTO #TrackTable (Id, UserId, UserName, ProfileImage, IsOff, ScreenShotFrequency, Multiplier)
						--	SELECT T.Id, T.UserId, T.UserName, T.ProfileImage, T.IsOff, ISNULL(AU.ScreenShotFrequency, A.ScreenShotFrequency), ISNULL(AU.Multiplier, A.Multiplier)
						--			FROM #TrackStatusId AS T
						--			LEFT JOIN ActivityTrackerScreenShotFrequencyUser AS AU ON AU.InActiveDateTime IS NULL AND AU.UserId = T.UserId
						--			LEFT JOIN ActivityTrackerScreenShotFrequency AS A ON A.InActiveDateTime IS NULL
						--			JOIN UserRole AS UR ON UR.UserId = T.UserId AND UR.RoleId = A.RoleId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
						--			--JOIN Employee AS E ON E.UserId = T.UserId
						--			WHERE (A.ComapnyId = @CompanyId OR A.ComapnyId IS NULL) AND T.UserId NOT IN (SELECT UserId FROM #TrackTable)
						--					--AND (E.TrackEmployee = 0 OR E.TrackEmployee IS NULL)
						--			ORDER BY A.ScreenShotFrequency , A.Multiplier DESC	

						--END
						--ELSE
						--BEGIN
						--	INSERT INTO #TrackTable (Id, UserId, UserName, ProfileImage, IsOff, ScreenShotFrequency, Multiplier)
						--	SELECT T.Id, T.UserId, T.UserName, T.ProfileImage, T.IsOff, 0, 0
						--			FROM #TrackStatusId AS T
						--			WHERE T.UserId NOT IN (SELECT UserId FROM #TrackTable)
						--END
						
						INSERT INTO #TrackTable (Id, UserId, UserName, ProfileImage, IsOff, ScreenShotFrequency, Multiplier)
						SELECT T.Id, T.UserId, T.UserName, T.ProfileImage, T.IsOff, 0, 0
								FROM #TrackStatusId AS T

						SELECT DISTINCT RANK() OVER(PARTITION BY T.UserId ORDER BY T.UserId DESC) Repeated,
								T.UserId, T.UserName, T.ProfileImage, T.IsOff, T.ScreenShotFrequency, T.Multiplier, A.LastActiveDateTime AS ActiveTime INTO #TrackTa
								FROM #TrackTable AS T
								LEFT JOIN ActivityTrackerStatus AS A ON A.UserId = T.UserId
								ORDER BY LastActiveDateTime DESC

						SELECT DISTINCT T.UserId, T.UserName AS [Name], UR.RoleId 
							FROM #TrackTa AS T 
							LEFT JOIN UserRole AS UR ON UR.UserId = T.UserId AND UR.InactiveDateTime IS NULL
							JOIN @RoleIdList AS RI ON UR.RoleId = RI.RoleId OR RI.RoleId = '00000000-0000-0000-0000-000000000000'
							INNER JOIN Employee AS E ON E.UserId = T.UserId
							INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
									 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
									 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationPerformedBy))
									 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							JOIN @BranchIdList AS BI ON BI.BranchId = EB.BranchId OR BI.BranchId = '00000000-0000-0000-0000-000000000000'
							--WHERE (T.IsOff = 0 OR (T.ScreenShotFrequency > 0 AND T.Multiplier > 0)) --AND T.Repeated = 1
							--GROUP BY T.UserId,T.UserName, UR.RoleId
							ORDER BY T.UserName

				END

		END
		ELSE
        BEGIN
                 RAISERROR (@HavePermission,11, 1)
        END
	END TRY
	BEGIN CATCH
       THROW
	END CATCH
END
GO