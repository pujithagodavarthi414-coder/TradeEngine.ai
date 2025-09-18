using Btrak.Models;
using Btrak.Models.Sprints;
using Btrak.Models.Templates;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.Templates
{
    public class TemplatesValidationHelper
    {
        public static bool UpsertTemplateValidations(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext,
           List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (templatesUpsertInputModel.ProjectId == null || templatesUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(templatesUpsertInputModel.TemplateName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTemplateName
                });
            }

            if (templatesUpsertInputModel.TemplateName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForTemplateName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetTemplateByIdValidations(Guid? templateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (templateId == Guid.Empty || templateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTemplateId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSprintValidations (SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (sprintsUpsertInputModel.ProjectId == null || sprintsUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if(!string.IsNullOrEmpty(sprintsUpsertInputModel.Description) && sprintsUpsertInputModel.Description.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SprintDescriptionNotExceed800Characters
                });
            }

            if (!string.IsNullOrEmpty(sprintsUpsertInputModel.SprintName) && sprintsUpsertInputModel.SprintName.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SprintNameNotExceed250Characters
                });
            }

            return validationMessages.Count <= 0;

        }

        public static bool DeleteSprintValidations(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (sprintsUpsertInputModel.SprintId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            return validationMessages.Count <= 0;

        }
    }
}
