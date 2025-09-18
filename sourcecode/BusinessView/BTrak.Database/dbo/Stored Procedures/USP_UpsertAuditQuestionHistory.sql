CREATE PROCEDURE [dbo].[USP_UpsertAuditQuestionHistory]
(
  @AuditId UNIQUEIDENTIFIER = NULL, 
  @ConductId UNIQUEIDENTIFIER = NULL, 
  @QuestionId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(MAX),
  @NewValue NVARCHAR(MAX), 
  @Description NVARCHAR(MAX),
  @Field NVARCHAR(MAX),
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsAction BIT= NULL,
  @UserStoryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        IF(@AuditId IS NULL)
        BEGIN

            SELECT @AuditId = AuditComplianceId FROM AuditConduct WHERE Id = @ConductId

        END

        INSERT INTO [dbo].[AuditQuestionHistory]([Id], 
                                                 [AuditId], 
                                                 [ConductId], 
                                                 [QuestionId], 
                                                 [OldValue], 
                                                 [NewValue], 
                                                 [Description], 
                                                 [Field],
                                                 [CreatedDateTime], 
                                                 [CreatedByUserId],
                                                 [IsAction],
                                                 UserStoryId
                                                )
                                          SELECT NEWID(),
                                                 @AuditId,
                                                 @ConductId,
                                                 @QuestionId,
                                                 @OldValue,
                                                 @NewValue,
                                                 @Description,
                                                 @Field,
                                                 GETDATE(),
                                                 @OperationsPerformedBy,
                                                 ISNULL(@IsAction , 0),
                                                 @UserStoryId

    END TRY
    BEGIN CATCH

        THROW

    END CATCH


END
GO