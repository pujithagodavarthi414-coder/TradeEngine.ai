--exec [dbo].[USP_TestDataActivityTrackerInsertScript] @CompanyId='CECB81BC-9AD4-4B66-A442-F6133C9BF534',@UserId='051E1159-8B5C-4DF3-B411-72331B4E5F44'
CREATE PROCEDURE [dbo].[USP_TestDataActivityTrackerInsertScript]
(
 @CompanyId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='7499F5E3-0EF2-4044-B840-2411B68302F9')
	BEGIN
		--INSERT INTO ActivityTrackerApplicationUrlRole(Id,IsProductive,ActivityTrackerApplicationUrlId,RoleId,CompanyId,CreatedByUserId,CreatedByDateTime)
		--SELECT NEWID(),CASE WHEN A.AppUrlName IN (N'Google',N'Visual Studio Code',N'Microsoft SQL Server Management Studio') THEN 1 
		--					ELSE 0 END
		--			 ,A.Id,R.Id,@CompanyId,@UserId,GETDATE()
		--		FROM ActivityTrackerApplicationUrl AS A ,Role AS R 
		--		WHERE A.CompanyId = @CompanyId AND R.CompanyId =  @CompanyId

		INSERT INTO UserActivityTime ([Id], [MACAddress], [UserId], [ApplicationId], [ApplicationStartTime], [ApplicationEndTime], [ApplicationTypeId], [SpentTime], [IdleTime], [IsApp], [OtherApplication], [CreatedDateTime])
		SELECT NEWID(),E.[MACAddress],E.[UserId],(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Google' AND CompanyId = @CompanyId),DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'670B5CAF-311C-4303-89AD-58B4EE17C264',
				CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 0,NULL,CONVERT(DATE, InTime)
		FROM Employee E JOIN [User] U ON U.Id = E.UserId INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND [Date] = CONVERT(DATE,GETDATE()) AND U.CompanyId = @CompanyId
		WHERE E.MACAddress IS NOT NULL
		UNION
		SELECT NEWID(),E.[MACAddress],E.[UserId],(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Microsoft Visual Studio' AND CompanyId = @CompanyId),DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'0F371F03-9412-4F86-B444-3B7691AA5EDE',
				CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 1,NULL,CONVERT(DATE, InTime)
		FROM Employee E JOIN [User] U ON U.Id = E.UserId INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND [Date] = CONVERT(DATE,GETDATE()) AND U.CompanyId = @CompanyId
		WHERE E.MACAddress IS NOT NULL
		UNION
		SELECT NEWID(),E.[MACAddress],E.[UserId],N'A5149B84-7074-4098-A1E4-6C218CA4DE5D',DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'A5149B84-7074-4098-A1E4-6C218CA4DE5D',
				CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 1,N'Slack',CONVERT(DATE, InTime)
		FROM Employee E JOIN [User] U ON U.Id = E.UserId INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND [Date] = CONVERT(DATE,GETDATE()) AND U.CompanyId = @CompanyId
		WHERE E.MACAddress IS NOT NULL

		INSERT INTO ActivityScreenShot ([Id], [MACAddress], [UserId],[ScreenShotUrl],[ScreenShotName],[ScreenShotDateTime],[KeyStroke],[MouseMovement],[ApplicationTypeId],[CreatedDateTime],[ScreenShotTimeZoneId])
		SELECT NEWID(), E.[MACAddress], E.[UserId],N'https://bviewstorage.blob.core.windows.net/0c2ba308-12b8-4a6b-97d9-ebb400864def/localsiteuploads/dbc307b7-05e3-4afd-a261-be2f4d452b16/ScreenCapture_Activity_tracker_ActivityScreenshot_Snovasys_Business_Suite_Google_Chrome_06012020_112626_png-62de1fa7-e10d-40d2-9bbc-273086ca75a0',N'Google',DATEADD(MINUTE,1,InTime),N'10',N'12',N'670B5CAF-311C-4303-89AD-58B4EE17C264',(SELECT CAST(DATEADD(SECOND,20,InTime) AS DATE)),'557c436a-5d19-4eeb-a677-93ea2609eaf1'
		FROM Employee E JOIN [User] U ON U.Id = E.UserId INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND [Date] = CONVERT(DATE,GETDATE()) AND U.CompanyId = @CompanyId
		WHERE E.MACAddress IS NOT NULL
	END
ELSE
	BEGIN
			--INSERT INTO ActivityTrackerApplicationUrlRole(Id,IsProductive,ActivityTrackerApplicationUrlId,RoleId,CompanyId,CreatedByUserId,CreatedByDateTime)
			--SELECT NEWID(),CASE WHEN A.AppUrlName IN (N'Google',N'Visual Studio Code',N'Microsoft SQL Server Management Studio') THEN 1 
			--				ELSE 0 END
   -- 			       ,A.Id,R.Id,@CompanyId,@UserId,GETDATE()
			--		FROM ActivityTrackerApplicationUrl AS A ,Role AS R 
			--		WHERE A.CompanyId = @CompanyId AND R.CompanyId =  @CompanyId

			INSERT INTO UserActivityTime ([Id], [MACAddress], [UserId], [ApplicationId], [ApplicationStartTime], [ApplicationEndTime], [ApplicationTypeId], [SpentTime], [IdleTime], [IsApp], [OtherApplication], [CreatedDateTime])
			SELECT NEWID(),UM.[MACAddress],UM.[UserId],(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Google' AND CompanyId = @CompanyId),DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'670B5CAF-311C-4303-89AD-58B4EE17C264',
				   CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 0,NULL,CONVERT(DATE, InTime)
			FROM UserMAC UM INNER JOIN TimeSheet TS ON TS.UserId = UM.UserId AND [Date] = CONVERT(DATE,GETDATE()) AND UM.CompanyId = @CompanyId
			UNION
			SELECT NEWID(),UM.[MACAddress],UM.[UserId],(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Microsoft Visual Studio' AND CompanyId = @CompanyId),DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'0F371F03-9412-4F86-B444-3B7691AA5EDE',
				   CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 1,NULL,CONVERT(DATE, InTime)
			FROM UserMAC UM INNER JOIN TimeSheet TS ON TS.UserId = UM.UserId AND [Date] = CONVERT(DATE,GETDATE()) AND UM.CompanyId = @CompanyId
			UNION
			SELECT NEWID(),UM.[MACAddress],UM.[UserId],N'A5149B84-7074-4098-A1E4-6C218CA4DE5D',DATEADD(SECOND,20,InTime),DATEADD(MINUTE,5,InTime),N'A5149B84-7074-4098-A1E4-6C218CA4DE5D',
				   CAST('00:05:00' AS TIME),CAST('00:00:00' AS TIME), 1,N'Slack',CONVERT(DATE, InTime)
			FROM UserMAC UM INNER JOIN TimeSheet TS ON TS.UserId = UM.UserId AND [Date] = CONVERT(DATE,GETDATE()) AND UM.CompanyId = @CompanyId

			INSERT INTO ActivityScreenShot ([Id], [MACAddress], [UserId],[ScreenShotUrl],[ScreenShotName],[ScreenShotDateTime],[KeyStroke],[MouseMovement],[ApplicationTypeId],[CreatedDateTime], [ScreenShotTimeZoneId])
			SELECT NEWID(), UM.[MACAddress], UM.[UserId],N'https://bviewstorage.blob.core.windows.net/0c2ba308-12b8-4a6b-97d9-ebb400864def/localsiteuploads/dbc307b7-05e3-4afd-a261-be2f4d452b16/ScreenCapture_Activity_tracker_ActivityScreenshot_Snovasys_Business_Suite_Google_Chrome_06012020_112626_png-62de1fa7-e10d-40d2-9bbc-273086ca75a0',N'Google',DATEADD(MINUTE,1,InTime),N'10',N'12',N'670B5CAF-311C-4303-89AD-58B4EE17C264',(SELECT CAST(DATEADD(SECOND,20,InTime) AS DATE)),'557c436a-5d19-4eeb-a677-93ea2609eaf1'
			FROM UserMAC UM INNER JOIN TimeSheet TS ON TS.UserId = UM.UserId AND [Date] = CONVERT(DATE,GETDATE()) AND UM.CompanyId = @CompanyId
	END


END
