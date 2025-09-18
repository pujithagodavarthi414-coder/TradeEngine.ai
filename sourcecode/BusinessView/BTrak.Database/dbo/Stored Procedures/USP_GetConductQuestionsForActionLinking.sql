
--EXEC [dbo].[USP_GetConductQuestionsForActionLinking] @ProjectId='', @OperationsPerformedBy=''

CREATE PROCEDURE [dbo].[USP_GetConductQuestionsForActionLinking]
(
@ProjectId UNIQUEIDENTIFIER,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@QuestionName NVARCHAR(MAX) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
		IF(@QuestionName = '') SET @QuestionName = NULL

		SET @QuestionName = '%' + @QuestionName + '%'
		
		SELECT AC.Id ConductId, ACQ.Id ConductQuestionId, ACQ.QuestionName, ACQ.QuestionId FROM AuditConduct AC 
				JOIN AuditConductQuestions ACQ ON ACQ.[AuditConductId] = AC.Id AND AC.InActiveDateTime IS NULL 
				AND ACQ.InActiveDateTime IS NULL AND AC.IsCompleted <> 1 AND AC.DeadLineDate >= GETDATE() AND AC.ProjectId = @ProjectId
				AND (@QuestionName IS NULL OR ACQ.QuestionName like @QuestionName)
				END
	END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO