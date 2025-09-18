CREATE PROCEDURE [dbo].[Marker324]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
		
	MERGE INTO [dbo].[EmployeeFields] AS Target 
	USING (VALUES 
			 (NEWID(), N'surName',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'branchId',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'timeZoneId',0,1,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'mobileNo',0,1,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'roleIds',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'businessUnitIds',0,1,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'jobCategoryId',0,1,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'multipleBranches',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'departmentId',0,1,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'shiftTimingId',0,0,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'ipNumber',0,1,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'currencyId',0,1,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'email',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'firstName',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'employmentStatusId',0,1,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'isActive',0,0,0,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'designationId',0,1,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'employeeNumber',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
,(NEWID(), N'dateOfJoining',0,0,1,NULL,GETDATE(),@UserId,NULL,NULL, @CompanyId)
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

END
GO