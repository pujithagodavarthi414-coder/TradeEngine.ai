CREATE PROCEDURE [dbo].[USP_UpsertCustomAppApiDetails]
(
   @CustomWidgetId UNIQUEIDENTIFIER = NULL,
   @HttpMethod NVARCHAR(50) = NULL,  
   @OutputRoot NVARCHAR(250) = NULL,  
   @ApiUrl NVARCHAR(MAX) = NULL,  
   @ApiHeadersJson NVARCHAR(MAX) = NULL,
   @ApiOutputsJson NVARCHAR(MAX) = NULL,
   @BodyJson NVARCHAR(MAX) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@CustomWidgetId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CustomWidgetId')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
       
             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
			 
                  DECLARE @Currentdate DATETIME = GETDATE()
                    
                        
                  DECLARE @ApiDetailsId UNIQUEIDENTIFIER = (SELECT Id FROM CustomWidgetApiDetails WHERE CustomWidgetId = @CustomWidgetId)
                     
                  IF(@ApiDetailsId IS NULL)
                  BEGIN
                     
					 SET @ApiDetailsId = NEWID()

                       INSERT INTO [dbo].[CustomWidgetApiDetails](
                                   [Id],
								   [CustomWidgetId],
                                   [CompanyId],
                                   [HttpMethod],
								   [ApiUrl],
								   [ApiHeadersJson],
								   [ApiOutputsJson],
								   [BodyJson],
								   [OutputRoot],
								   [CreatedDateTime],
                                   [CreatedByUserId]                 
                                   )
                            SELECT @ApiDetailsId,
                                   @CustomWidgetId,
								   @CompanyId,
								   @HttpMethod,
                                   @ApiUrl,
                                   @ApiHeadersJson,
								   @ApiOutputsJson,
								   @BodyJson,
								   @OutputRoot,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                                   
				    END
				    ELSE
				    BEGIN

						UPDATE [CustomWidgetApiDetails]
						   SET [CompanyId] = @CompanyId,
                               [ApiUrl] = @ApiUrl,
                               [HttpMethod] = @HttpMethod,
							   [OutputRoot] = @OutputRoot,
							   [ApiHeadersJson] = @ApiHeadersJson,
							   [ApiOutputsJson] = @ApiOutputsJson,
							   [BodyJson] = @BodyJson,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE CustomWidgetId = @CustomWidgetId

						END

                            
                         SELECT Id FROM [dbo].[CustomWidgetApiDetails] WHERE CustomWidgetId = @CustomWidgetId
                    
                  END
                  ELSE
                  BEGIN
                  
                         RAISERROR (@HavePermission,11, 1)
                         
                  END
        END
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO