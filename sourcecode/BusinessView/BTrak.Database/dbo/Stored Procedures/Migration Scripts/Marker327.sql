CREATE PROCEDURE [dbo].[Marker327]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

  MERGE INTO [dbo].[CompanySettings] AS Target
    USING ( VALUES
       (NEWID(), @CompanyId, N'PayslipLogo', N'https://bviewstorage.blob.core.windows.net/6671cd0d-5b91-4044-bdcc-e1f201c086c5/projects/d72d1c2f-dfbe-4d48-9605-cd3b7e38ed17/Main-Logo-9277cc4b-0c1f-4093-a917-1a65e874b3c9.png', N'Pay slip logo', CAST(N'2021-08-25T11:37:09.943' AS DateTime), @UserId)
    )
    AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET CompanyId = Source.CompanyId,
               [Key] = source.[Key],
               [Value] = Source.[Value],
               [Description] = source.[Description],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
    VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

END