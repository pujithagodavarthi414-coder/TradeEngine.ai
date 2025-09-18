using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.BillingManagementValidationHelpers
{
    public class ExpenseValidations
    {
        public static bool ValidateUpsertExpenseCategory(UpsertExpenseCategoryInputModel upsertExpenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(upsertExpenseCategoryInputModel.CategoryName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCategoryName
                });
            }

            if (!string.IsNullOrEmpty(upsertExpenseCategoryInputModel.CategoryName) && upsertExpenseCategoryInputModel.CategoryName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CategoryNameLengthExceeded
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertExpenseMerchant(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(upsertExpenseMerchantInputModel.MerchantName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMerchantName
                });
            }

            if (!string.IsNullOrEmpty(upsertExpenseMerchantInputModel.MerchantName) && upsertExpenseMerchantInputModel.MerchantName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MerchantNameLengthExceeded
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
