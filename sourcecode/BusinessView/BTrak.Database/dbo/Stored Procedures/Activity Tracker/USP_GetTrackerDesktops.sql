-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-16 00:00:00.000'
-- Purpose      To Get Tracker Desktops
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetTrackerDesktops] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTrackerDesktops]
(
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyUrl NVARCHAR(500) = NULL,
	@UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @CompanyIdFromUrl UNIQUEIDENTIFIER

		IF (@HavePermission = '1')
	    BEGIN
			DECLARE @SkipCompanyCheck BIT = 0
			IF(@SearchText = '') SET @SearchText = NULL

			SET @SearchText = '%'+ @SearchText +'%'

			SET @CompanyIdFromUrl = (SELECT TOP 1 Id FROM [dbo].[Company] WHERE SiteAddress = @CompanyUrl ORDER BY CreatedDateTime DESC)

			IF(@CompanyIdFromUrl IS NULL AND @CompanyUrl IS NOT NULL)
			BEGIN
				SET @SkipCompanyCheck = 1
			END

			DECLARE @ShiftConfig TABLE
			(
				ShiftStartTime TIME NULL,
				ShiftEndTime TIME NULL,
				IsActiveShift BIT NULL,
				UserId UNIQUEIDENTIFIER
			)
			INSERT INTO @ShiftConfig (ShiftStartTime, ShiftEndTime, IsActiveShift, UserId)
			SELECT ShiftStartTime, ShiftEndTime, IsActiveShift, UserId FROM dbo.Ufn_GetUserShiftStatus(null, null, @CompanyId)

			DECLARE @UserShiftStartTime TIME
			DECLARE @UserShiftEndTime TIME
			SET @UserShiftStartTime = (SELECT TOP 1 ShiftStartTime FROM @ShiftConfig WHERE UserId = @UserId)
			SET @UserShiftEndTime = (SELECT TOP 1 ShiftEndTime FROM @ShiftConfig WHERE UserId = @UserId)

			DECLARE @AllDeskTops TABLE
			(
				RowNumber INT,
				DesktopId UNIQUEIDENTIFIER,
				DesktopDeviceId NVARCHAR(1000),
				DesktopName NVARCHAR(500),
				CreatedDateTime datetime,
				IsDesktopAvailable BIT
			)

			INSERT INTO @AllDeskTops
			SELECT ROW_NUMBER() OVER(ORDER BY Id) AS RowNumber, ATD.Id, DesktopDeviceId, DesktopName, CreatedDateTime,0 FROM ActivityTrackerDesktop ATD
			WHERE (ATD.CompanyId = @CompanyId OR (@SkipCompanyCheck = 1 AND ATD.CompanyId IS NULL))

			DECLARE @MinRow INT = 1
			DECLARE @MaxRow INT = (SELECT MAX(RowNumber) FROM @AllDeskTops)
			DECLARE @DesktopId UNIQUEIDENTIFIER

			WHILE(@MinRow <= @MaxRow)
			BEGIN
				SET @DesktopId = (SELECT TOP 1 DesktopId FROM @AllDeskTops WHERE RowNumber = @MinRow)
				-- if desktop not assigned to others
				IF((SELECT COUNT(*) FROM [User] WHERE DesktopId = @DesktopId) = 0)
				BEGIN
					UPDATE @AllDeskTops SET IsDesktopAvailable = 1 WHERE DesktopId = @DesktopId
				END
				-- if desktop assigned to self
				ELSE IF((SELECT COUNT(*) FROM [User] WHERE DesktopId = @DesktopId AND Id = @UserId) > 0)
				BEGIN
					UPDATE @AllDeskTops SET IsDesktopAvailable = 1 WHERE DesktopId = @DesktopId
				END
				-- if desktop assigned and available for current user shift
				ELSE IF((SELECT COUNT(*) FROM [User] WHERE DesktopId = @DesktopId) > 0 AND @UserShiftStartTime IS NOT NULL AND @UserShiftEndTime IS NOT NULL)
				BEGIN
					DECLARE @AssignedUsers TABLE
					(
						RowNumber INT,
						UserId UNIQUEIDENTIFIER
					)

					DELETE @AssignedUsers

					INSERT INTO @AssignedUsers
					SELECT ROW_NUMBER() OVER(ORDER BY Id) AS RowNumber, Id FROM [User] WHERE DesktopId = @DesktopId

					DECLARE @MinUserRow INT = 1
					DECLARE @MaxUserRow INT = (SELECT MAX(RowNumber) FROM @AssignedUsers)
					DECLARE @IsDesktopAssignable BIT = 0

					WHILE(@MinUserRow <= @MaxUserRow)
					BEGIN
						DECLARE @CurrentUserId UNIQUEIDENTIFIER
						DECLARE @CurrentUserShiftStartTime TIME
						DECLARE @CurrentUserShiftEndTime TIME
						SET @CurrentUserId = (SELECT TOP 1 UserId FROM @AssignedUsers WHERE RowNumber = @MinUserRow)
						SET @CurrentUserShiftStartTime = (SELECT TOP 1 ShiftStartTime FROM @ShiftConfig WHERE UserId = @CurrentUserId)
						SET @CurrentUserShiftEndTime = (SELECT TOP 1 ShiftEndTime FROM @ShiftConfig WHERE UserId = @CurrentUserId)

						IF(@CurrentUserShiftStartTime IS NULL OR @CurrentUserShiftEndTime IS NULL)
						BEGIN
							SET @IsDesktopAssignable = 0
							BREAK
						END
						ELSE IF
						(
							(@UserShiftEndTime <= @CurrentUserShiftStartTime AND @UserShiftEndTime < @CurrentUserShiftEndTime)
								OR
							(@UserShiftStartTime >= @CurrentUserShiftEndTime AND @UserShiftStartTime > @CurrentUserShiftStartTime)
						)
						BEGIN
							SET @IsDesktopAssignable = 1
						END
						ELSE
						BEGIN
							SET @IsDesktopAssignable = 0
							BREAK
						END

						SET @MinUserRow = @MinUserRow + 1
					END

					UPDATE @AllDeskTops SET IsDesktopAvailable = @IsDesktopAssignable WHERE DesktopId = @DesktopId

				END

				SET @MinRow = @MinRow + 1
			END

			SELECT * FROM @AllDeskTops WHERE IsDesktopAvailable = 1 ORDER BY DesktopName

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