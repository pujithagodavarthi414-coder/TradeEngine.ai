CREATE PROCEDURE [dbo].[USP_GetRolesDropDown]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @CompanyId UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	 IF (@HavePermission = '1')
	 BEGIN

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 IF(@SearchText = '') SET @SearchText = NULL

	      SELECT R.Id RoleId,
				 R.RoleName
		  FROM  [dbo].[Role] AS R WITH (NOLOCK)
		  WHERE R.InactiveDateTime IS NULL
		        AND (R.CompanyId = @CompanyId)
				AND (@SearchText IS NULL OR R.RoleName LIKE '%'+ @SearchText+'%')
				AND (R.IsHidden = 0 OR R.IsHidden IS NULL)
		  ORDER BY RoleName ASC 

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END