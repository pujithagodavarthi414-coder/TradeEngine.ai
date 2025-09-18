CREATE PROCEDURE [dbo].[USP_GetBreakDetails]  
(
	
	@DateFrom DATETIME,
	@DateTo DATETIME,
	@BranchId uniqueidentifier,
	@TeamLeadId uniqueidentifier,
	@UserId uniqueidentifier
)
AS 
BEGIN

IF(@BranchId = '00000000-0000-0000-0000-000000000000')
BEGIN
   SET @BranchId = NULL
END

IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000')
BEGIN
   SET @TeamLeadId = NULL
END

SELECT US.Id,U.Id UserId,US.[Date],US.BreakIn,US.BreakOut,FirstName, SurName, FirstName + ' ' + SurName FullName,
    CAST(DATEDIFF(MINUTE,BreakIn,BreakOut)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, BreakIn,BreakOut)%60 AS VARCHAR(50)) + 'min' BreakDiff
FROM [User] U WITH (NOLOCK) LEFT JOIN UserBreak US ON U.Id = US.UserId AND US.[Date] >= @DateFrom AND US.[Date] <= @DateTo

 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = U.Id
  LEFT JOIN Branch B ON B.Id = EB.BranchId 
 --LEFT JOIN TeamLeadWithMember TLM ON TLM.MemberUserId = U.Id OR TLM.LeadUserId = U.Id
 LEFT JOIN [EmployeeShift] ES ON ES.EmployeeId = U.Id
WHERE (@BranchId IS NULL OR EB.BranchId = @BranchId)
  --AND (@TeamLeadId IS NULL OR TLM.LeadUserId = @TeamLeadId)
  --AND (@Type IS NULL OR IsAbsent = @Type)
  AND U.Id NOT IN (SELECT UserId FROM ExcludedUser)
  AND U.IsActive = 1
  AND US.UserId = @UserId OR @UserId IS NULL
GROUP BY US.Id,U.Id,US.[Date],US.BreakIn,US.BreakOut,FirstName, SurName, FirstName + ' ' + SurName
ORDER BY FullName

END