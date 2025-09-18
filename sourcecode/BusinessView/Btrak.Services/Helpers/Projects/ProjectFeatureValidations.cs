using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;

namespace Btrak.Services.Helpers.Projects
{
    public class ProjectFeatureValidations
    {
        public static bool ValidateUpsertProjectFeature(ProjectFeatureUpsertInputModel projectFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectFeatureUpsertInputModel.ProjectId == null || projectFeatureUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(projectFeatureUpsertInputModel.ProjectFeatureName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectFeatureName
                });
            }

            if (projectFeatureUpsertInputModel.ProjectFeatureName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForProjectFeatureName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectFeatureById(Guid? projectFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectFeatureId == Guid.Empty || projectFeatureId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectFeatureId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetAllProjectFeaturesByProjectId(ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, projectFeatureSearchCriteriaInputModel, validationMessages);
            
            return validationMessages.Count <= 0;
        }

        public static bool ValidateProjectFeatureFoundWithId(Guid? projectFeatureId, List<ValidationMessage> validationMessages, ProjectFeatureSpReturnModel projectFeatureSpReturnModel)
        {
            if (projectFeatureSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProjectFeatureWithTheId, projectFeatureId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
