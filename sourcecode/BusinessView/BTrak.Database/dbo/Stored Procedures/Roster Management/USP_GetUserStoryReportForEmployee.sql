CREATE PROCEDURE [dbo].[USP_GetUserStoryReportForEmployee]
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
		 
         DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
			CREATE TABLE #UserIdList
			(
				UserId UNIQUEIDENTIFIER NULL
			)
					
			DECLARE @Time TIME = '23:59:59'

			INSERT INTO #UserIdList VALUES( '00000000-0000-0000-0000-000000000000' )

			
			IF(@UserId IS NOT NULL)
			BEGIN
					DELETE FROM #UserIdList WHERE UserId = '00000000-0000-0000-0000-000000000000'
					INSERT INTO #UserIdList (UserId)
					SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
					FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
			END			

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SET @StartDate = (SELECT CAST(CAST(@StartDate AS DATE) AS DATETIME))
			SET @EndDate = (SELECT CAST(CAST(@EndDate AS DATE) AS DATETIME))

            CREATE TABLE  #DATESTORY 
			(
				RefDate datetime,
				UserId uniqueidentifier,
				ResourceId int identity(1,1)
			)

			;with cte as(
				select @StartDate RefDate
				union all
				select dateadd(dd, 1, RefDate) from cte where RefDate < @EndDate
			)

			INSERT INTO #DATESTORY
			select DISTINCT *from cte
			inner join #UserIdList on 1=1
			ORDER BY UserId, RefDate ASC

			SELECT DISTINCT  U.Id UserId, U.FirstName + COALESCE( ''+ U.SurName,'') UserName, CONVERT(DATE, UT.CreatedDateTime) CreatedDate,
			CONVERT(DATETIME,SWITCHOFFSET(StartTime, '+00:00')) StartTime, CONVERT(DATETIME,(SWITCHOFFSET(ISNULL(EndTime, IIF(CONVERT(DATE, SWITCHOFFSET(UT.StartTime, '+00:00')) = CONVERT(DATE, GETDATE()) , GETDATE(), CONVERT(DATETIME,CONVERT(DATE, SWITCHOFFSET(StartTime, '+00:00'))) + CAST(@Time as DATETIME))), '+00:00'))) AS EndTime, US.UserStoryName AS UserStoryName, 'User Story' AS ApplicationTypeName,
			D.ResourceId
			FROM UserStorySpentTime UT
			INNER JOIN UserStory US ON US.Id = UT.UserStoryId
			INNER JOIN [User] U ON U.Id = UT.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
			INNER JOIN #UserIdList UL ON U.Id = UL.UserId
			INNER JOIN #DATESTORY D ON CONVERT(DATE, D.RefDate) = CONVERT(DATE, UT.CreatedDateTime) AND D.UserId = U.Id
			WHERE CONVERT(DATE, UT.CreatedDateTime) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
			AND U.CompanyId = @CompanyId AND UT.StartTime IS NOT NULL

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