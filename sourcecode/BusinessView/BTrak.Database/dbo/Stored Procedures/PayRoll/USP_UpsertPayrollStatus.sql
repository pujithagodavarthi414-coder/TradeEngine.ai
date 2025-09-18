CREATE PROCEDURE USP_UpsertPayrollStatus
(
@Id uniqueidentifier,
@CompanyId uniqueidentifier,
@UserId uniqueidentifier,
@PayrollStatusName nvarchar(250),
@IsArchived bit
)
AS
BEGIN
	DECLARE @PayrollStatusNameExists INT = (SELECT COUNT(1) FROM PayrollStatus WHERE [PayrollStatusName] = @PayrollStatusName AND CompanyId = @CompanyId AND (@Id IS NULL OR @Id <> Id))
	IF (@PayrollStatusNameExists > 0)
		BEGIN
			RAISERROR(50001,16,2,'PayRollStatusName')
		END
	ELSE
	BEGIN
		IF(@Id IS NULL)
		BEGIN
			INSERT INTO PayrollStatus(Id, payrollStatusName, CompanyId, CreatedDatetime, CreatedByUserId) values(NEWID(), @PayrollStatusName, @CompanyId, GETDATE(), @UserId)
		END
	ELSE
		BEGIN
			UPDATE PayrollStatus SET payrollStatusName = @PayrollStatusName, CompanyId = @CompanyId, UpdatedDatetime = GETDATE(), UpdatedByUserId = @UserId, IsArchived = @IsArchived where Id = @Id
		END
	END
END