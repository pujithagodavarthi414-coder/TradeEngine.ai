using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.MasterDataValidationHelper
{
    public class AccessibleIpAddressDataValidation
    {
        public static bool UpsertAccessibleIpAddressNameValidation(AccessibleIpAddressUpsertModel accessibleIpAddressUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert accessible ip address", "accessibleIpAddressUpsertModel", accessibleIpAddressUpsertModel, "accessible ip address Api"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(accessibleIpAddressUpsertModel.LocationName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAccessibleIpAddressName
                });
            }

            if (!string.IsNullOrEmpty(accessibleIpAddressUpsertModel.IpAddress) && accessibleIpAddressUpsertModel.IpAddress.Length > 50)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AccessibleIpAddressNameLengthExceeded
                });
            }

            return validationMessageses.Count <= 0;
        }
    }
}