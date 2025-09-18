CREATE FUNCTION [dbo].[Ufn_GetEmployeeYTDLeaves]
(
	@UserId UNIQUEIDENTIFIER,
	@Year INT,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL
)
RETURNS FLOAT
AS
BEGIN
	
	DECLARE @DateFrom DATE,@DateTo DATE
	
	DECLARE @YTDLeaves FLOAT = 0,@YTDLeavesPerLeaveType FLOAT = 0

	DECLARE @LeaveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND InActiveDateTime IS NULL AND CompanyId = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId)))
	
	DECLARE @LeavesTaken FLOAT = 0,@TotalLeavesTaken FLOAT = 0

	SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,@Year)
	
	DECLARE @JoinedDate DATETIME = (SELECT JoinedDate
             FROM Employee E 
             JOIN Job J ON J.EmployeeId = E.Id AND E.UserId = @UserId)

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

	DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @UserId)

	IF(@DateFrom <> @DateTo)
	BEGIN

				IF(@DateTo < @DateFrom) SET @DateTo = EOMONTH(@DateFrom)

				DECLARE @DateToForYTD DATETIME = GETDATE()

				SET @YTDLeaves = (
									SELECT SUM(LeavesCount)
									FROM (
										   SELECT ISNULL(CASE WHEN (@DateFrom <= DateFrom AND @DateTo >=DateTo ) THEN NoOfLeaves
										   	           WHEN (@DateFrom >= DateFrom AND @DateToForYTD <= DateTo) THEN (((DATEDIFF(MONTH,@DateFrom,@DateToForYTD)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	           WHEN (@DateFrom < DateFrom AND @DateToForYTD <= DateTo) THEN (((DATEDIFF(MONTH,DateFrom,@DateToForYTD)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	           WHEN (@DateToForYTD > DateTo AND @DateFrom >= DateFrom AND @DateFrom BETWEEN DateFrom AND DateTo) THEN (((DATEDIFF(MONTH,@DateFrom,DateTo)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	     ELSE 0
										   	     END,0) 
												-- + ISNULL((SELECT SUM(MaxCarryForwardLeavesCountYTD) FROM [dbo].[Ufn_GetCarryForwardAndEncashedLeavesOfAnEmployee](@UserId,@EmployeeId,DateFrom,DateTo,LeaveTypeId,1) WHERE ISNULL(IsPaid,0) = 1),0) 
												AS LeavesCount
										   FROM LeaveFrequency
										   WHERE ((@LeaveTypeId IS NULL AND LeaveTypeId IN (SELECT LeaveTypeId FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId))) 
				  	                               OR LeaveTypeId = @LeaveTypeId)
							                     AND InActiveDateTime IS NULL
										         AND ISNULL(IsPaid, 0) = 1
										         AND ((@JoinedDate BETWEEN DateFrom AND DateTo) OR (DateFrom > @JoinedDate))

												 --AND (
												 --  (@DateFrom BETWEEN DateFrom AND DateTo
			          --                              AND @DateTo BETWEEN DateFrom AND DateTo)
			          --                             OR (@DateFrom < DateFrom AND @DateFrom < DateTo)
		           --                              )

										) T
					             )

				SET @YTDLeaves = ISNULL(@YTDLeaves,0)

				DECLARE @LeavesTable TABLE
				(
				  Id INT IDENTITY(1, 1),
				  IsCarryForward BIT,
				  DateFrom DATE,
				  DateTo DATE,
				  LeavesTaken FLOAT,
				  CarryForwardLeaves FLOAT,
				  LeaveTypeId UNIQUEIDENTIFIER
				)

				INSERT INTO @LeavesTable(LeaveTypeId,
										 IsCarryForward,
										 DateFrom,
										 DateTo,
										 CarryForwardLeaves)
					  SELECT LeaveTypeId,
					  	     ISNULL(IsToCarryForward, 0),
							 CONVERT(DATE, DateFrom),
					  	     CONVERT(DATE, DateTo),
					  	     ISNULL(CarryForwardLeavesCount, 0)
					  	     FROM LeaveFrequency
					  	     WHERE((@LeaveTypeId IS NULL AND LeaveTypeId IN (SELECT LeaveTypeId FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId))) 
					  	         OR LeaveTypeId = @LeaveTypeId)
								 AND InActiveDateTime IS NULL
								 AND ISNULL(IsPaid, 0) = 1
								 AND ((@JoinedDate BETWEEN DateFrom AND DateTo) OR (DateFrom > @JoinedDate))
					         ORDER BY LeaveTypeId,DateFrom

				DECLARE @Id INT = (SELECT ISNULL(MAX(Id),0) FROM @LeavesTable WHERE CarryForwardLeaves = 0 AND ((DateTo < @DateTo) OR (@DateTo BETWEEN DateFrom AND DateTo)) AND @DateTo IS NOT NULL AND LeaveTypeId = @LeaveTypeId)
				
				--UPDATE @LeavesTable SET LeavesTaken = (SELECT ISNULL(Cnt,0) FROM[dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,
				--																								  DateFrom,
				--																								  DateTo,
				--																								  NULL,
				--																								  LeaveTypeId,
				--																								  @LeaveStatusId)) 
				--																								  FROM @LeavesTable 
				--																								  WHERE Id >= @Id
				--																								    AND ((DateTo IS NULL )
				--																									 OR (DateTo <= @DateTo)
				--																									 OR (@DateTo BETWEEN DateFrom AND DateTo))
				
				
				IF(@DateFrom IS NOT NULL AND @DateTo IS NOT NULL)
				BEGIN
				
					UPDATE @LeavesTable SET DateFrom = IIF(DateFrom < @DateFrom,@DateFrom,DateFrom)
											,DateTo = IIF(DateTo > @DateTo,@DateTo,DateTo)
														   FROM @LeavesTable 
														   WHERE ((@DateFrom BETWEEN DateFrom AND DateTo) OR (@DateTo BETWEEN DateFrom AND DateTo))
				
				END
			
			SET @TotalLeavesTaken = ISNULL((SELECT SUM(Cnt) FROM
			(SELECT ISNULL(SUM(Total.Cnt),0) AS Cnt FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
				(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
				        FROM MASTER..SPT_VALUES MSPT
					    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
											   AND (@LeaveTypeId IS NULL OR LA.LeaveTypeId = @LeaveTypeId)
					                           AND (LA.UserId = @UserId)
						JOIN @LeavesTable LTT ON LTT.LeaveTypeId = LA.LeaveTypeId
											   AND (LA.LeaveDateFrom BETWEEN LTT.DateFrom AND LTT.DateTo 
											        OR LA.LeaveDateTo BETWEEN LTT.DateFrom AND LTT.DateTo)
				WHERE DATEADD(DAY,NUMBER,LA.LeaveDateFrom) BETWEEN LTT.DateFrom AND LTT.DateTo) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id  AND LAP.UserId = @UserId
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		    --WHERE T.[Date] BETWEEN @DateFrom AND @DateTo
			)Total
			RIGHT JOIN (SELECT @UserId AS UserId,Id,
			            CASE WHEN IsApproved = 1 THEN 'Approved'
						     WHEN IsWaitingForApproval = 1 THEN 'WaitingForApproval'
							 WHEN IsRejected = 1 THEN 'Rejected' END
							 AS LeaveStatusName FROM LeaveStatus WHERE CompanyId = @CompanyId AND (Id = @LeaveStatusId)) LS ON LS.Id = Total.OverallLeaveStatusId AND LS.UserId = Total.UserId
			
			GROUP BY LS.UserId,LS.Id,LS.LeaveStatusName
			) TT ),0)
				
				--SET @TotalLeavesTaken = ISNULL((SELECT SUM(LeavesTaken) FROM @LeavesTable),0)

			END	

	RETURN ROUND(IIF(@YTDLeaves > @TotalLeavesTaken,@YTDLeaves - @TotalLeavesTaken,0),1)

END
GO
