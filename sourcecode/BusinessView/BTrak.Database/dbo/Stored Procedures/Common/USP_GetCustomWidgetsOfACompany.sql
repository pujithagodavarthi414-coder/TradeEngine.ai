CREATE PROCEDURE USP_GetCustomWidgetsOfACompany
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT CW.Id CustomWidgetId, CustomWidgetName FROM CustomWidgets CW  INNER JOIN WidgetModuleConfiguration WRC ON WRC.WidgetId = CW.Id AND WRC.InActiveDateTime IS NULL AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
			   WHERE CW.CompanyId = @CompanyId AND CW.InActiveDateTime IS NULL

END
GO

--EXEC USP_GetCustomWidgetsOfACompany '02B59C20-BDC0-4B83-8715-35D57CFC458F'
