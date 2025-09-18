using Btrak.Models;
using Btrak.Models.ProductivityDashboard;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.ProductivityDashboard
{
    public class ProductivityDashboardValidations
    {
        public static bool ValidateProductivityIndexForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(productivityDashboardSearchCriteriaInputModel.Type) && productivityDashboardSearchCriteriaInputModel.DateFrom == null && productivityDashboardSearchCriteriaInputModel.DateTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyType
                });
            }

            if (productivityDashboardSearchCriteriaInputModel.SelectedDate == null && productivityDashboardSearchCriteriaInputModel.DateFrom == null && productivityDashboardSearchCriteriaInputModel.DateTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStoryStatuses(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(productivityDashboardSearchCriteriaInputModel.Type))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyType
                });
            }

            if (productivityDashboardSearchCriteriaInputModel.SelectedDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateQaPerformance(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(productivityDashboardSearchCriteriaInputModel.Type))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyType
                });
            }

            if (productivityDashboardSearchCriteriaInputModel.SelectedDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeUserStories(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (productivityDashboardSearchCriteriaInputModel.DeadLineDateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadLine
                });
            }

            if (productivityDashboardSearchCriteriaInputModel.DeadLineDateTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadLine
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
