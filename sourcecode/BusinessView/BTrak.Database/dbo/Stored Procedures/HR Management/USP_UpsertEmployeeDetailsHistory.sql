	CREATE PROCEDURE [dbo].[USP_UpsertEmployeeDetailsHistory]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@OldValue NVARCHAR(MAX),
	@NewValue NVARCHAR(MAX),
	@Category NVARCHAR(100),
	@FieldName NVARCHAR(100),
	@RecordTitle NVARCHAR(MAX) = NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		INSERT INTO EmployeeDetailsHistory(
											Id,
											EmployeeId,
											UserId,
											Category,
											OldValue,
											NewValue,
											FieldName,
											CreatedByUserId,
											CreatedDateTime,
											RecordTitle,
											[Description]
		                                  )
									SELECT NEWID(),
									       @EmployeeId,
										   @UserId,
										   @Category,
										   @OldValue,
										   @NewValue,
										   @FieldName,
										   @OperationsPerformedBy,
										   GETDATE(),
										   @RecordTitle,
										   @Description

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
