CREATE PROCEDURE [dbo].[USP_UpsertSmsTemplate]
(
	@TemplateId uniqueidentifier = NULL,
	@TemplateName nvarchar(250),
	@Template nvarchar(max),
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsActive bit =  null
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@TemplateId IS NOT NULL)
		BEGIN
			UPDATE [SMSTemplate] 
				SET TemplateName = @TemplateName,
					Template = @Template,
					UpdatedByUserId = @OperationsPerformedBy,
					UpdatedDateTime = @Currentdate,
					InActiveDateTime = CASE WHEN @IsActive = 1 THEN @Currentdate ELSE NULL END
			WHERE Id = @TemplateId
		END
		ELSE
		BEGIN
			SET @TemplateId = NEWID();
			INSERT INTO SMSTemplate(Id, TemplateName, Template, CreatedByUserId, CreatedDateTime)
			SELECT @TemplateId, @TemplateName, @Template, @OperationsPerformedBy, @Currentdate
		END
		
		SELECT Id FROM [dbo].[SMSTemplate] WHERE Id = @TemplateId
	
	END TRY  
	BEGIN CATCH 
		EXEC USP_GetErrorInformation
	END CATCH
END