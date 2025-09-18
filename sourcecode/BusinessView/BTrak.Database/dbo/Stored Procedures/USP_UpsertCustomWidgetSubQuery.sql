CREATE PROC [dbo].[USP_UpsertCustomWidgetSubQuery]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomWidgetId UNIQUEIDENTIFIER,
	@CompanyGuid UNIQUEIDENTIFIER,
	@SubQueryType NVARCHAR(MAX),
	@SubQuery NVARCHAR(MAX)
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	
		IF (@HavePermission = '1')
	    BEGIN
			UPDATE CustomWidgets SET SubQuery = @SubQuery, SubQueryType = @SubQueryType, UpdatedByUserId = @OperationsPerformedBy WHERE CompanyId = @CompanyGuid AND Id = @CustomWidgetId
			SELECT @CustomWidgetId
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
