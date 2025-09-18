CREATE PROCEDURE [dbo].[USP_GetCompanyModules]
	@CompanyId UNIQUEIDENTIFIER = NULL,
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
	        SELECT CM.Id AS CompanyModuleId,
			       CM.CompanyId,
				   CM.ModuleId,
				   M.ModuleName,
				   C.CompanyName,
				   TotalCount = COUNT(1) OVER(),
				   CM.[TimeStamp],
				   M.[ModuleDescription] AS [Description],
				   M.ModuleLogo,
				   M.[TimeStamp] AS ModuleTimeStamp,
				   ModulePages =  (STUFF((SELECT ',' + MP.PageName [text()]
			  				  FROM ModulePage MP
			  						LEFT JOIN CompanyModule CM1 ON CM1.Id = MP.CompanyModuleId
			   				  WHERE  MP.CompanyModuleId = CM.Id AND MP.InActiveDateTime IS NULL
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				  M.Tags
				FROM [dbo].[CompanyModule]CM
				INNER JOIN [dbo].[Module]M ON M.Id = CM.ModuleId
				INNER JOIN [dbo].[Company]C ON C.Id = CM.CompanyId
			WHERE (@CompanyId IS NULL OR CM.CompanyId = @CompanyId)
			AND (@SearchText IS NULL or ((M.ModuleName LIKE '%' + @SearchText + '%')) OR (M.ModuleDescription LIKE '%' + @SearchText + '%'))
			AND M.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL
			AND CM.IsActive = 1 AND CM.IsEnabled = 1 AND (CM.InActiveDateTime IS NULL)
			ORDER BY M.ModuleName ASC
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