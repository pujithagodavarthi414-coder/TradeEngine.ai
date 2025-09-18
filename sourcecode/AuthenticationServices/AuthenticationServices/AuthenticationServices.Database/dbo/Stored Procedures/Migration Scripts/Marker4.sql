CREATE PROCEDURE [dbo].[Marker4]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
    MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
		(NEWID(), @RoleId, N'3DCF0C72-244C-4F49-87A8-BDFDE94FFA1D', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
       ,(NEWID(), @RoleId, N'218096C9-1D0F-4DF4-9F37-B9697C824793', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
       ,(NEWID(), @RoleId, N'23A7830E-5AE1-4916-930B-D0DE643413AA', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.[RoleId] = Source.[RoleId] AND Target.[FeatureId] = Source.[FeatureId]  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               [FeatureId] = Source.[FeatureId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

      MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'StampDocument', N'',N'Logo for stamp', GETDATE(), @UserId,1)
		  )
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId], [IsVisible])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
               [IsVisible]  = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);

    INSERT INTO RoleFeature([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    SELECT NEWID(),@RoleId,F.ID,GETDATE(),@UserId FROM Feature F LEFT JOIN RoleFeature RF ON RF.FeatureId = F.Id AND RF.RoleId = @RoleId
    WHERE RF.Id IS NULL

END