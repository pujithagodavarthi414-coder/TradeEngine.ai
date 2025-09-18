--SELECT * FROM [dbo].[Ufn_GetLeavesReportOfAnUser]('0B2921A9-E930-4013-9047-670B5352F308',NULL,'2020-02-27','2020-12-31')
CREATE FUNCTION [dbo].[Ufn_GetLeavesReportOfAnUser]
  (
	@UserId UNIQUEIDENTIFIER,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL
)
RETURNS @LeavesTable TABLE
  (
    Id INT IDENTITY(1, 1),
    LeaveFrequencyId UNIQUEIDENTIFIER,
    IsCarryForward BIT,
    IsPaid BIT,
    DateFrom DATE,
    DateTo DATE,
    LeaveCount FLOAT,
    LeavesTaken FLOAT,
    ActualBalance FLOAT,
    CarryForwardLeaves FLOAT,
	Leaves FLOAT,
    EffectiveBalance FLOAT,
	TotalLeaves FLOAT,
	LeaveTypeId UNIQUEIDENTIFIER,
	EncashedLeaves FLOAT,
	MaxEncashedLeavesCount FLOAT
  )
AS
BEGIN

	DECLARE @LeaveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND InActiveDateTime IS NULL AND CompanyId = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId)))
	
	DECLARE @JoinedDate DATETIME = (SELECT JoinedDate
                 FROM Employee E 
                 JOIN Job J ON J.EmployeeId = E.Id AND E.UserId = @UserId)

	DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @UserId)

	INSERT INTO @LeavesTable(LeaveFrequencyId, 
	                         LeaveTypeId,
							 IsCarryForward,
							 LeaveCount,
							 TotalLeaves,
							 DateFrom,
							 DateTo,
							 CarryForwardLeaves,
							 IsPaid,
							 EncashedLeaves)
					  SELECT Id, 
					         LeaveTypeId,
					  	     ISNULL(IsToCarryForward, 0),
					  	     IIF(@JoinedDate BETWEEN DateFrom AND DateTo,ROUND((((DATEDIFF(MONTH,@JoinedDate,DateTo) + 1) * 1.0 * NoOfLeaves)/(DATEDIFF(MONTH,DateFrom,DateTo) + 1)),0),NoOfLeaves),
							 NoOfLeaves,
							 CONVERT(DATE, DateFrom),
					  	     CONVERT(DATE, DateTo),
					  	     ISNULL(CarryForwardLeavesCount, 0),
					  	     ISNULL(IsPaid, 0),
							 ISNULL(EncashedLeavesCount,0)
					  	     FROM LeaveFrequency
					  	     WHERE((@LeaveTypeId IS NULL AND LeaveTypeId IN (SELECT LeaveTypeId FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId))) 
					  	         OR LeaveTypeId = @LeaveTypeId)
								 AND InActiveDateTime IS NULL
								 AND ((@JoinedDate BETWEEN DateFrom AND DateTo) OR (DateFrom > @JoinedDate))
					         ORDER BY LeaveTypeId,DateFrom

	DECLARE @Id INT = (SELECT ISNULL(MAX(Id),0) FROM @LeavesTable WHERE CarryForwardLeaves = 0 AND ((DateTo < @DateTo) OR (@DateTo BETWEEN DateFrom AND DateTo)) AND @DateTo IS NOT NULL AND LeaveTypeId = @LeaveTypeId)
	
	UPDATE @LeavesTable SET LeavesTaken = (SELECT ISNULL(Cnt,0) FROM[dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,
																									  DateFrom,
																									  DateTo,
																									  NULL,
																									  LeaveTypeId,
																									  @LeaveStatusId)) 
																									  FROM @LeavesTable 
																									  WHERE Id >= @Id
																									    AND ((DateTo IS NULL )
																										 OR (DateTo <= @DateTo)
																										 OR (@DateTo BETWEEN DateFrom AND DateTo))
	
	UPDATE @LeavesTable SET ActualBalance = LeaveCount - ISNULL(LeavesTaken, 0),LeavesTaken = ISNULL(LeavesTaken,0)
	
	--Leaves => previous frequency carry forward leaves to current frequency

	UPDATE @LeavesTable SET Leaves = (SELECT IIF(CarryForwardLeaves > ActualBalance AND IsCarryForward = 1,ActualBalance,CarryForwardLeaves - LeavesTaken)
	                                                           FROM @LeavesTable WHERE Id = (T.Id - 1) AND T.LeaveTypeId = LeaveTypeId)
				        FROM @LeavesTable T WHERE T.Id >= @Id AND (@DateTo IS NULL OR DateTo <= @DateTo)
	
	UPDATE @LeavesTable SET Leaves = 0 WHERE Leaves IS NULL

	UPDATE @LeavesTable SET EffectiveBalance = ActualBalance + Leaves,LeaveCount = LeaveCount + Leaves, TotalLeaves = TotalLeaves + Leaves

	UPDATE @LeavesTable SET LeaveCount = CASE WHEN (@DateFrom < DateFrom AND @DateTo > DateTo) THEN LeaveCount
	                                   WHEN (@DateFrom >= DateFrom AND @DateTo <= DateTo) THEN (((DATEDIFF(MONTH,@DateFrom,@DateTo)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * LeaveCount
	                                   WHEN (@DateFrom < DateFrom AND @DateTo <= DateTo) THEN (((DATEDIFF(MONTH,DateFrom,@DateTo)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * LeaveCount
									   WHEN (@DateTo > DateTo AND @DateFrom >= DateFrom AND @DateFrom BETWEEN DateFrom AND DateTo) THEN (((DATEDIFF(MONTH,@DateFrom,DateTo)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * LeaveCount
									   ELSE 0
								   END
								   

	IF(@DateFrom IS NOT NULL)
	BEGIN

	DECLARE @Temp TABLE(
						Cnt INT IDENTITY(1,1),
						LeaveTypeId UNIQUEIDENTIFIER
					    )

	INSERT INTO @Temp(LeaveTypeId)
	SELECT LeaveTypeId FROM @LeavesTable GROUP BY LeaveTypeId

	DECLARE @Cnt INT = (SELECT MAX(Cnt) FROM @Temp)

	WHILE(@Cnt > 0)
	BEGIN

		SET @Id = (SELECT Top 1 Id FROM @LeavesTable WHERE (@DateFrom BETWEEN DateFrom AND DateTo) AND LeaveTypeId = (SELECT LeaveTypeId FROM @Temp WHERE Cnt = @Cnt) ORDER BY DateFrom)

		UPDATE @LeavesTable SET Leaves = IIF(Id < @Id,0,IIF(Id = @Id,EffectiveBalance,ActualBalance))
		
		SET @Cnt = @Cnt - 1
	END

	UPDATE @LeavesTable SET LeaveCount = CASE WHEN ISNULL(LeaveCount,0) >= 0.45 AND ISNULL(LeaveCount,0) < 1 THEN 0.5
	                                          ELSE ROUND(ISNULL(LeaveCount,0),0) END

	--UPDATE @LeavesTable SET EffectiveBalance = LeaveCount

	IF(@DateFrom IS NOT NULL AND @DateTo IS NOT NULL)
	BEGIN

		UPDATE @LeavesTable SET LeavesTaken = (SELECT ISNULL(Cnt,0) FROM[dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,
																									  IIF(DateFrom < @DateFrom,@DateFrom,DateFrom),
																									  IIF(DateTo > @DateTo,@DateTo,DateTo),
																									  NULL,
																									  LeaveTypeId,
																									  @LeaveStatusId)) 
																									  FROM @LeavesTable 
																									  WHERE ((@DateFrom BETWEEN DateFrom AND DateTo) OR (@DateTo BETWEEN DateFrom AND DateTo))

	END

	END

	UPDATE @LeavesTable SET MaxEncashedLeavesCount = ROUND((CASE WHEN  ISNULL(LeaveCount,0) - ISNULL(LeavesTaken,0) > ISNULL(EncashedLeaves,0) THEN ISNULL(EncashedLeaves,0) ELSE ISNULL(LeaveCount,0) - ISNULL(LeavesTaken,0) END),2)

RETURN 
END