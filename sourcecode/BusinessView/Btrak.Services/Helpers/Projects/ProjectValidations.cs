using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;

namespace Btrak.Services.Helpers.Projects
{
    public class ProjectValidations
    {
        public static bool ValidateProjectById(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectId == Guid.Empty || projectId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectOverViewDetails(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectId == Guid.Empty || projectId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertProject(ProjectUpsertInputModel projectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(projectInputModel.ProjectName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectName
                });
            }

            if (projectInputModel.ProjectName != null && projectInputModel.ProjectName.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForProjectName
                });
            }

            if (projectInputModel.ProjectResponsiblePersonId == null || projectInputModel.ProjectResponsiblePersonId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionProjectResponsiblePersonId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateArchiveProject(ArchiveProjectInputModel archiveProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (archiveProjectInputModel.ProjectId == null || archiveProjectInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertProjectTags(ProjectTagUpsertInputModel projectTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectTagUpsertInputModel.ProjectId == null || projectTagUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
