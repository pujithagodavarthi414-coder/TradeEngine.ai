CREATE PROCEDURE [dbo].[USP_InsertMail]
(
	@FromMail NVARCHAR(100)
	,@ToMail NVARCHAR(MAX)
	,@CCMail NVARCHAR(4000) = NULL
	,@BCCMail NVARCHAR(4000) = NULL
	,@Subject NVARCHAR(1000) = NULL
	,@MailBody NVARCHAR(MAX) = NULL
	,@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		--TODO
		IF(@CompanyId IS NULL) SET @CompanyId = '4AFEB444-E826-4F95-AC41-2175E36A0C16' --Snovasys company id

		INSERT INTO SentMail([Id],[CompanyId],[BCCMail],[CCMail],[FromMail],[MailBody],[Subject],[ToMail],[CreatedDateTime])
		SELECT NEWID(),@CompanyId,@BCCMail,@CCMail,@FromMail,@MailBody,@Subject,@ToMail,GETDATE()

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO