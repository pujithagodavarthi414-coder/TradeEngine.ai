CREATE PROCEDURE [dbo].[USP_GetLeadStages]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @Id UNIQUEIDENTIFIER = NULL,
     @SearchText NVARCHAR(250)  = NULL
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
            
              SELECT  LS.Id,
              LS.[Name],
              LS.[Color],
              LS.[TimeStamp],
			  CASE WHEN LS.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
              TotalCount = COUNT(1) OVER()
            FROM LeadStages LS
			WHERE LS.CompanyId = @CompanyId
            AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LS.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND LS.InactiveDateTime IS NULL))
            AND (@Id IS NULL OR (@Id = LS.Id))
            ORDER BY LS.CreatedDatetime DESC
 
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
