CREATE PROCEDURE [dbo].[USP_GetUsersBasedOnFeaturePermission]
(
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT UserId,
					 UserName
				FROM [Ufn_GetUsersBasedOnFeaturePermission] (@CompanyId,@FeatureId)

         END
         ELSE
         BEGIN
         
                 RAISERROR (@HavePermission,11, 1)
                 
         END
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO