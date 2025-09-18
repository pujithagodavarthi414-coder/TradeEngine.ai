CREATE PROCEDURE [dbo].[Marker223]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @DefaultUserId UNIQUEIDENTIFIER = NULL
        
        SET @DefaultUserId = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')

		IF(@DefaultUserId IS NOT NULL)
        BEGIN
		
	 MERGE INTO [dbo].[NotificationType] AS Target 
        USING ( VALUES 
      (N'750B94A6-1D1F-43F5-9843-1BB1A7ADD8AB', N'GenericNotificationActivity',N'e10ddae0-39e4-4010-9981-269fea0991d5',CAST(N'2018-08-13 13:09:49.497' AS DateTime), @DefaultUserId)
        ) 
        AS Source ([Id], [NotificationTypeName],[FeatureId], [CreatedDateTime], [CreatedByUserId]) 
        ON Target.NotificationTypeName = Source.NotificationTypeName  
        WHEN MATCHED THEN 
        UPDATE SET [NotificationTypeName] = Source.[NotificationTypeName],
        		   [FeatureId] = Source.[FeatureId],
        	       [CreatedDateTime] = Source.[CreatedDateTime],
        		   [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [NotificationTypeName],[FeatureId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [NotificationTypeName],[FeatureId], [CreatedDateTime], [CreatedByUserId]);	
        
		END
END
GO
