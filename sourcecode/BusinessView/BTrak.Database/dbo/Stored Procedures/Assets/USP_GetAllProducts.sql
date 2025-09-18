--EXEC [dbo].[USP_GetAllProducts]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllProducts]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageNumber INT = NULL,
    @PageSize INT = NULL,
    @SortBy NVARCHAR(100) = 'ProductName',
    @SortDirection NVARCHAR(100) = 'ASC',
	@IsArchived BIT = NULL,
    @SearchText NVARCHAR(100) = NULL
)
AS
BEGIN

   SET NOCOUNT ON
   BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SET @SearchText = '%'+ @SearchText+'%'

		IF(@PageSize IS NULL)
		BEGIN
		SET @PageSize =(SELECT COUNT(1) FROM Product)
		END
		
		IF(@PageSize = 0)
        SET @PageSize = 10	

		IF(@Pagenumber IS NULL) SET @Pagenumber = 1
		
        SELECT P.Id AS ProductId,
			   P.ProductName,
			   P.CreatedDateTime AS CreatedDate,
			   P.CreatedByUserId,
			   CASE WHEN P.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
			   P.[TimeStamp],
			   TotalCount = COUNT(1) OVER()
        FROM Product AS P
        WHERE P.CompanyId = @CompanyId  
		AND (@IsArchived IS NULL OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND P.InactiveDateTime IS NULL))
		AND (@SearchText IS NULL OR (P.ProductName LIKE @SearchText))
		ORDER BY ProductName 
		OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		FETCH NEXT @PageSize ROWS ONLY	

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
