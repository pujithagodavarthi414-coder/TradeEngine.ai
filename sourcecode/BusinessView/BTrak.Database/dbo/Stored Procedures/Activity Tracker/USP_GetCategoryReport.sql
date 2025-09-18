--EXEC [USP_GetCategoryReport] @OperationsPerformedBy = '589BE7AE-E5FA-4BDB-B5C4-F44834151BA4'
CREATE PROCEDURE [dbo].[USP_GetCategoryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@OnDate DATETIME = NULL,
	@MySelf BIT = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@OnDate IS NULL) SET @OnDate = GETUTCDATE()
		
		IF(@MySelf IS NULL) SET @MySelf = 0
		
		DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

		IF(@HavePermission = '1')
		BEGIN

			DECLARE @FeatureIdCount INT = (SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			                               AND UR.InactiveDateTime IS NULL
			                               AND RF.InactiveDateTime IS NULL
			                               WHERE UR.UserId = @OperationsPerformedBy AND RF.FeatureId = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5')
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			
			SELECT IIF(ApplicationCategoryName IS NULL,'Other Category',ApplicationCategoryName) AS CategoryName
				 ,TotalTimeInHr
			FROM (
			SELECT TOP(5) *
			FROM (
			SELECT  ROUND(SUM(UA.TimeInMillisecond) /3600000.0 ,3) TotalTimeInHr
			 ,AAU.ApplicationCategoryId
			 ,AC.ApplicationCategoryName
			FROM UserActivityAppSummary UA
			    INNER JOIN [User] U ON U.Id = UA.UserId 
				            AND U.InActiveDateTime IS NULL
				            AND U.IsActive = 1
				            AND U.CompanyId = @CompanyId
				LEFT JOIN ActivityTrackerApplicationUrl AAU ON AAU.Id = UA.ApplicationId
				LEFT JOIN ApplicationCategory AC ON AC.Id = AAU.ApplicationCategoryId AND AC.InActiveDateTime IS NULL
			WHERE UA.CreatedDateTime = CONVERT(DATE,@OnDate)
				  AND ((@MySelf = 1 AND UA.UserId = @OperationsPerformedBy)
						OR (@MySelf = 0 AND (@FeatureIdCount > 0 OR UA.UserId IN (SELECT ChildId FROM dbo.Ufn_ReportedMembersByUserId(@OperationsPerformedBy,@CompanyId))))
					  )	
			GROUP BY AAU.ApplicationCategoryId,AC.ApplicationCategoryName
			         --,A.ApplicationTypeName,UA.AbsoluteAppName,AAU.AppUrlImage,AAU.Id
			) TT 
			ORDER BY TotalTimeInHr DESC
			) T

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
