using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyLocation;
using BTrak.Common;

namespace Btrak.Services.Helpers.CompanyLocationValidationHelpers
{
    public class CompanyLocationValidationHelper
    {
        public static bool UpsertCompanyLocationValidation(CompanyLocationInputModel companyLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyLocationValidation", "companyLocationInputModel", companyLocationInputModel, "Company Location Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(companyLocationInputModel.LocationName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyLocation
                });
            }

            if (!string.IsNullOrEmpty(companyLocationInputModel.LocationName))
            {
                if (companyLocationInputModel.LocationName.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanyLocationNameLengthExceed
                    });
                }
            }

            if (string.IsNullOrEmpty(companyLocationInputModel.Address))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyAddress
                });

            }

            if (!string.IsNullOrEmpty(companyLocationInputModel.Address))
            {
                if (companyLocationInputModel.Address.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanyAddressLengthExceed
                    });
                }
            }

            if (companyLocationInputModel.Latitude == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyLatitude
                });
            }

            if (companyLocationInputModel.Longitude == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyLongitude
                });
            }
           

            return validationMessages.Count <= 0;
        }

        public static bool GetCompanyLocationByIdValidation(Guid? locationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyLocationByIdValidation", "locationId", locationId, "Company Location Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (locationId == null || locationId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyLocationId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
