CREATE FUNCTION Ufn_GetEligibleLeavesOfAnEmployee
(
	@UserId UNIQUEIDENTIFIER,
	@StartDate DATE,
	@EndDate DATE
)
RETURNS FLOAT
AS
BEGIN

	DECLARE @NoOfLeaves FLOAT  

	DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @UserId)

	DECLARE @Leaves TABLE
	(
		LeaveTypeId UNIQUEIDENTIFIER,
		Leaves FLOAT
	)

	INSERT INTO @Leaves
	SELECT LeaveTypeId, 
	       ISNULL(CASE WHEN DATEDIFF(MONTH,DateFrom,DateTo) = DATEDIFF(MONTH,@StartDate,@EndDate) THEN ISNULL(NoOfLeaves,0)
		         WHEN @StartDate < JoinedDate THEN (ISNULL(NoOfLeaves,0)/(DATEDIFF(MONTH,DateFrom,DateTo) + 1))*(DATEDIFF(MONTH,JoinedDate,@EndDate)+1)
		        ELSE (ISNULL(NoOfLeaves,0)/(DATEDIFF(MONTH,DateFrom,DateTo) + 1))*(DATEDIFF(MONTH,@StartDate,@EndDate)+1)
		   END,0) +
		   ISNULL((SELECT SUM(MaxCarryForwardLeavesCount) FROM [dbo].[Ufn_GetCarryForwardAndEncashedLeavesOfAnEmployee](@UserId,@EmployeeId,DateFrom,DateTo,LeaveTypeId,1)),0) Leaves
	FROM (
	SELECT LF.LeaveTypeId,
	       LF.DateFrom,
		   LF.DateTo,
		   Job.JoinedDate,
		   --CASE WHEN DateFrom < Job.JoinedDate THEN ROUND((ISNULL(LF.NoOfLeaves,0) - ((ISNULL(LF.NoOfLeaves,0)/(DATEDIFF(MONTH,DateFrom,DateTo) + 1))*DATEDIFF(MONTH,DateFrom,JoinedDate))),2) ELSE ISNULL(LF.NoOfLeaves,0) END NoOfLeaves
		   LF.NoOfLeaves
	FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId) ELT 
		 INNER JOIN LeaveFrequency LF ON LF.LeaveTypeId = ELT.LeaveTypeId AND LF.InActiveDateTime IS NULL AND DATEPART(YEAR,LF.DateFrom) = DATEPART(YEAR,@EndDate) AND (LF.IsPaid IS NOT NULL AND LF.IsPaid = 1)
		 INNER JOIN (SELECT E.UserId, MAX(J.JoinedDate) JoinedDate 
	                 FROM Job J 
				          INNER JOIN Employee E ON E.Id = J.EmployeeId
					      INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
				     WHERE J.InActiveDateTime IS NULL GROUP BY E.UserId) Job ON Job.UserId = @UserId
	) T
	WHERE @StartDate BETWEEN DateFrom AND DateTo
		  AND @EndDate BETWEEN DateFrom AND DateTo
		
	SELECT @NoOfLeaves = SUM(Leaves) FROM @Leaves
										
	RETURN @NoOfLeaves

END
