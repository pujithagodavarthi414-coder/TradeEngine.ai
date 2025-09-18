--exec [dbo].[USP_IsIpExisting] @IpAddress = '::1' ,@CompanyId='60b28fbc-14ea-48a2-b460-9ee635e821b8'

CREATE PROCEDURE [dbo].[USP_IsIpExisting]
(
	@IpAddress VARCHAR(250),
	@CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Value NVARCHAR(50) = ISNULL((SELECT [Value] FROM [dbo].[CompanySettings] WHERE CompanyId = @CompanyId AND [Key] = 'EnableIpAddressCheckingForTimeSheet'),'1')

	IF(@Value = '1')
	BEGIN

	IF(EXISTS(SELECT IpAddress FROM AccessisbleIpAdresses WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL))
	BEGIN
		
		SELECT [IpAddress] FROM [AccessisbleIpAdresses] WHERE [IpAddress] = @IpAddress AND InActiveDateTime IS NULL
		AND  CompanyId = @CompanyId

	END
	ELSE
		SELECT @IpAddress 

	END
	ELSE
		SELECT @IpAddress 

END
GO