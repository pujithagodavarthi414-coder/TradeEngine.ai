using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.Helpers.MasterDataValidationHelper
{
    public class MasterDataValidationHelper
    {
        public static bool UpsertCompanySettingsValidation(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert job categories Validation", "appSettingsUpsertInputModel", companySettingsUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(companySettingsUpsertInputModel.Key))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanySettingsKey
                });
            }

            if (!string.IsNullOrEmpty(companySettingsUpsertInputModel.Key))
            {
                if (companySettingsUpsertInputModel.Key.Length > 500)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanySettingsKeyNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }
    }
}
