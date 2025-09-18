CREATE PROCEDURE [dbo].[Marker71]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[PartsOfDay] AS Target 
USING (VALUES 
		(NEWID(),'Morning',CAST(N'2020-04-01T00:00:00.000' AS DateTime),@UserId,@CompanyId)
	   ,(NEWID(),'Afternoon',CAST(N'2020-04-02T00:00:00.000' AS DateTime), @UserId,@CompanyId)
	   ,(NEWID(),'Evening',CAST(N'2020-04-03T00:00:00.000' AS DateTime), @UserId,@CompanyId)
	   ,(NEWID(),'Night',CAST(N'2020-04-04T00:00:00.000' AS DateTime), @UserId,@CompanyId)
) 

AS Source ([Id],[PartsOfDayName],[CreatedDateTime],[CreatedByUserId],[CompanyId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
		   [PartsOfDayName] = Source.[PartsOfDayName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[PartsOfDayName],[CreatedDateTime],[CreatedByUserId],[CompanyId]) VALUES ([Id],[PartsOfDayName],[CreatedDateTime],[CreatedByUserId],[CompanyId]);

END
GO
