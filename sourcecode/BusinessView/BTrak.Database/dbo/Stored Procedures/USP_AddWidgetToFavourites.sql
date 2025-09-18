CREATE PROCEDURE [dbo].[USP_AddWidgetToFavourites]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @WidgetId UNIQUEIDENTIFIER = NULL,
 @IsFavouriteWidget BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

			IF(@IsFavouriteWidget IS NULL) SET @IsFavouriteWidget = 0

			IF(@WidgetId IS NOT NULL)
			BEGIN
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))	
			
			IF EXISTS(SELECT * FROM FavouriteWidgets WHERE CompanyId = @CompanyId AND WidgetId = @WidgetId AND CreatedByUserId = @OperationsPerformedBy)
			BEGIN
				UPDATE [dbo].[FavouriteWidgets]
					SET IsFavourite = @IsFavouriteWidget,
						UpdatedDateTime = GETDATE(),
						UpdatedByUserId = @OperationsPerformedBy
						WHERE CompanyId = @CompanyId AND WidgetId = @WidgetId 
						SELECT WidgetId FROM FavouriteWidgets WHERE CompanyId = @CompanyId AND WidgetId = @WidgetId AND CreatedByUserId = @OperationsPerformedBy
			END

			ELSE
			BEGIN
			INSERT INTO [dbo].[FavouriteWidgets](
                         [Id],
                         [WidgetId],
						 [CompanyId],
                         [CreatedDateTime],
                         [CreatedByUserId],
						 [IsFavourite]
                         )
                  SELECT NEWID(),
                         @WidgetId,
                         @CompanyId,
                         GETDATE(),
                         @OperationsPerformedBy,
						 @IsFavouriteWidget
						SELECT WidgetId FROM FavouriteWidgets WHERE CompanyId = @CompanyId AND WidgetId = @WidgetId AND CreatedByUserId = @OperationsPerformedBy
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


