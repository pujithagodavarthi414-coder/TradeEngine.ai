--EXEC [USP_GetExpenseCategories] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'

CREATE PROCEDURE [dbo].[USP_GetExpenseCategories]
(
  @ExpenseCategoryId UNIQUEIDENTIFIER = NULL,
  @ExpenseCategoryName NVARCHAR(250) = NULL,
  @Description NVARCHAR(500) = NULL,
  @AccountCode NVARCHAR(100) = NULL,
  @IsSubCategory BIT = NULL,
  @IsArchived BIT = NULL,
  @SearchText NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(50) = NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		   IF(@HavePermission = '1')			 
		   BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))		   
		     
	           IF(@ExpenseCategoryId = '00000000-0000-0000-0000-000000000000') SET @ExpenseCategoryId = NULL
		       
	           IF(@ExpenseCategoryName = '') SET  @ExpenseCategoryName = NULL
		     
	           IF(@Description = '') SET  @Description = NULL
		     
		       IF(@SearchText = '') SET  @SearchText = NULL

			   IF(@AccountCode = '') SET @AccountCode = NULL
		     
		       IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		     
		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		     
		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Merchant])

			   IF(@PageSize = 0) SET @PageSize = 10
		     
		       IF(@PageNumber IS NULL) SET @PageNumber = 1
		     
	           SELECT EC.Id AS ExpenseCategoryId,
		              EC.CategoryName,
					  EC.IsSubCategory,
					  EC.AccountCode,
		  	  	      EC.[Description],
		              EC.CompanyId,
		  	  	      EC.CreatedByUserId,
		  	  	      EC.CreatedDateTime,
					  EC.[TimeStamp],
		              TotalCount = COUNT(1) OVER()
		       FROM  [dbo].[ExpenseCategory] EC WITH (NOLOCK)
		       WHERE EC.CompanyId = @CompanyId
					 AND (@IsArchived IS NULL 
					      OR (@IsArchived = 1 AND EC.InActiveDateTime IS NOT NULL)
						  OR (@IsArchived = 0 AND EC.InActiveDateTime IS NULL))
		             AND (@ExpenseCategoryId IS NULL OR EC.Id = @ExpenseCategoryId)
		             AND (@IsSubCategory IS NULL OR EC.IsSubCategory = @IsSubCategory)
		             AND (@ExpenseCategoryName IS NULL OR EC.CategoryName = @ExpenseCategoryName)
		             AND (@Description IS NULL OR EC.[Description] = @Description)
		             AND (@AccountCode IS NULL OR EC.AccountCode = @AccountCode)
		             AND (@SearchText IS NULL 
					       OR (EC.CategoryName LIKE @SearchText)
						   OR (EC.AccountCode LIKE @SearchText)
		  	  			   OR (EC.[Description] LIKE @SearchText))
		       ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	  			CASE WHEN @SortBy = 'CategoryName' THEN EC.CategoryName
		  	  			     WHEN @SortBy = '[Description]' THEN EC.[Description]
		  	  			     WHEN @SortBy = '[AccountCode]' THEN EC.AccountCode
		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,EC.CreatedDateTime,121) AS sql_variant)
		  	  			END
		  	  	  END ASC,
		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
		  	  			CASE WHEN @SortBy = 'CategoryName' THEN EC.CategoryName
		  	  			     WHEN @SortBy = '[Description]' THEN EC.[Description]
		  	  			     WHEN @SortBy = '[AccountCode]' THEN EC.AccountCode
		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,EC.CreatedDateTime,121) AS sql_variant)
		  	  			END
		  	  	  END DESC
		     OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		     FETCH NEXT @PageSize Rows ONLY 
			 
			   END
		   ELSE
		   BEGIN
		   
		   	RAISERROR (@HavePermission,11, 1)
		   		
		   END
			   
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO