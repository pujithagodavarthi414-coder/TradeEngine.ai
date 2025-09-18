-- EXEC [dbo].[USP_AuditConductMailNotification]
CREATE PROCEDURE [dbo].[USP_AuditConductMailNotification]
(
    @days INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY

				SELECT 
					AuditConductName,
					AC.Id ConductId,
					U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
					U.UserName CreatedUserMail
					FROM AuditConduct AC
					JOIN [User] U ON U.Id = AC.CreatedByUserId  
					WHERE CONVERT(DATE,DeadlineDate) = CONVERT(DATE,GETDATE()) AND IsCompleted <> 1

  END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO