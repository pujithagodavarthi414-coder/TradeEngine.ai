
-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Save or update the Dashboard
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpdateDashboard] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WidgetContent='Test',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpdateDashboard]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @WidgetContent XML  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN TRY

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL

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

		IF(@WorkSpaceIdCount = 0 AND @WorkspaceId IS NOT NULL AND @TabsCount = 0)
		BEGIN
			RAISERROR(50002,16, 1,'Workspace')
		END

		ELSE
		BEGIN
		
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @WorkspaceDashboards TABLE
					(
					    DashboardId UNIQUEIDENTIFIER NULL,
						[X] INT,
						[Y] INT,
						[Col] INT,
						[Row] INT,
						[MinItemCols] INT,
						[MinItemRows] INT,
						[Name] NVARCHAR(500),
						[IsDraft] BIT NULL,
						[Component] NVARCHAR(500),
						[CustomAppVisualizationId] UNIQUEIDENTIFIER NULL,
						[CustomWidgetId] UNIQUEIDENTIFIER NULL,
						[IsCustomWidget] BIT,
						IsArchived BIT,
						XCoOrdinate NVARCHAR(100),
						YCoOrdinate NVARCHAR(100),
						ExtraVariableJson NVARCHAR(MAX)
					)

					INSERT INTO @WorkspaceDashboards (DashboardId,[X],[Y],[Col],[Row],[MinItemCols],[MinItemRows],[Name],[IsDraft],[Component],IsArchived,[CustomAppVisualizationId],[CustomWidgetId],[IsCustomWidget],XCoOrdinate,YCoOrdinate,ExtraVariableJson)
					SELECT RTRIM(LTRIM([Table].[Column].value('DashboardId[1]', 'UNIQUEIDENTIFIER'))),
					       RTRIM(LTRIM([Table].[Column].value('X[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('Y[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('Cols[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('Rows[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('MinItemCols[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('MinItemRows[1]', 'INT'))),
						   RTRIM(LTRIM([Table].[Column].value('Name[1]', 'NVARCHAR(600)'))),
						   RTRIM(LTRIM([Table].[Column].value('IsDraft[1]', 'NVARCHAR(600)'))),
						   RTRIM(LTRIM([Table].[Column].value('Component[1]', 'NVARCHAR(600)'))),
						   RTRIM(LTRIM([Table].[Column].value('IsArchived[1]', 'BIT'))),
						   RTRIM(LTRIM([Table].[Column].value('(CustomAppVisualizationId/text())[1]', 'UNIQUEIDENTIFIER'))),
						   RTRIM(LTRIM([Table].[Column].value('(CustomWidgetId/text())[1]', 'UNIQUEIDENTIFIER'))),
						   RTRIM(LTRIM([Table].[Column].value('IsCustomWidget[1]', 'BIT'))),
						   RTRIM(LTRIM([Table].[Column].value('XCoOrdinate[1]', 'NVARCHAR(100)'))),
						   RTRIM(LTRIM([Table].[Column].value('YCoOrdinate[1]', 'NVARCHAR(100)'))),
                           RTRIM(LTRIM([Table].[Column].value('ExtraVariableJson[1]', 'NVARCHAR(MAX)')))

						FROM @WidgetContent.nodes('/ArrayOfDashboardModel/DashboardModel') AS [Table]([Column])

						UPDATE WorkspaceDashboards SET 
										   [Name] =  WD.[Name],
										   [Component] =  WD.[Component],
										   [InactiveDateTime] = CASE WHEN IsArchived = 1 THEN @Currentdate ELSE NULL END,
										   [CustomWidgetId] =  WD.[CustomWidgetId],
										   [IsCustomWidget] =  WD.[IsCustomWidget],
										   [CustomAppVisualizationId] = WD.[CustomAppVisualizationId],
										   [IsDraft] = CASE WHEN IsArchived = 1 THEN 0 ELSE WD.[IsDraft] END,
										   [ExtraVariableJson] = WD.[ExtraVariableJson]
 					                FROM [dbo].WorkspaceDashboards WSD
									      INNER JOIN @WorkspaceDashboards WD ON WD.DashboardId = WSD.Id
									                AND WSD.WorkspaceId = @WorkspaceId AND WSD.InActiveDateTime IS NULL AND WD.DashboardId IS NOT NULL

						DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT DashboardId From @WorkspaceDashboards) AND CreatedByUserId = @OperationsPerformedBy

						INSERT INTO DashboardPersistance( [Id],
												          X,		
													      Y,
													      Col,		
													      [Row],  			
														  MinItemRows,
														  MinItemCols,
														  DashboardId,
														  CreatedByUserId,
														  CreatedDateTime)
												   SELECT NEWID(),
														  WD.X,
														  WD.Y,
														  WD.Col,
														  WD.[Row],
														  WD.MinItemRows,
														  WD.MinItemCols,
														  WD.DashboardId,
														  @OperationsPerformedBy,
														  @Currentdate
														  FROM @WorkspaceDashboards WD

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
GO