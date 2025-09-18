-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Save or update the Workspace
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWorkspace] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @WorkspaceId= 'fd3aa09f-5bfa-4c19-b8e9-962e994c23ec', @WorkspaceName='868',@IsArchived = 1
---------------------------------------------------------------------------------------------------------------------------------------


Create PROCEDURE [dbo].[USP_UpsertWorkspace]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @WorkspaceName NVARCHAR(250)  = NULL,
   @Description NVARCHAR(500) = NULL,
   @RoleIds NVARCHAR(MAX) = NULL,
   @EditRoles NVARCHAR(MAX) = NULL,
   @DeleteRoles NVARCHAR(MAX) = NULL,
   @IsHidden BIT = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsCustomizedFor NVARCHAR(250)  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsListView BIT = NULL,
   @MenuItemId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WorkspaceName = '') SET @WorkspaceName = NULL

		IF(@IsHidden IS NULL) SET @IsHidden = 0

		IF(@IsCustomizedFor = '') SET @IsCustomizedFor = NULL

	    IF(@WorkspaceName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'WorkspaceName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @WorkspaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @WorkspaceId AND CompanyId = @CompanyId)

		DECLARE @WorkspaceNameCount INT = (SELECT COUNT(1) FROM Workspace WHERE WorkspaceName = @WorkspaceName AND (Id <> @WorkspaceId OR @WorkspaceId IS NULL) AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND @IsHidden IS NULL)

		 IF(@WorkspaceNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Workspace')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			DECLARE @CanHide BIT = (CASE WHEN EXISTS(SELECT Id FROM RoleFeature WHERE FeatureId = '9E47F20C-73BF-43DE-B044-B8FB48CF3B33' AND 
											 RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND InActiveDateTime IS NULL)
												THEN 1 ELSE 0 END)
			SET @HavePermission ='1' -- (SELECT CASE WHEN (@WorkspaceId IS NULL OR @CanHide = 1 OR ((SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId]((SELECT EditRoles FROM DashboardConfiguration WHERE DashboardId = @WorkspaceId),@OperationsPerformedBy)) > 0))  AND @HavePermission = '1' THEN '1' ELSE '0' END)
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @WorkspaceId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Workspace WHERE Id = @WorkspaceId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			       IF(@WorkspaceId IS NULL)
				   BEGIN

				    SET @WorkspaceId = NEWID()

			        INSERT INTO [dbo].Workspace(
			                    [Id],
			                    [WorkspaceName],
								[Description],
								[IsHidden],
								[IsCustomizedFor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId,
								[IsListView],
								[MenuItemId]
								)
			             SELECT @WorkspaceId,
			                    @WorkspaceName,
								@Description,
								@IsHidden,
								@IsCustomizedFor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId,
								@IsListView,
								@MenuItemId

							IF(@IsCustomizedFor IS NULL)
							BEGIN
							DECLARE @DashboardConfigurationId UNIQUEIDENTIFIER = NEWID()
		
							INSERT INTO [dbo].[DashboardConfiguration](
										[Id],
										[DashboardId],
										[ViewRoles],
										[EditRoles],
										[DeleteRoles],
										[CompanyId],
										[CreatedDateTime],
										[CreatedByUserId]
										)
							SELECT @DashboardConfigurationId,
									@WorkspaceId,
									@RoleIds,
									@EditRoles,
									@DeleteRoles,
									@CompanyId,
									@Currentdate,
									@OperationsPerformedBy
						   END

					END
					ELSE
					BEGIN

				       	UPDATE [dbo].Workspace
			             SET    [WorkspaceName] = @WorkspaceName,
								[Description] = @Description,
 								[IsHidden] = @IsHidden,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END, 
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy,
								CompanyId = @CompanyId,
								[IsListView] = @IsListView
							WHERE Id = @WorkspaceId

					END

					IF(@IsArchived IS NULL OR @IsArchived = 0)
					BEGIN

					DECLARE @DashboardRecords INT = (SELECT COUNT(1) FROM DashboardConfiguration WHERE DashboardId = @WorkspaceId AND CompanyId = @CompanyId)
			       
					IF(@DashboardRecords = 0 AND @IsCustomizedFor IS NULL)
					BEGIN

						INSERT INTO [dbo].DashboardConfiguration(
			                    [Id],
			                    [DashboardId],
								[ViewRoles],
								[CompanyId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT NEWID(),
                              @WorkspaceId, 
                              @RoleIds,
							  @CompanyId,
							  @Currentdate,
                              @OperationsPerformedBy
					END

					ELSE
						UPDATE [dbo].DashboardConfiguration SET ViewRoles = @RoleIds,
																EditRoles = @EditRoles,
																DeleteRoles = @DeleteRoles,
																UpdatedDateTime = @Currentdate,
																UpdatedByUserId = @OperationsPerformedBy
						WHERE DashboardId = @WorkspaceId AND CompanyId = @CompanyId
					END
                   
					SELECT Id FROM [dbo].Workspace WHERE Id = @WorkspaceId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
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