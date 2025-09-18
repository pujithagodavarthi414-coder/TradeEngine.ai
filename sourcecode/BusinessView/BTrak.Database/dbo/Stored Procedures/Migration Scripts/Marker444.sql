CREATE PROCEDURE [dbo].[Marker444]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
DECLARE @ModuleId UNIQUEIDENTIFIER = (SELECT Id FROM Module WHERE ModuleName = 'Business')
MERGE INTO [dbo].[CompanyModule] AS Target 
	USING ( VALUES 
	 (NEWID(), @CompanyId, @ModuleId, GETDATE(), @UserId, 0, 1)
	)
	AS Source ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [IsActive], [IsEnabled])
	ON Target.ModuleId = Source.ModuleId AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [Id] = Source.[Id],
			   [CompanyId] = Source.[CompanyId],	
			   [ModuleId] = Source.[ModuleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsActive] = Source.[IsActive],
               [IsEnabled] = Source.[IsEnabled]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId],[IsActive], [IsEnabled]) VALUES ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId],[IsActive], [IsEnabled]);

END

GO