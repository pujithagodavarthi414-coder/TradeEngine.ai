using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Products;
using BTrak.Common;

namespace Btrak.Services.Helpers.ProductValidationHelpers
{
    public class ProductValidationHelper
    {
        public static bool UpsertProductValidation(ProductInputModel productModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProductValidation", "productModel", productModel, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(productModel.ProductName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Product name is required", "Product Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductNameIsRequired
                });
            }

            if (!string.IsNullOrEmpty(productModel.ProductName))
            {
                if (productModel.ProductName.Length > 250)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                        "Product name is required", "Product Service"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ProductNameLengthExceeds
                    });
                }
            }

            if (validationMessages.Count > 0)
            {
                return false;
            }

            return true;
        }

        public static bool UpsertProductDetailsValidation(ProductDetailsInputModel productDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProductDetailsValidation", "productDetailsModel", productDetailsModel, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (productDetailsModel.ProductId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Product id is required", "Product Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductIdIsRequired
                });
            }

            if (productDetailsModel.SupplierId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "supplier id is required", "Product Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SupplierIdIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ProductByIdValidation(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ProductByIdValidation", "productId", productId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (productId == null || productId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Approved by user is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductByIdIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ProductDetailsByIdValidation(Guid? productDetailsId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ProductByIdValidation", "productDetailsId", productDetailsId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (productDetailsId == null || productDetailsId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Approved by user is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductDetailsByIdIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
