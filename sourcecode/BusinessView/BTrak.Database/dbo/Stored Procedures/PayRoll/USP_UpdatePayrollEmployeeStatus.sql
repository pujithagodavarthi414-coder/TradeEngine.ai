CREATE PROCEDURE [dbo].[USP_UpdatePayrollEmployeeStatus]
(
@PayrollRunId uniqueidentifier,
@EmployeeId uniqueidentifier,
@PayrollStatusId uniqueidentifier,
@IsHold bit,
@IsPayslipReleased bit
)
AS
BEGIN
UPDATE PayrollRunEmployee SET PayrollStatusId = @PayrollStatusId, IsHold = @IsHold, IsPayslipReleased = @IsPayslipReleased where PayrollRunId = @PayrollRunId AND EmployeeId = @EmployeeId
END