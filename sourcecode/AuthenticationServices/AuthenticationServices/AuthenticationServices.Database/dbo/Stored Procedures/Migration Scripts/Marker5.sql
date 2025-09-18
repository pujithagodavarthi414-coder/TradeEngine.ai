CREATE PROCEDURE [dbo].[Marker5]
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
		 (NEWID(), @CompanyId, N'Excel sheet uploader mail', N'Excel sheet uploader mail',N'Mail from which the user sends the excel sheets to convert to custom aplication records', GETDATE() , @UserId)
		 ,(NEWID(), @CompanyId, N'Excel sheet uploader mail password', N'Excel sheet uploader password',N'Mail password from which the user sends the excel sheets to convert to custom aplication records', GETDATE() , @UserId)
	     ,(NEWID(), @CompanyId, N'Excel sheet uploader mail subject', N'Excel sheet uploader subject',N'Mail subject from which the user sends the excel sheets to convert to custom aplication records', GETDATE() , @UserId)
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
INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);
	

END