CREATE PROCEDURE [dbo].[USP_InsertLoginAudit]
(
	@UserId UNIQUEIDENTIFIER
	,@BrowserName NVARCHAR(250)
	,@IPAddress NVARCHAR(100)
)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY

		INSERT INTO [LoginAudit](Id,LoggedinUserId,IpAddress,Browser,LoggedinDateTime)
		SELECT NEWID(),@UserId,@IPAddress,@BrowserName,GETDATE()

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO