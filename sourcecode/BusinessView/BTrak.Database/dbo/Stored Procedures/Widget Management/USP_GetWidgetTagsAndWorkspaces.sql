-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-24 00:00:00.000'
-- Purpose      To Get Widgets
-- Copyright © 2020,Snovasys Software Solutions India Pvt. LtW., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetWidgetTagsAndWorkspaces] @OperationsPerformedBy ='8248E42D-9BB9-492A-A093-5DCE2C5DED97'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetWidgetTagsAndWorkspaces]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@WidgetDetailsXML XML = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
			
			IF(@WidgetDetailsXML IS NOT NULL)
			BEGIN
				
				CREATE TABLE #WidgetDetails
				(
					WidgetId UNIQUEIDENTIFIER
					,IsCustomWidget BIT --0 for system widgets
					,IsHtml BIT
					,IsProcess BIT
				)

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				INSERT INTO #WidgetDetails(WidgetId,IsCustomWidget,IsHtml,IsProcess)
				SELECT	x.value('WidgetId[1]','UNIQUEIDENTIFIER')
				        ,x.value('IsCustomWidget[1]','BIT')
						,x.value('IsHtml[1]','BIT')
						,x.value('IsProcess[1]','BIT')
				FROM  @WidgetDetailsXML.nodes('/ArrayOfWidgetTagsAndWorkspaceModel/WidgetTagsAndWorkspaceModel') XmlData(x)

				SELECT W.WidgetId
				   ,WidgetTags = (SELECT T.Id AS TagId
								         ,T.TagName
								  FROM CustomTags CT
			  				 	   	INNER JOIN Tags T ON CT.ReferenceId = W.WidgetId AND CT.TagId = T.Id 
			   				      WHERE  CT.ReferenceId = W.WidgetId AND T.InActiveDateTime IS NULL
							      ORDER BY T.[Order]
								  FOR JSON PATH
								)
					,WidgetWorkSpaces =  (STUFF((SELECT ',' + WS.WorkspaceName [text()]
                                    FROM WorkspaceDashboards WD
                                    INNER JOIN WorkSpace WS ON WS.Id = WD.WorkspaceId
                                    WHERE  WD.[Name] = ISNULL(SW.WidgetName,CW.CustomWidgetName) AND WD.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL AND WS.IsCustomizedFor IS NULL
                                    GROUP BY WS.WorkspaceName
                                    ORDER BY WS.WorkspaceName
                                   FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
					FW.IsFavourite IsFavouriteWidget
               FROM #WidgetDetails W
			        LEFT JOIN Widget SW ON SW.Id = W.WidgetId AND W.IsCustomWidget = 0 AND W.IsHtml = 0 AND W.IsProcess = 0
			        LEFT JOIN CustomWidgets CW ON CW.Id = W.WidgetId AND W.IsCustomWidget = 1
					LEFT JOIN  FavouriteWidgets FW ON FW.WidgetId = W.WidgetId AND FW.CreatedByUserId = @OperationsPerformedBy

			END

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