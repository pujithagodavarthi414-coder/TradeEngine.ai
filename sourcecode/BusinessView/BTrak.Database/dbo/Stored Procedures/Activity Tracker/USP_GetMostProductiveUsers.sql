/*
DECLARE @OperationsPerformedBy UNIQUEIDENTIFIER = '4E6A2B8A-8B1D-4A63-9685-6B608A5C7567'
DECLARE @ApplicationTypeName NVARCHAR(MAX) = 'Productive'  -- 'Productive' , 'Unproductive' , 'Neutral'
DECLARE @DateFrom DATETIME = NULL
DECLARE	@DateTo DATETIME = NULL
EXEC USP_GetMostProductiveUsers @OperationsPerformedBy, @ApplicationTypeName, @DateFrom, @DateTo
*/

CREATE PROCEDURE [dbo].[USP_GetMostProductiveUsers](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@ApplicationTypeName [NVARCHAR](500) = NULL,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@PageNumber INT = 1,
@PageSize INT = 5
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  BEGIN TRY
	IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
   
	IF (@HavePermission = '1')
	BEGIN


	DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy)

		IF(@DateFrom IS NULL AND @DateTo IS NULL)
		BEGIN
			DECLARE @CurrentDate DATETIME = (SELECT CONVERT(DATE,GETUTCDATE()))
			SET @DateFrom = @CurrentDate
			SET @DateTo = @CurrentDate
			--SET @DateFrom = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0,  @CurrentDate), 0))
			--SET @DateTo   = (SELECT DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate) , 0)) ))
		END
						  
		SELECT UserId, 
			   FullName,		  
			   ProfileImage,
			   CAST(ROUND([SpentTime]*100.0/[TotalTime],2)as decimal(5,2)) AS [SpentPercent],			 
			   IIF(SpentTime < 60, CAST(SpentTime AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+'h' + ' ' +IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+'m')) [SpentTime],			 			
			   IIF(TotalTIme < 60, CAST(TotalTime AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(TotalTime,0)/60.0 AS int) AS varchar(100))+'h' + ' ' +IIF(CAST(ISNULL(TotalTime,0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(TotalTime,0)%60 AS INT) AS VARCHAR(100))+'m')) [TotalTime] 
			 
		FROM

		 (SELECT  
				U.Id AS UserId, 
				CONCAT(U.FirstName,' ',U.SurName) AS FullName,
				U.ProfileImage,
				M.SpentTime,
				M.TotalTime
			FROM [User] U 
			INNER JOIN (SELECT UserId,(SUM(Productive + Neutral + UnProductive) / 60000) AS TotalTime
			                   ,CASE WHEN @ApplicationTypeName = 'Neutral' THEN (SUM(Neutral)/ 60000)
			                        WHEN @ApplicationTypeName = 'UnProductive' THEN (SUM(UnProductive) / 60000)
			                        WHEN @ApplicationTypeName = 'Productive' THEN (SUM(Productive) / 60000)
								END AS SpentTime
			            FROM UserActivityTimeSummary 
						WHERE CreatedDateTime BETWEEN CONVERT(DATE,@DateFrom) AND CONVERT(DATE,@DateTo)
							AND CompanyId = @CompanyId 
						GROUP BY UserId
						) M ON U.Id = M.UserId
			WHERE SpentTime > 0
			  AND U.Id <> @OperationsPerformedBy
			  AND U.CompanyId = @CompanyId 
			  AND (@CanAccessAllEmployee = 1 OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) WHERE ChildId <> @OperationsPerformedBy))		 
		    ORDER BY SpentTime DESC, FullName
		 
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS                 
         FETCH NEXT @PageSize ROWS ONLY
		) U

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
