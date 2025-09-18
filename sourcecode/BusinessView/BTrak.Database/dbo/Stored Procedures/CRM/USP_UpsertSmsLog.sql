CREATE PROCEDURE [dbo].[USP_UpsertSmsLog]
(
	@SentTo NVARCHAR(50) = NULL,
	@TemplateId uniqueidentifier,
	@Message nvarchar(max),
	@ReceiverId uniqueidentifier = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		Declare @SmsId UNIQUEIDENTIFIER  = newid();

		INSERT INTO SMSLog(Id, SentTo, TemplateId, [Message], ReceiverId, CreatedByUserId, CreatedDateTime)
		SELECT @SmsId, @SentTo, @TemplateId, @Message, @ReceiverId, @OperationsPerformedBy, @Currentdate
		
		SELECT Id FROM [dbo].[SMSTemplate] WHERE Id = @TemplateId

	END TRY  
	BEGIN CATCH 
		EXEC USP_GetErrorInformation
	END CATCH
END