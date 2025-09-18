CREATE  PROCEDURE [dbo].[USP_AuditConductDeadLineMailNotification]
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
						AC.AuditConductName,
						U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
						U.UserName CreatedUserMail,
						U.Id UserId,
						U.CompanyId,
						CONVERT(DATE,DATEADD(Day, @daysT, GetDate())) D
					 FROM AuditConduct AC
						JOIN [User] U ON U.Id = AC.CreatedByUserId 
						WHERE AC.InActiveDateTime IS NULL AND 
						 CONVERT(DATE,AC.DeadlineDate) = CONVERT(DATE,DATEADD(Day, @daysT, GetDate()))
  END TRY
 BEGIN CATCH

    THROW

END CATCH
END