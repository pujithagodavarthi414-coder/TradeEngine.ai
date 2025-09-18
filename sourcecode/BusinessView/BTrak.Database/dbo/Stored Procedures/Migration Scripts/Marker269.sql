CREATE PROCEDURE [dbo].[Marker269]
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
       (NEWID(), @CompanyId, N'FileSystem','Local', N'Default storage type for the company', GETUTCDATE(), @UserId,1)
	   ,(NEWID(), @CompanyId, N'LocalFileSystemPath','C://Snovasys//LOCAL_STORAGE', N'Default path where the uploadedf files will save', GETUTCDATE(), @UserId,0)
	   )
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	ON Target.[Key] = Source.[Key] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsVisible] = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);
END
GO