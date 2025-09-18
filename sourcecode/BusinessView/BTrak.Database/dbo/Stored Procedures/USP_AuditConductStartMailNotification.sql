CREATE PROCEDURE [dbo].[USP_AuditConductStartMailNotification]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@days INT  = NULL
)AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				DECLARE @daysT INT = @days
				SELECT AC.Id AuditId,
						AC.AuditName AuditConductName,
						U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
						U.UserName CreatedUserMail,
						U.Id UserId,
						U.CompanyId,
						CE.ConductStartDate,
						CONVERT(DATE,DATEADD(Day, @daysT, GetDate())) D
					 FROM [dbo].[CronExpression] CE
						INNER JOIN AuditCompliance AC ON AC.Id = CE.CustomWidgetId AND AC.CompanyId = @CompanyId
						JOIN [User] U ON U.Id = AC.CreatedByUserId 
						WHERE AC.InActiveDateTime IS NULL AND CE.InActiveDateTime IS NULL AND 
						 CONVERT(DATE,CE.ConductStartDate) = CONVERT(DATE,DATEADD(Day, @daysT, GetDate()))
  END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO