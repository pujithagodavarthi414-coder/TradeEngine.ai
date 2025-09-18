CREATE PROCEDURE [dbo].[Marker21]
(
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DELETE FROM [ProcessDashboardStatus] WHERE StatusName='Process is not started yet'

DECLARE @Val CHAR(1) = IIF((SELECT IndustryId FROM Company WHERE Id = @CompanyId) = (SELECT Id FROM Industry WHERE IndustryName LIKE '%Remote Working%') , 1, 0)

MERGE INTO [dbo].[CompanySettings] AS Target
USING ( VALUES
			(NEWID(), @CompanyId, N'ConsiderMACAddressInEmployeeScreen', @Val,N'Considering MAC address from employee ', GETDATE(), @UserId)
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

MERGE INTO [dbo].[ActivityTrackerConfigurationState] AS Target
USING ( VALUES
	(NEWID(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, @CompanyId)
)
AS Source (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId)
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId] = Source.[CompanyId],
		    [Id] = Source.[Id],
			[IsTracking] = Source.[IsTracking],		   
			[IsScreenshot] = Source.[IsScreenshot],
			[IsDelete] = Source.[IsDelete],
			[DeleteRoles] = Source.[DeleteRoles],
			[IsRecord] = Source.[IsRecord],
			[RecordRoles] = Source.[RecordRoles],
			[IsIdealTime] =  Source.[IsIdealTime],
			[IdealTimeRoles] =  Source.[IdealTimeRoles],
			[IsManualTime] =  Source.[IsManualTime],
			[ManualTimeRole] =  Source.[ManualTimeRole]
WHEN NOT MATCHED BY TARGET THEN 
INSERT (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId) VALUES
	   (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId);

END
GO