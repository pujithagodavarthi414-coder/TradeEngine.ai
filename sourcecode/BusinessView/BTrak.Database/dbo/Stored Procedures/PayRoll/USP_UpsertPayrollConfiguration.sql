CREATE PROCEDURE USP_UpsertPayrollConfiguration
(
@Id uniqueidentifier,
@EmployeeId uniqueidentifier,
@PayrollTemplateId uniqueidentifier,
@ActiveFrom datetime,
@ActiveTo datetime,
@IsApproved bit,
@UserId uniqueidentifier
)
AS
BEGIN
IF(@Id IS NULL)
BEGIN
INSERT INTO EmployeepayrollConfiguration(Id, EmployeeId, PayrollTemplateId, ActiveFrom, ActiveTo, CreatedByUserId, CreatedDateTime)
values(NEWID(), @EmployeeId, @PayrollTemplateId, @ActiveFrom, @ActiveTo, @UserId, GETDATE())
END
ELSE
BEGIN
UPDATE EmployeepayrollConfiguration SET EmployeeId = @EmployeeId, PayrollTemplateId = @PayrollTemplateId, ActiveFrom = @ActiveFrom, ActiveTo = @ActiveTo, UpdatedDateTime = GETDATE(), UpdatedByUserId = @UserId, IsApproved = @IsApproved WHERE Id = @Id
END
END