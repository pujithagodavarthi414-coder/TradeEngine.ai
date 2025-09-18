using Btrak.Models;
using Btrak.Models.Expenses;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers
{
    public class ExpenseValidationHelper
    {
        public List<ValidationMessage> UpsertMerchantCheckValidation(MerchantModel merchantModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Merchant validating LoggedInUser", "Expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(merchantModel.MerchantName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Merchant validating MerchantName", "MerchantName", merchantModel.MerchantName, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMerchantName
                });
            }
            return validationMessages;
        }

        public List<ValidationMessage> GetMerchantByIdValidation(Guid? merchantId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Merchant By Id validating LoggedInUser", "Expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (merchantId == null || merchantId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Merchant By Id validating merchantId", "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMerchantId
                });
            }
            
            return validationMessages;
        }

        public List<ValidationMessage> UpsertExpenseCategoryCheckValidation(UpsertExpenseCategoryApiInputModel upsertExpenseCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Category validating LoggedInUser", "Expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertExpenseCategoryApiInputModel.ExpenseCategoryName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category validating CategoryName", "CategoryName", upsertExpenseCategoryApiInputModel.ExpenseCategoryName, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseCategoryName
                });
            }
            else if (upsertExpenseCategoryApiInputModel.ExpenseCategoryName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category validating Length of CategoryName", "CategoryName", upsertExpenseCategoryApiInputModel.ExpenseCategoryName, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseCategoryName
                });
            }

            if (upsertExpenseCategoryApiInputModel.Description != null)
            {
                if (upsertExpenseCategoryApiInputModel.Description.Length > AppConstants.InputWithMaxSize1000)
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category validating length of Description", "Description", upsertExpenseCategoryApiInputModel.Description, "Expense Service"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MaximumLengthForExpenseCategoryDescription
                    });
                }
            }

            return validationMessages;
        }

        public List<ValidationMessage> UpsertExpenseStatusCheckValidation(UpsertExpenseStatusModel upsertExpenseStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Status Check Validation", "Expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertExpenseStatusModel.Name))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status Check Validation", "Name", upsertExpenseStatusModel.Name, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseStatusName
                });
            }
            else if (upsertExpenseStatusModel.Name.Length > 100)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status validating Name Length", "Name", upsertExpenseStatusModel.Name, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseStatusName
                });
            }
            
            if (upsertExpenseStatusModel.Description?.Length > 1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status validating Description Length", "Description", upsertExpenseStatusModel.Description, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseStatusDescription
                });
            }

            return validationMessages;
        }

        public static bool ExpenseCategoryByIdValidation(Guid? categoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ExpenseCategoryByIdValidation", "categoryId", categoryId, "Expense Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (categoryId == null || categoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseCategoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertExpenseReportValidation(ExpenseReportInputModel expenseReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertExpenseReportValidation", "expenseReportInputModel", expenseReportInputModel, "Expense Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(expenseReportInputModel.ReportTitle))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseReportTitle
                });
            }

            if (!string.IsNullOrEmpty(expenseReportInputModel.ReportTitle))
            {
                if (expenseReportInputModel.ReportTitle.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceededExpenseReportTitle
                    });
                }
               
            }

            if (string.IsNullOrEmpty(expenseReportInputModel.BusinessPurpose))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseBusinessPurpose
                });
            }

            if (!string.IsNullOrEmpty(expenseReportInputModel.BusinessPurpose))
            {
                if (expenseReportInputModel.BusinessPurpose.Length > 1000)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceededExpenseBusinessPurpose
                    });
                }

            }

            if (expenseReportInputModel.DurationFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseDurationFrom
                });
            }

            if (expenseReportInputModel.DurationTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseDurationTo
                });
            }

            if (expenseReportInputModel.DurationFrom != null && expenseReportInputModel.DurationTo != null)
            {
                int value = DateTime.Compare((DateTime)expenseReportInputModel.DurationFrom, (DateTime)expenseReportInputModel.DurationTo);

                if (value > 0)
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DurationFromIsLaterThanDurationTo
                    });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ExpenseStatusByIdValidation(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ExpenseStatusByIdValidation", "statusId", statusId, "Expense Validation Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (statusId == null || statusId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertExpenseReportStatusValidation(UpsertExpenseReportStatusModel upsertExpenseReportStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status Validation", "upsertExpenseReportStatusModel", upsertExpenseReportStatusModel, "Expense Validation Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertExpenseReportStatusModel.Name))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status validating Name", "Name", upsertExpenseReportStatusModel.Name, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseReportStatusName
                });
            }
            else if (upsertExpenseReportStatusModel.Name.Length > 250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status validating Name Length", "Name", upsertExpenseReportStatusModel.Name, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseReportStatusName
                });
            }

            if (upsertExpenseReportStatusModel.Description.Length > 1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status validating Description Length", "Description", upsertExpenseReportStatusModel.Description, "Expense Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseReportStatusDescription
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ExpenseReportStatusByIdValidation(Guid? reportStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ExpenseReportStatusByIdValidation", "reportStatusId", reportStatusId, "Expense Validation Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (reportStatusId == null || reportStatusId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseReportStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ExpenseReportByIdValidation(Guid? expenseReportId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ExpenseReportByIdValidation", "expenseReportId", expenseReportId, "Expense Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (expenseReportId == null || expenseReportId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseReportById
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(expenseUpsertInputModel.ExpenseName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseDescription
                });
            }

            if (expenseUpsertInputModel.ExpenseName?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForExpenseDescription
                });
            }

            //if (expenseUpsertInputModel.ExpenseCategoryId == null || expenseUpsertInputModel.ExpenseCategoryId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyExpenseCategoryId
            //    });
            //}

            if (expenseUpsertInputModel.CurrencyId == null || expenseUpsertInputModel.CurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (expenseUpsertInputModel.BranchId == null || expenseUpsertInputModel.BranchId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBranchId
                });
            }

            //if (expenseUpsertInputModel.Amount == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyAmount
            //    });
            //}

            //if (expenseUpsertInputModel.Amount != null && expenseUpsertInputModel.Amount < 0)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.AmountLessThanZero
            //    });
            //}

            if (expenseUpsertInputModel.ExpenseDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateExpenseById(Guid? expenseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (expenseId == Guid.Empty || expenseId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExpenseId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateExpenseFoundWithId(Guid? expenseId, List<ValidationMessage> validationMessages, ExpenseSpReturnModel expenseSpReturnModel)
        {
            if (expenseSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundExpenseWithTheId, expenseId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool AddMultipleExpensesValidation(List<ExpenseUpsertInputModel> expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AddMultipleExpensesValidation", "expenseUpsertInputModel", expenseUpsertInputModel, "Expense Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            foreach (var expenseUpsertInput in expenseUpsertInputModel)
            {
                if (expenseUpsertInput.ExpenseDate == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyExpenseDate
                    });
                }

                if (expenseUpsertInput.ExpenseCategoryId == null || expenseUpsertInput.ExpenseCategoryId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyExpenseCategoryId
                    });
                }

                if (expenseUpsertInput.CurrencyId == null || expenseUpsertInput.CurrencyId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyExpenseCurrencyId
                    });
                }

                if (expenseUpsertInput.BranchId == null || expenseUpsertInput.BranchId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyBranchId
                    });
                }

                if (expenseUpsertInput.Amount == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyExpensesAmount
                    });
                }

                if (expenseUpsertInput.Description == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyExpensesDescription
                    });
                }

            }

            return validationMessages.Count <= 0;
        }
    }
}
