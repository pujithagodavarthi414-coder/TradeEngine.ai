CREATE PROCEDURE [dbo].[USP_GetActivityTrackerInformation](
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
   BEGIN TRY
		IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

		DECLARE @Temp DATE = GETDATE()
        
        IF (@HavePermission = '1')
        BEGIN
		
			SELECT A.ScreenShotFrequency,A.Multiplier, U.Id AS UserId, U.CompanyId INTO #UserScreenshotFrequency
							FROM [User] AS U 
							INNER JOIN ActivityTrackerScreenShotFrequency AS A ON A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
							           AND A.InActiveDateTime IS NULL 		 
						WHERE U.Id = @OperationsPerformedBy
						GROUP BY A.ScreenShotFrequency,A.Multiplier, U.Id,U.CompanyId

			SELECT TOP(1) * INTO #ActivityTrackerInformation FROM #UserScreenshotFrequency ORDER BY ScreenShotFrequency , Multiplier DESC

			DECLARE @StartTime DATETIME

			SET @StartTime = (SELECT TOP(1) ActivityTrackerStartTime FROM ActivityTrackerStatus WHERE UserId = @OperationsPerformedBy AND [Date] = CONVERT(DATE,GETDATE()) ORDER BY ActivityTrackerStartTime,LastActiveDateTime DESC)

			IF(@StartTime = '' OR @StartTime IS NULL)
			BEGIN
				
				SET @StartTime = GETDATE()

			END

			SELECT @StartTime AS StartTime , ATS.ScreenShotFrequency , ATS.Multiplier 
							FROM [User] AS U
							JOIN TimeSheet AS T ON T.UserId =  U.Id AND T.Date = @Temp
							JOIN #ActivityTrackerInformation AS ATS ON ATS.UserId = U.Id
							WHERE U.Id =  @OperationsPerformedBy AND ATS.CompanyId = @CompanyId
	
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