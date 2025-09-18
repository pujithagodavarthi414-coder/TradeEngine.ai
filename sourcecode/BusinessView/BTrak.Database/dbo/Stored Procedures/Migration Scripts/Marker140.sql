CREATE PROCEDURE [dbo].[Marker140]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'EnableLoginWithGoogle', N'0',N'Enable login with google', GETDATE(), @UserId)
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
GO
