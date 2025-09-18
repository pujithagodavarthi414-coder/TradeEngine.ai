-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-10-30 00:00:00.000'
-- Purpose      To Get the Screenshot Frequency related information
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetActivityTrackerScreenshotFrequency] @MACAddress='8CEC4BC1C769'
CREATE PROCEDURE [dbo].[USP_GetActivityTrackerScreenshotFrequency](
@MACAddress XML= NULL,
@DeviceId NVARCHAR(500),
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	   BEGIN TRY

				 DECLARE @companyId UNIQUEIDENTIFIER = NULL,
						@ConsiderMACAddressInEmployeeScreen VARCHAR(10)	,
						@Multiplier INT = 0,
						@ScreenshotFrequency  INT = 0,
						@UserId UNIQUEIDENTIFIER,
						@Count INT = 0,
						@UserTrack BIT,
						@RandomScreenshot BIT = NULL,
						@OfflineTracking BIT = NULL,
						@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'	

				IF(@OperationsPerformedBy = @EmptyGuid OR @OperationsPerformedBy IS NULL)
				BEGIN
					SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
					IF(@OperationsPerformedBy IS NULL)
					BEGIN
						SET @OperationsPerformedBy = @EmptyGuid
					END
				END

				IF(@OperationsPerformedBy IS NOT NULL AND (SELECT IsActive FROM [User] WHERE Id = @OperationsPerformedBy AND IsActive = 1 AND InActiveDateTime IS NULL) = 1)
				BEGIN
					SET @UserId = (SELECT Id FROM [User] WHERE Id = @OperationsPerformedBy AND IsActive = 1 AND InActiveDateTime IS NULL)
					SET @companyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND IsActive = 1 AND InActiveDateTime IS NULL)

					SET @UserTrack = (SELECT TrackEmployee FROM Employee WHERE UserId = @UserId)

					IF(@UserTrack = 1)
					BEGIN
						SET @ScreenshotFrequency = (SELECT Top(1)ScreenShotFrequency FROM ActivityTrackerUserConfiguration WHERE UserId = @UserId AND ComapnyId = @companyId)
						SET @Multiplier = (SELECT Top(1)Multiplier FROM ActivityTrackerUserConfiguration WHERE UserId = @UserId AND ComapnyId = @companyId)
					END
					ELSE
					BEGIN
						IF((SELECT COUNT(1) FROM ActivityTrackerScreenShotFrequencyUser WHERE UserId = @UserId AND InActiveDateTime IS NULL) > 0)
						BEGIN
							SET @Multiplier = (SELECT Top(1)Multiplier FROM ActivityTrackerScreenShotFrequencyUser WHERE UserId = @UserId AND InActiveDateTime IS NULL ORDER BY Multiplier)
							SET @ScreenshotFrequency = (SELECT Top(1)ScreenShotFrequency FROM ActivityTrackerScreenShotFrequencyUser WHERE UserId = @UserId AND InActiveDateTime IS NULL ORDER BY Multiplier)
						END
						ELSE
						BEGIN
							SET @Count = 0
							SET @Count = (SELECT COUNT(1) FROM ActivityTrackerScreenShotFrequencyUser AS ATS
															JOIN [User] AS U ON U.Id = ATS.UserId AND U.InActiveDateTime IS NULL
															JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
														WHERE UR.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId)) AND ATS.InActiveDateTime IS NULL)

								SET @Multiplier = ISNULL((SELECT TOP(1) A.Multiplier
													FROM [User] AS U
													INNER JOIN ActivityTrackerScreenShotFrequency AS A ON A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](U.Id))
																AND A.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL 	
													WHERE U.Id = @UserId AND U.CompanyId = @companyId
													ORDER BY A.Multiplier DESC), 0)
								SET @ScreenshotFrequency = ISNULL((SELECT TOP(1) A.ScreenShotFrequency
													FROM [User] AS U
													INNER JOIN ActivityTrackerScreenShotFrequency AS A ON A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](U.Id))
																AND A.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL 	
													WHERE U.Id = @UserId AND U.CompanyId = @companyId
													ORDER BY A.ScreenShotFrequency DESC), 0)
						END
					END

					SET @RandomScreenshot = ISNULL((SELECT TOP(1) RandomScreenshot FROM ActivityTrackerScreenShotFrequency WHERE ComapnyId = @companyId), 0)

					SET @OfflineTracking = ISNULL((SELECT TOP(1) IsOfflineTracking FROM ActivityTrackerRolePermission AS A
																JOIN UserRole AS UR ON UR.RoleId = A.RoleId AND A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId))
																		AND UR.InactiveDateTime IS NULL
																			 WHERE CompanyId = @companyId
																			 ORDER BY IsOfflineTracking DESC), 0)

					SELECT @ScreenshotFrequency AS ScreenShotFrequency,@Multiplier AS Multiplier, U.Id AS UserId, U.CompanyId, @RandomScreenshot AS RandomScreenshot, @OfflineTracking AS OfflineTracking
								INTO #UserScreenshot
							FROM [User] AS U
							--INNER JOIN ActivityTrackerScreenShotFrequency AS A ON A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](U.Id))
							--			AND A.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL 	
							--LEFT JOIN ActivityTrackerRolePermission AS AR ON AR.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](U.Id)) 
							--			AND A.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND ComapnyId = @companyId
							WHERE U.Id = @UserId AND U.InActiveDateTime IS NULL AND U.CompanyId = @companyId AND U.IsActive = 1
							GROUP BY U.Id,U.CompanyId--, AR.MinimumIdelTime

							SELECT TOP(1) * FROM #UserScreenshot ORDER BY ScreenShotFrequency , Multiplier DESC

				END
			  END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END