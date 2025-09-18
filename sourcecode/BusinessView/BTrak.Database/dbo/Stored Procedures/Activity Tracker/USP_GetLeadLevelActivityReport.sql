CREATE PROCEDURE [dbo].[USP_GetLeadLevelActivityReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@OnDate DATETIME = NULL,
	@IsProductiveApps BIT = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@OnDate IS NULL) SET @OnDate = GETUTCDATE()
		
		IF(@IsProductiveApps IS NULL) SET @IsProductiveApps = 0
		
		DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

		IF(@HavePermission = '1')
		BEGIN

			DECLARE @FeatureIdCount INT = (SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			                               AND UR.InactiveDateTime IS NULL
			                               AND RF.InactiveDateTime IS NULL
			                               WHERE UR.UserId = @OperationsPerformedBy AND RF.FeatureId = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5')
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			
			SELECT TotalTimeInHr
			       ,ApplicationTypeName
				   ,AppUrlImage
				   ,AppUrlName
				   ,STUFF((SELECT ',' + R.Rolename
							FROM ActivityTrackerApplicationUrlRole AAR
							   INNER JOIN [Role] R ON R.Id = AAR.RoleId
										  AND AAR.InActiveDateTime IS NULL
										  AND R.InActiveDateTime IS NULL
										  AND AAR.IsProductive = 1
										  AND AAR.ActivityTrackerApplicationUrlId = Main.ActivityTrackerApplicationUrlId
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,' ') AS ProductiveRoles
					,STUFF((SELECT ',' + R.Rolename
							FROM ActivityTrackerApplicationUrlRole AAR
							   INNER JOIN [Role] R ON R.Id = AAR.RoleId
										  AND AAR.InActiveDateTime IS NULL
										  AND AAR.IsProductive = 0
										  AND R.InActiveDateTime IS NULL
										  AND AAR.ActivityTrackerApplicationUrlId = Main.ActivityTrackerApplicationUrlId
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,' ') AS UnProductiveRoles
			FROM (
			SELECT TOP(5) *
			FROM (
			SELECT --UA.UserId,
			  ROUND(SUM(UA.TimeInMillisecond) /3600000.0 ,3) TotalTimeInHr
			 ,UA.ApplicationTypeName
			 ,UA.ApplicationName AS AppUrlName
			 ,UA.AppUrlImage
			 ,UA.ApplicationId AS ActivityTrackerApplicationUrlId
			FROM UserActivityAppSummary UA
			    INNER JOIN [User] U ON U.Id = UA.UserId 
				            AND U.InActiveDateTime IS NULL
				            AND U.IsActive = 1
				            AND U.CompanyId = @CompanyId
			WHERE UA.CreatedDateTime = CONVERT(DATE,@OnDate)
				  AND (@IsProductiveApps IS NULL OR (@IsProductiveApps = 0 AND UA.ApplicationTypeName = 'UnProductive') 
				        OR (@IsProductiveApps = 1 AND UA.ApplicationTypeName = 'Productive'))
				  AND (@FeatureIdCount > 0 OR UA.UserId IN (SELECT ChildId FROM dbo.Ufn_ReportedMembersByUserId(@OperationsPerformedBy,@CompanyId)))
			GROUP BY UA.ApplicationTypeName,UA.ApplicationName,UA.AppUrlImage,UA.ApplicationId
			) TT ORDER BY TotalTimeInHr DESC
			) Main

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO