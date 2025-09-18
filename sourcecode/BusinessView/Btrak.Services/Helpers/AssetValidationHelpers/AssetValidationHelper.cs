using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Assets;
using Btrak.Models.SeatingArrangement;
using BTrak.Common;

namespace Btrak.Services.Helpers.AssetValidationHelpers
{
    public class AssetValidationHelper
    {
        public static bool UpsertAssertValidation(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertAssertValidation", "assetDetailsModel", assetDetailsModel, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (assetDetailsModel.IsWriteOff)
            {
                if (string.IsNullOrEmpty(assetDetailsModel.DamagedReason))
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Damaged Reason is required", "Asset Validation Helper"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DamagedReasonIsRequired
                    });
                }
                if (assetDetailsModel.DamagedDate == null)
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Damaged date is required", "Asset Validation Helper"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DamagedDateIsRequired
                    });
                }
            }

            if (string.IsNullOrEmpty(assetDetailsModel.AssetNumber))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Asset Number is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AssetNumberIsRequired
                });
            }

            if (!string.IsNullOrEmpty(assetDetailsModel.AssetNumber))
            {
                assetDetailsModel.AssetNumber = assetDetailsModel.AssetNumber.Trim();
                if (assetDetailsModel.AssetNumber.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.AssetNumberLengthValidation)
                    });
                }
            }

            if (string.IsNullOrEmpty(assetDetailsModel.AssetName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "asset name is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AssetNameIsRequired
                });
            }

            if (!string.IsNullOrEmpty(assetDetailsModel.AssetName))
            {
                if (assetDetailsModel.AssetName.Length > 50)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                        "asset name exceeds", "Asset Validation Helper"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.AssetNameLengthExceeds
                    });
                }
            }

            if (assetDetailsModel.ProductDetailsId == Guid.Empty)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Product Details Id", "Asset Validation Helper"));
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductIdIsRequired
                });
            }

            if (assetDetailsModel.ApprovedByUserId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Approved by user is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ApprovedByIsRequired
                });
            }

            if (assetDetailsModel.Cost == null || assetDetailsModel.Cost <= 0)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Cost is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CostRequired
                });
            }

            if (assetDetailsModel.CurrencyId == Guid.Empty)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Currency type is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CurrencyTypeIsRequired
                });
            }
          
            return validationMessages.Count <= 0;
        }

        public static bool AssetByIdValidation(Guid? assetId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Asset ById Validation", "assetId", assetId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (assetId == null || assetId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Approved by user is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AssetByIdIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSeatingArrangementValidation(SeatingArrangementInputModel seatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Seating Arrangement Validation", "seatingModel", seatingModel, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (seatingModel.BranchId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Branch Id is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBranchId
                });
            }
            if (string.IsNullOrEmpty(seatingModel.SeatCode))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "seat code is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SeatCodeIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetSeatingArrangementById(Guid? seatingArrangementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSeatingArrangementById", "seatingArrangementId", seatingArrangementId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (seatingArrangementId == null || seatingArrangementId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "seating Arrangement Id is required", "Asset Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.SeatingArrangementByIdIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetCommentsAndHistoryValidation(Guid? assetId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCommentsAndHistoryValidation", "assetId", assetId, "Asset Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            //if (assetId == Guid.Empty)
            //{
            //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Asset id is required", "Asset Service"));
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyOperationsPerformedBy
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool ValidateAssetFoundWithId(Guid? assetId, List<ValidationMessage> validationMessages, AssetsOutputModel assetDetails)
        {
            if (assetDetails == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundAssetWithTheId, assetId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
