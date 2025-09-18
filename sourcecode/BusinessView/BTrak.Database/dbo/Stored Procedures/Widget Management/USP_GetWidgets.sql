-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Get Widgets
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtW., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetWidgets] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetWidgets]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@WidgetId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
    @WidgetName NVARCHAR(250) = NULL,
	@IsExport BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL

		   IF(@WidgetName = '') SET @WidgetName = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@IsArchived IS NULL)SET @IsArchived = 0

		   IF(@WidgetId = '00000000-0000-0000-0000-000000000000') SET @WidgetId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
           DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		   DECLARE @EnableBugs BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

       	         DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

			  SELECT WidgetId
		          INTO #Widgets
		          FROM  WidgetModuleConfiguration WMC WHERE  WMC.InActiveDateTime IS NULL 
		              AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId
		              AND InActiveDateTime IS NULL AND  IsActive= 1) AND WidgetId IN (SELECT Id FROM Widget WHERE CompanyId = @CompanyId)

           SELECT W.Id AS WidgetId,
		   	      W.CompanyId, 				   
				  RoleIds = (STUFF((SELECT ',' + LOWER(CAST(WRC.RoleId AS NVARCHAR(MAX))) [text()]
				  FROM WidgetRoleConfiguration WRC 
				  WHERE W.Id = WRC.WidgetId  
						AND WRC.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),				   
				  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				  FROM WidgetRoleConfiguration WRC 
						INNER JOIN [Role] R ON R.Id = WRC.RoleId 
						AND WRC.InActiveDateTime IS NULL 
						AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
 				  WHERE  W.Id = WRC.WidgetId
				  ORDER BY R.RoleName ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
		   	      W.WidgetName,
		   	      W.Description,
		   	      W.InActiveDateTime,
		   	      W.CreatedDateTime,
		   	      W.CreatedByUserId,
		   	      W.[TimeStamp],
				  Tags = (STUFF((SELECT ',' + T.TagName [text()]
				  FROM  [CustomTags] CT 
						INNER JOIN [Tags]T ON T.Id = CT.TagId
						AND W.CompanyId = @CompanyId
 				  WHERE  W.Id = CT.ReferenceId
				  GROUP BY T.TagName,T.[Order]
				  ORDER BY T.[order] ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				--  CT.Tags,
				  @IsArchived IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Widget AS W INNER JOIN	#Widgets  D ON D.WidgetId = W.Id AnD W.InActiveDateTime IS NULL
           WHERE W.CompanyId = @CompanyId
		      -- AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
		       AND (@SearchText IS NULL OR (W.WidgetName LIKE @SearchText))
		   	   AND (@WidgetId IS NULL OR W.Id = @WidgetId)
			   AND (@WidgetName IS NULL OR W.WidgetName = @WidgetName)
			   AND (@EnableSprints = 1 OR ((@EnableSprints = 0 OR @EnableSprints IS NULL) AND W.WidgetName NOT IN ('Sprint replan history','Sprint activity','Sprint bug report')))
			   AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND WidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',
			  'QA created and executed test cases','Talko2  file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',
			  'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
			  AND (@EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND W.WidgetName NOT IN ('Bug priority','Bug priority','Sprint bug report')))
			  AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
		   ORDER BY W.WidgetName ASC

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