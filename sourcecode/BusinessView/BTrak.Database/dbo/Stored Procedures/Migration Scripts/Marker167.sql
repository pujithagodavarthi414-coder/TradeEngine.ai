CREATE PROCEDURE [dbo].[Marker167]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE CustomAppDetails SET YCoOrdinate ='Audits Overdue' 
WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits over due' AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET WidgetQuery ='  SELECT COUNT(1) [Audits Overdue] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
 WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)
   AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)' ,
CustomWidgetName = 'Audits Overdue' WHERE CompanyId = @CompanyId AND CustomWidgetName =  'Audits over due'

END
GO

