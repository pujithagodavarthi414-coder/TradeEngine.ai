CREATE PROCEDURE [dbo].[Marker115]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    MERGE INTO [dbo].[BoardType] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'SuperAgile',N'D0C55A82-303C-4976-8884-026441BA75BF')
	) 
	AS Source ([Id],CompanyId, [BoardTypeName], [BoardTypeUIId]) 
	ON Target.CompanyId = Source.CompanyId 
	   AND Target.[BoardTypeName] = Source.[BoardTypeName]
	   AND Target.[BoardTypeUIId] = Source.[BoardTypeUIId]
	WHEN MATCHED THEN 
	UPDATE SET [IsDefault] = 1,
	           [IsSuperAgileBoard] = 1;

	MERGE INTO [dbo].[BoardType] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'Kanban Bugs',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8')
			,(NEWID(),@CompanyId, N'Kanban',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8')
			,(NEWID(),@CompanyId, N'Templates Workflow',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8')
	) 
	AS Source ([Id],CompanyId, [BoardTypeName], [BoardTypeUIId]) 
	ON Target.CompanyId = Source.CompanyId 
	   AND Target.[BoardTypeName] = Source.[BoardTypeName]
	   AND Target.[BoardTypeUIId] = Source.[BoardTypeUIId]
	WHEN MATCHED THEN 
	UPDATE SET [IsDefault] = 1;
	
END
GO
