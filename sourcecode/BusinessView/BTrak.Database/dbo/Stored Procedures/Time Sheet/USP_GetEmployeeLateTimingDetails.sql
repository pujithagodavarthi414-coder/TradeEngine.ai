-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get the Employee Late Timing Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeLateTimingDetails] @OperationsPerformedBy='6412f248-3596-4c8e-a1ee-f870f0f9ea6f',@Type='Month',@Date='2019-03-01',@IsMorningLateEmployee=1,@IsLunchBreakLongTake=0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeLateTimingDetails]
(
   @Type VARCHAR(100)=NULL,
   @Date DATETIME = NULL,
   @IsMorningLateEmployee BIT = 0,
   @IsLunchBreakLongTake BIT = 0,
   @IsMoreSpentTime BIT = 0,
   @IsMorningAndAfterNoonLate BIT = 0,
   @Order VARCHAR(50) = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME=NULL
)  
AS
BEGIN
    SET NOCOUNT ON 
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
     IF (@HavePermission = '1')
     BEGIN

          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL;
        
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     
		  DECLARE @MaxWorkingHours INT = (SELECT CAST((SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = @OperationsPerformedBy) AND [Key] = 'MaximumWorkingHours') AS INT))
	      
          DECLARE @StartDate DATETIME
          
          DECLARE @EndDate DATETIME
		  IF(@Type = '' Or @Type IS NULL )
		  BEGIN
			  SELECT @StartDate =IIF(@DateFrom = @DateTo, DATEADD(MONTH, DATEDIFF(MONTH, 0, @DateFrom), 0),@DateFrom)
              SELECT @EndDate = IIF(@DateFrom = @DateTo, DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @DateTo) + 1, 0)),@DateTo)
		  
		  END
          IF(@Type = 'Month')
          BEGIN
              SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)
              SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
          END
        
          ELSE IF(@Type = 'Week')
          BEGIN
              SELECT @EndDate = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))
              SELECT @StartDate = DATEADD(dd, -(DATEPART(dw, @EndDate)-1), CAST(@EndDate AS DATE))
          END
        
          IF(@EndDate >= CONVERT(DATE,GETUTCDATE()))
          BEGIN
                  SELECT @EndDate = CONVERT(DATE,GETUTCDATE())
          END
          SET @SearchText = '%'+ @SearchText +'%'
          IF(@SortDirection IS NULL)
          BEGIN
     
                  SET @SortDirection = 'DESC'
     
          END
     
          IF(@IsMoreSpentTime = 0)
          BEGIN
     
                   SET @SortBy = 'FullName'
     
          END

          ELSE IF( @IsMoreSpentTime = 1)
          BEGIN
               SET @SortBy = 'SpentTime'
			   		
          END
		   ELSE IF(@IsMorningLateEmployee = 1)
          BEGIN
               SET @SortBy = 'FullName'
          END
          ELSE
          BEGIN
     
                   SET @SortBy = @SortBy
     
          END
          IF(@IsMorningLateEmployee = 1 OR @IsMorningAndAfterNoonLate = 1)
          BEGIN
     
		  SELECT *, CASE WHEN @IsMorningLateEmployee =  1 THEN (T.DaysLate - T.PermittedDays) ELSE 0 END AS DaysWithOutPermission,TotalCount = COUNT(1) OVER() 
		  FROM (
		  SELECT U.Id AS UserId,
		  ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS FullName,
		  U.ProfileImage,
		  @Type AS DaysLateFor,
		  CASE WHEN @IsMoreSpentTime = 1 THEN 0 ELSE COUNT(U.Id) END AS DaysLate,
		  CASE WHEN @IsMoreSpentTime = 0 THEN DENSE_RANK() OVER(PARTITION BY NULL ORDER BY COUNT(U.Id) DESC) ELSE 0 END [Rank],
		  CASE WHEN (@IsMoreSpentTime = 1 AND @Order IS NULL) THEN DENSE_RANK() OVER(PARTITION BY NULL ORDER BY SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))) DESC) ELSE 0 END [Rank1],
		  CASE WHEN (@IsMoreSpentTime = 1 AND @Order IS NOT NULL) THEN PERCENT_RANK() OVER (PARTITION BY NULL ORDER BY SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00')))) ELSE 0 END AS PctRank,  
		  CASE WHEN @IsMoreSpentTime = 1 THEN SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))) ELSE 0 END AS DaysMoreTimeSpent,
		  --CASE WHEN @IsMoreSpentTime = 0 THEN 0
		  --WHEN SUM(DATEDIFF(MINUTE,InTime,OutTime)) % 60  >= 30 THEN SUM(DATEDIFF(MINUTE,InTime,OutTime))/ 60 + 1 	
		  --ELSE ISNULL(SUM(DATEDIFF(MINUTE,InTime,OutTime))/ 60,0) END AS SpentTime,
		  CASE WHEN @IsMoreSpentTime = 0 THEN '0'
		  ELSE ISNULL([dbo].[Ufn_GetMinutesToHHMM](IIF(ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00')
		  ,CASE WHEN CAST(TS.[Date] AS DATE) = CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND TS.OutTime IS NULL THEN GETUTCDATE() 
          WHEN CAST(TS.[Date] AS DATE) <> CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND TS.OutTime IS NULL THEN DATEADD(HH,@MaxWorkingHours,SWITCHOFFSET(InTime, '+00:00')) 
		  ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00')
		  , SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) - ISNULL(SUM(Breaks),0) > 0

		  ,ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(InTime, '+00:00')
		  ,CASE WHEN CAST(TS.[Date] AS DATE) = CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND TS.OutTime IS NULL THEN GETUTCDATE() 
          WHEN CAST(TS.[Date] AS DATE) <> CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND TS.OutTime IS NULL THEN DATEADD(HH,@MaxWorkingHours,SWITCHOFFSET(InTime, '+00:00')) 
          ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) 
		  - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'), SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) - 
		  ISNULL(SUM(breaks),0),0)),0) END AS SpentTime,
		  CASE WHEN @IsMorningLateEmployee = 1 THEN ISNULL(
		  (SELECT COUNT(1)
		  FROM Permission P WITH (NOLOCK)
			   LEFT JOIN [User] U1 ON U1.Id = P.UserId  AND U1.InActiveDateTime IS NULL
			   LEFT JOIN [Employee] E ON E.UserId = U.Id 
				WHERE P.[Date] >= ISNULL(@StartDate,@DateFrom) 
     					AND P.[Date] <= ISNULL(@EndDate,@DateTo) 
     					AND IsMorning = 1
					AND (IsDeleted IS NULL OR IsDeleted = 0)
					AND P.[Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId=@CompanyId)
     			   AND U1.Id = U.Id 
     			   AND @IsMorningLateEmployee = 1
     			   GROUP By P.UserId),0) ELSE 0 END AS PermittedDays
		  FROM [User] U WITH (NOLOCK)
			   INNER JOIN Employee E ON E.UserId = U.Id AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL
	           INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                      AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                      AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                          AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			   INNER JOIN TimeSheet TS ON TS.UserId = U.Id 
			   LEFT JOIN (SELECT UserId,CONVERT(DATE,[Date]) AS [Date] ,SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UBB.BreakIn, '+00:00')
		  , SWITCHOFFSET(UBB.BreakOut, '+00:00'))) AS Breaks
			              FROM UserBreak UBB
						  INNER JOIN [User] U ON U.Id = UbB.UserId AND U.CompanyId = @CompanyId
						  AND UBB.[Date] >= ISNULL(@StartDate,@DateFrom)  
			   AND UBB.[Date] <=  ISNULL(@EndDate,@DateTo)
						  GROUP BY UserId,CONVERT(DATE,[Date])
						  ) UB  ON UB.UserId = TS.UserId AND UB.[Date] = TS.[Date]
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id 
			   AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,GETDATE()) 
			   AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,GETDATE()))))
			    AND ES.InActiveDateTime IS NULL						  
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date]) 
			   --INNER JOIN UserActiveDetails UAD ON UAD.UserId = U.Id  AND UAD.InactiveDateTime IS NULL
				LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND  SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
		  WHERE TS.[Date] >= ISNULL(@StartDate,@DateFrom)  
			   AND TS.[Date] <= ISNULL(@EndDate,@DateTo)
			   AND TS.[Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId=@CompanyId)
			   AND ((@IsMorningLateEmployee =  1 AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME)))
			   OR (@IsLunchBreakLongTake = 1 AND ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) > 70)
			   OR (@IsMorningAndAfterNoonLate = 1 AND (SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME)) 
			   AND ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) > 70))
			   OR (@IsMoreSpentTime = 1 AND (U.Id NOT IN (SELECT UserId FROM ExcludedUser))))
			   AND (U.CompanyId = @CompanyId)
  
          GROUP BY U.Id,U.FirstName,U.SurName,U.ProfileImage
          ) T
          WHERE ((@IsMoreSpentTime = 0 AND [Rank] <= 5) 
                  OR (@IsMoreSpentTime = 1 AND PctRank < 0.475 AND @Order='Bottom')
                  OR (@IsMoreSpentTime = 1 AND PctRank > 0.475 AND @Order='Top')
                  OR (@IsMoreSpentTime = 1 AND [Rank1] <= 5 AND @Order IS NULL))
                  AND (@SearchText IS NULL 
                       OR T.FullName LIKE @SearchText
                       OR T.DaysLate LIKE @SearchText
                       OR T.SpentTime LIKE @SearchText
                       OR (T.DaysLate - T.PermittedDays) LIKE @SearchText)
                         ORDER BY  
          CASE WHEN @SortDirection = 'ASC' THEN
          CASE WHEN @SortBy = 'SpentTime' THEN CAST(DaysMoreTimeSpent AS SQL_VARIANT)
               WHEN @SortBy = 'DaysLate' THEN CAST(DaysLate AS SQL_VARIANT)
               WHEN ( @SortBy IS NULL OR @SortBy = 'FullName') THEN CAST(FullName AS SQL_VARIANT)
               WHEN @SortBy = 'DaysWithOutPermission' THEN CAST(T.DaysLate - T.PermittedDays AS SQL_VARIANT)
               END
          END ASC,
          CASE WHEN @SortDirection = 'DESC' THEN
          CASE WHEN @SortBy = 'SpentTime' THEN CAST(DaysMoreTimeSpent AS SQL_VARIANT)
               WHEN @SortBy = 'DaysLate' THEN CAST(DaysLate AS SQL_VARIANT)
               WHEN ( @SortBy IS NULL OR @SortBy = 'FullName') THEN CAST(FullName AS SQL_VARIANT)  
               WHEN @SortBy = 'DaysWithOutPermission' THEN CAST(T.DaysLate - T.PermittedDays AS SQL_VARIANT)
               END
          END DESC
          OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
      
          FETCH NEXT @PageSize ROWS ONLY
             END
          IF(@IsMoreSpentTime = 1 OR @IsLunchBreakLongTake = 1)
		  BEGIN

		  SELECT *, CASE WHEN @IsMorningLateEmployee =  1 THEN (T.DaysLate - T.PermittedDays) ELSE 0 END AS DaysWithOutPermission,TotalCount = COUNT(1) OVER() FROM (
		  SELECT U.Id AS UserId,
		  ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS FullName,
		  U.ProfileImage,
		  @Type AS DaysLateFor,
		  (IIF(ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),CASE WHEN TS.[Date] = CAST(GETDATE()  AS DATE) AND TS.OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'), SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) - ISNULL(SUM( RInner.BreakTime),0) >0,ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), CASE WHEN TS.[Date] = CAST(GETDATE()  AS DATE) AND TS.OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),  SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) -  ISNULL(SUM( RInner.BreakTime),0) ,0)) [SpentTimeInMin],
		  CASE WHEN @IsMoreSpentTime = 1 THEN 0 ELSE COUNT(U.Id) END AS DaysLate,
		  CASE WHEN @IsMoreSpentTime = 0 THEN DENSE_RANK() OVER(PARTITION BY NULL ORDER BY COUNT(U.Id) DESC) ELSE 0 END [Rank],
		  CASE WHEN (@IsMoreSpentTime = 1 AND @Order IS NULL) THEN DENSE_RANK() OVER(PARTITION BY NULL ORDER BY SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))) DESC) ELSE 0 END [Rank1],
		  CASE WHEN (@IsMoreSpentTime = 1 AND @Order IS NOT NULL) THEN PERCENT_RANK() OVER (PARTITION BY NULL ORDER BY SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00')))) ELSE 0 END AS PctRank,  
		  CASE WHEN @IsMoreSpentTime = 1 THEN SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),CASE WHEN TS.[Date] = CAST(GETDATE()  AS DATE) AND TS.OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(OutTime, '+00:00') END)) ELSE 0 END AS DaysMoreTimeSpent,
		  --CASE WHEN @IsMoreSpentTime = 0 THEN 0
		  --WHEN SUM(DATEDIFF(MINUTE,InTime,OutTime)) % 60  >= 30 THEN SUM(DATEDIFF(MINUTE,InTime,OutTime))/ 60 + 1 	
		  --ELSE ISNULL(SUM(DATEDIFF(MINUTE,InTime,OutTime))/ 60,0) END AS SpentTime,
		  CASE WHEN @IsMoreSpentTime = 0 THEN '0'
		  ELSE ISNULL([dbo].[Ufn_GetMinutesToHHMM](IIF(ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),CASE WHEN TS.[Date] = CAST(GETDATE()  AS DATE) AND TS.OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'), SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) - ISNULL(SUM( RInner.BreakTime),0) >0,ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), CASE WHEN TS.[Date] = CAST(GETDATE()  AS DATE) AND TS.OutTime IS NULL THEN GETDATE() ELSE SWITCHOFFSET(OutTime, '+00:00') END)),0) - ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),  SWITCHOFFSET(LunchBreakEndTime, '+00:00'))),0) -  ISNULL(SUM( RInner.BreakTime),0) ,0)),0) END AS SpentTime,
		  CASE WHEN @IsMorningLateEmployee = 1 THEN ISNULL(
		  (SELECT COUNT(1)
		  FROM Permission P WITH (NOLOCK)
			   LEFT JOIN [User] U1 ON U1.Id = P.UserId  AND U1.InActiveDateTime IS NULL
     			   WHERE P.[Date] >= ISNULL(@StartDate,@DateFrom)  
     					AND P.[Date] <= ISNULL(@EndDate,@DateTo)
     					AND IsMorning = 1
					AND (IsDeleted IS NULL OR IsDeleted = 0)
					AND P.[Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId=@CompanyId)
     			   AND U1.Id = U.Id 
     			   AND @IsMorningLateEmployee = 1
     			   GROUP By P.UserId),0) ELSE 0 END AS PermittedDays
		  FROM [User] U WITH (NOLOCK)
			   INNER JOIN Employee E ON E.UserId = U.Id AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL
	           INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                      AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                      AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                          AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))			
			   INNER JOIN TimeSheet TS ON TS.UserId = U.Id 
			    LEFT JOIN (SELECT UB.UserId,CAST(UB.Date AS date) [Date],ISNULL(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))),0) BreakTime 
				FROM [User] U INNER JOIN UserBreak UB ON UB.UserId = U.Id WHERE UB.[Date] >= @StartDate AND UB.[Date] <= @EndDate AND U.CompanyId = @CompanyId
			       GROUP BY UB.UserId,CAST(UB.Date AS date)
			   )RInner ON RInner.UserId = TS.UserId AND TS.[Date] = RInner.[Date]
		  WHERE TS.[Date] >= @StartDate 
			   AND TS.[Date] <= @EndDate 
			   AND TS.[Date] NOT IN (SELECT [Date] FROM HoliDay WHERE InActiveDateTime IS NULL AND CompanyId=@CompanyId)
			   AND ((@IsLunchBreakLongTake = 1 AND ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) > 70)
			   OR (@IsMoreSpentTime = 1 AND (U.Id NOT IN (SELECT UserId FROM ExcludedUser))))
			   AND (U.CompanyId = @CompanyId)
  
          GROUP BY U.Id,U.FirstName,U.SurName,U.ProfileImage
          ) T
          WHERE ((@IsMoreSpentTime = 0 AND [Rank] <= 5) 
                  OR (@IsMoreSpentTime = 1 AND PctRank < 0.475 AND @Order='Bottom')
                  OR (@IsMoreSpentTime = 1 AND PctRank > 0.475 AND @Order='Top')
                  OR (@IsMoreSpentTime = 1 AND [Rank1] <= 5 AND @Order IS NULL))
                  AND (@SearchText IS NULL 
                       OR T.FullName LIKE @SearchText
                       OR T.DaysLate LIKE @SearchText
                       OR T.SpentTime LIKE @SearchText
                       OR (T.DaysLate - T.PermittedDays) LIKE @SearchText)
                         ORDER BY 
          CASE WHEN @SortDirection = 'ASC' THEN
          CASE WHEN @SortBy = 'SpentTime' THEN CAST(SpentTimeInMin AS SQL_VARIANT)
               WHEN @SortBy = 'DaysLate' THEN CAST(DaysLate AS SQL_VARIANT)
               WHEN (@SortBy IS NULL OR @SortBy = 'FullName') THEN CAST(FullName AS SQL_VARIANT)
               WHEN @SortBy = 'DaysWithOutPermission' THEN CAST(T.DaysLate - T.PermittedDays AS SQL_VARIANT)
               END
          END ASC,
          CASE WHEN @SortDirection = 'DESC' THEN
          CASE WHEN @SortBy = 'SpentTime' THEN CAST(SpentTimeInMin AS SQL_VARIANT)
               WHEN @SortBy = 'DaysLate' THEN CAST(DaysLate AS SQL_VARIANT)
               WHEN (@SortBy IS NULL OR @SortBy = 'FullName') THEN CAST(FullName AS SQL_VARIANT)  
               WHEN @SortBy = 'DaysWithOutPermission' THEN CAST(T.DaysLate - T.PermittedDays AS SQL_VARIANT)
               END
          END DESC
          OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
      
          FETCH NEXT @PageSize ROWS ONLY
             END

	 END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
     END TRY 
     BEGIN CATCH 
          EXEC [dbo].[USP_GetErrorInformation]
     END CATCH
END
GO