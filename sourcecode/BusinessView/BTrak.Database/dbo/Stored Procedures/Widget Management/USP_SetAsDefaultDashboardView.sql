-------------------------------------------------------------------------------
-- Author       Surya Kadiyam
-- Created      '2020-01-06 00:00:00.000'
-- Purpose      To Current user persistance as default
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_SetAsDefaultDashboardView] @OperationsPerformedBy='A9C216B9-9268-47F7-B823-BD8159949E3A',@WorkspaceId ='4c109bb8-171f-4f2e-97fd-7c29119d4813',@IsDefaultView=1

CREATE PROCEDURE [dbo].[USP_SetAsDefaultDashboardView]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsDefaultView BIT = NULL
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
					UPDATE Workspace SET [IsListView] = @IsDefaultView
										,[UpdatedByUserId] = @OperationsPerformedBy
										,[UpdatedDateTime] = @Currentdate
						WHERE Id = @WorkspaceId AND CompanyId = @CompanyId
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
