CREATE PROCEDURE [dbo].[USP_GetCustomAppApiDetails]
(
   @CustomWidgetId UNIQUEIDENTIFIER,
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

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   		   
		   SELECT [Id] AS ApiDetailsId,
				  [CustomWidgetId],
                  [CompanyId],
				  [HttpMethod],
				  [OutputRoot],
				  [ApiUrl],
				  [ApiHeadersJson],
				  [ApiOutputsJson],
				  [BodyJson]
		          FROM CustomWidgetApiDetails
                  WHERE (CustomWidgetId = @CustomWidgetId) AND CompanyId = @CompanyId
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