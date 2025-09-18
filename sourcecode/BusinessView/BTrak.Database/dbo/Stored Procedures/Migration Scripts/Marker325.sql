CREATE PROCEDURE [dbo].[Marker325]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN
    MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
    USING ( VALUES
     (NEWID(), GETDATE(), @UserId, @CompanyId, N'Client', N'Clients')
    )
    AS Source ([Id], [CreatedDateTime], [CreatedByUserId], [CompanyId], [ClientLabel], [ClientsLabel])
    ON Target.CompanyId = Source.CompanyId 
    WHEN MATCHED THEN
    UPDATE SET 
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId]       = Source.[CompanyId],
               [ClientLabel] = Source.[ClientLabel],
               [ClientsLabel] = Source.[ClientsLabel];
END
GO
