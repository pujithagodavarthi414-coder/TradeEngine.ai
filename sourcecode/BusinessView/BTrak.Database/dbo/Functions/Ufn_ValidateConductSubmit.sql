CREATE FUNCTION [dbo].[Ufn_ValidateConductSubmit]
(
    @AuditConductId UNIQUEIDENTIFIER,
    @CheckMandatory BIT NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN

    DECLARE @BitColumn BIT = 0

    IF(@CheckMandatory = 1)
    BEGIN
    DECLARE @Mandatory INT = ISNULL((SELECT COUNT(1)
                               FROM AuditConductQuestions ACQ
							   INNER JOIN ConductQuestionRoleConfiguration ACQR ON ACQR.ConductQuestionId = ACQ.Id 
                               WHERE ACQ.AuditConductId = @AuditConductId AND ACQ.IsMandatory = 1 AND ACQ.IsMandatory = 1
							   AND ((ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL))
							   OR ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
							   AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0 
							   AND ACQR.CanView =1 AND ACQR.CanEdit = 1))
                       ),0)
    
    DECLARE @SubmittedMandatory INT = ISNULL((SELECT COUNT(1)
                               FROM AuditConductQuestions ACQ
                               JOIN AuditConductSubmittedAnswer ACSA ON ACSA.ConductId = ACQ.AuditConductId
							   INNER JOIN ConductQuestionRoleConfiguration ACQR ON ACQR.ConductQuestionId = ACQ.Id 
                                AND ACSA.InActiveDateTime IS NULL AND ACQ.InActiveDateTime IS NULL
                                AND ACSA.QuestionId = ACQ.QuestionId AND ACQ.IsMandatory = 1 AND ACQ.AuditConductId = @AuditConductId
								AND ((ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL))
							   OR ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
							   AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0 
							   AND ACQR.CanView =1 AND ACQR.CanEdit = 1))
                       ),0)

    SET @BitColumn = IIF(@SubmittedMandatory < @Mandatory,0,1)
    END
    ELSE IF(@CheckMandatory = 0)
    BEGIN
        
                IF(EXISTS(SELECT ACQ.Id FROM AuditConductQuestions ACQ 
               JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId AND ACQ.AuditConductId = @AuditConductId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
               JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId 
                AND ACS.AuditAnswerId = ACA.Id AND ISNULL(ACA.QuestionOptionResult,0) = 0
               LEFT JOIN UserStory US ON  ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,',')) AND US.InActiveDateTime IS NULL
               WHERE US.Id IS NULL))
        BEGIN

            SET @BitColumn = 1

        END
        ELSE
        BEGIN

            SET @BitColumn = 0

        END

    END
	ELSE IF(@CheckMandatory IS NULL) 
	BEGIN
	DECLARE @MandatoryDocument INT = IIF((SELECT COUNT(1)
                               FROM AuditConductQuestions ACQ
							   INNER JOIN ConductQuestionRoleConfiguration ACQR ON ACQR.ConductQuestionId = ACQ.Id
							   INNER JOIN ConductQuestionDocuments C ON C.ConductQuestionId = ACQ.Id 
							   LEFT JOIN  (SELECT [FileName],FileExtension,FilePath,QuestionDocumentId FROM UploadFile WHERE   InActiveDateTime IS NULL) as U on u.QuestionDocumentId = C.Id
                               WHERE ACQ.AuditConductId = @AuditConductId
							   --AND ACQ.IsMandatory = 1 
							   AND C.IsDocumentMandatory = 1
							   AND U.FilePath IS NULL
							   AND ((ACQR.Roles IS NULL OR ACQR.Users IS NULL OR (ACQR.CanEdit IS NULL AND ACQR.CanView IS NULL AND ACQR.CanAddAction IS NULL AND ACQR.NoPermission IS NULL))
							   OR ((SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Roles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0 
							   AND (SELECT COUNT(1) UserIdsCount FROM [dbo].[Ufn_StringSplit](ACQR.Users,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT (@OperationsPerformedBy)))  > 0 
							   AND ACQR.CanView =1 AND ACQR.CanEdit = 1))
                       ) = 0,0,1)

					   SET @BitColumn = @MandatoryDocument
	END
    RETURN @BitColumn
END
