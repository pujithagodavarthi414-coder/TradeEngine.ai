
-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Save a Dashboard
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_InsertDashboard] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WidgetContent='Test',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_InsertDashboard]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @WidgetContent XML  = NULL,
   @IsFromImport BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL

		IF(@IsFromImport IS NULL)SET @IsFromImport = 0

	    IF(@WidgetContent IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Widget Content')

		END

		ELSE IF(@WorkspaceId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Workspace Id')

		END

		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @WorkSpaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId)

		DECLARE @TabsCount INT = (SELECT COUNT(1) FROM DynamicTab WHERE Id = @WorkspaceId AND InActiveDateTime IS NULL)

		IF(@WorkSpaceIdCount = 0 AND @WorkspaceId IS NOT NULL AND @TabsCount =0)
		BEGIN
			RAISERROR(50002,16, 1,'Workspace')
		END

		ELSE
		BEGIN
		
			DECLARE @HavePermission NVARCHAR(250)  ='1' -- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
					
					DECLARE @NewDashboardId UNIQUEIDENTIFIER = NEWID();

					DECLARE @NewPersitanceId UNIQUEIDENTIFIER = NEWID();

					DECLARE @PersistanceWidgetId UNIQUEIDENTIFIER = NULL

					SET @PersistanceWidgetId = (SELECT RTRIM(LTRIM([Table].[Column].value('(CustomWidgetId/text())[1]', 'UNIQUEIDENTIFIER'))) 
													FROM @WidgetContent.nodes('/ArrayOfDashboardModel/DashboardModel') AS [Table]([Column]))			

					IF(@PersistanceWidgetId IS NOT NULL)
					BEGIN
			
						DECLARE @PersistanceJson NVARCHAR(MAX) = (SELECT [PersistanceJson] FROM Persistance WHERE ReferenceId = @PersistanceWidgetId)

						INSERT INTO Persistance( [Id]
												,[ReferenceId]	  			
												,[PersistanceJson]
												,[IsUserLevel]	  			
												,[CreatedDateTime]	  			
												,[CreatedByUserId])
						VALUES(@NewPersitanceId
								,@NewDashboardId
								,@PersistanceJson
								,0
								,@Currentdate
								,@OperationsPerformedBy)

					END
	
					INSERT INTO WorkspaceDashboards( [Id]
											   ,[WorkspaceId]
											   ,[X]
											   ,[Y]
											   ,[Col]
											   ,[Row]
											   ,[MinItemCols]
											   ,[MinItemRows]
											   ,[Name]
											   ,[Component]
											   ,[CustomAppVisualizationId]
											   ,[CustomWidgetId]
											   ,[IsCustomWidget]
											   ,[CreatedByUserId]
											   ,[CreatedDateTime]
											   ,[CompanyId]
											   ,[ExtraVariableJson]
											   ,[Order]
											   ,[DashboardName]
											   ,[IsDraft])
		  								SELECT RTRIM(LTRIM([Table].[Column].value('DashboardId[1]', 'UNIQUEIDENTIFIER'))),
											   @WorkspaceId,
											   RTRIM(LTRIM([Table].[Column].value('X[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('Y[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('Cols[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('Rows[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('MinItemCols[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('MinItemRows[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('Name[1]', 'NVARCHAR(600)'))),
											   RTRIM(LTRIM([Table].[Column].value('Component[1]', 'NVARCHAR(600)'))),
											   RTRIM(LTRIM([Table].[Column].value('(CustomAppVisualizationId/text())[1]', 'UNIQUEIDENTIFIER'))) ,
											   RTRIM(LTRIM([Table].[Column].value('(CustomWidgetId/text())[1]', 'UNIQUEIDENTIFIER'))),
											   RTRIM(LTRIM([Table].[Column].value('IsCustomWidget[1]', 'BIT'))),
											   @OperationsPerformedBy,
										       @Currentdate,
											   @CompanyId,
											   RTRIM(LTRIM([Table].[Column].value('ExtraVariableJson[1]', 'NVARCHAR(MAX)'))),
											   RTRIM(LTRIM([Table].[Column].value('Order[1]', 'INT'))),
											   RTRIM(LTRIM([Table].[Column].value('DashboardName[1]', 'NVARCHAR(600)'))),
											   CASE WHEN @IsFromImport = 1 THEN 0 ELSE 1 END
						           FROM @WidgetContent.nodes('/ArrayOfDashboardModel/DashboardModel') AS [Table]([Column])
							
							SELECT @NewDashboardId

				END					
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END
	    END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END