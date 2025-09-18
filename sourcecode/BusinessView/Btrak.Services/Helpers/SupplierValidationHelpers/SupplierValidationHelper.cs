using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Btrak.Models;
using Btrak.Models.Supplier;
using BTrak.Common;

namespace Btrak.Services.Helpers.SupplierValidationHelpers
{
    public class SupplierValidationHelper
    {
        public static bool UpsertSupplierValidation(SupplierDetailsInputModel supplierInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSupplierValidation", "supplierInputModel", supplierInputModel, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(supplierInputModel.SupplierName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Supplier name is required", "Supplier Service"));

                validationMessages.Add(new ValidationMessage
                {
                    Field = "SupplierName",
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SupplierNameIsRequired
                });
            }

            if (!string.IsNullOrEmpty(supplierInputModel.SupplierName))
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Supplier name exceeds", "Supplier Service"));
                if (supplierInputModel.SupplierName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        Field = "SupplierName",
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.SupplierNameLengthExceeds
                    });
                }
            }

            if (supplierInputModel.StartedWorkingFrom == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "started working from is required", "Supplier Service"));

                validationMessages.Add(new ValidationMessage
                {
                    Field = "StartedWorkingFrom",
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.StartedWorkingFromIsRequired
                });
            }

            if (!string.IsNullOrEmpty(supplierInputModel.CompanyPhoneNumber) && !Regex.Match(supplierInputModel.CompanyPhoneNumber, @"^[-+]?\d*$").Success)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Invalid Company phone number", "Supplier Service"));

                validationMessages.Add(new ValidationMessage
                {
                    Field = "CompanyPhoneNumber",
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.InvalidCompanyPhoneNumber
                });
            }

            if (!string.IsNullOrEmpty(supplierInputModel.ContactPhoneNumber) && !Regex.Match(supplierInputModel.ContactPhoneNumber, @"^[-+]?\d*$").Success)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Invalid contact phone number", "Supplier Service"));

                validationMessages.Add(new ValidationMessage
                {
                    Field = "ContactPhoneNumber",
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.InvalidContactPhoneNumber
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool SupplierByIdValidation(Guid? supplierId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SupplierByIdValidation", "supplierId", supplierId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (supplierId == null || supplierId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SupplierIdIsRequired
                });
            }
           
            return validationMessages.Count <= 0;
        }
    }
}
