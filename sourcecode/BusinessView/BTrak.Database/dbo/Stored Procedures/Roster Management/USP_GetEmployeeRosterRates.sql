CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterRates]
(
	@CreationDate DateTime,
	@StartTime TIME,
	@EndTime TIME,
	@EmployeeIds NVARCHAR(MAX),
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	
	DECLARE @EmployeeList AS TABLE
	(
		Id INT IDENTITY(1,1) PRIMARY KEY,
		CreatedDate Datetime,
		EmployeeId UNIQUEIDENTIFIER,
		Rate FLOAT null,
		IsPermanent BIT
	)

	set @CreationDate = CAST(@CreationDate AS DATE)
	
	IF (ISJSON(@EmployeeIds) > 0)  
	BEGIN
		INSERT INTO @EmployeeList(CreatedDate, EmployeeId)
		SELECT @CreationDate,VALUE FROM OPENJSON(@EmployeeIds)
	END
	ELSE
	BEGIN
		INSERT INTO @EmployeeList(CreatedDate, EmployeeId)
		SELECT @CreationDate, @EmployeeIds
	END
		
	SELECT ROW_NUMBER() OVER (ORDER BY E.Id,@CreationDate) Id,E.Id EmployeeId, E.UserId, @CreationDate [Date], DATENAME(WEEKDAY,@CreationDate) [DayOfWeek], SW.Id ShiftWeekId, ST.Id ShiftTimimgId, ST.ShiftName, SW.StartTime, SW.EndTime,
	       CAST(CAST(@CreationDate AS DATE) AS DATETIME) + CAST(CAST(SW.StartTime AS TIME) AS DATETIME) ShiftStartTime, 
		   CASE WHEN SW.StartTime > SW.EndTime THEN CAST(CAST(DATEADD(DAY,1,@CreationDate) AS DATE) AS DATETIME) + CAST(CAST(SW.EndTime AS TIME) AS DATETIME) 
		        ELSE CAST(CAST(@CreationDate AS DATE) AS DATETIME) + CAST(CAST(SW.EndTime AS TIME) AS DATETIME) END ShiftEndTime,
		   CAST(CAST(@CreationDate AS DATE) AS DATETIME) + CAST(CAST(SW.Deadline AS TIME) AS DATETIME) ShiftDeadline, 
		   SW.IsPaidBreak, SW.AllowedBreakTime,
		   CAST(CAST(@CreationDate AS DATE) AS DATETIME) + CAST(CAST(@StartTime AS TIME) AS DATETIME) InTime, 
		   CASE WHEN CAST(@StartTime AS TIME) > CAST(@EndTime AS TIME) THEN CAST(CAST(DATEADD(DAY,1,@CreationDate) AS DATE) AS DATETIME) + CAST(CAST(@EndTime AS TIME) AS DATETIME) 
		        ELSE CAST(CAST(@CreationDate AS DATE) AS DATETIME) + CAST(CAST(@EndTime AS TIME) AS DATETIME) END OutTime, 
		   NULL LunchBreakStartTime, NULL LunchBreakEndTime, NULL BreakInMin, 
		   WD.IsWeekEnd, IIF(H.Id IS NULL,0,1) IsBankHoliday, 1 IsRegularDay
	INTO #EmployeeDetails
	FROM Employee E
		 INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND E.InActiveDateTime IS NULL
		 INNER JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
		 INNER JOIN (SELECT J.EmployeeId, MAX(J.JoinedDate) JoinedDate 
					 FROM Job J 
					      INNER JOIN Employee E ON E.Id = J.EmployeeId
					 	  INNER JOIN [User] U ON U.Id = E.UserId
					 WHERE U.CompanyId = @CompanyId AND J.InActiveDateTime IS NULL GROUP BY EmployeeId) JInner ON JInner.EmployeeId = J.EmployeeId AND JInner.JoinedDate = J.JoinedDate
		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		      AND ( (EB.ActiveTo IS NOT NULL AND @CreationDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
			          OR (EB.ActiveTo IS NULL AND @CreationDate >= EB.ActiveFrom)
					  OR (EB.ActiveTo IS NOT NULL AND @CreationDate <= EB.ActiveTo)
				  ) 
		INNER JOIN EmploymentStatus ESS ON ESS.Id = J.EmploymentStatusId AND ESS.InActiveDateTime IS NULL
		INNER JOIN WeekDays WD ON WD.WeekDayName = DATENAME(WEEKDAY,@CreationDate) AND WD.CompanyId = @CompanyId
		INNER JOIN Branch B ON B.Id = EB.BranchId
		LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
				   AND ( (ES.ActiveTo IS NOT NULL AND @CreationDate BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND @CreationDate >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND @CreationDate <= ES.ActiveTo)
				  ) 
		LEFT JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.BranchId = EB.BranchId --AND ST.CompanyId = @CompanyId
		LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND SW.[DayOfWeek] = DATENAME(WEEKDAY,@CreationDate)
		LEFT JOIN Holiday H ON H.[Date] = @CreationDate AND H.CompanyId = @CompanyId AND H.CountryId = B.CountryId
	WHERE ESS.IsPermanent = 0
	      AND (@EmployeeIds IS NULL OR E.Id IN (SELECT EmployeeId FROM @EmployeeList))
	ORDER BY ES.EmployeeId,[Date]

	UPDATE #EmployeeDetails SET IsRegularDay = IIF(IsWeekEnd = 1 OR IsBankHoliday = 1,0,1) 

	CREATE TABLE #RateTagTypes 
	(
		RowId INT IDENTITY(1,1),
		Id UNIQUEIDENTIFIER,
		RateTagForName NVARCHAR(250),
		RateTagType NVARCHAR(250),
		[Order] INT
	)

	INSERT INTO #RateTagTypes
	SELECT * FROM
    (
        SELECT Id RateTagForId, RateTagForName,'RateTag' RateTagForType, 1 [Order] FROM RateTagFor WHERE CompanyId = @CompanyId
        UNION
        SELECT Id RateTagForId, PartsOfDayName,'PartsOfDay' RateTagForType, 2 [Order] FROM PartsOfDay WHERE CompanyId = @CompanyId
        UNION
        SELECT Id RateTagForId, WeekDayName,'WeekDays' RateTagForType, 3 [Order] FROM WeekDays WHERE CompanyId = @CompanyId
        UNION
        SELECT Id RateTagForId, Reason,'Holiday' RateTagForType, 4 [Order] FROM Holiday WHERE CompanyId = @CompanyId
        UNION
        SELECT Id RateTagForId, Reason,'SpecificDay' RateTagForType, 5 [Order] FROM SpecificDay WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL
     ) T
     ORDER BY [Order],RateTagForName
	
	CREATE TABLE #EmployeeRateTag
	(
		Id INT,
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		EmployeeRateTagId UNIQUEIDENTIFIER,
		RateTagId UNIQUEIDENTIFIER,
		MinTime FLOAT,
		MaxTime FLOAT,
		[Priority] INT,
		NewPriority INT
	)

	CREATE TABLE #DaysOfWeekConfiguration
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		DateOfWeekId UNIQUEIDENTIFIER,
		DateOfWeek NVARCHAR(100),
		PartsOfDayId UNIQUEIDENTIFIER,
		PartsOfDay NVARCHAR(100),
		FromTime TIME,
		ToTime TIME,
		FromDateTime DATETIME,
		ToDateTime DATETIME
	)

	CREATE TABLE #RateTagDetails 
	(
		Id INT,
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		EmployeeRateTagId UNIQUEIDENTIFIER,
		RateTagId UNIQUEIDENTIFIER,
		RateTagForId UNIQUEIDENTIFIER,
		RateTagForName NVARCHAR(250),
		[IsAllowance] INT,
		[BreakInMin] FLOAT,
		[BreakAllowance] FLOAT,
		[Priority] INT,
		NewPriority INT,
		FromDateTime DATETIME,
		ToDateTime DATETIME
	)

	declare @EmployeeRates as table  
	(
		Id INT,
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		EmployeeRateTagId UNIQUEIDENTIFIER,
		RateTagId UNIQUEIDENTIFIER,
		RateTagForId UNIQUEIDENTIFIER,
		RateTagForName NVARCHAR(250),
		[IsAllowance] INT,
		[BreakInMin] FLOAT,
		[BreakAllowance] FLOAT,
		[Priority] INT,
		NewPriority INT,
		InTime DATETIME,
		OutTime DATETIME,
		FromDateTime DATETIME,
		ToDateTime DATETIME
	)

	CREATE TABLE #EmployeeFinalRates 
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		EmployeeRateTagId UNIQUEIDENTIFIER,
		RateTagId UNIQUEIDENTIFIER,
		InTime DATETIME,
		OutTime DATETIME,
		FromDateTime DATETIME,
		ToDateTime DATETIME,
		FinalFromDateTime DATETIME,
		FinalToDateTime DATETIME,
		[BreakInMin] FLOAT,
		[BreakAllowance] FLOAT,
		AdditionalTimeInMin FLOAT,
		AdditionalAllowance FLOAT,
		Rate FLOAT,
		FinalRate FLOAT
	)

	CREATE TABLE #EmployeeFinalRates1 
	(
		Id INT IDENTITY(1,1),
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATETIME,
		EmployeeRateTagId UNIQUEIDENTIFIER,
		RateTagId UNIQUEIDENTIFIER,
		InTime DATETIME,
		OutTime DATETIME,
		FromDateTime DATETIME,
		ToDateTime DATETIME,
		FinalFromDateTime DATETIME,
		FinalToDateTime DATETIME,
		[BreakInMin] FLOAT,
		[BreakAllowance] FLOAT,
		AdditionalTimeInMin FLOAT,
		AdditionalAllowance FLOAT,
		Rate FLOAT,
		FinalRate FLOAT
	)

	CREATE TABLE #TimeSlot
	(
		Id INT IDENTITY(1,1),
		FromDateTime DATETIME,
		ToDateTime DATETIME,
		[Type] INT,
		IsDeleted BIT
	)

	CREATE TABLE #FilteredTimeSlot
	(
		Id INT IDENTITY(1,1),
		FromDateTime DATETIME,
		ToDateTime DATETIME,
		[Type] INT
	)

	DECLARE @EmployeeDetailsCounter INT = 1, @EmployeeDetailsCount INT, @IsRegularDay BIT, @IsBankHoliday BIT, @IsWeekEnd BIT, @EmployeeId UNIQUEIDENTIFIER, @EmployeeBranchId UNIQUEIDENTIFIER, @EmployeeRoleIds NVARCHAR(MAX), @ShiftStartTime DATETIME, @ShiftEndTime DATETIME,
	        @Date DATE, @DayOfWeek NVARCHAR(100), @InTime DATETIME, @OutTime DATETIME, @IsPaidBreak BIT, @BreakAllowanceMaxTime FLOAT, @LunchBreakInMin FLOAT, @BreakInMin FLOAT,
			@OffSet NVARCHAR(100), @OffSetSign NVARCHAR(10), @OffSetInMin FLOAT, @OffSetInMinWithSign FLOAT, @TimeZoneName NVARCHAR(150), @EmployeeRateTagCount INT, @EmployeeRateTagCounter INT,
			@FromDateTime1 DATETIME, @ToDateTime1 DATETIME, @FromDateTime2 DATETIME, @ToDateTime2 DATETIME, @FinalFromDateTime DATETIME, @FinalToDateTime DATETIME, @MinTime FLOAT, @MaxTime FLOAT,
			@TotalTags INT, @SatisfiedTags INT, @TotalTagsCounter INT, @RateTagId UNIQUEIDENTIFIER, @RateTagForName NVARCHAR(250), @RateTagType NVARCHAR(250), @IsAllowance INT, @RateTagForId UNIQUEIDENTIFIER,
			@Priority INT, @NewPriority INT, @DayStartDateTime DATETIME, @DayEndDateTime DATETIME, @EmployeeRateTagId UNIQUEIDENTIFIER, @EmployeeRatesCount INT, @EmployeeRatesCounter INT,
			@CameEarlyToBePaid BIT, @CameEarlyAllowanceMinTime FLOAT, @CameEarlyAllowanceMaxTime FLOAT, @CameEarlyAllowance FLOAT, @CameEarlyHoursSpent FLOAT, @CameEarlyMinutesSpent FLOAT,
			@StayLateToBePaid BIT, @StayLateAllowanceMinTime FLOAT, @StayLateAllowanceMaxTime FLOAT, @StayLateAllowance FLOAT, @StayLateHoursSpent FLOAT, @StayLateMinutesSpent FLOAT,
			@CameLateToBePaid BIT, @CameLateAllowanceMaxTime DATETIME, @CameLateAllowance FLOAT, @CameLateHoursSpent FLOAT, @CameLateMinutesSpent FLOAT,
			@WentEarlyToBePaid BIT, @WentEarlyAllowance FLOAT, @WentEarlyHoursSpent FLOAT, @WentEarlyMinutesSpent FLOAT,
			@BreakAllowance FLOAT, @BreakInHours FLOAT

	SELECT @EmployeeDetailsCount = MAX(Id) FROM #EmployeeDetails

	WHILE(@EmployeeDetailsCounter <= @EmployeeDetailsCount)
	BEGIN

		SELECT @IsRegularDay = IsRegularDay, @IsBankHoliday = IsBankHoliday, @IsWeekEnd = IsWeekEnd, @EmployeeId = EmployeeId, @Date = [Date], @DayOfWeek = [DayOfWeek], @InTime = InTime, @OutTime = OutTime,
		       @LunchBreakInMin = DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime), @BreakInMin = BreakInMin, @ShiftStartTime = ShiftStartTime, @ShiftEndTime = ShiftEndTime, @IsPaidBreak = IsPaidBreak, 
			   @BreakAllowanceMaxTime = AllowedBreakTime, @CameLateAllowanceMaxTime = ShiftDeadline
		FROM #EmployeeDetails 
		WHERE Id = @EmployeeDetailsCounter

		SELECT @EmployeeBranchId = BranchId
		FROM EmployeeBranch EB
		WHERE EB.EmployeeId = @EmployeeId
		      AND ((EB.ActiveTo IS NULL AND @CreationDate >= EB.ActiveFrom)
				   OR (EB.ActiveTo IS NOT NULL AND @CreationDate <= EB.ActiveTo AND @CreationDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				)

		SELECT @EmployeeRoleIds = STUFF((SELECT ',' + CAST(RoleId AS NVARCHAR(50)) FROM UserRole WHERE InactiveDateTime IS NULL AND UserId = (SELECT UserId FROM Employee WHERE Id = @EmployeeId) FOR XML PATH('')), 1, 1, '')

		SELECT @TimeZoneName = TimeZoneName 
		FROM Branch B INNER JOIN TimeZone TZ ON TZ.Id = B.TimeZoneId 
		WHERE B.Id = @EmployeeBranchId

		SELECT @OffSet = RIGHT(GETUTCDATE() AT TIME ZONE @TimeZoneName,6)
		SELECT @OffSetSign = LEFT(@OffSet,1)
		SELECT @OffSet = REPLACE(@OffSet,'+','')
		SELECT @OffSetInMin = (LEFT(@OffSet,2) * 60) + RIGHT(@OffSet,2)
		SELECT @OffSetInMinWithSign = CASE WHEN @OffSetSign = '+' THEN @OffSetInMin ELSE -1 * @OffSetInMin END
		SELECT @OffSetInMinWithSign = CASE WHEN @OffSetInMinWithSign IS NULL THEN 0 ELSE @OffSetInMinWithSign END
		
		SELECT @ShiftStartTime = CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,StartTime) AS TIME) AS DATETIME), 
		       @ShiftEndTime = CASE WHEN DATEADD(MINUTE,@OffSetInMinWithSign,StartTime) > DATEADD(MINUTE,@OffSetInMinWithSign,EndTime) THEN CAST(CAST(DATEADD(DAY,1,@Date) AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,EndTime) AS TIME) AS DATETIME) 
		                            ELSE CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,EndTime) AS TIME) AS DATETIME) END
		FROM #EmployeeDetails WHERE Id = @EmployeeDetailsCounter
		
		--SELECT @InTime = DATEADD(MINUTE,@OffSetInMinWithSign,@InTime), @OutTime = DATEADD(MINUTE,@OffSetInMinWithSign,@OutTime)
		SELECT @CameLateAllowanceMaxTime = DATEADD(MINUTE,@OffSetInMinWithSign,@CameLateAllowanceMaxTime)

		SELECT @DayStartDateTime = CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST('00:00:00' AS TIME) AS DATETIME),
		       @DayEndDateTime = CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST('23:59:59' AS TIME) AS DATETIME)

		SELECT @CameEarlyToBePaid = 1
		FROM [ContractPaySettings] CPS 
		     INNER JOIN ContractPayType CPT ON CPT.Id = CPS.ContractPayTypeId
		WHERE CPS.[BranchId] = @EmployeeBranchId
			  AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
	  		         OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
					 OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo)
	  			   )
			  AND CPT.ContractPayTypeName = 'Early coming' AND IsToBePaid = 1

		SELECT @StayLateToBePaid = 1
		FROM [ContractPaySettings] CPS 
		     INNER JOIN ContractPayType CPT ON CPT.Id = CPS.ContractPayTypeId
		WHERE CPS.[BranchId] = @EmployeeBranchId
			  AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
	  		         OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
					 OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo)
	  			   )
			  AND CPT.ContractPayTypeName = 'Late going' AND IsToBePaid = 1
				 
		SELECT @CameLateToBePaid = 1
		FROM [ContractPaySettings] CPS 
		     INNER JOIN ContractPayType CPT ON CPT.Id = CPS.ContractPayTypeId
		WHERE CPS.[BranchId] = @EmployeeBranchId
			  AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
	  		         OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
					 OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo)
	  			   )
			  AND CPT.ContractPayTypeName = 'Late coming' AND IsToBePaid = 1

		SELECT @WentEarlyToBePaid = 1
		FROM [ContractPaySettings] CPS 
		     INNER JOIN ContractPayType CPT ON CPT.Id = CPS.ContractPayTypeId
		WHERE CPS.[BranchId] = @EmployeeBranchId
			  AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
	  		         OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
					 OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo)
	  			   )
			  AND CPT.ContractPayTypeName = 'Early going' AND IsToBePaid = 1 

		IF(@CameLateToBePaid = 1 AND @CameLateAllowanceMaxTime IS NOT NULL AND @InTime > @ShiftStartTime) SELECT @InTime = CASE WHEN @InTime <= @CameLateAllowanceMaxTime THEN @ShiftStartTime ELSE @InTime END

		--TRUNCATE TABLE #EmployeeRateTag

		INSERT INTO #EmployeeRateTag
		SELECT NewPriority Id, *
		FROM (
		SELECT @EmployeeId EmployeeId,@Date [Date],ERT.Id,ERT.RateTagId,RT.MinTime,RT.MaxTime,ERT.[Priority],ROW_NUMBER() OVER(ORDER BY @EmployeeId,@Date,ISNULL(ERT.GroupPriority,0),ISNULL(ERT.[Priority],50),ERT.RateTagId) NewPriority
		FROM EmployeeRateTag ERT
		     INNER JOIN RateTag RT ON RT.Id = ERT.RateTagId
		WHERE ERT.InActiveDateTime IS NULL 
			  AND ERT.RateTagEmployeeId = @EmployeeId
			  AND ( (RateTagEndDate IS NOT NULL AND @Date BETWEEN RateTagStartDate AND RateTagEndDate)
	  		         OR (RateTagEndDate IS NULL AND @Date >= RateTagStartDate)
					 OR (RateTagEndDate IS NOT NULL AND @Date <= RateTagEndDate)
	  			   )
		) T
		ORDER BY EmployeeId,[Date],NewPriority,RateTagId
		
		IF((SELECT COUNT(1) FROM #EmployeeRateTag WHERE EmployeeId = @EmployeeId AND [Date] = @Date) = 0)
		BEGIN
		 
			INSERT INTO #EmployeeRateTag
			SELECT NewPriority Id, *
			FROM (
			SELECT @EmployeeId EmployeeId,@Date [Date],RTC.Id,RTC.RateTagId,RT.MinTime,RT.MaxTime,ERT.[Priority],ROW_NUMBER() OVER(ORDER BY @EmployeeId,@Date,ISNULL(ERT.[Priority],0),ISNULL(RTC.[Priority],50),RTC.RateTagId) NewPriority
			FROM RateTagRoleBranchConfiguration ERT
			     INNER JOIN RateTagConfiguration RTC ON ERT.Id = RTC.RateTagRoleBranchConfigurationId
			     INNER JOIN RateTag RT ON RT.Id = RTC.RateTagId
			WHERE ERT.InActiveDateTime IS NULL AND RTC.InActiveDateTime IS NULL
				  AND ((ERT.RoleId IS NULL AND ERT.BranchId = @EmployeeBranchId) OR (ERT.BranchId IS NULL AND ERT.RoleId IN (SELECT CAST(Id AS NVARCHAR(50)) FROM UfnSplit(@EmployeeRoleIds))) 
				        OR (ERT.BranchId = @EmployeeBranchId AND ERT.RoleId IN (SELECT CAST(Id AS NVARCHAR(50)) FROM UfnSplit(@EmployeeRoleIds)))
						OR (ERT.RoleId IS NULL AND ERT.BranchId IS NULL))
				  AND ( (EndDate IS NOT NULL AND @Date BETWEEN StartDate AND EndDate)
	  			         OR (EndDate IS NULL AND @Date >= StartDate)
						 OR (EndDate IS NOT NULL AND @Date <= EndDate)
	  				   )
			) T
			ORDER BY EmployeeId,[Date],NewPriority,RateTagId
			
		END
		
		TRUNCATE TABLE #DaysOfWeekConfiguration

		INSERT INTO #DaysOfWeekConfiguration
		SELECT @EmployeeId,@Date,WD.Id,@DayOfWeek,PD.Id,PD.PartsOfDayName,FromTime,ToTime,
		       CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,DWC.FromTime) AS TIME) AS DATETIME) FromDateTime,
			   CASE WHEN CAST(DATEADD(MINUTE,@OffSetInMinWithSign,DWC.FromTime) AS TIME) > CAST(DATEADD(MINUTE,@OffSetInMinWithSign,DWC.ToTime) AS TIME) THEN CAST(CAST(DATEADD(DAY,1,@Date) AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,DWC.ToTime) AS TIME) AS DATETIME)
					ELSE CAST(CAST(@Date AS DATE) AS DATETIME) + CAST(CAST(DATEADD(MINUTE,@OffSetInMinWithSign,DWC.ToTime) AS TIME) AS DATETIME) END ToDateTime
		FROM DaysOfWeekConfiguration DWC
		     INNER JOIN WeekDays WD ON WD.Id = DWC.DaysOfWeekId AND WD.WeekDayName = @DayOfWeek AND WD.CompanyId = @CompanyId AND DWC.BranchId = @EmployeeBranchId
			 INNER JOIN PartsOfDay PD ON PD.Id = DWC.PartsOfDayId AND PD.CompanyId = @CompanyId
		WHERE DWC.InActiveDateTime IS NULL 
			  AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
	  		         OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
					 OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo)
	  			   )

		SELECT @EmployeeRateTagCount = NULL, @EmployeeRateTagCounter = 1, @FinalFromDateTime = NULL, @FinalToDateTime = NULL

		SELECT @EmployeeRateTagCount = COUNT(1) FROM #EmployeeRateTag WHERE [Date] = @Date AND EmployeeId = @EmployeeId
		
		WHILE(@EmployeeRateTagCounter <= @EmployeeRateTagCount)
		BEGIN
		
			SELECT @TotalTags = NULL, @SatisfiedTags = 0, @TotalTagsCounter = 1, @Priority = NULL, @NewPriority = NULL, @MinTime = NULL, @MaxTime = NULL

			SELECT @RateTagId = RateTagId, @EmployeeRateTagId = EmployeeRateTagId, @Priority = [Priority], @NewPriority = NewPriority, @EmployeeRateTagId = EmployeeRateTagId, @MinTime = MinTime, @MaxTime = MaxTime  
			FROM #EmployeeRateTag WHERE Id = @EmployeeRateTagCounter AND [Date] = @Date AND EmployeeId = @EmployeeId
			
			--TRUNCATE TABLE #RateTagDetails
			
			INSERT INTO #RateTagDetails(Id,EmployeeId,[Date],EmployeeRateTagId,RateTagId,RateTagForId,RateTagForName,IsAllowance,[Priority],NewPriority)
		    SELECT ROW_NUMBER() OVER(PARTITION BY @Date,@EmployeeId,@EmployeeRateTagId ORDER BY @Date,@EmployeeId,@EmployeeRateTagId),@EmployeeId,@Date [Date],@EmployeeRateTagId,RTD.RateTagId,RTD.RateTagForId,RTT.RateTagForName,ISNULL(RTF.IsAllowance,0),@Priority,@NewPriority
		    FROM RateTagDetails RTD
			     INNER JOIN #RateTagTypes RTT ON RTT.Id = RTD.RateTagForId
			     LEFT JOIN RateTagFor RTF ON RTF.Id = RTD.RateTagForId
		    WHERE RateTagId = @RateTagId
			      AND RTD.InActiveDateTime IS NULL
			
			SELECT @TotalTags = COUNT(1) FROM #RateTagDetails WHERE [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId
			
			WHILE(@TotalTagsCounter <= @TotalTags)
			BEGIN
			
				SELECT @RateTagForName = NULL, @RateTagType = NULL

				SELECT @RateTagForId = RateTagForId 
				FROM #RateTagDetails 
				WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId
				
				SELECT @RateTagForName = RateTagForName, @RateTagType = RateTagType
				FROM #RateTagTypes
				WHERE Id = @RateTagForId
				
				IF(@RateTagType = 'RateTag')
				BEGIN
				
					SELECT @IsAllowance = IsAllowance FROM RateTagFor WHERE CompanyId = @CompanyId AND Id = @RateTagForId
					
					IF(@IsAllowance = 1 AND @RateTagForName = 'Early' AND @CameEarlyToBePaid = 1 AND @InTime < @ShiftStartTime)
					BEGIN
					
						SELECT @CameEarlyAllowanceMinTime = @MinTime, @CameEarlyAllowanceMaxTime = @MaxTime

						SELECT @CameEarlyMinutesSpent = DATEDIFF(MINUTE,@InTime,@ShiftStartTime)

						SELECT @CameEarlyAllowanceMinTime = CASE WHEN @CameEarlyAllowanceMinTime IS NULL AND @CameEarlyAllowanceMaxTime IS NOT NULL THEN 0 ELSE @CameEarlyAllowanceMinTime END
						
						SELECT @CameEarlyMinutesSpent = CASE WHEN @CameEarlyMinutesSpent > @CameEarlyAllowanceMaxTime THEN @CameEarlyAllowanceMaxTime ELSE @CameEarlyMinutesSpent END

						SELECT @CameEarlyHoursSpent = ROUND(@CameEarlyMinutesSpent/60.0,2)
						
						SELECT @CameEarlyAllowance = CASE WHEN @CameEarlyMinutesSpent >= @CameEarlyAllowanceMinTime THEN @CameEarlyMinutesSpent END
						
						UPDATE #RateTagDetails SET FromDateTime = IIF(@CameEarlyAllowance IS NOT NULL,DATEADD(MINUTE,-@CameEarlyAllowance,@ShiftStartTime),NULL),
					                               ToDateTime = IIF(@CameEarlyAllowance IS NOT NULL,@ShiftStartTime,NULL)
						WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

						SELECT @SatisfiedTags = @SatisfiedTags + 1

					END
					ELSE IF(@IsAllowance = 1 AND @RateTagForName = 'Overtime' AND @StayLateToBePaid = 1 AND @OutTime > @ShiftEndTime)
					BEGIN

						SELECT @StayLateAllowanceMinTime = @MinTime, @StayLateAllowanceMaxTime = @MaxTime

						SELECT @StayLateMinutesSpent = DATEDIFF(MINUTE,@ShiftEndTime,@OutTime)

						SELECT @StayLateAllowanceMinTime = CASE WHEN @StayLateAllowanceMinTime IS NULL AND @StayLateAllowanceMaxTime IS NOT NULL THEN 0 ELSE @StayLateAllowanceMinTime END
						
						SELECT @StayLateMinutesSpent = CASE WHEN @StayLateMinutesSpent > @StayLateAllowanceMaxTime THEN  @StayLateAllowanceMaxTime ELSE @StayLateMinutesSpent END

						SELECT @StayLateHoursSpent = ROUND(@StayLateMinutesSpent/60.0,2)
						
						SELECT @StayLateAllowance = CASE WHEN @StayLateMinutesSpent > @StayLateAllowanceMinTime THEN @StayLateMinutesSpent END

						UPDATE #RateTagDetails SET FromDateTime = IIF(@StayLateAllowance IS NOT NULL,@ShiftEndTime,NULL),
					                               ToDateTime = IIF(@StayLateAllowance IS NOT NULL,DATEADD(MINUTE,@StayLateAllowance,@ShiftEndTime),NULL)
						WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

						SELECT @SatisfiedTags = @SatisfiedTags + 1
						
					END
					ELSE IF(@IsAllowance = 1 AND @RateTagForName = 'Paid break' AND @IsPaidBreak = 1 AND @BreakInMin > 0)
					BEGIN

						SELECT @BreakInHours = ROUND(@BreakInMin/60.0,2)
				
				        SELECT @BreakAllowance = CASE WHEN @BreakInMin <= @BreakAllowanceMaxTime THEN @BreakInMin ELSE 0 END

						UPDATE #RateTagDetails SET BreakInMin = @BreakAllowance WHERE Id = @TotalTagsCounter

						SELECT @SatisfiedTags = @SatisfiedTags + 1

					END
					ELSE IF((@RateTagForName = 'Regular Day' AND @IsRegularDay = 1) OR (@RateTagForName = 'Holiday' AND @IsBankHoliday = 1) OR (@RateTagForName = 'WeekEnd' AND @IsWeekEnd = 1))
					BEGIN
				
						--UPDATE #RateTagDetails SET FromDateTime = CASE WHEN @InTime > @DayStartDateTime THEN @InTime ELSE @DayStartDateTime END,
					 --                              ToDateTime = CASE WHEN @OutTime > @DayEndDateTime THEN @DayEndDateTime ELSE @OutTime END
						--WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND RateTagId = @RateTagId

						UPDATE #RateTagDetails SET FromDateTime = @InTime,
					                               ToDateTime = @OutTime
						WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId
						
						SELECT @SatisfiedTags = @SatisfiedTags + 1

					END

				END
				ELSE IF(@RateTagType = 'PartsOfDay' AND (SELECT COUNT(1) FROM #DaysOfWeekConfiguration WHERE PartsOfDay = @RateTagForName AND (@InTime <= FromDateTime OR @InTime BETWEEN FromDateTime AND ToDateTime) AND (@OutTime >= ToDateTime OR @OutTime BETWEEN FromDateTime AND ToDateTime)) > 0)
				BEGIN

					UPDATE #RateTagDetails SET FromDateTime = CASE WHEN DWC.FromDateTime > @InTime THEN DWC.FromDateTime ELSE @InTime END,
					                           ToDateTime = CASE WHEN @OutTime > DWC.ToDateTime THEN DWC.ToDateTime ELSE @OutTime END
					FROM #DaysOfWeekConfiguration DWC INNER JOIN #RateTagDetails RTD ON RTD.Id = @TotalTagsCounter AND RTD.[Date] = @Date AND RTD.EmployeeId = @EmployeeId AND RTD.RateTagId = @RateTagId
					WHERE DWC.PartsOfDay = @RateTagForName

					SELECT @SatisfiedTags = @SatisfiedTags + 1 
					

				END
				ELSE IF(@RateTagType = 'WeekDays' AND @RateTagForName = @DayOfWeek)
				BEGIN
				
					UPDATE #RateTagDetails SET FromDateTime = CASE WHEN @InTime > @DayStartDateTime THEN @InTime ELSE @DayStartDateTime END,
					                           ToDateTime = CASE WHEN @OutTime > @DayEndDateTime THEN @DayEndDateTime ELSE @OutTime END
					WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

					SELECT @SatisfiedTags = @SatisfiedTags + 1

				END
				ELSE IF(@RateTagType = 'Holiday' AND (SELECT COUNT(1) FROM Holiday WHERE CompanyId = @CompanyId AND [Date] = @Date AND Reason = @RateTagForName) > 0)
				BEGIN
				
					UPDATE #RateTagDetails SET FromDateTime = CASE WHEN @InTime > @DayStartDateTime THEN @InTime ELSE @DayStartDateTime END,
					                           ToDateTime = CASE WHEN @OutTime > @DayEndDateTime THEN @DayEndDateTime ELSE @OutTime END
					WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

					SELECT @SatisfiedTags = @SatisfiedTags + 1

				END
				ELSE IF(@RateTagType = 'SpecificDay' AND (SELECT COUNT(1) FROM SpecificDay WHERE CompanyId = @CompanyId AND [Date] = @Date AND Reason = @RateTagForName) > 0)
				BEGIN
				
					UPDATE #RateTagDetails SET FromDateTime = CASE WHEN @InTime > @DayStartDateTime THEN @InTime ELSE @DayStartDateTime END,
					                           ToDateTime = CASE WHEN @OutTime > @DayEndDateTime THEN @DayEndDateTime ELSE @OutTime END
					WHERE Id = @TotalTagsCounter AND [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

					SELECT @SatisfiedTags = @SatisfiedTags + 1

				END

				SET @TotalTagsCounter = @TotalTagsCounter + 1

			END
		
			IF @SatisfiedTags > 0 
			BEGIN
			
				SELECT @TotalTags = NULL, @EmployeeRatesCounter = 1,
				       @FromDateTime1 = NULL, @ToDateTime1 = NULL, @FromDateTime2 = NULL, @ToDateTime2 = NULL
				
				--TRUNCATE TABLE @EmployeeRates

				INSERT INTO @EmployeeRates(Id,EmployeeId,[Date],EmployeeRateTagId,RateTagId,RateTagForId,RateTagForName,IsAllowance,BreakInMin,[Priority],NewPriority,InTime,OutTime,FromDateTime,ToDateTime)
				SELECT * FROM (
				SELECT ROW_NUMBER() OVER(PARTITION BY @Date,@EmployeeId,@EmployeeRateTagId ORDER BY @Date,@EmployeeId,@EmployeeRateTagId) Id,@EmployeeId EmployeeId,@Date [Date],RTD.EmployeeRateTagId,RTD.RateTagId,RTD.RateTagForId,RTD.RateTagForName,RTD.IsAllowance,RTD.BreakInMin,RTD.[Priority],RTD.NewPriority,@InTime InTime,@OutTime OutTime,RTD.FromDateTime,RTD.ToDateTime
				FROM #RateTagDetails RTD 
				     INNER JOIN EmployeeRateTag ERT ON ERT.Id = @EmployeeRateTagId
				WHERE RTD.EmployeeRateTagId = @EmployeeRateTagId AND RTD.EmployeeId = @EmployeeId AND RTD.[Date] = @Date
				) T
				ORDER BY DATEDIFF(MINUTE,FromDateTime,ToDateTime) DESC
				
				INSERT INTO @EmployeeRates(Id,EmployeeId,[Date],EmployeeRateTagId,RateTagId,RateTagForId,RateTagForName,IsAllowance,BreakInMin,[Priority],NewPriority,InTime,OutTime,FromDateTime,ToDateTime)
				SELECT * FROM (
				SELECT ROW_NUMBER() OVER(PARTITION BY @Date,@EmployeeId,@EmployeeRateTagId ORDER BY @Date,@EmployeeId,@EmployeeRateTagId) Id,@EmployeeId EmployeeId,@Date [Date],RTD.EmployeeRateTagId,RTD.RateTagId,RTD.RateTagForId,RTD.RateTagForName,RTD.IsAllowance,RTD.BreakInMin,RTD.[Priority],RTD.NewPriority,@InTime InTime,@OutTime OutTime,RTD.FromDateTime,RTD.ToDateTime
				FROM #RateTagDetails RTD 
				     INNER JOIN RateTagConfiguration ERT ON ERT.Id = @EmployeeRateTagId
				WHERE RTD.EmployeeRateTagId = @EmployeeRateTagId AND RTD.EmployeeId = @EmployeeId AND RTD.[Date] = @Date
				) T
				ORDER BY DATEDIFF(MINUTE,FromDateTime,ToDateTime) DESC
				
				SELECT @EmployeeRatesCount = COUNT(1) FROM @EmployeeRates WHERE [Date] = @Date AND EmployeeId = @EmployeeId AND EmployeeRateTagId = @EmployeeRateTagId

				-- Getting common time of all rate types start
				SELECT @FromDateTime1 = FromDateTime, @ToDateTime1 = ToDateTime FROM @EmployeeRates WHERE EmployeeRateTagId = @EmployeeRateTagId AND EmployeeId = @EmployeeId AND [Date] = @Date AND Id = @EmployeeRatesCounter
				
				WHILE(@EmployeeRatesCounter <= @EmployeeRatesCount)
				BEGIN

					SELECT @FromDateTime2 = FromDateTime, @ToDateTime2 = ToDateTime FROM @EmployeeRates WHERE EmployeeRateTagId = @EmployeeRateTagId AND EmployeeId = @EmployeeId AND [Date] = @Date AND Id = @EmployeeRatesCounter + 1

					IF((SELECT COUNT(1) FROM @EmployeeRates WHERE EmployeeRateTagId = @EmployeeRateTagId AND EmployeeId = @EmployeeId AND [Date] = @Date AND Id = @EmployeeRatesCounter + 1) = 0)
					BEGIN
					
						SELECT @FromDateTime2 = @FromDateTime1, @ToDateTime2 = @ToDateTime1

					END
					ELSE IF(@FromDateTime1 IS NULL OR @FromDateTime2 IS NULL OR @ToDateTime1 IS NULL OR @ToDateTime2 IS NULL)

						SELECT @FromDateTime1 = NULL, @ToDateTime1 = NULL

					ELSE
					
						SELECT @FromDateTime1 = CASE WHEN @FromDateTime2 > @FromDateTime1 THEN @FromDateTime2 ELSE @FromDateTime1 END, 
						       @ToDateTime1 = CASE WHEN @ToDateTime2 < @ToDateTime1 THEN @ToDateTime2 ELSE @ToDateTime1 END
							
						SET @EmployeeRatesCounter = @EmployeeRatesCounter + 1

				END
				-- Getting common time of all rate types end
				
				INSERT INTO #EmployeeFinalRates(EmployeeId,[Date],EmployeeRateTagId,RateTagId,InTime,OutTime,FromDateTime,ToDateTime,BreakInMin,Rate)
				SELECT *
				FROM
				(
				SELECT ER.EmployeeId,ER.[Date],ER.EmployeeRateTagId,ER.RateTagId,ER.InTime,ER.OutTime,@FromDateTime1 FromDateTime,@ToDateTime1 ToDateTime,BreakInMin,
				       CASE WHEN @DayOfWeek = 'Monday' THEN IIF(ERT.RatePerHourMon IS NULL,ERT.RatePerHour,ERT.RatePerHourMon)
							WHEN @DayOfWeek = 'Tuesday' THEN IIF(ERT.RatePerHourTue IS NULL,ERT.RatePerHour,ERT.RatePerHourTue)
							WHEN @DayOfWeek = 'Wednesday' THEN IIF(ERT.RatePerHourWed IS NULL,ERT.RatePerHour,ERT.RatePerHourWed)
							WHEN @DayOfWeek = 'Thursday' THEN IIF(ERT.RatePerHourThu IS NULL,ERT.RatePerHour,ERT.RatePerHourThu)
							WHEN @DayOfWeek = 'Friday' THEN IIF(ERT.RatePerHourFri IS NULL,ERT.RatePerHour,ERT.RatePerHourFri)
							WHEN @DayOfWeek = 'Saturday' THEN IIF(ERT.RatePerHourSat IS NULL,ERT.RatePerHour,ERT.RatePerHourSat)
							WHEN @DayOfWeek = 'Sunday' THEN IIF(ERT.RatePerHourSun IS NULL,ERT.RatePerHour,ERT.RatePerHourSun)
					   END Rate
				FROM @EmployeeRates ER
				     INNER JOIN EmployeeRateTag ERT ON ERT.Id = ER.EmployeeRateTagId
				WHERE ER.[Date] = @Date AND ER.EmployeeId = @EmployeeId AND ER.EmployeeRateTagId = @EmployeeRateTagId
				GROUP BY ER.EmployeeId,ER.[Date],ER.EmployeeRateTagId,ER.RateTagId,ER.InTime,ER.OutTime,ERT.RatePerHour,ERT.RatePerHourMon,ERT.RatePerHourTue,ERT.RatePerHourWed,ERT.RatePerHourThu,ERT.RatePerHourFri,
				         ERT.RatePerHourSat,ERT.RatePerHourSun,BreakInMin
				) T

				INSERT INTO #EmployeeFinalRates(EmployeeId,[Date],EmployeeRateTagId,RateTagId,InTime,OutTime,FromDateTime,ToDateTime,BreakInMin,Rate)
				SELECT *
				FROM
				(
				SELECT ER.EmployeeId,ER.[Date],ER.EmployeeRateTagId,ER.RateTagId,ER.InTime,ER.OutTime,@FromDateTime1 FromDateTime,@ToDateTime1 ToDateTime,BreakInMin,
				       CASE WHEN @DayOfWeek = 'Monday' THEN IIF(ERT.RatePerHourMon IS NULL,ERT.RatePerHour,ERT.RatePerHourMon)
							WHEN @DayOfWeek = 'Tuesday' THEN IIF(ERT.RatePerHourTue IS NULL,ERT.RatePerHour,ERT.RatePerHourTue)
							WHEN @DayOfWeek = 'Wednesday' THEN IIF(ERT.RatePerHourWed IS NULL,ERT.RatePerHour,ERT.RatePerHourWed)
							WHEN @DayOfWeek = 'Thursday' THEN IIF(ERT.RatePerHourThu IS NULL,ERT.RatePerHour,ERT.RatePerHourThu)
							WHEN @DayOfWeek = 'Friday' THEN IIF(ERT.RatePerHourFri IS NULL,ERT.RatePerHour,ERT.RatePerHourFri)
							WHEN @DayOfWeek = 'Saturday' THEN IIF(ERT.RatePerHourSat IS NULL,ERT.RatePerHour,ERT.RatePerHourSat)
							WHEN @DayOfWeek = 'Sunday' THEN IIF(ERT.RatePerHourSun IS NULL,ERT.RatePerHour,ERT.RatePerHourSun)
					   END Rate
				FROM @EmployeeRates ER
				     INNER JOIN RateTagConfiguration ERT ON ERT.Id = ER.EmployeeRateTagId
				WHERE ER.[Date] = @Date AND ER.EmployeeId = @EmployeeId AND ER.EmployeeRateTagId = @EmployeeRateTagId
				GROUP BY ER.EmployeeId,ER.[Date],ER.EmployeeRateTagId,ER.RateTagId,ER.InTime,ER.OutTime,ERT.RatePerHour,ERT.RatePerHourMon,ERT.RatePerHourTue,ERT.RatePerHourWed,ERT.RatePerHourThu,ERT.RatePerHourFri,
				         ERT.RatePerHourSat,ERT.RatePerHourSun,BreakInMin
				) T

				--IF(@FromDateTime1 IS NOT NULL AND @ToDateTime1 IS NOT NULL)
				--BEGIN
				
				--	DECLARE @DupFinalFromDateTime DATETIME = @FinalFromDateTime
					
				--	SELECT @FinalFromDateTime = CASE WHEN @FinalFromDateTime IS NULL THEN @FromDateTime1 
				--                                     WHEN /*@FromDateTime1 BETWEEN @FinalFromDateTime AND ISNULL(@FinalToDateTime,@ToDateTime1) OR*/ @FromDateTime1 >= @FinalFromDateTime AND @FromDateTime1 < @FinalToDateTime THEN '1900-01-01'
				--									 ELSE @FromDateTime1
				--                                END, 
				--       @FinalToDateTime = CASE WHEN @FinalToDateTime IS NULL THEN @ToDateTime1 
				--	                           WHEN /*@ToDateTime1 BETWEEN @FinalFromDateTime AND @FinalToDateTime OR*/ (@ToDateTime1 < @FinalToDateTime AND @ToDateTime1 > @DupFinalFromDateTime) THEN '2900-01-01'
				--							   WHEN @ToDateTime1 = @FinalToDateTime AND @ToDateTime1 > @DupFinalFromDateTime THEN @DupFinalFromDateTime
				--							   ELSE @ToDateTime1
				--	                      END

				--	UPDATE #EmployeeFinalRates SET FinalFromDateTime = @FinalFromDateTime, FinalToDateTime = @FinalToDateTime
				--    WHERE [Date] = @Date AND EmployeeId = @EmployeeId AND RateTagId = @RateTagId AND @FromDateTime1 IS NOT NULL AND @ToDateTime1 IS NOT NULL

				--END

				--UPDATE #EmployeeFinalRates SET FinalRate = ROUND((Rate/60.0) * (IIF(DATEDIFF(MINUTE,FinalFromDateTime,FinalToDateTime) > 0,DATEDIFF(MINUTE,FinalFromDateTime,FinalToDateTime),0)),2)
				--WHERE [Date] = @Date AND EmployeeId = @EmployeeId AND RateTagId = @RateTagId 
				--      AND FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL AND FinalFromDateTime <> '1900-01-01 00:00:00' AND FinalToDateTime <> '2900-01-01 00:00:00'

			END

			SET @EmployeeRateTagCounter = @EmployeeRateTagCounter + 1

		END

		TRUNCATE TABLE #EmployeeFinalRates1
		TRUNCATE TABLE #TimeSlot
		TRUNCATE TABLE #FilteredTimeSlot
		
		INSERT INTO #EmployeeFinalRates1(EmployeeId,[Date],EmployeeRateTagId,RateTagId,InTime,OutTime,FromDateTime,ToDateTime,BreakInMin,Rate)
		SELECT EmployeeId,[Date],EmployeeRateTagId,RateTagId,InTime,OutTime,FromDateTime,ToDateTime,BreakInMin,Rate
		FROM #EmployeeFinalRates
		WHERE EmployeeId = @EmployeeId AND [Date] = @Date
		
		INSERT INTO #FilteredTimeSlot
		SELECT @InTime,@OutTime,0
		
		DECLARE @EmployeeFinalRatesCount INT, @EmployeeFinalRatesCounter INT = 1, @TimeSlotCount INT, @TimeSlotCounter INT

		SELECT @EmployeeFinalRatesCount = COUNT(1) FROM #EmployeeFinalRates1
		
		WHILE(@EmployeeFinalRatesCounter <= @EmployeeFinalRatesCount)
		BEGIN

			SELECT @FromDateTime1 = FromDateTime, @ToDateTime1 = ToDateTime FROM #EmployeeFinalRates1 WHERE Id = @EmployeeFinalRatesCounter
			
			SELECT @TimeSlotCounter = 1

			TRUNCATE TABLE #TimeSlot

			INSERT INTO #TimeSlot
			SELECT FromDateTime,ToDateTime,[Type],0 FROM #FilteredTimeSlot
			WHERE DATEDIFF(MINUTE,FromDateTime,ToDateTime) <> 0
		
			SELECT @TimeSlotCount = COUNT(1) FROM #TimeSlot
			
			TRUNCATE TABLE #FilteredTimeSlot

			WHILE(@TimeSlotCounter <= @TimeSlotCount)
			BEGIN
			
				SELECT @FromDateTime2 = FromDateTime, @ToDateTime2 = ToDateTime FROM #TimeSlot WHERE Id = @TimeSlotCounter

			    --select @FromDateTime1 , @ToDateTime1,@FromDateTime2 , @ToDateTime2

				IF(@FromDateTime2 <= @ToDateTime2 AND @ToDateTime2 <= @FromDateTime1 AND @FromDateTime1 <= @ToDateTime1)
				BEGIN
				
					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter
					INSERT INTO #FilteredTimeSlot SELECT @FromDateTime2,@ToDateTime2,1

				END
				ELSE IF(@FromDateTime1 <= @ToDateTime1 AND @ToDateTime1 <= @FromDateTime2 AND @FromDateTime2 <= @ToDateTime1)
				BEGIN
				
					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter
					INSERT INTO #FilteredTimeSlot SELECT @FromDateTime2,@ToDateTime2,2

				END
				ELSE IF(@FromDateTime2 <= @FromDateTime1 AND @FromDateTime1 <= @ToDateTime2 AND @ToDateTime2 <= @ToDateTime1)
				BEGIN
				
					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter
					INSERT INTO #FilteredTimeSlot SELECT @FromDateTime2,@FromDateTime1,3

					IF((SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE Id = @EmployeeFinalRatesCounter AND FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL) > 0)

						UPDATE #EmployeeFinalRates1 SET AdditionalTimeInMin = ISNULL(AdditionalTimeInMin,0) + DATEDIFF(MINUTE,@FromDateTime1,@ToDateTime2) WHERE Id = @EmployeeFinalRatesCounter 

					ELSE UPDATE #EmployeeFinalRates1 SET FinalFromDateTime = @FromDateTime1, FinalToDateTime = @ToDateTime2 WHERE Id = @EmployeeFinalRatesCounter 

				END
				ELSE IF(@FromDateTime1 <= @FromDateTime2 AND @FromDateTime2 <= @ToDateTime1 AND @ToDateTime1 <= @ToDateTime2)
				BEGIN

					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter
					INSERT INTO #FilteredTimeSlot SELECT @ToDateTime1,@ToDateTime2,4

					IF((SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE Id = @EmployeeFinalRatesCounter AND FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL) > 0)

						UPDATE #EmployeeFinalRates1 SET AdditionalTimeInMin = ISNULL(AdditionalTimeInMin,0) + DATEDIFF(MINUTE,@FromDateTime2,@ToDateTime1) WHERE Id = @EmployeeFinalRatesCounter 

					ELSE UPDATE #EmployeeFinalRates1 SET FinalFromDateTime = @FromDateTime2, FinalToDateTime = @ToDateTime1 WHERE Id = @EmployeeFinalRatesCounter 

				END
				ELSE IF(@FromDateTime2 <= @FromDateTime1 AND @FromDateTime1 <= @ToDateTime1 AND @ToDateTime1 <= @ToDateTime2)
				BEGIN
				
					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter
					INSERT INTO #FilteredTimeSlot SELECT @FromDateTime2,@FromDateTime1,5
					INSERT INTO #FilteredTimeSlot SELECT @ToDateTime1,@ToDateTime2,5

					IF((SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE Id = @EmployeeFinalRatesCounter AND FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL) > 0)

						UPDATE #EmployeeFinalRates1 SET AdditionalTimeInMin = ISNULL(AdditionalTimeInMin,0) + DATEDIFF(MINUTE,@FromDateTime1,@ToDateTime1) WHERE Id = @EmployeeFinalRatesCounter 

					ELSE UPDATE #EmployeeFinalRates1 SET FinalFromDateTime = @FromDateTime1, FinalToDateTime = @ToDateTime1 WHERE Id = @EmployeeFinalRatesCounter 

				END
				ELSE IF(@FromDateTime1 <= @FromDateTime2 AND @FromDateTime2 <= @ToDateTime2 AND @ToDateTime2 <= @ToDateTime1)
				BEGIN
				
					UPDATE #TimeSlot SET IsDeleted = 1 WHERE Id = @TimeSlotCounter

					IF((SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE Id = @EmployeeFinalRatesCounter AND FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL) > 0)

						UPDATE #EmployeeFinalRates1 SET AdditionalTimeInMin = ISNULL(AdditionalTimeInMin,0) + DATEDIFF(MINUTE,@FromDateTime2,@ToDateTime2) WHERE Id = @EmployeeFinalRatesCounter 

					ELSE UPDATE #EmployeeFinalRates1 SET FinalFromDateTime = @FromDateTime2, FinalToDateTime = @ToDateTime2 WHERE Id = @EmployeeFinalRatesCounter  

				END
				
				SET @TimeSlotCounter = @TimeSlotCounter + 1
				
			END
			
			INSERT INTO #FilteredTimeSlot
			SELECT FromDateTime,ToDateTime,[Type] FROM #TimeSlot WHERE IsDeleted <> 1
			
			SET @EmployeeFinalRatesCounter = @EmployeeFinalRatesCounter + 1

		END
		
		IF(@IsPaidBreak = 1 AND (SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE BreakInMin = 0) > 0) UPDATE #EmployeeFinalRates1 SET [BreakInMin] = -@BreakInMin WHERE EmployeeId = @EmployeeId AND [Date] = @Date AND Id = (SELECT MIN(Id) FROM #EmployeeFinalRates1 WHERE FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL)
		ELSE IF(@IsPaidBreak = 0) UPDATE #EmployeeFinalRates1 SET [BreakInMin] = -@BreakInMin WHERE EmployeeId = @EmployeeId AND [Date] = @Date AND Id = 1
		ELSE IF(@IsPaidBreak = 1 AND (SELECT COUNT(1) FROM #EmployeeFinalRates1 WHERE BreakInMin > 0) > 0) UPDATE #EmployeeFinalRates1 SET [BreakInMin] = -@BreakInMin WHERE EmployeeId = @EmployeeId AND [Date] = @Date AND Id = (SELECT MIN(Id) FROM #EmployeeFinalRates1 WHERE FinalFromDateTime IS NOT NULL AND FinalToDateTime IS NOT NULL)
	
		IF((SELECT COUNT(1) FROM #FilteredTimeSlot) > 0)
		BEGIN

			INSERT INTO #EmployeeFinalRates
			SELECT TOP 1 @EmployeeId,@Date,NULL,RTD.RateTagId,NULL,NULL,NULL,NULL,TS.FromDateTime,TS.ToDateTime,NULL,NULL,NULL,NULL,
			             CASE WHEN @DayOfWeek = 'Monday' THEN IIF(RT.RatePerHourMon IS NULL,RT.RatePerHour,RT.RatePerHourMon)
							  WHEN @DayOfWeek = 'Tuesday' THEN IIF(RT.RatePerHourTue IS NULL,RT.RatePerHour,RT.RatePerHourTue)
							  WHEN @DayOfWeek = 'Wednesday' THEN IIF(RT.RatePerHourWed IS NULL,RT.RatePerHour,RT.RatePerHourWed)
							  WHEN @DayOfWeek = 'Thursday' THEN IIF(RT.RatePerHourThu IS NULL,RT.RatePerHour,RT.RatePerHourThu)
							  WHEN @DayOfWeek = 'Friday' THEN IIF(RT.RatePerHourFri IS NULL,RT.RatePerHour,RT.RatePerHourFri)
							  WHEN @DayOfWeek = 'Saturday' THEN IIF(RT.RatePerHourSat IS NULL,RT.RatePerHour,RT.RatePerHourSat)
							  WHEN @DayOfWeek = 'Sunday' THEN IIF(RT.RatePerHourSun IS NULL,RT.RatePerHour,RT.RatePerHourSun)
					     END Rate,
						 NULL
			FROM RateTagDetails RTD 
			     INNER JOIN RateTagFor RTF ON RTF.Id = RTD.RateTagForId
				 INNER JOIN RateTag RT ON RT.Id = RTD.RateTagId
				 INNER JOIN #FilteredTimeSlot TS ON 1 = 1
			WHERE RTF.RateTagForName = 'Remaining time' AND RTF.CompanyId = @CompanyId
			ORDER BY RTD.CreatedDateTime

		END
	
		UPDATE #EmployeeFinalRates SET FinalFromDateTime = EFR1.FinalFromDateTime, FinalToDateTime = EFR1.FinalToDateTime, BreakInMin = EFR1.BreakInMin, BreakAllowance = EFR1.BreakAllowance,
		                               AdditionalTimeInMin = EFR1.AdditionalTimeInMin
		FROM #EmployeeFinalRates1 EFR1
		     INNER JOIN #EmployeeFinalRates EFR ON EFR.EmployeeId = EFR1.EmployeeId AND EFR.[Date] = EFR1.[Date] AND EFR.EmployeeRateTagId = EFR1.EmployeeRateTagId AND EFR.RateTagId = EFR1.RateTagId
		WHERE EFR.EmployeeId = @EmployeeId AND EFR.[Date] = @Date
		
		SET @EmployeeDetailsCounter = @EmployeeDetailsCounter + 1

	END

	UPDATE #EmployeeFinalRates SET FinalRate = ROUND((Rate/60.0) * (IIF(DATEDIFF(MINUTE,FinalFromDateTime,FinalToDateTime) > 0,DATEDIFF(MINUTE,FinalFromDateTime,FinalToDateTime),0)),2),
	                               BreakAllowance = BreakInMin * (Rate/60.0),
								   AdditionalAllowance = AdditionalTimeInMin * (Rate/60.0)

	--SELECT ROW_NUMBER() OVER(ORDER BY EmployeeId,[Date]) Id, EmployeeId, [Date], SUM(FinalRate) + ISNULL(SUM(BreakAllowance),0) + ISNULL(SUM(AdditionalAllowance),0) Salary
	--INTO #EmployeeDateLevelSalary
	--FROM #EmployeeFinalRates
	--GROUP BY EmployeeId,[Date]
	
	SELECT ROW_NUMBER() OVER(ORDER BY EmployeeId) Id, EmployeeId, ROUND((SUM(FinalRate) + ISNULL(SUM(BreakAllowance),0) + ISNULL(SUM(AdditionalAllowance),0)),0) Salary
	INTO #EmployeeSalary
	FROM #EmployeeFinalRates
	GROUP BY EmployeeId

	--Salary calculation End

	UPDATE @EmployeeList SET Rate = ES.Salary
	FROM #EmployeeSalary ES INNER JOIN @EmployeeList EL ON EL.EmployeeId = ES.EmployeeId

	UPDATE EL SET EL.RATE = COALESCE(IIF(ESS.IsPermanent = 1, (CAST(ES.Amount AS FLOAT) / (12 * DAY(EOMONTH(@CreationDate)))), EL.Rate) , 0), IsPermanent = ESS.IsPermanent
	FROM Employee E 
	INNER JOIN @EmployeeList EL ON EL.EmployeeId = E.Id AND E.InActiveDateTime IS NULL
	INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
	INNER JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
	INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
			AND((EB.ActiveTo IS NULL AND @CreationDate >= EB.ActiveFrom)
				OR (EB.ActiveTo IS NOT NULL AND @CreationDate <= EB.ActiveTo AND @CreationDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EB.ActiveFrom), 0))
				)
	INNER JOIN EmploymentStatus ESS ON ESS.Id = J.EmploymentStatusId AND ESS.InActiveDateTime IS NULL
	LEFT JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id 
	AND ((ES.ActiveTo IS NULL AND @CreationDate >= ES.ActiveFrom)
		OR (ES.ActiveTo IS NOT NULL AND @CreationDate <= ES.ActiveTo AND @CreationDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ES.ActiveFrom), 0))
		)

	SELECT *FROM @EmployeeList

END
