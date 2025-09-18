CREATE PROCEDURE [dbo].[Marker183]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)

MERGE INTO [dbo].[CustomTags] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Configure Employee bonus' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Users' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
)
AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ReferenceId] = Source.[ReferenceId],
		   [TagId] = Source.[TagId],	
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET  AND Source.ReferenceId IS NOT NULL  THEN 
INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);


MERGE INTO [dbo].[TaxCalculationType] AS Target 
USING ( VALUES 
		(NEWID(), N'Old Tax Slabs', @CountryId,CAST(N'2019-12-31T10:48:51.907' AS DateTime), @UserId),
		(NEWID(), N'New Tax Slabs', @CountryId,CAST(N'2019-12-31T10:48:51.907' AS DateTime), @UserId)
		) 
AS Source ([Id], [TaxCalculationTypeName],[CountryId],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TaxCalculationTypeName] = Source.[TaxCalculationTypeName],
           [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [CountryId] = Source.[CountryId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [TaxCalculationTypeName],[CountryId],[CreatedDateTime], [CreatedByUserId]) 
VALUES([Id], [TaxCalculationTypeName],[CountryId],[CreatedDateTime], [CreatedByUserId]);	

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'B50D9A50-06CB-4D9B-8227-617CDAF016FD', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

DECLARE @OldTaxCalculationTypeId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM TaxCalculationType WHERE CountryId = @CountryId AND TaxCalculationTypeName = 'Old Tax Slabs')

DECLARE @NewTaxCalculationTypeId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM TaxCalculationType WHERE CountryId = @CountryId AND  TaxCalculationTypeName = 'New Tax Slabs')

UPDATE TaxSlabs
SET [IsFlatRate] = 1
WHERE [Name] = 'Slabs'
AND CountryId IN (SELECT Id FROM Country WHERE CompanyId = @CompanyId)

UPDATE TaxSlabs
SET TaxCalculationTypeId = @NewTaxCalculationTypeId
WHERE [Name] = 'Slabs' AND CountryId = @CountryId

UPDATE TaxSlabs
SET TaxCalculationTypeId = @OldTaxCalculationTypeId
WHERE [Name] in ('Upto 60 years','Age 60-80','Above 80 years')
AND CountryId = @CountryId

UPDATE Widget
set WidgetName = 'Rate tag library'
where WidgetName = 'Rate tag'
AND CompanyId = @CompanyId

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'38CED01C-DB50-4999-ABC3-EAE960DD51DB', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
		  ,(NEWID(), @RoleId, N'2B447F3A-8022-43A7-B145-731D5F6678F6', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);


END
GO