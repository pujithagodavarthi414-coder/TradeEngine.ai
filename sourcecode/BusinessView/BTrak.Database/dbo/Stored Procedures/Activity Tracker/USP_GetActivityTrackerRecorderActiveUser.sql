-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2020-06-15 00:00:00.000'
-- Purpose      To Get the activity tracker active user status
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetActivityTrackerRecorderActiveUser] @OperationsPerformedBy = '1a5bb5f0-2802-4713-876d-246bd8a206f1', @IsForScreenshots = 1, @DateFrom = '2021-05-05T00:00:00.000Z', @DateTo = '2021-05-05T00:00:00.000Z'

CREATE PROCEDURE [dbo].[USP_GetActivityTrackerRecorderActiveUser](
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@UserId UNIQUEIDENTIFIER = NULL,
@IsAllEmployee BIT = NULL,
@EntityId UNIQUEIDENTIFIER = NULL,
@IsActive BIT = NULL,
@IsForScreenshots BIT = NULL,
@IsTrailExpired BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
		BEGIN TRY

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			IF(@DateFrom IS NULL) SET @DateFrom = GETDATE()

			IF(@DateTo IS NULL) SET @DateTo = @DateFrom

			IF(@IsForScreenshots IS NULL) SET @IsForScreenshots = 0

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END

			ELSE
			BEGIN
			  	
				DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
						 
				 IF (@HavePermission = '1')
				 BEGIN			 

					IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE()));
					
					DECLARE @Temp DATETIME

					DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
											JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
											JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
											WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy)

						CREATE TABLE #TrackStatusId
						(
						 Id UNIQUEIDENTIFIER,
						 UserId UNIQUEIDENTIFIER,
						 UserName NVARCHAR(100),
						 ProfileImage NVARCHAR(MAX),
						 CanHaveActivityTracker BIT
						)

						INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage,CanHaveActivityTracker)
						SELECT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage,1
										FROM ActivityTrackerUserConfiguration AS A 
										JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
										JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
										INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
													 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
										WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL AND E.UserId = U.Id
												AND (@IsAllEmployee = 1 OR (@CanAccessAllEmployee > 0 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))) OR (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId))))
												AND E.TrackEmployee = 1
												AND (@UserId IS NULL OR U.Id = @UserId)
						GROUP BY ActivityTrackerAppUrlTypeId, U.Id,U.FirstName,U.SurName, U.ProfileImage

						INSERT INTO #TrackStatusId (Id, UserId, UserName, ProfileImage, CanHaveActivityTracker)
						SELECT ActivityTrackerAppUrlTypeId, U.Id, CONCAT(U.FirstName,' ',U.SurName), U.ProfileImage,1
										FROM ActivityTrackerRoleConfiguration AS A 
										JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
										JOIN Employee AS E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
										INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
													 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
										WHERE U.CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
												AND (@IsAllEmployee = 1 OR (@CanAccessAllEmployee > 0 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))) OR (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId))))
												AND A.ComapnyId = @CompanyId AND U.Id NOT IN (SELECT UserId FROM #TrackStatusId) 
												AND (@UserId IS NULL OR U.Id = @UserId)
						GROUP BY ActivityTrackerAppUrlTypeId, U.Id,U.FirstName,U.SurName, U.ProfileImage

						DECLARE @Time DATETIME = GETUTCDATE()

						DECLARE @Date DATE = GETUTCDATE()

						SELECT DISTINCT COUNT(1) AS ScreenshotCount, U.Id AS UserId INTO #ScreenshotCount
							FROM ActivityScreenShot AS A
							LEFT JOIN [User] AS U ON U.Id = A.UserId 
							WHERE (CONVERT(DATE,A.CreatedDateTime) BETWEEN CONVERT(DATE,@DateFrom) AND CONVERT(DATE,@DateTo)) AND A.CreatedDateTime IS NOT NULL
								AND U.CompanyId = @CompanyId
							GROUP BY U.Id
						
						SELECT DISTINCT T.UserId, T.UserName, T.ProfileImage,A.LastActiveDateTime ActiveTime,
									(CASE WHEN DATEDIFF(MINUTE,A.LastActiveDateTime,@Time) < 11 THEN 1 ELSE 0 END) AS [Status],
							(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.LunchBreakStartTime AND (TT.LunchBreakEndTime IS NULL OR @Time <= TT.LunchBreakEndTime) 
									AND TT.UserId = T.UserId AND TT.Date = @Date) = @Time OR
									(SELECT @Time FROM UserBreak AS U WHERE ((@Time BETWEEN U.BreakIn AND U.BreakOut) OR (@Time>=U.BreakIn AND U.BreakOut IS NULL)) AND  U.UserId = T.UserId
									   						  AND U.Date = @Date) = @Time
									THEN 1
									ELSE 0 
									END) AS IsBreak,
							(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.InTime AND TT.OutTime IS NULL AND TT.Date = CONVERT(date, @Date) AND TT.UserId = T.UserId) = @Time
								THEN 1
								ELSE 0
								END) AS IsOnline,
							ISNULL(L.IsApproved, 0) AS IsLeave,
									ISNULL(S.ScreenshotCount, 0) AS ScreenshotCount
								INTO #Tra
								FROM #TrackStatusId AS T
								LEFT JOIN #ScreenshotCount AS S ON S.UserId = T.UserId
								LEFT JOIN (SELECT UserId, MAX(LastActiveDateTime) AS LastActiveDateTime 
			                               FROM [User] U INNER JOIN ActivityTrackerStatus UTS ON UTS.UserId = U.Id AND U.CompanyId = @CompanyId
	                                       GROUP BY UserId) A ON A.UserId = T.UserId
								LEFT JOIN (SELECT UserId, LS.IsApproved
										   FROM LeaveApplication LA
												INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
										   WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
												 AND ISNULL(LS.IsApproved,0) = 1 AND LS.IsApproved IS NOT NULL
												 AND ISNULL(LA.IsDeleted,0) = 0
												 AND LS.CompanyId = @CompanyId) AS L ON L.UserId  = T.UserId
								WHERE (ISNULL(S.ScreenshotCount, 0) > 0 OR T.CanHaveActivityTracker = 1) --TODO : This condition is always true
								ORDER BY T.UserName ASC

							SELECT UserId, UserName, ProfileImage, ActiveTime, [Status], IsBreak, IsLeave, ScreenshotCount FROM #Tra
									WHERE (((@IsActive IS NULL OR @IsActive = 0 ) OR (@IsActive = 1 AND (IsOnline = 0 OR IsBreak = 1)))
										  AND (@UserId IS NULL OR UserId = @UserId))
										  --AND (@IsForScreenshots <> 1 OR (@IsForScreenshots = 1 AND ScreenshotCount > 0)))
									ORDER BY CASE WHEN @IsForScreenshots = 1 THEN ScreenshotCount END DESC,
									         CASE WHEN @IsForScreenshots <> 1 THEN UserName END ASC

				 END
				 
				 ELSE
				 BEGIN
				   		RAISERROR (@HAVEPERMISSION,11, 1)
				 END
		    END
		END TRY
		
		BEGIN CATCH
        
		    THROW

	    END CATCH
END
GO