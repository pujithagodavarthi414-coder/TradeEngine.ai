using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Assets;
using Btrak.Models.Branch;
using Btrak.Models.SeatingArrangement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.AssetValidationHelpers;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Btrak.Services.Chromium;
using Btrak.Services.ActivityTracker;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using System.Configuration;
using Btrak.Models.Notification;
using Btrak.Services.Notification;
using BTrak.Common.Constants;
using Hangfire;
using Btrak.Services.Email;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;

namespace Btrak.Services.Assets
{
    public class AssetServices : IAssetServices
    {
        private readonly AssetRepository _assetRepository = new AssetRepository();
        private readonly ProductDetailRepository _productDetailRepository = new ProductDetailRepository();
        private readonly SeatingArrangementRepository _seatingArrangementRepository = new SeatingArrangementRepository();
        private readonly AuditService _auditService = new AuditService();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly BranchRepository _branchRepository = new BranchRepository();
        private readonly MasterTableRepository _masterTableRepository = new MasterTableRepository();
        private readonly IChromiumService _chromiumService;
        private readonly IActivityTrackerService _activityTrackerService;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly INotificationService _notificationService;
        private readonly IEmailService _emailService;
        private readonly ICompanyStructureService _companyStructureService;

        public AssetServices(ICompanyStructureService companyStructureServiece,IChromiumService chromiumService, IActivityTrackerService activityTrackerService, INotificationService notificationService,IEmailService emailService)
        {
            _chromiumService = chromiumService;
            _activityTrackerService = activityTrackerService;
            _notificationService = notificationService;
            _emailService = emailService;
            _companyStructureService = companyStructureServiece;
        }

        public Guid? UpsertAsset(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Asset Started", "assetDetailsModel", assetDetailsModel, "Asset Api"));
            LoggingManager.Debug(assetDetailsModel.ToString());
            AssetAuditModel assetAuditModel = new AssetAuditModel();
            Guid? assetId = assetDetailsModel.AssetId;
            string fullname = _userRepository.UserDetails(loggedInContext.LoggedInUserId).FullName;

            if (!AssetValidationHelper.UpsertAssertValidation(assetDetailsModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (assetDetailsModel.IsSelfApproved)
            {
                assetDetailsModel.ApprovedByUserId = loggedInContext.LoggedInUserId;
            }

            if (assetDetailsModel.AssetId == Guid.Empty || assetDetailsModel.AssetId == null)
            {
                assetDetailsModel.IsToSendNotification = true;
                assetDetailsModel.PurchasedDate = assetDetailsModel.PurchasedDate ?? DateTime.Now;
                assetId = _assetRepository.UpsertAsset(assetDetailsModel, loggedInContext, validationMessages);

                if (assetId != Guid.Empty && assetId != null)
                {
                    AssetDetailsModel assetDetails = _assetRepository.GetAssetById(assetId, loggedInContext, validationMessages);
                    if (assetDetails != null)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "Asset",
                            OldValue = assetDetailsModel.AssetNumber + '(' + assetDetailsModel.AssetName + ')',
                            NewValue = assetDetails.AssignedToEmployeeName,
                            OldValueText = assetDetailsModel.AssetName + '(' + assetDetailsModel.AssetName + ')',
                            NewValueText = assetDetails.AssignedToEmployeeName,
                            Description = "AssetIsNewlyAssignedTo",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                }
            }

            if (assetDetailsModel.AssetId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Asset with not null identifier", "Asset Service"));

                AssetSearchCriteriaInputModel assetSearchCriteriaModel = new AssetSearchCriteriaInputModel { AssetId = assetDetailsModel.AssetId, ActiveAssignee = assetDetailsModel.ActiveAssignee };
                AssetsOutputModel assetDetails = _assetRepository.SearchAssets(assetSearchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();

                if (assetDetails == null)
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Asset not found with the identifier", "Asset Service"));

                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.AssetDetailsNotFound
                    });
                }
                else
                {
                    if (assetDetailsModel.IsWriteOff != assetDetails.IsWriteOff)
                    {
                        string damagedByUser = _userRepository.UserDetails(assetDetailsModel.DamagedByUserId).FullName;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "IsWriteOff",
                            OldValue = assetDetailsModel.AssetNumber,
                            NewValue = assetDetailsModel.DamagedByUserId.ToString(),
                            OldValueText = assetDetailsModel.AssetNumber,
                            NewValueText = damagedByUser,
                            Description = "AssetIsWriteOffChange",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.AssetNumber.ToLower() != assetDetails.AssetNumber.ToLower())
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "AssetNumber",
                            OldValue = assetDetails.AssetNumber,
                            NewValue = assetDetailsModel.AssetNumber,
                            OldValueText = assetDetails.AssetNumber,
                            NewValueText = assetDetailsModel.AssetNumber,
                            Description = "AssetNumberChange",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.AssetName.ToLower() != assetDetails.AssetName.ToLower())
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "AssetName",
                            OldValue = assetDetails.AssetName,
                            NewValue = assetDetailsModel.AssetName,
                            OldValueText = assetDetails.AssetName,
                            NewValueText = assetDetailsModel.AssetName,
                            Description = "AssetNameChange",
                            FullName = fullname


                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.ProductDetailsId != assetDetails.ProductDetailsId)
                    {

                        string oldProductName = _productDetailRepository.GetProductDetailsById(assetDetails.ProductDetailsId, loggedInContext.LoggedInUserId, validationMessages).ProductName;
                        string newProductName = _productDetailRepository.GetProductDetailsById(assetDetailsModel.ProductDetailsId, loggedInContext.LoggedInUserId, validationMessages).ProductName;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "ProductId",
                            OldValue = assetDetails.ProductDetailsId.ToString(),
                            NewValue = assetDetailsModel.ProductDetailsId.ToString(),
                            OldValueText = oldProductName,
                            NewValueText = newProductName,
                            Description = "AssetProductNameChange",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.AssignedToEmployeeId != assetDetails.AssignedToEmployeeId)
                    {
                        string oldEmployeeName = assetDetails.AssignedToEmployeeName;
                        string newEmployeeName = _userRepository.UserDetails(assetDetailsModel.AssignedToEmployeeId).FullName;

                        assetDetailsModel.IsToSendNotification = true;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "AssignedToEmployeeId",
                            OldValue = assetDetails.AssignedToEmployeeId.ToString(),
                            NewValue = assetDetailsModel.AssignedToEmployeeId.ToString(),
                            OldValueText = oldEmployeeName,
                            NewValueText = newEmployeeName,
                            Description = "AssetAssignedToEmployeeChange",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.ApprovedByUserId != assetDetails.ApprovedByUserId)
                    {
                        string oldEmployeeName = _userRepository.UserDetails(assetDetails.ApprovedByUserId)?.FirstName;

                        string newEmployeeName = _userRepository.UserDetails(assetDetailsModel.ApprovedByUserId).FullName;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "ApprovedByUserId",
                            OldValue = assetDetails.ApprovedByUserId.ToString(),
                            NewValue = assetDetailsModel.ApprovedByUserId.ToString(),
                            OldValueText = oldEmployeeName,
                            NewValueText = newEmployeeName,
                            Description = "AssetApprovedByUserChange",
                            FullName = fullname
                        };

                        //assetCompare.Description = "Asset <b>approved by</b> changed from &nbsp;<b><i>" + oldEmployeeName + "</i></b>&nbsp; to&nbsp;<b><i>" + newEmployeeName + "</i></b><br/>";
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.Cost != assetDetails.Cost)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "Cost",
                            OldValue = assetDetails.Cost.ToString(),
                            NewValue = assetDetailsModel.Cost.ToString(),
                            OldValueText = assetDetails.Cost.ToString(),
                            NewValueText = assetDetailsModel.Cost.ToString(),
                            Description = "AssetCostChange",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.CurrencyId != assetDetails.CurrencyId)
                    {
                        string oldCurrencyType = _masterTableRepository.GetCurrencyById(loggedInContext, assetDetails.CurrencyId, validationMessages).CurrencyType;
                        string newCurrencyType = _masterTableRepository.GetCurrencyById(loggedInContext, assetDetailsModel.CurrencyId, validationMessages).CurrencyType;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "CurrencyId",
                            OldValue = assetDetails.CurrencyId.ToString(),
                            NewValue = assetDetailsModel.CurrencyId.ToString(),
                            OldValueText = oldCurrencyType,
                            NewValueText = newCurrencyType,
                            Description = "AssetCurrencyChange",
                            FullName = fullname

                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.PurchasedDate != assetDetails.PurchasedDate)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "PurchasedDate",
                            OldValue = assetDetails.PurchasedDate.HasValue ? assetDetails.PurchasedDate.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            NewValue = assetDetailsModel.PurchasedDate.HasValue ? assetDetailsModel.PurchasedDate.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            OldValueText = assetDetails.PurchasedDate.HasValue ? assetDetails.PurchasedDate.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            NewValueText = assetDetailsModel.PurchasedDate.HasValue ? assetDetailsModel.PurchasedDate.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            Description = "AssetPurchasedDateChange",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.AssignedDateFrom != assetDetails.AssignedDateFrom)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "AssignedDateFrom",
                            OldValue = assetDetails.AssignedDateFrom.HasValue ? assetDetails.AssignedDateFrom.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            NewValue = assetDetailsModel.AssignedDateFrom.HasValue ? assetDetailsModel.AssignedDateFrom.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            OldValueText = assetDetails.AssignedDateFrom.HasValue ? assetDetails.AssignedDateFrom.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            NewValueText = assetDetailsModel.AssignedDateFrom.HasValue ? assetDetailsModel.AssignedDateFrom.Value.ToString("dd'-'MMM'-'yyyy") : string.Empty,
                            Description = "AssetAssignedDateFromChange",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.IsEmpty != assetDetails.IsEmpty)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "IsEmpty",
                            OldValue = assetDetails.IsEmpty.ToString(),
                            NewValue = assetDetailsModel.IsEmpty.ToString(),
                            OldValueText = assetDetails.IsEmpty.ToString(),
                            NewValueText = assetDetailsModel.IsEmpty.ToString(),
                            Description = "AssetIsEmptyChange",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.IsVendor != assetDetails.IsVendor)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "IsVendor",
                            OldValue = assetDetails.IsVendor.ToString(),
                            NewValue = assetDetailsModel.IsVendor.ToString(),
                            OldValueText = assetDetails.IsVendor.ToString(),
                            NewValueText = assetDetailsModel.IsVendor.ToString(),
                            Description = "AssetIsVendorChange",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.SeatingId != assetDetails.SeatingId)
                    {
                        SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModelOld = new SeatingSearchCriteriaInputModel { SeatingId = assetDetails.SeatingId };
                        string oldSeatType = _seatingArrangementRepository.SearchSeating(seatingSearchCriteriaInputModelOld, loggedInContext, validationMessages).FirstOrDefault()?.SeatCode;
                        SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModelNew = new SeatingSearchCriteriaInputModel { SeatingId = assetDetailsModel.SeatingId, IsArchived = false };
                        string newSeatType = _seatingArrangementRepository.SearchSeating(seatingSearchCriteriaInputModelNew, loggedInContext, validationMessages).FirstOrDefault()?.SeatCode;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "SeatingId",
                            OldValue = assetDetails.SeatingId.ToString(),
                            NewValue = assetDetailsModel.SeatingId.ToString(),
                            OldValueText = oldSeatType,
                            NewValueText = newSeatType,
                            Description = "AssetSeatingCodeChanged",
                            FullName = fullname
                        };

                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.BranchId != assetDetails.BranchId)
                    {
                        BranchSearchInputModel branchSearchInputModelNew = new BranchSearchInputModel { BranchId = assetDetailsModel.BranchId, IsArchived = false };
                        string newBranchName = _branchRepository.GetAllBranches(branchSearchInputModelNew, loggedInContext, validationMessages).FirstOrDefault()?.BranchName;

                        BranchSearchInputModel branchSearchInputModelOld = new BranchSearchInputModel { BranchId = assetDetails.BranchId };
                        string oldBranchName = _branchRepository.GetAllBranches(branchSearchInputModelOld, loggedInContext, validationMessages).FirstOrDefault()?.BranchName;

                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "BranchId",
                            OldValue = assetDetails.BranchId.ToString(),
                            NewValue = assetDetailsModel.BranchId.ToString(),
                            OldValueText = oldBranchName,
                            NewValueText = newBranchName,
                            Description = "AssetBranchChanged",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetDetailsModel.AssetUniqueNumber != assetDetails.AssetUniqueNumber)
                    {
                        AssetAuditFields assetCompare = new AssetAuditFields
                        {
                            FieldName = "AssetUniqueNumber",
                            OldValue = assetDetails.AssetUniqueNumber,
                            NewValue = assetDetailsModel.AssetUniqueNumber,
                            OldValueText = assetDetails.AssetUniqueNumber,
                            NewValueText = assetDetailsModel.AssetUniqueNumber,
                            Description = string.IsNullOrEmpty(assetDetails.AssetUniqueNumber) ? "AssetUniqueNumberIs" : "AssetUniqueNumberChanged",
                            FullName = fullname
                        };
                        assetAuditModel.AssetsFieldsChangedList.Add(assetCompare);
                    }
                    if (assetAuditModel.AssetsFieldsChangedList.Count > 0 || !String.IsNullOrEmpty(assetDetailsModel.AssetUniqueNumber))
                    {
                        assetId = _assetRepository.UpsertAsset(assetDetailsModel, loggedInContext, validationMessages);
                        _activityTrackerService.GetChatActivityTrackerRecorder(loggedInContext, validationMessages, true);
                    }
                }
            }

            if (assetId != null && assetId != Guid.Empty && (assetAuditModel.AssetsFieldsChangedList.Count > 0))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Asset History Saving", "Asset Service"));
                _assetRepository.SaveAssetsHistory(assetId, JsonConvert.SerializeObject(assetAuditModel), loggedInContext);
            }

            if (assetDetailsModel.IsToSendNotification != null && assetDetailsModel.IsToSendNotification == true)
            {
                _notificationService.SendNotification(new AssetNotificationModel(
                                string.Format(NotificationSummaryConstants.AssetsAssigned, assetDetailsModel.AssetName, assetDetailsModel.AssetNumber),
                                loggedInContext.LoggedInUserId,
                                assetDetailsModel.AssignedToEmployeeId,
                                assetDetailsModel.AssetId,
                                assetDetailsModel.AssetName,
                                assetDetailsModel.AssetNumber
                                ), loggedInContext, assetDetailsModel.AssignedToEmployeeId);

                var assetsChange = new List<AssetsMultipleUpdateReturnModel>();
                var asset = new AssetsMultipleUpdateReturnModel();
                asset.AssetNumber = assetDetailsModel.AssetNumber;
                asset.AssetName = assetDetailsModel.AssetName;
                assetsChange.Add(asset);
                BackgroundJob.Enqueue(() => AssetNotificationMailSending(assetsChange, assetDetailsModel.AssignedToEmployeeId, loggedInContext, validationMessages));
            }

            if (assetId != Guid.Empty && assetId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Asset audit saving", "Asset Service"));
                _auditService.SaveAudit(AppCommandConstants.UpsertAssetCommandId, assetAuditModel, loggedInContext);
                return assetId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Asset", "Asset Service"));
            return null;
        }

        public List<AllUsersAssetsModel> GetAllUsersAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<AllUsersAssetsModel> assets = _assetRepository.GetAllUsersAssets(assetSearchCriteriaModel, loggedInContext, validationMessages).ToList();
            return assets;
        }

        public List<AssetsMultipleUpdateReturnModel> UpdateAssigneeForMultipleAssets(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<AssetsMultipleUpdateReturnModel> assets = _assetRepository.UpdateAssigneeForMultipleAssets(assetDetailsModel, loggedInContext, validationMessages).ToList();

            if (assets[0].FailedCount == 0)
            {

                foreach (var asset in assets)
                {
                    _notificationService.SendNotification(new AssetNotificationModel(
                                    string.Format(NotificationSummaryConstants.AssetsAssigned, asset.AssetName, asset.AssetNumber),
                                    loggedInContext.LoggedInUserId,
                                    assetDetailsModel.AssignedToEmployeeId,
                                    asset.AssetId,
                                    asset.AssetName,
                                    asset.AssetNumber
                                    ), loggedInContext, assetDetailsModel.AssignedToEmployeeId);
                }

                BackgroundJob.Enqueue(() => AssetNotificationMailSending(assets, assetDetailsModel.AssignedToEmployeeId, loggedInContext, validationMessages));
            }
            return assets;
        }

        public List<AssetsOutputModel> SearchAllAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchAllAssets", "assetSearchCriteriaModel", assetSearchCriteriaModel, "Asset Service"));
            LoggingManager.Debug(assetSearchCriteriaModel.ToString());
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, assetSearchCriteriaModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            _auditService.SaveAudit(AppCommandConstants.SearchAssetsCommandId, assetSearchCriteriaModel, loggedInContext);

            return _assetRepository.SearchAssets(assetSearchCriteriaModel, loggedInContext, validationMessages)?.ToList();
        }

        public int? GetAssetsCount(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Assets Count", "Asset Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var assetsOutputModel = _assetRepository.SearchAssets(assetSearchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();

            int? assetCount = assetsOutputModel != null ? assetsOutputModel.TotalCount : 0;

            LoggingManager.Info("assetCount : " + assetCount);

            return assetCount;
        }

        public AssetsOutputModel GetMyAsset(Guid userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAssetById", "assetId", loggedInContext.LoggedInUserId, "Asset Service"));

            AssetSearchCriteriaInputModel assetSearchCriteriaModel = new AssetSearchCriteriaInputModel();

            AssetsOutputModel assetDetails = _assetRepository.SearchAssets(assetSearchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();

            return assetDetails;
        }

        public Guid? UpsertSeatingArrangement(SeatingArrangementInputModel seatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Seating Arrangement Started", "seatingModel", seatingModel, "Asset Api"));
            if (seatingModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.SeatingModelEmpty)
                });
                return null;
            }
            LoggingManager.Debug(seatingModel.ToString());

            if (!AssetValidationHelper.UpsertSeatingArrangementValidation(seatingModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? seatingArrangementId = _seatingArrangementRepository.UpsertSeatingArrangement(seatingModel, loggedInContext, validationMessages);

            if (seatingArrangementId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Seating Arrangement", "Asset Service"));
                _auditService.SaveAudit(AppCommandConstants.UpsertSeatingCommandId, seatingModel, loggedInContext);
                return seatingArrangementId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Seating Arrangement", "Asset Service"));
            LoggingManager.Debug(seatingModel.ToString());
            return null;
        }

        public List<SeatingArrangementOutputModel> GetAllSeatingArrangement(SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Seating Arrangement", "Asset Service"));
            LoggingManager.Debug(seatingSearchCriteriaInputModel.ToString());
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, seatingSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            var seatingArrangementList = _seatingArrangementRepository.SearchSeating(seatingSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Seating Arrangement List", "Asset Service"));
            return seatingArrangementList;
        }

        public SeatingArrangementOutputModel GetSeatingArrangementById(Guid? seatingArrangementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSeatingArrangementById", "seatingArrangementId", seatingArrangementId, "Asset Service"));
            if (!AssetValidationHelper.GetSeatingArrangementById(seatingArrangementId, loggedInContext, validationMessages))
            {
                return null;
            }

            SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModel = new SeatingSearchCriteriaInputModel()
            {
                SeatingId = seatingArrangementId
            };
            SeatingArrangementOutputModel seatingDetails = _seatingArrangementRepository.SearchSeating(seatingSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            LoggingManager.Debug("seating arrangement id : " + seatingArrangementId);
            return validationMessages.Any() ? null : seatingDetails;
        }

        public List<AssetsDashboardOutputModel> GetAllAssetsAssignedToEmployees(AssetSearchCriteriaInputModel assertSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllAssetsAssignedToEmployees", "assertSearchModel", assertSearchModel, "Asset Service"));
            LoggingManager.Debug(assertSearchModel.ToString());
            List<AssetsDashboardOutputModel> assetDetailsList = _assetRepository.GetAssetsAssignedToEmployees(assertSearchModel, loggedInContext, validationMessages);
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Exiting Assets Assigned To Employees", "Asset Service"));
            return assetDetailsList;
        }

        public List<AssetDetailsModel> GetAllAssets(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Assets", "Assets Service"));
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, null, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Assets List", "Assets Service"));
            return _assetRepository.GetAllAssets(loggedInContext).ToList();
        }

        public List<AssetCommentsAndHistoryOutputModel> GetCommentsAndHistory(AssetCommentAndHistorySearchCriteriaInputModel assetCommentAndHistorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Assets Comments and History", "AssetCommentAndHistorySearchCriteriaInputModel", assetCommentAndHistorySearchCriteriaInputModel, "Asset Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAssetCommentsAndHistoryCommandId, assetCommentAndHistorySearchCriteriaInputModel, loggedInContext);
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Asset Comments And History", "Assets Service"));

            List<AssetCommentsAndHistoryOutputModel> assetCommentsAndHistory = _assetRepository.GetAssetCommentsAndHistory(assetCommentAndHistorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            assetCommentsAndHistory = assetCommentsAndHistory.Select(ConvertToHistoryReturnModel).ToList();

            return assetCommentsAndHistory;
        }

        private static AssetCommentsAndHistoryOutputModel ConvertToHistoryReturnModel(AssetCommentsAndHistoryOutputModel historyModel)
        {
            AssetCommentsAndHistoryOutputModel returnModel = new AssetCommentsAndHistoryOutputModel
            {
                CreatedByUserId = historyModel.CreatedByUserId,
                FullName = historyModel.FullName,
                ProfileImage = historyModel.ProfileImage,
                CreatedDateTime = historyModel.CreatedDateTime,
                AssetHistoryId = historyModel.AssetHistoryId,
                TotalCount = historyModel.TotalCount,
                AssetsFieldsChangedList = (historyModel.AssetHistoryJson != null) ?
                JsonConvert.DeserializeObject<AssetAuditHistoryModel>(historyModel.AssetHistoryJson).AssetsFieldsChangedList : new List<AssetAuditFieldsHistory>(),
                Comment = historyModel.Comment
            };

            return returnModel;
        }

        public async Task<byte[]> PrintAssets(AssetFileInputModel assetFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "PrintAssets", "assetFileInputModel", assetFileInputModel, "Asset Service"));

            _auditService.SaveAudit(AppCommandConstants.PrintAssetsCommandId, assetFileInputModel, loggedInContext);

            AssetSearchCriteriaInputModel assetSearchCriteriaModel = new AssetSearchCriteriaInputModel { UserId = assetFileInputModel.UserId };

            List<AssetsOutputModel> assetDetails = _assetRepository.SearchAssets(assetSearchCriteriaModel, loggedInContext, validationMessages).ToList();

            CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
            var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
            
            if (assetDetails.Count > 0)
            {
                string mytable = "<br><img src=\""+ CompanyLogo +"\"><center><p id=\"para\" >" + assetDetails[0].AssignedToEmployeeName + "</p></center>";
                mytable += "<center><p id=\"para\">" + assetDetails[0].BranchName + "</p><br></center>";
                mytable += "<center><table class=\"a\">";
                mytable += "<tr><th class=\"b\"><center>S.no</center></th>";
                mytable += "<th class=\"b\"><center>Asset code</center></th>";
                mytable += "<th class=\"b\"><center>Asset Name</center></th>";
                mytable += "<th class=\"b\"><center>Assigned to</center></th>";
                mytable += "<th class=\"b\"><center>Assigned by</center></th>";
                mytable += "<th class=\"b\"><center>Assign date</center></th></tr>";
                int i = 1;
                foreach (var assets in assetDetails)
                {
                    if (assets.IsSelfApproved == true)
                    {
                        mytable += "<tr><td class=\"b\"><center>" + i + "</center></td>";
                        mytable += "<td class=\"b\"><center>" + assets.AssetNumber + "</center></td>";
                        mytable += "<td class=\"b\"><center>" + assets.AssetName + "</center></td>";
                        mytable += "<td class=\"b\"><center>" + assets.AssignedToEmployeeName + "</center></td>";
                        mytable += "<td class=\"b\"><center>" + assets.ApprovedByEmployeeName + "</center></td>";
                        mytable += "<td class=\"b\"><center>" + assets.AssignedDateFrom?.ToString("dd-MMM-yyyy") + "</center></td>";
                        mytable += "</tr>";
                        i = i + 1;
                    }
                }
                mytable += "</table><center>";

                var html = _goalRepository.GetHtmlTemplateByName("AssetsTemplate", loggedInContext.CompanyGuid).Replace("##assetsListJson##", mytable).Replace("##assignedToName##", assetFileInputModel.FileName);

                var pdfOutput = await _chromiumService.GeneratePdf(html, null, assetFileInputModel.FileName);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Service"));

                LoggingManager.Debug(pdfOutput.ByteStream.ToString());

                return pdfOutput.ByteStream;
            }

            return null;
        }

        public bool AssetNotificationMailSending(List<AssetsMultipleUpdateReturnModel> assetsInputModel, Guid assignee, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);
            var userSearchCriteriaInputModel = new Models.User.UserSearchCriteriaInputModel { UserId = assignee };
            var assetNames = string.Join(",", assetsInputModel.Select(p => p.AssetName).ToList());
            var assetNumbers = string.Join(",", assetsInputModel.Select(p => p.AssetNumber).ToList());

            List<UserOutputModel> userOutputModel = _userRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);
            var html = _goalRepository.GetHtmlTemplateByName("AssetNotificationTemplate", loggedInContext.CompanyGuid);
            var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/dashboard/profile/" + assignee.ToString() + "/assets";
            html = html.Replace("##userName##", userOutputModel[0].FullName).
                    Replace("##assets##", assetNames).
                    Replace("##assetNumbers##", assetNumbers).
                    Replace("##siteAddress##", siteAddress);
            if (userOutputModel[0].Email != null)
            {
                var toMails = userOutputModel[0].Email.Split('\n');
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Asset assigned notification",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            return true;
        }
    }
}