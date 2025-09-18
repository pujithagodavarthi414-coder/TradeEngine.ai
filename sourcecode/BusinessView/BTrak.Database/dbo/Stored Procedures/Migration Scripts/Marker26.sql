CREATE PROCEDURE [dbo].[Marker26]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
		MERGE INTO [dbo].[WorkFlowType] AS TARGET
        USING( VALUES
		      (N'CC2FA695-AAF0-44F0-9B22-B03FA0D7FE63',N'DMN Workflow',CAST(N'2019-12-03 06:20:28.687' AS DateTime), @UserId,NULL)
        )
        AS Source ([Id],[WorkFlowTypeName],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkFlowTypeName] = Source.[WorkFlowTypeName],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [InActiveDateTime] = Source.[InActiveDateTime]
        WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id],[WorkFlowTypeName],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime])
        VALUES ([Id],[WorkFlowTypeName],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]);
	
END
GO