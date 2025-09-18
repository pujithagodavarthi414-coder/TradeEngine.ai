
--EXEC [dbo].[USP_GetAuditImpact] @OperationsPerformedBy = '9d7e7f73-227c-411d-aaed-41568d59894e'
CREATE PROCEDURE [dbo].[USP_GetAuditImpact]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL
)
 AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


		  SELECT Id ImpactId,
				 ImpactName,
				 [Description],
				 [TimeStamp]
				FROM AuditImpact
				WHERE CompanyId = @CompanyId
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND InactiveDateTime IS NULL))
				ORDER BY ImpactName

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