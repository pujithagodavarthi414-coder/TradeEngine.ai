CREATE PROCEDURE [dbo].[Marker147]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
BEGIN TRY

    DELETE EntityRoleFeature WHERE EntityFeatureId = 'CA3B6E21-8C62-4D91-8338-92A956F83BCA'
    DELETE FROM EntityFeature WHERE Id = 'CA3B6E21-8C62-4D91-8338-92A956F83BCA'

    MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'EmailLimitPerDay', N'1000',N'Mail restriction', GETDATE() , @UserId)
	)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON Target.CompanyId = Source.CompanyId AND Target.[Key] = Source.[key] 
	WHEN MATCHED THEN
	UPDATE SET [value] = Source.[value]
	WHEN NOT MATCHED  BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);
END TRY  
BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

END CATCH
END
GO
