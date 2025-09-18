CREATE PROCEDURE [dbo].[Marker357]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
MERGE INTO [dbo].[Folder] AS Target 
	USING ( VALUES
	        (NEWID(), N'Identification details'            , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL)
	        ) 
	AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FolderName] = Source.[FolderName],
	           [ParentFolderId] = Source.[ParentFolderId],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [StoreId] = Source.[StoreId],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);
	
INSERT INTO Workspace(Id,WorkspaceName,IsHidden,CreatedDateTime,CreatedByUserId,CompanyId,IsCustomizedFor)
SELECT Id, N'Customized_AuditAnalytics',0, GETDATE(), @UserId, @CompanyId, 'AuditAnalytics' FROM Project WHERE CompanyId=@CompanyId

END