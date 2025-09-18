CREATE PROCEDURE [dbo].[USP_GetAuditVersions]
(
   @AuditId UNIQUEIDENTIFIER
    ,@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN TRY
            
            DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)
		    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
		    BEGIN

                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
                SELECT VersionName AS AuditVersionName
                       ,ACV.Id AS AuditId
                       ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName
                       ,ACV.CreatedDateTime
                       ,U.ProfileImage AS CreatedByUserProfileImage
                FROM AuditComplianceVersions ACV
                     INNER JOIN [User] U ON U.Id = ACV.CreatedByUserId
                WHERE ACV.InActiveDateTime IS NULL
                      AND ACV.AuditId = @AuditId
                      AND ACV.CompanyId = @CompanyId
                ORDER BY ACV.CreatedDateTime
            
            END

    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH

END
GO