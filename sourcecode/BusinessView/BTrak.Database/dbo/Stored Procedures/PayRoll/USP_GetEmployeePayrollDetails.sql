-------------------------------------------------------------------------------
-- Author Aravind Bandla
-- Created '2020-03-12 00:00:00.000'
-- Purpose To Get Employee payroll details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtD., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeePayrollDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@EmployeeId='ce0cf1b6-632d-4896-a31f-202449a94beb'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeePayrollDetails]
(
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@EmployeeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
SET @HavePermission = 1;
IF (@HavePermission = '1')
BEGIN
select pr.PayrollStartDate, pr.PayrollEndDate, pr.RunDate, prs.PayrollStatusId, pr.PayrollTemplateId, pt.PayrollName as PayrolltemplateName, 
dbo.Ufn_GetCurrency(CU.CurrencyCode,pre.ActualPaidAmount,1) ModifiedActualPaidAmount,
pre.* from PayrollRunEmployee pre
join PayrollRun as pr on pr.Id = pre.payrollrunid
left JOIN PayrollRunStatus AS prs on prs.Id = (SELECT top 1 Id from PayrollRunStatus where PayrollRunId = pr.Id order by CreatedDateTime desc) and prs.PayrollRunId = pr.Id
left join PayrollStatus as ps on ps.Id = prs.PayrollStatusId
left join PayrollTemplate as pt on pt.Id = pre.PayrollTemplateId
LEFT JOIN SYS_Currency CU on CU.Id = pt.CurrencyId
WHERE pre.EmployeeId = @EmployeeId and ps.PayrollStatusName = 'Paid' AND (pre.IsHold = 0 OR pre.IsHold IS NULL) AND PR.InactiveDateTime IS NULL
order by pr.RunDate desc, pr.PayrollStartdate desc, pr.PayrollEndDate desc
END
ELSE
BEGIN
RAISERROR (@HavePermission,11, 1)
END
END TRY
BEGIN CATCH
THROW
END CATCH
END