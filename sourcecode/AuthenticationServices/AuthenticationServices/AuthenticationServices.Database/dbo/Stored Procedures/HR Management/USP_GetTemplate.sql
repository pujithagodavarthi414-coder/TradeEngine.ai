CREATE PROCEDURE [dbo].[USP_GetTemplate]
(
 @TemplateName VARCHAR(2000),
 @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
  SET NOCOUNT ON
    BEGIN TRY
     SELECT HtmlTemplate FROM [HtmlTemplates] WHERE TemplateName = @TemplateName AND (@CompanyId IS NULL OR CompanyId = @CompanyId)
     
     END TRY
     BEGIN CATCH
        
        SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage
    END CATCH
END