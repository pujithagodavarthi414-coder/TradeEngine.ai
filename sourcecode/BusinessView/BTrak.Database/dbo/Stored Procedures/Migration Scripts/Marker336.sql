CREATE PROCEDURE [dbo].[Marker336]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
		
	MERGE INTO [dbo].[EmployeeFields] AS Target 
	USING (VALUES 
	(NEWID(), N'isActive',0,0,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
			)
	AS Source ([Id], FieldName, Hide, Edit, Mandatory, InActiveDateTime, [CreatedDateTime], [CreatedByUserId],UpdatedDateTime,UpdatedByUserId,CompanyId)
	ON Target.FieldName = Source.FieldName  AND Target.CompanyId=Source.CompanyId
	WHEN MATCHED THEN 
	UPDATE SET [FieldName] = Source.[FieldName],
			   [Hide] = Source.[Hide],
			   [Edit] = Source.[Edit],
			   [Mandatory] = Source.[Mandatory]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], FieldName, Hide, Edit, Mandatory, InActiveDateTime, [CreatedDateTime], [CreatedByUserId],UpdatedDateTime,UpdatedByUserId,CompanyId) 
	VALUES ([Id], FieldName, Hide, Edit, Mandatory, InActiveDateTime, [CreatedDateTime], [CreatedByUserId],UpdatedDateTime,UpdatedByUserId,CompanyId);	
	
	 INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
    VALUES (NEWID(),@Roleid,'F371622B-3CEC-46D0-AE2D-99349C1B0098',@UserId,GETUTCDATE())
          ,(NEWID(),@Roleid,'57AE5D56-B002-4A69-9FB9-2C01E3589130',@UserId,GETUTCDATE())
          ,(NEWID(),@Roleid,'DC0E9E15-1203-4506-8E2F-E6ABE88DAC00',@UserId,GETUTCDATE())

END
GO