using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.SoftLabels;
using BTrak.Common;

namespace Btrak.Services.Helpers.SoftLabelsValidationHelpers
{
    public class SoftLabelsValidationHelper
    {
        public static bool UpsertSoftLabelsValidation(SoftLabelsInputMethod softLabelsInputMethod, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert SoftLabels Validation", "softLabelsInputMethod", softLabelsInputMethod, "Soft Labels Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(softLabelsInputMethod.SoftLabelName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySoftLabelName
                });
            }

            if (!string.IsNullOrEmpty(softLabelsInputMethod.SoftLabelName))
            {
                if (softLabelsInputMethod.SoftLabelName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.SoftLabelNameLengthExceeded
                    });
                }
            }

            if (softLabelsInputMethod.BranchId == null || softLabelsInputMethod.BranchId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBranchId
                });
            }

            return validationMessages.Count <= 0;
        }

    }
}
