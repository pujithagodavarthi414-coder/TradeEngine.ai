--- Read 460 line if your using script for 489 branch
DECLARE @OperationsPerformedBy UNIQUEIDENTIFIER = '7ee4e815-33d1-44b2-a071-42d9fd0d535e' --Need to give userid for companyid
DECLARE @DateFrom DATETIME = '2021-04-10',@DateTo DATETIME =  '2021-04-15'--date range to loop
DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy))

--IF(@DateTo > GETDATE()) SET @DateTo = GETDATE() --TODO
----Saving the users who's test data to be insert

DECLARE @Users TABLE
(
	UserId UNIQUEIDENTIFIER,
	RowNo INT IDENTITY(1,1)
)

INSERT INTO @Users(UserId)
SELECT Id
FROM [User]
WHERE CompanyId = @CompanyId
	 AND InActiveDateTime IS NULL
--AND Id = '468C6166-02BF-4034-93AB-06BDC3593433' --'b6b98add-758b-4f21-a452-dbcb58d97981' --TODO
ORDER BY UserName

DECLARE @MaxCount INT =  (SELECT MAX(RowNo) FROM @Users)


DECLARE @Count INT = 1
DECLARE @DateCount INT = 1
----Inserting Applications if not exist
DECLARE @Applications TABLE
(
	ApplicationId UNIQUEIDENTIFIER
	,ApplicationName VARCHAR(250)
	,IsApp BIT
	,IsProductive BIT
	,ImageUrl NVARCHAR(MAX)
)

INSERT @Applications(ApplicationId,ApplicationName,IsApp,IsProductive,ImageUrl)
VALUES (NEWID(),'Stackoverflow',0,1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/stackoverflow-84e057bb-6081-4639-8e2a-0f0f8cd557fd.png')
       ,(NEWID(),'Snovasys Office Messenger',1,NULL,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/sno-8a5d84e5-4dbf-43c4-90db-20b5b605ecc2.png')
       ,(NEWID(),'Microsoft PowerPoint',1,0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/powerpoint-20c0c8d3-af79-4e96-9499-613931d31d45.png')
       ,(NEWID(),'www.google.com',0,NULL,'https://bviewstorage.blob.core.windows.net/d0596d08-8527-4016-9225-bebc009bd888/projects/9d74bb93-28de-4e16-a310-72bbdedab0bd/images-5a339497-0dd2-4b8b-bda6-296ba37e2354.png')
       ,(NEWID(),'primevideo',0,0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/primevideo-712f322b-4dda-4ece-b4b2-21916fdc6651.jpg')
       ,(NEWID(),'whatsapp',1,1,'https://bviewstorage.blob.core.windows.net/d0596d08-8527-4016-9225-bebc009bd888/projects/9d74bb93-28de-4e16-a310-72bbdedab0bd/124034-4cbc6508-9c06-4ef2-8ef5-d22d4218d6e5.png')
       ,(NEWID(),'Linkedin',0,0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/linkedin-862733e2-4391-4daf-8f66-d50fad5ca07f.png')
       ,(NEWID(),'Google Chrome',1,1,'https://bviewstorage.blob.core.windows.net/d0596d08-8527-4016-9225-bebc009bd888/projects/9d74bb93-28de-4e16-a310-72bbdedab0bd/imgbin-google-chrome-web-browser-internet-google-tq49XnxEzhZ6H79w2A5byzsB0-beb7fa68-2355-4381-b043-b9141c81f919.jpg')
       ,(NEWID(),'Microsoft Word',1,1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/word-5642a506-6ceb-4da2-a79a-928f2078db91.png')
       ,(NEWID(),'Microsoft Excel',1,1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/excel-990965bd-1c35-4721-a407-e00f18450b4f.png')
       ,(NEWID(),'netflix',0,0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/netflix-7cff2635-d5fa-402c-ab0f-c231a9c7ac73.png')
       ,(NEWID(),'AnyDesk',1,NULL,'https://bviewstorage.blob.core.windows.net/d0596d08-8527-4016-9225-bebc009bd888/projects/9d74bb93-28de-4e16-a310-72bbdedab0bd/download-9be234bb-933f-43e3-85ce-6984de037544.png')
       ,(NEWID(),'youtube',0,0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/youtube-19c6f7f9-1ac1-43e8-aa3f-84a53bc79251.png')
	   ,(NEWID(),'Paint',1,0,'https://bviewstorage.blob.core.windows.net/d0596d08-8527-4016-9225-bebc009bd888/projects/9d74bb93-28de-4e16-a310-72bbdedab0bd/faad3a3e1a22918c7ac3770147f2fac2-d6c3e529-7afd-4256-9b39-0c8ec7ebaf19.jpg')

UPDATE @Applications SET ApplicationId = ATU.Id
FROM @Applications A 
	 INNER JOIN ActivityTrackerApplicationUrl ATU ON ATU.AppUrlName = A.ApplicationName
			   AND ATU.CompanyId = @CompanyId

INSERT INTO ActivityTrackerApplicationUrl(Id,AppUrlName,CreatedByUserId,CreatedDateTime,CompanyId,AppUrlImage)
SELECT ApplicationId,ApplicationName,@OperationsPerformedBy,GETDATE(),@CompanyId,ImageUrl
FROM @Applications A 
	 LEFT JOIN ActivityTrackerApplicationUrl ATU ON ATU.Id = A.ApplicationId
			   AND ATU.CompanyId = @CompanyId
WHERE ATU.Id IS NULL

-----------Inserting Role configurations with productive/unproductive

INSERT INTO ActivityTrackerApplicationUrlRole(Id,CompanyId,ActivityTrackerApplicationUrlId,CreatedByUserId,CreatedByDateTime,IsProductive,RoleId)
SELECT NEWID(),@CompanyId,T.ApplicationId,@OperationsPerformedBy,GETDATE(),T.IsProductive,T.RoleId
FROM (SELECT A.ApplicationId,A.IsProductive,UR.RoleId
	  FROM @Applications A
	       INNER JOIN (SELECT RoleId FROM UserRole UR 
	  	             INNER JOIN @Users U ON U.UserId = UR.UserId 
	  	                           AND UR.InactiveDateTime IS NULL
	  				 ) UR ON 1=1
	 ) T
LEFT JOIN (SELECT LocalApp.ApplicationId,LocalApp.IsProductive,LocalApp.RoleId
			FROM
			(SELECT A.ApplicationId,A.IsProductive,UR.RoleId
		     FROM @Applications A
		          INNER JOIN (SELECT RoleId FROM UserRole UR 
		     	             INNER JOIN @Users U ON U.UserId = UR.UserId 
		     	                           AND UR.InactiveDateTime IS NULL
		     				 ) UR ON 1=1
			) LocalApp
		    INNER JOIN ActivityTrackerApplicationUrlRole AUR ON AUR.RoleId = LocalApp.RoleId AND AUR.ActivityTrackerApplicationUrlId = LocalApp.ApplicationId
		  ) ExistedData ON ExistedData.ApplicationId = T.ApplicationId AND ExistedData.RoleId = T.RoleId
WHERE ExistedData.ApplicationId IS NULL

----------Starting Users looping
DECLARE @UserId UNIQUEIDENTIFIER

DECLARE User_Cursor CURSOR
FOR SELECT UserId AS UserId
    FROM @Users
 
OPEN User_Cursor
 
    FETCH NEXT FROM User_Cursor INTO 
        @UserId
     
    WHILE @@FETCH_STATUS = 0
    BEGIN
             
		DECLARE @TimeZone UNIQUEIDENTIFIER = 'C527B633-9FB6-4D9F-BE87-5172DBE87D18' --TODO --Indis timezone
		DECLARE @Date DATE = @DateFrom --'2021-01-1' --,@IntimeRange INT = 100,@LunchRange INT = 50

		WHILE(@Date <= CONVERT(DATE,@DateTo))
		BEGIN
		
		         IF(@DateCount = @Count AND @MaxCount > 1 AND NOT EXISTS(SELECT Id FROM LeaveApplication WHERE OverallLeaveStatusId IN (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId) AND @Date BETWEEN LeaveDateFrom AND LeaveDateTo AND UserId = @UserId AND InActiveDateTime IS NULL))
			     BEGIN
			     
				 DECLARE @LeaveStatusId UNIQUEIDENTIFIER =  (SELECT TOP 1 Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)
				 DECLARE @LeaveApplicationId UNIQUEIDENTIFIER = NEWID()

		            INSERT INTO [dbo].[LeaveApplication]([Id],[UserId],[LeaveAppliedDate],[LeaveReason],[LeaveTypeId],[LeaveDateFrom],[LeaveDateTo],[CreatedDateTime],[CreatedByUserId],
	                                    [OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId])
                               SELECT @LeaveApplicationId,@UserId,CASE WHEN @Date > GETDATE() THEN GETDATE() ELSE @Date END,'Sick',(SELECT TOP 1 Id FROM LeaveType WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL),
                                      @Date,
                                      @Date,
                                      @Date,
                                      @UserId,
			     					 @LeaveStatusId,
                                      (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId),
                                      (SELECT Id FROM LeaveSession WHERE IsSecondHalf = 1 AND CompanyId = @CompanyId)

									  INSERT INTO [LeaveApplicationStatusSetHistory](
											               [Id]
											              ,[LeaveApplicationId]
											              ,[LeaveStatusId]
											              ,[LeaveStuatusSetByUserId]
											              ,[CreatedDateTime]
											              ,[CreatedByUserId]
														  ,[Reason]
														  ,[Description]
				                                          )
									                SELECT NEWID()
									                      ,@LeaveApplicationId
									                      ,@LeaveStatusId
									                      ,@OperationsPerformedBy
									                      ,GETDATE()
									                      ,@OperationsPerformedBy
														  ,'Sick'
														  ,'Approved'

                 
				 END

				 IF  NOT EXISTS(SELECT Id FROM LeaveApplication WHERE OverallLeaveStatusId IN (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId) AND @Date BETWEEN LeaveDateFrom AND LeaveDateTo AND UserId = @UserId AND InActiveDateTime IS NULL)
				 BEGIN
				 
				DECLARE @LunchStartTime DATETIME = (SELECT DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 20),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:00:00' AS DATETIME)))
						,@LunchEndTime DATETIME = (SELECT DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 40),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:00:00' AS DATETIME)))

				--Inserting Data into TimeSheet
				--DELETE FROM TimeSheet WHERE UserId = @UserId --TODO

				INSERT INTO TimeSheet(Id,UserId,[Date],InTime,InTimeTimeZone,LunchBreakStartTime,LunchBreakStartTimeZone
									 ,LunchBreakEndTime,LunchBreakEndTimeZone,OutTime,OutTimeTimeZone,CreatedDateTime,CreatedByUserId)
				SELECT NEWID(),@UserId,@Date
					  ,(SELECT DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 60),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:00:00' AS DATETIME))),@TimeZone
					  ,@LunchStartTime,@TimeZone,@LunchEndTime,@TimeZone
					  ,(SELECT DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 18:00:00' AS DATETIME))),@TimeZone
					  ,GETDATE(),@UserId
				WHERE NOT EXISTS(SELECT 1 FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date)

				--------Breaktime insert
				IF(@LunchEndTime IS NOT NULL)
				BEGIN

				DECLARE @BreakStartTime DATETIME = DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 20),DATEADD(MINUTE,20,(SELECT TOP 1 LunchBreakEndTime FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date))) 
				DECLARE @BreakEndTime  DATETIME = DATEADD(MINUTE,5,DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 20),@BreakStartTime))
				INSERT INTO UserBreak(Id,UserId,[Date],BreakIn,BreakOut,BreakInTimeZone,BreakOutTimeZone,CreatedDateTime,CreatedByUserId,IsOfficeBreak)
				SELECT NEWID(),@UserId,@Date,@BreakStartTime,@BreakEndTime,@TimeZone,@TimeZone,GETDATE(),@UserId,0
				
				END

				-----Idle time 
			   DECLARE @InTime DATETIMEOFFSET = ISNULL(@BreakEndTime,(SELECT InTime FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date))

			   DECLARE @IdleTime INT = (ABS(CHECKSUM(NEWID())) % 30)+5
			      DECLARE @StartTime DATETIME = DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 60),@InTime)
				  

			   IF(@InTime IS NOT NULL)
			   BEGIN
			      
			      INSERT INTO [UserActivityTrackerStatus](Id,UserId,CompanyId,StartDateTime,TrackedDateTime,IdleTimeInMin,IsIdleRecord,CreatedDateTime)
                  SELECT NEWID(),@UserId,@CompanyId,DATEADD(MINUTE,-330,@StartTime),DATEADD(MINUTE,-330,dateadd(MINUTE,@IdleTime,@StartTime)),@IdleTime,1,@Date
			   
			  INSERT INTO UserActivityTime(Id,UserId,DesktopId,ApplicationId,ApplicationStartTime
											 ,ApplicationEndTime,ApplicationTypeId,SpentTime,OtherApplication --,TrackedUrl,CommonUrl
											 ,AbsoluteAppName,IsApp,CreatedDateTime,IdleTime)
				SELECT  TOP 1  NEWID(),@UserId,NULL,A.ApplicationId
				        ,DATEADD(MINUTE,-330,@StartTime)
				        ,DATEADD(MINUTE,-330,DATEADD(MINUTE,@IdleTime,@StartTime))
							,CASE WHEN A.IsProductive IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = A.IsProductive) END
							 ,CONVERT(TIME,DATEADD(MINUTE,@IdleTime,0))
							 ,A.ApplicationName,A.ApplicationName,A.IsApp,@Date,'00:00:00.0000000'
							 FROM @Applications A
			    END

				--Inserting data into useractivitytime table

				DECLARE @ApplicationTimes TABLE
				(
					ApplicationStartTime DATETIME
					,ApplicationEndTime DATETIME
					,ApplicationName VARCHAR(250)
				)
				
				DELETE FROM @ApplicationTimes

				INSERT INTO @ApplicationTimes(ApplicationStartTime,ApplicationEndTime)
				VALUES(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:50:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:56:00' AS DATETIME))
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 10:59:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 11:59:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 12:59:00' AS DATETIME))
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 13:59:00' AS DATETIME))
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 14:59:00' AS DATETIME))
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 15:59:00' AS DATETIME))
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 16:59:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:14:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:15:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:29:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:30:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:44:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:45:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 17:59:00' AS DATETIME))	
					  ,(CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 18:00:00' AS DATETIME),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 18:15:00' AS DATETIME))	
	
				UPDATE @ApplicationTimes SET ApplicationEndTime = DATEADD(MINUTE,-(ABS(CHECKSUM(NEWID())) % 3),ApplicationEndTime)
											 --,ApplicationStartTime = DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 5),ApplicationStartTime)

				--UPDATE @ApplicationTimes SET ApplicationEndTime = CASE WHEN ATS.ApplicationEndTime > T.Original_ApplicationStartTime 
				--													   THEN T.Original_ApplicationStartTime ELSE ATS.ApplicationEndTime END
				--FROM @ApplicationTimes ATS
				--INNER JOIN (SELECT ApplicationStartTime,ApplicationEndTime,LEAD(ApplicationStartTime) OVER (ORDER BY ApplicationStartTime) Original_ApplicationStartTime
				--FROM @ApplicationTimes) T ON T.ApplicationStartTime = ATS.ApplicationStartTime AND T.ApplicationEndTime = ATS.ApplicationEndTime

				UPDATE @ApplicationTimes SET ApplicationName = OuterT.ApplicationName
				FROM (SELECT TOP 22 ApplicationName
					  FROM (SELECT ApplicationName,ROW_NUMBER() OVER(ORDER BY ApplicationName) + (ABS(CHECKSUM(NEWID())) % 3650) RowNumber 
							 FROM @Applications) T
					  ORDER BY RowNumber
					  ) OuterT

				DELETE FROM @ApplicationTimes 
				WHERE ApplicationEndTime BETWEEN @LunchStartTime AND @LunchEndTime 
					  AND ApplicationStartTime BETWEEN @LunchStartTime AND @LunchEndTime 
					  AND ApplicationStartTime BETWEEN @BreakStartTime AND @BreakEndTime 
					  AND ApplicationEndTime BETWEEN @BreakStartTime AND @BreakEndTime 
					  AND ApplicationEndTime BETWEEN @StartTime AND dateadd(MINUTE,@IdleTime,@StartTime) 
					  AND ApplicationStartTime BETWEEN @StartTime AND dateadd(MINUTE,@IdleTime,@StartTime)

				--INSERT INTO @ApplicationTimes (ApplicationStartTime)
				--SELECT DATEADD(SECOND, (ABS(CHECKSUM(NEWID())) % 3650), CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:00:00' AS DATETIME))
				--FROM @Applications A ,@Applications B,@Applications C
				----WHERE 

				--UPDATE @ApplicationTimes SET ApplicationEndTime = DATEADD(SECOND, (ABS(CHECKSUM(NEWID())) % 3650),ApplicationStartTime)

				--SELECT * FROM @ApplicationTimes
				--DELETE FROM UserActivityTime WHERE UserId = @UserId --TODO

				DECLARE @OutTime DATETIME  = NULL
				DECLARE @InTimeSheet DATETIME  = NULL
				
				  SELECT @OutTime = OutTime,@InTimeSheet = InTime FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date
				

				INSERT INTO UserActivityTime(Id,UserId,DesktopId,ApplicationId,ApplicationStartTime
											 ,ApplicationEndTime,ApplicationTypeId,SpentTime,OtherApplication --,TrackedUrl,CommonUrl
											 ,AbsoluteAppName,IsApp,CreatedDateTime,IdleTime)
				SELECT DISTINCT TOP 22  NEWID(),@UserId,NULL,A.ApplicationId,ATS.ApplicationStartTime,ATS.ApplicationEndTime
							,CASE WHEN A.IsProductive IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = A.IsProductive) END
							 ,CONVERT(TIME,DATEADD(MINUTE,DATEDIFF(MINUTE,ATS.ApplicationStartTime,ATS.ApplicationEndTime),0))
							 ,A.ApplicationName,A.ApplicationName,A.IsApp,@Date,'00:00:00.0000000'
				FROM @Applications A
							INNER JOIN @ApplicationTimes ATS ON ATS.ApplicationName = A.ApplicationName
				WHERE ApplicationStartTime < ApplicationEndTime AND ApplicationEndTime <=  @OutTime AND ApplicationStartTime >= @InTimeSheet

				INSERT INTO UserActivityTime(Id,UserId,DesktopId,ApplicationId,ApplicationStartTime
											 ,ApplicationEndTime,ApplicationTypeId,SpentTime,OtherApplication --,TrackedUrl,CommonUrl
											 ,AbsoluteAppName,IsApp,CreatedDateTime,IdleTime)
				SELECT NEWID(),L.UserId,NULL,A.ApplicationId,L.ApplicationEndTime,L.ApplicationStartTime,CASE WHEN A.IsProductive IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = A.IsProductive) END
							 ,CONVERT(TIME,DATEADD(MINUTE,DATEDIFF(MINUTE,L.ApplicationEndTime,L.ApplicationStartTime),0)),A.ApplicationName,A.ApplicationName,A.IsApp,@Date,'00:00:00.0000000'
							 FROM 
							 (
				SELECT * FROM
	               (SELECT UserId,DATEADD(MINUTE,1,ApplicationEndTime)ApplicationEndTime,DATEADD(MINUTE,-1,LEAD(ApplicationStartTime) OVER (ORDER BY ApplicationEndTime)) AS ApplicationStartTime 
				      FROM UserActivityTime WHERE CreatedDateTime = @Date AND UserId = @UserId)T
					  WHERE ApplicationEndTime NOT BETWEEN @LunchStartTime AND @LunchEndTime 
					  AND ApplicationStartTime NOT BETWEEN @LunchStartTime AND @LunchEndTime 
					  AND ApplicationStartTime NOT BETWEEN @BreakStartTime AND @BreakEndTime 
					  AND ApplicationEndTime NOT BETWEEN @BreakStartTime AND @BreakEndTime 
					 AND ApplicationEndTime NOT BETWEEN  @StartTime AND dateadd(MINUTE,@IdleTime,@StartTime) 
					  AND ApplicationStartTime NOT BETWEEN @StartTime AND dateadd(MINUTE,@IdleTime,@StartTime) 
					  AND  ApplicationStartTime <=  @OutTime  AND ApplicationEndTime >= @InTimeSheet
				      GROUP BY ApplicationEndTime,ApplicationStartTime,UserId
				      HAVING DATEDIFF(MINUTE,ApplicationEndTime,ApplicationStartTime) > 0)L JOIN (SELECT TOP 1 * FROM @Applications)A ON 1=1 

                DELETE UserActivityTime WHERE UserId = @UserId AND CreatedDateTime = @Date AND ApplicationStartTime BETWEEN @LunchStartTime AND @LunchEndTime 
				 AND ApplicationEndTime BETWEEN @LunchStartTime AND @LunchEndTime 

				---Inserting Data into useractivitytrackerstatus Table (Need to check desktop id is required or not)
				--DELETE FROM UserActivitytrackerstatus WHERE UserId = @UserId --TODO

				--INSERT INTO UserActivitytrackerstatus(Id,UserId,CompanyId,TrackedDateTime,KeyStroke,MouseMovement,CreatedDateTime)
				--SELECT NEWID(),@UserId,@CompanyId,DATEADD(MINUTE,number,CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:00:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 60),(ABS(CHECKSUM(NEWID())) % 30),@Date
				--FROM  master..spt_values 
				--WHERE TYPE = 'p' 
				--AND number BETWEEN 1 AND 450 
				--ORDER BY number

				--Inserting ScreenShots
				INSERT INTO activityscreenshot(Id,UserId,ScreenShotName,ScreenShotUrl,ScreenShotDateTime,KeyStroke,MouseMovement,CreatedDateTime,CreatedByUserId,ScreenShotTimeZoneId
											  ,MacAddress,ApplicationTypeId,ApplicationName,ApplicationId)
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042225.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_101450-ccc5ad81-d3ea-423f-af8b-e172ce59147c.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Google Chrome') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Google Chrome')) END
				,'Google Chrome',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'Google Chrome')
				UNION ALL
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042226.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_100450-d5fd782f-23a3-4bc5-a236-db653ac3a8ca.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'whatsapp') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'whatsapp')) END
							 ,'whatsapp',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'whatsapp')
				UNION ALL
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042227.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_095050-a5570cf6-5970-4c9a-81e0-e4350fc28a3b.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Linkedin') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Linkedin')) END
							 ,'Linkedin',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'Linkedin')
				UNION ALL
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042228.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_095650-bd8f7850-4751-4290-af47-abfc937ebdc3.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Microsoft Excel') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Microsoft Excel')) END
							 ,'Microsoft Excel',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'Microsoft Excel')
				UNION ALL
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042229.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_095850-ec7af6fa-f21a-4970-a4ed-b468c469fbac.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Microsoft PowerPoint') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'Microsoft PowerPoint')) END
							 ,'Microsoft PowerPoint',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'Microsoft PowerPoint')
				UNION ALL
				SELECT NEWID(),@UserId,'1ScreenCapture_22122020_042223.jpg','https://bviewstorage.blob.core.windows.net/activitytrackercontainer/d0596d08-8527-4016-9225-bebc009bd888/e54420b8-1b2e-42cf-a5d5-25ca5ee69f4e/12%20Jan%202021/1ScreenCapture_12012021_100250-d18e3cc2-c7bf-4bb8-8044-aac52a4ec22e.jpg'
				,DATEADD(MINUTE,(ABS(CHECKSUM(NEWID())) % 90),CAST(CONVERT(NVARCHAR(10), @Date, 110) + ' 09:30:00' AS DATETIME)),(ABS(CHECKSUM(NEWID())) % 90),(ABS(CHECKSUM(NEWID())) % 30),@Date,@UserId,@TimeZone
				,'',CASE WHEN (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'primevideo') IS NULL
							 THEN (SELECT Id FROM ApplicationType WHERE IsProductive IS NULL)	
							 ELSE (SELECT Id FROM ApplicationType WHERE IsProductive = (SELECT IsProductive FROM @Applications WHERE ApplicationName = 'primevideo')) END
							 ,'primevideo',(SELECT ApplicationId FROM @Applications WHERE ApplicationName = 'primevideo')

				--Inserting TimeLine data
				EXEC USP_ActivityTrackerTimeLineRecurringJob @Date = @Date,@OperationsPerformedBy = @OperationsPerformedBy
			---Insert log time data
			IF EXISTS(SELECT Id FROM CompanyModule WHERE ModuleId = '3926F534-EDE8-4C47-8A44-BFDD2B7F76DB' AND CompanyId = @CompanyId AND IsActive = 1)
				BEGIN

				DECLARE @UserStoryId UNIQUEIDENTIFIER = (SELECT TOP 1 US.Id FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id  WHERE OwnerUserId = @UserId)

				DECLARE @LogTime INT = (SELECT ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, '+00:00'),SWITCHOFFSET(TS.OutTime, '+00:00')),0) 
                  - ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'),SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))-
                  ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, '+00:00') ,SWITCHOFFSET(UB.BreakOut, '+00:00'))),0),0)[Spent time]   
                  FROM [User] U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL  AND OutTime IS NOT NULL          
                  AND U.CompanyId = @CompanyId
				  LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = CAST(UB.[Date] AS date) AND UB.InActiveDateTime IS NULL       
                  WHERE TS.[Date] = @Date AND TS.UserId = @UserId                
                  GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime, TS.LunchBreakStartTime,TS.UserId)

				  IF(@UserStoryId IS NULL)
				  BEGIN

				  SET @UserStoryId = (SELECT TOP 1 US.Id FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = @CompanyId
				                                                            WHERE ProjectId IN (SELECT ProjectId FROM UserProject WHERE UserId = @UserId AND InActiveDateTime IS NULL))
                  
				  IF(@UserStoryId IS NULL)
				  BEGIN

				   SET @UserStoryId = (SELECT TOP 1 Id FROM UserStory WHERE OwnerUserId IS NULL AND ProjectId IN (SELECT Id FROM Project WHERE ProjectName = 'Adhoc project' AND CompanyId = @CompanyId))

				  END
				  END

				  IF(@UserStoryId IS NULL)
				  BEGIN
				     
					  DECLARE @Temp1 TABLE
					  (
					  Id UNIQUEIDENTIFIER
					  )
					  INSERT INTO @Temp1(Id) 
			    	  EXEC USP_UpsertAdhocWork @OperationsPerformedBy= @OperationsPerformedBy ,@UserStoryName='Create Sample App for finding room temp using IOT'

					  SET @UserStoryId = (SELECT TOP 1 Id FROM @Temp1)

				  END

               IF(@UserStoryId IS NOT NULL)
			   BEGIN

				INSERT INTO UserStorySpentTime([Id], [Comment],[DateFrom], [DateTo],[UserStoryId], [SpentTimeInMin],[UserId],[CreatedDateTime], [CreatedByUserId])
                 SELECT NEWID(),'Worked',@Date,@Date,@UserStoryId,IIF(@LogTime > 30,@LogTime -(ABS(CHECKSUM(NEWID())) % 30),@LogTime),U.UserId,@Date,U.UserId FROM @Users U LEFT JOIN (SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime, SUM(SpentTimeInMin) AS TotalTime
                       --,CEILING(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
                        FROM [User] AS UM
                           INNER JOIN (SELECT UserId,CONVERT(DATE, CreatedDateTime) AS CreatedDateTime, ROUND(DATEDIFF(MILLISECOND, UA.StartTime, UA.EndTime ) * 1.0 / 60000 * 1.0, 1) AS SpentTimeInMin
											--CEILING(DATEDIFF(MILLISECOND, UA.StartTime, UA.EndTime ) * 1.0 / 60000 * 1.0) AS SpentTimeInMin
                                          FROM UserStorySpentTime AS UA 
                                          WHERE CONVERT(DATE, UA.CreatedDateTime)= @Date
                                                AND UA.InActiveDateTime IS NULL AND UA.StartTime IS NOT NULL AND UA.EndTime IS NOT NULL
                                          UNION ALL
										  SELECT UserId,CONVERT(DATE, DateTo) AS CreatedDateTime,SpentTimeInMin
										  FROM UserStorySpentTime UAH
 										  WHERE CONVERT(DATE, UAH.DateTo) = @Date
												AND UAH.StartTime IS NULL
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime)UST ON UST.UserId = U.UserId AND CAST(UST.CreatedDateTime AS date) = @Date
						WHERE UST.UserId IS NULL AND U.UserId = @UserId 
                   END
			   END

			   

			 END
			 
			 DECLARE @ProcDate DATE  = @Date

			 SET @Date = DATEADD(Day,1,@Date)

			---Uncommment this sript if script will use for 489 branch EXEC [dbo].[USP_TrackerSummaryDataInsert] @UserId = @UserId,@Date = @ProcDate

			 SET @DateCount = @DateCount + 1

			IF(@DateCount > @MaxCount)
			SET @DateCount = 1 
			
			

		END
		 
		 SET @DateCount = 1
		 SET @Count = @Count + 1
		
		FETCH NEXT FROM User_Cursor INTO 
        @UserId

	END

CLOSE User_Cursor
DEALLOCATE User_Cursor
