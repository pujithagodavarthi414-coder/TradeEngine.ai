CREATE PROCEDURE [dbo].[Marker195]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN
    MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
    USING ( VALUES
     (NEWID(), GETDATE(), @UserId, @CompanyId, N'Question', N'Question')
    )
    AS Source ([Id], [CreatedDateTime], [CreatedByUserId], [CompanyId], [AuditQuestionLabel], [AuditQuestionsLabel])
    ON Target.CompanyId = Source.CompanyId 
    WHEN MATCHED THEN
    UPDATE SET [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId]       = Source.[CompanyId],
               [AuditQuestionLabel] = Source.[AuditQuestionLabel],
               [AuditQuestionsLabel] = Source.[AuditQuestionsLabel];
END
GO