-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-24 00:00:00.000'
-- Purpose      To Get the Idle Time Of An User
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetIdleTimeOfAnUser] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetIdleTimeOfAnUser] --TODO
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@UserId UNIQUEIDENTIFIER = NULL
	,@Date DATETIME = NULL
	,@GetIds BIT = 0 
)
AS
BEGIN
	
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			IF(@GetIds IS NULL) SET @GetIds = 0

			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETDATE())

			IF(@UserId IS NULL) SET @UserId = @OperationsPerformedBy

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ActivityTotalTime INT

			SET @ActivityTotalTime = (
										SELECT SUM(Productive + UnProductive + Neutral)
										FROM [UserActivityTimeSummary]
										WHERE CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,@Date)
										      AND UserId = @UserId
									 )

			SELECT T.UserId AS USerId,SUM(T.TotalTimeInMin) OVER() AS TotalIdleTime 
	       ,MaxTrackedDateTime,MinTrackedDateTime
		   ,TotalTimeInMin AS TimeGaps
		   ,@ActivityTotalTime AS UserActivityTime
		    ,ApplicationName AS ApplicationName
		   ,CASE WHEN  @GetIds = 0 
				            THEN NULL 
					  ELSE  (SELECT T.Id 
					                ,T.IsLogged
							 FOR XML PATH('IdleTimeRecords'),ROOT('IdleTimeRecordsXML')
						    ) 
				 END AS IdsXML
	        FROM (
			SELECT UARS.UserId,UARS.IdleTimeInMin AS TotalTimeInMin,StartDateTime  AS MinTrackedDateTime
			       ,TrackedDateTime AS MaxTrackedDateTime,UARS.Id,UARS.IsLogged
				   ,ISNULL(UAT.AbsoluteAppName,UAT.OtherApplication) AS ApplicationName
			FROM [UserActivityTrackerStatus] UARS
				 INNER JOIN [User] U ON U.Id = UARS.UserId AND U.CompanyId = @CompanyId
						      AND UserId = @UserId
				LEFT JOIN UserActivityTime UAT ON UAT.UserId = UARS.UserId 
		            AND UAT.ApplicationStartTime = UARS.StartDateTime 
		            AND UAT.ApplicationEndTime = UARS.TrackedDateTime 
			WHERE UARS.IsIdleRecord = 1
				 AND UARS.IdleTimeInMin IS NOT NULL
				 AND CONVERT(DATE,TrackedDateTime) = CONVERT(DATE,@Date)
			UNION ALL 
			SELECT UserId,IdleTimeInMin,MinTrackedDateTime,MaxTrackedDateTime,NULL,IsLogged
			        ,ISNULL(AbsoluteAppName,TrackedUrl) AS ApplicationName
			FROM IdleTimeHistoricalData
			WHERE CompanyId = @CompanyId
				  AND UserId = @UserId
			      AND CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,@Date)
		  )T  
		  ORDER BY T.MinTrackedDateTime ASC
		 
		END
		ELSE
		BEGIN
			
			RAISERROR (@HavePermission,11,1)

		END

	 END TRY
	 BEGIN CATCH
		

		THROW

	END CATCH

END
GO
