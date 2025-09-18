using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.FoodOrders;
using BTrak.Common;
using BTrak.Common.Texts;

namespace Btrak.Services.Helpers.FoodOrderManagementValidationHelpers
{
    public class FoodOrderManagementValidationHelper
    {
        public static List<ValidationMessage> CheckFoodOrderValidationMessages(FoodOrderManagementInputModel foodOrderManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (foodOrderManagementInputModel.OrderedDate == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking OrderedDate in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyOrderedDate
                });
            }
            if (string.IsNullOrEmpty(foodOrderManagementInputModel.FoodOrderItems))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking FoodOrderItems in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodOrderItems
                });
            }
            if (foodOrderManagementInputModel.MemberId == null || foodOrderManagementInputModel.MemberId.Count <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking MemberId in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodOrderMembers
                });
            }
            if (foodOrderManagementInputModel.Amount == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking Amount in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyAmount
                });
            }
            if (foodOrderManagementInputModel.Amount != null && foodOrderManagementInputModel.Amount <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking Amount in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.ValidFoodOrderAmount
                });
            }
            if (foodOrderManagementInputModel.CurrencyId == null || foodOrderManagementInputModel.CurrencyId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking Currency in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyCurrencyId
                });
            }
            return validationMessages;
        }

        public static List<ValidationMessage> CheckGetFoodOrderByIdValidationMessages(Guid? foodOrderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetFoodOrderByIdValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            if (foodOrderId == null || foodOrderId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetFoodOrderByIdValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking foodOrderId in CheckFoodOrderValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodOrderId
                });
            }
            return validationMessages;
        }

        public static List<ValidationMessage> CheckMonthlyFoodOrderReportValidationMessages(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckMonthlyFoodOrderReportValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            return validationMessages;
        }

        public static List<ValidationMessage> CheckFoodOrderStatusValidationMessages(ChangeFoodOrderStatusInputModel changeFoodOrderStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderStatusValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (changeFoodOrderStatusInputModel.FoodOrderId == null || changeFoodOrderStatusInputModel.FoodOrderId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderStatusValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking FoodOrderId in CheckFoodOrderStatusValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodOrderId
                });
            }
            if (changeFoodOrderStatusInputModel.IsFoodOrderApproved == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderStatusValidationMessages", "FoodOrderManagementValidationHelper"));
                LoggingManager.Debug("Checking IsFoodOrderApproved in CheckFoodOrderStatusValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodOrderApproveStatus
                });
            }
            if (changeFoodOrderStatusInputModel.IsFoodOrderApproved != null)
            {
                if (changeFoodOrderStatusInputModel.IsFoodOrderApproved == false && string.IsNullOrEmpty(changeFoodOrderStatusInputModel.RejectReason))
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckFoodOrderStatusValidationMessages", "FoodOrderManagementValidationHelper"));
                    LoggingManager.Debug("Checking RejectReason in CheckFoodOrderStatusValidationMessages");
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = LangText.NotEmptyFoodOrderRejectReason
                    });
                }
            }
            return validationMessages;
        }
    }
}
