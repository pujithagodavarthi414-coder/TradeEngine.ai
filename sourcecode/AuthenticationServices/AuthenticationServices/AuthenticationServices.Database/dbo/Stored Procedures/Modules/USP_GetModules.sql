CREATE PROCEDURE [dbo].[USP_GetModules]
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = '1'
	   IF(@HavePermission = 1)
	   BEGIN
	       SELECT M.ModuleName,
		          M.Id AS ModuleId,
				  M.ModuleLogo,
				  M.ModuleDescription,
				  M.[TimeStamp]
			FROM [dbo].[Module]M
			WHERE M.InActiveDateTime IS NULL
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