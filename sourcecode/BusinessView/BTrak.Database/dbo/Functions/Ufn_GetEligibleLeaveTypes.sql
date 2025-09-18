CREATE FUNCTION [dbo].[Ufn_GetEligibleLeaveTypes]
(
 @UserId UNIQUEIDENTIFIER
)
RETURNS @LeaveType TABLE
(
  LeaveTypeId UNIQUEIDENTIFIER
)
AS
BEGIN

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

	INSERT INTO @LeaveType
	SELECT LA.LeaveTypeId 
	       FROM LeaveApplicability LA
		   JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId AND LT.InActiveDateTime IS NULL
		   LEFT JOIN RoleLeaveType RLT ON RLT.LeaveTypeId = LT.Id AND RLT.InactiveDateTime IS NULL
		   LEFT JOIN BranchLeaveType BLT ON BLT.LeaveTypeId = LT.Id AND BLT.InactiveDateTime IS NULL
		   LEFT JOIN GenderLeaveType GLT ON GLT.LeaveTypeId = LT.Id AND GLT.InactiveDateTime IS NULL
		   LEFT JOIN MariatalStatusLeaveType MLT ON MLT.LeaveTypeId = LT.Id AND MLT.InactiveDateTime IS NULL
		   LEFT JOIN EmployeeLeaveType ELT ON ELT.LeaveTypeId = LT.Id AND ELT.InactiveDateTime IS NULL
		   JOIN [User] U ON U.Id = @UserId
		   LEFT JOIN [Employee] E ON E.UserId = @UserId AND E.InactiveDateTime IS NULL 
		   AND ((E.MaritalStatusId IS NULL OR MLT.IsAccessAll = 1 OR E.MaritalStatusId = MLT.MariatalStatusId OR MLT.MariatalStatusId IS NULL) 
				  AND (E.GenderId IS NULL OR GLT.IsAccessAll = 1 OR E.GenderId = GLT.GenderId OR GLT.GenderId IS NULL))
		   LEFT JOIN [UserRole] UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL AND (UR.RoleId = RLT.RoleId OR RLT.IsAccessAll = 1)
		   LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 AND (EB.BranchId = BLT.BranchId OR BLT.IsAccessAll = 1) 
		   JOIN [Job] J ON J.EmployeeId = E.Id 
		   LEFT JOIN (SELECT EmployeeId, DATEDIFF(MONTH,MIN(EWE.FromDate),MAX(EWE.ToDate)) ExperianceMonths
		              FROM [EmployeeWorkExperience] EWE 
					  WHERE  EWE.InactiveDateTime IS NULL
					  GROUP BY EmployeeId) AS EWEInner ON EWEInner.EmployeeId = E.Id 
		  WHERE LT.CompanyId = @CompanyId
		  AND (ELT.EmployeeId IS NULL OR E.Id = ELT.EmployeeId)
		  AND ((ISNULL(DATEDIFF(MONTH,J.JoinedDate,GETDATE()),0) + ISNULL(EWEInner.ExperianceMonths,0)) >= LA.MinExperienceInMonths)
				AND (((ISNULL(DATEDIFF(MONTH,J.JoinedDate,GETDATE()),0) + ISNULL(EWEInner.ExperianceMonths,0)) <= LA.MaxExperienceInMonths) OR LA.MaxExperienceInMonths IS NULL
		  )
	      GROUP BY LA.LeaveTypeId
	RETURN
END
GO