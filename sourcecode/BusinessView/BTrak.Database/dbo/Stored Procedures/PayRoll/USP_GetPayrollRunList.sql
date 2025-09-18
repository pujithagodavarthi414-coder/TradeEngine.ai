CREATE PROCEDURE [dbo].[USP_GetPayrollRunList]
(
@UserId uniqueidentifier,
@CompanyId uniqueidentifier,
@IsArchived BIT = NULL
)
AS
BEGIN
SELECT
prs.PayrollStatusId, 
prs.Comments,
prs.WorkflowProcessInstanceId,
ps.PayrollStatusName,
ps.PayRollStatusColour,
CASE WHEN (select COUNT(*) from PayrollRunEmployee where PayrollRunId = pr.Id and IsPayslipReleased = 1) > 0 THEN 1 ELSE 0 END IsPayslipReleased, 
br.BranchName, 
PRFESInner.EmploymentStatusNames,
PRFEInner.EmployeeNames,
PRFEInner1.EmployeesList,
PT.PayrollName TemplateName,
pr.*
FROM PayrollRun pr
LEFT JOIN PayrollTemplate PT ON PT.Id = pr.PayrollTemplateId
left JOIN PayrollRunStatus AS prs on prs.Id = (SELECT top 1 Id from PayrollRunStatus where PayrollRunId = pr.Id order by CreatedDateTime desc) and prs.PayrollRunId = pr.Id
left join payrollStatus as ps on ps.Id = prs.PayrollStatusId
left join branch as br on br.Id = pr.BranchId
LEFT JOIN (SELECT PayrollRunId, STUFF((SELECT ', '+ ES.EmploymentStatusName 
            FROM PayrollRunFilteredEmploymentStatus PRFES
            INNER JOIN EmploymentStatus ES ON ES.Id = PRFES.EmploymentStatusId
            WHERE ES.InActiveDateTime IS NULL AND  PRFES1.PayrollRunId = PRFES.PayrollRunId AND CompanyId = @CompanyId FOR XML PATH('')), 1, 1, '') EmploymentStatusNames FROM PayrollRunFilteredEmploymentStatus
		    PRFES1 GROUP BY PayrollRunId) PRFESInner ON
			PRFESInner.PayrollRunId =  pr.Id 
LEFT JOIN (SELECT PayrollRunId, STUFF((SELECT ', '+ U.FirstName +' '+ ISNULL(U.SurName,'')
            FROM PayrollRunFilteredEmployee PRFE
            INNER JOIN Employee E ON E.Id = PRFE.EmployeeId
			INNER JOIN [User] U ON U.Id = E.UserId
            WHERE E.InActiveDateTime IS NULL 
			AND  PRFE1.PayrollRunId = PRFE.PayrollRunId 
			AND CompanyId = @CompanyId FOR XML PATH('')), 1, 1, '') EmployeeNames FROM PayrollRunFilteredEmployee
		    PRFE1 GROUP BY PayrollRunId) PRFEInner ON PRFEInner.PayrollRunId =  pr.Id 
LEFT JOIN (SELECT PayrollRunId, 
	      (SELECT * FROM (SELECT U.FirstName +' '+ ISNULL(U.SurName,'') UserName,U.Id UserId,U.ProfileImage,R.RoleName
            FROM PayrollRunFilteredEmployee PRFE
            INNER JOIN Employee E ON E.Id = PRFE.EmployeeId
			INNER JOIN [User] U ON U.Id = E.UserId
			LEFT JOIN [UserRole] UR ON UR.UserId = U.Id AND UR.InActiveDateTime IS NULL
			LEFT JOIN [Role] R ON R.Id = UR.RoleId AND R.InActiveDateTime IS NULL
            WHERE E.InActiveDateTime IS NULL 
			AND  PRFE1.PayrollRunId = PRFE.PayrollRunId 
			AND U.CompanyId = @CompanyId) T FOR JSON AUTO) EmployeesList FROM PayrollRunFilteredEmployee
		    PRFE1 GROUP BY PayrollRunId) PRFEInner1 ON PRFEInner1.PayrollRunId =  pr.Id 
WHERE pr.CompanyId = @CompanyId 
AND (@IsArchived IS NULL
	OR (@IsArchived = 1 AND PR.InActiveDateTime IS NOT NULL)
	OR (@IsArchived = 0 AND PR.InActiveDateTime IS NULL))		
order by pr.CreatedDateTime desc
END	