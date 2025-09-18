--EXEC [dbo].[USP_GetTeamActivity] '2d76d8ad-c8dd-4708-92bd-8169caf9d126','2020-12-22','2020-12-22','2020-12-22'
CREATE PROCEDURE [dbo].[USP_GetTeamActivity]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@OnDate DATETIME = NULL
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@IsForSummary BIT = NULL
    ,@BranchIds XML = NULL
    ,@RoleIds XML = NULL
    ,@UserIds XML = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		IF(@OnDate IS NOT NULL AND @DateFrom IS NULL AND @DateTo IS NULL) SELECT @DateFrom = @OnDate,@DateTo = @OnDate
		
		IF(@OnDate IS NULL) SET @OnDate = GETUTCDATE()

		IF(@DateFrom IS NULL) SET @DateFrom = GETUTCDATE()

		IF(@DateTo IS NULL) SET @DateTo = GETUTCDATE()

		IF(@IsForSummary IS NULL) SET @IsForSummary = 0

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 

		CREATE TABLE #BranchIdList 
		(
			BranchId UNIQUEIDENTIFIER NULL
		)

		CREATE TABLE #RoleIdList
		(
			RoleId UNIQUEIDENTIFIER NULL
		)

		CREATE TABLE #UserIdList
		(
			UserId UNIQUEIDENTIFIER NULL
		)

		INSERT INTO #RoleIdList (RoleId)
		SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
		FROM  @RoleIds.nodes('/ListItems/ListRecords/ListItem') XmlData(x)

		INSERT INTO #BranchIdList (BranchId)
		SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
		FROM  @BranchIds.nodes('/ListItems/ListRecords/ListItem') XmlData(x)

		INSERT INTO #UserIdList (UserId)
		SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
		FROM  @UserIds.nodes('/ListItems/ListRecords/ListItem') XmlData(x)

		IF(@HavePermission = '1')
		BEGIN

			SELECT Da.UserName,ISNULL(P.Productive,0)Productive,ISNULL(P.UnProductive,0)UnProductive,ISNULL(P.Neutral,0)Neutral
			,(ISNULL(P.Productive,0) + ISNULL(P.UnProductive,0) + ISNULL(P.Neutral,0)) AS TotalTime,ProductiveInSec,UnProductiveInSec,NeutralInSec
			 FROM
			(SELECT U.FirstName + ' ' + ISNULL(U.Surname,' ') AS UserName,U.Id AS UserId
			        FROM [User] U 
					INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
										INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
										            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
													--AND EB.ActiveFrom IS NOT NULL AND CONVERT(DATE,EB.ActiveFrom) <= @DateFrom
													--AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= @DateTo)
													AND (@BranchIds IS NULL OR EB.BranchId IN (SELECT BranchId FROM #BranchIdList))
													AND (@UserIds IS NULL OR U.Id IN (SELECT UserId FROM #UserIdList))
													AND (@RoleIds IS NULL OR U.Id IN (SELECT UserId FROM [UserRole] 
													              WHERE RoleId IN (SELECT RoleId FROM #RoleIdList) 
																		AND InActiveDateTime IS NULL))
					WHERE U.CompanyId = @CompanyId AND ((SELECT COUNT(1) FROM Feature AS F
											JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
											JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
											WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy) > 0 OR
								U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
											 (@OperationsPerformedBy,@CompanyId)
											 WHERE (@IsForSummary = 1 OR (@IsForSummary = 0 AND (ChildId <> @OperationsPerformedBy)))
										))
					)  Da
			LEFT JOIN
			(
				SELECT UserId
				       ,SUM(Neutral)/1000 AS NeutralInSec
				       ,SUM(UnProductive)/1000 AS UnProductiveInSec
				       ,SUM(Productive)/1000 AS ProductiveInSec
					   ,CONVERT(DECIMAL(10,1),SUM(Neutral)/3600000.0) AS Neutral
					   ,CONVERT(DECIMAL(10,1),SUM(Productive)/3600000.0) AS Productive
					   ,CONVERT(DECIMAL(10,1),SUM(UnProductive)/3600000.0) AS UnProductive
				FROM UserActivityTimeSummary
				WHERE CompanyId = @CompanyId
				      AND CreatedDateTime BETWEEN CONVERT(DATE,@DateFrom) AND CONVERT(DATE,@DateTo)
				GROUP BY UserId
           ) P ON P.UserId = Da.UserId
		   ORDER BY DA.UserName
           OFFSET (0) ROWS 
           FETCH NEXT 100 ROWS ONLY

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


