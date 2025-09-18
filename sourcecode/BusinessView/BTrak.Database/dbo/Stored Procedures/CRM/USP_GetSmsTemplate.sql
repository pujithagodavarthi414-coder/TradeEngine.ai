CREATE PROCEDURE [dbo].[USP_GetSmsTemplate]
(
	@TemplateId uniqueidentifier = NULL,
	@TemplateName nvarchar(250),
	@ReceiverId uniqueidentifier = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsActive bit =  null
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		SELECT Id TemplateId, TemplateCode, TemplateName, Template  FROM SMSTemplate ST
		WHERE (@IsActive IS NULL OR (@IsActive = 0 AND InActiveDateTime IS NOT NULL) OR (@IsActive = 1 AND InActiveDateTime IS NULL))
		AND (@TemplateName IS NULL OR ST.TemplateName LIKE '%'+@TemplateName+'%')
		AND (@TemplateId IS NULL OR ST.Id = @TemplateId)

	END TRY  
	BEGIN CATCH 
		EXEC USP_GetErrorInformation
	END CATCH
END