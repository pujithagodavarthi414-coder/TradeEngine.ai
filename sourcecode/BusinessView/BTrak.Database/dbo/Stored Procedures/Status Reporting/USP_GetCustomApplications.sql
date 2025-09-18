--EXEC  [dbo].[USP_GetCustomApplications] @OperationsPerformedBy = 'B162DD20-E05D-4175-A370-44F33EA4BA2F',@PageSize = '35',@PageNumber ='1'

---------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Get the Custom Applications by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCustomApplications] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCustomApplications]
(
    @CustomApplicationId UNIQUEIDENTIFIER = NULL
	,@CustomApplicationName NVARCHAR(250) = NULL
	,@GenericFormId UNIQUEIDENTIFIER = NULL
	,@GenericFormName NVARCHAR(250) = NULL
    ,@OperationsPerformedBy UNIQUEIDENTIFIER
	,@PageNumber INT = 1
	,@PageSize INT = 10
	,@SearchText  NVARCHAR(250) = NULL
	,@IsArchived BIT = 0
	,@CompanyId UNIQUEIDENTIFIER=NULL
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = '1'
		
		IF (@HavePermission = '1')
	    BEGIN
           IF(@CompanyId IS NULL)
		   SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   DECLARE @BearerToken NVARCHAR(500) = (SELECT AuthToken from UserAuthToken WHERE UserId=@OperationsPerformedBy)
		   DECLARE @RoleIds NVARCHAR(MAX)
		   DECLARE @ModuleIds NVARCHAR(MAX)

		   IF(@SearchText = '')SET @SearchText = NULL


		   IF(@IsArchived IS NULL) SET @IsArchived = 0

		   IF(@CustomApplicationId IS NOT NULL)
		   BEGIN
		     
			      SELECT @RoleIds = COALESCE(@RoleIds + ',', '') + CONVERT(NVARCHAR(50),RoleId)
				  FROM CustomApplicationRoleConfiguration CARC 
				  WHERE CustomApplicationId = @CustomApplicationId

				  SELECT @ModuleIds = COALESCE(@ModuleIds + ',', '') + CONVERT(NVARCHAR(50),ModuleId)
				  FROM WidgetModuleConfiguration 
				  WHERE WidgetId = @CustomApplicationId AND InActiveDateTime IS NULL
		  END

		  DECLARE @JSONVALUE NVARCHAR(MAX) = (SELECT  * FROM (
		   SELECT CA.Id AS CustomApplicationId
		          ,CA.CustomApplicationName
				  ,CAF.GenericFormId AS FormId
				  ,CA.PublicMessage
				  ,CA.IsApproveNeeded
				  ,CA.Allowannonymous
				  ,CA.IsPdfRequired
				  ,CA.IsRedirectToEmails
				  ,CA.[Description]
				  ,CA.IsPublished
				  ,CAF.PublicUrl
				  ,CA.[CreatedDateTime]
				  ,CA.[TimeStamp]
				  ,CA.WorkflowIds
			 	  ,@IsArchived IsArchived
				  ,TotalCount = COUNT(1) OVER()
				  ,@RoleIds AS RoleIds
				  ,ToRoleIds
				  ,ToEmails
				  ,[Message]
				  ,[Subject]
				  ,ISNULL(IsRecordLevelPermissionEnabled,0) AS IsRecordLevelPermissionEnabled
				  ,RecordLevelPermissionFieldName
				  ,ConditionalEnum
				  ,ConditionsJson
				  ,StageScenariosJson
				  ,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@RoleIds,',')) WRC
		   							 INNER JOIN [Role] R ON R.Id = WRC.[Value] AND R.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,''))
			       ,UserIds = (STUFF((SELECT ',' +CAST( AC.ApproverId AS nvarchar(100)) [text()]
		   							 FROM ApprovalCustomApplicationForms AC
									 WHERE AC.CustomApplicationId = CA.Id
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,''))
				  ,@ModuleIds AS ModuleIds
				  , ApproveSubject
				  ,ApproveMessage
				
		     FROM CustomApplication CA
			      INNER JOIN [CustomApplicationForms] CAF ON CAF.CustomApplicationId = CA.Id
			 WHERE CA.CompanyId = @CompanyId
			       AND (@CustomApplicationId IS NULL OR CA.Id = @CustomApplicationId)
				   AND (@CustomApplicationName IS NULL OR CA.CustomApplicationName = @CustomApplicationName)
				   AND (@GenericFormId IS NULL OR CAF.GenericFormId = @GenericFormId)
				   AND (@SearchText IS NULL OR CA.CustomApplicationName = @SearchText)
				   AND ((@IsArchived = 1 AND CA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CA.InActiveDateTime IS NULL))
			 ORDER BY CA.CustomApplicationName

				   OFFSET ((@PageNumber - 1) * @PageSize) ROWS

				   FETCH NEXT @PageSize ROWS ONLY
				   ) T 
		  FOR JSON PATH) 

		 SELECT @JSONVALUE

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