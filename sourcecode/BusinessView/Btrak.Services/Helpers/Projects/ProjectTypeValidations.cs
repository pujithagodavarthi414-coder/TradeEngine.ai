using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ProjectType;
using BTrak.Common;

namespace Btrak.Services.Helpers.Projects
{
    public class ProjectTypeValidations
    {
        public static bool ValidateUpsertProjectType(string projectTypeName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateUpsertProjectType", "ProjectTypeValidations"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(projectTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectTypeName
                });
            }

            if (projectTypeName != null && projectTypeName.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForProjectTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectTypeById(Guid? projectTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateProjectTypeById", "ProjectTypeValidations"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectTypeId == Guid.Empty || projectTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectTypeFoundWithId(Guid? projectTypeId, List<ValidationMessage> validationMessages, ProjectTypeApiReturnModel projectTypeSpReturnModel)
        {
            if (projectTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =
                        string.Format(ValidationMessages.NotFoundProjectTypeWithTheId, projectTypeId)
                });
                return true;
            }

            return validationMessages.Count <= 0;
        }
    }
}
