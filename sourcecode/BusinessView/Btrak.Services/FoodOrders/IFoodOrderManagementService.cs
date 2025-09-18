using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.FoodOrders;
using BTrak.Common;

namespace Btrak.Services.FoodOrders
{
    public interface IFoodOrderManagementService
    {
        Guid? UpsertFoodOrder(FoodOrderManagementInputModel foodOrderManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FoodOrderManagementApiReturnModel> SearchFoodOrders(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FoodOrderManagementApiReturnModel GetFoodOrderById(Guid? foodOrderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FoodOrderManagementSpReturnModel> GetMonthlyFoodOrderReport(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ChangeFoodOrderStatus(ChangeFoodOrderStatusInputModel changeFoodOrderStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
