CREATE PROCEDURE [dbo].[Marker124]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  IF(NOT EXISTS(SELECT 1 FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday planned vs unplanned work percentage' AND CompanyId = @CompanyId))
  BEGIN

	UPDATE CustomWidgets SET CustomWidgetName = 'Yesterday planned vs unplanned work percentage' WHERE CustomWidgetName = 'Planned vs unplanned work percentage' AND CompanyId = @CompanyId
 
  END
  
  UPDATE Widget SET InActiveDateTime = GETDATE() WHERE WidgetName='Activity tracker timeline' AND CompanyId='59A3F184-B1A3-4DD6-82AD-0041514B2565'

  MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'DocumentsSizeLimit', N'1073741824',N'Describes the maximum limit to upload files for a company', GETDATE(), @UserId)
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