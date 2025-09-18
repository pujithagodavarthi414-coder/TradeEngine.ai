-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-01-06 00:00:00.000'
-- Purpose      To Current user persistance as default
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_SetAsDefaultDashboardPersistance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkspaceId = ''

CREATE PROCEDURE [dbo].[USP_SetAsDefaultDashboardPersistance]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsListView BIT=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL

		ELSE IF(@WorkspaceId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Workspace Id')

		END

		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @WorkSpaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId)

		IF(@WorkSpaceIdCount = 0 AND @WorkspaceId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Workspace')
		END

		ELSE
		BEGIN
		
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()

					UPDATE WorkspaceDashboards SET InActiveDateTime  = @CurrentDate WHERE IsDraft = 1 AND CreatedByUserId <> @OperationsPerformedBy AND WorkspaceId = @WorkspaceId

					UPDATE WorkspaceDashboards SET 
									   [X] = ISNULL(DP.X,WD.X),
									   [Y] = ISNULL(DP.Y,WD.Y),
									   [Col] = ISNULL(DP.Col,WD.Col),
									   [Row] = ISNULL(DP.Row,WD.Row),
									   [MinItemCols] = ISNULL(DP.MinItemCols,WD.MinItemCols),
									   [MinItemRows] = ISNULL(DP.MinItemRows,WD.MinItemRows),
									   [Order] =  ISNULL(DO.[Order],WD.[Order]),
									   [IsDraft] = 0
 					            FROM WorkspaceDashboards WD 
										LEFT JOIN DashboardPersistance DP ON WD.Id = DP.DashboardId AND WD.WorkspaceId = @WorkspaceId AND WD.InActiveDateTime IS NULL AND DP.CreatedByUserId = @OperationsPerformedBy
										LEFT JOIN DashboardCustomViewOrder DO ON WD.Id = DO.DashboardId AND WD.WorkspaceId = @WorkspaceId AND WD.InActiveDateTime IS NULL

					DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId = @WorkspaceId ) 
					DELETE FROM DashboardCustomViewOrder WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId = @WorkspaceId ) 

					UPDATE [Workspace] SET [IsListView] = @IsListView
										,[UpdatedByUserId] = @OperationsPerformedBy
										,[UpdatedDateTime] = @Currentdate
						WHERE Id = @WorkspaceId AND CompanyId = @CompanyId

					EXEC [dbo].[USP_SetCustomAppPersistanceForUser] @WorkSpaceId = @WorkSpaceId, @IsDefault = 1, @OperationsPerformedBy = @OperationsPerformedBy

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