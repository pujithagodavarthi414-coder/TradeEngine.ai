using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Services.Helpers
{
   public  class CommonValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForLoggedInUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return validationMessages;
        }

        public static List<ValidationMessage> CheckValidationForSearchCriteria(LoggedInContext loggedInContext, SearchCriteriaInputModelBase searchModel, List<ValidationMessage> validationMessages)
        {
            CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (searchModel.PageNumber == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating PageNumber", "Common Validation Helper") + "Page Number:" + searchModel.PageNumber);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageNumberRequired
                });
            }

            if (searchModel.PageSize == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating PageSize", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageSizeRequired
                });
            }

            else if (searchModel.PageSize > AppConstants.InputWithMaxSize1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating PageSize", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthPageSize
                });
            }

            return validationMessages;
        }
        public static bool ValidateSearchCriteria(LoggedInContext loggedInContext, SearchCriteriaInputModelBase searchModel, List<ValidationMessage> validationMessages)
        {
            CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (searchModel.PageNumber == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate PageNumber", "Common Validation Helper") + "Page Number:" + searchModel.PageNumber);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageNumberRequired
                });
            }

            if (searchModel.PageSize == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate PageSize", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageSizeRequired
                });
            }

            else if (searchModel.PageSize > 1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate PageSize", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthPageSize
                });
            }

            return validationMessages.Count <= 0;
        }

    }
}
