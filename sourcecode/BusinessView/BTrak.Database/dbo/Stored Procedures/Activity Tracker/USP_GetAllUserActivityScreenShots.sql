CREATE PROCEDURE [dbo].[USP_GetAllUserActivityScreenShots]
(
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@UserIdXml XML = NULL,
@PageNo INT = 1,
@PageSize INT = 100,
@TimeZone NVARCHAR(250) = NULL,
@IsFullDay BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END

			IF(@DateFrom IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'DateFrom')
			END

			IF(@DateTo IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'DateTo')
			END
			ELSE
			BEGIN
				DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				IF (@HavePermission = '1')
				BEGIN
					CREATE TABLE #UserIdList 
					(
						UserId UNIQUEIDENTIFIER NULL
					)

					DECLARE @IsDelete BIT 

					SET @IsDelete = (SELECT TOP 1 IsDeleteScreenShots FROM ActivityTrackerRolePermission WHERE IsDeleteScreenShots = 1 
					                 AND RoleId IN (SELECT UR.RoleId FROM UserRole AS UR  WHERE UR.UserId = @OperationsPerformedBy AND UR.InactiveDateTime IS NULL) AND CompanyId = @CompanyId ORDER BY IsDeleteScreenShots DESC)
					
					--IF(DATEDIFF(DAY,@DateFrom,@DateTo) > 7) SET @DateFrom = DATEADD(DAY,-7,@DateTo) --TODO

					SELECT Id,RoleName INTO #Roles FROM [Role] WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL

					IF(@IsDelete  = '')
					BEGIN
						SET @IsDelete = 0
					END
					IF(@UserIdXml IS NOT NULL)
					BEGIN
						INSERT INTO #UserIdList (UserId)
						SELECT Id FROM (
						SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER') AS Id
						FROM  @UserIdXml.nodes('/ListItems/ListRecords/ListItem') XmlData(x) ) T
					END

					IF(@UserIdXml IS NULL)
					BEGIN
						
						INSERT INTO #UserIdList (UserId)
						SELECT @OperationsPerformedBy
					END

					SELECT DISTINCT A.Id AS ScreenShotId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],A.UserId,U.ProfileImage,
							STUFF((SELECT ', ' + RoleName
								  FROM #Roles R
									   INNER JOIN UserRole UR ON R.Id = UR.RoleId AND UR.UserId = U.Id
												  AND UR.InactiveDateTime IS NULL
								FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,							
							A.IsArchived,A.ScreenShotUrl AS ScreenShotUrl,A.ScreenShotName AS ScreenShotName,
							A.KeyStroke,A.MouseMovement,A.Reason,A.ApplicationName AS ApplicationName,ATT.ApplicationTypeName AS ApplicationTypeName,A.ScreenShotDateTime AS ScreenShotDateTime,@IsDelete AS IsDelete,
							 CONCAT(UU.FirstName,' ',UU.SurName) AS DeletedByUser,
							0 AS RecordActivity, 0 AS MouseTracking,
															A.CreatedDateTime,
							A.TimeZoneAbbreviation, A.TimeZoneName
							INTO #Screenshots
							FROM  [User] AS U
							INNER JOIN #UserIdList AS UL ON UL.UserId = U.Id
							INNER JOIN Employee AS E ON U.Id = E.UserId 
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo <= GETDATE()))
							LEFT JOIN (SELECT SS.Id, SS.UserId, SS.ApplicationTypeId, SS.ScreenShotDateTime, SS.ScreenShotName,
											SS.ScreenShotUrl, SS.ApplicationName,SS.KeyStroke, SS.MouseMovement
											, CONVERT(DATE,SS.ScreenShotDateTime) AS CreatedDateTime --Need to compare with screenshot date which is having offset
											,SS.Reason, SS.IsArchived,SS.UpdatedByUserId,TZ.TimeZoneAbbreviation,TZ.TimeZoneName 
											FROM (SELECT SS.UserId,MAX(SS.ScreenShotDateTime) AS ScreenShotDateTime 
											       FROM ActivityScreenShot SS
							                            INNER JOIN #UserIdList AS UL ON UL.UserId = SS.UserId
											     WHERE CONVERT(DATE,SS.ScreenShotDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo)
											           AND SS.CreatedDateTime IS NOT NULL
												  GROUP BY SS.UserId
												 ) ASS
											INNER JOIN ActivityScreenShot  AS SS ON ASS.ScreenShotDateTime = SS.ScreenShotDateTime AND ASS.UserId = SS.UserId
											LEFT JOIN TimeZone TZ ON TZ.Id = ScreenShotTimeZoneId
							           ) A ON A.UserId = U.Id
							INNER JOIN ApplicationType AS ATT ON ATT.Id = A.ApplicationTypeId
							LEFT JOIN [User] UU ON UU.Id = A.UpdatedByUserId 
							WHERE CONVERT(DATE, A.CreatedDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo)
									AND A.CreatedDateTime IS NOT NULL AND U.CompanyId = @CompanyId
							ORDER BY A.ScreenShotDateTime DESC

					DECLARE @TotalCount INT= (SELECT COUNT(1) FROM #Screenshots)

					SELECT T.[Date] AS [Date],@IsDelete AS IsDelete,@TotalCount AS TotalCount,(
					SELECT * FROM #Screenshots ST
					WHERE ST.CreatedDateTime = T.[Date]
					ORDER BY ScreenShotDateTime DESC
					OFFSET ((@PageNo - 1) * @PageSize) ROWS 
					FETCH NEXT @PageSize ROWS ONLY
					FOR JSON PATH) AS ScreenshotDetails 
					FROM (
							SELECT DISTINCT CreatedDateTime AS [Date]--, UserId
							FROM #Screenshots AA
							WHERE CONVERT(DATE, AA.CreatedDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo) AND AA.CreatedDateTime IS NOT NULL
						) T
					ORDER BY T.[Date] DESC

				END
				ELSE
				BEGIN
				   	RAISERROR (@HavePermission,11, 1)
				END
			END
		END TRY
		BEGIN CATCH
			THROW
		END CATCH
END
GO

--EXEC [dbo].[USP_GetAllUserActivityScreenShots] @OperationsPerformedBy = '0b2921a9-e930-4013-9047-670b5352f308'
--,@DateFrom = '2021-02-01',@DateTo = '2020-02-20'
--,@UserIdXml = 
--'<ListItems><ListRecords><ListItem>
--<ListItemId>C6B24B90-00D3-444D-A6A8-0E5050D2499F</ListItemId>
--<ListItemId>3644C910-B934-451C-A90B-111B5092D6A7</ListItemId>
--<ListItemId>248006C1-4342-4275-B7F1-1DEAFF08F21E</ListItemId>
--<ListItemId>D19CC006-A09E-43C8-BBFD-36AE5B24B4E6</ListItemId>
--</ListItem>
--</ListRecords>
--</ListItems>'
--,@PageSize = 250