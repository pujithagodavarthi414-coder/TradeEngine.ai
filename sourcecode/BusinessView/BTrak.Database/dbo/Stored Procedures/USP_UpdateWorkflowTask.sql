CREATE procedure [dbo].[USP_UpdateWorkflowTask]
( @TaskId uniqueidentifier,
  @UserStoryId uniqueidentifier,
  @CustomAppId uniqueidentifier = null,
  @FormId uniqueidentifier = null,
  @ReferenceId uniqueidentifier = null,
  @ReferenceTypeId uniqueidentifier = null
)
as
begin
if(@FormId IS NOT NULL AND @CustomAppId IS NOT NULL)
BEGIN
update UserStory set workFlowTaskId = @TaskId,FormId= @FormId, CustomApplicationId = @CustomAppId where Id = @UserStoryId
END
ELSE IF(@ReferenceId IS NOT NULL AND @ReferenceTypeId IS NOT NULL)
BEGIN
 IF(@ReferenceTypeId = 'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6') 
		  BEGIN
			IF EXISTS(SELECT Id FROM AuditCompliance WHERE Id = @ReferenceId)
				BEGIN
				SET @ReferenceTypeId = '98A3A24D-BE04-4A12-8E48-73648A0507FB'
				END
			ELSE IF EXISTS(SELECT Id FROM AuditConduct WHERE Id = @ReferenceId)
			BEGIN
				SET @ReferenceTypeId = '6A752767-347B-4E6C-8F73-4E3FA9BF0ACC'
				END
			ELSE IF EXISTS(SELECT Id FROM AuditQuestions WHERE Id = @ReferenceId)
			BEGIN
				SET @ReferenceTypeId = 'D8C4322A-7041-473A-A4B1-3608B260A5B7'
				END
			ELSE IF EXISTS(SELECT Id FROM AuditConductQuestions WHERE Id = @ReferenceId)
			BEGIN
				SET @ReferenceTypeId = 'C6BA92FE-B4A5-4082-B513-9FDCA29610B8'
				END
		  END
update UserStory set workFlowTaskId = @TaskId,ReferenceId= @ReferenceId, ReferenceTypeId = @ReferenceTypeId where Id = @UserStoryId
END
end