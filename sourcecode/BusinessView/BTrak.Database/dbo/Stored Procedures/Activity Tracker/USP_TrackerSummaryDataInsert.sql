--EXEC [dbo].[USP_TrackerSummaryDataInsert] @UserId = 'DE782F93-705E-476D-8353-D208D103E312',@Date = '2021-01-18'
CREATE PROCEDURE [dbo].[USP_TrackerSummaryDataInsert]
(
	@UserId UNIQUEIDENTIFIER = NULL
	,@Date DATE = NULL
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
		
		IF(@UserId IS NOT NULL)
		BEGIN

				IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETUTCDATE())

				DECLARE @UserName  NVARCHAR(500) = (SELECT CONCAT(U.FirstName,' ',U.SurName) FROM [User] U WHERE Id = @UserId AND InActiveDateTime IS NULL)

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT Dbo.Ufn_GetCompanyIdBasedOnUserId(@UserId))

				--Deleting curentdate data from UserActivityAppSummary
				DELETE FROM UserActivityAppSummary WHERE (CreatedDateTime = @Date) AND UserId = @UserId

				--Detailed data tracking calculations
				INSERT INTO UserActivityAppSummary(UserId,AppUrlImage,ApplicationId,ApplicationName,[ApplicationTypeName],[SpentTime],IsApp,CreatedDateTime,CompanyId,TimeInMillisecond)
				SELECT U.Id AS UserId
				                ,A.AppUrlImage
								,UA.ApplicationId
								,UA.AbsoluteAppName AS ApplicationName
								,T.ApplicationTypeName
						        ,UA.SpentTime
								,UA.IsApp
								,UA.CreatedDateTime
								,@CompanyId
								,ISNULL(UA.TimeInMS,0)
				FROM [User] AS U
					 INNER JOIN (SELECT ApplicationId,ApplicationTypeId
					                    ,CONVERT(TIME, DATEADD(MS, SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)), 0)) AS SpentTime
					                    ,UA.UserId,UA.CreatedDateTime,UA.IsApp,UA.AbsoluteAppName
										,SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)) TimeInMS
					             FROM UserActivityTime AS UA
									  --INNER JOIN [User] AS U ON U.Id = UA.UserId 
									  --AND U.CompanyId = @CompanyId
					 	         WHERE UA.InActiveDateTime IS NULL
								 AND (UA.CreatedDateTime = @Date)
								 AND UA.UserId = @UserId
								 GROUP BY ApplicationId,ApplicationTypeId,UA.UserId,UA.CreatedDateTime,UA.IsApp,UA.AbsoluteAppName								 
								 ) AS UA ON U.Id = UA.UserId 
					 LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
					 LEFT JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id 
				WHERE U.CompanyId = @CompanyId
					  AND U.Id = @UserId

				DECLARE @Neutral BIGINT,@UnProductive BIGINT,@Productive BIGINT,@IdleInMinutes INT
				
				SET @Neutral = (SELECT SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)) TimeInMS FROM UserActivityTime 
				                WHERE ApplicationTypeId = 'A5149B84-7074-4098-A1E4-6C218CA4DE5D' /*Neutral application type id*/
								 AND CreatedDateTime = @Date
								 AND UserId = @UserId
								 AND InActiveDateTime IS NULL
								GROUP BY ApplicationTypeId)
			   
			   SET @UnProductive = (SELECT SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)) TimeInMS FROM UserActivityTime 
				                WHERE ApplicationTypeId = '0F371F03-9412-4F86-B444-3B7691AA5EDE' /*UnProductive application type id*/
								 AND CreatedDateTime = @Date
								 AND UserId = @UserId
								 AND InActiveDateTime IS NULL
								GROUP BY ApplicationTypeId)
			   
			   SET @Productive = (SELECT SUM(DATEDIFF(MS,'00:00:00.0000000',SpentTime)) TimeInMS FROM UserActivityTime 
				                WHERE ApplicationTypeId = '670B5CAF-311C-4303-89AD-58B4EE17C264' /*Productive application type id*/
								 AND CreatedDateTime = @Date
								 AND UserId = @UserId
								 AND InActiveDateTime IS NULL
								GROUP BY ApplicationTypeId)
			  
			  SET @IdleInMinutes = (SELECT SUM(UARS.IdleTimeInMin) AS TotalIdleInMin
									FROM [UserActivityTrackerStatus] UARS
									WHERE UARS.IsIdleRecord = 1
										 AND UARS.IdleTimeInMin IS NOT NULL
								         AND UARS.UserId = @UserId
										 AND CONVERT(DATE,TrackedDateTime) = @Date)
			  
			  IF(EXISTS (SELECT UserId FROM [UserActivityTimeSummary] WHERE UserId = @UserId AND CreatedDateTime = @Date))
			  BEGIN
				
					UPDATE [UserActivityTimeSummary] SET Neutral = ISNULL(@Neutral,0)
					                                    ,Productive = ISNULL(@Productive,0)
														,UnProductive = ISNULL(@UnProductive,0)
														,IdleInMinutes = ISNULL(@IdleInMinutes,0)
										WHERE UserId = @UserId AND CreatedDateTime = @Date

			  END
			  ELSE
			  BEGIN
				
					INSERT INTO [UserActivityTimeSummary](UserId,[Neutral],[UnProductive],[Productive],[IdleInMinutes],CreatedDateTime,CompanyId)
					SELECT @UserId,ISNULL(@Neutral,0),ISNULL(@UnProductive,0),ISNULL(@Productive,0),ISNULL(@IdleInMinutes,0),@Date,@CompanyId

			  END

			  IF(EXISTS(SELECT * FROM AppSettings WHERE AppSettingsName = 'LatestInsertedTrackerDate'))
			  BEGIN
				
				UPDATE AppSettings SET AppSettingsValue = GETUTCDATE()
										,UpdatedDateTime = GETUTCDATE()
										,UpdatedByUserId = @UserId
				WHERE AppSettingsName = 'LatestInsertedTrackerDate'

			  END
			  ELSE
			  BEGIN
				
				INSERT INTO AppSettings(Id,AppSettingsName,AppSettingsValue,CreatedByUserId,CreatedDateTime,IsSystemLevel)
				SELECT NEWID(),'LatestInsertedTrackerDate',GETUTCDATE(),@UserId,GETUTCDATE(),1

			  END
				
		END

END
GO

