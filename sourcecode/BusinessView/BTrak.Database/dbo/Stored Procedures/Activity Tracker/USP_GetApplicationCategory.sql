--EXEC [dbo].[USP_GetApplicationCategory] @OperationsPerformedBy = '589BE7AE-E5FA-4BDB-B5C4-F44834151BA4'
CREATE PROCEDURE [dbo].[USP_GetApplicationCategory]
(
	@ApplicationCategoryName NVARCHAR(250) = NULL,
	@ApplicationCategoryId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL
)
 AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@ApplicationCategoryName = '') SET @ApplicationCategoryName = NULL

			IF (@HavePermission = '1')
			BEGIN
				
				SELECT AC.Id AS ApplicationCategoryId
					   ,AC.ApplicationCategoryName
					   ,AC.CompanyId
					   ,AC.CreatedByUserId
					   ,AC.CreatedDateTime
					   ,AC.[TimeStamp]
					   ,CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
				FROM ApplicationCategory AC
				WHERE AC.CompanyId = @CompanyId
					 AND (@ApplicationCategoryId IS NULL OR AC.Id = @ApplicationCategoryId)
					 AND (@ApplicationCategoryName IS NULL OR AC.ApplicationCategoryName = @ApplicationCategoryName)
					 AND (@IsArchived IS NULL 
							OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL)
							OR (@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL)
					 )

			END
			ELSE
				RAISERROR (@HavePermission,11, 1)
				
		  END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
 GO