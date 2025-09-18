Create PROCEDURE [dbo].[USP_GetDynamicModuleTabs]
(
   @DynamicModuleId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	BEGIN TRY

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT Id AS DynamicTabId,
		         DynamicTabName,ViewRole,EditRole,
				 CreatedDateTime,
				 (SELECT RoleName FROM [Role] WHERE Id = CAST(ViewRole AS uniqueidentifier)) as ViewRoleName,
				 (SELECT RoleName FROM [Role] WHERE Id = CAST(EditRole AS uniqueidentifier)) as EditRoleName 
				 FROM DynamicTab WHERE DynamicModuleId = @DynamicModuleId AND InActiveDateTime IS NULL 
				 ORDER BY CreatedDateTime ASC				
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END