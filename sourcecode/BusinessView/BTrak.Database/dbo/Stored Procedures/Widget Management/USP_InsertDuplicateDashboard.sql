
-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-01-21 00:00:00.000'
-- Purpose      To Save a the duplicate dashbaord
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_InsertDuplicateDashboard] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkspaceId='836a5645-0a69-4d10-a753-755d97f78dcc',@WorkspaceName='Testmahesh'

CREATE PROCEDURE [dbo].[USP_InsertDuplicateDashboard]
(
   @WorkspaceName NVARCHAR(250) = NULL,
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL

	    IF(@WorkspaceName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Workspace name')

		END

		ELSE IF(@WorkspaceId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Workspace Id')

		END

		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @WorkSpaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

		DECLARE @WorkspaceNameCount INT = (SELECT COUNT(1) FROM Workspace WHERE WorkspaceName = @WorkspaceName AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

		IF(@WorkSpaceIdCount = 0 AND @WorkspaceId IS NOT NULL)
		BEGIN
			
			RAISERROR(50002,16, 1,'Workspace')
		
		END
		ELSE IF(@WorkspaceNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Workspace')

		END		
		ELSE
		BEGIN
		
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @Description NVARCHAR(250) = (SELECT Description FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
					
					DECLARE @NewWorkspaceId UNIQUEIDENTIFIER = NEWID();

					        INSERT INTO [dbo].Workspace(
			                            [Id],
			                            [WorkspaceName],
										[Description],
										[IsHidden],
			                            [CreatedDateTime],
			                            [CreatedByUserId],
					        			CompanyId)
			                     SELECT @NewWorkspaceId,
			                            @WorkspaceName,
										@Description,
										0,
			                            @Currentdate,
			                            @OperationsPerformedBy,
					        			@CompanyId
					        			FROM Workspace 
					        			WHERE Id = @WorkspaceId

				            INSERT INTO [dbo].DashboardConfiguration(
			                            [Id],
			                            [DashboardId],
					        			[ViewRoles],
										[DefaultDashboardRoles],
										[EditRoles],
										[DeleteRoles],
					        			[CompanyId],
			                            [CreatedDateTime],
			                            [CreatedByUserId]
			                            )
                                 SELECT NEWID(),
                                       @NewWorkspaceId, 
                                       D.ViewRoles,
									   D.DefaultDashboardRoles,
									   D.EditRoles,
									   D.DeleteRoles,
					        		   @CompanyId,
					        		   @Currentdate,
                                       @OperationsPerformedBy
					        		   FROM DashboardConfiguration D
					        		   WHERE DashboardId = @WorkspaceId 

					       INSERT INTO WorkspaceDashboards( 
					                   [Id]
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
									  ,IsDraft
									  )
		  					  SELECT NEWID()
									 ,@NewWorkspaceId
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[X] ELSE W.[X] END
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[Y] ELSE W.[Y] END
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[Col] ELSE W.[Col] END
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[Row] ELSE W.[Row] END
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[MinItemCols] ELSE W.MinItemCols END
									 ,CASE WHEN DP.DashboardId IS NOT NULL THEN  DP.[MinItemRows] ELSE W.MinItemRows END
									 ,[Name]
									 ,[Component]
									 ,[CustomAppVisualizationId]
									 ,[CustomWidgetId]
									 ,[IsCustomWidget]
									 ,@OperationsPerformedBy
									 ,@Currentdate
									 ,@CompanyId
									 ,W.IsDraft
							    FROM WorkspaceDashboards W LEFT JOIN [DashboardPersistance]DP ON DP.DashboardId = W.Id AND DP.CreatedByUserId = @OperationsPerformedBy 
								WHERE W.WorkspaceId = @WorkspaceId AND InActiveDateTime IS NULL
							

							SELECT Id FROM WORKSPACE WHERE Id = @NewWorkspaceId

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