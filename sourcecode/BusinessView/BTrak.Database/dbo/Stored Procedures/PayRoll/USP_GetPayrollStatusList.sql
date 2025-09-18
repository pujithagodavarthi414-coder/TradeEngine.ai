CREATE PROCEDURE USP_GetPayrollStatusList
(
@StatusId uniqueidentifier null,
@CompanyId uniqueidentifier
)
AS
BEGIN
IF(@StatusId IS NULL)
BEGIN
select Id, CompanyId, PayrollStatusName, IsArchived,PayRollStatusColour from PayrollStatus where CompanyId = @CompanyId
END
ELSE
BEGIN
select Id, CompanyId, PayrollStatusName, IsArchived ,PayRollStatusColour from PayrollStatus where CompanyId = @CompanyId AND Id = @StatusId
END
END