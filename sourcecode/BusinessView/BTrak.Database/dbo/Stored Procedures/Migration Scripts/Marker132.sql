CREATE PROCEDURE [dbo].[Marker132]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'SpentTime', N'9h',N'SpentTime', GETDATE() , @UserId)
	)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON Target.CompanyId = Source.CompanyId AND Target.[Key] = Source.[key] 
	WHEN MATCHED THEN
	UPDATE SET [value] = Source.[value];

END
GO
