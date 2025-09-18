CREATE  PROCEDURE [dbo].[USP_ResetDatabaseToTestKickStartState]
@UserGuid UNIQUEIDENTIFIER,
@CompanyGuid UNIQUEIDENTIFIER
AS
BEGIN
   SET NOCOUNT ON;

   EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?'
   EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
   EXEC sp_MSForEachTable 'DELETE FROM ?'
   EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
   EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?'

    INSERT INTO [dbo].[Company](Id, CompanyName, CreatedDateTime)
    VALUES(@CompanyGuid, 'company name',getdate())

    INSERT INTO [dbo].[User](Id, CompanyId, UserName,  FirstName, [Password], [IsActive], [MobileNo], [IsActiveOnMobile], [RegisteredDateTime], [CreatedDateTime], [CreatedByUserId])
    VALUES(@UserGuid, @CompanyGuid,'TestUser','TestUserFirstName', 'TestUserPassword', 1, 'test mobile no', 1, getdate(), getdate(), N'127133f1-4427-4149-9dd6-b02e0e036970')
    
    INSERT INTO UserRole
						(Id
						,UserId
						,RoleId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@UserGuid
							   ,N'2fdd59fd-7900-4c1d-a054-37414e2f71e3'
							   , N'127133f1-4427-4149-9dd6-b02e0e036970'
							   ,GETDATE()
    

END
GO