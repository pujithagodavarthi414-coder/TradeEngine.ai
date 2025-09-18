CREATE PROCEDURE [dbo].[USP_UpsertTemplate]
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@TemplateName NVARCHAR(250) = NULL,
	@TemplateResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OnBoardProcessDate DATETIMEOFFSET = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @BoardTypeId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[BoardType] WHERE BoardTypeName = 'Templates Workflow' AND CompanyId = @CompanyId)

			 DECLARE @TemplatesNameCount INT = (
                                             SELECT COUNT(1)
                                             FROM Templates
                                             WHERE TemplateName = @TemplateName
                                                   And ProjectId = @ProjectId
                                                   AND (
                                                           Id <> @TemplateId
                                                           OR @TemplateId IS NULL
                                                       )
                                                   AND InActiveDateTime IS NULL

                                         )
			 IF (@TemplatesNameCount > 0)
             BEGIN

                RAISERROR(50001, 16, 1, 'Template')

             END
			 ELSE
			 BEGIN
			     DECLARE @IsLatest BIT
                    = (CASE
                           WHEN @TemplateId IS NULL THEN
                               1
                           ELSE
                               CASE
                                   WHEN
                                   (
                                       SELECT [TimeStamp] FROM [Templates] WHERE Id = @TemplateId
                                   ) = @TimeStamp THEN
                                       1
                                   ELSE
                                       0
                               END
                       END
                      )
				  IF (@IsLatest = 1)
                  BEGIN 
				      DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
					    IF (@TemplateId IS NULL)
                         BEGIN
						      SET @TemplateId = NEWID()
						      INSERT INTO [dbo].[Templates] (
							                   [Id],
											   [ProjectId],
											   [TemplateName],
											   [TemplateResponsibleUserId],
											   [BoardTypeId],
											   [OnBoardProcessDate],
											   [CreatedByUserId],
											   [CreatedDateTime]
                                            )
									SELECT @TemplateId,
									       @ProjectId,
									       @TemplateName,
										   @TemplateResponsiblePersonId,
										   @BoardTypeId,
										   @OnBoardProcessDate,
										   @OperationsPerformedBy,
										   @Currentdate

								EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @TemplateName, @FieldName = 'TemplateAdded',
		                                                      @Description = 'TemplateAdded', @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId

						 END
						 ELSE
						   BEGIN

									EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
									                                     @TemplateId = @TemplateId,
                                                                         @TemplateName = @TemplateName,
                                                                         @TemplateResponsibleUserId = @TemplateResponsiblePersonId,
																		 @TemplateOnBoardProcessDate = @OnBoardProcessDate,
																		 @TemplateBoardTypeId = @BoardTypeId,
                                                                         @OperationsPerformedBy = @OperationsPerformedBy

						             UPDATE [dbo].[Templates]
									 SET TemplateName = @TemplateName,
									     ProjectId = @ProjectId,
									     TemplateResponsibleUserId = @TemplateResponsiblePersonId,
										 OnBoardProcessDate = @OnBoardProcessDate,
										 BoardTypeId = @BoardTypeId,
										 UpdatedByUserId = @OperationsPerformedBy,
										 UpdatedDateTime = @Currentdate
									 WHERE Id = @TemplateId
						   END
						SELECT Id FROM [dbo].[Templates] WHERE Id = @TemplateId
				  END
				  ELSE
				  BEGIN
				       RAISERROR(50008, 11, 1)
				  END
			 END
	  END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO