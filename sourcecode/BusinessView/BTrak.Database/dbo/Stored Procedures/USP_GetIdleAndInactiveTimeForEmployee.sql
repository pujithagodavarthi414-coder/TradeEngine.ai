CREATE PROCEDURE [dbo].[USP_GetIdleAndInactiveTimeForEmployee]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER, 
	@UserId XML = NULL ,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		 
        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
        IF (@HavePermission = '1')
        BEGIN

			CREATE TABLE #UserIdList
			(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				UserId UNIQUEIDENTIFIER NULL
			)
			
			IF(@UserId IS NULL)
			INSERT INTO #UserIdList VALUES( '00000000-0000-0000-0000-000000000000' )
			
			IF(@UserId IS NOT NULL)
			BEGIN
					INSERT INTO #UserIdList (UserId)
					SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
					FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
			END

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SET @StartDate = (SELECT CAST(CAST(@StartDate AS DATE) AS DATETIME))
			SET @EndDate = (SELECT CAST(CAST(@EndDate AS DATE) AS DATETIME))

			CREATE TABLE #DATESIDLETIME 
			(
				RefDate datetime,
				UserId uniqueidentifier,
				ResourceId int identity(1,1)
			)
			;WITH cte AS(
				SELECT @StartDate RefDate
				UNION all
				SELECT dateadd(dd, 1, RefDate) FROM cte WHERE RefDate < @EndDate
			)

			INSERT INTO #DATESIDLETIME
			SELECT DISTINCT RefDate, UserId from cte	
			inner join #UserIdList ON 1=1
			ORDER BY UserId, RefDate ASC

			CREATE TABLE #UserIdleStatus
			(
				UserId uniqueidentifier,
				UserName NVARCHAR(50),
				ProfileImage NVARCHAR(500),
				CreatedDate DATE,
				ApplicationTypeName NVARCHAR(50),
				StartTime DATETIME,
				EndTime DATETIME,
				ResourceId INT,
				SpentTime INT
			)

			CREATE TABLE #UserStatus
			(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				ApplicationTypeName VARCHAR(50),
				ApplicationStartTime DATETIME,
				ApplicationEndTime DATETIME,
				NextTypeName VARCHAR(50),
				CreatedDate DATETIME,
				UserId UNIQUEIDENTIFIER,
				UserName VARCHAR(250),
				ResourceId INT,
				[Counter] INT,
				UserOrder INT
			)

			DECLARE @Iden INT = 1, @maxUser INT = (SELECT COUNT(*) FROM #UserIdList)
			DECLARE @counter INT = 1

			DECLARE @Time TIME = '23:59:59'

			WHILE(@Iden <= @maxUser)
			BEGIN
					
				DECLARE @UserIdLocal UNIQUEIDENTIFIER = (SELECT UserId FROM #UserIdList WHERE Id = @Iden)

				
				
				;WITH CTE AS(
					SELECT *, ROW_NUMBER() OVER(PARTITION BY StartTime, EndTime, [CreatedDate], [UserId], UserName, [COUNTER] ORDER BY 
							StartTime, EndTime, [CreatedDate], [UserId], UserName, [COUNTER]) RN FROM (
								SELECT U.Id UserId,  U.FirstName + COALESCE( ' '+ U.SurName,'') UserName, D.RefDate AS CreatedDate, M.CreatedDateTime AS StartTime,
										ISNULL(LEAD(M.CreatedDateTime) OVER (ORDER BY M.CreatedDateTime) 
										 , CASE WHEN CONVERT(DATE, M.CreatedDateTime) =  CONVERT(DATE, GETDATE()) THEN GETDATE() ELSE CONVERT(DATETIME,CONVERT(DATE, M.CreatedDateTime)) + CAST(@Time as DATETIME) END) AS EndTime
										,UO.StatusName, D.ResourceId , 0 [Counter]
										FROM #DATESIDLETIME AS D
										INNER JOIN [User] AS U ON U.Id = D.UserId AND U.IsActive = 1
										INNER JOIN MessengerAudit AS M ON M.UserId = U.Id AND  CONVERT(DATE, M.CreatedDateTime) =  D.RefDate
										AND CONVERT(DATE, M.CreatedDateTime) BETWEEN CONVERT(DATE, @Startdate) AND CONVERT(DATE, @Enddate)
										INNER JOIN UserOnlineStatus AS UO ON UO.Id = M.StatusId 
									WHERE U.Id = @UserIdLocal
					) AS T
				)

				INSERT INTO #UserStatus
				SELECT StatusName, StartTime, EndTime, LEAD(StatusName) OVER (ORDER BY StartTime) LEAD , CreatedDate, UserId, UserName, ResourceId, [Counter],
													row_number() over(partition by UserId order by UserId, CreatedDate, StartTime) [UserOrder]  FROM CTE
					WHERE RN = 1 --AND StatusName IN ('Offline', 'Inactive')
						ORDER BY UserId, UserName, CreatedDate, StartTime
				
				DECLARE @cnt INT = 1, @max INT
				SELECT @max = count(*) FROM #UserStatus WHERE UserId = @UserIdLocal
				WHILE(@cnt <= @max)
				BEGIN
					UPDATE #UserStatus SET [Counter] = @counter WHERE UserOrder = @cnt AND UserId = @UserIdLocal
					IF EXISTS(SELECT * FROM #UserStatus WHERE UserOrder = @cnt and ApplicationTypeName <> NextTypeName AND UserId = @UserIdLocal)
					BEGIN
						SET @counter = @counter + 1;
					END
					SET @cnt = @cnt + 1
				END

				INSERT INTO #UserIdleStatus
				SELECT t.UserId, t.UserName, U.ProfileImage, CreatedDate, ApplicationTypeName, StartTime, EndTime, ResourceId,SpentTime = DATEDIFF(MINUTE, StartTime, EndTime) 
				FROM(
					SELECT DISTINCT UserId, UserName, CreatedDate,ApplicationTypeName,
					FIRST_VALUE(ApplicationStartTime) OVER (PARTITION BY [Counter] ORDER BY uSERiD,ApplicationStartTime )  AS StartTime,
					LAST_VALUE(ApplicationEndTime) OVER (PARTITION BY [Counter] ORDER BY UserId,ApplicationEndTime RANGE BETWEEN 
							UNBOUNDED PRECEDING AND 
							UNBOUNDED FOLLOWING )  AS EndTime
						FROM #UserStatus T
						WHERE T.UserId = @UserIdLocal AND ApplicationTypeName IN ('Offline', 'Inactive', 'Active')

				) AS t
				INNER JOIN #DATESIDLETIME D ON D.RefDate = T.CreatedDate AND D.UserId = T.UserId
				INNER JOIN [User] U ON U.Id = T.USerId
				WHERE DATEDIFF(MINUTE, StartTime, EndTime) > 0
				ORDER BY StartTime

				SET @Iden = @Iden + 1 
			END

			SELECT * FROM #UserIdleStatus

		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END