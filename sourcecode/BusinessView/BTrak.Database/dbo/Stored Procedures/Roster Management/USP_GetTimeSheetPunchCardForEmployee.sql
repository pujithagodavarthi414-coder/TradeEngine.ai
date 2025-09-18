CREATE PROCEDURE [dbo].[USP_GetTimeSheetPunchCardForEmployee]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER, 
	@UserId XML = NULL ,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@IsTrailExpired BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		SET @StartDate = (SELECT CAST(CAST(@StartDate AS DATE) AS DATETIME))
		SET @EndDate = (SELECT CAST(CAST(@EndDate AS DATE) AS DATETIME))
		 
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
        IF (@HavePermission = '1')
        BEGIN

			CREATE TABLE #UserIdList
			(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				UserId UNIQUEIDENTIFIER NULL
			)
			
			IF(@UserId IS NULL)
			INSERT INTO #UserIdList VALUES( '00000000-0000-0000-0000-000000000000' )

			IF(@IsTrailExpired = 1) SET @StartDate = DATEADD(DAY,-6, GETDATE());
			
			IF(@UserId IS NOT NULL)
			BEGIN
					--DELETE FROM #UserIdList WHERE UserId = '00000000-0000-0000-0000-000000000000'
					INSERT INTO #UserIdList (UserId)
					SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
					FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
			END

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
			CREATE TABLE #DATESTIME
			(
				RefDate datetime,
				UserId uniqueidentifier,
				ResourceId int identity(1,1)
			)

			;WITH cte AS(
				SELECT @StartDate RefDate
				UNION ALL
				SELECT DATEADD(dd, 1, RefDate) FROM cte WHERE RefDate < @EndDate
			)

			INSERT INTO #DATESTIME
			SELECT distinct RefDate, UserId FROM cte
			INNER JOIN #UserIdList ON 1 = 1
			ORDER BY UserId, RefDate ASC

			CREATE TABLE #UserBreakStatus
			(
				UserId uniqueidentifier,
				UserName NVARCHAR(50),
				ProfileImage NVARCHAR(600),
				CreatedDate DATE,
				StartTime DATETIME,
				EndTime DATETIME,
				ApplicationTypeName NVARCHAR(50),
				ResourceId INT
			)
			
			DECLARE @LeaveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)

			DECLARE @Iden INT = 1, @maxUser INT = (SELECT COUNT(*) FROM #UserIdList)
			DECLARE @counter INT = 1
			WHILE(@Iden <= @maxUser)
			BEGIN
					
				DECLARE @UserIdLocal UNIQUEIDENTIFIER = (SELECT UserId FROM #UserIdList WHERE Id = @Iden)

				--;with cte as(
				--	select @StartDate RefDate
				--	union all
				--	select dateadd(dd, 1, RefDate) from cte where RefDate < @EndDate
				--)

				--INSERT INTO #DATESTIME
				--select RefDate, UserId from cte	
				--inner join #UserIdList ON UserId = @UserIdLocal
				--order by UserId, RefDate ASC

				INSERT INTO #UserBreakStatus 
				SELECT U.Id UserId, U.FirstName + COALESCE( ' '+ U.SurName,'') UserName,
					U.ProfileImage,
					CreatedDate,
					TS.[InTime] StartTime,
					TS.[OutTime] EndTime,
					TS.StatusVal ApplicationTypeName,
					D.ResourceId
				FROM [User] U 
				CROSS APPLY(
					SELECT UserId, TS.Date CreatedDate, InTime, COALESCE(OutTime,  IIF( CONVERT(DATE, TS.DATE) = CONVERT(DATE, GETDATE()) , DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = TS.InTimeTimeZone), GETDATE()) ,  CONVERT(DATETIME, TS.DATE) + '23:59:59')) OutTime, 'Log' StatusVal From TimeSheet TS where UserId = U.Id AND TS.[Date] BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@EndDate) AND TS.InActiveDateTime IS NULL
					UNION
					SELECT UserId, TS.Date CreatedDate, LunchBreakStartTime, LunchBreakEndTime, 'Lunch' StatusVal From TimeSheet TS where UserId = U.Id AND TS.[Date] BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@EndDate) AND TS.InActiveDateTime IS NULL
					UNION
					(SELECT U.Id,[Date],[LeaveStartTime],[LeaveEndTime],'Leave' FROM [dbo].[Ufn_GetLeaveDatesOfAnUser](U.Id,NULL,NULL,@StartDate,@EndDate,@LeaveStatusId) T)
					UNION
					SELECT UserId, CONVERT(DATE, [Date]) CreatedDate, ub.BreakIn, ub.BreakOut, 'Break' StatusVal  From UserBreak Ub where UserId = U.Id AND CONVERT(DATE, Ub.[Date]) BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@EndDate)
				) TS
				INNER JOIN #UserIdList UL ON U.Id = UL.UserId
				INNER JOIN #DATESTIME D ON D.RefDate = TS.CreatedDate AND D.UserId = U.Id
				OUTER APPLY (SELECT UserId,[Date],SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)) AS UserBreak
							FROM UserBreak UB
							WHERE UB.UserId = U.Id AND UB.[Date] BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@EndDate)
							GROUP BY UserId,[Date]) UserBreak
				WHERE U.CompanyId = @CompanyId AND UL.UserId = @UserIdLocal
				AND TS.InTime IS NOT NULL AND TS.OutTime IS NOT NULL
		
				SET @Iden = @Iden + 1 
			END

			SELECT DISTINCT * FROM #UserBreakStatus
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