CREATE PROCEDURE [USP_UpdatePayrollRunBankPointer]
(
@PayrollRunId uniqueidentifier,
@BankSubmittedFilePointer nvarchar(max)
)
AS
BEGIN
UPDATE PayrollRun SET BankSubmittedFilePointer = @BankSubmittedFilePointer WHERE Id = @PayrollRunId
END