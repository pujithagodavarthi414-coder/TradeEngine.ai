	-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To Save or update the Custom Widget
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_CustomWidgetNameValidator] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CustomWidgetName = 'Sample  Workspace'
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_CustomWidgetNameValidator]
(
   @CustomWidgetId UNIQUEIDENTIFIER = NULL,
   @CustomWidgetName NVARCHAR(800)  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@CustomWidgetId = '00000000-0000-0000-0000-000000000000') SET @CustomWidgetId = NULL

		IF(@CustomWidgetName = '') SET @CustomWidgetName = NULL

	    IF(@CustomWidgetName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CustomWidgetName')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @WidgetsCount INT = (SELECT COUNT(1) FROM CustomWidgets WHERE CustomWidgetName = @CustomWidgetName AND (@CustomWidgetId IS NULL OR Id <> @CustomWidgetId ) AND CompanyId = @CompanyId)

			IF(@WidgetsCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'CustomWidget')
			END	
			ELSE 
			BEGIN
				PRINT 1
			END
	    END
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO