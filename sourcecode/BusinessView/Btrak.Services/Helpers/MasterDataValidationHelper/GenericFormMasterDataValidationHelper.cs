using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.MasterDataValidationHelper
{
    public class GenericFormMasterDataValidationHelper
    {
        public static bool UpsertGenericFormTypeValidation(GenericFormTypeUpsertModel genericFormTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGenericFormType", "genericFormTypeUpsertModel", genericFormTypeUpsertModel, "UpsertGenericFormType Validation helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(genericFormTypeUpsertModel.FormTypeName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFormTypeName
                });
            }

            if (!string.IsNullOrEmpty(genericFormTypeUpsertModel.FormTypeName) && genericFormTypeUpsertModel.FormTypeName.Length > 50)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormTypeNameLengthExceeded
                });

            }

            return validationMessageses.Count <= 0;
        }
    }
}
