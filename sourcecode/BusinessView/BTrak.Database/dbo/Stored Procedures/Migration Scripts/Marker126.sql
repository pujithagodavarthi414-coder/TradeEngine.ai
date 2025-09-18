CREATE PROCEDURE [dbo].[Marker126]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  MERGE INTO [dbo].[CompanySettings] AS Target
  USING ( VALUES
  		 (NEWID(), @CompanyId, N'AcceptableGoogleDomains', N'',N'Domains accepted for google login', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'DefaultGoogleUserRole', N'',N'Default role for user logged in via google', GETDATE(), @UserId)
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
GO