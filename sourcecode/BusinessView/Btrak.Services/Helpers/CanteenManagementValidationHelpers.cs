using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Canteen;
using BTrak.Common;
using BTrak.Common.Texts;

namespace Btrak.Services.Helpers
{
    public class CanteenManagementValidationHelpers
    {
        public List<ValidationMessage> UpsertCanteenFoodItemValidation(CanteenFoodItemInputModel canteenFoodItemInputModel,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Canteen FoodItem validating LoggedInUser", "Canteen Management Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(canteenFoodItemInputModel.FoodItemName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Canteen FoodItem validating Food Item Name", "Canteen Management Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodItemName
                });
            }

            if (canteenFoodItemInputModel.Price <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Canteen FoodItem validating Price", "Canteen Management Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.InvalidFoodItemPrice
                });
            }

            if (canteenFoodItemInputModel.CurrencyId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Canteen FoodItem validating Currency", "Canteen Management Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyCurrencyId
                });
            }

            return validationMessages;
        }

        public List<ValidationMessage> GetFoodItemByIdValidation(Guid? foodItemId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get FoodItem By Id Validation", "CanteenManagementValidationHelpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (foodItemId == null || foodItemId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get FoodItem By Id Validation", "CanteenManagementValidationHelpers"));
                LoggingManager.Debug("Checking GetFoodItemByIdValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyFoodItemId
                });
            }
            return validationMessages;
        }

        public List<ValidationMessage> CheckCanteenCreditValidationMessages(CanteenCreditInputModel canteenCreditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckCanteenCreditValidationMessages", "CanteenManagementValidationHelpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (canteenCreditInputModel.UserIds == null || canteenCreditInputModel.UserIds.Count < 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckCanteenCreditValidationMessages", "CanteenManagementValidationHelpers"));
                LoggingManager.Debug("Checking UserId in CheckCanteenCreditValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyUserId
                });
            }
            if (canteenCreditInputModel.Amount == null || canteenCreditInputModel.Amount <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckCanteenCreditValidationMessages", "CanteenManagementValidationHelpers"));
                LoggingManager.Debug("Checking Amount in CheckCanteenCreditValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyAmount
                });
            }
            if (canteenCreditInputModel.CurrencyId ==  null || canteenCreditInputModel.CurrencyId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckCanteenCreditValidationMessages", "CanteenManagementValidationHelpers"));
                LoggingManager.Debug("Checking Currency in CheckCanteenCreditValidationMessages");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyCurrencyId
                });
            }
            return validationMessages;
        }

        public List<ValidationMessage> GetCanteenCreditByIdValidation(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Canteen Credit By Id Validation", "CanteenManagementValidationHelpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (userId == null || userId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCanteenCreditByIdValidation", "CanteenManagementValidationHelpers"));
                LoggingManager.Debug("Checking userId in GetCanteenCreditByIdValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyUserId
                });
            }
            return validationMessages;
        }

        public List<ValidationMessage> PurchaseCanteenItemValidation(List<PurchaseCanteenItemInputModel> purchaseCanteenItemInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "PurchaseCanteenItemValidation", "Canteen Management Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (purchaseCanteenItemInputModel == null)
            {
                LoggingManager.Debug("purchaseCanteenItemInputModel is null in PurchaseCanteenItemValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyPurchaseList
                });
            }
            if (purchaseCanteenItemInputModel != null && purchaseCanteenItemInputModel.Count <= 0)
            {
                LoggingManager.Debug("purchaseCanteenItemInputModel is null in PurchaseCanteenItemValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyPurchaseList
                });
            }
            if (purchaseCanteenItemInputModel != null && purchaseCanteenItemInputModel.Count > 0)
            {
                foreach(var purchaseItems in purchaseCanteenItemInputModel)
                {
                    if(purchaseItems.CanteenItemId == null || purchaseItems.CanteenItemId == Guid.Empty)
                    {
                        LoggingManager.Debug("Validating CanteenItemId in PurchaseCanteenItemValidation");
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = LangText.NotEmptyFoodItemName
                        });
                    }
                    if(purchaseItems.Quantity == null || purchaseItems.Quantity <= 0)
                    {
                        LoggingManager.Debug("Validating Qunatity in PurchaseCanteenItemValidation");
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = LangText.FoodItemQuantityIsNotEmpty

                        });
                    }
                }
            }
            return validationMessages;
        }
    }
}
