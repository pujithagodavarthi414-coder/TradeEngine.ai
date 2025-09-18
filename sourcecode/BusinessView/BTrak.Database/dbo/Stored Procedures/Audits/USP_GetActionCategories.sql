CREATE PROCEDURE [dbo].[USP_GetActionCategories]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @ActionCategoryName NVARCHAR(250)= NULL,
     @ActionCategoryId UNIQUEIDENTIFIER = NULL,
     @IsArchived BIT = NULL
)
 AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

        IF(@IsArchived IS NULL) SET @IsArchived = 0

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
        
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  SELECT AC.Id ActionCategoryId,
				 AC.ActionCategoryName,
				 AC.CompanyId,
				 AC.[TimeStamp]
				FROM ActionCategory AC
				WHERE CompanyId = @CompanyId
				AND (@ActionCategoryId  IS NULL OR AC.Id = @ActionCategoryId)
				AND (@ActionCategoryName IS NULL OR AC.ActionCategoryName = @ActionCategoryName)
                AND (@IsArchived IS NULL OR (@IsArchived = 1 AND AC.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND AC.InactiveDateTime IS NULL))
				ORDER BY ActionCategoryName
				
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