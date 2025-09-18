CREATE PROCEDURE [dbo].[USP_GetDynamicModule]
(
   @DynamicModuleId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	BEGIN TRY

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT DynamicModuleName
		,Stuff((SELECT ','+DynamicTabName
				 FROM DynamicTab WHERE DynamicModuleId = DM.Id AND InActiveDateTime IS NULL 
		      FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') as DynamicTabNames
        ,Id DynamicModuleId
		,ModuleIcon
		,ViewRole
		,EditRole,
		DM.[TimeStamp]
		,Stuff((SELECT ','+RoleName FROM [Role] WHERE Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(ViewRole)) 
		      FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') as ViewRoleName
		,Stuff((SELECT ','+RoleName FROM [Role] WHERE Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(EditRole)) 
		      FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') as EditRoleName
		,[Description]
		FROM DynamicModule DM
		WHERE (@DynamicModuleId IS NULL OR Id = @DynamicModuleId)
		 AND CompanyId = @CompanyId
		 AND InActiveDateTime IS NULL
		 AND (SELECT dbo.Ufn_RoleCheck(ViewRole,@OperationsPerformedBy)) = 1 
		 AND (SELECT dbo.Ufn_RoleCheck(EditRole,@OperationsPerformedBy)) = 1 
					  Order by CreatedDateTime desc

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END