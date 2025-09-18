CREATE PROCEDURE [dbo].[Marker196]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
    MERGE INTO [dbo].[ActionCategory] AS Target 
    USING ( VALUES 
     (NEWID(), N'Issue', CAST(GETDATE() AS DateTime), @UserId, @CompanyId),
     (NEWID(), N'Mitigation action', CAST(GETDATE() AS DateTime), @UserId, @CompanyId))
    AS Source ([Id], [ActionCategoryName], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
    ON Target.[ActionCategoryName] = Source.[ActionCategoryName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN 
    UPDATE SET [ActionCategoryName] = Source.[ActionCategoryName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id], [ActionCategoryName], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
    VALUES([Id], [ActionCategoryName], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

END
GO