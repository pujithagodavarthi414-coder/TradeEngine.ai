CREATE PROCEDURE [dbo].[USP_LateEmployeesWithPermissions]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER 
)
AS
BEGIN

  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
               
  IF (@HavePermission = '1')
  BEGIN

	IF(@UserId = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SET @UserId = NULL
	END

	--IF(@ToDate >= CONVERT(DATE,GETUTCDATE()))
	--BEGIN
	--	SELECT @ToDate = CONVERT(DATE,GETUTCDATE())
	--END

	DECLARE @PresentDate DATETIME
  DECLARE @DimDate TABLE
  (
       [Date] DATETIME
  )
  ;WITH CTE AS
  (
   SELECT CAST(@FromDate AS DATETIME) AS Result
   UNION ALL
   SELECT Result+1 FROM CTE WHERE Result+1 <= CAST(@ToDate AS DATETIME)
  )

   INSERT INTO @DimDate([Date])
   SELECT Result FROM CTE OPTION (maxrecursion 0)
   DECLARE DATE_CURSOR CURSOR FOR
   SELECT [Date] FROM @DimDate
   
   DECLARE @LateEmployees TABLE
   (
      UserId UniqueIdentifier,
      [Date] DATETIME,
      LateTime TIME
   )
   
   OPEN DATE_CURSOR
   FETCH NEXT FROM DATE_CURSOR INTO @PresentDate
   WHILE @@FETCH_STATUS = 0
   BEGIN
      INSERT INTO @LateEmployees(UserId,[Date],LateTime)
      SELECT U.Id,[Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
      FROM [User] U LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
					LEFT JOIN Employee E ON E.UserId = U.Id JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))
					LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
					LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id 					
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) 
					LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
      WHERE [Date] = @PresentDate AND CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND (U.CompanyId = @CompanyId)
      GROUP BY U.Id,TS.[Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
   FETCH NEXT FROM DATE_CURSOR INTO @PresentDate
   END
   CLOSE DATE_CURSOR
   DEALLOCATE DATE_CURSOR

   DECLARE @PermissionList TABLE
   (
      PermissionId UNIQUEIDENTIFIER,
      UserId UNIQUEIDENTIFIER,
	  [Date] DATETIME
   )

   INSERT INTO @PermissionList 
   SELECT Id,UserId,[Date] FROM Permission
   WHERE IsMorning = 1 AND (IsDeleted IS NULL OR IsDeleted = 0) 
		AND (@FromDate IS NULL OR [Date] >= @FromDate)  
		AND (@ToDate IS NULL OR [Date] <= @ToDate)
    

   DECLARE @FinalPermissionList TABLE
   (
      UserId UNIQUEIDENTIFIER,
      EmployeeName VARCHAR(800),
      LateTime TIME,
      PermissionId UNIQUEIDENTIFIER,
	  Duration TIME,
	  DurationInMinutes FLOAT,
      PermissionReasonId UNIQUEIDENTIFIER,
      ReasonName VARCHAR(800),
      [Date] DATETIME,
      PermissionGivenDate DATETIME
   )

   INSERT INTO @FinalPermissionList(UserId,EmployeeName,LateTime,PermissionId,Duration,DurationInMinutes,PermissionReasonId,ReasonName,[Date],PermissionGivenDate)
   SELECT LE.UserId,U.FirstName+' '+ISNULL(U.SurName,'') EmployeeName ,LE.LateTime,P.Id,P.Duration,P.DurationInMinutes,P.PermissionReasonId,PR.ReasonName,LE.[Date],(CASE WHEN P.UpdatedDateTime IS NULL THEN P.CreatedDateTime ELSE P.UpdatedDateTime END) AS PermissionGivenDate
   FROM @LateEmployees LE LEFT JOIN @PermissionList PL ON PL.UserId = LE.UserId AND PL.[Date] = LE.[Date] LEFT JOIN Permission P ON P.Id = PL.PermissionId LEFT JOIN PermissionReason PR ON PR.Id = P.PermissionReasonId JOIN [User] U ON U.Id = LE.UserId
   WHERE  U.CompanyId = @CompanyId
   
   SELECT FPL.* FROM @FinalPermissionList FPL JOIN [User] U ON U.Id = FPL.UserId
		WHERE (@UserId IS NULL OR UserId = @UserId)
			  AND U.CompanyId = @CompanyId

	  END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
END