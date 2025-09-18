CREATE PROCEDURE [dbo].[Marker10]
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

	INSERT INTO  [dbo].[CompanySettings] ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
    SELECT NEWID(), @CompanyId, N'EnableIpAddressCheckingForTimeSheet', N'0',N'Enable Or Disable IpAddress Checking For TimeSheet', GETDATE(), @UserId
	
UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker10' WHERE AppSettingsName = 'Marker'
	
END TRY  
BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

END CATCH
END
GO