CREATE PROCEDURE [dbo].[USP_GetPayrollRunList]
(
@UserId uniqueidentifier,
@CompanyId uniqueidentifier
)
AS
BEGIN
SELECT prs.PayrollStatusId, prs.Comments, prs.WorkflowProcessInstanceId, ps.PayrollStatusName, CASE WHEN (select COUNT(*) from PayrollRunEmployee where PayrollRunId = pr.Id and IsPayslipReleased = 1) > 0 THEN 1 ELSE 0 END IsPayslipReleased, br.BranchName, pr.* FROM PayrollRun pr
left JOIN PayrollRunStatus AS prs on prs.Id = (SELECT top 1 Id from PayrollRunStatus where PayrollRunId = pr.Id order by CreatedDateTime desc) and prs.PayrollRunId = pr.Id 
left join payrollStatus as ps on ps.Id = prs.PayrollStatusId
left join branch as br on br.Id = pr.BranchId
WHERE pr.CompanyId = @CompanyId 
order by pr.CreatedDateTime desc
END

