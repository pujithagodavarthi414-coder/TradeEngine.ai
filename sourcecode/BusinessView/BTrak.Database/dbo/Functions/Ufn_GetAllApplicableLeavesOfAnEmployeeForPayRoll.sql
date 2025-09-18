CREATE FUNCTION [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll]
(
	@UserId UNIQUEIDENTIFIER,
	@YearStartDate DATE,
	@YearEndDate DATE,
	@IsPaidOnly BIT = 1
)
RETURNS FLOAT
AS
BEGIN

	DECLARE @NoOfLeaves FLOAT 
	
	DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @UserId)

	IF(@IsPaidOnly IS NULL) SET @IsPaidOnly = 1

	DECLARE @Leaves TABLE
	(
		LeaveTypeId UNIQUEIDENTIFIER,
		Leaves FLOAT
	)

	INSERT INTO @Leaves
	SELECT ELT.LeaveTypeId, 
	       ISNULL(CASE WHEN DateFrom < Job.JoinedDate THEN ROUND((ISNULL(LF.NoOfLeaves,0) - ((ISNULL(LF.NoOfLeaves,0)/(DATEDIFF(MONTH,DateFrom,DateTo) + 1))*DATEDIFF(MONTH,DateFrom,JoinedDate))),2) 
		                                       ELSE ISNULL(LF.NoOfLeaves,0) END,0) + 
		   ISNULL((SELECT SUM(MaxCarryForwardLeavesCount) FROM [dbo].[Ufn_GetCarryForwardAndEncashedLeavesOfAnEmployee](@UserId,@EmployeeId,DateFrom,DateTo,LF.LeaveTypeId,1)),0)
	FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId) ELT 
		 INNER JOIN LeaveFrequency LF ON LF.LeaveTypeId = ELT.LeaveTypeId AND LF.InActiveDateTime IS NULL 
		            AND ((LF.DateTo IS NOT NULL AND @YearStartDate BETWEEN LF.DateFrom AND LF.DateTo AND @YearEndDate BETWEEN LF.DateFrom AND LF.DateTo)
			                 OR (LF.DateTo IS NULL AND @YearEndDate >= LF.DateFrom)
				             OR (LF.DateTo IS NOT NULL AND @YearStartDate <= LF.DateTo AND @YearStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, LF.DateFrom), 0))
			   )
					AND (@IsPaidOnly = 0 OR (LF.IsPaid IS NOT NULL AND LF.IsPaid = 1))
		 INNER JOIN (SELECT E.UserId, MAX(J.JoinedDate) JoinedDate 
	                 FROM Job J 
				          INNER JOIN Employee E ON E.Id = J.EmployeeId
					      INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
				     WHERE J.InActiveDateTime IS NULL GROUP BY E.UserId) Job ON Job.UserId = @UserId
		
	SELECT @NoOfLeaves = SUM(Leaves) FROM @Leaves
										
	RETURN @NoOfLeaves

END
