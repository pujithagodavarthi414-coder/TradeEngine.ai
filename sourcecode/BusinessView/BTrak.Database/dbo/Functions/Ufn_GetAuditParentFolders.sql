CREATE FUNCTION [dbo].[Ufn_GetAuditParentFolders]
(
	@AuditFolderId UNIQUEIDENTIFIER
)
RETURNS TABLE AS
RETURN


       WITH Tree as
       (
        SELECT P.ParentAuditFolderId,P.AuditFolderName,P.Id,P.[TimeStamp],1 AS lvl, P.InActiveDateTime
        FROM AuditFolder P
        WHERE P.Id = @AuditFolderId --AND InActiveDateTime IS NULL
        
        UNION ALL
        
        SELECT P1.ParentAuditFolderId,P1.AuditFolderName,P1.Id,P1.[TimeStamp],lvl + 1, P1.InActiveDateTime
        FROM AuditFolder P1  
        INNER JOIN Tree M
        ON M.ParentAuditFolderId = P1.Id
        WHERE M.ParentAuditFolderId IS NOT NULL --AND InActiveDateTime IS NULL
       )
	   SELECT T.*, AF.CreatedDateTime, AF.UpdatedDateTime, AF.CompanyId, AF.ProjectId FROM Tree T INNER JOIN AuditFolder AF ON AF.Id = T.Id
GO
