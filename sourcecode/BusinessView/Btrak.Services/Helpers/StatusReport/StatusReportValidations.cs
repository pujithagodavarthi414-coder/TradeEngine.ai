using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Services.Helpers.Comments;
using BTrak.Common;

namespace Btrak.Services.Helpers.StatusReport
{
    public class StatusReportValidations
    {
        public static bool ValidateStatusReport(StatusReportUpsertInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (statusReport.StatusReportingConfigurationOptionId == Guid.Empty || statusReport.StatusReportingConfigurationOptionId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.StatusReportingConfigurationOptionIdNotFound
                });
            }

            if (!string.IsNullOrEmpty(statusReport.Description))
            {
                var description = CommentValidations.GetSubStringFromHtml(statusReport.Description, statusReport.Description.Length);
                description = description.Trim();

                if (description?.Length > 500)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MaximumLengthForReportComment
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertStatusReportingConfiguration(StatusReportingConfigurationUpsertInputModel statusReportingConfiguration, LoggedInContext loggedInContext,  List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(statusReportingConfiguration.ConfigurationName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ConfigurationNameNotFound
                });
            }

            if (statusReportingConfiguration.ConfigurationName?.Length > 100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ConfigurationNameMaxLength
                });
            }

            if (statusReportingConfiguration.GenericFormId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormIdNotFound
                });
            }

            if (string.IsNullOrEmpty(statusReportingConfiguration.EmployeeIds))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmployeeIdsNotFound
                });
            }

            if (string.IsNullOrEmpty(statusReportingConfiguration.StatusConfigurationOptions))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ConfigurationOptionsNotFound
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
