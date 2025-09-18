CREATE PROCEDURE [dbo].[USP_UpsertActivityTrackerHistory]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@OldValue NVARCHAR(MAX),
	@NewValue NVARCHAR(MAX),
	@Category NVARCHAR(100),
	@FieldName NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		INSERT INTO [ActivityTrackerHistory](
											Id,
											UserId,
											Category,
											OldValue,
											NewValue,
											FieldName,
											CreatedByUserId,
											CreatedDateTime,
											[Description],
											CompanyId
		                                  )
									SELECT NEWID(),
										   @UserId,
										   @Category,
										   @OldValue,
										   @NewValue,
										   @FieldName,
										   @OperationsPerformedBy,
										   GETDATE(),
										   @Description,
										   @CompanyId

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
