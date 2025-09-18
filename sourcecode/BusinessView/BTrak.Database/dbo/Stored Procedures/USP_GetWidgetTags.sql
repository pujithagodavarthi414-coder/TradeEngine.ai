CREATE PROCEDURE [dbo].[USP_GetWidgetTags]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsFromSearch BIT = NULL
)
AS
BEGIN
 SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@IsFromSearch IS NULL) SET @IsFromSearch = 0
		
		IF (@HavePermission = '1')
	    BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		    CREATE TABLE #RoleIds 
		    (
			 	UserRoleId UNIQUEIDENTIFIER
		    )
		    
		    INSERT INTO #RoleIds(UserRoleId)
		    SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)

			 DECLARE @IsSupport BIT = (CASE WHEN EXISTS(SELECT RoleId FROM UserRole UR INNER JOIN [Role]R ON R.Id = UR.RoleId AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL AND R.IsHidden = 1 WHERE  UR.UserId = @OperationsPerformedBy)   THEN 1 ELSE 0 END)
			
			SELECT Tags,ParentTagId,TagId,ROW_NUMBER() OVER(ORDER BY [Order] DESC,T.Tags DESC) RowNumber 
			FROM (
				SELECT T.TagName Tags, T.ParentTagId, T.Id AS TagId ,ISNULL(ISNULL(UT.[Order],T.[Order]),1)[Order] 
				FROM Tags T 
					 INNER JOIN CustomTags CT ON CT.TagId = T.Id
					 INNER JOIN (
					              SELECT W.Id WidgetId 
					              FROM  Widget W  INNER JOIN WidgetModuleConfiguration WMC ON WMC.WidgetId = W.Id AND W.CompanyId = @CompanyId AND WMC.InActiveDateTime IS NULL AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))
								  LEFT JOIN(SELECT WidgetId FROM WidgetRoleConfiguration WRC INNER JOIN #RoleIds R ON R.UserRoleId = WRC.RoleId AND WRC.Inactivedatetime IS NULL)WR ON W.Id = WR.WidgetId
			                      WHERE (@IsSupport = 1 OR WR.WidgetId IS NOT NULL) AND W.Inactivedatetime IS NULL
					              GROUP BY W.Id
					            	UNION 
					            	SELECT W.Id AS WidgetId
					               FROM  CustomWidgets W 
									   INNER JOIN WidgetModuleConfiguration WMC ON WMC.WidgetId = W.Id  AND W.CompanyId = @CompanyId AND WMC.InActiveDateTime IS NULL AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))
								       LEFT JOIN (SELECT CustomWidgetId FROM CustomWidgetRoleConfiguration CWRC 
					                                    INNER JOIN #RoleIds R ON R.UserRoleId = CWRC.RoleId AND CWRC.Inactivedatetime IS NULL)WR ON WR.CustomWidgetId = W.Id
					                  WHERE (@IsSupport = 1 OR WR.CustomWidgetId IS NOT NULL) AND W.Inactivedatetime IS NULL
					              GROUP BY W.Id
					            	UNION
					            	SELECT WH.Id AS WidgetId
					              FROM CustomHtmlApp WH INNER JOIN WidgetModuleConfiguration WMC ON WMC.WidgetId = WH.Id AND WH.CompanyId = @CompanyId AND WMC.InActiveDateTime IS NULL AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))
								                        LEFT JOIN (SELECT CustomHtmlAppId FROM CustomHtmlAppRoleConfiguration CHRC 
					                                             INNER JOIN #RoleIds R ON R.UserRoleId = CHRC.RoleId AND CHRC.Inactivedatetime IS NULL)WR ON WR.CustomHtmlAppId = WH.Id
					                 WHERE (@IsSupport = 1 OR WR.CustomHtmlAppId IS NOT NULL) AND WH.Inactivedatetime IS NULL
									 GROUP BY WH.Id
					            	UNION
					            	SELECT CA.Id AS WidgetId
					              FROM CustomApplication CA INNER JOIN WidgetModuleConfiguration WMC ON WMC.WidgetId = CA.Id AND WMC.InActiveDateTime IS NULL AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))
					                        	            LEFT JOIN (SELECT CustomApplicationId FROM CustomApplicationRoleConfiguration CARC 
					                                                      INNER JOIN #RoleIds R ON R.UserRoleId = CARC.RoleId )WR ON WR.CustomApplicationId = CA.Id
					              WHERE (@IsSupport = 1 OR WR.CustomApplicationId IS NOT NULL) AND CA.Inactivedatetime IS NULL 
								   GROUP BY CA.Id
					             ) WR ON WR.WidgetId = CT.ReferenceId
					  LEFT JOIN UserTags UT ON UT.TagId = CT.TagId AND UT.UserId = @OperationsPerformedBy
					  WHERE T.CompanyId = @CompanyId AND T.InActiveDateTime IS NULL
					        AND ((@IsFromSearch = 1 AND ParentTagId IS NULL) OR (@IsFromSearch = 0))
					  GROUP BY T.TagName,T.ParentTagId, T.Id, UT.[Order],T.[Order]
			 ) T
			 UNION
			 SELECT TagName AS Tags,OT.ParentTagId,OT.Id,0
			 FROM Tags OT
			 WHERE OT.CompanyId = @CompanyId AND OT.TagName = 'Other'
			 ORDER BY RowNumber DESC

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
GO