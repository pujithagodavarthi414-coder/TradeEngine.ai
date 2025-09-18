CREATE PROCEDURE [dbo].[Marker30]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

		MERGE INTO [dbo].[WorkFlowType] AS TARGET
        USING( VALUES
		      (N'0361770A-3F6D-4C86-AC7D-E2FA0DE428CA',N'Type-1',CAST(N'2019-11-07 06:20:28.687' AS DateTime), @UserId,CAST(N'2020-06-03 06:20:28.687' AS DateTime))
                ,(N'93BB9E02-41D2-4402-B53D-FF919217072B',N'Type-2',CAST(N'2019-11-08 06:20:28.687' AS DateTime), @UserId,CAST(N'2020-06-03 06:20:28.687' AS DateTime))
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
