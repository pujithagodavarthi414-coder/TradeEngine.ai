using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using BTrak.Common;

namespace Btrak.Services.Helpers.AdhocWorkValidationHelpers
{
    public class AdhocWorkValidationHelper
    {
        public static bool UpsertAdhocWorkValidation(AdhocWorkInputModel adhocWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertAdhocWorkValidation", "adhocWorkInputModel", adhocWorkInputModel, "Adhoc Work Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (adhocWorkInputModel.UserStoryName?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForUserStoryName
                });
            }

            if(adhocWorkInputModel.UserStoryName==null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType=MessageTypeEnum.Error,
                    ValidationMessaage=ValidationMessages.NotEmptyUserStoryName
                });
            }

            //if (adhocWorkInputModel.OwnerUserId == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyOwnerId
            //    });
            //}

            //if (adhocWorkInputModel.EstimatedTime == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyEstimatedTime
            //    });
            //}

            //if (adhocWorkInputModel.EstimatedTime == 0)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotZeroEstimatedTime
            //    });
            //}

            //if (adhocWorkInputModel.DeadLineDate == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyDeadLine
            //    });
            //}

            if (loggedInContext == null)
            {
                loggedInContext = new LoggedInContext();
            }

            //if (loggedInContext.LoggedInUserId == Guid.Empty)
            //{
            //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate LoggedInUserId", "Adhoc work Validation Helper") + "LoggedIn User Id :" + loggedInContext.LoggedInUserId);

            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyLoggedInUserId
            //    });
            //}

            //if (loggedInContext.CompanyGuid == Guid.Empty)
            //{
            //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate CompanyId", "adhoc cwork Validation Helper") + "Company Id : " + loggedInContext.CompanyGuid);

            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyCompanyId
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool ValidateAdhocWorkByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryId == Guid.Empty || userStoryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
