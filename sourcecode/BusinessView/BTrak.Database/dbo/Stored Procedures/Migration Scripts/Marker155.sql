CREATE PROCEDURE [dbo].[Marker155]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

      UPDATE  Widget SET WidgetName = 'Company hierarchy' 
                WHERE WidgetName = 'Branch' 
        AND CompanyId = @CompanyId

    --DECLARE @EntityCount INT = ISNULL((SELECT COUNT(1) FROM Entity WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL),0)

    --IF(@EntityCount > 1)
    --BEGIN
      
    --    UPDATE Entity SET IsBranch = 1 WHERE Id IN (SELECT Id FROM Branch WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId)
        
    --    UPDATE Entity SET IsGroup = 1,IsBranch = 0
    --    WHERE ParentEntityId IS NULL AND InactiveDateTime IS NULL AND CompanyId = @CompanyId AND EntityName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId)

    --    UPDATE Branch SET InActiveDateTime = GETDATE() WHERE BranchName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId) AND CompanyId = @CompanyId 
    --    --AND Id = (SELECT )

    --END

END
GO
