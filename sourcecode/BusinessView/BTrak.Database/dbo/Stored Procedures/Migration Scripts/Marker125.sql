CREATE PROCEDURE [dbo].[Marker125]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  MERGE INTO [dbo].[CompanySettings] AS Target
  USING ( VALUES
  		 (NEWID(), @CompanyId, N'StorageAccountName', N'',N'Storage account name', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'StorageAccountAccessKey', N'',N'Storage account access key', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'iformFileuploadpath', N'',N'Iform file upload path', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'iformFilesize', N'10',N'Iform file size', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'FromMailAddress', N'',N'From mail address', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'SmtpServer', N'',N'Smtp server', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'SmtpServerPort', N'',N'Smtp server port', GETDATE(), @UserId),
  		 (NEWID(), @CompanyId, N'UseSsl', N'1',N'Use SSL', GETDATE(), @UserId)
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