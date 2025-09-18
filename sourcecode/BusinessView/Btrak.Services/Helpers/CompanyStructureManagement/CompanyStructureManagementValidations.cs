using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyStructureManagement;
using BTrak.Common;

namespace Btrak.Services.Helpers.CompanyStructureManagement
{
    public class CompanyStructureManagementValidations
    {
        public static bool ValidateUpsertCountry(CountryUpsertInputModel countryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(countryUpsertInputModel.CountryName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCountryName
                });
            }

            if (countryUpsertInputModel.CountryName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForCountryName
                });
            }

            if (countryUpsertInputModel.CountryCode?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForCountryCode
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertRegion(RegionUpsertInputModel regionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(regionUpsertInputModel.RegionName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRegionName
                });
            }

            if (regionUpsertInputModel.RegionName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForRegionName
                });
            }

            if (regionUpsertInputModel.CountryId == null || regionUpsertInputModel.CountryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCountryId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
