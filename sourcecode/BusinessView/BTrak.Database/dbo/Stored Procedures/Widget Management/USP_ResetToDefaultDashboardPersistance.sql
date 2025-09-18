-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-01-06 00:00:00.000'
-- Purpose      Reset dashboard persistance to default
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_ResetToDefaultDashboardPersistance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkspaceId = ''

CREATE PROCEDURE [dbo].[USP_ResetToDefaultDashboardPersistance]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
		IF (@HavePermission = '1')
		BEGIN
	
	            IF(@WorkspaceId IS NULL)
		        BEGIN
		           
		            RAISERROR(50011,16, 2, 'Workspace Id')
		        
		        END
		        
		        ELSE
		        BEGIN

					DECLARE @CurrentDate DATETIME = GETDATE()
		        
		        	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		        
		        	DECLARE @WorkSpaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId)
		        
		        	IF(@WorkSpaceIdCount = 0 AND @WorkspaceId IS NOT NULL)
		        	BEGIN
		        		RAISERROR(50002,16, 1,'Workspace')
		        	END
		        
		        	ELSE
		        	BEGIN
						UPDATE WorkspaceDashboards SET InActiveDateTime = @CurrentDate WHERE WorkspaceId = @WorkspaceId AND IsDraft = 1 AND CreatedByUserId = @OperationsPerformedBy AND InActiveDateTime IS NULL
		        		DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId = @WorkspaceId ) 
						DELETE FROM DashboardCustomViewOrder WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId = @WorkspaceId )
						UPDATE [Workspace] SET IsListView = NULL WHERE Id = @WorkspaceId
		        	END
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
GO