CREATE PROCEDURE [dbo].[USP_GetModuleLayouts]
	@ModuleLayoutId UNIQUEIDENTIFIER = NULL,
	@ModulePageId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	  DECLARE @HavePermission NVARCHAR(250)  = '1'
	   IF(@HavePermission = '1')
       BEGIN
	        SELECT ML.Id AS ModuleLayoutId,
			       ML.ModulePageId,
				   ML.LayoutName,
				   M.ModuleName,
				   ML.[Timestamp],
				   TotalCount = COUNT(1) OVER()
			  FROM [dbo].[ModuleLayout]ML
			  INNER JOIN [dbo].[ModulePage]MP ON MP.Id = ML.ModulePageId
			  INNER JOIN [dbo].[CompanyModule]CM ON CM.Id = MP.CompanyModuleId
			  INNER JOIN [dbo].[Module]M ON M.Id = CM.ModuleId
			WHERE (@ModulePageId IS NULL OR MP.Id = @ModulePageId)
			AND (@SearchText IS NULL OR ML.LayoutName LIKE '%' + @SearchText + '%')
			AND ML.InActiveDateTime IS NULL AND M.InActiveDateTime IS NULL AND MP.InActiveDateTime IS NULL
			ORDER BY ML.LayoutName ASC
			  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			  FETCH NEXT @PageSize ROWS ONLY
	   END
	    ELSE
	   BEGIN
	     RAISERROR(@HavePermission,11,1)
	   END
	 END TRY
	BEGIN CATCH

		THROW

	END CATCH

END