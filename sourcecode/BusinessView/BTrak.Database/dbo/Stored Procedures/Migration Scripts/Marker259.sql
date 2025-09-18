CREATE PROCEDURE [dbo].[Marker259]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[ScheduleStatus] AS Target 
	USING (VALUES 
	(NEWID(),'New','#33BBFF','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Selected','#36E801','2',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Being interviewed','#33FFFF','3',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Not selected','#ff3333','4',@CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Status] = Source.[Status]  AND Target.[Status] IS NOT NULL AND Target.[CompanyId]=Source.[CompanyId]
WHEN MATCHED THEN 
UPDATE SET
		   [Status] = Source.[Status],
		   [Color] = Source.[Color],
		   [Order] = Source.[Order],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]);

END
GO