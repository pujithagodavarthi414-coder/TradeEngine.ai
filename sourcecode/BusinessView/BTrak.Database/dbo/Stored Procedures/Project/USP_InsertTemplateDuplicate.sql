CREATE PROCEDURE [dbo].[USP_InsertTemplateDuplicate]
	@GoalId UNIQUEIDENTIFIER = NULL,
	@TemplateName NVARCHAR(250) = NULL,
	@TemplateResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OnBoardProcessDate DATETIMEOFFSET = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @BoardTypeId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[BoardType] WHERE BoardTypeName = 'Templates Workflow' AND CompanyId = @CompanyId)

	     DECLARE @TemplatesNameCount INT = (SELECT COUNT(1) FROM Templates WHERE TemplateName = @TemplateName
                                                   And ProjectId = @ProjectId
                                                   AND InActiveDateTime IS NULL)
			 IF (@TemplatesNameCount > 0)
             BEGIN

                RAISERROR(50001, 16, 1, 'Template')

             END
			 ELSE
			 BEGIN
			  
				      DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
					  DECLARE @TemplateId UNIQUEIDENTIFIER = NEWID()
						   
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
					DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE TemplateId = @TemplateId)
					
					EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @TemplateName, @FieldName = 'TemplateExtractedFromGoal',
		                                          @Description = 'TemplateExtractedFromGoal', @OperationsPerformedBy = @OperationsPerformedBy

					INSERT INTO [dbo].[UserStory](
                                           [Id],
                                           [GoalId],
                                           [UserStoryName],
                                           [EstimatedTime],
                                           [TemplateId],
										   [Order],
										   [UserStoryTypeId],
										   [CreatedByUserId],
										   [CreatedDateTime],
										   [UserStoryUniqueName],
										   [Description]
                                           )
                                    SELECT NEWID(),
                                           NULL,
                                           UserStoryName,
                                           EstimatedTime,
                                           @TemplateId,
										   [Order],
										   UserStoryTypeId,
										   @OperationsPerformedBy,
										   @Currentdate,
										   UserStoryUniqueName,
										   [Description]
						        FROM UserStory US WHERE GoalId = @GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
					  
					  SELECT Id FROM [dbo].[Templates] WHERE Id = @TemplateId
				 
			 END
	  END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO