using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Canteen;
using BTrak.Common;

namespace Btrak.Services.Canteen
{
    public interface ICanteenService
    {
        Guid? UpsertCanteenFoodItem(CanteenFoodItemInputModel canteenFoodItemInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FoodItemApiReturnModel> SearchFoodItems(FoodItemSearchCriteriaInputModel foodItemSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FoodItemApiReturnModel GetFoodItemById(Guid? foodItemId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? UpsertCanteenCredit(CanteenCreditInputModel canteenCreditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CanteenCreditApiOutputModel> SearchCanteenCredit(CanteenCreditSearchInputModel canteenCreditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CanteenCreditApiOutputModel> GetCanteenCreditByUserId(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> PurchaseCanteenItem(List<PurchaseCanteenItemInputModel> purchaseCanteenItemInputModel,bool? IsArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CanteenPurchaseOutputModel> SearchCanteenPurchases(SearchCanteenPurcahsesInputModel searchCanteenPurcahsesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CanteenBalanceApiOutputModel> SearchCanteenBalance(SearchCanteenBalanceInputModel searchCanteenBalanceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //void AddOrUpdateUserCanteenCredit(CreditUserApiInputModel creditUserApiInputModel, LoggedInContext loggedInContext);
        //void AddOrUpdatePurchasedCanteenFoodItem(List<PurchaseFoodItemList> canteenFoodItemModels, LoggedInContext loggedInContext);
        //bool HaveSufficientBalanceForMakingThisPurchase(List<PurchaseFoodItemList> canteenFoodItemModels, LoggedInContext loggedInContext);
        //CanteenFoodItemModel GetFoodItem(Guid foodItemId);
        //decimal GetCanteenCredit(Guid userId);
        //void TransferCanteenCredit(CreditUserApiInputModel creditUserApiInputModel, LoggedInContext loggedInContext);
        //IList<CanteenPurchasedItems> SearchPurchasedItems(CanteenPurchasesSearchCriteriaInputModel canteenPurchasesSearchCriteriaInputModel,LoggedInContext loggedInContext);
        //IList<CanteenCreditModel> SearchOffers(CanteenCreditSearchCriteriaInputModel canteenCreditSearchCriteriaInputModel,LoggedInContext loggedInContext);
        //IList<CanteenBalanceModel> GetCanteenBalanceDetails(LoggedInContext loggedInContext);
        //IList<CanteenFoodItemDbEntity> SearchFoodItems(string searchString);
        //IList<CanteenUserDetailModel> GetUserCanteenDetail(Guid userId, LoggedInContext loggedInContext);
        //bool CheckIfItemNameAlreadyExists(string itemName);
    }
}