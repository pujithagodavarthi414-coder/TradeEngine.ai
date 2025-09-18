CREATE PROCEDURE [dbo].[Marker158]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    DECLARE @AuditsCount INT = (SELECT COUNT(1) FROM AuditCompliance WHERE AuditFolderId IS NULL AND CompanyId = @CompanyId)

    IF(@AuditsCount > 0)
    BEGIN
        
        DECLARE @ParentAuditFolderId UNIQUEIDENTIFIER = (SELECT Id FROM AuditFolder WHERE AuditFolderName = 'Audits' AND ParentAuditFolderId IS NULL AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

        IF(@ParentAuditFolderId IS NULL)
        BEGIN

            SET @ParentAuditFolderId = NEWID()

            INSERT INTO AuditFolder([Id], [CompanyId], [AuditFolderName], [ParentAuditFolderId], [CreatedDateTime], [CreatedByUserId])
            SELECT @ParentAuditFolderId, @CompanyId, N'Audits', NULL, GETDATE(), @UserId

        END

        UPDATE AuditCompliance SET AuditFolderId = @ParentAuditFolderId, UpdatedDateTime = GETDATE() WHERE AuditFolderId IS NULL AND CompanyId = @CompanyId

    END
	
END
GO