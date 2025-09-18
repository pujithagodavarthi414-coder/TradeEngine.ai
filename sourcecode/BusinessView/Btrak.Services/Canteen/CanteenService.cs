using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Canteen;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using CanteenFoodItemRepository = Btrak.Dapper.Dal.Partial.CanteenFoodItemRepository;

namespace Btrak.Services.Canteen
{
    public class CanteenService : ICanteenService
    {
        private readonly CanteenManagementValidationHelpers _canteenManagementValidationHelpers;
        private readonly IAuditService _auditService;
        private readonly CanteenFoodItemRepository _canteenFoodItemRepository;
        private readonly UserCanteenCreditRepository _userCanteenCreditRepository;
        private readonly UserPurchasedCanteenFoodItemRepository _userPurchasedCanteenFoodItemRepository;

        public CanteenService(CanteenManagementValidationHelpers canteenManagementValidationHelpers, IAuditService auditService, CanteenFoodItemRepository canteenFoodItemRepository, UserCanteenCreditRepository userCanteenCreditRepository, UserPurchasedCanteenFoodItemRepository userPurchasedCanteenFoodItemRepository)
        {
            _canteenManagementValidationHelpers = canteenManagementValidationHelpers;
            _canteenFoodItemRepository = canteenFoodItemRepository;
            _userCanteenCreditRepository = userCanteenCreditRepository;
            _userPurchasedCanteenFoodItemRepository = userPurchasedCanteenFoodItemRepository;
            _auditService = auditService;
        }

        public Guid? UpsertCanteenFoodItem(CanteenFoodItemInputModel canteenFoodItemInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Canteen Food Item", "canteenFoodItemInputModel", canteenFoodItemInputModel, "Canteen Service"));

            _canteenManagementValidationHelpers.UpsertCanteenFoodItemValidation(canteenFoodItemInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            canteenFoodItemInputModel.ActiveFrom = DateTime.Now;

            Guid? foodItemId = _canteenFoodItemRepository.UpsertCanteenFoodItem(canteenFoodItemInputModel, loggedInContext, validationMessages);

            if (foodItemId != null)
            {
                if (canteenFoodItemInputModel.FoodItemId == foodItemId)
                {
                    LoggingManager.Debug("Canteen Food Item is updated successfully with the Id " + foodItemId);
                }
                else
                {
                    LoggingManager.Debug("Canteen Food Item is inserted successfully with the Id " + foodItemId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertCanteenFoodItemCommandId, canteenFoodItemInputModel, loggedInContext);
            }

            return foodItemId;
        }

        public List<FoodItemApiReturnModel> SearchFoodItems(FoodItemSearchCriteriaInputModel foodItemSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Food Items", "foodItemSearchCriteriaInputModel", foodItemSearchCriteriaInputModel, "Canteen Service"));

            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, foodItemSearchCriteriaInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchFoodItemsCommandId, foodItemSearchCriteriaInputModel, loggedInContext);

            return _canteenFoodItemRepository.SearchCanteenFoodItems(foodItemSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public FoodItemApiReturnModel GetFoodItemById(Guid? foodItemId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get FoodItem By Id", "foodItemId", foodItemId, "Canteen Service"));

            _canteenManagementValidationHelpers.GetFoodItemByIdValidation(foodItemId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var foodItemSearchCriteriaInputModel = new FoodItemSearchCriteriaInputModel {FoodItemId = foodItemId};

            _auditService.SaveAudit(AppCommandConstants.GetFoodItemByIdCommandId, foodItemSearchCriteriaInputModel, loggedInContext);

            var foodItemById = _canteenFoodItemRepository.SearchCanteenFoodItems(foodItemSearchCriteriaInputModel, loggedInContext, validationMessages);

            foreach (var foodItem in foodItemById)
            {
                return foodItem;
            }

            return null;
        }

        public bool? UpsertCanteenCredit(CanteenCreditInputModel canteenCreditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCanteenCredit", "canteenCreditInputModel", canteenCreditInputModel, "CanteenService"));

            _canteenManagementValidationHelpers.CheckCanteenCreditValidationMessages(canteenCreditInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? canteenCreditId = canteenCreditInputModel.CanteenCreditId;

            string listOfUserXml = Utilities.ConvertIntoListXml(canteenCreditInputModel.UserIds);

            bool? canteenCredit = _userCanteenCreditRepository.UpsertCanteenCredit(canteenCreditInputModel, listOfUserXml, loggedInContext, validationMessages);
            LoggingManager.Debug(canteenCreditId?.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCanteenCreditCommandId, canteenCreditInputModel, loggedInContext);
            return canteenCredit;
        }

        public List<CanteenCreditApiOutputModel> SearchCanteenCredit(CanteenCreditSearchInputModel canteenCreditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenCredit", "canteenCreditSearchInputModel", canteenCreditSearchInputModel, "Canteen Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchCanteenCreditCommandId, canteenCreditSearchInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, canteenCreditSearchInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            LoggingManager.Debug("Getting Canteen Credit search list ");
            List<CanteenCreditApiOutputModel> canteenCreditReturnList = _userCanteenCreditRepository.SearchCanteenCredit(canteenCreditSearchInputModel, loggedInContext, validationMessages).ToList();
            
            return canteenCreditReturnList;
        }
      
        public List<CanteenCreditApiOutputModel> GetCanteenCreditByUserId(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCanteenCreditByUserId", "userId", userId, "Canteen Service"));
            
            _canteenManagementValidationHelpers.GetCanteenCreditByIdValidation(userId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            CanteenCreditSearchInputModel canteenCreditSearchInputModel = new CanteenCreditSearchInputModel
            {
                UserId = userId
            };

            _auditService.SaveAudit(AppCommandConstants.GetCanteenCreditByUserIdCommandId, canteenCreditSearchInputModel, loggedInContext);

            LoggingManager.Debug("Getting Canteen Credit Detail by User Id ");
            List<CanteenCreditApiOutputModel> canteenCreditSReturnList = _userCanteenCreditRepository.SearchCanteenCredit(canteenCreditSearchInputModel, loggedInContext, validationMessages).ToList();
            return canteenCreditSReturnList;
        }

        public List<Guid> PurchaseCanteenItem(List<PurchaseCanteenItemInputModel> purchaseCanteenItemInputModel,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "PurchaseCanteenItem", "purchaseCanteenItemInputModel", purchaseCanteenItemInputModel, "CanteenService"));
            _canteenManagementValidationHelpers.PurchaseCanteenItemValidation(purchaseCanteenItemInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            string listOfCanteenItemXml = Utilities.ConvertIntoListXml(purchaseCanteenItemInputModel);
            List<Guid> purchaseResult = _userPurchasedCanteenFoodItemRepository.UpsertPurchasedCanteenFoodItem(listOfCanteenItemXml, isArchived, loggedInContext, validationMessages);
            LoggingManager.Debug("Purchased result" + purchaseResult);
            _auditService.SaveAudit(AppCommandConstants.PurchaseCanteenItemCommandId, purchaseResult, loggedInContext);
            return purchaseResult;
        }

        public List<CanteenPurchaseOutputModel> SearchCanteenPurchases(SearchCanteenPurcahsesInputModel searchCanteenPurchasesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenPurchases", "searchCanteenPurchasesInputModel", searchCanteenPurchasesInputModel, "Canteen Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchCanteenPurchasesCommandId, searchCanteenPurchasesInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, searchCanteenPurchasesInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            LoggingManager.Info("Getting Canteen Purchases list ");
            List<CanteenPurchaseOutputModel> canteenPurchaseReturnList = _userPurchasedCanteenFoodItemRepository.SearchCanteenPurchases(searchCanteenPurchasesInputModel, loggedInContext, validationMessages).ToList();
            return canteenPurchaseReturnList;
        }

        public List<CanteenBalanceApiOutputModel> SearchCanteenBalance(SearchCanteenBalanceInputModel searchCanteenBalanceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenBalance", "searchCanteenBalanceInputModel", searchCanteenBalanceInputModel, "Canteen Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchCanteenBalanceCommandId, searchCanteenBalanceInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, searchCanteenBalanceInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            LoggingManager.Info("Getting Canteen Balance list ");
            List<CanteenBalanceApiOutputModel> canteenBalanceReturnList = _userPurchasedCanteenFoodItemRepository.SearchCanteenBalance(searchCanteenBalanceInputModel, loggedInContext, validationMessages).ToList();           
            return canteenBalanceReturnList;
        }
    }
}
