using Btrak.Models.Projects;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models;

namespace Btrak.Services.Helpers.Projects
{
    public class ProjectMemberValidations
    {
        public static bool ValidateUpsertProjectMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectMemberUpsertInputModel.ProjectId == null || projectMemberUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (projectMemberUpsertInputModel.RoleIds == null || projectMemberUpsertInputModel.RoleIds?.Count < 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectMemberRoleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetAllProjectMembers(ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, projectMemberSearchCriteriaInputModel, validationMessages);

            if (projectMemberSearchCriteriaInputModel.ProjectId == null || projectMemberSearchCriteriaInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectMemberById(Guid? projectMemberId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectMemberId == null || projectMemberId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectMemberUserId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectMemberFoundWithId(Guid? projectMemberId, List<ValidationMessage> validationMessages, ProjectMemberSpReturnModel projectMemberSpReturnModel)
        {
            if (projectMemberSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProjectMemberWithTheId, projectMemberId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectMemberFoundWithUserId(Guid? userId, List<ValidationMessage> validationMessages, List<ProjectMemberSpReturnModel> projectMemberDetails)
        {
            if (projectMemberDetails == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProjectMemberWithTheUserId, userId)
                });

                return true;
            }

            return validationMessages.Count <= 0;
        }

        public static bool DeleteProjectMember(DeleteProjectMemberModel deleteProjectMemberModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (deleteProjectMemberModel.ProjectId == null || deleteProjectMemberModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (deleteProjectMemberModel.UserId == null || deleteProjectMemberModel.UserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
