CREATE PROCEDURE [dbo].[USP_GetModulePages]
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@ModulePageId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	  DECLARE @HavePermission NVARCHAR(250)  = '1'
	   IF(@HavePermission = '1')
       BEGIN
	        SELECT MP.Id AS ModulePageId,
			       MP.CompanyModuleId,
				   MP.PageName,
				   MP.IsDefault,
				   M.ModuleName,
				   (SELECT COUNT(1) FROM [dbo].[ModuleLayout]ML LEFT JOIN [dbo].[ModulePage]MP1 ON MP1.Id = ML.ModulePageId 
				    WHERE ML.ModulePageId = MP.Id AND ML.InActiveDateTime IS NULL) AS LayoutsCount,
				   MP.[Timestamp]
			  FROM [dbo].[ModulePage]MP
			  INNER JOIN [dbo].[CompanyModule]CM ON CM.Id = MP.CompanyModuleId
			  INNER JOIN [dbo].[Module]M ON M.Id = CM.ModuleId
			WHERE (@ModulePageId IS NULL OR MP.Id = @ModulePageId)
			AND (@ModuleId IS NULL OR CM.Id = @ModuleId)
			AND (@SearchText IS NULL OR MP.PageName LIKE '%' + @SearchText + '%')
			AND MP.InActiveDateTime IS NULL AND M.InActiveDateTime IS NULL
			ORDER BY MP.PageName ASC
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
