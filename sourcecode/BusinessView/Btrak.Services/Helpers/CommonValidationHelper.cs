using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using BTrak.Common;

namespace Btrak.Services.Helpers
{
    public static class CommonValidationHelper
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
         public static bool ValidateSearchCriteriaUnAuth( SearchCriteriaInputModelBase searchModel, List<ValidationMessage> validationMessages)
        {

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

        public static bool ValidateObservationTypeModel (ObservationTypeModel observationTypeModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(observationTypeModel.ObservationTypeName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate observationTypeName", "Common Validation Helper") + "Observation Type Name:" + observationTypeModel.ObservationTypeName);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ObservationNameIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateDynamicField(string value,string fieldName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            if (value == string.Empty || value  == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = fieldName+" should not be null"
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