CREATE PROCEDURE [dbo].[Marker186]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    INSERT INTO [dbo].Workspace([Id],[WorkspaceName],[IsCustomizedFor],[CreatedDateTime],[CreatedByUserId],CompanyId)
        SELECT AQ.Id,CONCAT('AuditQuestion-', CONVERT(NVARCHAR(MAX), AQ.Id)),'AuditQuestionAnalytics',GETDATE(),AQ.CreatedByUserId,AQ.CompanyId 
            FROM AuditQuestions AQ WHERE AQ.Id NOT IN (SELECT Id FROM Workspace WHERE CompanyId = @CompanyId) AND AQ.InActiveDateTime IS NULL AND AQ.CompanyId  = @CompanyId  

END
GO