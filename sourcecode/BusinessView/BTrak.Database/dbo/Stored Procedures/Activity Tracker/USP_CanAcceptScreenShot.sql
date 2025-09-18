-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-23 00:00:00.000'
-- Purpose      To Check the screenShot is taken while working time of an user
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_CanAcceptScreenShot] @MACAddress = '8C3B2H1E7000',@OperationsPerformedBy = 'AD3867FB-15D3-4790-B6B0-BD85A6F27456'

CREATE PROCEDURE [dbo].[USP_CanAcceptScreenShot]
(
	@MACAddress XML = NULL,
	@DeviceId NVARCHAR(500) = NULL,
    @ScreenShotDate DATETIME2 = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeZone NVARCHAR(500)
)
AS
BEGIN

SET NOCOUNT ON
	BEGIN  TRY
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = NULL,
			@UserId UNIQUEIDENTIFIER,
			@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
			@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop WHERE DesktopDeviceId = @DeviceId),
			@TimeZoneName NVARCHAR(500),
			@TimeZoneAbbrevation NVARCHAR(50)

	IF(@OperationsPerformedBy = @EmptyGuid)
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
		SET @CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND IsActive = 1 AND InActiveDateTime IS NULL)
	
	END
	ELSE
	
	DECLARE @ActivityToken NVARCHAR(800)
	SET @ActivityToken = (SELECT TOP 1 ActivityToken FROM UserActivityToken WHERE 
		(UserId = @UserId)
		OR
		(@DesktopId = DesktopId AND @OperationsPerformedBy = @EmptyGuid)
	)

	SET @TimeZoneName = (SELECT TOP 1 TimeZoneName FROM TimeZone WHERE TimeZone = @TimeZone)
	SET @TimeZoneAbbrevation = (SELECT TOP 1 TimeZoneAbbreviation FROM TimeZone WHERE TimeZone = @TimeZone)

	IF(@UserId IS NOT NULL)
	BEGIN
	
		DECLARE @ActivityId UNIQUEIDENTIFIER = NEWID()

		DECLARE @Intime DATETIMEOFFSET = NULL,@LunchStartTime DATETIMEOFFSET = NULL,@LunchEndTime DATETIMEOFFSET = NULL
		    ,@OutTime DATETIMEOFFSET = NULL,@BreakStartTime DATETIMEOFFSET = NULL,@BreakEndTime DATETIMEOFFSET = NULL
	
		SELECT @Intime = InTime,@OutTime = OutTime,@LunchStartTime = LunchBreakStartTime,@LunchEndTime = LunchBreakEndTime
	    FROM TimeSheet WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@ScreenShotDate)
	
		SELECT @BreakStartTime = BreakIn, @BreakEndTime = BreakOut 
					FROM UserBreak WITH (NOLOCK)
	                WHERE UserId = @UserId AND CONVERT(DATE,[Date]) = CONVERT(DATE,@ScreenShotDate) 
					      AND BreakIn = (SELECT MAX(BreakIn) 
                                         FROM UserBreak WHERE UserId = @UserId AND CONVERT(DATE,[Date]) = CONVERT(DATE,@ScreenShotDate))

		DECLARE @IsTrack INT = (SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = 'Can have activity tracker' AND U.Id = @UserId)

		DECLARE @ConsiderPunchCard BIT = (SELECT TOP 1 ConsiderPunchCard FROM ActivityTrackerRoleConfiguration AS A 
						JOIN [User] AS U ON U.CompanyId = A.ComapnyId
						JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
						WHERE U.Id = @UserId AND A.ComapnyId = @CompanyId
						ORDER BY ConsiderPunchCard DESC)
						
		IF(@IsTrack = 0)
		BEGIN 
						
			SELECT @UserId AS UserId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
						
		END
		ELSE IF(@Intime IS NULL AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF(@Intime IS NOT NULL AND @LunchStartTime IS NOT NULL AND @ScreenShotDate > @LunchStartTime AND @LunchEndTime IS NULL AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF(@Intime IS NOT NULL AND @LunchStartTime IS NOT NULL AND @ScreenShotDate > @LunchStartTime AND @ScreenShotDate < @LunchEndTime AND @LunchEndTime IS NOT NULL AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF(@OutTime IS NOT NULL AND @OutTime < @ScreenShotDate AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF(@BreakStartTime IS NOT NULL AND @ScreenShotDate > @BreakStartTime AND @BreakEndTime IS NULL AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF(@BreakStartTime IS NOT NULL AND @ScreenShotDate > @BreakStartTime AND @BreakEndTime IS NOT NULL AND @ScreenShotDate < @BreakEndTime AND @ConsiderPunchCard = 1)
		BEGIN 
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
		ELSE IF((@Intime < @ScreenShotDate AND (@OutTime IS NULL OR @OutTime > @ScreenShotDate)) OR @ConsiderPunchCard = 0)
		BEGIN

				SELECT @UserId AS UserId,@CompanyId AS CompanyId,1 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation

		END
		ELSE
		BEGIN
		
			SELECT @UserId AS UserId,@CompanyId AS CompanyId,0 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken, @TimeZoneName AS TimeZoneName, @TimeZoneAbbrevation AS TimeZoneAbbrevation
		
		END
	
	END
	ELSE
	BEGIN
		
		SELECT @UserId AS UserId,@CompanyId AS CompanyId,1 AS CanAcceptScreenShot, @ActivityToken AS ActivityToken
	
	END
		
END TRY

BEGIN CATCH
	
		THROW

END CATCH

END
GO
