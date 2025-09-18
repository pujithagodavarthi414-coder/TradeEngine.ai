using AuthenticationServices.Common;
using AuthenticationServices.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.Helpers
{
    public class CommonValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForLoggedInUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return validationMessages;
        }

        public static bool ValidateLoggedInUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (loggedInContext == null)
            {
                loggedInContext = new LoggedInContext();
            }

            if (loggedInContext.LoggedInUserId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate LoggedInUserId", "Common Validation Helper") + "LoggedIn User Id :" + loggedInContext.LoggedInUserId);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLoggedInUserId
                });
            }

            if (loggedInContext.CompanyGuid == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate CompanyId", "Common Validation Helper") + "Company Id : " + loggedInContext.CompanyGuid);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyId
                });
            }

            return validationMessages.Count <= 0;
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

            else if (searchModel.PageSize > AppConstants.InputWithMaxSize1000)
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

        public static bool ValidateSearchCriteriaForAllowAnonymous(SearchCriteriaInputModelBase searchModel, List<ValidationMessage> validationMessages)
        {
            if (searchModel.PageNumber == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateSearchCriteriaForAllowAnonymous", "Common Validation Helper") + "Page Number:" + searchModel.PageNumber);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageNumberRequired
                });
            }

            if (searchModel.PageSize == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateSearchCriteriaForAllowAnonymous", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageSizeRequired
                });
            }

            else if (searchModel.PageSize > AppConstants.InputWithMaxSize1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateSearchCriteriaForAllowAnonymous", "Common Validation Helper") + "Page Size:" + searchModel.PageSize);

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
