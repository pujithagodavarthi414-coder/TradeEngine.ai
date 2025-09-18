-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update the CompanyModule
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCompanyModule]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ModuleId='5D48C02F-D270-43E6-81AD-11E3F630DB00',@IsActive=1,@CompanyModuleId='71F7294B-E9AC-4FEB-A193-D6B761AEF399'

CREATE PROCEDURE [dbo].[USP_UpsertCompanyModule]
(
    @CompanyModuleId UNIQUEIDENTIFIER = NULL,
    @ModuleIdXml XML = NULL, 
    @IsActive BIT = 1,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@IsEnabled BIT = NULL,
	@IsFromSupportUser BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	        
            IF (@HavePermission = '1')
            BEGIN

			    DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                           FROM CompanyModule WHERE Id = @CompanyModuleId ) = @TimeStamp
                                     THEN 1 ELSE 0 END)

				     DECLARE @CurrentDate DATETIME = GETDATE()
	            
                     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				     
					  DECLARE @WidgetRoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] where RoleName like '%super admin%' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL)

                     IF(@CompanyModuleId IS NULL)
					 BEGIN

					 CREATE TABLE #Modules 
					 (  
					   ModuleId UNIQUEIDENTIFIER,
					 )

                   INSERT INTO #Modules(ModuleId)
				   SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				   FROM @ModuleIdXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
				   IF(@IsFromSupportUser IS NULL OR @IsFromSupportUser = 0)
				   BEGIN
					 
					 UPDATE [CompanyModule]
						    SET IsActive        = 1,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy
								FROM Module M WHERE M.Id = CompanyModule.ModuleId  AND ISNULL(M.IsSystemModule,0) = 0
								AND ModuleId IN (SELECT ModuleId FROM #Modules) AND CompanyId = @CompanyId

					UPDATE [CompanyModule]
						    SET IsActive        = 0,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy
									FROM Module M WHERE M.Id = CompanyModule.ModuleId AND ISNULL(M.IsSystemModule,0) = 0
								      AND ModuleId NOT IN (SELECT ModuleId FROM #Modules) AND CompanyId = @CompanyId
								
				   END
				   ELSE
				   BEGIN
				   UPDATE [CompanyModule]
						    SET IsEnabled        = 1,
								IsActive		=1,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy
								FROM Module M WHERE M.Id = CompanyModule.ModuleId  AND ISNULL(M.IsSystemModule,0) = 0
								AND ModuleId IN (SELECT ModuleId FROM #Modules) AND CompanyId = @CompanyId

					UPDATE [CompanyModule]
						    SET IsEnabled        = 0,
								IsActive        = 0,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy
								FROM Module M WHERE M.Id = CompanyModule.ModuleId AND ISNULL(M.IsSystemModule,0) = 0
								      AND ModuleId NOT IN (SELECT ModuleId FROM #Modules) AND CompanyId = @CompanyId
				   END
				   
				     INSERT INTO [dbo].[WidgetRoleConfiguration] ([Id], [WidgetId], [RoleId], [CreatedDateTime],[CreatedByUserId])
                     SELECT NEWID(),W.Id,@WidgetRoleId,GETDATE(),@OperationsPerformedBy 
                      FROM [dbo].[Widget] W LEFT JOIN WidgetRoleConfiguration WR ON W.Id = WR.WidgetId AND WR.InActiveDateTime IS NULL AND WR.RoleId = @WidgetRoleId
					   WHERE W.CompanyId = @CompanyId AND W.InActiveDateTime IS NULL AND WR.Id IS NULL
						       AND W.Id IN (SELECT WidgetId FROM Widget W INNER JOIN WidgetModuleConfiguration WM ON W.Id = WM.WidgetId 
						                                                         AND WM.InActiveDateTime IS NULL AND W.InActiveDateTime IS NULL AND W.CompanyId = @CompanyId
						                                                  INNER JOIN #Modules M ON M.ModuleId = WM.ModuleId)
					
					UPDATE  WidgetRoleConfiguration SET InActiveDateTime = @CurrentDate WHERE WidgetId IN (
					 SELECT W.Id FROM Widget W INNER JOIN WidgetModuleConfiguration WM ON W.Id= WM.WidgetId AND WM.InActiveDateTime IS NULL AND W.InActiveDateTime IS NULL
					    AND W.CompanyId = @CompanyId
						WHERE ModuleId NOT IN (SELECT ModuleId FROM #Modules))

					 INSERT INTO [dbo].[CustomWidgetRoleConfiguration] ([Id], [CustomWidgetId], [RoleId], [CreatedDateTime],[CreatedByUserId])
                     SELECT NEWID(),W.Id,@WidgetRoleId,GETDATE(),@OperationsPerformedBy 
                      FROM [dbo].CustomWidgets W LEFT JOIN CustomWidgetRoleConfiguration WR ON W.Id = WR.CustomWidgetId AND WR.InActiveDateTime IS NULL AND WR.RoleId = @WidgetRoleId
					   WHERE W.CompanyId = @CompanyId AND W.InActiveDateTime IS NULL AND WR.Id IS NULL
						       AND W.Id IN (SELECT WidgetId FROM CustomWidgets W INNER JOIN WidgetModuleConfiguration WM ON W.Id = WM.WidgetId 
						                                                         AND WM.InActiveDateTime IS NULL AND W.InActiveDateTime IS NULL AND W.CompanyId = @CompanyId
						                                                  INNER JOIN #Modules M ON M.ModuleId = WM.ModuleId)
					
					UPDATE CustomWidgetRoleConfiguration SET InActiveDateTime = @CurrentDate WHERE CustomWidgetId IN (
					 SELECT W.Id FROM CustomWidgets W INNER JOIN WidgetModuleConfiguration WM ON W.Id= WM.WidgetId AND WM.InActiveDateTime IS NULL AND W.InActiveDateTime IS NULL
					    AND W.CompanyId = @CompanyId
						WHERE ModuleId NOT IN (SELECT ModuleId FROM #Modules)) AND InActiveDateTime IS NULL
							
							DECLARE @RolEId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] where RoleName like '%superadmin%' AND CompanyId = @CompanyId)

								 IF(@RolEId IS NOT NULL)
								 BEGIN

										DELETE RF FROM RoleFeature RF
                                       INNER JOIN FeatureModule FM ON FM.FeatureId = RF.FeatureId
                                       INNER JOIN Module M On M.Id = FM.ModuleId AND M.IsSystemModule <> 1
                                       INNER JOIN CompanyModule CM ON CM.ModuleId = M.Id AND CM.CompanyId = @CompanyId
									   INNER JOIN [Role]R ON R.Id = RF.RoleId  AND (ISNULL(R.IsHidden,0) = 0)
										WHERE RoleId = @RolEId

									INSERT INTO [dbo].[RoleFeature](
									         [Id],
									         [RoleId],
									         [FeatureId],
									         [CreatedDateTime],
									         [CreatedByUserId]
									         )
									  SELECT NEWID(),
									         @RolEId,
									         FeatureId,
									         @Currentdate,
									         @OperationsPerformedBy 
									FROM (SELECT FeatureId FROM FeatureModule WHERE ModuleId IN (SELECT ModuleId FROM #Modules) GROUP BY FeatureId) T

			       				  END

								  SET @RolEId = (SELECT Id FROM [Role] where RoleName like '%ceo%' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL)

								 IF(@RolEId IS NOT NULL)
								 BEGIN
									DELETE RF FROM RoleFeature RF
                                       INNER JOIN FeatureModule FM ON FM.FeatureId = RF.FeatureId
                                       INNER JOIN Module M On M.Id = FM.ModuleId AND M.IsSystemModule <> 1
                                       INNER JOIN CompanyModule CM ON CM.ModuleId = M.Id AND CM.CompanyId = @CompanyId
									   INNER JOIN [Role]R ON R.Id = RF.RoleId  AND (ISNULL(R.IsHidden,0) = 0)
								    WHERE RoleId = @RolEId

									INSERT INTO [dbo].[RoleFeature](
									         [Id],
									         [RoleId],
									         [FeatureId],
									         [CreatedDateTime],
									         [CreatedByUserId]
									         )
									  SELECT NEWID(),
									         @RolEId,
									         FeatureId,
									         @Currentdate,
									         @OperationsPerformedBy 
											 FROM (SELECT FeatureId FROM FeatureModule WHERE ModuleId IN (SELECT ModuleId FROM #Modules) GROUP BY FeatureId) T
			       				  END

						SELECT Id FROM [dbo].[CompanyModule] WHERE CompanyId = @CompanyId
                             
						END
						ELSE
						BEGIN

						UPDATE [CompanyModule]
						    SET CompanyId       = @CompanyId,
							   -- ModuleId        = @ModuleId,
								IsActive        = @IsActive,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy,
								IsEnabled = @IsEnabled
								WHERE Id = @CompanyModuleId 

								SELECT  Id FROM [dbo].[CompanyModule] WHERE Id = @CompanyModuleId
						END
	        END
	        ELSE
	        BEGIN
	        
	            RAISERROR (@HavePermission,11, 1)
	        
	        END
    END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END