CREATE PROCEDURE [dbo].[Marker49]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER,
	@Marker NVARCHAR(100) = NULL
)
AS 
BEGIN 
SET NOCOUNT ON
BEGIN TRY

	UPDATE FeatureModule SET ModuleId = '9C9684AD-E2C2-485C-A66C-B6D388337BD5' WHERE Id IN ('FDCE9220-399F-491D-8F6E-7454FB206061')

	IF((SELECT COUNT(*) FROM CompanySettings WHERE [Key] = 'EnableIpAddressCheckingForTimeSheet' AND CompanyId = @CompanyId) = 0)
	BEGIN
		INSERT INTO  [dbo].[CompanySettings] ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
		SELECT NEWID(), @CompanyId, N'EnableIpAddressCheckingForTimeSheet', N'1',N'Enable Or Disable IpAddress Checking For TimeSheet', GETDATE(), @UserId
	END
	
	UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker49' WHERE AppSettingsName = 'Marker'
	
END TRY  
BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

END CATCH
END
GO