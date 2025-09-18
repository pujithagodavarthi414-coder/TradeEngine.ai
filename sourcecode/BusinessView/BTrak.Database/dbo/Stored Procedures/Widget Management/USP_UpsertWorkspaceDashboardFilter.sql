-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-06 00:00:00.000'
-- Purpose      To Save or update the Workspace Dashboard Filter
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWorkspaceDashboardFilter] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FilterJson = '{}',@WorkspaceDashboardId = '8F3CE401-9260-455A-86D4-38B925CEC419'

CREATE PROCEDURE [dbo].[USP_UpsertWorkspaceDashboardFilter]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@WorkspaceDashboardFilterId UNIQUEIDENTIFIER = NULL,
	@WorkspaceDashboardId UNIQUEIDENTIFIER = NULL,
	@FilterJson NVARCHAR(MAX) = NULL,
	@IsCalenderView BIT = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@WorkspaceDashboardFilterId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardFilterId = NULL
		
		IF(@FilterJson = '') SET @FilterJson = NULL

		IF(@IsCalenderView IS NULL) SET @IsCalenderView = 0

		IF(@WorkspaceDashboardId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardId = NULL

		IF(@WorkspaceDashboardId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'WorkspaceDashboardId')

		END
		ELSE
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CurrentDate DATETIME = GETDATE()
			
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN
				
				DECLARE @ExistingRecordCount INT = (SELECT COUNT(1) FROM WorkspaceDashboardFilter WHERE CreatedByUserId = @OperationsPerformedBy AND WorkspaceDashboardId = @WorkspaceDashboardId)

				IF(@ExistingRecordCount = 0)
				BEGIN
					
					SET @WorkspaceDashboardFilterId = NEWID()

					INSERT INTO WorkspaceDashboardFilter(
								[Id]
								,[WorkspaceDashboardId]
								,[FilterJson]
								,[IsCalenderView]
								,[CreatedByUserId]
								,[CreatedDateTime]
								)
						SELECT @WorkspaceDashboardFilterId
						       ,@WorkspaceDashboardId
							   ,@FilterJson
							   ,@IsCalenderView
							   ,@OperationsPerformedBy
							   ,@CurrentDate

				END
				ELSE IF(@ExistingRecordCount = 1)
				BEGIN
						
						UPDATE WorkspaceDashboardFilter
						      SET FilterJson = @FilterJson
								  ,IsCalenderView = @IsCalenderView
								  ,UpdatedByUserId = @OperationsPerformedBy
								  ,UpdatedDateTime = @CurrentDate
							WHERE [WorkspaceDashboardId] = @WorkspaceDashboardId
							      AND CreatedByUserId = @OperationsPerformedBy

				END

				SELECT Id FROM WorkspaceDashboardFilter 
				WHERE [WorkspaceDashboardId] = @WorkspaceDashboardId AND CreatedByUserId = @OperationsPerformedBy

			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END

		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END